#!/usr/bin/bash

set -ex

# --- Configuration ---
# This script creates a global shortcut in KDE Plasma to focus or launch an application.
# It uses kdotool to intelligently find, focus, or cycle application windows.

# --- Usage ---
if [[ "$#" -ne 4 ]]; then
  echo "Usage: $0 <app_name> <keybinding> <window_class> <launch_cmd>"
  echo ""
  echo "Arguments:"
  echo "  <app_name>      A short, descriptive name (e.g., 'Focus Dolphin')."
  echo "  <keybinding>    The key combination (e.g., 'Meta+F1', 'Ctrl+Alt+T')."
  echo "  <window_class>  The application's window class name."
  echo "  <launch_cmd>    The command to run to launch the application."
  echo ""
  echo "Example:"
  echo "  $0 'Focus Dolphin' 'Meta+Ctrl+D' 'org.kde.dolphin' 'dolphin'"
  echo ""
  echo "Tip: To find a window's class, run:"
  echo "  kdotool getactivewindow getwindowclassname"
  exit 1
fi

# --- Arguments ---
APP_NAME="$1"
KEYBINDING="$2"
WINDOW_CLASS="$3"
LAUNCH_CMD="$4"

# --- Script ---
echo "--- Starting Shortcut Creation ---"

# 1. Standardize the ID
# Sanitize the app name to create a safe filename and identifier.
# Replaces spaces and special characters with hyphens and converts to lowercase.
SANITIZED_NAME=$(echo "$APP_NAME" | tr -s '[:punct:][:space:]' '-' | tr '[:upper:]' '[:lower:]' | sed 's/^-//;s/-$//')
ID="net.local.$SANITIZED_NAME.desktop"
FILE_PATH="$HOME/.local/share/applications/$ID"
echo "Generated ID: $ID"
echo "Desktop file will be at: $FILE_PATH"

EXEC_CMD="/usr/bin/focus-app '$WINDOW_CLASS' '$LAUNCH_CMD'"
echo "Exec command will be: $EXEC_CMD"

# 2. Create the .desktop file
echo "Creating .desktop file..."
cat <<EOF >"$FILE_PATH"
[Desktop Entry]
Exec=$EXEC_CMD
Name=$APP_NAME
NoDisplay=true
Type=Application
X-KDE-GlobalAccel-CommandShortcut=true
StartupNotify=false
Terminal=false
EOF

chmod +x "$FILE_PATH"
echo ".desktop file created and made executable."

# 3. Update kglobalshortcutsrc
# This tells KDE which keybinding launches the .desktop file's action.
echo "Assigning keybinding '$KEYBINDING'..."
kwriteconfig6 --file kglobalshortcutsrc \
  --group "services" \
  --group "$ID" \
  --key "_launch" "$KEYBINDING"

# 4. Force the System to recognize the new service
echo "Updating system configuration cache..."
kbuildsycoca6 --noincremental

# 5. Register the shortcut with the running kglobalaccel daemon
# This is the magic step that avoids needing to log out or restart services.
# The DBus path requires the service ID, with underscores replacing dots.
DBUS_SERVICE_ID=$(echo "$ID" | sed 's/\./_/g')
echo "Registering via DBus with service ID: $DBUS_SERVICE_ID..."
dbus-send --type=method_call --dest=org.kde.kglobalaccel "/component/services_$DBUS_SERVICE_ID" \
  org.kde.kglobalaccel.Component.allShortcutInfos >/dev/null 2>&1 || true

# 6. Final Refresh
# While the DBus call is often enough, a restart can help in some edge cases.
echo "Requesting a refresh of the global shortcuts daemon..."
systemctl --user restart plasma-kglobalaccel >/dev/null 2>&1 || true

echo "--- Shortcut Creation Complete! ---"
echo "Your new shortcut '$APP_NAME' should now be active with the keybinding '$KEYBINDING'."
echo "If it doesn't work immediately, try logging out and back in."
