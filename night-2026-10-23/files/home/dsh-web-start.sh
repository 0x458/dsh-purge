#!/usr/bin/env bash
SHIM="$HOME/.npm-global/bin/dsh"
HOST="100.126.242.114"
[ -x "$SHIM" ] || chmod +x "$SHIM"
pkill -f '[d]sh web' 2>/dev/null && sleep 2
cd "$HOME"
nohup "$SHIM" web --no-open --host "$HOST" --trusted-host "$HOST" > /tmp/dsh-web.log 2>&1 &
sleep 8
pgrep -af '[d]sh web' >/dev/null && echo "✓ http://$HOST:3080" || { echo "✗ 失败"; tail -20 /tmp/dsh-web.log; }
