# Alquimia AI

設定前請先安裝 [Alquimia AI CLI](https://docs.alquimia.ai)。整合鍵為 `alquimia`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration alquimia
```

若是既有的 Spec Kit 專案，請使用 `specify integration install alquimia`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.alquimia/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

產生的技能同時可由使用者與模型呼叫；受支援的核心技能還會附上行內參數提示。

## 工作流程分派

工作流程的命令與提示詞步驟使用 `alquimia -p <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--output-format json`。沒有整合專屬的設定選項。
