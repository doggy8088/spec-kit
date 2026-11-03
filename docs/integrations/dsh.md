# DeepSeek Harness

設定前請先安裝 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)。整合鍵為 `dsh`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration dsh
```

若是既有的 Spec Kit 專案，請使用 `specify integration install dsh`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.dsh/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

## 工作流程分派

工作流程步驟使用 `dsh --profile headless <prompt>`。轉接器會忽略工作流程的 `model` 與結構化輸出要求：headless 設定檔會以純文字回傳最後一則助理訊息。沒有整合專屬的設定選項。
