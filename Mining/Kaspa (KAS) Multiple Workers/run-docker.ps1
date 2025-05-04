# Change directory to the script location
Set-Location $PSScriptRoot
$MaxWorker = 20
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

Write-Host "DOCKER_HOST: $env:DOCKER_HOST"
Write-Host "WALLET_ADDRESS: $env:WALLET_ADDRESS"
Write-Host "POOL_URL: $env:POOL_URL"

# Build Docker image on the remote Docker host
Write-Host "Building Docker image ($imageName) on remote Docker host..."
try {
    docker -H $env:DOCKER_HOST build -t $imageName .
    Write-Host "Docker image built successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to build Docker image on remote host!" -ForegroundColor Red
    exit 1
}

# Loop to create and run MaxWorker workers
for ($i = 10; $i -le $MaxWorker; $i++) {
    # Generate a unique worker name for each worker
    $workerName = "${env:WORKER_NAME}_$i"

    # Stop and remove any existing container with the same name
    Write-Host "Removing any existing container ($workerName)..."
    docker -H $env:DOCKER_HOST stop $workerName 2>$null
    docker -H $env:DOCKER_HOST rm $workerName 2>$null

    # Run the Docker container remotely with GPU access for the worker
    Write-Host "Starting Docker container ($workerName) on remote host..."
    try {
        docker -H $env:DOCKER_HOST run -d --name $workerName --gpus all --restart unless-stopped `
            -e WALLET_ADDRESS=$env:WALLET_ADDRESS `
            -e POOL_URL=$env:POOL_URL `
            -e WORKER_NAME=$workerName `
            $imageName
        Write-Host "Docker container $workerName started successfully on remote host." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to start Docker container $workerName on remote host!" -ForegroundColor Red
        exit 1
    }
}

# Show logs for each worker
Write-Host "Fetching logs for all workers..."
for ($i = 5; $i -le $MaxWorker; $i++) {
    $workerName = "${env:WORKER_NAME}_$i"
    Write-Host "Fetching logs for $workerName..."
    docker -H $env:DOCKER_HOST logs -f $workerName
}
