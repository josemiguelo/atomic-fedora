#!/usr/bin/bash

set -eoux pipefail

echo "::group:: Install COSMIC Desktop"

dnf5 install -y @cosmic-desktop-environment

echo "COSMIC desktop installed successfully"
echo "::endgroup::"

###############################################################################

echo "::group:: Configure Display Manager"

systemctl disable cosmic-greeter || true
systemctl enable gdm

echo "Display manager configured"
echo "::endgroup::"

echo "::group:: Install Additional Utilities"

###############################################################################

dnf5 install -y \
  xdg-desktop-portal-cosmic

echo "Additional utilities installed"
echo "::endgroup::"

echo "COSMIC desktop installation complete!"
