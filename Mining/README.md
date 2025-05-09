# Demasoft.mining


# Enable docker access for VS Code
$env:DOCKER_HOST="tcp://10.0.0.135:2375"


# Add bitcoin user to server

sudo groupadd -g 1500 bitcoin
sudo useradd -u 1500 -g 1500 bitcoin

# Change ownership to the new 'bitcoin' user (UID 1500) and group (GID 1500)
sudo chown -R 1500:1500 /mnt/data2/docker/bitcoin-data
# Set permissions to 770 (read, write, execute for owner and group)
sudo chmod -R 770 /mnt/data2/docker/bitcoin-data

# Monero Node Setup with Docker and GPU Mining

This guide covers setting up a Monero node using Docker, with GPU mining using XMRig and backing up the blockchain data once synchronization is complete.

## 1. **Permissions Setup**

Before proceeding with the setup, ensure that the correct permissions are in place for accessing and modifying the necessary files and directories.

### Permissions for `/mnt/data` Directory:

```bash
sudo chmod -R 777 /mnt/data
sudo chmod -R 777 /mnt/data/monero

## 3. **Block Chain Backup Procedure**

After the Monero node has synchronized with the blockchain, it is essential to back up the blockchain data to ensure its safety and preserve the state of your node.

### 1. **Stop the Monero Node**

Before creating a backup, stop the Monero node to ensure that no changes are made to the blockchain data during the backup process.

### 1. **Create backup**
sudo tar -czvf /mnt/data2/monero-lmdb-backup.tar.gz -C /mnt/data/monero lmdb

### 2. Restore from back up
sudo tar -xzvf /mnt/data2/monero-lmdb-backup.tar.gz -C /mnt/data/monero/

### Check logs in p2pool
docker logs p2pool 2>&1 | grep -iE '37889|listen|bind|port|error|fail'
docker logs p2pool 2>&1 | grep -iE 'share|submitted|accepted'


### Check command line in the container
docker exec -it p2pool bash
cat /proc/1/cmdline | tr '\0' ' '

### Check p2pool version
docker exec -it p2pool bash
./p2pool --version

### Clear banned list
docker exec -it p2pool rm /opt/p2pool/p2pool_peers.txt

### start rig manually
docker exec -it monero-miner-gpu-p2p bash

./xmrig -o p2pool.monero_network_p2p:3333 -u 46QteQEGFhX8esA1sxBWCL33s97wDKKkVSWKJPrG3wpYeQ2ymmAgbhgNqNrQ5EJbRg9MggKGQcpM9hqfdViGzCSRVhZZ16w -p x -t 8  --cuda

tail -f /opt/p2pool/build/p2pool.log | grep --line-buffered "Block found"
tail -f /opt/p2pool/build/p2pool.log | grep --line-buffered "received"

docker exec -it monero-miner-ocean bash
