#!/bin/sh

if [ "$(whoami)" = "root" ]; then
	echo "ERROR: cannot be root"
	exit 1
fi

# minimal
BASE="base base-devel cryptsetup dhcpcd git linux linux-lts mkinitcpio nss-mdns stow"
FIRMWARE="amd-ucode linux-firmware"

GO="go gopls" # `go-task` for alternative to `just`, `go-tools` for static analysis
TERMINAL="bat btop cloc fd fish fzf just man-db neovim nodejs openssh plocate ripgrep shellcheck tealdeer tree-sitter-cli"
MAIL="isync msmtp notmuch"
SECURITY="age pwgen"

# desktop
AUDIO="pipewire pipewire-jack pulseaudio pavucontrol wireplumber"
DESKTOP="foot polkit"
DEV="apache jdk-openjdk mariadb"
FONT="noto-fonts noto-fonts-cjk noto-fonts-emoji otf-font-awesome ttf-firacode-nerd ttf-font-awesome ttf-nerd-fonts-symbols-mono"
GPU_DRIVER="amdvlk vulkan-tools"
MEDIA="gimp yt-dlp mpv"
WAYLAND="grim slurp mako bemenu-wayland sway swaybg sway-contrib swayidle swayimg swaylock xdg-desktop-portal-gtk xdg-desktop-portal-wlr xorg-xwayland"

# shellcheck disable=SC2086
sudo pacman -S --needed \
	$BASE \
	$FIRMWARE \
	$GO \
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

# gimp-git \

if [ -f "$(which paru)" ]; then
	paru -S --needed \
			brave-bin \
			exercism-bin \
			pandoc-bin

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
