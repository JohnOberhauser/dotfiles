#!/usr/bin/env bash

start_daemon() {
    if ! pgrep -f OpenTabletDriver.Daemon > /dev/null; then
        otd-daemon >> /dev/null 2>&1 & disown
    fi
}

# Start daemon if tablet is already connected
if hyprctl monitors | grep -q "Artist 24 Pro"; then
    start_daemon
fi

handle() {
    case $1 in
        monitoraddedv2*Artist\ 24\ Pro*)
            start_daemon
            ;;
        monitorremovedv2*Artist\ 24\ Pro*)
            pkill -f OpenTabletDriver.Daemon
            ;;
    esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
    | while read -r line; do handle "$line"; done