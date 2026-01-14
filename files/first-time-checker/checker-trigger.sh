#!/bin/bash

# Define paths
SETUP_MARKER="$HOME/.config/ublue/setup-done"

# Check if setup has already been completed
if test -e "$SETUP_MARKER"; then
  echo "First-time setup already completed"
  exit 0
fi

# Setup hasn't been run yet, launch the script in a terminal
echo "First-time setup needed, launching..."

# Launch the script in a terminal window
if command -v ptyxis >/dev/null 2>&1; then
  ptyxis -- /usr/bin/first-time-checker
elif command -v konsole >/dev/null 2>&1; then
  konsole -e /usr/bin/first-time-checker
elif command -v gnome-terminal >/dev/null 2>&1; then
  gnome-terminal -- /usr/bin/first-time-checker
elif command -v xterm >/dev/null 2>&1; then
  xterm -e /usr/bin/first-time-checker
else
  # Fallback: run without terminal
  /usr/bin/first-time-checker
fi
