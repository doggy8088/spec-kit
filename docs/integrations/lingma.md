# Lingma

設定前請先在你的 IDE 中安裝 [Lingma](https://lingma.aliyun.com/)。整合鍵為 `lingma`，不需要另外的 CLI。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration lingma
```

若是既有的 Spec Kit 專案，請使用 `specify integration install lingma`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會自動安裝為 `.lingma/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

選用的 `--integration-options="--skills"` 旗標只是重述預設值；本整合一律產生技能。

## 工作流程限制

本整合不支援工作流程命令或提示詞步驟的 CLI 分派；它支援的途徑是 IDE 技能介面。
