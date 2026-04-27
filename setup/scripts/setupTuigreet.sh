#!/bin/bash

# Greetd
sudo cp $HOME/workspace/dotfiles/tuigreet/greetd/config.toml /etc/greetd/

# make sure other DMs are disabled
sudo systemctl disable gdm
sudo systemctl disable sddm
sudo systemctl enable --now greetd

# Virtual terminal colors
sudo cp $HOME/workspace/dotfiles/tuigreet/initcpio/hooks/setvtrgb /usr/lib/initcpio/hooks/
sudo cp $HOME/workspace/dotfiles/tuigreet/initcpio/install/setvtrgb /usr/lib/initcpio/install/
sudo cp $HOME/workspace/dotfiles/tuigreet/initcpio/install/sd-setvtrgb /usr/lib/initcpio/install/
sudo cp $HOME/workspace/dotfiles/tuigreet/vtrgb/vtrgb /etc/

# Virtual terminal colors, resolution, and plymouth
sudo cp $HOME/workspace/dotfiles/tuigreet/mkinitcpio/mkinitcpio.conf /etc/
sudo mkinitcpio -P