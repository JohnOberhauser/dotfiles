#!/bin/bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -s $HOME/workspace/dotfiles/zsh/varda.zsh-theme $HOME/.oh-my-zsh/themes/
ln -s $HOME/workspace/dotfiles/zsh/theme.zsh $HOME/.oh-my-zsh/themes/
ln -s $HOME/workspace/dotfiles/zsh/zshrc $HOME/.zshrc