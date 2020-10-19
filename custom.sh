set -exu

partition_scheme='partitions.sfdisk.in'
system_device='/dev/sda'
system_device_backup='partition_table.bak'
swap_partition="$system_device"1
system_partition="$system_device"2

# Partition info
# ONLY GPT HERE RIGHT NOW
system_scheme_label='gpt'
# Boot partition
system_scheme_boot_size='200M'
system_scheme_boot_type='21686148-6449-6E6F-744E-656564454649'
system_scheme_boot_extra=',bootable'
# Should base this on 1.5 * RAM
system_scheme_swap_size='16G'
system_scheme_swap_type='S'
system_scheme_swap_extra=''
# Last partition uses rest of space
system_scheme_last_type='L'
system_scheme_last_extra=''

system_mp='/mnt'

# Required packages for the system to work
pacstrap_pkgs='base linux linux-firmware'

# Packages to instal once the system is working
# Man and info
user_pkgs='man-db man-pages texinfo'
# Windows file system drivers
user_pkgs="$user_pkgs ntfs-3g"
# Bootloader - GRUB
user_pkgs="$user_pkgs grub os-prober"
# Processor ucode updates
# !!! SELECT ONE OF THIS TWO !!!!
# TODO automatically select this
#user_pkgs="$user_pkgs amd-ucode"
user_pkgs="$user_pkgs intel-ucode"
# Vim
user_pkgs="$user_pkgs vim"
# TODO Networking
user_pkgs="$user_pkgs"

# Set timezone in format 'Region/City'
timezone='Europe/Madrid'

# Part of regex, escape characters
locale_list='es_ES\.UTF-8 en_US\.UTF-8'
# Not part of regex
locale_selected='es_ES.UTF-8'

# Same as in loadkeys
vconsole_keymap='es'

# Plain text root password
root_passwd='1234'

# Only hostname
host_name='mypc'

# Only domain name
domain_name='localdomain'
# '127.0.1.1' or externally visible IP
external_ip='127.0.1.1'
