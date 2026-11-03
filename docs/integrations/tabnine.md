# Tabnine CLI

設定前請先安裝 [Tabnine CLI](https://docs.tabnine.com/main/getting-started/tabnine-cli)。整合鍵為 `tabnine`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration tabnine
```

若是既有的 Spec Kit 專案，請使用 `specify integration install tabnine`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

TOML 命令會安裝為 `.tabnine/agent/commands/speckit.<command>.toml`。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

## 執行階段事件與工作流程分派

原生事件使用 `.tabnine/agent/settings.json`，會將提示詞提交與停止事件對應到 `BeforeAgent` 與 `AfterAgent`。Hook 逾時會轉換為毫秒。`--integration-options="--events false"` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#runtime-events)。

工作流程步驟使用 `tabnine -p <prompt>`，並在已設定模型時傳入 `-m`、在要求結構化輸出時傳入 `--output-format json`。
