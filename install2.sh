#!/bin/sh
echo "# Setting keyboard layout"
loadkeys de-latin1

echo "# Setting system time"
timedatectl set-ntp true

echo "# lsblk"
lsblk

while true; do
  read -p "Specify the name of the device to install to (i.e. /dev/sda) " install_device
  read -p "You selcted \"$install_device\", is this correct? [Y/n] " yn
  case $yn in
          [Yy][eE][sS]|[yY] ) break;;
          [Nn][Oo]|[nN] ) ;;
          * ) echo "Please answer yes or no.";;
  esac
done

# Create partitions
# 1 500MB EFI
# 2 500MB Boot
# 3 100% main

# Get the corrosponding numbers of fdisk partition types
EFI_SYSTEM_NUMBER=$(echo "l" | fdisk $install_device | grep -oP "[0-9]+(?= EFI System )")
LINUX_FILESYSTEM_NUMBER=$(echo "l" | fdisk $install_device | grep -oP "[0-9]+(?= Linux filesystem )")
LINUX_LVM_NUMBER=$(echo "l" | fdisk $install_device | grep -oP "[0-9]+(?= Linux LVM)")

# Wipe the disk
wipefs -af $install_device

(echo g; echo w) | fdisk $install_device

# Create partition 1
(echo n; echo 1; echo ""; echo "+500M"; echo w) | fdisk $install_device 
(echo t; echo $EFI_SYSTEM_NUMBER; echo w) | fdisk $install_device 

# Create partition 2
(echo n; echo 2; echo ""; echo "+500M"; echo w) | fdisk $install_device 
(echo t; echo 2; echo $LINUX_FILESYSTEM_NUMBER; echo w) | fdisk $install_device 

# Create partition 3
(echo n; echo 3; echo ""; echo ""; echo w) | fdisk $install_device 
(echo t; echo 3; echo $LINUX_LVM_NUMBER; echo w) | fdisk $install_device 

# Get partition names
PARTITION_EFI=$(fdisk -l $install_device | grep "500M EFI System" | grep -oP "^[a-z0-9\/]+")
echo "EFI partition is @ $PARTITION_EFI"

PARTITION_BOOT=$(fdisk -l $install_device | grep "500M Linux filesystem" | grep -oP "^[a-z0-9\/]+")
echo "Boot partition is @ $PARTITION_BOOT"

PARTITION_LVM=$(fdisk -l $install_device | grep "Linux LVM" | grep -oP "^[a-z0-9\/]+")
echo "LVM partition is @ $PARTITION_LVM"

# Format the EFI partition
mkfs.fat -n EFI -F32 $PARTITION_EFI

# Format the boot partition
mkfs.ext4 -L BOOT $PARTITION_BOOT

# Set up encryption
cryptsetup luksFormat $PARTITION_LVM
cryptsetup open --type luks $PARTITION_LVM lvm

pvcreate --dataalignment 1m /dev/mapper/lvm
vgcreate vg0 /dev/mapper/lvm

lvcreate -L 30GB vg0 -n lv_root
lvcreate -l 100%FREE vg0 -n lv_home

mkfs.ext4 -L root /dev/vg0/lv_root
mount /dev/vg0/lv_root /mnt

mkdir /mnt/home
mkfs.ext4 -L home /dev/vg0/lv_home

mkdir /mnt/boot
mount $PARTITION_BOOT /mnt/boot

mkdir /mnt/etc
genfstab -U -p /mnt >> /mnt/etc/fstab


while true; do
  cat /mnt/etc/fstab
  read -p "Are all the partition looking correct? [Y/n] " yn
  case $yn in
          [Yy][eE][sS]|[yY] ) break;;
          [Nn][Oo]|[nN] ) exit;;
          * ) echo "Please answer yes or no.";;
  esac
done


echo ""
echo "# Setting mirroslist"
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/helper/mirrorlist -O /etc/pacman.d/mirrorlist

echo ""
echo " Installing packages"
pacstrap /mnt base base-devel linux linux-firmware dhcpcd networkmanager wget vim xterm rsync

echo ""
echo " fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo ""
echo " chroot"
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/install_chroot.sh -O /mnt/install_chroot.sh
arch-chroot /mnt sh install_chroot.sh

umount -R /mnt
swapoff -a

while true; do
  read -p "Do you wish to reboot? [Y/n] " yn
  case $yn in
          [Yy][eE][sS]|[yY] ) reboot; break;;
          [Nn][Oo]|[nN] ) break;;
          * ) echo "Please answer yes or no.";;
  esac
done
