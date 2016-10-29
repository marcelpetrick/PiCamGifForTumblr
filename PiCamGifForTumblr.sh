#!/usr/bin/env bash

# author:	Marcel Petrick (mail@marcelpetrick.it)
#
# about:        Shoot photos, create a GIF and upload to tumblr.
#
# license:	GNU General Public License v2.0
# version:	0.0
# date:		20161012
#
# history:
#			0.0 initial version


VERSION=0.0

if [ "$#" -eq  "0" ]; then
     echo "No arguments supplied"
# +++++++++++++++++++
# +++ the program +++
# +++++++++++++++++++
	# shoot 18 (best value, fits most of the time) 500pix-wide photos and save them in a hardcoded directory (since it's run as cronjob)
	echo "shoot now"
	for (( i = 0; i < 18; i++ )); do
		raspistill -h 375 -w 500 -a 1036 -o /home/pi/Desktop/webcam/tempgifs/cam${i}.jpg
	done

	# convert the photos: necessary, because if saved immediately as GIF, then posterization appears (trust me ..)
	echo "convert now"
	for (( i = 0; i < 18; i++ )); do
		mogrify -format gif /home/pi/Desktop/webcam/tempgifs/cam${i}.jpg
		rm /home/pi/Desktop/webcam/tempgifs/cam${i}.jpg
	done

	# convert the single frames to an animated GIF and move it
	echo "gif now"
	gifsicle --delay=10 -O3 --loop /home/pi/Desktop/webcam/tempgifs/cam*.gif > /home/pi/Desktop/webcam/tempgifs/upload.gif
	mv /home/pi/Desktop/webcam/tempgifs/upload.gif /home/pi/Desktop/webcam/upload.gif

	# upload via the pre-configured pytumble-python-script
	echo "upload now"
	python /home/pi/Desktop/webcam/pytumble.py
else
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++ just some totally unnecessary helper-functions +++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	if [ $1 == "-version" ]; then
		echo "running version $VERSION"
		exit 1
	fi

	if [ $1 == "-help" ]; then
		echo "Just call the script and everything will be done (including baking a cake)!"
		echo ""
		echo "Available parameters are -version and -help. They are NOT combineable!"
		exit 1
	fi
 fi

