FROM nvidia/cuda:12.2.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev wget && \
    git clone https://github.com/xmrig/xmrig.git && \
    mkdir xmrig/build && cd xmrig/scripts && ./build_deps.sh && \
    cd ../build && cmake .. -DWITH_CUDA=ON && make -j$(nproc)

WORKDIR /xmrig/build

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
