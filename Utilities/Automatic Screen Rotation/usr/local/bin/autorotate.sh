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
	
	if [[ $commandx -gt -800000 ]] && [[ $commandx -lt -200000 ]]
	then
		current="cw"
	elif [[ $commandx -gt 200000 ]] && [[ $commandx -lt 800000 ]]
	then
		current="ccw"
	elif [[ $commandy -gt 25000 ]] && [[ $commandy -lt 80000 ]]
	then
		current="half"
	elif [[ $commandy -gt -80000 ]] && [[ $commandy -lt -25000 ]]
	then
		current="none"
	fi
	
	if [[ $lastr != $current ]]
	then 
		echo "auto-rotating $current"
		$rotate $current
		$rotate $current
		lastr=$current
	fi

done
