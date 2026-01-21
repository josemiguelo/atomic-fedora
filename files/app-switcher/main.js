registerShortcut("cycle-app-focus", "Cycle focus for apps", "", function () {
  console.log("Shortcut 'cycle-app-focus' triggered.");

  var targetClass = readConfig("targetClass", "");
  console.log("Read targetClass:", targetClass);
  if (!targetClass) {
    console.log("No targetClass configured, exiting.");
    return;
  }

  var windows = workspace.windowList();
  var matches = windows.filter(w =>
    w.resourceClass.toLowerCase() === targetClass.toLowerCase() && w.normalWindow
  );

  if (matches.length > 0) {
    console.log("Found", matches.length, "matching windows.");
    var active = workspace.activeWindow;
    var nextIndex = 0;

    for (var j = 0; j < matches.length; j++) {
      if (active && matches[j].internalId === active.internalId) {
        nextIndex = (j + 1) % matches.length;
        console.log("Active window matched, nextIndex:", nextIndex);
        break;
      }
    }
    workspace.activeWindow = matches[nextIndex];
    console.log("Set active window to:", matches[nextIndex].caption);
  } else {
    console.log("No matching windows found.");
  }
});
