
import socket
import json

HOST = '127.0.0.1'
PORT = 54325

def test_stratum():
    print(f"Connecting to {HOST}:{PORT}...")
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(5)
            s.connect((HOST, PORT))
            print("Connected!")
            
            # Send mining.subscribe
            msg = {
                "id": 1,
                "method": "mining.subscribe",
                "params": ["test_script/1.0.0", "EthereumStratum/1.0.0"]
            }
            data = json.dumps(msg) + "\n"
            print(f"Sending: {data.strip()}")
            s.sendall(data.encode())
            
            response = s.recv(1024)
            print(f"Received: {response.decode().strip()}")
            
            # Send mining.authorize
            msg = {
                "id": 2,
                "method": "mining.authorize",
                "params": ["n2N4j8LWmaeBoQLfCRiSTn4XhkeG9KvP5i.worker1", "x"]
            }
            data = json.dumps(msg) + "\n"
            print(f"Sending: {data.strip()}")
            s.sendall(data.encode())

            response = s.recv(1024)
            print(f"Received: {response.decode().strip()}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_stratum()
