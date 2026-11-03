# Cursor

設定前請先安裝 [Cursor](https://cursor.sh/)。整合鍵為 `cursor-agent`；IDE 設定不需要另外的 CLI。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration cursor-agent
```

若是既有的 Spec Kit 專案，請使用 `specify integration install cursor-agent`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.cursor/skills/speckit-<command>/SKILL.md`。在 Cursor 的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

## 選項與工作流程權限

選用的 `--integration-options="--skills"` 旗標只是重述預設值；本整合一律產生技能。原生事件使用 `.cursor/hooks.json`；`--events false` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#runtime-events)。

工作流程的命令與提示詞步驟另外需要 `cursor-agent` CLI。分派使用 `-p --trust --approve-mcps --force`：這些旗標會繞過工作區信任提示，並核准 MCP 載入與工具動作。請只在你打算授予這些權限的專案中執行工作流程。已設定的 `--model` 與要求的 `--output-format json` 都會被轉傳。
