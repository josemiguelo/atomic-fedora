#!/bin/bash

set -ex

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO_ROOT=$(dirname "$(dirname "$SCRIPT_DIR")")

########################
# kdotool installation #
########################
echo "Checking if kdotool is installed..."
if [ ! -f "$HOME/.local/bin/kdotool" ]; then
  echo "kdotool not found, installing..."
  TEMP_DIR=$(mktemp -d)
  git clone https://github.com/jinliu/kdotool "$TEMP_DIR"
  cd "$TEMP_DIR" || exit
  cargo build --release
  if [ $? -eq 0 ]; then
    cp ./target/release/kdotool "$HOME/.local/bin/kdotool"
    chmod 755 "$HOME/.local/bin/kdotool"
    export PATH="$HOME/.local/bin:$PATH"
    "$HOME/.local/bin/kdotool" --version
  else
    echo "Failed to build kdotool."
    exit 1
  fi
  cd - || exit
  rm -rf "$TEMP_DIR"
else
  echo "kdotool is already installed."
  export PATH="$HOME/.local/bin:$PATH"
fi

#####################
# shortcut creation #
#####################
"$REPO_ROOT/files/app-focuser/shortcut-creator.sh" 'Focus Firefox' 'Meta+Ctrl+Alt+Shift+F' 'org.mozilla.firefox' "kstart firefox"
"$REPO_ROOT/files/app-focuser/shortcut-creator.sh" 'Focus Dolphin' 'Meta+Ctrl+Alt+Shift+E' 'org.kde.dolphin' "kstart dolphin"
"$REPO_ROOT/files/app-focuser/shortcut-creator.sh" 'Focus Wezterm' 'Meta+Ctrl+Alt+Shift+W' 'org.wezfurlong.wezterm' "/usr/bin/distrobox-enter -n fedora-dev -- wezterm start --cwd ."
"$REPO_ROOT/files/app-focuser/shortcut-creator.sh" 'Focus Konsole' 'Meta+Ctrl+Alt+Shift+K' 'org.kde.konsole' "kstart konsole"
