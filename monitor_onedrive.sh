#!/bin/bash

set -a
source "$HOME/.telegram_env"
set +a
set -euo pipefail

COOLDOWN_SECONDS=300
REAUTH_PYTHON="/opt/miniforge3/envs/automation/bin/python"
REAUTH_SCRIPT="$HOME/Dev/onedrive-reauth/reauth-onedrive.py"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

send_telegram() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message" > /dev/null
}

run_reauth() {
    log "Running OneDrive reauth script..."
    if "$REAUTH_PYTHON" "$REAUTH_SCRIPT"; then
        log "Reauth completed successfully"
        send_telegram "[OK] fixed reauth error - $(hostname) at: $(date) [auto-reauth]"
    else
        log "Reauth failed"
        send_telegram "[KO] reauth failed - $(hostname) at: $(date) [auto-reauth]"
    fi
}

cleanup() {
    log "Monitor service stopping"
    jobs -p | xargs -r kill 2>/dev/null || true
}

trap cleanup EXIT TERM INT

log "OneDrive monitor service started"

while true; do
  log "Starting monitoring loop..."

  # Disable -e for this block so SIGPIPE / exit codes don't kill the service
  set +e
  journalctl --user-unit=onedrive -f --since=now --no-pager |
  while IFS= read -r line; do
    case "$line" in
      *"Main process exited, code=exited, status="*)
        log "Detected OneDrive service exit"
        send_telegram "[KO] OneDrive sync failed $(hostname) at: $(date) [caught with systemd monitor]"
        break
        ;;
      *"ERROR: You will need to issue a --reauth"*|*"Please authorise this application by visiting the following URL"*)
        log "Detected OneDrive reauth requirement"
        run_reauth
        break
        ;;
      *"Conflict"*)
        log "Conflict with file error"
        send_telegram "[KO] OneDrive conflict ERROR - $(hostname) at: $(date) [caught with systemd monitor]"
        break
        ;;
    esac
  done
  set -e

  sleep $COOLDOWN_SECONDS
done
