#!/bin/sh

if [ "$(whoami)" = "root" ]; then
  echo "ERROR: cannot be root"
  exit 1
fi

# minimal
BASE="base base-devel cryptsetup dhcpcd expac git git-lfs inotify-tools libnotify linux linux-lts mkinitcpio nss-mdns rlwrap stow tmux"
FIRMWARE="amd-ucode linux-firmware"

TERMINAL="bat btop cloc eza fd fish fzf inetutils just lazygit man-db openssh plocate qmk ripgrep shellcheck tealdeer zoxide w3m"
MAIL="isync msmtp notmuch"
SECURITY="age pwgen"

# desktop
AUDIO="pipewire pipewire-jack pulseaudio pavucontrol wireplumber"
DESKTOP="foot polkit wxwidgets-gtk3"
DEV="clojure go gopls apache jdk-openjdk mariadb"
FONT="noto-fonts noto-fonts-cjk noto-fonts-emoji otf-font-awesome ttf-firacode-nerd ttf-font-awesome ttf-nerd-fonts-symbols-mono"
GPU_DRIVER="amdvlk vulkan-tools"
MEDIA="gimp yt-dlp mpv"
WAYLAND="grim slurp mako bemenu-wayland sway swaybg sway-contrib swayidle swayimg swaylock xdg-desktop-portal-gtk xdg-desktop-portal-wlr xorg-xwayland"

# shellcheck disable=SC2086
sudo pacman -S --needed \
  $BASE \
  $FIRMWARE \
  $TERMINAL \
  $MAIL \
  $SECURITY \
  $AUDIO \
  $DESKTOP \
  $DEV \
  $FONT \
  $GPU_DRIVER \
  $MEDIA \
  $WAYLAND

# gimp-git


if [ -f "$(which paru)" ]; then
    paru -S --needed \
         asdf-vm \
         brave-bin \
         exercism-bin \
         pandoc-bin \
         tailwindcss \
         rustywind \
         ruplacer \
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

# sudo systemctl enable --now avahi-daemon.service
# sudo systemctl enable --now sshd.service

sudo pacman -Syy
