#!/bin/sh

# minimal
BASE="base base-devel cryptsetup dhcpcd git linux linux-lts mkinitcpio nss-mdns"
FIRMWARE="amd-ucode linux-firmware"

# core
TERMINAL="bat btop fd fzf just man-db openssh plocate ripgrep shellcheck tealdeer"
MAIL="isync msmtp notmuch"
SECURITY="age pwgen"

# desktop
AUDIO="pipewire pipewire-jack pulseaudio pavucontrol wireplumber"
DESKTOP="foot polkit"
FONT="noto-fonts noto-fonts-cjk noto-fonts-emoji otf-font-awesome ttf-firacode-nerd ttf-font-awesome ttf-nerd-fonts-symbols-mono"
GPU_DRIVER="amdvlk vulkan-tools"
MEDIA="yt-dlp mpv"
WAYLAND="grim slurp mako bemenu-wayland sway swaybg sway-contrib swayidle swayimg swaylock xdg-desktop-portal-gtk xdg-desktop-portal-wlr xorg-xwayland"
WEB="apache mariadb"

sudo pacman -S --needed \
  $BASE \
  $FIRMWARE \
  $TERMINAL \
  $MAIL \
  $SECURITY \
  $AUDIO \
  $DESKTOP \
  $FONT \
  $GPU_DRIVER \
  $MEDIA \
  $WAYLAND \
  $WEB

if [ -f "$(which paru)" ]; then
  paru -S --needed \
    brave-bin \
    gimp-git \
    passage-git
else
  sudo pacman -S --needed base-devel
  cd /tmp
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
fi

sudo systemctl enable --now avahi-daemon.service
# sudo systemctl enable --now sshd.service

sudo pacman -Syy

