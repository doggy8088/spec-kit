# Kiro CLI

設定前請先安裝 [Kiro CLI](https://kiro.dev/docs/cli/)。整合鍵為 `kiro-cli`。執行檔相容性檢查也接受 `kiro`，但 `kiro` 不是已註冊的整合鍵。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration kiro-cli
```

若是既有的 Spec Kit 專案，請使用 `specify integration install kiro-cli`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的提示詞

Markdown 提示詞會安裝在 `.kiro/prompts/` 之下。Spec Kit 使用點記法名稱，例如 `speckit.specify`；請使用 Kiro 的[提示詞介面](https://kiro.dev/docs/cli/chat/manage-prompts/)選取它們。

Kiro CLI 不會在檔案型提示詞中替代 `$ARGUMENTS`。因此 Spec Kit 會算繪一段散文備援，指示模型從對話中取得參數。請參閱 [github/spec-kit#1926](https://github.com/github/spec-kit/issues/1926)。

## 工作流程分派

工作流程步驟使用 `kiro-cli` 執行檔並傳入 `-p <prompt>`，在適當時轉傳 `--model` 並要求 `--output-format json`。工具偵測也能辨識 `kiro` 執行檔，但轉接器的預設分派執行檔仍是 `kiro-cli`。若只有 `kiro` 可用，請將 `SPECKIT_INTEGRATION_KIRO_CLI_EXECUTABLE` 設定為其路徑，供工作流程分派使用。沒有整合專屬的設定選項。
