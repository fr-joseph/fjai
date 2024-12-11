#!/bin/sh

HOST=$(hostnamectl hostname)

ID="$HOME/.ssh/id_rsa.pub"

ssh-copy-id -i "$ID" dsadmin@dormition
ssh-copy-id -i "$ID" root@dormition
ssh-copy-id -i "$ID" frpeter@dormition

ssh-copy-id -i "$ID" root@archive.ds

# --------------------------------------------

ID="$HOME/.ssh/id_ed25519.pub"

if [ "$HOST" != "myr" ]; then
    ssh-copy-id -i "$ID" fj@myr
fi

if [ "$HOST" != "salt" ]; then
    ssh-copy-id -i "$ID" fj@salt
fi

ssh-copy-id -i "$ID" dsadmin@baptist

# ssh-copy-id -i "$ID" root@ionos
ssh-copy-id -i "$ID" ubuntu@ionos
