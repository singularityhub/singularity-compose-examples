#!/bin/bash

# Grab a development node to run this on
# srun --time 24:00 --mem 32000 --pty bash

# cd into the folder of the script
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $here

# Download the original data to the host
if [ ! -f "restaurant.json" ]; then
    wget https://raw.githubusercontent.com/ozlerhakan/mongodb-json-files/master/datasets/restaurant.json
fi
