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

get_graphics_driver_pkgs(){
    local graphics_card=$(lspci | grep -e VGA -e 2D -e 3D)
    local driver=''

    $(echo "$graphics_card" | grep -q -e 'Intel') && \
        driver='xf86-video-intel'

    $(echo "$graphics_card" | grep -q -e 'NVIDIA') && \
        driver="$driver" "$nvidia_driver"

    # !!!!!! Not tested!!!!
    $(echo "$graphics_card" | grep -q -e 'ATI') && \
        driver="$driver" 'xf86-video-ati'

    # !!!!!! Not tested!!!!
    $(echo "$graphics_card" | grep -q -e 'AMD') && \
        driver="$driver" 'xf86-video-amdgpu'

    printf '%s' "$driver"
}

# Add graphics driver
graphics_driver=$(get_graphics_driver_pkgs)
user_pkgs="$user_pkgs $graphics_driver"

# Install packages
pacman -Syu --noconfirm $user_pkgs

### Sudo config ###
# Adding sudo group config
echo "# Members of group sudo can execute anything with their password" >/etc/sudoers.d/20_sudo_group
echo "%sudo	ALL=(ALL) ALL" >>/etc/sudoers.d/20_sudo_group
# Fixing permissions
chmod 440 /etc/sudoers.d/20_sudo_group

# Creating sudo group
groupadd sudo

# Adding user to sudo group
usermod -aG sudo "$new_user_name"

### Removing beeping ###
echo 'blacklist pcspkr' >> /etc/modprobe.d/nobeep.conf

### Configuring Xorg keyboard ###

cat <<EOF > /etc/X11/xorg.conf.d/00-keyboard.conf
# Created by install script on $(date)
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "es"
        Option "XkbModel" "pc104"
        Option "XkbOptions" "caps:ctrl_modifier,terminate:ctrl_alt_bksp"
EndSection
EOF

### Configuring dunst ###
# Nothing here

systemctl enable NetworkManager
systemctl enable lightdm
systemctl enable org.cups.cupsd.service

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
