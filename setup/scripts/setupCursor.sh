#!/bin/bash

cp -r $HOME/workspace/dotfiles/setup/installFiles/cursor/* $HOME/.icons/

# give flatpak permission to read from the .icons folder, and set the cursor path
flatpak override --user --env=XCURSOR_PATH=~/.icons
flatpak override --user --filesystem=/home/$USER/.icons/:ro