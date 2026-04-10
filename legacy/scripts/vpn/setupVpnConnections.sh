#!/usr/bin/env bash

# Call this script from a folder that contains the ovpn files

USERNAME="$1"
PASS="$2"

for f in  ./*.ovpn; do
  $HOME/workspace/Varda-Theme/setup/scripts/addVpnConnection.sh $f $1 $2
done
