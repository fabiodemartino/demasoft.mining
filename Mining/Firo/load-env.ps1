# load-env.ps1

# Path to your .env file
$envFile = ".env"

# Check if the .env file exists
if (Test-Path $envFile) {
    # Read the .env file and load each line into the environment
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        # Skip empty lines and comments
        if ($line -and !$line.StartsWith('#')) {
            # Split the line into variable name and value
            $parts = $line -split '=', 2
            if ($parts.Length -eq 2) {
                $envName = $parts[0].Trim()
                $envValue = $parts[1].Trim()
                # Set the environment variable in PowerShell
                [System.Environment]::SetEnvironmentVariable($envName, $envValue, [System.EnvironmentVariableTarget]::Process)
            }
        }
    }
    Write-Host "Environment variables loaded successfully from .env file."
} else {
    Write-Host "The .env file does not exist at path $envFile"
}
