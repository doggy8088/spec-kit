# Pi Coding Agent

設定前請先安裝 [Pi Coding Agent](https://pi.dev)。整合鍵為 `pi`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration pi
```

若是既有的 Spec Kit 專案，請使用 `specify integration install pi`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的提示詞

Markdown 提示詞會安裝在 `.pi/prompts/` 之下。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

## 工作流程分派與工具

工作流程步驟使用 `pi -p <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--mode json`（JSONL 事件），而不是 `--output-format`。沒有整合專屬的設定選項。

本整合會產生提示詞檔案；它不會安裝或設定 MCP 伺服器。需要 GitHub 工具的命令，必須在 Pi 中另外設定該工具。請參閱 [Pi 擴充功能](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent#extensions)。
