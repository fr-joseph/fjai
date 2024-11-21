#!/bin/sh

# ==========================================================
# variables

HOSTNAME="myr"
REGION="America"
CITY="Denver"

# ==========================================================
# message

cput () {
    txt_color=$(tput setaf "$1")
    txt_reset=$(tput sgr0)
    echo "${txt_color}==========> ${2}${txt_reset}"
}

cput_red () {
    cput 1 "$1"
}

cput_green () {
    cput 2 "$1"
}

# ==========================================================
cput_red "locale"

# timedatectl set-timezone "$REGION/$CITY"
# timedatectl set-ntp on
ln -sf /usr/share/zoneinfo/"$REGION"/"$CITY" /etc/localtime
# hardware clock should be in UTC
hwclock --systohc --utc

sed -i 's|#en_US.UTF-8|en_US.UTF-8|' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "$HOSTNAME" > /etc/hostname

# ==========================================================
cput_red "mkinitcpio"

# https://wiki.archlinux.org/title/Mkinitcpio#HOOKS
cp /fjai/mkinitcpio.conf /etc/mkinitcpio.conf && chmod 644 /etc/mkinitcpio.conf
mkinitcpio -P

# ==========================================================
cput_red "root passwd"
passwd

# ==========================================================
cput_red "install systemd-boot"
bootctl --esp-path=/efi --boot-path=/boot install

# ==========================================================
cput_red "enable services"

systemctl enable dhcpcd

# ==========================================================
cput_red 'edit bootloader & reboot'

echo "edit your bootloader config, check with 'bootctl'"
echo "(get the UUIDs from blkid, see example arch.conf)"
echo "exit chroot, and reboot"
echo ""
cput_green "
  vim /efi/loader/loader.conf

  ./fjai/03-ai-bootloader-conf.sh
  cd /boot/loader/entries/
  vim arch.conf
  cp arch.conf arch-lts.conf
  vim arch-lts.conf
  # add '-lts' to the relevant lines

  bootctl
  exit
  reboot"

# example:
# edit /efi/loader/loader.conf to say:
# "default arch
# timeout 3"

