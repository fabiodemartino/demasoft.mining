# Navigate to script location
Set-Location $PSScriptRoot

# Use the test compose file
try {
    docker build --no-cache -t xmrig-cuda-p2p -f Dockerfile .
    # docker run --rm -it --gpus all xmrig-cuda-builder /xmrig-cuda/build/xmrig --help
    Write-Host "Docker image and test executed successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to start via Docker Compose!" -ForegroundColor Red
    exit 1
}

