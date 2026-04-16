#!/bin/bash

cp -r $HOME/workspace/dotfiles/setup/installFiles/cursor/* $HOME/.local/share/icons/

# give flatpak permission to read from the .icons folder, and set the cursor path
flatpak override --user --env=XCURSOR_PATH=~/.local/share/icons
flatpak override --user --filesystem=/home/$USER/.local/share/icons/:ro