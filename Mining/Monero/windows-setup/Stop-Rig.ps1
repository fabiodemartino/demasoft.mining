# Stop-Rig.ps1
$xmrigServiceName = "XMRigService"

if (Get-Service -Name $xmrigServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Stopping XMRig service..."
    Stop-Service -Name $xmrigServiceName
} else {
    Write-Host "Service '$xmrigServiceName' not found. Killing xmrig processes directly."
    Get-Process -Name xmrig -ErrorAction SilentlyContinue | Stop-Process -Force
}
