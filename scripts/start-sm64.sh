#!/usr/bin/env bash
set -euo pipefail

for ((i=0; i<100; i++)); do
  if /opt/base/bin/xdpyprobe --quiet "$DISPLAY"; then
    break
  fi
  sleep 0.1
done

/opt/base/bin/xdpyprobe --quiet "$DISPLAY"

cd /opt/sm64/game
export LD_LIBRARY_PATH=/opt/sm64/game${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

exec /opt/sm64/game/sm64coopdx
