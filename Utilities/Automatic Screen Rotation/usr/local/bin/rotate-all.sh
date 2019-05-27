#!/bin/bash

export DISPLAY=':0.0'
export XAUTHORITY="/home/morro/.Xauthority"

if [[ $# -ne 1 ]]
then
	echo "You need to specify which way to rotate."
	echo "EX: none, half (180 degrees), wc, ccw"
	exit 1
fi

DEFAULTCTM="1 0 0 0 1 0 0 0 1"	#default Coordinate Transformation Matrix
leftr="0 -1 1 1 0 0 0 0 1"
rightr="0 1 0 -1 0 1 0 0 1"
upsider="-1 0 1 0 -1 1 0 0 1"

CTM=$DEFAULTCTM
rotation=$1

if [[ $rotation == "ccw" ]]
then
	CTM=$leftr
	xrandr_action="left"
elif [[ $rotation == "cw" ]]
then
	CTM=$rightr
	xrandr_action="right"
elif [[ $rotation == "none" ]]
then
	CTM=$DEFAULTCTM
	xrandr_action="normal"
elif [[ $rotation == "half" ]]
then
	CTM=$upsider
	xrandr_action="inverted"
fi

xrandr --output eDP1 --rotate $xrandr_action
for i in {1..2}
do
	xinput set-prop "Wacom Pen and multitouch sensor Finger" "Coordinate Transformation Matrix" $CTM
	xinput set-prop $(xinput |grep "Wacom Pen and multitouch sensor Pen"|cut -d'=' -f2|cut -f 1) "Coordinate Transformation Matrix" $CTM
	xinput set-prop $(xinput |grep "Wacom Pen and multitouch sensor Pen Pen"|cut -d'=' -f2|cut -f 1) "Coordinate Transformation Matrix" $CTM
	sleep 2
done
