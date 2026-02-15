import time
import urllib.request
import json
import subprocess
import signal
import sys
import os

# Kill existing HARD
os.system("kill -9 $(pgrep -f xmrig)")

print("Starting XMRig via run_xmrig.sh...")
# Start XMRig detached from TTY
xmrig = subprocess.Popen(["./run_xmrig.sh"], stdout=sys.stdout, stderr=sys.stderr, stdin=subprocess.DEVNULL)

def send_cmd(cmd):
    try:
        # XMRig API endpoint: /2/pause or /2/resume
        url = f"http://127.0.0.1:20000/2/{cmd}"
        req = urllib.request.Request(url, method="POST")
        req.add_header('Content-Type', 'application/json')
        # Add Bearer Token
        req.add_header('Authorization', 'Bearer mytoken')
        
        # Empty body
        with urllib.request.urlopen(req, data=b"{}") as f:
            if f.status == 200:
                print(f"API: {cmd} OK")
            else:
                print(f"API: {cmd} Failed {f.status}")
    except Exception as e:
        print(f"API Error {cmd}: {e}")

try:
    print("Waiting 30s for miner DAG generation...")
    time.sleep(30)
    
    print("Entering Low Power Loop (5s Mining / 15s Sleeping)...")
    while True:
        if xmrig.poll() is not None:
             print("XMRig exited!")
             break
        
        # Resume mining
        send_cmd("resume")
        time.sleep(5)
        
        # Pause mining
        send_cmd("pause")
        time.sleep(15)

except KeyboardInterrupt:
    print("\nStopping...")
finally:
    if xmrig:
        xmrig.terminate()
    os.system("kill -9 $(pgrep -f xmrig)")
