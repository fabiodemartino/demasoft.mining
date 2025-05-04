# Convert the plain text password into a secure string
$securePass = ConvertTo-SecureString 'demasoftbitcoin123@@' -AsPlainText -Force

# Create the PSCredential object
$pair = New-Object System.Management.Automation.PSCredential ("demasoftbitcoin", $securePass)

# Prepare the request body and headers
$headers = @{ "Content-Type" = "text/plain" }
$body = '{"jsonrpc":"1.0","id":"statuscheck","method":"getblockchaininfo","params":[]}'

# Make the request
Invoke-WebRequest -Uri "http://10.0.0.135:8332/" -Method POST -Body $body -Headers $headers -Credential $pair

docker -H tcp://10.0.0.135:2375 ps
curl http://10.0.0.135:8332/


docker -H tcp://10.0.0.135:2375 info
docker-compose ps
docker run --rm -it -v /mnt/data2/docker/bitcoin-data:/mnt/test alpine sh


docker-compose down
docker-compose up -d
