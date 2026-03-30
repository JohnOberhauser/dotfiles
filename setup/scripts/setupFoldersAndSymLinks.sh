#!/bin/bash

mkdir -p $HOME/Pictures
mkdir -p $HOME/Pictures/Screenshots
mkdir -p $HOME/Videos
mkdir -p $HOME/Videos/ScreenRecordings

rm -rf ~/.config/hypr
ln -s $HOME/workspace/Varda-Theme/hypr $HOME/.config/
touch $HOME/.config/hypr/conf/monitors.conf

#mkdir -p $HOME/.config/btop/themes

#mkdir -p $HOME/.themes/SystemTheme
#mkdir -p $HOME/.config/gtk-4.0
#ln -s $HOME/workspace/Varda-Theme/gnome/themes/Varda/gtk-4.0 $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/kitty $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/nvim $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/fastfetch $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/yazi $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/spotify-player/ $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/OkPanel/desktop/OkPanel $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/okshell $HOME/.config/

ln -s $HOME/workspace/Varda-Theme/matugen $HOME/.config/