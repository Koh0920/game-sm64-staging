#!/usr/bin/env bash
set -euo pipefail

for ((i=0; i<100; i++)); do
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

xdpyinfo -display "$DISPLAY" >/dev/null

if [[ -x /opt/sm64/sm64 ]]; then
  exec /opt/sm64/sm64
else
  exec xterm -display "$DISPLAY" -geometry 80x24+120+80 \
    -title "SM64 pixelStream Demo" \
    -e bash -c 'echo "SM64 pixelStream demo"; echo "Game binary not available"; exec bash'
fi
