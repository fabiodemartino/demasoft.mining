# Use Ubuntu as base
FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl unzip git build-essential libpci-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /miner

# Download lolMiner
RUN wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.82/lolMiner_v1.82_Lin64.tar.gz && \
    tar -xvzf lolMiner_v1.82_Lin64.tar.gz && \
    mv 1.82/* . && rm -rf 1.82 lolMiner_v1.82_Lin64.tar.gz

# Copy start script
COPY start.sh .

# Make it executable
RUN chmod +x start.sh

CMD ["./start.sh"]
