# Use a base image
FROM ruimarinho/bitcoin-core:24.0.1

# Set the UID and GID for the bitcoin user to match the host
ARG BITCOIN_UID=1500
ARG BITCOIN_GID=1500

# Make sure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Change UID/GID of the bitcoin user and group to match host
RUN groupmod -g ${BITCOIN_GID} bitcoin && \
    usermod -u ${BITCOIN_UID} -g ${BITCOIN_GID} bitcoin

# Install bash and nano
RUN apt-get update && \
    apt-get install -y iproute2 bash nano && \
    rm -rf /var/lib/apt/lists/*

# Default entrypoint to start the Bitcoin node
ENTRYPOINT ["/entrypoint.sh"]
