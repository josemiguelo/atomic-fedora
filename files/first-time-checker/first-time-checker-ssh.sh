#!/bin/bash

# SSH key
SSH_KEY="$HOME/.ssh/bazzite"
if [ ! -f "$SSH_KEY" ]; then
  echo "Creating SSH key 'bazzite'..."
  ssh-keygen -t ed25519 -C "josemiguelo.ochoa@gmail.com" -f "$SSH_KEY" -N ""
  ssh-add "$SSH_KEY"
  echo "Done creating SSH key 'bazzite'"
else
  echo "SSH key 'bazzite' already exists."
fi
