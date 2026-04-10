#/bin/bash

dconf write /org/gnome/desktop/interface/font-name "'{{ okshell.font.primary }} Medium 11'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'{{ okshell.font.primary }} Medium 10'"
dconf write /org/gnome/desktop/interface/document-font-name "'{{ okshell.font.primary }} Medium 11'"
