#!/bin/sh

SRC="$HOME/bak/projects/dev-machine-setup/etc"

cput () {
    txt_color=$(tput setaf "$1")
    txt_reset=$(tput sgr0)
    echo "${txt_color}==========> ${2}${txt_reset}"
}

red () {
    cput 1 "$1"
}

green () {
    cput 2 "$1"
}

setup_etc_file () {
  SUBPATH="$1"
  PERMS="$2"
  if [ -f "$SRC/$SUBPATH" ]; then
    sudo cp -f "$SRC/$SUBPATH" "/etc/$SUBPATH"
    # shellcheck disable=SC2086
    sudo chmod $PERMS "/etc/$SUBPATH"
    sudo chown root:root "/etc/$SUBPATH"
  fi
}

diff_files () {
    OLD="/etc/$SUBPATH/$1"
    NEW="$SRC/$SUBPATH/$1"
    red "diffing $1"
    # sudo git diff -w --word-diff --color=always "$OLD" "$NEW"
    if ! sudo cmp "$OLD" "$NEW"; then
        sudo diff -w -d --color=always "$OLD" "$NEW"
    else
        echo "<same>"
    fi
}

if [ "$1" = "force" ]; then
    setup_etc_file hosts 644
    setup_etc_file sudoers 440
    setup_etc_file nsswitch.conf 644
else
    green "diffing...use 'force' to actually copy from bak to etc..."
    diff_files hosts
    diff_files sudoers
    diff_files nsswitch.conf
fi
