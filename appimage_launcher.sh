#!/bin/bash

APPIMAGE_DIR="/home/m1tus/.local/share/appimage/"

APP_NAME="$1"

APPIMAGE="$(ls "$APPIMAGE_DIR"/${APP_NAME}*.AppImage | head -n1)"

"$APPIMAGE"
