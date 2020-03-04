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
# 1 500MB Boot
# 2 100% main
wipefs -af $install_device
(echo o; echo w) | fdisk $install_device
(echo d; echo n; echo p; echo 1; echo ""; echo "+500M"; echo a; echo n; echo p; echo 2; echo ""; echo ""; echo w) | fdisk $install_device 

mkfs.ext2 $install_device"1"

# Setup the encryption of the system
cryptsetup -c aes-xts-plain64 -y --use-random luksFormat $install_device"2"
cryptsetup luksOpen $install_device"2" luks

# Create encrypted partitions
# This creates one partions for root, modify if /home or other partitions should be on separate partitions
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate --size 8G vg0 --name swap
lvcreate -l +100%FREE vg0 --name root

# Create filesystems on encrypted partitions
mkfs.ext4 /dev/mapper/vg0-root
mkswap /dev/mapper/vg0-swap
