SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$SCRIPT_DIR/build_cursor.sh"
"$SCRIPT_DIR/build_cursor.sh"

# copy the new files
rm -rf $HOME/.local/share/icons/systemCursor/cursors
cp -r $SCRIPT_DIR/Nordzy-cursors/xcursors/systemCursor/cursors $HOME/.local/share/icons/systemCursor/

# set the new theme
size=24

dummyTheme=dummyCursor
hyprctl setcursor $dummyTheme $size
gsettings set org.gnome.desktop.interface cursor-theme $dummyTheme
gsettings set org.gnome.desktop.interface cursor-size $size

xrdb -merge <<< "Xcursor.theme: $dummyTheme"
xrdb -merge <<< "Xcursor.size: $size"

theme=systemCursor

hyprctl setcursor $theme $size
gsettings set org.gnome.desktop.interface cursor-theme $theme
gsettings set org.gnome.desktop.interface cursor-size $size

xrdb -merge <<< "Xcursor.theme: $theme"
xrdb -merge <<< "Xcursor.size: $size"