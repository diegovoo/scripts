#!/bin/bash

# Start the necessary applications for work

# Launch notion
nohup sh -c 'XAPP_FORCE_GTKWINDOW_ICON="/home/m1tus/.local/share/ice/icons/Notion.png" firefox --class WebApp-Notion8108 --profile /home/m1tus/.local/share/ice/firefox/Notion8108 --no-remote "https://www.notion.so/Ing-Inform-tica-ecd3de8958444c1485dec7f56865715b"' > /tmp/nohup.out &

# firefox with moodle if not open
nohup firefox > /tmp/nohup.out &

# caffeine extension on so screen doesnt shut off

# wallpaper with motivational phrases
# array with all the different wallpaper names
wallpapers=("mvwpp1.jpg" "mvwpp2.jpg" "mvwpp3.jpg" "mvwpp4.jpg")

# seed random gen
RANDOM=$$$(date +%s)

selectedwpp=${wallpapers[ $RANDOM % ${#wallpapers[@]} ]}

gsettings set org.gnome.desktop.background picture-uri-dark file:///home/m1tus/Pictures/wpp/work/$selectedwpp
