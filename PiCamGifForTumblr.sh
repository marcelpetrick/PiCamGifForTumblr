#!/usr/bin/env bash

# author:	Marcel Petrick (mail@marcelpetrick.it)
#
# about:        Shoot photos, create a GIF and upload to tumblr.
#
# license:	GNU General Public License v2.0
# version:	0.3
# date:		20180313
#
# history:
#			0.3 fixed some mistakes in the script
#			0.2 logging-support; minor code-improvement; now 30 frames possible at maximum - because the new upper filesize-limit is 3 MiByte
#			0.1 added support to use as much frames a possible while keeping the GIF-size inside the tumblr-animation-limit (max 25 frames)
#			0.0 initial version

VERSION=0.3

if [ "$#" -eq  "0" ]; then
# +++++++++++++++++++
# +++ the program +++
# +++++++++++++++++++
	cd "${0%/*}" #go to the current directory of the script

	FRAMES=30 # maximum amount of frames
	OUTFILE="PiCam.log"
	TEXT=`date`

	# shoot some 500pix-wide photos and save them in a hardcoded directory (since it's run as cronjob)
	echo "shoot now $FRAMES photos"
	for (( i = 0; i < $FRAMES; i++ )); do
		raspistill -h 375 -w 500 -a 1036 -o tempgifs/cam${i}.jpg
	done

	# convert the photos: necessary, because if saved immediately as GIF, then posterization appears (trust me ..)
	echo "convert now $FRAMES JPG to GIF"
	for (( i = 0; i < $FRAMES; i++ )); do
		mogrify -format gif tempgifs/cam${i}.jpg
		rm tempgifs/cam${i}.jpg
	done

	RESULTFILE="upload.gif"
	MAXSIZE=3100000 # less than three 3 * 1024 * 1024 byte
	
while true; do
	#create the list of all input files
	INPUTLIST=""
	for (( i = 0; i < $FRAMES; i++ )); do
		INPUTLIST="$INPUTLIST tempgifs/cam$i.gif"
	done
	#echo "result list: $INPUTLIST"

	# convert the single frames to an animated GIF
	echo "gif now using $FRAMES frames"
	gifsicle --delay=10 -O3 --loop $INPUTLIST > "$RESULTFILE"
	#echo "$RESULTFILE"

	#check the size of the GIF
	if (( `stat -c%s "$RESULTFILE"` < $MAXSIZE )); then
		echo "success: smaller than two mibyte with $FRAMES frames"
		TEXT="$TEXT success $FRAMES frames"
		break
	else
		echo "fail: bigger than two mibyte! -> next run with less frames (now $FRAMES)"
		FRAMES=$((FRAMES-1)) # decrease by one .. ugly in bash
		if (( "$FRAMES" <  0 )); then
			echo "break because smaller zero"
			TEXT="$TEXT fail"
		fi
	fi
done #end of the loop: is exited via break

	#logging
	echo "$TEXT" >> "$OUTFILE"

	# upload via the pre-configured pytumble-python-script
	echo "upload now"
	python pytumble.py

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
