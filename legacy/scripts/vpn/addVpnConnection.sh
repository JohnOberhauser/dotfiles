#!/usr/bin/env bash

FILE="$1"
USERNAME="$2"
PASS="$3"

usage() {
  echo "Usage: $0 [file_path] [username] [password]"
  exit 1
}

if [[ -z $FILE || -z $USERNAME || -z $PASS ]]; then
  echo "Error: Missing required parameters."
  usage
  exit 1
fi

nmcli c i type openvpn file "$1"
nmcli c mod "$(basename -s .ovpn "$1")" \
  +vpn.data "connection-type=password-tls, username=$USERNAME" \
  vpn.secrets "password=$PASS"
