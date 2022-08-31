#!/bin/bash

set -eo pipefail

echo "[1/8] stopping existing instance"
singularity-compose stop || true

echo "[2/8] copy config to usr folder"
sudo cp 50_redis.conflist /usr/local/etc/singularity/network/50_redis.conflist

# (docker-compose build --no-cache equivalent) #OPTIONAL
echo "[3/8] cleaning cache and old image"
singularity cache clean -f || true

echo "[4/8] removing old sif image" #OPTIONAL
rm -f redis.sif

echo "[5/8] removing etc.hosts and resolv.conf"
rm -f etc.hosts
rm -f resolv.conf

echo "[7/8] building new instance"
singularity-compose build

echo "[7/8] running singularity-compose"
singularity-compose --debug up -d

echo "[8/8] show instances"
singularity-compose ps

printf "\n"
echo "NOTE: to recover original configuration setup and delete new configuration run:"
echo "sudo rm -f /usr/local/etc/singularity/network/50_redis.conflist"
