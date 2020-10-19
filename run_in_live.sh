#!/bin/bash
# Source configuration variables
. ./custom.sh

# Remove module so no beeps
rmmod pcspkr || echo 'No beeps removed'

# Load keyboard configuration.
loadkeys es

# Detect boot mode
boot_mode=$(ls /sys/firmware/efi/efivars 1>/dev/null && printf 'UEFI' || printf 'BIOS')
printf 'Boot mode is %s\n' "$boot_mode"

# Utilities
boot_mode_is_bios(){
    return [ "$boot_mode" = "BIOS" ]
}
boot_mode_is_uefi(){
    return [ "$boot_mode" = "UEFI" ]
}

# Check ip is set
ip a
# Connectivity check
ping -c 1 archlinux.org

# Use timedatectl to ensure the system clock is accurate
timedatectl set-ntp true
# Check the service status
timedatectl status

# !!!!!!!!!!! WARNING !!!!!!!!!!!!!
# !! Only works with BIOS/GPT  !!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Backup $system_device
sfdisk --dump "$system_device" >"$system_device_backup"$(date -I'ns')
# Restore with:
# sfdisk "$system_device" <"$system_device_backup"

# Partition disks
echo "label: $system_scheme_label" >"$partition_scheme"
echo '' >>"$partition_scheme"
printf "size=%s,type=%s%s\n" \
    "$system_scheme_boot_size" \
    "$system_scheme_boot_type" \
    "$system_scheme_boot_extra" \
    >>"$partition_scheme"

printf "size=%s,type=%s%s\n" \
    "$system_scheme_swap_size" \
    "$system_scheme_swap_type" \
    "$system_scheme_swap_extra" \
    >>"$partition_scheme"

printf "type=%s%s\n" \
    "$system_scheme_last_type" \
    "$system_scheme_last_extra" \
    >>"$partition_scheme"

sfdisk "$system_device" <"$partition_scheme"

mkswap "$swap_partition"
mkfs.ext4 "$system_partition"

# Enable swap
swapoff "$swap_partition" || swapon "$swap_partition"
# Mount system
umount "$system_mp" || mount "$system_partition" "$system_mp"

# Install required packages
pacstrap "$system_mp" $pacstrap_pkgs

# Generate fstab from live environment
genfstab -U /mnt >> /mnt/etc/fstab

# Copy script to new system
cp custom.sh run_in_system.sh /mnt/root/
# Enter system and run script
arch-chroot /mnt /root/run_in_system.sh
