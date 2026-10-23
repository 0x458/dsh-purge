#!/bin/sh
# 应用 dsh-night-2026-10-23 (幂等; 打补丁前存 .pre-bundle 备份)
set -e
B=$(cd "$(dirname "$0")" && pwd)
H=${HOME:-/home/g0x9458i}
D=$H/.npm-global/lib/node_modules/@deepseek-ai/dsh
echo "== 1/4 DSH 内部补丁"
patch -p1 -d "$D" -b --suffix .pre-bundle < "$B/patches/dsh-internal.patch" || true
echo "== 2/4 启动器补丁"
patch -p1 -d "$H/.npm-global/bin" -b --suffix .pre-bundle < "$B/patches/npm-global-bin.patch" || true
echo "== 3/4 文件落地"
mkdir -p "$H/.dsh/profiles/web" "$H/.dsh/rules" "$H/.dsh/.agent-presets" "$H/.config/systemd/user"
cp -a "$B/files/dsh-home/web-cordis.patch.yml" "$H/.dsh/profiles/web/cordis.patch.yml"
cp -a "$B/files/dsh-home/.env" "$H/.dsh/.env"; chmod 600 "$H/.dsh/.env"
cp -a "$B/files/dsh-home/.credentials.yaml" "$H/.dsh/.credentials.yaml"; chmod 600 "$H/.dsh/.credentials.yaml"
cp -a "$B/files/dsh-home/AGENTS.md" "$H/.dsh/AGENTS.md"
cp -a "$B/files/dsh-home/prompt-inject.md" "$H/.dsh/prompt-inject.md"
cp -a "$B/files/dsh-home/rules/." "$H/.dsh/rules/"
cp -a "$B/files/dsh-home/agent-presets/." "$H/.dsh/.agent-presets/"
cp -a "$B/files/home/dsh-bridge.py" "$H/dsh-bridge.py"
cp -a "$B/files/home/dsh-web-start.sh" "$H/dsh-web-start.sh"
cp -a "$B/files/home/.dsh-bridge-token" "$H/.dsh-bridge-token"
cp -a "$B/files/systemd/dsh-web.service" "$H/.config/systemd/user/dsh-web.service"
echo "== 4/4 重启"
systemctl --user daemon-reload || true
systemctl --user restart dsh-web.service || true
systemctl --user is-active dsh-web.service || true
