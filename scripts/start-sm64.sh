#!/usr/bin/env bash
set -euo pipefail

for _ in $(seq 1 100); do
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

xdpyinfo -display "$DISPLAY" >/dev/null

# Start SM64 (native binary). If not available, fall back to xclock demo.
if [[ -x /opt/sm64/sm64 ]]; then
  exec /opt/sm64/sm64
else
  # Demo: show pixelStream is working with a visible X11 app
  exec xclock -digital -strftime -geometry 640x480+0+0 -fg white -bg '#101419'
fi
