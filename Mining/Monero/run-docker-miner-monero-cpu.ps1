# Change directory to the script location
Set-Location $PSScriptRoot
# Start the service using docker-compose
try {
     
    # Run docker-compose to start the container
    docker-compose -p monero-cpu -f docker-compose.cpu.yml --env-file .env.cpu up --build -d
    Write-Host "Docker Compose started successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to start via Docker Compose!" -ForegroundColor Red
    exit 1
}

# Show container logs
Write-Host "`nTailing container logs for 'monero-miner-cpu'..."
Start-Sleep -Seconds 2
docker logs -f monero-miner-cpu
