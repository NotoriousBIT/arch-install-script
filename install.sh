#!/bin/sh
echo "# Setting keyboard layout"
loadkeys de-latin1

echo "# Setting system time"
timedatectl set-ntp true

while true; do
  read -p "Do you wish to create any partitions? [Y/n] " yn
  case $yn in
          [Yy][eE][sS]|[yY] ) cfdisk; break;;
          [Nn][Oo]|[nN] ) break;;
          * ) echo "Please answer yes or no.";;
  esac
done

echo ""
echo "# lsblk"
echo "+ lsblk -o name,mountpoint,label,size,uuid"
echo ""
lsblk -o name,mountpoint,label,size,uuid

echo ""
echo "# Partitioning"
echo "#"
echo "# Examples:"
echo "# mkfs.ext4 -L arch /dev/sda1"
echo ""

while true; do
  read -p "Run command or quit with ':q': " cmd
  case $cmd in
          [:][q] ) break;;
          * ) $cmd;;
  esac
done

read -p "Specify the name of the root partition! " partition
mount /dev/$partition /mnt
echo "# /dev/$partition mounted at /mnt"
# todo mounting of /var /home /boot ...

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
read input

umount /mnt

while true; do
  read -p "Do you wish to reboot? [Y/n] " yn
  case $yn in
          [Yy][eE][sS]|[yY] ) reboot; break;;
          [Nn][Oo]|[nN] ) break;;
          * ) echo "Please answer yes or no.";;
  esac
done