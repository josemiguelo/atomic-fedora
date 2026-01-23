#!/bin/bash

set -ex

CURRENT_USER=$(whoami)
echo "user: $CURRENT_USER"

if [ "$CURRENT_USER" = "sddm" ] || [ "$CURRENT_USER" = "root" ]; then
  echo "User is $CURRENT_USER, skipping first-time-checker..."
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

/usr/bin/first-time-checker-flatpaks.sh
/usr/bin/first-time-checker-steam.sh
/usr/bin/first-time-checker-ssh.sh
/usr/bin/first-time-checker-krohnkite.sh
/usr/bin/first-time-checker-kdotool.sh

##############################################################################################

echo "All done!!"
