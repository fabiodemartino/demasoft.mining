FROM monero-tari-local

# Set environment variables or install any necessary packages if needed
# For example, if you want to install curl or bash:
# RUN apt-get update && apt-get install -y bash curl

# Copy your script to the container
COPY start-tari-node.sh /root/start-tari-node.sh

# Make sure the script is executable
RUN chmod +x /root/start-tari-node.sh

# Set the entrypoint to your script
ENTRYPOINT ["/root/start-tari-node.sh"]
