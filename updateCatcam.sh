#!/usr/bin/env bash

# author:	Marcel Petrick (mail@marcelpetrick.it)

mv /home/pi/Desktop/webcam/regulargif.sh /home/pi/Desktop/webcam/regulargif.sh1 
sudo rpi-update 
sudo apt-fast update && sudo apt-fast dist-upgrade -y
sudo apt-get autoclean
sudo apt-get autoremove
mv /home/pi/Desktop/webcam/regulargif.sh1 /home/pi/Desktop/webcam/regulargif.sh
sudo reboot

