# Cline

設定前請先在你的 IDE 中安裝 [Cline](https://github.com/cline/cline)。整合鍵為 `cline`，不需要另外的 CLI。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration cline
```

若是既有的 Spec Kit 專案，請使用 `specify integration install cline`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 工作流程會安裝在 `.clinerules/workflows/` 之下，使用連字號檔名，例如 `speckit-specify.md`。在 Cline 的聊天中以 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess` 呼叫它們，不要使用點記法命令。

交接參照以及擴充功能／預設集的命令內容，也會正規化為連字號命令名稱，因此擴充功能命令中的 `/speckit.git.commit` 會變成 `/speckit-git-commit`。路徑中的 `speckit.*.md` 檔名，例如 `.specify/extensions/git/commands/speckit.git.commit.md`、`C:\speckit.foo.md`、`C:\Program Files (x86)\speckit.foo.md`、`%TEMP%\speckit.foo.md` 或 `./commands[old]/speckit.foo.md`，會保留其點號與 `.md` 副檔名。裸露或帶斜線前綴的符記，例如 `/speckit.foo.md`，會被視為命令參照並改為連字號形式。核心命令內容不會以此方式改寫。

## 工作流程限制

本整合不支援工作流程命令或提示詞步驟的 CLI 分派。它只安裝 IDE 工作流程，也沒有整合專屬的設定選項。
