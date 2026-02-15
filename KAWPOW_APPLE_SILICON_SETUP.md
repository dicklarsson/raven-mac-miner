# Ravencoin Mining Setup on Apple Silicon (M-Series)

This guide documents the process of setting up and running a Ravencoin miner on Apple Silicon (M1/M2/M3/M4/M5) using `kawpowminer` and a local Stratum proxy.

## Prerequisites

1.  **Ravencoin Core QT Wallet**:
    *   Must be installed and synced (Testnet or Mainnet).
    *   `raven.conf` location: `~/Library/Application Support/Raven/raven.conf` (or `testnet3/raven.conf` if strictly using testnet directory).
    *   **Configuration**: Check `raven.conf` for `rpcuser`, `rpcpassword`, and `rpcport`.
    *   **Important**: The node must be running with `-server=1` or `server=1` in `raven.conf` to accept RPC connections.

2.  **Development Tools** (for building):
    *   Xcode Command Line Tools (`xcode-select --install`).
    *   Homebrew (`brew`).
    *   `cmake`, `boost` (or use local boost as configured).

## 1. Setup Stratum Proxy

The Stratum proxy bridges the miner (which speaks Stratum protocol) to the local Ravencoin node (which speaks RPC).

### Installation
We use the Kralverde Stratum Proxy.

```bash
cd ravencoin-stratum-proxy
pip3 install -r requirements.txt
cd ..
```

### Configuration & Running
A script `run_stratum.sh` is provided to simplify launching the proxy.

1.  **Edit `run_stratum.sh`**:
    *   Update `RPC_USER`, `RPC_PASS`, and `RPC_PORT` to match your local `raven.conf`.
    *   Set `IS_TESTNET="true"` if mining on Testnet.

2.  **Run the Proxy**:
    ```bash
    ./run_stratum.sh
    ```
    *Output should indicate the proxy is listening on port 54325.*

## 2. Build Kawpowminer (Apple Silicon)

Steps to compile `kawpowminer` from source for Apple Silicon.

```bash
cd kawpowminer
mkdir -p build && cd build
cmake ..
# Note: If you encounter specific Boost/OpenCL issues, checking CMakeLists.txt modifications might be required.
make -j$(nproc)
cd ../..
```

*The binary will be located at `kawpowminer/build/kawpowminer/kawpowminer`.*

## 3. Run the Miner

A script `run_miner_example.sh` is provided to launch the miner.

1.  **Edit `run_miner_example.sh`**:
    *   Update `WALLET_ADDRESS` to your Ravencoin address (Testnet addresses start with `n` or `m`).
    *   Ensure the proxy URL port (default 54325) matches the proxy setting.

2.  **Run the Miner**:
    Open a new terminal window (keep the proxy running in the first one) and run:
    ```bash
    ./run_miner_example.sh
    ```

## Troubleshooting

-   **Proxy Connection Refused**: Ensure the Ravencoin QT wallet is running and fully loaded. Check `raven.conf` RPC settings.
-   **Miner "No connection"**: Ensure the Proxy is running and listening on the expected port.
-   **OpenCL Errors**: Ensure you are not running through Rosetta (use native Terminal).
