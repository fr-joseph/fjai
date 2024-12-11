#!/bin/sh

HOST=$(hostnamectl hostname)
NAME="${USER}@${HOST}"

if ! [ -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "$NAME"
else
  echo "---> ~/.ssh/id_ed25519 already exists"
fi

if ! [ -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096 -C "$NAME"
else
  echo "---> ~/.ssh/id_ed25519 already exists"
fi

D="$HOME/bak/projects/dev-machine-setup/$HOST"
if ! [ -d "$D/.ssh" ]; then
  mkdir -p "$D"
  cp -r ~/.ssh "$D"
else
  echo "---> $D/.ssh already exists"
fi

echo "now upload ssh key to git forges, and run backup process to copy ~/.ssh to ~/bak"
# echo "now upload new ssh pubkey to git forges and local servers (copied to clipboard)"
# wl-copy < ~/.ssh/id_ed25519.pub
