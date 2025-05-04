# Navigate to script location
Set-Location $PSScriptRoot

# Use the test compose file
try {
     
    docker-compose -p monero-gpu-p2p -f docker-compose.gpu-p2p.yml --env-file .env.gpu-p2p up --build -d
    Write-Host "Docker Compose started successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to start via Docker Compose!" -ForegroundColor Red
    exit 1
}

# Show container logs
Write-Host "`nTailing container logs for 'monero-miner-gpu-p2p'..."
Start-Sleep -Seconds 2
docker logs -f monero-miner-gpu-p2p
docker logs -f monerod