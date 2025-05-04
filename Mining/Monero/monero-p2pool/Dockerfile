FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl wget git cmake build-essential libssl-dev \
    libboost-all-dev pkg-config python3 \
    libzmq3-dev libuv1-dev libcurl4-openssl-dev \
    ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone the latest version of p2pool (default branch)
RUN git clone --recurse-submodules https://github.com/SChernykh/p2pool.git && \
    cd p2pool && \
    git submodule update --init --recursive

# Build
WORKDIR /opt/p2pool
RUN cmake -B build -S . && \
    cmake --build build -j$(nproc)

WORKDIR /opt/p2pool/build

EXPOSE 3333

ENTRYPOINT ["./p2pool"]
