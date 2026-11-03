# Kilo Code

設定前請先在你的 IDE 中安裝 [Kilo Code](https://github.com/Kilo-Org/kilocode)。整合鍵為 `kilocode`，不需要另外的 CLI。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration kilocode
```

若是既有的 Spec Kit 專案，請使用 `specify integration install kilocode`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 命令會安裝在 `.kilo/commands/` 之下。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

舊版的 `.kilocode/workflows/` 安裝仍受支援，作為註冊的備援途徑。

升級會將清單追蹤的核心命令遷移到 `.kilo/commands/`。若預設集的命令覆寫影響到舊版目錄，升級會在變更任何檔案之前被拒絕；請先移除預設集、完成升級，再重新安裝它們。無法讀取的預設集註冊表也會阻擋該遷移。

## 工作流程限制

本整合不支援工作流程命令或提示詞步驟的 CLI 分派。它只安裝 IDE 命令，也沒有整合專屬的設定選項。
