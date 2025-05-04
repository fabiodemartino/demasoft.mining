# Ensure script is run from its own folder
Set-Location $PSScriptRoot
Write-Host "Building Docker image for Monero deamon" -ForegroundColor Cyan

$tag = "monero-monerod-local"

try {
    docker build --no-cache -t $tag -f Dockerfile .
    Write-Host "Docker image '$tag' built successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to build Docker image!" -ForegroundColor Red
    exit 1
}
