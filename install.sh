#!/bin/bash
set -e

echo "=== Setting up Raven Mac Miner ==="

# 1. Check prerequisites
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed."
    exit 1
fi
if ! command -v cmake &> /dev/null; then
    echo "Error: cmake is not installed. (brew install cmake)"
    exit 1
fi
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 is not installed."
    exit 1
fi

# 2. Clone Stratum Proxy
if [ ! -d "ravencoin-stratum-proxy" ]; then
    echo "Cloning Stratum Proxy..."
    git clone https://github.com/masker/ravencoin-stratum-proxy.git
else
    echo "Stratum Proxy already exists."
fi

# 3. Clone & Build XMRig
if [ ! -d "xmrig" ]; then
    echo "Cloning XMRig..."
    git clone https://github.com/xmrig/xmrig.git
fi

if [ ! -f "xmrig/build/xmrig" ]; then
    echo "Building XMRig..."
    mkdir -p xmrig/build
    cd xmrig/build
    cmake .. -DWITH_OPENCL=ON -DWITH_CUDA=OFF
    make -j$(sysctl -n hw.ncpu)
    cd ../..
else
    echo "XMRig already built."
fi

# 4. Setup Configs
if [ ! -f "run_stratum.sh" ]; then
    echo "Creating run_stratum.sh from example..."
    cp run_stratum.sh.example run_stratum.sh
    chmod +x run_stratum.sh
    echo "--> Please edit run_stratum.sh with your RPC Password!"
fi

if [ ! -f "xmrig/build/config.json" ]; then
    echo "Creating config.json from example..."
    mkdir -p xmrig/build
    cp config.json.example xmrig/build/config.json
    echo "--> Please edit xmrig/build/config.json with your Wallet Address!"
fi

chmod +x run_xmrig.sh

echo ""
echo "=== Setup Complete! ==="
echo "1. Edit 'run_stratum.sh' and set RPC_PASS."
echo "2. Edit 'xmrig/build/config.json' and set your wallet address."
echo "3. Run './run_xmrig.sh' to start mining!"
