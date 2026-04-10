#!/bin/bash

mkdir -p $HOME/Pictures
mkdir -p $HOME/Pictures/Screenshots
mkdir -p $HOME/Videos
mkdir -p $HOME/Videos/ScreenRecordings

rm -rf ~/.config/hypr
ln -sf $HOME/workspace/dotfiles/hypr $HOME/.config/
touch $HOME/.config/hypr/conf/font.conf
touch $HOME/.config/hypr/conf/theme.conf

ln -sf $HOME/workspace/dotfiles/kitty $HOME/.config/

ln -sf $HOME/workspace/dotfiles/nvim $HOME/.config/

ln -sf $HOME/workspace/dotfiles/fastfetch $HOME/.config/

ln -sf $HOME/workspace/dotfiles/yazi $HOME/.config/

ln -sf $HOME/workspace/dotfiles/spotify-player/ $HOME/.config/

ln -sf $HOME/workspace/dotfiles/matugen $HOME/.config/

ln -sf $HOME/workspace/dotfiles/kvantum/Kvantum $HOME/.config/

ln -sf $HOME/workspace/dotfiles/gitui $HOME/.config/

ln -sf $HOME/workspace/dotfiles/zsh/zshrc $HOME/.zshrc

ln -sf $HOME/workspace/dotfiles/zsh/varda.zsh-theme $HOME/.config/oh-my-zsh/themes/