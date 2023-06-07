#!/bin/bash

# Prompt for the desired option
echo "Select an option:"
echo "1. Work"
echo "2. Personal"
read -n 1 -p "Enter the option number: " option

# Execute the corresponding startup script based on the selected option
case $option in
    1)
        /home/m1tus/scripts/startup/work.sh &
	# sleep is already set inside the work script
        ;;
    2)
	sleep 1
        /home/m1tus/scripts/startup/personal.sh &
        ;;
    *)
	gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/m1tus/Pictures/Wallpapers/megumi4k.jpg'
	sleep 1
        ;;
esac

# Close terminal AFTER all is done
sleep 1
