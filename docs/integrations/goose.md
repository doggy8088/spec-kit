# Goose

設定前請先安裝 [Goose](https://goose-docs.ai/)。整合鍵為 `goose`。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration goose
```

若是既有的 Spec Kit 專案，請使用 `specify integration install goose`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的配方

Goose 使用 YAML 配方，安裝為 `.goose/recipes/speckit.<command>.yaml`。Spec Kit 的工作流程分派會將 `/speckit.<command>` 呼叫轉換為配方執行，並把尾隨參數作為配方的 `args` 參數傳入。互動執行請使用 Goose 的配方介面，不要假設這些配方是技能。

## 工作流程分派

分派時，`/speckit.<command>` 提示詞使用 `goose run --recipe <path>`，其他提示詞文字（包括非 Spec Kit 的斜線命令）則使用 `goose run -t <prompt>`。已設定的 `--model` 與要求的 `--output-format json` 都會被轉傳。

請避免在 `SPECKIT_INTEGRATION_GOOSE_EXTRA_ARGS` 中重複單值旗標，例如 `--model`、`--recipe` 或 `--output-format`；Goose 會拒絕重複出現的旗標，而不是採用最後一個值。沒有整合專屬的設定選項。
