FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git build-essential cmake automake libtool autoconf \
    libuv1-dev libssl-dev libhwloc-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# -------- Build XMRig --------
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig.git
WORKDIR /root/xmrig
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc)

# -------- Build CUDA plugin --------
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig-cuda.git
WORKDIR /root/xmrig-cuda/build
RUN cmake .. \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_LIB=/usr/local/cuda/lib64/stubs/libcuda.so && \
    make -j$(nproc)

# -------- Copy plugin --------
RUN mkdir -p /root/xmrig/build/plugins && \
    cp /root/xmrig-cuda/build/libxmrig-cuda.so /root/xmrig/build/plugins/

# -------- Default workdir and entry --------
WORKDIR /root/xmrig/build
ENV LD_LIBRARY_PATH="/root/xmrig/build/plugins:$LD_LIBRARY_PATH"
ENTRYPOINT ["./xmrig"]
