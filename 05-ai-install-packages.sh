#!/bin/bash

if [ "$(whoami)" = "root" ]; then
  echo "ERROR: cannot be root"
  exit 1
fi

# minimal
BASE="base base-devel cryptsetup dhcpcd expac git git-lfs inotify-tools libnotify linux linux-lts mkinitcpio nss-mdns rlwrap stow tmux"
FIRMWARE="amd-ucode linux-firmware"

TERMINAL="bat btop cloc eza fd fish fzf inetutils just man-db openssh plocate qmk ripgrep shellcheck tealdeer zoxide w3m"
MAIL="isync msmtp notmuch"
SECURITY="age pwgen"

# desktop
AUDIO="pipewire pipewire-jack pulseaudio pavucontrol wireplumber"
DBOX="crun distrobox fuse-overlayfs podman"
DESKTOP="ghostty polkit wxwidgets-gtk3"
FONT="noto-fonts noto-fonts-cjk noto-fonts-emoji otf-font-awesome ttf-firacode-nerd ttf-font-awesome ttf-nerd-fonts-symbols-mono"
GPU_DRIVER="amdvlk vulkan-tools"
MEDIA="gimp yt-dlp mpv"
PRINTER="cups avahi nss-mdns gtk3 dbus-python python-gobject ghostscript hplip"
WAYLAND="grim slurp mako bemenu-wayland sway swaybg sway-contrib swayidle swayimg swaylock xdg-desktop-portal-gtk xdg-desktop-portal-wlr xorg-xwayland"

DEV="go"
DEV+=" clojure netbeans intellij-idea-community-edition jdk-openjdk wmname maven" # java/clojure
DEV+=" apache mariadb" # misc

# shellcheck disable=SC2086
sudo pacman -S --needed \
  $BASE \
  $FIRMWARE \
  $TERMINAL \
  $MAIL \
  $SECURITY \
  $AUDIO \
  $DBOX \
  $DESKTOP \
  $FONT \
  $GPU_DRIVER \
  $MEDIA \
  $PRINTER \
  $WAYLAND \
  $DEV

if [ -f "$(which paru)" ]; then
    paru -S --needed \
         asdf-vm \
         brave-bin \
         exercism-bin \
         pandoc-bin \
         tailwindcss \
         ruplacer \
         tartube \
         tmuxinator \
         wl-color-picker


  # it asks to review package build even if no updates are needed
  # so just don't even ask me...
  if ! [ -f "$(which passage)" ]; then
      paru -S --needed passage-git
  fi

else
  sudo pacman -S --needed base-devel
  cd /tmp || exit 1
  git clone https://aur.archlinux.org/paru.git
  cd paru || exit 1
  makepkg -si
fi

sudo systemctl enable --now avahi-daemon
sudo systemctl enable --now cups
# sudo systemctl enable --now sshd.service

sudo pacman -Syy
