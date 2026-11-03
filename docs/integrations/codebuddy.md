# CodeBuddy CLI

設定前請先安裝 [CodeBuddy CLI](https://www.codebuddy.cn/docs/cli/installation)。整合鍵為 `codebuddy`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration codebuddy
```

若是既有的 Spec Kit 專案，請使用 `specify integration install codebuddy`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 命令會安裝在 `.codebuddy/commands/` 之下。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

## 工作流程分派

工作流程步驟使用 `codebuddy -p <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--output-format json`。沒有整合專屬的設定選項。
