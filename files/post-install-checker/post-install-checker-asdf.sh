#!/bin/bash

set -ex

##################
## INSTALLATION ##
##################

cd $HOME

ASDF_VERSION="0.18.0"
BIN_DIR="$HOME/.local/bin"
ASDF_DATA_DIR="$HOME/.asdf"
CHEZMOI_DIR="$HOME/.local/share/chezmoi"

if command -v asdf >/dev/null 2>&1; then
  echo "🚀 asdf version $(asdf --version) is already installed. Skipping download."
else
  echo "asdf not found. Starting installation of v${ASDF_VERSION}..."

  ARCH=$(uname -m)
  case ${ARCH} in
  x86_64) ARCH_TYPE="amd64" ;;
  aarch64) ARCH_TYPE="arm64" ;;
  *)
    echo "Unsupported architecture: ${ARCH}"
    exit 1
    ;;
  esac

  mkdir -p "$BIN_DIR"
  mkdir -p "$ASDF_DATA_DIR"/{installs,plugins,shims}

  URL="https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VERSION}/asdf-v${ASDF_VERSION}-linux-${ARCH_TYPE}.tar.gz"

  echo "Downloading from: ${URL}"
  curl -sSL "$URL" | tar -xz -C "$BIN_DIR" asdf

  chmod +x "${BIN_DIR}/asdf"
  chmod -R 777 "$ASDF_DATA_DIR"

  echo "🚀 Installation complete. asdf binary placed in ${BIN_DIR}/asdf."
  echo "version $(asdf --version)"
fi

#############
## PLUGINS ##
#############

if asdf plugin list | grep -q "^asdf-plugin-manager$"; then
  echo "🚀 asdf-plugin-manager plugin is already installed."
else
  asdf plugin add asdf-plugin-manager https://github.com/asdf-community/asdf-plugin-manager.git
  asdf install asdf-plugin-manager 1.5.0 # sync this version with asdf config files
fi

PLUGIN_MANAGER="$ASDF_DATA_DIR/shims/asdf-plugin-manager"
echo "🚀 installed asdf-plugin-manager version $($PLUGIN_MANAGER version)"

if [ -f ~/.tool-versions ]; then
  echo "Checking for missing plugins from ~/.tool-versions..."
  INSTALLED_PLUGINS=$(asdf plugin list 2>/dev/null)
  MISSING_PLUGINS=false

  while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    PLUGIN_NAME=$(echo "$line" | awk '{print $1}')
    if [ -n "$PLUGIN_NAME" ]; then
      if ! echo "$INSTALLED_PLUGINS" | grep -q "^${PLUGIN_NAME}$"; then
        MISSING_PLUGINS=true
        break
      fi
    fi
  done < ~/.tool-versions

  if [ "$MISSING_PLUGINS" = true ]; then
    echo "Installing missing plugins..."
    $PLUGIN_MANAGER add-all
  else
    echo "🚀 All plugins from ~/.tool-versions are already installed."
  fi
  
  echo "Checking tools from ~/.tool-versions..."
  export CFLAGS="-std=gnu11 -Wno-error=incompatible-pointer-types" # avoid error on older python versions
  while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    
    tool=$(echo "$line" | awk '{print $1}')
    
    if [ -z "$tool" ]; then
      continue
    fi
    
    # Get all versions (all fields after the first one)
    # Use awk to print fields 2 onwards
    VERSIONS=$(echo "$line" | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')
    
    if [ -z "$VERSIONS" ]; then
      # No versions specified, install latest/default
      echo "Installing $tool (no version specified)..."
      asdf install "$tool" || { echo "❌ Failed to install asdf tool: $tool"; }
      continue
    fi
    
    # Get installed versions for this tool
    INSTALLED_VERSIONS=$(asdf list "$tool" 2>/dev/null)
    
    # Loop through each version and install if not already installed
    for VERSION in $VERSIONS; do
      if [ -n "$INSTALLED_VERSIONS" ]; then
        # Check if this specific version is already installed
        if echo "$INSTALLED_VERSIONS" | grep -qE "^[[:space:]]*${VERSION}[[:space:]]*$"; then
          echo "🚀 $tool version $VERSION is already installed. Skipping."
          continue
        fi
      fi
      
      echo "Installing $tool version $VERSION..."
      asdf install "$tool" "$VERSION" || { echo "❌ Failed to install $tool version $VERSION"; }
    done
  done < ~/.tool-versions
else
  echo "⚠️  ~/.tool-versions not found. There was a problem with the chezmoi setup..."
  exit 1
fi

if [ -d "$CHEZMOI_DIR" ]; then
  DESIRED_REMOTE="git@github.com:josemiguelo/.dotfiles.git"
  CURRENT_REMOTE=$(cd "$CHEZMOI_DIR" && git remote get-url origin 2>/dev/null)
  if [ "$CURRENT_REMOTE" != "$DESIRED_REMOTE" ]; then
    echo "Setting chezmoi git remote to $DESIRED_REMOTE..."
    (cd "$CHEZMOI_DIR" && git remote set-url origin "$DESIRED_REMOTE")
  else
    echo "🚀 chezmoi git remote is already set correctly."
  fi
else
  echo "⚠️  $CHEZMOI_DIR not found. There was a problem with the chezmoi setup..."
  exit 1
fi