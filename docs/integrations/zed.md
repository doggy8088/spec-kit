# Zed

設定前請先安裝 [Zed](https://zed.dev/)。整合鍵為 `zed`，不需要另外的 CLI。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration zed
```

若是既有的 Spec Kit 專案，請使用 `specify integration install zed`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.agents/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。此目錄與其他整合共用，因此不要假設它們產生的技能可以毫無重疊地共存。

## 工作流程限制

本整合不支援工作流程命令或提示詞步驟的 CLI 分派。它只安裝編輯器技能，也沒有整合專屬的設定選項；不需要、也未宣告 `--skills` 旗標。
