# Navigate to script location
Set-Location $PSScriptRoot

# Use the test compose file
try {
    #docker build --no-cache -t ravecoin-miner -f Dockerfile .
    docker build  -t ravecoin-miner -f Dockerfile .
    
    Write-Host "Docker image and test executed successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to start via Docker Compose!" -ForegroundColor Red
    exit 1
}

