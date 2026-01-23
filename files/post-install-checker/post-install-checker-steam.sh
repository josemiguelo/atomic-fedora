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
mkdir -p "$HOME/.steam/steam"
cat <<EOF >"$HOME/.steam/steam/steam_dev.cfg"
@ShaderBackgroundProcessingThreads 8
unShaderBackgroundProcessingThreads 8
EOF

echo "Done fixing steam settings file"
