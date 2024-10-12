#!/bin/bash

APPIMAGE_DIR="/home/m1tus/.local/share/appimage/"

APP_NAME="$1"

APPIMAGE="$(ls "$APPIMAGE_DIR"/${APP_NAME}*.AppImage 2>/dev/null | head -n1)"

if [ -z "$APPIMAGE" ]; then
    notify-send "No se encontró AppImage con nombre $APP_NAME"
else 
    "$APPIMAGE"
fi

