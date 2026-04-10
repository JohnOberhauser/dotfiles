#!/bin/sh

brightness=$(brightnessctl i | grep Current | awk -F "(" '{print $2}' | awk -F "%" '{print $1}')

echo "current brightness: $brightness"

increase() {
    if [[ $brightness -le 95 ]]; then
        brightnessctl s 5%+
    else
        brightnessctl s 100%
    fi
}

decrease() {
    if [[ $brightness -ge 5 ]]; then
        brightnessctl s 5%-
    else
        brightnessctl s 0%
    fi
}

if [ "$1" = "increase" ]; then
    increase
elif [ "$1" = "decrease" ]; then
    decrease
fi
