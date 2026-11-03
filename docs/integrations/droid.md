# Factory Droid

設定前請先安裝 [Factory Droid](https://docs.factory.ai/cli/getting-started/overview)。整合鍵為 `droid`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration droid
```

若是既有的 Spec Kit 專案，請使用 `specify integration install droid`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.factory/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

產生的技能預設同時可由使用者與模型呼叫。

## 僅限使用者呼叫的技能

若要阻止 Droid 自動呼叫核心 Spec Kit 命令技能：

```bash
specify init my-project --integration droid --integration-options="--no-model-invocation"
```

這會將 `disable-model-invocation: true` 寫入核心命令技能。在 Droid 1.0.0 中，模型不再將它們列入可用技能，因此不會在未經提示的情況下執行它們，而 `/speckit-<command>` 與工作流程分派仍可執行它們。這不是硬性阻擋：點名某個技能的提示詞（例如「use the speckit-specify skill」）仍可讓模型透過它的 `Skill` 工具呼叫該技能。Factory 的[技能文件](https://docs.factory.com/cli/configuration/skills)並未描述此行為。

- 擴充功能技能仍可由模型呼叫，因為強制性的擴充功能 hook 依賴模型呼叫它們。若某個擴充功能的強制 hook 執行核心命令（其 `command:` 是核心的 `speckit.<command>`），請不要啟用此選項：當核心技能僅限使用者呼叫時，模型無法執行該 hook。
- 此選項會與整合的其他選項一併儲存，並由 `specify integration upgrade droid` 重新套用。將 `--integration-options` 傳給 `upgrade` 會取代所有已儲存的選項；`--integration-options=""` 會清除它們。重新執行 `specify init` 同樣只儲存傳入的選項。
- 被預設集覆寫、或不再被預設集覆寫的核心命令技能，會被那些在不重新安裝 Droid 的情況下重新註冊預設集技能的命令還原為預設值：安裝、移除或更新預設集的命令（包括帶有預設集的 `specify bundle` 命令）、`specify integration use droid`，以及當 Droid 已安裝但不是預設整合時的 `specify integration switch droid`。若要重新套用此選項，請在 Droid 是預設整合時執行 `specify integration upgrade droid --force`（需要 `--force`，因為那些命令會修改已安裝的技能檔案，而且它會覆寫對 Spec Kit 管理檔案的本機編輯）。

## 工作流程分派

工作流程步驟使用 `droid exec <prompt>`，轉傳 `--model`，並在適當時要求 `--output-format json`。Spec Kit 不會加上略過權限的旗標。操作者可以透過 `SPECKIT_INTEGRATION_DROID_EXTRA_ARGS` 明確設定權限旗標；這些參數位於 Spec Kit 的模型／輸出旗標之後，在重複旗標解析時可能會覆寫它們。唯一的整合專屬設定選項是 `--no-model-invocation`。
