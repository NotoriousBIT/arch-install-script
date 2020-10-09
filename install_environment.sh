#!/bin/bash
pacman -S --noconfirm ansible

curl https://github.com/NotoriousBIT/arch-install-script/blob/master/playbook.yml -L -o /tmp/arch-install/script/playbook.yml

ansible-playbook --ask-become-pass /tmp/arch-install/script/playbook.yml