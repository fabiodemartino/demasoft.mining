# Navigate to script location
Set-Location $PSScriptRoot

# Use the test compose file
try {
     
    docker-compose -p ravecoin-miner -f docker-compose.yml --env-file .env up --build -d
    Write-Host "Docker Compose started successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to start via Docker Compose!" -ForegroundColor Red
    exit 1
}

# Show container logs
Write-Host "`nTailing container logs for 'ravecoin-miner'..."
Start-Sleep -Seconds 2
docker logs -f ravecoin-miner
 