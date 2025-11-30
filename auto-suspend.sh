#!/bin/bash

TIMEOUT_SEC=20
LOG_TAG="AutoSuspend"

TIMER_PID=""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

is_screen_locked() {
    gdbus call --session \
        --dest org.gnome.ScreenSaver \
        --object-path /org/gnome/ScreenSaver \
        --method org.gnome.ScreenSaver.GetActive 2>/dev/null | grep -q "true"
}

suspend_sequence() {
    log "Initiating suspend sequence. Waiting ${TIMEOUT_SEC}s..."
    sleep $TIMEOUT_SEC
    
    if is_screen_locked; then
        log "Timeout reached and screen still locked. Suspending system..."
        systemctl suspend
    else
        log "Timeout reached but screen was unlocked. Suspend aborted."
    fi
}

start_countdown() {
    stop_countdown "Restarting timer"
    suspend_sequence &
    TIMER_PID=$!
    log "Countdown started (PID: $TIMER_PID)"
}

stop_countdown() {
    if [[ -n "$TIMER_PID" ]]; then
        if ps -p $TIMER_PID > /dev/null; then
            kill $TIMER_PID
            log "Activity detected or status change: Timer cancelled (PID: $TIMER_PID killed)."
        fi
        TIMER_PID=""
    fi
}

log "Auto-suspend started..."

# Usamos stdbuf para evitar Block Buffering porque sino el sistema espera a llenar el buffer antes de pasar los datos
# y con stbuf -oL forzamos Line Buffering para que cada línea se procese inmediatamente.

# usamos { ... } | while read -r line; porque así podemos leer la salida combinada de ambos monitores a la vez
{
    stdbuf -oL gdbus monitor --system --dest org.freedesktop.login1 --object-path /org/freedesktop/login1 &
    stdbuf -oL gdbus monitor --session --dest org.gnome.ScreenSaver --object-path /org/gnome/ScreenSaver &
} | while read -r line; do
    
    # CASO 1: resume
    if echo "$line" | grep -q "PrepareForSleep"; then
        if echo "$line" | grep -q "false"; then
            log "Event: System Resumed."
            if is_screen_locked; then
                start_countdown
            fi
        fi
    fi

    # CASO 2: La pantalla cambia de estado; [ActiveChanged (true,)  -> Bloqueado], [ActiveChanged (false,) -> Desbloqueado]
    if echo "$line" | grep -q "ActiveChanged"; then
        if echo "$line" | grep -q "true"; then
            log "Event: Screen Locked / Turned Off."
            start_countdown
        elif echo "$line" | grep -q "false"; then
            log "Event: Screen Unlocked."
            stop_countdown
        fi
    fi

done
