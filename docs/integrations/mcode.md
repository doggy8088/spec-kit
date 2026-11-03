# MiniMax Code

設定前請先安裝 [MiniMax Code](https://github.com/MiniMax-AI/minimax-code)。整合鍵為 `mcode`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration mcode
```

若是既有的 Spec Kit 專案，請使用 `specify integration install mcode`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.minimax/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

選用的 `--integration-options="--skills"` 旗標只是重述預設值；本整合一律產生技能。

## 無頭模式權限

無頭模式的工作流程分派使用 `--permission full`，讓工具動作不會被無頭模式的權限把關擋下。若要改用 MiniMax Code 較嚴格的政策，請設定 `SPECKIT_INTEGRATION_MCODE_EXTRA_ARGS="--permission smart"`。

分派使用 `mcode exec <prompt>`。已設定的 `--model` 與要求的 `--output-format json` 都會被轉傳。
