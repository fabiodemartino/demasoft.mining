# Navigate to script location
Set-Location $PSScriptRoot

$ErrorActionPreference = "Stop"
Write-Host "Starting Honey gain container..."
docker-compose -p honey-gain -f docker-compose.yml --env-file .env up --build -d
Write-Host "Honeygain is now running!"
