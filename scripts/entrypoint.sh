#!/usr/bin/env bash
set -euo pipefail

export HOME=/home/ato
export DISPLAY=:1
export XDG_RUNTIME_DIR=/run/sm64/xdg

install -d -m 0700 "$HOME" "$XDG_RUNTIME_DIR"
cleanup() { for pid in "${XVFB_PID:-}" "${DEMO_PID:-}" "${VNC_PID:-}"; do [ -n "$pid" ] && kill "$pid" 2>/dev/null || true; done; }
trap cleanup EXIT INT TERM

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
Xvfb :1 -screen 0 1280x720x24 -nolisten tcp -noreset &
XVFB_PID=$!

attempt=0
until xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; do
  kill -0 "$XVFB_PID" 2>/dev/null || exit 1
  [ $((attempt++)) -le 100 ] || exit 1
  sleep 0.05
done

/opt/sm64/scripts/start-sm64.sh &
DEMO_PID=$!

X0tigervnc -display "$DISPLAY" -rfbport 5901 -SecurityTypes None -AlwaysShared &
VNC_PID=$!

# Health endpoint for build readiness probe
python3 -c "
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import os, socket, subprocess

rfb_port = 5901

def healthy():
    try:
        with socket.create_connection(('127.0.0.1', rfb_port), timeout=2):
            pass
    except OSError:
        return False
    try:
        os.kill($DEMO_PID, 0)
    except OSError:
        return False
    return True

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        ok = self.path == '/healthz' and healthy()
        body = b'ok' if ok else b'not ready'
        self.send_response(200 if ok else 503)
        self.send_header('Content-Type', 'text/plain')
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Cache-Control', 'no-store')
        self.end_headers()
        self.wfile.write(body)
    def log_message(self, *a): return

ThreadingHTTPServer(('0.0.0.0', 3000), H).serve_forever()
" &
HEALTH_PID=$!

touch /run/sm64/desktop-ready
wait -n "$XVFB_PID" "$DEMO_PID" "$VNC_PID" "$HEALTH_PID"
