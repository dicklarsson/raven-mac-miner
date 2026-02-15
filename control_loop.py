import time
import urllib.request
import json
import os

token = "mytoken"

def send_cmd(cmd):
    try:
        url = "http://127.0.0.1:20000/json_rpc"
        # XMRig methods are "pause" and "resume" (no params needed usually)
        body = json.dumps({
            "id": 1,
            "jsonrpc": "2.0",
            "method": cmd
        }).encode()
        
        req = urllib.request.Request(url, data=body, method="POST")
        req.add_header('Content-Type', 'application/json')
        req.add_header('Authorization', f'Bearer {token}')
        
        with urllib.request.urlopen(req) as f:
            resp = json.load(f)
            if "error" in resp and resp["error"]:
                 print(f"API Error {cmd}: {resp['error']}")
            else:
                 # Success! Minimal logging
                 pass

    except urllib.error.HTTPError as e:
        print(f"API HTTP Error {cmd}: {e.code} {e.reason}")
    except Exception as e:
        print(f"API Error {cmd}: {e}")

print("Starting Low Power Control Loop (5s ON / 15s OFF)...")
print("Mining: ⚒️")
try:
    while True:
        # Resume mining
        send_cmd("resume")
        print("\r[Mining]   ⚒️ ", end="", flush=True)
        time.sleep(5)
        
        # Pause mining
        send_cmd("pause")
        print("\r[Sleeping] 💤", end="", flush=True)
        time.sleep(15)

except KeyboardInterrupt:
    print("\nStopping control loop.")
