# Claude Code

設定前請先安裝 [Claude Code](https://www.anthropic.com/claude-code)。整合鍵為 `claude`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration claude
```

若是既有的 Spec Kit 專案，請使用 `specify integration install claude`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.claude/skills/speckit-<command>/SKILL.md`。在 Claude 的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

## 僅限使用者呼叫的技能

預設情況下，為 Claude Code 安裝的每個 Spec Kit 技能都可由模型呼叫，因此它的說明永遠在 Claude 的上下文中，並占用技能清單的預算。在技能眾多的專案中，這可能把其他技能擠出清單。若要讓核心 Spec Kit 命令技能僅限使用者呼叫：

```bash
specify init my-project --integration claude --integration-options="--no-model-invocation"
```

這會將 `disable-model-invocation: true` 寫入核心命令技能。Claude 只有在使用者呼叫 `/speckit-<command>` 時才能執行它們，而且它們的說明不會出現在其上下文中。

- 擴充功能技能仍可由模型呼叫，因為強制性的擴充功能 hook 依賴模型呼叫它們。若某個擴充功能的強制 hook 執行核心命令（其 `command:` 是核心的 `speckit.<command>`），請不要啟用此選項：當核心技能僅限使用者呼叫時，模型無法執行該 hook。
- 此選項會與整合的其他選項一併儲存，並由 `specify integration upgrade claude` 重新套用。將 `--integration-options` 傳給 `upgrade` 會取代所有已儲存的選項，因此請重複列出你想保留的選項（例如 `--integration-options="--events false --no-model-invocation"`）；`--integration-options=""` 會清除它們。重新執行 `specify init` 同樣只儲存傳入的選項。
- 被預設集覆寫、或不再被預設集覆寫的核心命令技能，會被那些在不重新安裝 Claude 的情況下重新註冊預設集技能的命令還原為預設值：安裝、移除或更新預設集的命令（包括帶有預設集的 `specify bundle` 命令）、`specify integration use claude`，以及當 Claude 已安裝但不是預設整合時的 `specify integration switch claude`。若要重新套用此選項，請在 Claude 是預設整合時執行 `specify integration upgrade claude --force`（需要 `--force`，因為那些命令會修改已安裝的技能檔案，而且它會覆寫對 Spec Kit 管理檔案的本機編輯）。

## 執行階段事件與工作流程分派

本整合透過 `.claude/settings.json` 支援原生事件。使用 `--integration-options="--events false"` 可停用 Spec Kit 事件處理常式；若兩項設定都需要，可將它與 `--no-model-invocation` 併用。請參閱[執行階段事件](cli.md#runtime-events)。

工作流程步驟使用 `claude -p <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--output-format json`。此轉接器本身不會加上略過權限的旗標。
