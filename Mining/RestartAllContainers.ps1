# Get all running containers
$containers = docker ps -q

# Check if there are any running containers
if ($containers) {
    Write-Host "Restarting all running containers..." -ForegroundColor Green

    # Loop through each container ID and restart
    foreach ($container in $containers) {
        try {
            # Stop the container
            docker stop $container
            Write-Host "Stopped container $container" -ForegroundColor Yellow

            # Start the container again
            docker start $container
            Write-Host "Started container $container" -ForegroundColor Yellow
        } catch {
            Write-Host "Error restarting container ${container}: $_" -ForegroundColor Red
        }
    }
} else {
    Write-Host "No running containers found." -ForegroundColor Red
}
