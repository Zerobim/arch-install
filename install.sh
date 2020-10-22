#!/bin/bash
out_file='install.out'
err_file='install.err'

pacman -Sy --noconfirm git
git clone 'https://github.com/Zerobim/arch-install.git'
cd arch-install
git checkout dev

./run_in_live.sh 2>"$err_file" | tee "$out_file"
