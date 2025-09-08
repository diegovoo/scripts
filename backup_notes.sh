#!/bin/bash

set -a
source ~/.telegram_env
set +a

NOTES_BACKUP_FILE="/home/m1tus/.log/notes_backup.txt"

if rsync -a --delete ~/Notes/ ~/OneDrive/Notes_Backup/; then
    echo "[OK]: $(date)" >> $NOTES_BACKUP_FILE
else
    echo "[KO]: $(date)" >> $NOTES_BACKUP_FILE
    MESSAGE="[KO] Notes backup failed on $(hostname) at: $(date)"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
         -d chat_id="$CHAT_ID" \
         -d text="$MESSAGE"
fi

