# Change directory to the script location
Set-Location $PSScriptRoot

# Load environment variables from .env file
if (Test-Path ".env") {
    Get-Content .env | ForEach-Object {
        if ($_ -match "^\s*$" -or $_ -match "^\s*#") { return }  # Skip empty/comments
        $name, $value = $_.split('=', 2)
        Set-Content env:\$name $value
    }
} else {
    Write-Host "ERROR: .env file not found!" -ForegroundColor Red
    exit 1
}

# Configuration
$imageName = "firoorg/firod"
$numInstances = 1             # You can increase if needed
$baseIntensity = 80           # GPU intensity
$dataDir = "/mnt/data/docker/firo-data"

# Validate required environment variables
if (-not $env:DOCKER_HOST) { Write-Host "ERROR: DOCKER_HOST is not set!" -ForegroundColor Red; exit 1 }
if (-not $env:WALLET_ADDRESS) { Write-Host "ERROR: WALLET_ADDRESS is not set!" -ForegroundColor Red; exit 1 }
if (-not $env:POOL_URL) { Write-Host "ERROR: POOL_URL is not set!" -ForegroundColor Red; exit 1 }

# Pull Docker image on remote Docker host
Write-Host "Pulling Docker image ($imageName) on remote Docker host..."
try {
    docker -H $env:DOCKER_HOST pull $imageName
    Write-Host "Docker image pulled successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to pull Docker image on remote host!" -ForegroundColor Red
    exit 1
}

# Stop and remove any existing containers
for ($i = 1; $i -le $numInstances; $i++) {
    $containerName = "firod-$i"
    Write-Host "Removing existing container ($containerName)..."
    docker -H $env:DOCKER_HOST stop $containerName 2>$null
    docker -H $env:DOCKER_HOST rm $containerName 2>$null
}

# Start container(s)
for ($i = 1; $i -le $numInstances; $i++) {
    $containerName = "firod-$i"
    $workerName = "$env:WALLET_ADDRESS.worker$i"
    $intensity = [math]::Max($baseIntensity - ($i - 1) * 10, 50)

    Write-Host "Starting Docker container ($containerName) on remote host..."
    try {
        docker -H $env:DOCKER_HOST run -d `
            --name $containerName `
            --gpus all `
            --restart unless-stopped `
            --cpus="1.0" `
            --memory="10g" `
            -v "${dataDir}:/home/firod/.firo" `
            -e WALLET_ADDRESS=$workerName `
            -e POOL_URL=$env:POOL_URL `
            -e WORKER_NAME="worker$i" `
            -e INTENSITY=$intensity `
            $imageName

        Write-Host "Docker container ($containerName) started successfully." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to start Docker container ($containerName) on remote host!" -ForegroundColor Red
        exit 1
    }
}

# Tail logs
for ($i = 1; $i -le $numInstances; $i++) {
    $containerName = "firod-$i"
    Write-Host "`nFetching logs for $containerName..."
    docker -H $env:DOCKER_HOST logs -f $containerName
}
