# SHAI (OVHcloud)

設定前請先安裝 [SHAI](https://github.com/ovh/shai)。整合鍵為 `shai`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration shai
```

若是既有的 Spec Kit 專案，請使用 `specify integration install shai`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 命令會安裝在 `.shai/commands/` 之下，使用點記法名稱，例如 `speckit.specify.md`。

## 工作流程限制

工作流程的 `command` 與 `prompt` 步驟無法透過 SHAI 執行。它的 CLI 接受以參數、stdin 或透過 `shai agent` 傳入的提示詞文字，但會將其交給自動修復代理，且從不載入 `.shai/commands/`，因此這些步驟會失敗。

轉接器會明確拒絕 CLI 分派，而不是在未執行已安裝命令的情況下回報成功。沒有整合專屬的設定選項。
