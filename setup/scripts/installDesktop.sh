rustup default stable

cd $HOME/workspace/

git clone https://github.com/JohnOberhauser/OkShell.git
git clone https://github.com/JohnOberhauser/Wallpaper.git

/home/john/workspace/OkShell/install.sh

# Add cargo bins to path
PROFILE="$HOME/.profile"
LINE='export PATH="$PATH:$HOME/.cargo/bin"'

# Create .profile if it doesn't exist
touch "$PROFILE"

# Only add if not already present
if ! grep -qF "$LINE" "$PROFILE"; then
    echo "$LINE" >> "$PROFILE"
    echo "Added to $PROFILE"
else
    echo "Already present in $PROFILE, skipping"
fi