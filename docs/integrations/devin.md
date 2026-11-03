# Devin for Terminal

設定前請先安裝 [Devin for Terminal](https://cli.devin.ai/docs)。整合鍵為 `devin`。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration devin
```

若是既有的 Spec Kit 專案，請使用 `specify integration install devin`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.devin/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

## 選項與工作流程分派

選用的 `--integration-options="--skills"` 旗標只是重述預設值；本整合一律產生技能。原生事件使用 `.devin/hooks.v1.json`；`--events false` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#runtime-events)。

工作流程步驟使用 `devin -p <prompt>`，並轉傳已設定的 `--model`。即使要求結構化輸出，Devin 的轉接器仍回傳純文字 stdout；它不會加上 JSON 輸出旗標。
