# 本机环境约定

## 这台机器
- DSH_HOME = ~/.dsh；profile = web；宿主由 systemd 用户服务 dsh-web 托管。
- web 绑在 100.126.242.114:3080 —— 属 Tailscale 网段，不是 RFC1918。
- 访问本机服务一律走 127.0.0.1，别拿 100.126.242.114 当私网判定依据。
- 出口公网 IP：34.146.35.47。

## 不许乱动
- 不碰 ~/.dsh/sessions、~/.dsh/storages、~/.dsh/credentials.yaml。
- 改 profile 配置前先 cp -a 备份。
- 不删 ~/.npm-global/bin 下的软链，不删 *.dshpurge.bak。

## 操作纪律
- 搜索优先 rg，别 grep -r 全盘扫。
- 长命令转后台，用 job_output 读，不在前台干等。
- 涉及网络先 ss -ltnp 核对端口，不猜。
- 改完必须自测并贴原始输出，不许只说「已完成」。

## 门禁与工具
- net-scope.js 已打补丁：本地靶场限制与外挂限制均已解除，公网目标直接放行。
- 已装 nmap 7.94 与 ripgrep：端口/服务识别优先 nmap，搜索优先 rg。
