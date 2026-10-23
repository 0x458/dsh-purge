# 脱敏说明

推送到公开仓库前，下列真实值已被替换成占位符。要恢复的话，把占位符换回自己的值。

| 文件 | 位置 | 占位符 | 原值前缀 |
| --- | --- | --- | --- |
| `files/dsh-home/.env` | `VENICE_API_KEY` | `<YOUR_VENICE_KEY>` | `VENICE_INFERENCE_KEY_n88Z2...` |
| `files/dsh-home/.credentials.yaml` | `refs.VENICE_API_KEY` | `<YOUR_VENICE_KEY>` | 同上 |
| `files/dsh-home/.credentials.yaml` | `refs.DEEPSEEK_API_KEY` | `<YOUR_DEEPSEEK_KEY>` | `sk-0e60eb...` |
| `files/dsh-home/.credentials.yaml` | `refs.DSH_TELEGRAM_BOT_TOKEN_*` | `<YOUR_TELEGRAM_BOT_TOKEN>` | `8865713580:...` |
| `files/dsh-home/.credentials.yaml` | `records.*.secret` | `<YOUR_BROWSER_SESSION_SECRET>` | `tuN2W4UT...` |
| `files/home/.dsh-bridge-token` | 整个文件 | `<YOUR_BRIDGE_TOKEN>` | `6NLLod4s...` |

未脱敏（不算密钥）：`files/systemd/dsh-web.service` 里的 Tailscale IP、`files/dsh-home/web-cordis.patch.yml` 里的模型 id 与 baseURL。
