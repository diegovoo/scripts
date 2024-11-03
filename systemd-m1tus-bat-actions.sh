#!/bin/bash

function notify_user() {
    local message="$1"
    local body="$2"

    # Specify the user explicitly
    local user="m1tus"

    # Get the user's UID
    local uid=$(id -u $user)

    # Construct the DBUS_SESSION_BUS_ADDRESS
    local dbus_address="unix:path=/run/user/$uid/bus"

    # Send the notification
    sudo -u $user DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=$dbus_address notify-send "$message" "$body"
}

function disable_caffeine() {
    local user="m1tus"
    local uid=$(id -u $user)
    local dbus_address="unix:path=/run/user/$uid/bus"
    sudo -u $user DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=$dbus_address gnome-extensions disable caffeine@patapon.info
    sudo -u $user DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=$dbus_address gnome-extensions enable caffeine@patapon.info
}

battery_percent=$(upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}' | tr -d '%')
last_status_file="/tmp/last_battery_status"

if [ -f "$last_status_file" ]; then
    last_status=$(cat "$last_status_file")
else
    touch "$last_status_file"
    last_status=0
fi

if [ "$battery_percent" -le 40 ] && [ "$last_status" -gt 40 ]; then
    last_status=40
    notify_user "[Battery at 40%]" "Charge when possible"
elif [ "$battery_percent" -le 20 ] && [ "$last_status" -gt 20 ]; then
    last_status=20
    disable_caffeine
    notify_user "[Low Battery]" "Caffeine turned off"
elif [ "$battery_percent" -eq 80 ] && [ "$last_status" -lt 80 ]; then
    last_status=80
    notify_user "[Battery at 80%]" "Disconnect from power"
fi

echo "$last_status" > "$last_status_file"
