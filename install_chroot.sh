#!/bin/sh
echo ""
read -p "Specify the hostname: " hostname
echo $hostname > /etc/hostname
echo "127.0.0.1	localhost" > /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.0.1	$hostname.localdomain $hostname" >> /etc/hosts

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

echo ""
echo " installing grub"
pacman -S --noconfirm grub
LUKS_PARTITION=$(blkid | grep "LUKS" | cut -d ':' -f1)
sed -i "s|GRUB_CMDLINE_LINUX=\"\"|GRUB_CMDLINE_LINUX=\"$LUKS_PARTITION\"|" /mnt/etc/default/grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
