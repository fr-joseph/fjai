#!/bin/bash

cd

mkdir -p \
  ~/.certs \
  ~/.trash \
  ~/.mail \
  ~/big-files \
  ~/videos \
  ~/mnt/usb \
  ~/src \
  ~/tmp

link_dir () {
  SRC="$HOME/bak/$1"
  NAME="$2"
  ln -sf -T "$SRC" "$NAME"
}

link_bak_dir () {
  link_dir "$1" "$1"
}

if [ -d ~/bak ]; then
  link_bak_dir bin
  link_bak_dir church
  link_bak_dir latex-projects
  link_bak_dir notes
  link_bak_dir projects
  link_dir "passwords/passage" ".passage"
else
  echo "ERROR: ~/bak does not exist"
  exit 1
fi

# remove stow conflicts, if file is not symlink
# (files originally created by fresh OS install)
if ! [ -h ~/.config/user-dirs.dirs ]; then
  rm -f ~/.config/user-dirs.dirs
fi

STOW_SRC="$HOME/bak/projects/dev-machine-setup"
if [ -d "$STOW_SRC/dotfiles" ]; then
  cd "$STOW_SRC" || exit 1
  stow --dotfiles -v 1 -d ./dotfiles -t "$HOME" .
  # stow --delete
  # stow --restow
  # stow --adopt
else
  echo "ERROR: $STOW_SRC does not exist"
  exit 1
fi

# remove old XDG dirs
rmdir ~/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos} 2>/dev/null
