# Use Alpine as the base image
FROM alpine:latest


# Install necessary packages
RUN apk add --no-cache \
    git \
    build-base \
    cmake \
    curl \
    bash \
    libuv-dev \
    openssl-dev \
    hwloc-dev \
    && git clone https://github.com/MoneroOcean/xmrig.git \
    && mkdir -p xmrig/build \
    && cd xmrig/build \
    && cmake .. -DXMRIG_DEPS=scripts/deps \
    && make -j$(nproc)

# Set working directory
WORKDIR /xmrig/build

# Default command to start mining
# CMD ["./xmrig", "-o", "gulf.moneroocean.stream:10128", "-u", "46xQckfXrPSfZScsNDhAcZPLVCE6iRHe8MNnGdTyD8pWgsxSBuEN3Xzhdumsbu9cdyhRoheobzL9WiutNWPiMeqd4RcnxWQ", "-k"]
 