# Use CUDA 11.2 runtime base image with Ubuntu 20.04
FROM nvidia/cuda:11.2.2-runtime-ubuntu20.04

# Set non-interactive mode to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory for the miner
WORKDIR /kawpowminer

# Download the Ravencoin Kawpow miner from the correct URL
RUN wget -O kawpowminer.tar.gz https://github.com/RavenCommunity/kawpowminer/releases/download/1.2.4/kawpowminer-ubuntu20-cuda11-1.2.4.tar.gz

# Extract the miner tarball
RUN tar -xzvf kawpowminer.tar.gz && ls -Rlah /kawpowminer

# Set execute permissions on the kawpowminer binary
RUN chmod +x /kawpowminer/linux-ubuntu20-cuda11-1.2.4/kawpowminer

# Entrypoint to run the miner with the appropriate stratum pool
CMD ["/kawpowminer/linux-ubuntu20-cuda11-1.2.4/kawpowminer", "-P", "stratum+tcp://${RVN_WALLET_ADDRESS}@${RVN_POOL_HOST}:${RVN_POOL_PORT}"]

# Expose ports used for mining (optional)
EXPOSE 3333
