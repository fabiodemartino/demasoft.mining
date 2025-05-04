#!/bin/bash
set -e

# Get the UID and GID of the bitcoin user on the host machine (mounted volume)
HOST_UID=$(stat -c '%u' /home/bitcoin/.bitcoin)
HOST_GID=$(stat -c '%g' /home/bitcoin/.bitcoin)

# Check if the current UID/GID is different from the host's
if [ "$HOST_UID" != "$(id -u bitcoin)" ] || [ "$HOST_GID" != "$(id -g bitcoin)" ]; then
    # Change the bitcoin user's UID and GID to match the host's
    echo "Changing UID/GID to match the host's volume permissions"
    usermod -u $HOST_UID bitcoin
    groupmod -g $HOST_GID bitcoin
    # Ensure the directory permissions are correct
    chown -R bitcoin:bitcoin /home/bitcoin/.bitcoin
fi

# Execute the original entrypoint to start the Bitcoin node
exec /entrypoint-original.sh "$@"
