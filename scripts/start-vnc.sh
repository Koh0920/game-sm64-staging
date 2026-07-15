#!/usr/bin/env bash
set -euo pipefail

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
exec /usr/bin/Xtigervnc :1 \
  -rfbport 5901 \
  -localhost \
  -SecurityTypes None \
  -geometry 1280x720 \
  -depth 24 \
  -AlwaysShared \
  -DisconnectClients=0 \
  -desktop "SM64" \
  -ac
