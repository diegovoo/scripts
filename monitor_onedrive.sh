#!/bin/bash

set -a
source ~/.telegram_env
set +a
set -euo pipefail

COOLDOWN_SECONDS=300

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

send_telegram() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message" > /dev/null
}

cleanup() {
    log "Monitor service stopping"
    jobs -p | xargs -r kill 2>/dev/null || true
}

trap cleanup EXIT TERM INT

log "OneDrive monitor service started"

while true; do
    log "Starting monitoring loop..."
    
    journalctl --user-unit=onedrive -f --since=now --no-pager | \
    grep -E "(Main process exited, code=exited, status=|ERROR: You will need to issue a --reauth|Conflict)" --line-buffered | \
    while IFS= read -r line; do
        if [[ "$line" == *"Main process exited, code=exited, status="* ]]; then
            log "Detected OneDrive service exit"
            send_telegram "[KO] OneDrive sync failed $(hostname) at: $(date) [caught with systemd monitor]"
            exit 0
            
        elif [[ "$line" == *"ERROR: You will need to issue a --reauth"* ]]; then
            log "Detected OneDrive reauth error"
            send_telegram "[KO] OneDrive REAUTH ERROR - $(hostname) at: $(date) [caught with systemd monitor]"
            exit 0

        elif [[ "$line" == *"Conflict"* ]]; then
            log "Conflict with file error"
            send_telegram "[KO] OneDrive conflict ERROR - $(hostname) at: $(date) [caught with systemd monitor]"
            exit 0
        fi
    done
    
    log "Error detected. Entering cooldown period for ${COOLDOWN_SECONDS} seconds..."
    sleep "$COOLDOWN_SECONDS"
    log "Cooldown period ended. Resuming monitoring..."
done
