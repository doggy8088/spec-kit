# Grok Build

設定前請先安裝 [Grok Build](https://docs.x.ai/build/overview)。整合鍵為 `grok`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration grok
```

若是既有的 Spec Kit 專案，請使用 `specify integration install grok`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.grok/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

## 工作流程權限

工作流程步驟使用 `grok -p <prompt> --always-approve`，會自動核准工具執行。請只在你打算授予該權限的環境中執行工作流程。已設定的 `--model` 與要求的 `--output-format json` 都會被轉傳。沒有整合專屬的設定選項。
