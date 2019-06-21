#!/bin/bash

# Grab a development node to run this on
# srun --time 24:00 --mem 32000 --pty bash

# cd into the folder of the script
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $here

# Download the original data to the host
if [ ! -f "venmo.tar.xz" ]; then

    # https://github.com/sa7mon/venmo-data
    # Takes a while.
    wget https://d.badtech.xyz/venmo.tar.xz

    # Extract into the folder, creates test folder with data
    tar xf venmo.tar.xz
fi
