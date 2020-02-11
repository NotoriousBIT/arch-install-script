#!/bin/sh
read -p "Specify the username: " username
useradd -m -g users -s /bin/bash $username

passwd $username

pacman -S --noconfirm sudo

sed "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers > /etc/sudores

gpasswd -a $username wheel
gpasswd -a $username audio
gpasswd -a $username video
gpasswd -a $username games
gpasswd -a $username power