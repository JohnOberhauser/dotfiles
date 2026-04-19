#!/usr/bin/env bash

handle() {
    case $1 in
        monitoraddedv2*Artist\ 24\ Pro*)
            otd-daemon >> /dev/null 2>&1 & disown
            ;;
        monitorremovedv2*Artist\ 24\ Pro*)
            pkill -f OpenTabletDriver.Daemon
            ;;
    esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
    | while read -r line; do handle "$line"; done