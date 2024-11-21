#!/bin/sh

# ==========================================================
# notes

# systemd-boot, XBOOTLDR, separate /boot and /efi
#   https://wiki.archlinux.org/title/Systemd-boot#Installation_using_XBOOTLDR

# ==========================================================
# variables

# DISK=/dev/vda
DISK=/dev/nvme0n1
CRYPT="main"

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

read -p "Are you sure you want to reformat $DISK? (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then

# ==========================================================
cput_red "partition"

# -Z zap all
# ef00 EFI system partition
# ea00 XBOOTLDR partition
# 8200 Linux swap
# 8300 Linux filesystem

# unmount everything, just in case (force, all, recursive)
cd /
umount -fAR /mnt
cryptsetup close "$CRYPT"
umount -fAR "$DISK"1
umount -fAR "$DISK"2
umount -fAR "$DISK"3

wipefs --all "$DISK"
       
# -n 0:0:+4G      -c 0:SWAP  -t 0:8200 \

sgdisk -Z \
       -n 0:2048:+100M -c 0:EFI   -t 0:ef00 \
       -n 0:0:+1G      -c 0:BOOT  -t 0:ea00 \
       -n 0:0:0        -c 0:LINUX -t 0:8300 \
       -G "$DISK"

# inform kernel of partition table changes, without rebooting
partprobe "$DISK"

# done using the whole drive name, only use partitions going forward
# so if nvme, fix the name formatting
if echo "$DISK" | grep -q "nvme"
then
    DISK="${DISK}p"
fi

# ==========================================================
cput_red "luks"

cryptsetup -v --use-random --type luks2 --hash sha512 luksFormat "$DISK"3
cryptsetup luksDump "$DISK"3
cryptsetup open "$DISK"3 "$CRYPT"

# ==========================================================
cput_red "mkfs"

mkfs.vfat -F 32 -n "EFI" "$DISK"1
mkfs.vfat -F 32 -n "BOOT" "$DISK"2
mkfs.ext4 -L "MAIN" "/dev/mapper/$CRYPT"

# ==========================================================

cput_red "mount"

mkdir -p /mnt
mount "/dev/mapper/$CRYPT" /mnt

mkdir -p /mnt/{boot,efi,fj}
mount -o umask=0077 "$DISK"1 /mnt/efi
mount -o umask=0077 "$DISK"2 /mnt/boot

mkswap -U clear --size 8G --file /mnt/swapfile
swapon /mnt/swapfile

# ==========================================================
cput_red "check CPU"

CPU_FIRMWARE=""

if lscpu | grep "Model name:" | grep -q "Intel"
then
    CPU_FIRMWARE="intel-ucode"
fi

if lscpu | grep "Model name:" | grep -q "AMD"
then
    CPU_FIRMWARE="amd-ucode"
fi

# ==========================================================
cput_red "pacstrap"

# sync package DBs
pacman -Syy

# install packages, interactive confirmation
pacstrap -Ki /mnt \
         base \
         base-devel \
         linux \
         linux-lts \
         linux-firmware \
         iptables-nft \
         "$CPU_FIRMWARE" \
         vim \
         git \
         dhcpcd \
         openssh \
         mkinitcpio \
         cryptsetup

# pick iptables-nft over iptables
# linux-headers linux-lts-headers
# bash-completion

# ==========================================================
cput_red "fstab"

genfstab -U /mnt > /mnt/etc/fstab

# ==========================================================
cput_red "chroot"

cp -r /root/fjai /mnt

echo "now run the following:"
echo ""
cput_green "
  arch-chroot /mnt
  ./fjai/02-ai-chroot.sh"

# end of "are you sure..."
fi
