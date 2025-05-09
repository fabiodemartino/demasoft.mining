#!/bin/bash

# Ensure we have all necessary directories and files
mkdir -p /root/.tari/node/nextnet/config/base_node
mkdir -p /root/.tari/node/nextnet/libtor/base_node/data

# Execute the Tari node initialization process
# We'll provide 'Y' to all the prompts automatically using a here document

/usr/local/bin/entrypoint.sh <<EOF
Y
Y
EOF

# Keep the container running
tail -f /dev/null
