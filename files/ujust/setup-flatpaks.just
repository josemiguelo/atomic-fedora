####################################################################################################
[group('PostInstall')]
setup-flatpaks:
  #!/bin/bash

  set -ex

  remove_flatpak() {
    local app_id=$1
    if flatpak info "$app_id" >/dev/null 2>&1; then
      flatpak uninstall --delete-data "$app_id" -y
      echo "✅ Removed $app_id..."
    else
      echo "⚠️ $app_id flatpak is not present on the system. skipping uninstallation..."
    fi
  }

  install_flatpak() {
    local app_id=$1
    local app_name=$2
    if flatpak info "$app_id" >/dev/null 2>&1; then
      echo "⚠️ $app_name is already installed."
    else
      echo "🚀 Installing $app_name..."
      if flatpak install -y "$app_id"; then
        echo "✅ Success: $app_name installed"
      else
        echo "❌ Error: Failed to install $app_name. Proceeding with remainder of script..."
      fi
    fi
  }

  # flatpaks
  echo "🚀 Configuring flatpaks..."

  remove_flatpak "org.mozilla.firefox"
  install_flatpak "md.obsidian.Obsidian" "Obsidian"

  echo "✅ Done installing flatpaks"
