#!/bin/bash

echo "Checking if Krohnkite is installed..."
if ! kpackagetool6 -t KWin/Script -s krohnkite >/dev/null 2>&1; then
  echo "Krohnkite not found, installing..."
  TMP_KWIN_SCRIPT=$(mktemp)
  curl -L -o "$TMP_KWIN_SCRIPT" "https://codeberg.org/anametologin/Krohnkite/releases/download/0.9.9.2/krohnkite-0.9.9.2-1d7fd74.kwinscript"
  kpackagetool6 -t KWin/Script -i "$TMP_KWIN_SCRIPT"
  rm "$TMP_KWIN_SCRIPT"
  echo "Krohnkite installed."
else
  echo "Krohnkite is already installed."
fi
