#!/bin/bash
out_file='install.out'
err_file='install.err'

./run_in_live.sh 2>"$err_file" | tee "$out_file"
