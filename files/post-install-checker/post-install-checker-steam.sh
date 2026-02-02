#!/bin/bash

set -ex

# fix steam.desktop
STEAM_AUTOSTART="$HOME/.config/autostart/steam.desktop"
if [ -f "$STEAM_AUTOSTART" ]; then
  echo "Fixing steam autostart..."
  sed -i '/^\[Desktop Entry\]/a Hidden=true' "$STEAM_AUTOSTART"
  echo "Done fixing steam"
else
  echo "Steam autostart file not found at $STEAM_AUTOSTART, skipping."
fi

# fix shaders background processing threads
STEAM_DIR="$HOME/.steam/steam"
mkdir -p "$STEAM_DIR"

STEAM_DEV_FILE="$STEAM_DIR/steam_dev.cfg"
if [ -f "$STEAM_DEV_FILE" ]; then
  echo "Creating steam dev file $STEAM_DEV_FILE..."
  cat <<EOF >"$HOME/.steam/steam/steam_dev.cfg"
  @ShaderBackgroundProcessingThreads 8
  unShaderBackgroundProcessingThreads 8
  EOF
  echo "Done creating steam dev file $STEAM_DEV_FILE..."
else
  echo "Steam dev file $STEAM_DEV_FILE already created. skipping...."
fi

echo "Done fixing steam..."
