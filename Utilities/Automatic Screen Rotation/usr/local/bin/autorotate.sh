#!/bin/bash

rotate="/usr/local/bin/rotate-all.sh"
current="none"
lastr="none"

accelx=$(find /sys/devices/ -iname "*in_accel_x_raw*")
accely=$(find /sys/devices/ -iname "*in_accel_y_raw*")

while true; do

	sleep 1
	
	commandx=$(cat $accelx)
	commandy=$(cat $accely)
	# echo $commandx ":" $commandy
	
	if [[ $commandx -gt -900000 ]] && [[ $commandx -lt -100000 ]]
	then
		current="cw"
	elif [[ $commandx -gt 100000 ]] && [[ $commandx -lt 900000 ]]
	then
		current="ccw"
	elif [[ $commandy -gt 200000 ]] && [[ $commandy -lt 800000 ]]
	then
		current="half"
	elif [[ $commandy -gt -900000 ]] && [[ $commandy -lt -400000 ]]
	then
		current="none"
	fi
	
	if [[ $lastr != $current ]]
	then 
		echo "auto-rotating $current"
		$rotate $current
		# workaround for touch rotation being unresponsive
		$rotate $current
		lastr=$current
	fi

done
