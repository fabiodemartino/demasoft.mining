# Ensure script is run from its own folder
$env:DOCKER_HOST = "tcp://10.0.0.135:2375"
Set-Location $PSScriptRoot

Write-Host "Building Docker image for zephyr" -ForegroundColor Cyan

$tag = "xmrig-zephyr"

try {
    docker build --no-cache -t $tag -f Dockerfile .
    Write-Host ""
    Write-Host "Docker image '$tag' built successfully." -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to build Docker image!" -ForegroundColor Red
    exit 1
}
