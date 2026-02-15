#!/bin/bash
# Example script to run the Kawpowminer connecting to the local proxy
# Replace 'YOUR_WALLET_ADDRESS' with your actual Testnet Ravencoin address

WALLET_ADDRESS="n2N4j8LWmaeBoQLfCRiSTn4XhkeG9KvP5i"
WORKER_NAME="mac_miner"
PROXY_URL="stratum+tcp://${WALLET_ADDRESS}.${WORKER_NAME}@127.0.0.1:54325"

echo "Starting Kawpowminer..."
echo "  Proxy URL: $PROXY_URL"

./kawpowminer/build/kawpowminer/kawpowminer -P $PROXY_URL --cl-intensity 1.5

