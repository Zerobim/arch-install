#!/bin/bash
# Source configuration variables
. ./custom.sh

# Set timezone
ln -sf /usr/share/zoneinfo/"$timezone" /etc/localtime

# Sync HW clock
hwclock --systohc

# Set locale
uncomment_locales(){
    local locale_list="$@"
    local locale_list_regexp=''
    local locale_list_regexp_separator=''

    for i_locale in $locale_list;
    do
        locale_list_regexp="$locale_list_regexp""$locale_list_regexp_separator"
        locale_list_regexp_separator='\|'

        locale_list_regexp="$locale_list_regexp""\($i_locale.*\)"
    done

    locale_regexp=$(printf 's/#\(%s\)$/\\1/' "$locale_list_regexp"  )

    sed -i "$locale_regexp" /etc/locale.gen
}

uncomment_locales "$locale_list"
locale-gen

echo "LANG=$locale_selected" >/etc/locale.conf

# Set vconsole keymap
echo "KEYMAP=$vconsole_keymap" >/etc/vconsole.conf

# Change root password
printf 'root:%s\n' "$root_passwd" |\
    chpasswd

# Set hostname
echo "$host_name" >/etc/hostname

# Build hosts file
cat <<EOF >/etc/hosts
127.0.0.1     localhost
::1           localhost
$external_ip  $host_name.$domain_name  $host_name
EOF

# Create a new unprivileged user
useradd -m "$new_user_name"
printf '%s:%s\n' "$new_user_name" "$new_user_password" |\
    chpasswd

pacman -Syu --noconfirm $user_pkgs

### Sudo config ###
# Adding sudo group config
echo "Members of group sudo can execute anything with their password" >/etc/sudoers.d/20_sudo_group
echo "%sudo	ALL=(ALL) ALL" >>/etc/sudoers.d/20_sudo_group
# Fixing permissions
chmod 440 /etc/sudoers.d/20_sudo_group

# Creating sudo group
groupadd sudo

# Adding user to sudo group
usermod -aG sudo "$new_user_name"

systemctl enable NetworkManager

# MBR/GPT only
grub-install --target=i386-pc "$system_device"
# Configure
cat <<EOF >>/boot/grub/custom.cfg
menuentry "Shutdown" {
	echo "Powering off..."
	halt
}

menuentry "Reboot" {
	echo "Rebooting..."
	reboot
}
EOF

grub-mkconfig -o /boot/grub/grub.cfg

echo 'Finished configuring system'
