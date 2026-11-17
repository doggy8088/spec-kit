# Codex CLI

設定前請先安裝 [Codex CLI](https://github.com/openai/codex)。整合鍵為 `codex`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#我可以在同一個專案中安裝多個整合嗎)。

## 設定

```bash
specify init my-project --integration codex
```

若是既有的 Spec Kit 專案，請使用 `specify integration install codex`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.agents/skills/speckit-<command>/SKILL.md`。在 Codex 的聊天中以美元符號前綴呼叫它們，例如 `$speckit-specify`，或已安裝 bug 擴充功能的 `$speckit-bug-assess`。其他整合也會以 `.agents/skills/` 為目標；在安裝另一個共用此目錄的代理之前，請先檢視[共用的多重安裝規則](cli.md#我可以在同一個專案中安裝多個整合嗎)。

## 選項與工作流程分派

`--integration-options="--skills"` 會明確選取技能版式，而這已是本整合唯一支援的版式。原生事件使用 `.codex/config.toml`；`--events false` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#執行階段事件)。

工作流程步驟使用 `codex exec <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--json`。Codex 開發模式的註冊會寫入技能檔案，而不是以符號連結指向它們。

## 工作流程分派設定

命令與提示詞步驟可設定 [`reasoning_effort` 與 `context_size`](../workflow-steps/types.md#推理強度與上下文大小)。Codex 分派時會在 `--model` 之後以設定覆寫的方式傳入：

| 步驟設定 | Codex CLI 參數 | 值 |
|---|---|---|
| `reasoning_effort` | `-c model_reasoning_effort="<value>"` | 所選模型支援的層級，例如 `low`、`medium`、`high` 或 `xhigh` |
| `context_size` | `-c model_context_window=<value>` | Token 數量：不含前導零的正整數，最大為 `9223372036854775807` |

Spec Kit 會原樣傳遞 `reasoning_effort`；Codex CLI 0.165.0 不經檢查便將其轉交給模型。Codex 會顯示收到的推理強度，因此請以字面值或工作流程輸入設定，不要使用擷取到的輸出。`context_size` 若不是有效的 token 數量，步驟會在 Codex 啟動前失敗。

`context_size` 會覆寫 Codex 為模型假設的上下文視窗。Codex 會將該值箝制在模型的最大值；低於模型預設值時，可用的上下文會縮小。
