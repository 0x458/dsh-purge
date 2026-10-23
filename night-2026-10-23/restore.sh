#!/bin/sh
# 只回滚 DSH 内部与启动器补丁 (patch -R); 配置文件保留
B=$(cd "$(dirname "$0")" && pwd)
H=${HOME:-/home/g0x9458i}
D=$H/.npm-global/lib/node_modules/@deepseek-ai/dsh
patch -R -p1 -d "$D" < "$B/patches/dsh-internal.patch" || true
patch -R -p1 -d "$H/.npm-global/bin" < "$B/patches/npm-global-bin.patch" || true
systemctl --user restart dsh-web.service || true
