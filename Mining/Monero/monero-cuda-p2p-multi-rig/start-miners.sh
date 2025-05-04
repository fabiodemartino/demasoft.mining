#!/bin/bash

# Start the CUDA miner
echo "Starting CUDA miner..."
./xmrig --config=/configs/cuda.json &

# Start the CPU miner
echo "Starting CPU miner..."
./xmrig --config=/configs/cpu.json &

# Start another CUDA miner if you want to run more instances
echo "Starting another CUDA miner..."
./xmrig --config=/configs/cuda-2.json &

# Start another CPU miner
echo "Starting another CPU miner..."
./xmrig --config=/configs/cpu-2.json &

# Wait for all processes to finish
wait
