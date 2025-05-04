FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    cmake \
    build-essential \
    libssl-dev \
    libboost-all-dev \
    ocl-icd-opencl-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the Kawpowminer repo
RUN git clone --recursive https://github.com/RavenCommunity/kawpowminer.git

# Build Kawpowminer
WORKDIR /kawpowminer
RUN mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc)

# Set default command
WORKDIR /kawpowminer/build
CMD ["./kawpowminer", "-h"]
