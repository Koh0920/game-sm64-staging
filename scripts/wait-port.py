#!/usr/bin/env python3
import socket, sys, time

host = sys.argv[1]
port = int(sys.argv[2])
timeout = int(sys.argv[3]) if len(sys.argv) > 3 else 30

deadline = time.monotonic() + timeout
while time.monotonic() < deadline:
    try:
        s = socket.create_connection((host, port), timeout=1)
        s.close()
        sys.exit(0)
    except (ConnectionRefusedError, OSError, TimeoutError):
        time.sleep(0.1)
sys.exit(1)
