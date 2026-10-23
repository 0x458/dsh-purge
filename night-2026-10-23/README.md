# dsh-night-2026-10-23 — DSH 一夜改动存档

来源：GCP Ubuntu，用户 `g0x9458i`，DSH 0.2.1-rc.2 + dsh-purge 1.1.77。
目的：把一次 DSH 折腾的全部改动以源码形式存档，可重放、可回滚。

## 内容

| 路径 | 说明 |
| --- | --- |
| `patches/dsh-internal.patch` | dsh-purge 对 DSH 本体 56 个文件的改动（unified diff，基线是 npm 安装原件） |
| `patches/npm-global-bin.patch` | 对 `~/.npm-global/bin/dsh` 启动器的改动 |
| `files/dsh-home/` | `$DSH_HOME` 下的配置：Venice provider、AGENTS.md、rules、agent-presets、redteam setup |
| `files/home/` | 自建脚本 `dsh-bridge.py`、`dsh-web-start.sh` |
| `files/systemd/` | `dsh-web.service`（systemd --user） |
| `apply.sh` | 应用改动（幂等，覆盖前存 `.pre-bundle` 备份） |
| `restore.sh` | 反打补丁回滚 |

本仓库根目录是 dsh-purge 插件源码本身，本包不修改它。

## 主要改动

1. 给 DSH 的 llm-pi-ai 加 Venice provider
   - `baseURL: https://api.venice.ai/api/v1`，`api: openai-completions`，`apiKeyEnv: VENICE_API_KEY`
   - 三个模型：`deepseek-v4-1-flash-uncensored`、`deepseek-v4-1-flash`、`venice-uncensored-1-2`
   - `agent-default-model` 切到 `venice/deepseek-v4-1-flash-uncensored`
2. `VENICE_API_KEY` 落到 `$DSH_HOME/.env`（600）以及 `.credentials.yaml` 的 refs
3. `dsh-bridge.py`：80 端口的 HTTP 桥，暴露 `/run`、`/read`、`/ping`，用于从外部跑命令
4. `systemd --user` 的 `dsh-web.service`，绑定 Tailscale 地址
5. redteam 预设、rules、AGENTS.md

## 应用

```sh
./apply.sh     # patch -p1 -b --suffix .pre-bundle，然后铺文件、重启服务
./restore.sh   # patch -R 回滚补丁，配置文件保留
```

## 前置条件

- DSH 版本 `0.2.1-rc.2`，且未被 purge 过（补丁基线是干净安装的原件）
- 版本不同会 fuzz 或失败；`apply.sh` 已带备份

## 已知坑

1. **`reasoningEfforts` 必须显式声明档位。** 本包里的 `web-cordis.patch.yml` 仍写 `reasoningEfforts: false`，
   而默认模型带 `reasoningEffort: high`，两者冲突会直接报 `UNSUPPORTED_REASONING_EFFORT`。修法：

   ```yaml
   reasoningEfforts:
     off: null
     low: low
     medium: medium
     high: high
   ```

2. **密钥已脱敏**，替换清单见 `SANITIZED.md`。
