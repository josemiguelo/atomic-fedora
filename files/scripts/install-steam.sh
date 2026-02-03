#!/usr/bin/bash

set -eoux pipefail

echo "::group:: Install rpmfusion "
sudo dnf5 install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  -y
echo "::endgroup::"

echo "::group:: Install steam"
sudo dnf install steam -y
echo "::endgroup::"
