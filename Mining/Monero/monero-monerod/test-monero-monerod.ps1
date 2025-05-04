# Test-MoneroImage.ps1

$ImageName = "monero-monerod-local"
$ContainerName = "monero-node"
$VolumePath = "/mnt/data/docker/monero"

Write-Host "Checking if image '$ImageName' exists..."
try {
    docker image inspect $ImageName | Out-Null
    $imageExists = $true
} catch {
    $imageExists = $false
}

if (-not $imageExists) {
    Write-Host "Image not found. Building '$ImageName'..."
    $buildResult = docker build -t $ImageName .
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to build Docker image."
        exit 1
    }
} else {
    Write-Host $buildResult
}

Write-Host "Running version check..."
$versionCheck = docker run --rm $ImageName --version
if ($LASTEXITCODE -ne 0) {
    Write-Error "Version check failed."
    exit 1
} else {
    Write-Host $versionCheck
}

Write-Host "Removing existing container (if any)..."
docker rm -f $ContainerName -ErrorAction SilentlyContinue | Out-Null

Write-Host "Starting container '$ContainerName'..."
docker run -d `
    --name $ContainerName `
    -v "${VolumePath}:/monero" `
    -p 18080:18080 `
    -p 18081:18081 `
    $ImageName `
    --non-interactive `
    --confirm-external-bind `
    --data-dir /monero `
    --rpc-bind-ip 0.0.0.0

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to start the container."
    exit 1
}

Start-Sleep -Seconds 5

Write-Host "Fetching container logs..."
docker logs --tail 10 $ContainerName
