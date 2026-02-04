#!/bin/bash

set -ex

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

CURRENT_USER=$(whoami)
echo "user: $CURRENT_USER"

if [ "$CURRENT_USER" = "sddm" ] || [ "$CURRENT_USER" = "root" ]; then
  echo "User is $CURRENT_USER, skipping post-install-checker..."
  exit 0
fi

# Wait for network connection
echo "Waiting for internet connection..."
max_retries=30
count=0
while ! ping -c 1 8.8.8.8 >/dev/null 2>&1; do
  if [ "$count" -ge "$max_retries" ]; then
    echo "Error: Network timeout. Proceeding but installations may fail."
    break
  fi
  echo "Waiting for network... ($((count + 1))/$max_retries)"
  sleep 2
  count=$((count + 1))
done

##############################################################################################

"$SCRIPT_DIR"/post-install-checker-flatpaks.sh
"$SCRIPT_DIR"/post-install-checker-steam.sh
"$SCRIPT_DIR"/post-install-checker-ssh.sh
"$SCRIPT_DIR"/post-install-checker-git.sh
"$SCRIPT_DIR"/post-install-checker-dotfiles.sh
"$SCRIPT_DIR"/post-install-checker-fonts.sh
"$SCRIPT_DIR"/post-install-checker-asdf.sh
"$SCRIPT_DIR"/post-install-checker-ngrok.sh

##############################################################################################

echo "All done!!"
