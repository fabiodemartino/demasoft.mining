# Load environment variables from .env file
Set-Location $PSScriptRoot
$envFile = ".env"

# Check if the .env file exists
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and !$line.StartsWith('#')) {
            # Split each line into key-value pair
            $parts = $line -split '=', 2
            if ($parts.Length -eq 2) {
                $envName = $parts[0].Trim()
                $envValue = $parts[1].Trim()
                # Set the environment variable in the current process
                [System.Environment]::SetEnvironmentVariable($envName, $envValue, [System.EnvironmentVariableTarget]::Process)
            }
        }
    }
    Write-Host "Environment variables loaded successfully from .env file." -ForegroundColor Green
} else {
    Write-Host "The .env file does not exist at path $envFile" -ForegroundColor Red
    exit 1
}

# Ensure DOCKER_HOST and DATA_DIR are loaded from .env
if (-not $env:DOCKER_HOST) {
    Write-Host "ERROR: DOCKER_HOST is not set in the .env file!" -ForegroundColor Red
    exit 1
}

if (-not $env:BITCOIN_DATADIR) {
    Write-Host "ERROR: BITCOIN_DATADIR is not set in the .env file!" -ForegroundColor Red
    exit 1
}

Write-Host "DOCKER_HOST set to $env:DOCKER_HOST" -ForegroundColor Yellow
Write-Host "BITCOIN_DATADIR set to $env:BITCOIN_DATADIR" -ForegroundColor Yellow

# Display loaded environment variables (excluding sensitive data)
Write-Host "Loaded Environment Variables:" -ForegroundColor Cyan
Write-Host "BITCOIN_RPCUSER = $env:BITCOIN_RPCUSER"
Write-Host "BITCOIN_RPCPASSWORD = ******** (hidden for security)"
Write-Host "BITCOIN_RPCPORT = $env:BITCOIN_RPCPORT"
Write-Host "BITCOIN_P2PPORT = $env:BITCOIN_P2PPORT"
Write-Host "BITCOIN_NETWORK = $env:BITCOIN_NETWORK"
Write-Host "MINING_POOL = $env:MINING_POOL"
Write-Host "BITCOIN_DATADIR = $env:BITCOIN_DATADIR"  # Display BITCOIN_DATADIR

Write-Host "Substituting environment variables in bitcoin.template.conf" -ForegroundColor Green

# Substitute environment variables into the bitcoin.conf file using envsubst
docker run --rm -v ${PWD}:$env:BITCOIN_DATADIR --env-file .env busybox sh -c "envsubst < $env:BITCOIN_DATADIR/bitcoin.template.conf > $env:BITCOIN_DATADIR/bitcoin.conf"

Write-Host "Building and starting the Bitcoin mining environment..." -ForegroundColor Green

# Stop any existing containers to ensure a fresh start
docker-compose down

# Build the miner Docker image
docker-compose build

# Ensure Docker environment is ready
Write-Host "Ensuring Docker environment is ready..." -ForegroundColor Green

# Use Docker TCP for remote commands (directly using $env:DOCKER_HOST for remote Docker commands)
# Ensure the directory has correct permissions directly on the remote server using Docker API

Write-Host "Ensuring directory permissions on the host machine..." -ForegroundColor Green

# Use Docker to manage files on the remote server
docker -H $env:DOCKER_HOST exec -u root bitcoin-node sh -c "chown -R 1500:1500 $env:BITCOIN_DATADIR"

# Start the containers on the Ubuntu server (using Docker Compose over TCP)
Write-Host "Starting the Bitcoin node on the Ubuntu server..." -ForegroundColor Green

# Start Docker Compose on the remote server using the DOCKER_HOST
docker-compose -H $env:DOCKER_HOST up -d

Write-Host "Bitcoin node and miner are now running on Ubuntu server!" -ForegroundColor Cyan

# Now create the wallet and check the balance
Write-Host "Creating wallet..." -ForegroundColor Green
$walletCreateCmd = 'bitcoin-cli -rpcuser=$env:BITCOIN_RPCUSER -rpcpassword=$env:BITCOIN_RPCPASSWORD -rpcport=$env:BITCOIN_RPCPORT createwallet "demasoftbitcoinwallet"'
Invoke-Expression $walletCreateCmd

# Check balance in the wallet
Write-Host "Checking balance in the wallet..." -ForegroundColor Green
$balanceCheckCmd = 'bitcoin-cli -rpcuser=$env:BITCOIN_RPCUSER -rpcpassword=$env:BITCOIN_RPCPASSWORD -rpcport=$env:BITCOIN_RPCPORT -rpcwallet=demasoftbitcoinwallet getbalance'
Invoke-Expression $balanceCheckCmd

# Show logs (optional)
Start-Sleep -Seconds 5
docker-compose -H $env:DOCKER_HOST logs --tail=50 -f
