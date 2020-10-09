# How to install my Arch-Linux

**Included scripts:**
- install.sh https://bit.ly/2SCnxty
- install_environment.sh https://bit.ly/2P4Mg7D
- create_wheel_user.sh https://bit.ly/2SCApzR

## Step 1: Download the latest image
https://www.archlinux.org/download/

## Step 2: Copy the image to a USB Stick
`$ dd if=/path/to/*.iso of=/dev/XXX bs=64k status=progress`

## Step 3: Boot into the live environment
For changing the keyboad layout to germen type in<br>
`$ loadkeys de-latin1`

>**INFO**
[-] = [?] on english keyboard

## Step 4: Download and run the first install script
`$ curl https://bit.ly/2SCnxty -L -o install.sh` <br>
`$ sh install.sh`

>**NOTE**
Follow the instructions

## Step 5: Download and run the script for creating a sudo user
`$ curl https://bit.ly/2SCApzR -L -o create_wheel_user.sh` <br>
`$ sh create_wheel_user.sh`

>**NOTE**
Follow the instructions

## Step 6: Download the last script and run it to install the environment
`$ curl https://bit.ly/2P4Mg7D -L -o install_environment.sh` <br>
`$ sh install_environment.sh`

# Thanks to:
 - https://gist.github.com/mattiaslundberg/8620837
