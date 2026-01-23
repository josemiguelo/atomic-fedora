#!/bin/bash

set -ex

########################
# kdotool installation #
########################
echo "Checking if kdotool is installed..."
if ! command -v kdotool >/dev/null 2>&1; then
  echo "kdotool not found, installing..."
  TEMP_DIR=$(mktemp -d)
  git clone https://github.com/jinliu/kdotool "$TEMP_DIR"
  cd "$TEMP_DIR" || exit
  cargo build --release
  if [ $? -eq 0 ]; then
    sudo cp ./target/release/kdotool "$HOME/.local/bin/kdotool"
    sudo chmod 755 "$HOME/.local/bin/kdotool"
    kdotool --version
  else
    echo "Failed to build kdotool."
    exit 1
  fi
  cd - || exit
  rm -rf "$TEMP_DIR"
else
  echo "kdotool is already installed."
fi

#####################
# shortcut creation #
#####################
/usr/bin/focus-app-shortcut-creator 'Focus Firefox' 'Meta+Ctrl+Alt+Shift+F' 'org.mozilla.firefox' "firefox"
/usr/bin/focus-app-shortcut-creator 'Focus Dolphin' 'Meta+Ctrl+Alt+Shift+E' 'org.kde.dolphin' "dolphin"
