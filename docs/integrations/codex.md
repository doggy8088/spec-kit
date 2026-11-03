# Codex CLI

設定前請先安裝 [Codex CLI](https://github.com/openai/codex)。整合鍵為 `codex`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration codex
```

若是既有的 Spec Kit 專案，請使用 `specify integration install codex`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.agents/skills/speckit-<command>/SKILL.md`。在 Codex 的聊天中以美元符號前綴呼叫它們，例如 `$speckit-specify`，或已安裝 bug 擴充功能的 `$speckit-bug-assess`。其他整合也會以 `.agents/skills/` 為目標；在安裝另一個共用此目錄的代理之前，請先檢視[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 選項與工作流程分派

`--integration-options="--skills"` 會明確選取技能版式，而這已是本整合唯一支援的版式。原生事件使用 `.codex/config.toml`；`--events false` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#runtime-events)。

工作流程步驟使用 `codex exec <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--json`。Codex 開發模式的註冊會寫入技能檔案，而不是以符號連結指向它們。
