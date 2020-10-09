#!/bin/bash
pacman -S --noconfirm ansible

mkdir -p /tmp/arch-install-script

curl https://raw.githubusercontent.com/NotoriousBIT/arch-install-script/master/playbook.yml -L -o /tmp/arch-install-script/playbook.yml

ansible-playbook --ask-become-pass /tmp/arch-install-script/playbook.yml