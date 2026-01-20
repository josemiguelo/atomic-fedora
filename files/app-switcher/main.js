// This runs whenever the configuration changes OR the shortcut is triggered
registerShortcut("cycle-app-focus", "Cycle focus for apps", "", function () {
  // Read the class name from the script's own configuration
  var targetClass = readConfig("targetClass", "");
  if (!targetClass) return;

  var windows = workspace.windowList();
  var matches = windows.filter(w =>
    w.resourceClass.toLowerCase() === targetClass.toLowerCase() && w.normalWindow
  );

  if (matches.length > 0) {
    var active = workspace.activeWindow;
    var nextIndex = 0;

    for (var j = 0; j < matches.length; j++) {
      if (active && matches[j].internalId === active.internalId) {
        nextIndex = (j + 1) % matches.length;
        break;
      }
    }
    workspace.activeWindow = matches[nextIndex];
  } else {
    // No matching windows, so launch the app
    var launchCmd = readConfig("launchCmd", "");
    if (launchCmd) {
      callDBus("org.kde.krunner", "/App", "org.kde.krunner.App", "launch", launchCmd);
    }
  }
});
