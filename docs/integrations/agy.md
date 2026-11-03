# Antigravity

設定前請先安裝 [Antigravity](https://antigravity.google/)。整合鍵為 `agy`。技能版式需要 Antigravity CLI v1.0.0 以上版本，或 Antigravity IDE v2.0.0 以上版本。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration agy
```

若是既有的 Spec Kit 專案，請使用 `specify integration install agy`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.agents/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。此目錄與其他整合共用，因此不要假設它們產生的技能可以毫無重疊地共存。

## 無頭模式權限

自動工具核准預設為停用。在無頭模式的非互動執行中，只有當你打算在沒有互動核准的情況下授權工具動作時，才將 `SPECKIT_AGY_ALLOW_ALL_TOOLS=1` 或 `SPECKIT_INTEGRATION_AGY_ALLOW_ALL_TOOLS=1` 設定為啟用 `--dangerously-skip-permissions`。

## 工作流程分派

工作流程步驟使用 `agy --print <prompt>`。Spec Kit 會以專案根目錄提供 `--add-dir`，讓技能保持可被探索，轉傳已設定的 `--model`，並在要求結構化輸出時傳入 `--output-format json`。沒有整合專屬的設定選項。
