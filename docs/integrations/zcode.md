# ZCode

設定前請先安裝 [ZCode](https://zcode.z.ai/)。整合鍵為 `zcode`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration zcode
```

若是既有的 Spec Kit 專案，請使用 `specify integration install zcode`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.zcode/skills/speckit-<command>/SKILL.md`。在代理的聊天中以美元符號前綴呼叫它們，例如 `$speckit-specify`，或已安裝 bug 擴充功能的 `$speckit-bug-assess`。

選用的 `--integration-options="--skills"` 旗標只是重述預設值；本整合一律產生技能。

## 工作流程分派

工作流程步驟使用 `zcode -p <prompt>`，並要求以 `--output-format json` 取得結構化輸出。轉接器會忽略工作流程的 `model` 設定，因為 ZCode 沒有每次呼叫專用的模型旗標；請在工作階段中以 `/model` 選取模型。
