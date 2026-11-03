# opencode

設定前請先安裝 [opencode](https://opencode.ai/)。整合鍵為 `opencode`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration opencode
```

若是既有的 Spec Kit 專案，請使用 `specify integration install opencode`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 命令會安裝在 `.opencode/commands/` 之下。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

當正規目錄不存在時，舊版的 `.opencode/command/` 安裝仍作為註冊的備援途徑。

## 執行階段事件與工作流程分派

原生事件使用 `.opencode/plugin/speckit-events.ts`，而不是 JSON hook 對應表；Spec Kit 會將其外掛程式參照合併到 `opencode.json` 中。`--integration-options="--events false"` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#runtime-events)。

工作流程步驟使用 `opencode run`。以斜線開頭的提示詞會變成 `--command <name>`，其餘文字作為訊息；其他提示詞則以訊息文字傳入。轉接器會以 `-m` 轉傳已設定的模型，並在要求結構化輸出時傳入 `--format json`。
