# DownHoneygain.ps1

Write-Host "Stopping Honeygain container..."
docker compose --env-file .env down
Write-Host "Honeygain container stopped."
