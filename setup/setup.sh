#!/bin/bash

./scripts/install.sh
./scripts/installFirefoxNightly.sh
./scripts/installYay.sh
./scripts/installFonts.sh
./scripts/installOhMyZsh.sh
./scripts/setupFoldersAndSymLinks.sh
./scripts/startServices.sh
./scripts/setupUfw.sh
./scripts/setupCursor.sh
./scripts/setupTheme.sh
./scripts/setupYazi.sh
./scripts/setupXdgOpen.sh
./scripts/setupTuigreet.sh

# things left to do
#
# Install system wide wireguard vpn
#
# Firefox:
# sym link user chrome directory and the user.js file
# install custom dark reader
#
# intellij:
# set font
# install matugen.jar theme plugin
#
# remove extra packages from archinstall
# wofi, dolphin, sddm (make sure you set up tuigreet first)