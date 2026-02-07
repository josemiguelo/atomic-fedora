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

dnf5 remove -y \
  NetworkManager-openconnect-gnome \
  NetworkManager-openvpn-gnome \
  NetworkManager-ssh-gnome \
  NetworkManager-vpnc-gnome \
  desktop-backgrounds-gnome \
  f43-backgrounds-gnome \
  gnome-abrt \
  gnome-app-list \
  gnome-autoar \
  gnome-backgrounds \
  gnome-calculator \
  gnome-color-manager \
  gnome-control-center \
  gnome-control-center-filesystem \
  gnome-disk-utility \
  gnome-epub-thumbnailer \
  gnome-initial-setup \
  gnome-online-accounts \
  gnome-online-accounts-libs \
  gnome-settings-daemon \
  gnome-shell-extension* \
  nautilus \
  gnome-tour \
  gnome-user-docs \
  gnome-user-share \
  pinentry-gnome3 \
  vlc-plugin-gnome

echo "Additional utilities installed"
echo "::endgroup::"

echo "COSMIC desktop installation complete!"
