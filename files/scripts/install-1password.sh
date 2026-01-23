#!/bin/sh

set -ouex pipefail

rpm --import https://downloads.1password.com/linux/keys/1password.asc

dnf5 config-manager addrepo \
  --id=1password \
  --set=name="1Password Stable Channel" \
  --set=baseurl="https://downloads.1password.com/linux/rpm/stable/\$basearch" \
  --set=enabled=1 \
  --set=gpgcheck=1 \
  --set=repo_gpgcheck=1 \
  --set=gpgkey="https://downloads.1password.com/linux/keys/1password.asc"

dnf5 install -y 1password
