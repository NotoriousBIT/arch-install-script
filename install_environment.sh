#!/bin/bash

###########################
# GIT
###########################
pacman -S --noconfirm git
mkdir git
chown --recursive $SUDO_USER: git

###########################
# YAY
###########################
pacman -S --noconfirm git go
rm -rf yay
git clone https://aur.archlinux.org/yay.git
chown $SUDO_USER: yay
(cd yay && su $SUDO_USER -c "makepkg -s")
(cd yay && pacman -U --noconfirm *.pkg.tar.*)
rm -rf yay

###########################
# FONTS
###########################
pacman -S --noconfirm ttf-opensans ttf-ubuntu-font-family awesome-terminal-fonts powerline-fonts

###########################
# XORG
###########################
pacman -S --noconfirm xorg xorg-drivers xorg-xinit

###########################
# KEYBOARD LAYOUT DE
###########################
echo 'Section "InputClass"' > /etc/X11/xorg.conf.d/20-keyboard.conf
echo '       Identifier "keyboard"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo '       MatchIsKeyboard "yes"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo '       Option "XkbLayout" "de"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo '       Option "XkbVariant" "nodeadkeys"' >> /etc/X11/xorg.conf.d/20-keyboard.conf
echo 'EndSection' >> /etc/X11/xorg.conf.d/20-keyboard.conf

###########################
# LIGHTDM GREETER
###########################
pacman -S --noconfirm lightdm lightdm-webkit2-greeter light-locker

wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/helper/lightdm/lightdm.conf -O /etc/lightdm/lightdm.conf
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/helper/lightdm/lightdm-webkit2-greeter.conf -O /etc/lightdm/lightdm-webkit2-greeter.conf

# AETHER THEME
pacman -S --noconfirm git ttf-opensans
rm -rf lightdm-webkit-theme-aether
git clone https://aur.archlinux.org/lightdm-webkit-theme-aether.git
chown $SUDO_USER: lightdm-webkit-theme-aether
(cd lightdm-webkit-theme-aether && su $SUDO_USER -c "makepkg -s")
(cd lightdm-webkit-theme-aether && pacman -U --noconfirm *.pkg.tar.*)
rm -rf lightdm-webkit-theme-aether

systemctl enable lightdm

###########################
# QTILE
###########################
pacman -S --noconfirm qtile xorg-server-xephyr xorg-xrandr xorg-xcalc xorg-xeyes xorg-xclock python-psutil python-xdg

mkdir -p /home/$SUDO_USER/.config/qtile
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.config/qtile/config.py -O /home/$SUDO_USER/.config/qtile/config.py
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.config/qtile/autostart.sh -O /home/$SUDO_USER/.config/qtile/autostart.sh
chmod +x /home/$SUDO_USER/.config/qtile/autostart.sh

chown --recursive $SUDO_USER: .config

###########################
# TERMITE
###########################
pacman -S --noconfirm termite

mkdir -p /home/$SUDO_USER/.config/termite
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.config/termite/config -O /home/$SUDO_USER/.config/termite/config

chown --recursive $SUDO_USER: .config

###########################
# ZSH
###########################
pacman -S --noconfirm zsh ttf-ubuntu-font-family

wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.zshrc -O /home/$SUDO_USER/.zshrc
chown --recursive $SUDO_USER: .zshrc

# POWERLEVEL10K
(cd git && git clone https://github.com/romkatv/powerlevel10k.git)
chown --recursive $SUDO_USER: .git

wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.p10k.zsh -O /home/$SUDO_USER/.p10k.zsh
chown --recursive $SUDO_USER: .p10k.zsh

chsh -s $(which zsh) $SUDO_USER

###########################
# NITROGEN
###########################
pacman -S --noconfirm nitrogen

git clone https://github.com/NotoriousBIT/arch-install-script.git
mv ./arch-install-script/wallpaper ./wallpaper
chown --recursive $SUDO_USER: wallpaper
rm -rf arch-install-script

mkdir -p /home/$SUDO_USER/.config/nitrogen
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.config/nitrogen/bg-saved.cfg -O /home/$SUDO_USER/.config/nitrogen/bg-saved.cfg
chown --recursive $SUDO_USER: .config

###########################
# COMPTON
###########################
pacman -S --noconfirm picom # compton

mkdir -p /home/$SUDO_USER/.config/picom
wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.config/picom/picom.conf -O /home/$SUDO_USER/.config/picom/picom.conf
chown --recursive $SUDO_USER: .config

###########################
# EXA - ls replacement
###########################
pacman -S --noconfirm exa

###########################
# VIM
###########################
git clone https://github.com/VundleVim/Vundle.vim.git /home/$SUDO_USER/.vim/bundle/Vundle.vim
chown --recursive $SUDO_USER: .vim

wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.vimrc -O /home/$SUDO_USER/.vimrc
chown --recursive $SUDO_USER: .vimrc

(su $SUDO_USER && vim -c 'PluginInstall' -c 'qa!')

###########################
# VIFM
###########################
pacman -S --noconfirm vifm

wget -N https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/configs/.Xresources -O /home/$SUDO_USER/.Xresources
chown --recursive $SUDO_USER: .Xresources

