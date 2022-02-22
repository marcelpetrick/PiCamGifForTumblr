#!/usr/bin/env bash

# author:	mail@marcelpetrick.it


mv /home/pi/Desktop/catcam/PiCamGifForTumblr.sh /home/pi/Desktop/catcam/PiCamGifForTumblr.sh1
sudo rpi-update 
sudo apt-fast update && sudo apt-fast dist-upgrade -y
sudo apt-get autoclean
sudo apt-get autoremove
mv /home/pi/Desktop/catcam/PiCamGifForTumblr.sh1 /home/pi/Desktop/catcam/PiCamGifForTumblr.sh
sudo reboot
