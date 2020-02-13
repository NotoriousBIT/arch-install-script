#!/bin/bash
pacman -S --noconfirm xorg xorg-drivers xorg-xinit

echo 'Section "InputClass"' > /etc/X11/xorg.conf.d/20-keyboard.conf
echo '       Identifier "keyboard"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo '        MatchIsKeyboard "yes"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo '        Option "XkbLayout" "de"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo '        Option "XkbVariant" "nodeadkeys"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo 'EndSection' >> /etc/X11/xorg.conf.d/20-keyboard.conf

pacman -S --noconfirm lightdm lightdm-webkit2-greeter

sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
systemctl enable lightdm

pacman -S --noconfirm git go
rm -rf yay
git clone https://aur.archlinux.org/yay.git
chown $SUDO_USER: yay
(cd yay && su $SUDO_USER -c "makepkg -s")
(cd yay && pacman -U --noconfirm *.pkg.tar.*)
rm -rf yay

pacman -S --noconfirm ttf-opensans
rm -rf lightdm-webkit-theme-aether
git clone https://aur.archlinux.org/lightdm-webkit-theme-aether.git
chown $SUDO_USER: lightdm-webkit-theme-aether
(cd lightdm-webkit-theme-aether && su $SUDO_USER -c "makepkg -s")
(cd lightdm-webkit-theme-aether && pacman -U --noconfirm *.pkg.tar.*)
rm -rf lightdm-webkit-theme-aether

pacman -S --noconfirm qtile
sed -i "s/#user-session=default/user-session=qtile/g" /etc/lightdm/lightdm.conf
mkdir -p /home/$SUDO_USER/.config/qtile
cp -f /usr/share/doc/qtile/default_config.py /home/$SUDO_USER/.config/qtile/config.py
# add autostart stuff
# chmod +x for script

pacman -S --noconfirm termite zsh ttf-ubuntu-font-family
chsh -s $(which zsh) $SUDO_USER
sed -i "s/xterm/termite/g" /home/$SUDO_USER/.config/qtile/config.py

mkdir -p /home/$SUDO_USER/.config/termite

pacman -S --noconfirm nitrogen

pacman -S --noconfirm picom # compton
# COPY CONFIG