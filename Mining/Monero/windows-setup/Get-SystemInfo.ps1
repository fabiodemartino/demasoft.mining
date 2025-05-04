# Get-SystemInfo.ps1
Write-Host "CPU Info:"
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed | Format-List

Write-Host "`nMemory Info:"
Get-CimInstance Win32_PhysicalMemory | Select-Object BankLabel, Capacity, Speed, Manufacturer | Format-Table -AutoSize

$totalMemory = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
Write-Host "`nTotal Memory: {0:N2} GB" -f $totalMemory
