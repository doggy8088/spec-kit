# Junie

設定前請先安裝 [Junie](https://junie.jetbrains.com/)。整合鍵為 `junie`；Specify 會檢查其 CLI 是否存在。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration junie
```

若是既有的 Spec Kit 專案，請使用 `specify integration install junie`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 命令會安裝在 `.junie/commands/` 之下，使用連字號檔名，例如 `speckit-specify.md`。在 Junie 的聊天中以 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess` 呼叫它們，不要使用點記法命令。

交接參照以及擴充功能／預設集的命令內容，也會一併正規化為連字號名稱。

## 工作流程分派

工作流程步驟使用 `junie --task <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--output-format json`。沒有整合專屬的設定選項。
