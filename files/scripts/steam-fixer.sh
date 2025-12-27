#!/usr/bin/bash

# Ensure the directory path exists before writing to it
mkdir -p "$HOME/.steam/steam"

# Force-write the configuration using Heredoc
cat <<EOF >"$HOME/.steam/steam/steam_dev.cfg"
@ShaderBackgroundProcessingThreads 8
unShaderBackgroundProcessingThreads 8
EOF

