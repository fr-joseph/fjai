#!/bin/sh

# ==========================================================
# copy the files over to the computer you are setting up

scp \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    00-ai-main.sh \
    01-ai-main.sh \
    02-ai-chroot.sh \
    mkinitcpio.conf \
    arch.conf \
    root@archiso.local:/root/
