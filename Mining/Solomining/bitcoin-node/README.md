# Process to put in prune mode
1. sudo chmod -R 770 /mnt/data2/docker/bitcoin-data
2. cd /mnt/data2/docker/bitcoin-data
3. nano bitcoin.conf
   1. prune=512000   (add)
   2. remove tindex
4. docker restart bitcoin-node
   1. you should see init message: Pruning blockstore

# Get info on the block chain
1. docker exec -it bitcoin-node bash
2. bitcoin-cli -rpcuser=demasoftbitcoin -rpcpassword=test123 getblockchaininfo  


# Get wallet amount

1. bitcoin-cli -rpcuser=demasoftbitcoin -rpcpassword=test123 -rpcport=8332 -rpcwallet=demasoftbitcoinwallet getbalance
2. bitcoin-cli -rpcuser=demasoftbitcoin -rpcpassword=test123 -rpcport=8332 -rpcwallet=demasoftbitcoinwallet sendtoaddress "destination_address" 0.01
3. bitcoin-cli -rpcuser=demasoftbitcoin -rpcpassword=test123 -rpcport=8332 -rpcwallet=demasoftbitcoinwallet dumpprivkey "1Fy5ya7SprcuPCcR67VuP71MFwDyx5B4Kh"  (get wallet private key)

