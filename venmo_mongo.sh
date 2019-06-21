#!/bin/bash

# Grab a development node to run this on
# srun --time 24:00 --mem 32000 --pty bash

# Create folder on scratch to work in
mkdir -p $SCRATCH/venmo
cd $SCRATCH/venmo

# https://github.com/sa7mon/venmo-data
# Takes a while.
wget https://d.badtech.xyz/venmo.tar.xz

# Extract into the folder, creates test folder with data
tar xf venmo.tar.xz

# Pull Singularity container for mongodb
singularity pull docker://mongo

# Create subfolders for mongodb to write data on the host
mkdir -p data/db data/configdb

# Shell into the container, binding data to /data
singularity shell --bind data:/data mongo_latest.sif

# Start the mongo daemon
mongod &

# cd into the "dump/test" folder that was exported (venmo.bson is here)
cd dump/test

# Restore the data
mongorestore --collection venmo --db test venmo.bson
