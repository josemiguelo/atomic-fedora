#!/bin/bash

FOCUS_APP_DIR="$HOME/.local/share/kwin/scripts/focus-app"
FOCUS_APP_REPO="https://github.com/josemiguelo/focus-app-kde.git"

mkdir -p "$HOME/Repos"
FOCUS_APP_CLONE_DIR="$HOME/Repos/focus-app"

echo "Checking if Focus App KWin script is installed..."
if [ ! -d "$FOCUS_APP_DIR" ]; then
  echo "Focus App not found, cloning repository and installing..."

  if git clone "$FOCUS_APP_REPO" "$FOCUS_APP_CLONE_DIR"; then
    echo "Repository cloned successfully."

    # Run the install script
    if [ -f "$FOCUS_APP_CLONE_DIR/install.sh" ]; then
      echo "Running install.sh..."
      cd "$FOCUS_APP_CLONE_DIR"
      chmod +x install.sh
      ./install.sh
      cd - >/dev/null
      echo "Focus App installed successfully."
    else
      echo "Error: install.sh not found in repository."
    fi
  else
    echo "Error: Failed to clone Focus App repository."
  fi
else
  echo "Focus App is already installed."

  # Check if the script is active by verifying if it's enabled in KWin
  echo "Checking if Focus App script is active..."
  SCRIPT_ENABLED=$(kreadconfig6 --file kwinrc --group Plugins --key focus-appEnabled)

  if [ "$SCRIPT_ENABLED" != "true" ]; then
    echo "Focus App script is not active, reloading..."

    # Clone/update the repository to get reload.sh
    if [ -d "$FOCUS_APP_CLONE_DIR" ]; then
      echo "Updating existing repository..."
      cd "$FOCUS_APP_CLONE_DIR"
      git pull
      cd - >/dev/null
    else
      echo "Cloning repository to get reload script..."
      git clone "$FOCUS_APP_REPO" "$FOCUS_APP_CLONE_DIR"
    fi

    # Run the reload script
    if [ -f "$FOCUS_APP_CLONE_DIR/reload.sh" ]; then
      echo "Running reload.sh..."
      cd "$FOCUS_APP_CLONE_DIR"
      chmod +x reload.sh
      ./reload.sh
      cd - >/dev/null
      echo "Focus App reloaded successfully."
    else
      echo "Error: reload.sh not found in repository."
    fi
  else
    echo "Focus App script is already active."
  fi
fi
