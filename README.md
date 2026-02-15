# Ravencoin Testnet Silent Miner (Apple Silicon Edition) 🍏⛏️

An optimized, whisper-quiet mining setup for Ravencoin Testnet on Apple Silicon (M1/M2/M3) devices.

## 🎯 Purpose
Mining on a Mac usually means jet-engine fans and a hot laptop. This project solves that by implementing a **smart duty-cycle controller** that allows you to mine in the background while keeping your Mac cool and silent. Perfect for supporting the Testnet 24/7 without the noise!

## 🌟 The Magic Components

### 1. The Gateway: Kralverde's Stratum Proxy 🌉
We use the brilliant **[Ravencoin Stratum Proxy](https://github.com/masker/ravencoin-stratum-proxy)** originally by **Kralverde** (masker). This proxy allows modern miners like XMRig to communicate with the local Ravencoin Core wallet. Without this piece of genius engineering, local solo mining on Mac would be a headache. **Huge kudos to Kralverde!** 🙌

### 2. The Muscle: XMRig 💪
We leverage the highly optimized [XMRig](https://github.com/xmrig/xmrig) for OpenCL mining on Apple Silicon GPUs. It's fast, efficient, and reliable.

### 3. The Silencer: Low Power Control Loop 🤫
A custom Python script (`control_loop.py`) that monitors and controls the miner via API. It enforces a strict duty cycle (e.g., 5s Mining / 15s Sleeping) to drastically reduce heat output. The result? **~1.8 MH/s average hashrate with nearly silent fans.**

## 🚀 Quick Start (New Machine)

1.  Clone this repo:
    ```bash
    git clone https://github.com/dicklarsson/raven-mac-miner.git
    cd raven-mac-miner
    ```

2.  Run the automated installer:
    ```bash
    ./install.sh
    ```
    *(This will clone XMRig & Stratum Proxy and build everything for you)*

3.  Configure your secrets:
    *   Edit `run_stratum.sh` -> Set your local node RPC password.
    *   Edit `xmrig/build/config.json` -> Set your wallet address.

4.  **Start Mining!**
    ```bash
    ./run_xmrig.sh
    ```
    *(This script launch Stratum, XMRig, and the Silencer automatically)*

## ❤️ Credits
*   **Kralverde / masker**: For the indispensable Stratum Proxy.
*   **XMRig Team**: For the mining software.
*   **Ravencoin Community**: KA-KAW! 🦅
