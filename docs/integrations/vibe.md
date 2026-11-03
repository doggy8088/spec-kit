# Mistral Vibe

設定前請先安裝 [Mistral Vibe](https://github.com/mistralai/mistral-vibe)。整合鍵為 `vibe`。技能版式需要 Mistral Vibe v2.0.0 以上版本。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration vibe
```

若是既有的 Spec Kit 專案，請使用 `specify integration install vibe`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.vibe/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

產生的技能預設同時可由使用者與模型呼叫。選用的 `--integration-options="--skills"` 旗標只是重述預設值。

## 僅限使用者呼叫的技能

若要阻止 Mistral Vibe 自動呼叫核心 Spec Kit 命令技能：

```bash
specify init my-project --integration vibe --integration-options="--no-model-invocation"
```

這會將 `disable-model-invocation: true` 寫入核心命令技能。依 Mistral Vibe 的 [README](https://github.com/mistralai/mistral-vibe#skills-system)，這樣的技能僅限明確呼叫：你仍可呼叫 `/speckit-<command>`，但模型不會看到它、也不會自動呼叫它。

- 擴充功能技能仍可由模型呼叫，因為強制性的擴充功能 hook 依賴模型呼叫它們。若某個擴充功能的強制 hook 執行核心命令（其 `command:` 是核心的 `speckit.<command>`），請不要啟用此選項：當核心技能僅限使用者呼叫時，模型無法執行該 hook。
- 此選項會與整合的其他選項一併儲存，並由 `specify integration upgrade vibe` 重新套用。將 `--integration-options` 傳給 `upgrade` 會取代所有已儲存的選項；`--integration-options=""` 會清除它們。重新執行 `specify init` 同樣只儲存傳入的選項。
- 被預設集覆寫、或不再被預設集覆寫的核心命令技能，會被那些在不重新安裝 Mistral Vibe 的情況下重新註冊預設集技能的命令還原為預設值：安裝、移除或更新預設集的命令（包括帶有預設集的 `specify bundle` 命令）、`specify integration use vibe`，以及當 Mistral Vibe 已安裝但不是預設整合時的 `specify integration switch vibe`。若要重新套用此選項，請在 Mistral Vibe 是預設整合時執行 `specify integration upgrade vibe --force`（需要 `--force`，因為那些命令會修改已安裝的技能檔案，而且它會覆寫對 Spec Kit 管理檔案的本機編輯）。

## 執行階段事件

原生事件使用 `.vibe/hooks.toml`。Vibe 只支援 `pre_tool_use`、`post_tool_use` 與 `stop`，分別對應到 `pre_tool`、`post_tool` 與 `post_agent`。Vibe 不會發出工作階段開始、工作階段結束與提示詞提交事件；不受支援的處理常式會被略過並發出警告。`--integration-options="--events false"` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#runtime-events)。

Spec Kit 只會重新整理與移除它自己寫入的 `[[hooks]]` 項目，這些項目帶有 `speckit_marker = true`。每個項目在其最後一行 TOML 以及緊接其後的空白行處結束，因此跟在 Spec Kit 項目後面的註解（例如你自己的 hook 上方的說明）會留在檔案中。若移除 Spec Kit 的項目後只剩下註解與空白行，Spec Kit 會刪除 `.vibe/hooks.toml`，那些註解也會一併被刪除。Spec Kit 對 Codex 的 `.codex/config.toml` 也套用相同規則。

## 工作流程分派

工作流程步驟使用 `vibe -p <prompt>`，並要求以 `--output json` 取得結構化輸出。轉接器會忽略工作流程的 `model` 設定。請改用 Vibe 的 `active_model` 設定或 `VIBE_ACTIVE_MODEL` 選取模型。
