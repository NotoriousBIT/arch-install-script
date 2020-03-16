#!/bin/sh
echo ""
read -p "Specify the hostname: " hostname
echo $hostname > /etc/hostname
echo "127.0.0.1	localhost" > /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.0.1	$hostname.localdomain $hostname" >> /etc/hosts

pacman -S --noconfirm networkmanager dhcpcd wpa_supplicant wireless_tools netctl wget vim xterm rsync lvm2

echo ""
echo " enable dhcpcd"
systemctl enable dhcpcd

echo ""
echo " enable networkmanager"
systemctl enable NetworkManager

echo ""
echo " setting locale.conf"
echo LANG=de_DE.UTF-8 > /etc/locale.conf

echo ""
echo " setting locale.gen"
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/helper/locale.gen -O /etc/locale.gen
locale-gen

echo ""
echo " setting vconsole.conf"
echo KEYMAP=de-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf

echo ""
echo " setting localtime"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

echo ""
echo " setting root password:"
passwd

pacman -S --noconfirm lvm2
sed -i "s|HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)|HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)|" /etc/mkinitcpio.conf 

mkinitcpio -p linux

echo ""
echo " installing grub"
pacman -S --noconfirm grub efibootmgr dosfstools os-prober mtools

sed -i "s|#GRUB_ENABLE_CRYPTODISK=y|GRUB_ENABLE_CRYPTODISK=y|" /etc/default/grub

LUKS_PARTITION=$(blkid | grep "LUKS" | cut -d ':' -f1)
sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 cryptdevice=$LUKS_PARTITION:vg0:allow-discards quiet\"|" /etc/default/grub

mkdir /boot/EFI
