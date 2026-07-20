#!/usr/bin/env bash
set -euo pipefail

export HOME=/run/sm64/home
export DISPLAY=:1
export XDG_RUNTIME_DIR=/run/sm64/xdg

install -d -m 0700 "$HOME" "$XDG_RUNTIME_DIR"
install -d -m 0755 /run/sm64/http
cleanup() { for pid in "${VNC_PID:-}" "${GAME_PID:-}" "${HEALTH_PID:-}"; do [ -n "$pid" ] && kill "$pid" 2>/dev/null || true; done; }
trap cleanup EXIT INT TERM

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# Xvnc is both X server and VNC server in one
/opt/base/bin/Xvnc :1 -rfbport 5901 -SecurityTypes None \
  -geometry 1280x720 -depth 24 \
  -AlwaysShared -DisconnectClients=0 \
  -desktop SM64 -localhost no -ac &
VNC_PID=$!

attempt=0
until /opt/base/bin/xdpyprobe --quiet "$DISPLAY"; do
  kill -0 "$VNC_PID" 2>/dev/null || exit 1
  [ $((attempt++)) -le 100 ] || exit 1
  sleep 0.05
done

/opt/sm64/scripts/start-sm64.sh &
GAME_PID=$!

sleep 0.25
kill -0 "$GAME_PID"

printf 'ok\n' >/run/sm64/http/healthz
# The game is delivered over the pixel stream (RFB :5901), not HTTP. Still serve a
# 2xx landing page on `/` so the snapshot warmup gate (which probes `/`) is
# satisfied and health checks that hit the root succeed.
printf '<!doctype html><meta charset="utf-8"><title>Super Mario 64</title><body style="font:16px system-ui;margin:2rem">Super Mario 64 is loading — connect via the pixel stream.</body>' >/run/sm64/http/index.html
/usr/local/bin/busybox httpd -f -p 0.0.0.0:3000 -h /run/sm64/http &
HEALTH_PID=$!

touch /run/sm64/desktop-ready
wait -n "$VNC_PID" "$GAME_PID" "$HEALTH_PID"
