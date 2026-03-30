#!/bin/bash

# Define an array of valid arguments
valid_args=(
  "varda"
  "everforest"
  "nord"
  "rosepine"
  "bloodrust"
  "desertpower"
  "catppuccinfrappe"
  "catppuccinlatte"
  "catppuccinmacchiato"
  "catppuccinmocha"
)

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No argument provided."
    echo "Usage: $0 <${valid_args[*]}>"
    exit 1
fi

# Get the first argument
arg="$1"

# Check if the argument is valid
if [[ ! " ${valid_args[@]} " =~ " $arg " ]]; then
    echo "Error: Invalid argument '$arg'."
    echo "Expected: '${valid_args[*]}'."
    exit 1
fi

# set the directory to the root Varda-Theme dir
cd "$(dirname "$0")"
cd ..

kitty_theme() {
  mkdir -p ./kitty/localTheme/themes
  cp ./themes/$1/kitty/current-theme.conf ./kitty/localTheme/themes/$1.conf
  cp ./themes/$1/kitty/current-theme.conf ./kitty/
  KITTY_CONFIG_DIRECTORY=$HOME/.config/kitty/localTheme kitty +kitten themes --reload-in=all $1
}

fastfetch_theme() {
  cp ./themes/$1/fastfetch/ring.png ./fastfetch/
}

firefox_theme() {
  cp ./themes/$1/firefox/chrome/* ./firefox/chrome/
  cp ./themes/$1/firefox/startpage/* ./firefox/startpage/

  # Dark reader
  colors_file="./themes/$1/firefox/darkreader_colors"
  template_file="./firefox/startpage/darkreader/settings_template.json"
  output_file="./firefox/startpage/darkreader/settings.json"
  # Read the colors from the first file
  bg=$(grep '^bg:' "$colors_file" | cut -d':' -f2)
  fg=$(grep '^fg:' "$colors_file" | cut -d':' -f2)
  # Replace the placeholders in the second file
  sed -e "s/\${bg}/$bg/g" -e "s/\${fg}/$fg/g" "$template_file" > "$output_file"
}

cursor_theme() {
  rm -rf $HOME/.icons/systemCursor/cursors
  cp -r ./themes/$1/cursor/cursors $HOME/.icons/systemCursor/
  ./themes/setCursor.sh
}

gtk() {
  rm $HOME/.config/gtk-4.0
  rm -rf $HOME/.themes/SystemTheme/*
  dconf write /org/gnome/desktop/interface/font-name "'JetBrainsMono Nerd Font Medium 11'"
  dconf write /org/gnome/desktop/interface/monospace-font-name "'JetBrainsMono Nerd Font Medium 10'"
  dconf write /org/gnome/desktop/interface/document-font-name "'JetBrainsMono Nerd Font Medium 11'"
  ln -sf $HOME/workspace/Varda-Theme/themes/$1/gtk/gtk-4.0 $HOME/.config/
  cp -r $HOME/workspace/Varda-Theme/themes/$1/gtk/* $HOME/.themes/SystemTheme/
  dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
  dconf write /org/gnome/desktop/interface/gtk-theme "'SystemTheme'"
  flatpak override --user --env=GTK_THEME=SystemTheme
}

hypr() {
  COLORS_FILE="./themes/$1/hypr/hypr_colors"
  # Read the colors from the first file
  BG=$(grep '^bg:' "$COLORS_FILE" | cut -d':' -f2)
  FG=$(grep '^fg:' "$COLORS_FILE" | cut -d':' -f2)
  PRIMARY=$(grep '^primary:' "$COLORS_FILE" | cut -d':' -f2)
  ERROR=$(grep '^error:' "$COLORS_FILE" | cut -d':' -f2)

  # Hyprland theme
  THEME_TEMPLATE="./hypr/conf/theme_template.conf"
  THEME_OUTPUT="./hypr/conf/theme.conf"
  # Replace the placeholders in the second file
  sed -e "s|\${bg}|$BG|g" -e "s|\${fg}|$FG|g" -e "s|\${primary}|$PRIMARY|g" -e "s|\${error}|$ERROR|g" "$THEME_TEMPLATE" > "$THEME_OUTPUT"
}

zsh_theme() {
  cp ./themes/$1/zsh/* ./zsh/
}

btop_theme() {
  mkdir -p $HOME/.config/btop/themes
  ln -sf $HOME/workspace/Varda-Theme/themes/$1/btop/$1.theme $HOME/.config/btop/themes/
  sed -i "s|color_theme = \".*\"|color_theme = \"$HOME/.config/btop/themes/$1.theme\"|" $HOME/.config/btop/btop.conf
  pkill -SIGUSR2 btop
}

intellij_idea() {
  # must have themes already installed
  BASE_DIR="$HOME/.config/JetBrains/"
  # Get the most recent directory based on modification time
  RECENT_DIR=$(ls -lt "$BASE_DIR" | grep Intelli | grep '^d' | head -n 1 | awk '{print $9}')
  # the scheme name is capitalized theme name
  SCHEME=$(echo "$1" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
  sed -i "s/<global_color_scheme name=\".*\" \/>/<global_color_scheme name=\"$SCHEME\" \/>/" "$BASE_DIR/$RECENT_DIR/options/colors.scheme.xml"
  sed -i "s/<laf themeId=\".*\" \/>/<laf themeId=\"io.obez.themes.$1\" \/>/" "$BASE_DIR/$RECENT_DIR/options/laf.xml"
}

android_studio() {
  # must have themes already installed
  BASE_DIR="$HOME/.config/Google/"
  # Get the most recent directory based on modification time
  RECENT_DIR=$(ls -lt "$BASE_DIR" | grep Android | grep '^d' | head -n 1 | awk '{print $9}')
  # the scheme name is capitalized theme name
  SCHEME=$(echo "$1" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
  sed -i "s/<global_color_scheme name=\".*\" \/>/<global_color_scheme name=\"$SCHEME\" \/>/" "$BASE_DIR/$RECENT_DIR/options/colors.scheme.xml"
  sed -i "s/<laf themeId=\".*\" \/>/<laf themeId=\"io.obez.themes.$1\" \/>/" "$BASE_DIR/$RECENT_DIR/options/laf.xml"
}

darktable() {
  mkdir -p $HOME/.config/darktable/
  cp ./themes/$1/darktable/user.css $HOME/.config/darktable/
}

# Immediately visible first
echo "hypr"
hypr $1
echo "kitty"
kitty_theme $1
echo "btop"
btop_theme $1
echo "cursor"
cursor_theme $1
echo "gtk"
gtk $1

# Then the rest
#echo "fastfetch"
#fastfetch_theme $1
echo "firefox"
firefox_theme $1
echo "zsh"
zsh_theme $1
echo "intellij"
intellij_idea $1
echo "android studio"
android_studio $1
echo "darktable"
darktable $1
