#!/bin/sh

CONF=/boot/loader/entries/arch.conf
cp /fjai/arch.conf "$CONF"
echo "" >> "$CONF"
echo "" >> "$CONF"
blkid /dev/nvme0n1p3 | cut -d' ' -f2 | cut -d'"' -f2 >> "$CONF"
blkid /dev/mapper/main | cut -d' ' -f3 | cut -d'"' -f2 >> "$CONF"
