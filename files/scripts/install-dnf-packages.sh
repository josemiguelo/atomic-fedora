#!/bin/bash

set -ouex pipefail

######################
## GENERAL PACKAGES ##
######################

DEV_PACKAGES=(
  "vlc"
  "konsole"
  "okular"
  "dbus-devel"
  "dnf-command(copr)"
)
dnf5 install -y "${DEV_PACKAGES[@]}"
dnf5 clean all

###############
## DEV TOOLS ##
###############
dnf5 install -y @development-tools

DEV_PACKAGES=(
  "zlib-devel"
  "bzip2-devel"
  "readline-devel"
  "sqlite"
  "sqlite-devel"
  "openssl-devel"
  "xz-devel"
  "libffi-devel"
  "findutils"
  "tk-devel"
  "libzstd-devel"
  "autoconf"
  "gcc"
  "rust"
  "patch"
  "libyaml-devel"
  "gdbm-devel"
  "ncurses-devel"
  "perl-FindBin"
  "git-delta"
  "tmux"
)
echo "Installing dev packages ${#DEV_PACKAGES[@]} ..."
dnf5 install -y "${DEV_PACKAGES[@]}"
dnf5 clean all

###############
## CLI TOOLS ##
###############
CLI_PACKAGES=(
  "atuin"
  "btop"
  "bat"
  "chezmoi"
  "ripgrep"
  "zoxide"
  "fd-find"
  "trash-cli"
  "tree-sitter-cli"
)
echo "Installing cli packages ${#CLI_PACKAGES[@]} ..."
dnf5 install -y "${CLI_PACKAGES[@]}"
dnf5 clean all

##########
## YAZI ##
##########
dnf5 copr enable -y lihaohong/yazi
dnf5 install -y yazi

#############
## WEZTERM ##
#############
dnf5 copr enable -y wezfurlong/wezterm-nightly
dnf5 install -y wezterm
dnf5 clean all

############
## VSCODE ##
############
rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" |
  tee /etc/yum.repos.d/vscode.repo >/dev/null

dnf5 install -y code
dnf5 clean all

#################
## ANTIGRAVITY ##
#################
tee /etc/yum.repos.d/antigravity.repo <<EOF
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOF
dnf5 makecache
dnf5 install -y antigravity
dnf5 clean all

## clean everything ......
dnf5 clean all
echo "🚀 Installation complete!"
