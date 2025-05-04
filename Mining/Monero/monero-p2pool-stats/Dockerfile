FROM ubuntu:22.04

# Install necessary dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl wget git cmake build-essential libssl-dev \
    libboost-all-dev pkg-config python3 python3-pip \
    libzmq3-dev libuv1-dev libcurl4-openssl-dev \
    ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone the latest version of p2pool (default branch)
WORKDIR /opt
RUN git clone --recurse-submodules https://github.com/SChernykh/p2pool.git && \
    cd p2pool && \
    git submodule update --init --recursive

# Build the p2pool project
WORKDIR /opt/p2pool
RUN cmake -B build -S . && \
    cmake --build build -j$(nproc)

# Install Flask and other Python dependencies for the statistics page
WORKDIR /opt/p2pool/docker-compose/statistics/app
RUN pip3 install flask humanfriendly prefixed

# Expose the necessary ports
EXPOSE 3333
EXPOSE 80

# Add this after installing everything
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Change the ENTRYPOINT
ENTRYPOINT ["/start.sh"]
