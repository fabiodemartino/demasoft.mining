# Ensure script is run from its own folder
Set-Location $PSScriptRoot

Write-Host "Building Docker image for P2Pool stats" -ForegroundColor Cyan

$tag = "monero-p2p-stats"

try {
    docker build --no-cache -t $tag -f Dockerfile .
    Write-Host ""
    Write-Host "Docker image '$tag' built successfully." -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to build Docker image!" -ForegroundColor Red
    exit 1
}
