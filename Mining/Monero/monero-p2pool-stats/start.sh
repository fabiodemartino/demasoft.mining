#!/bin/bash
set -e

# Create the /data folder if it doesn't exist
mkdir -p /data

# Create or update the symlink
ln -sf /data-api/stats_mod /data/stats_mod

# Now start the Flask server
exec python3 /opt/p2pool/docker-compose/statistics/app/p2pool_statistics.py /opt/p2pool/docker-compose/statistics/app/data-api /opt/p2pool/docker-compose/statistics/app/stats.json
