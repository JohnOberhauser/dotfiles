#!/bin/sh

size=24

dummyTheme=dummyCursor
hyprctl setcursor $dummyTheme $size
gsettings set org.gnome.desktop.interface cursor-theme $dummyTheme
gsettings set org.gnome.desktop.interface cursor-size $size

xrdb -merge <<< "Xcursor.theme: $dummyTheme"
xrdb -merge <<< "Xcursor.size: $size"

theme=systemCursor

hyprctl setcursor $theme $size
gsettings set org.gnome.desktop.interface cursor-theme $theme
gsettings set org.gnome.desktop.interface cursor-size $size

xrdb -merge <<< "Xcursor.theme: $theme"
xrdb -merge <<< "Xcursor.size: $size"