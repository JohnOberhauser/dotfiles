#/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

magick -background none $SCRIPT_DIR/favicon.svg -define icon:auto-resize=64,48,32,16 $SCRIPT_DIR/favicon.ico