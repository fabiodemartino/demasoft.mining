FROM ubuntu:22.04

# Install dependencies (including zlib1g-dev for -lz)
RUN apt-get update && apt-get install -y curl \
    git build-essential automake autoconf pkg-config \
    libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev \
    zlib1g-dev \
    && apt-get clean

# Clone and build cpuminer-opt
RUN git clone https://github.com/JayDDee/cpuminer-opt.git /cpuminer
WORKDIR /cpuminer
RUN ./build.sh

# Default command (can be overridden in docker-compose)
ENTRYPOINT ["/cpuminer/cpuminer"]
