# Change directory to the script location
Set-Location $PSScriptRoot
# Start the service using docker-compose and log output
try {
    docker-compose down --volumes --remove-orphans
    Write-Host "Starting Xelis miner via Docker Compose..." -ForegroundColor Cyan

    # Capture Docker Compose output in a log file
    docker compose --env-file .env up -d --remove-orphans | Tee-Object -FilePath "docker-compose.log"
    Write-Host "Docker Compose started successfully." -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to start via Docker Compose!" -ForegroundColor Red
    exit 1
}

# Tail logs from the container
$containerName = "xelis-miner"  # Ensure this matches your container name

Write-Host "Tailing logs for '$containerName'..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
docker logs -f $containerName
