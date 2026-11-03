# Muse Code

設定前請先安裝 [Muse Code](https://dev.meta.ai/docs/muse-code)。整合鍵為 `muse`。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration muse
```

若是既有的 Spec Kit 專案，請使用 `specify integration install muse`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.agents/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。此目錄與其他整合共用，因此不要假設它們產生的技能可以毫無重疊地共存。

選用的 `--integration-options="--skills"` 旗標只是重述預設值；本整合一律產生技能。

## 工作流程分派

工作流程步驟使用 `muse exec <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--json`。
