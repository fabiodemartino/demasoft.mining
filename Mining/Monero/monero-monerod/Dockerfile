# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    tar \
    bzip2 \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Download and extract latest Monero CLI release
RUN MONERO_VERSION=$(curl -s https://api.github.com/repos/monero-project/monero/releases/latest | jq -r .tag_name) && \
    MONERO_FILENAME="monero-linux-x64-${MONERO_VERSION}.tar.bz2" && \
    curl -L -o /tmp/monero.tar.bz2 https://downloads.getmonero.org/cli/${MONERO_FILENAME} && \
    tar -xjf /tmp/monero.tar.bz2 -C /opt && \
    rm /tmp/monero.tar.bz2 && \
    mv /opt/monero-x86_64-linux-* /opt/monero

# Add binaries to PATH
ENV PATH="/opt/monero:${PATH}"

WORKDIR /monero

# Default command
ENTRYPOINT ["monerod"]
