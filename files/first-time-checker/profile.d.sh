if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/ublue/setup-done; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /usr/share/first-time-checker.desktop "$HOME"/.config/autostart/first-time-checker.desktop
    fi
fi