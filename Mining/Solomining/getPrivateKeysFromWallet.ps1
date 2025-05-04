# PowerShell script to get private keys from Bitcoin container
# Requires Docker CLI and bx (libbitcoin-explorer) or another tool to derive private keys

# ---- CONFIG ----
$rpcuser = "demasoftbitcoin"
$rpcpassword = "test123"
$rpcport = 8332
$rpcwallet = "demasoftbitcoinwallet"
$range = "[0,9]"  # Derive first 10 addresses
$container_name = "bitcoin-node"  # Replace with your container name or ID
$seedPhrase = "your 12-word seed phrase"  # Replace with your 12-word seed phrase (if you have one)

# ---- Get descriptors from wallet ----
$cmd = "docker exec $container_name bitcoin-cli -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport -rpcwallet=$rpcwallet listdescriptors"
$jsonOutput = Invoke-Expression $cmd | ConvertFrom-Json

Write-Host "`n--- Private Keys ---`n"

foreach ($desc in $jsonOutput.descriptors) {
    if (-not $desc.internal -and $desc.active -and $desc.desc -match "wpkh|pkh|tr") {
        $cleanDesc = $desc.desc -replace "#.*$", ""  # Clean descriptor by removing comments

        # Get canonical descriptor from getdescriptorinfo
        $descInfoCmd = "docker exec $container_name bitcoin-cli -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport getdescriptorinfo `"$cleanDesc`""
        $descInfo = Invoke-Expression $descInfoCmd | ConvertFrom-Json
        $canonical = $descInfo.descriptor

        # Derive addresses from descriptor
        $deriveCmd = "docker exec $container_name bitcoin-cli -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport deriveaddresses `"$canonical`" '$range'"
        $addresses = Invoke-Expression $deriveCmd | ConvertFrom-Json

        foreach ($address in $addresses) {
            Write-Host "Address: $address"

            # If descriptor wallet, manually derive private key
            # We need the derivation index and the extended private key (xprv)
            try {
                $derivationIndex = 0  # Example for first address, update based on your needs
                $xprv = Get-ExtendedPrivateKeyFromDescriptor $cleanDesc $seedPhrase  # Function to get xprv from seed

                # Derive private key using bx or other tools (replace bx with actual tool if necessary)
                $privateKey = DerivePrivateKeyFromXprv $xprv $derivationIndex
                Write-Host "Private Key: $privateKey"
            } catch {
                Write-Host "Error deriving private key for address $address : $_"
            }
            Write-Host ""
        }
    }
}

# Function to get the extended private key (xprv) from a seed phrase
function Get-ExtendedPrivateKeyFromDescriptor($descriptor, $seedPhrase) {
    # Using bx to convert seed to extended private key (xprv)
    $seedCmd = "bx mnemonic-to-seed `"$seedPhrase`""
    $seed = Invoke-Expression $seedCmd
    $xprvCmd = "bx hd-private --prefix 0488ade4 $seed"  # Using 0488ade4 for Bitcoin mainnet
    $xprv = Invoke-Expression $xprvCmd
    return $xprv
}

# Function to derive a private key from an xprv using a derivation index
function DerivePrivateKeyFromXprv($xprv, $index) {
    # Using bx to derive private key for the address
    $privateKeyCmd = "bx hd-private-child $xprv $index"
    $privateKey = Invoke-Expression $privateKeyCmd
    return $privateKey
}
