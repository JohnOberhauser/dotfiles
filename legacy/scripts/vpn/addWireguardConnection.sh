#!/usr/bin/env bash

FILE="$1"

usage() {
  echo "Usage: $0 [file_path]"
  exit 1
}

if [[ -z $FILE ]]; then
  echo "Error: Missing required parameters."
  usage
  exit 1
fi

nmcli c i type wireguard file "$1"

# disable auto connect
CON_NAME=$(basename "$FILE" .conf)
nmcli c modify "$CON_NAME" connection.autoconnect no