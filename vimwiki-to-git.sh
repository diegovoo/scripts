#!/bin/bash

CURR_TIME="$(date '+%d-%m-%Y %H:%M:%S')"
LOG_STRING="$CURR_TIME $(hostname): $(whoami) CMD($(basename "$0"))"

cd ~/OneDrive/vimwiki/

git add .

if git diff --cached --quiet; then
    echo "No changes to commit. Exiting."
    exit 0
fi

git commit -m "$LOG_STRING"
git push origin main

echo "$LOG_STRING" >> ~/.log/vimwiki-to-git.log
