#!/bin/bash

# Cleanup old processes
pkill -f xmrig
pkill -f control_loop.py

# Check if stratum proxy is running
if ! pgrep -f "run_stratum.sh" > /dev/null; then
    echo "Starting Stratum Proxy..."
    ./run_stratum.sh > stratum.log 2>&1 &
    sleep 5
fi

echo "Starting XMRig..."
./xmrig/build/xmrig --config=./xmrig/build/config.json &
XMRIG_PID=$!

echo "Waiting for miner to initialize (30s)..."
sleep 30

echo "Starting Update Low Power Monitor (control_loop.py)..."
python3 -u control_loop.py &

# Wait for XMRig to exit
wait $XMRIG_PID

# Cleanup
pkill -f control_loop.py
