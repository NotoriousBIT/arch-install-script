#!/bin/sh 
picom &
nitrogen --restore &
light-locker &
urxvtd -q -o -f &
