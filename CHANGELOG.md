# Completed tasks and dates

- [X] Tested `set` works.
- [X] Create a non root user.
  * [X] Create a new user.
  * [X] Test user is created after reboot
- [X] Allow to override values from `custom.sh`
  * [X] Source `override_custom.sh` at the end of `custom.sh`
  * [X] Copy `override_custom.sh` from live to the system
  * [X] Tested changing user name on script
  * [X] Test user name is different after reboot
- [X] Cabled internet works after reboot
  * [X] Install dhcp client
  * [X] Test ping archlinux.org
- [X] TAB completion for bash works
  * [X] Install TAB completion
  * [X] Tested. NOT. Should be read by default.
- [X] Finish a desktop environment installation
  * [X] Sudo is usable after reboot for unprivileged user
    - [X] Install sudo
    - [X] Configure `sudo` group as run with password
    - [X] Add user to `sudo` group
    - [X] Test user can `sudo -l`
    - [X] Test user can `sudo cat /etc/sudoers`.
  * [X] Remove beeping
    - [X] Dont load `pcspkr` kernel module
    - [X] Test pressing left when logged in
  * [X] Install Xorg
    - [X] Add package to the install list
    - [X] Tested running i3
  * [X] Install Intel/nvidia drivers
    - [X] Detect which one should be installed
    - [X] Add package to list
    - [X] Test they are added to the package list
  * [X] Install DE / WM
    - [X] Install i3-wm, i3blocks, i3status, i3lock
    - [X] Install xterm as fallback terminal
    - [X] Test it starts after installing xinit
  * [X] Install a display manager
    - [X] Install lightdm with the default theme
    - [X] Test can choose i3 session
  * [X] Install `xdg-user-dirs`
    - [X] Install package
    - [X] Test directories are there after reboot
  * [X] Install web browser
    - [X] Install firefox
    - [X] Test navigate to `wiki.archlinux.org`
  * [X] Make sound work
    - [X] Install `pulseaudio`
    - [X] Install fronted GUI (`pavucontrol`)
    - [X] Install fronted TUI (`pulsemixer`)
    - [X] Test audio works in firefox with jack after unmuting
    - [X] Test gui (`pavucontrol`). Sound when changing volume.
    - [X] Test tui(`pulsemixer`). Changes sound properly.
  * [X] Configure X keyboard layout
    - [X] Set layout to es
    - [X] Enable killing Xorg with C-M-BKSP
    - [X] Enable CAPSLOCK = CTRL
    - [X] Test writing on terminal
    - [X] Test killing Xorg with C-M-BKSP
    - [X] Test CAPSLOCK = CTRL
  * [X] Install `mlocate`
  * [X] Install notification daemon
    - [X] dunst
    - [X] Test network connected notification appears after boot
    - [X] Test send notification with dunstify
    - [X] Test send notification with notify-send
  * [X] Install CUPS
    - [X] Install `cups` and `ghostscript`.
  * [X] Configure DPMS & session locking
    - [X] Lock session with xss-lock & i3lock
    - [X] Configure Standby time
    - [X] Configure Suspend time
    - [X] Configure Off time
    - [X] Configure Screensaver time
    - [X] Configure inactivity lock for before screen turns off
    - [X] Test manual lock with `loginctl lock-session`.
    - [X] Test inactivity lock
    - [X] Test system is locked after screensaver
    - [X] Test system is locked after suspend
- [X] Add installation of git to install.sh
