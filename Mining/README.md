# demasoftai
DemaSoft AI Experimentation


# Add bitcoin user to server

sudo groupadd -g 1500 bitcoin
sudo useradd -u 1500 -g 1500 bitcoin

# Change ownership to the new 'bitcoin' user (UID 1500) and group (GID 1500)
sudo chown -R 1500:1500 /mnt/data2/docker/bitcoin-data
# Set permissions to 770 (read, write, execute for owner and group)
sudo chmod -R 770 /mnt/data2/docker/bitcoin-data

