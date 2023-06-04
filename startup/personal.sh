#!/bin/bash

# wallpaper

# array with all the different wallpaper names
wallpapers=("rick_7680x4320_xtrafondos.com.jpg" "megumi4k.jpg")

# seed random gen
RANDOM=$$$(date +%s)

selectedwpp=${wallpapers[ $RANDOM % ${#wallpapers[@]} ]}

gsettings set org.gnome.desktop.background picture-uri-dark file:///home/m1tus/Pictures/Wallpapers/$selectedwpp
