# Firebender

設定前請先在 Android Studio 或 IntelliJ 中安裝 [Firebender](https://firebender.com/)。整合鍵為 `firebender`，不需要另外的 CLI。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration firebender
```

若是既有的 Spec Kit 專案，請使用 `specify integration install firebender`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

命令會安裝為 `.firebender/commands/speckit.<command>.mdc`。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

## 工作流程限制

本整合不支援工作流程命令或提示詞步驟的 CLI 分派。它只安裝 IDE 命令，也沒有整合專屬的設定選項。
