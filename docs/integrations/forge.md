# Forge

設定前請先安裝 [Forge](https://forgecode.dev/)。整合鍵為 `forge`。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration forge
```

若是既有的 Spec Kit 專案，請使用 `specify integration install forge`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 命令會安裝在 `.forge/commands/` 之下，使用點記法檔名，例如 `speckit.specify.md`。它們在 frontmatter 中的命令名稱則是連字號形式，例如 `speckit-specify`；檔名與呼叫名稱並不相同。在代理的聊天中以 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess` 呼叫它們，不要使用點記法命令。

Forge 範本使用 `{{parameters}}` 作為參數。Spec Kit 會在核心設定期間移除不相容的 `handoffs` frontmatter。

## 工作流程分派

工作流程步驟使用 `forge -p <prompt>`。轉接器不會轉傳已設定的 `model`，也不會加上結構化輸出旗標。請在 Forge 自己的設定中選取模型，例如使用 `forge config set model`。沒有整合專屬的設定選項。
