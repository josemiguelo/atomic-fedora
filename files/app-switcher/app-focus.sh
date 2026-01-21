#!/usr/bin/bash

# Handle case where script path is passed as first argument
if [[ "$1" == /* && "$1" == *".sh" ]]; then
    shift
fi

# Get the class name and launch command
CLASS=$1
LAUNCH_CMD="${@:2}"

# We filter out this script's own PID to avoid false positives matching the command arguments
if pgrep -f "$LAUNCH_CMD" | grep -v "^$$\$" > /dev/null; then

    echo "App is running, focusing $LAUNCH_CMD"

    # 1. Update the script's configuration
    kwriteconfig6 --file kwinrc --group "Script-app-switcher" --key "targetClass" "$CLASS"
    kwriteconfig6 --file kwinrc --group "Script-app-switcher" --key "launchCmd" "$LAUNCH_CMD"

    # 2. Tell KWin to reload the configuration for this script
    qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "app-switcher"
    qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "" "app-switcher"

    # 3. Trigger the logic
    qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "cycle-app-focus"

else

    echo "App is not running, launching $LAUNCH_CMD"
    kstart $LAUNCH_CMD

fi