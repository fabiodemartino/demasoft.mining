# Ensure script is run from its own folder
Set-Location $PSScriptRoot

Write-Host "Building Docker image for Tari" -ForegroundColor Cyan

$tag = "monero-tari-local"

try {
    docker build --no-cache -t $tag -f Dockerfile .
    Write-Host ""
    Write-Host "Docker image '$tag' built successfully." -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to build Docker image!" -ForegroundColor Red
    exit 1
}
