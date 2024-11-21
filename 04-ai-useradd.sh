#!/bin/sh

useradd -m -G wheel fj

echo "now edit the sudoers file to allow wheel to use sudo"
