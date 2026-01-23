#! /usr/bin/bash

set -ex

if [[ -z "$1" ]]; then
  echo "Usage: $0 <window_class_name> [launch_command]"
  echo ""
  exit 1
fi

# 1. kdotool should be installed
if [ -f "$HOME/.local/bin/kdotool" ]; then
  KDOTOOL_BIN="$HOME/.local/bin/kdotool"
elif command -v "kdotool" >/dev/null 2>&1; then
  KDOTOOL_BIN="kdotool"
else
  echo "Error: kdotool not found" >&2
  exit 1
fi

CLASS_NAME=$1
LAUNCH_CMD=${2:-$1}

# 2. Get IDs for this specific class
# Using --class ensures we don't accidentally match a terminal with "firefox" in the title
ALL_WIDS=($($KDOTOOL_BIN search --class "$CLASS_NAME"))
ACTIVE_WID=$($KDOTOOL_BIN getactivewindow)

# 3. Logic: Launch, Focus, or Cycle
if [[ ${#ALL_WIDS[@]} -eq 0 ]]; then
  echo "Class '$CLASS_NAME' not found. Launching $LAUNCH_CMD..."
  eval "$LAUNCH_CMD" >/dev/null 2>&1 &
elif [[ ${#ALL_WIDS[@]} -eq 1 ]]; then
  # Even if only one, we check if it's already focused to avoid redundant calls
  if [[ "$ACTIVE_WID" == "${ALL_WIDS[0]}" ]]; then
    echo "Window is already focused."
  else
    $KDOTOOL_BIN windowactivate "${ALL_WIDS[0]}"
  fi
else
  # Cycle Logic: Find index of current window and pick the next one
  NEXT_WID=${ALL_WIDS[0]}
  FOUND_ACTIVE=false

  for i in "${!ALL_WIDS[@]}"; do
    if [[ "${ALL_WIDS[$i]}" == "$ACTIVE_WID" ]]; then
      NEXT_INDEX=$(((i + 1) % ${#ALL_WIDS[@]}))
      NEXT_WID=${ALL_WIDS[$NEXT_INDEX]}
      FOUND_ACTIVE=true
      break
    fi
  done

  # If the active window wasn't part of the app, NEXT_WID stays as ALL_WIDS[0]
  $KDOTOOL_BIN windowactivate "$NEXT_WID"
fi
