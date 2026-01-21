#!/usr/bin/bash

CLASS=$1
LAUNCH_CMD="${@:2}"

# 1. Update the script's configuration
kwriteconfig6 --file kwinrc --group "Script-app-switcher" --key "targetClass" "$CLASS"
kwriteconfig6 --file kwinrc --group "Script-app-switcher" --key "launchCmd" "$LAUNCH_CMD"

# 2. Tell KWin to reload the configuration for this script
qdbus org.kde.KWin /Scripting/app-switcher org.kde.kwin.Script.stop
qdbus org.kde.KWin /Scripting/app-switcher org.kde.kwin.Script.run

# 3. Trigger the logic
qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "cycle-app-focus"
