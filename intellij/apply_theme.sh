SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

7z a -tzip "$SCRIPT_DIR/Matugen-Intellij-Theme.jar" "$SCRIPT_DIR/Matugen-Intellij-Theme/*"

find ~/.local/share/JetBrains/ -name "Matugen-Intellij-Theme.jar" -exec cp "$SCRIPT_DIR/Matugen-Intellij-Theme.jar" {} \;
find ~/.local/share/Google/ -name "Matugen-Intellij-Theme.jar" -exec cp "$SCRIPT_DIR/Matugen-Intellij-Theme.jar" {} \;

echo "intellij theme copied"