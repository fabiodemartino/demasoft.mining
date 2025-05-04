#!/bin/bash
set -e

# Ensure the latest version of cpuminer is pulled and built
echo "[*] Building cpuminer-opt..."
cd /cpuminer
git pull
./build.sh

echo "[*] Starting cpuminer with arguments: $@"
exec ./cpuminer "$@"
