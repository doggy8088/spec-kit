# RovoDev

設定前請先安裝 [RovoDev](https://www.atlassian.com/software/rovo-dev)。整合鍵為 `rovodev`；執行階段分派使用 `acli rovodev`。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration rovodev
```

若是既有的 Spec Kit 專案，請使用 `specify integration install rovodev`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能與提示詞

本整合會產生 `.rovodev/skills/`、`.rovodev/prompts/` 之下的提示詞包裝，以及 `.rovodev/prompts.yml`。技能使用 `speckit-<command>/SKILL.md` 版式。在代理的聊天中以 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess` 呼叫它們。

提示詞包裝內含 `use skill <name> $ARGUMENTS`。設定程序會依名稱合併清單項目：產生的項目會取代相符的項目，未相符的使用者項目則保留其順序。合併後的 `prompts.yml` 會以整個檔案為單位追蹤：若自設定以來未曾變更，解除安裝時會將它移除，即使其中包含先前合併的使用者項目也一樣。如有需要，請備份該清單。

## 工作流程分派

工作流程步驟使用 `acli rovodev run <prompt>`。執行檔覆寫 `SPECKIT_INTEGRATION_ROVODEV_EXECUTABLE` 取代的是 `acli`，而不是 `rovodev` 子命令。結構化輸出要求會加上 `--output-schema` 與結果物件綱要。工作流程的 `model` 設定不會被轉傳。沒有整合專屬的設定選項；技能模式是無條件適用的。
