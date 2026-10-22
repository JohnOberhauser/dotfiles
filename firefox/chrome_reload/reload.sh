#!/bin/sh
dir="$HOME/.local/share/firefox-nightly"

for exe in /proc/[0-9]*/exe; do
  case $(readlink "$exe" 2>/dev/null) in
    "$dir"/*) exec "$dir/firefox" --reload-userchrome ;;
  esac
done
exit 1
