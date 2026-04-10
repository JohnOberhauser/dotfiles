#!/bin/bash

# Install the xdg desktop portal for terminal file choosers.  Using my fork that fixes some bugs.
mkdir -p $HOME/Downloads
cd $HOME/Downloads

git clone git@github.com:JohnOberhauser/xdg-desktop-portal-termfilechooser.git

cd xdg-desktop-portal-termfilechooser
meson build && ninja -C build && ninja -C build install

mkdir -p $HOME/.config/xdg-desktop-portal
cp $HOME/workspace/dotfiles/setup/installFiles/portals.conf $HOME/.config/xdg-desktop-portal/

# Move some installed files to the correct location
sudo mv /usr/local/share/xdg-desktop-portal/portals/termfilechooser.portal /usr/share/xdg-desktop-portal/portals/
sudo mv /usr/local/lib/systemd/user/xdg-desktop-portal-termfilechooser.service /usr/lib/systemd/user/
sudo mv /usr/local/share/dbus-1/services/org.freedesktop.impl.portal.desktop.termfilechooser.service /usr/share/dbus-1/services/

mkdir -p $HOME/.config/xdg-desktop-portal-termfilechooser
cp -r /usr/local/share/xdg-desktop-portal-termfilechooser/* $HOME/.config/xdg-desktop-portal-termfilechooser/

systemctl --user restart xdg-desktop-portal.service

# Setup xdg-mime default file manager
# Needs to go in /usr/ because firefox won't use local user's .desktop files for some reason
sudo cp $HOME/workspace/dotfiles/setup/installFiles/yazi-kitty.sh /usr/local/bin/
sudo cp $HOME/workspace/dotfiles/setup/installFiles/yazi-kitty.desktop /usr/share/applications/

xdg-mime default yazi-kitty.desktop inode/directory

rm -rf $HOME/Downloads/xdg-desktop-portal-termfilechooser
