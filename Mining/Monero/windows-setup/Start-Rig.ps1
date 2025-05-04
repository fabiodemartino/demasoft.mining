# Start-Rig.ps1

# ---------------- Configuration ----------------
$toolsPath = "C:\Tools\WindowsMonero"
$xmrigExe = "$toolsPath\XMRig\xmrig.exe"
$configPath = "$toolsPath\XMRig\config.json"
$apiUrl = "http://127.0.0.1:16000/1/summary"
$taskName = "StartXMRigElevated"
$nssmPath = "$toolsPath\nssm\nssm.exe"
$xmrigServiceName = "XMRigService"
$userName = "$env:COMPUTERNAME\$env:USERNAME"

# ---------------- Lock Pages in Memory ----------------
Write-Host "Granting 'Lock Pages in Memory' right to $userName..."
secedit /export /cfg C:\secpol.cfg
(Get-Content C:\secpol.cfg) -replace 'SeLockMemoryPrivilege = (.*)', "SeLockMemoryPrivilege = *$userName" |
    Set-Content C:\secpol.cfg
secedit /configure /db secedit.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
Remove-Item C:\secpol.cfg -Force

# ---------------- Create Scheduled Task to Run XMRig as Admin ----------------
Write-Host "Creating Scheduled Task for elevated XMRig launch..."
$action = New-ScheduledTaskAction -Execute $xmrigExe -Argument "--config=$configPath"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId $userName -LogonType S4U -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force

# ---------------- Setup NSSM Windows Service ----------------
Write-Host "Setting up XMRig as a Windows service using NSSM..."
Start-Process -FilePath $nssmPath -ArgumentList "install $xmrigServiceName `"$xmrigExe`" --config=$configPath" -NoNewWindow -Wait
Start-Process -FilePath $nssmPath -ArgumentList "set $xmrigServiceName Start SERVICE_AUTO_START" -NoNewWindow -Wait
Start-Service -Name $xmrigServiceName

# ---------------- Query XMRig API ----------------
Start-Sleep -Seconds 10
try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get
    Write-Host "`nXMRig Status:"
    Write-Host "Uptime: $($response.uptime) sec"
    Write-Host "Hashrate: $($response.hashrate.total[0]) H/s"
    Write-Host "Shares (Good/Bad): $($response.results.shares_good)/$($response.results.shares_bad)"
    Write-Host "Threads: $($response.cpu.threads.Count)"
} catch {
    Write-Warning "XMRig API not reachable. Ensure config has HTTP enabled on port 16000."
}
