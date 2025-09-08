#!/bin/bash

CURR_TIME="$(date '+%d-%m-%Y %H:%M:%S')"
LOG_STRING="[$CURR_TIME] | $(hostname) | $(whoami) | CMD($(basename "$0")) | STATUS="
STATUS=0

function notify_user() {
    local message="$1"
    local body="$2"

    local user="m1tus"
    local uid=$(id -u $user)
    local dbus_address="unix:path=/run/user/$uid/bus"

    sudo -u $user DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=$dbus_address notify-send "$message" "$body"
}

cd ~/OneDrive/vimwiki/

git add .
STATUS=$?

if [ "$STATUS" -ne 0 ]; then
    echo "git add failed with status = $STATUS"
    echo "$LOG_STRING$STATUS" >> ~/.log/vimwiki-to-git.log
    notify_user "git add failed; check vimwiki-to-git.sh" "STATUS=$STATUS"
fi

if git diff --cached --quiet; then
    echo "No changes to commit. Exiting."
    echo "$LOG_STRING$STATUS" >> ~/.log/vimwiki-to-git.log
    exit 0
fi

git commit -m "$LOG_STRING"
git push origin main

echo "$LOG_STRING" >> ~/.log/vimwiki-to-git.log
