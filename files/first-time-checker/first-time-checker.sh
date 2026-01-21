#!/bin/bash

CURRENT_USER=$(whoami)
if [ "$CURRENT_USER" = "sddm" ]; then
  echo "User is sddm, skipping first-time-checker..."
  exit 0
fi

echo "user: $CURRENT_USER"

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

./first-time-checker-flatpaks.sh
./first-time-checker-steam.sh
./first-time-checker-ssh.sh
./first-time-checker-krohnkite.sh
./first-time-checker-focus-app.sh

##############################################################################################

echo "All done!!"
