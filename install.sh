#!/bin/sh
echo "# Setting keyboard layout"
loadkeys de-latin1

echo "# Setting system time"
timedatectl set-ntp true

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

# Wipe the disk
wipefs -af $install_device

# Create partitions
sfdisk $install_device << EOF
,500MB,EF
,500MB,83
,,8E
EOF

# Format the EFI partition
mkfs.fat -n EFI -F32 "${install_device}p1"

# Format the boot partition
mkfs.ext4 -F -L BOOT "${install_device}p2"

# Set up encryption
cryptsetup luksFormat "${install_device}p3"
cryptsetup open --type luks "${install_device}p3" lvm

pvcreate --dataalignment 1m /dev/mapper/lvm
vgcreate vg0 /dev/mapper/lvm

lvcreate -L 100GB vg0 -n lv_home
lvcreate -l 100%FREE vg0 -n lv_root

mkfs.ext4 -L root /dev/vg0/lv_root
mount /dev/vg0/lv_root /mnt

mkfs.ext4 -L home /dev/vg0/lv_home
mkdir /mnt/home
mount /dev/vg0/lv_home /mnt/home

mkdir /mnt/boot
mount "${install_device}p2" /mnt/boot

mkdir /mnt/etc
genfstab -U -p /mnt >> /mnt/etc/fstab

mkdir /mnt/boot/efi
mount "${install_device}p1" /mnt/boot/efi

echo ""
echo "# Setting mirroslist"
curl -L -d "country=DE&protocol=http&protocol=https&ip_version=4" -X POST https://www.archlinux.org/mirrorlist/ -o /etc/pacman.d/mirrorlist
sed -i 's/^.//g' /etc/pacman.d/mirrorlist  

echo ""
echo " Installing packages"
pacstrap /mnt base base-devel linux-lts linux-firmware linux-lts-headers

# 'install' fstab
genfstab -pU /mnt >> /mnt/etc/fstab

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
echo " chroot"
curl -L https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/install_chroot.sh -o /mnt/install_chroot.sh
arch-chroot /mnt sh install_chroot.sh

umount -a

while true; do
  read -p "Do you wish to reboot? [Y/n] " yn
  case $yn in
          [Yy][eE][sS]|[yY] ) reboot; break;;
          [Nn][Oo]|[nN] ) break;;
          * ) echo "Please answer yes or no.";;
  esac
done
