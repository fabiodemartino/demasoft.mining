# Change directory to the script location
Set-Location $PSScriptRoot

# Load environment variables from .env file
if (Test-Path ".env") {
    Get-Content .env | ForEach-Object {
        $name, $value = $_.split('=', 2)
        Set-Content env:\$name $value
    }
} else {
    Write-Host "ERROR: .env file not found!" -ForegroundColor Red
    exit 1
}

# Ensure image name is set properly
$imageName = "gminer"  # Change this to your actual image name

# Validate required environment variables
if (-not $env:DOCKER_HOST) { Write-Host "ERROR: DOCKER_HOST is not set!" -ForegroundColor Red; exit 1 }
if (-not $env:WALLET_ADDRESS) { Write-Host "ERROR: WALLET_ADDRESS is not set!" -ForegroundColor Red; exit 1 }
if (-not $env:POOL_URL) { Write-Host "ERROR: POOL_URL is not set!" -ForegroundColor Red; exit 1 }
if (-not $env:WORKER_NAME) { Write-Host "ERROR: WORKER_NAME is not set!" -ForegroundColor Red; exit 1 }

Write-Host "DOCKER_HOST: $env:DOCKER_HOST"
Write-Host "WALLET_ADDRESS: $env:WALLET_ADDRESS"
Write-Host "POOL_URL: $env:POOL_URL"
Write-Host "WORKER_NAME: $env:WORKER_NAME"

# Build Docker image on the remote Docker host
Write-Host "Building Docker image ($imageName) on remote Docker host..."
try {
    docker -H $env:DOCKER_HOST build -t $imageName .
    Write-Host "Docker image built successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to build Docker image on remote host!" -ForegroundColor Red
    exit 1
}

# Stop and remove any existing container with the same name
Write-Host "Removing any existing container ($imageName)..."
docker -H $env:DOCKER_HOST stop $imageName 2>$null
docker -H $env:DOCKER_HOST rm $imageName 2>$null

# Run the Docker container remotely with GPU access
Write-Host "Starting Docker container ($imageName) on remote host..."
try {
    docker -H $env:DOCKER_HOST run -d --name $imageName --gpus all --restart unless-stopped `
        -e WALLET_ADDRESS=$env:WALLET_ADDRESS `
        -e POOL_URL=$env:POOL_URL `
        -e WORKER_NAME=$env:WORKER_NAME `
        $imageName
    Write-Host "Docker container started successfully on remote host." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to start Docker container on remote host!" -ForegroundColor Red
    exit 1
}

# Show container logs
Write-Host "Fetching logs..."
docker -H $env:DOCKER_HOST logs -f $imageName
