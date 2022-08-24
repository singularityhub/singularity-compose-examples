#!/bin/bash

set -eo pipefail

echo "[1/6] stopping existing instance"
sudo singularity instance stop redis || true

# (docker-compose build --no-cache equivalent) #OPTIONAL
echo "[2/6] cleaning cache and old image"
singularity cache clean -f || true

echo "[3/6] removing old sif image" #OPTIONAL
rm -f redis.sif

echo "[4/6] building sif image"
sudo singularity build redis.sif redis.def || true

echo "[5/6] spinning up a new redis instance"
sudo singularity instance start --hostname redis --writable-tmpfs --net --network-args "portmap=6379:6379/tcp" $PWD/redis.sif redis

echo "[6/6] launching redis server in background"
sudo singularity exec instance://redis redis-server --bind 0.0.0.0 --requirepass ThisIsNotAStrongPassword! &
