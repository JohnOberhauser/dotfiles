#!/bin/bash

sudo cp $HOME/workspace/dotfiles/setup/installFiles/keyboard-wakeup.service /etc/systemd/system/

sudo systemctl enable --now keyboard-wakeup.service

sudo systemctl enable --now bluetooth.service
systemctl --user enable --now hypridle.service