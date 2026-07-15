#!/usr/bin/env bash
set -euo pipefail

python3 /opt/sm64/scripts/wait-port.py 127.0.0.1 6080 30
install -d -m 0700 /run/sm64/client_temp /run/sm64/proxy_temp
exec /usr/sbin/nginx -c "$SM64_ROOT/nginx.conf" -g 'daemon off;'
