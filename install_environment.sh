#!/bin/bash
pacman -S --noconfirm ansible

mkdir -R /tmp/arch-install-script

curl https://github.com/NotoriousBIT/arch-install-script/blob/master/playbook.yml -L -o /tmp/arch-install-script/playbook.yml

ansible-playbook --ask-become-pass /tmp/arch-install-script/playbook.yml