[group('PostInstall')]
setup-ngrok:
  #!/bin/bash
  set -ex

  BIN_DIR="$HOME/.local/bin"
  NGROK_BINARY="${BIN_DIR}/ngrok"
  URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"

  # Check if ngrok is already installed
  if [ -f "$NGROK_BINARY" ] && [ -x "$NGROK_BINARY" ]; then
    echo "⚠️ ngrok is already installed at $NGROK_BINARY. Skipping download."
    exit 0
  fi

  echo "🚀 Downloading ngrok from: ${URL}"

  mkdir -p "$BIN_DIR"
  curl -sSL "$URL" | tar -xz -C "$BIN_DIR" ngrok
  chmod +x "$NGROK_BINARY"

  echo "✅ ngrok has been downloaded and installed at: ${NGROK_BINARY}"
