#!/usr/bin/env bash
set -euo pipefail

umask 077

started_as_root=false
if [[ "$(id -u)" == "0" ]]; then
  started_as_root=true
  install -d -o 1000 -g 1000 -m 0755 /run/sm64
  install -d -o 1000 -g 1000 -m 0700 \
    "$XDG_RUNTIME_DIR" \
    "$HOME" \
    "$HOME/.config"
  chown 1000:1000 "/proc/$$/fd/1" "/proc/$$/fd/2" 2>/dev/null || true
else
  install -d -m 0700 "$XDG_RUNTIME_DIR" "$HOME/.config"
fi

rm -f /run/sm64/desktop-ready
exec /usr/bin/supervisord -n -c "$SM64_ROOT/supervisor/supervisord.conf"
