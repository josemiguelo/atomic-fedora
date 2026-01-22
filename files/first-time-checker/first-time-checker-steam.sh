#!/bin/bash

set -x

# steam
STEAM_AUTOSTART="$HOME/.config/autostart/steam.desktop"
if [ -f "$STEAM_AUTOSTART" ]; then
  echo "Fixing steam autostart..."
  sed -i '/^\[Desktop Entry\]/a Hidden=true' "$STEAM_AUTOSTART"
  echo "Done fixing steam"
else
  echo "Steam autostart file not found at $STEAM_AUTOSTART, skipping."
fi
