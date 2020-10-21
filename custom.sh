set -exu

# File which overrides defaults
custom_override_file='custom_override.sh'

partition_scheme='partitions.sfdisk.in'
system_device='/dev/sda'
system_device_backup='partition_table.bak'
boot_partition="$system_device"1
swap_partition="$system_device"2
system_partition="$system_device"3

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

# New user info
new_user_name='john'
new_user_password='1234'

# Packages to install once the system is working

# Man and info
user_pkgs='man-db man-pages texinfo'

# Windows file system drivers
user_pkgs="$user_pkgs ntfs-3g"

# Bootloader - GRUB
user_pkgs="$user_pkgs grub os-prober"

# Processor ucode updates
# !!! SELECT ONE OF THIS TWO !!!!
#user_pkgs="$user_pkgs amd-ucode"
user_pkgs="$user_pkgs intel-ucode"

# Vim
user_pkgs="$user_pkgs vim"

# Networking
# Network Manager is kind of overkill, but it works.
user_pkgs="$user_pkgs networkmanager"
# Graphical goodies for network manager
user_pkgs="$user_pkgs nm-connection-editor network-manager-applet"

# Bash completion
user_pkgs="$user_pkgs bash-completion"

# Sudo
user_pkgs="$user_pkgs sudo"

# Xorg
user_pkgs="$user_pkgs xorg"

# Graphics driver Nvidia driver from official repos. Only used if the card is
# from nvidia.
nvidia_driver='nvidia'

# Fallback terminal
user_pkgs="$user_pkgs xterm"

# I3-wm
user_pkgs="$user_pkgs i3-wm i3blocks i3status"

# Display manager
user_pkgs="$user_pkgs lightdm lightdm-gtk-greeter"

# Sound server
user_pkgs="$user_pkgs pulseaudio pulseaudio-alsa pavucontrol pulsemixer"

# Web browser
user_pkgs="$user_pkgs firefox"

# Notification daemon
user_pkgs="$user_pkgs libnotify dunst"

# File finder
user_pkgs="$user_pkgs mlocate"

# Printing service
user_pkgs="$user_pkgs cups cups-pdf ghostscript"

# Override defaults here
[ -r ./"$custom_override_file" ] && \
    . ./"$custom_override_file" || \
    echo "Didn't find customization file $custom_override_file"
