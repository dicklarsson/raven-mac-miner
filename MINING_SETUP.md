# Ravencoin Testnet Mining Setup (Apple Silicon)

Detta är dokumentationen för hur man kör Ravencoin-mining på macOS (M1/M2/M3 etc) med reducerad ljudnivå.

## 🛠 Komponenter

Systemet består av tre huvuddelar som samarbetar:

1.  **Raven Core Node** (Din plånbok)
    *   Måste vara igång (helst `raven-qt` eller `ravend`).
    *   Agerar "pool" lokalt.

2.  **Stratum Proxy** (`run_stratum.sh`)
    *   En brygga som översätter XMRig:s språk (Stratum) till Raven Nodes språk (RPC).
    *   Körs automatiskt av startskriptet.

3.  **XMRig Miner** (`xmrig`)
    *   Själva gruvprogrammet som använder GPU:n (OpenCL).
    *   Konfigurerad via `xmrig/build/config.json`.

4.  **Low Power Monitor** (`control_loop.py`)
    *   Ett Python-skript som pratar med XMRig via API.
    *   **Funktion:** Pausar och startar minern i cykler (5s arbete / 15s vila) för att hålla datorn tyst och sval.

---

## 🚀 Hur man startar

Du behöver bara köra **ett** kommando. Skriptet sköter resten (startar proxy, miner och tystnadskontroll).

```bash
./run_xmrig.sh
```

För att stoppa allt: Tryck `Ctrl + C`.

---

## 📂 Viktiga Filer

*   **`run_xmrig.sh`**: Huvudskriptet. Startar Stratum (om den inte körs), XMRig, och Control Loop. Städar upp processer när du stänger.
*   **`run_stratum.sh`**: Startar stratum-proxyn med rätt inställningar (port 54325).
*   **`control_loop.py`**: "Tysthets-skriptet". Skickar API-kommandon till XMRig.
*   **`xmrig/build/config.json`**: Inställningar för XMRig. API måste vara aktiverat (`http.enabled: true`) för att control loop ska fungera.

## 🔧 Felsökning

Om något krånglar:

1.  **"Connection refused"**: Kolla att Raven Core (plånboken) är igång och har server-läge aktiverat i `raven.conf`.
2.  **Fläktarna låter för mycket**: Justera tiderna i `control_loop.py` (öka `sleep(15)`).
3.  **Kör manuellt**:
    *   Starta proxy: `./run_stratum.sh`
    *   Starta miner: `./xmrig/build/xmrig --config=./xmrig/build/config.json`
