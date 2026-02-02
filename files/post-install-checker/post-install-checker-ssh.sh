#!/bin/bash

set -ex

# SSH key
SSH_KEY="$HOME/.ssh/bluefin"
if [ ! -f "$SSH_KEY" ]; then
  echo "Creating SSH key 'bluefin'..."
  ssh-keygen -t ed25519 -C "josemiguelo.ochoa@gmail.com" -f "$SSH_KEY" -N ""
  eval "$(ssh-agent -s)"
  ssh-add "$SSH_KEY"
  echo "Done creating SSH key 'bluefin'"
else
  echo "SSH key 'bluefin' already exists."
fi
