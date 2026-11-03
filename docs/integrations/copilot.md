# GitHub Copilot

在你的編輯器中設定 [GitHub Copilot](https://code.visualstudio.com/)，或使用 Copilot CLI。整合鍵為 `copilot`；IDE 設定不需要 CLI。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration copilot
```

若是既有的 Spec Kit 專案，請使用 `specify integration install copilot`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 預設技能版式

技能會安裝為 `.github/skills/speckit-<command>/SKILL.md`。在代理的聊天中以 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess` 呼叫它們。這些是代理技能，不是終端機命令。產生的技能預設同時可由使用者與模型呼叫。

## 僅限使用者呼叫的技能

若要阻止 Copilot 在技能版式中自動載入核心 Spec Kit 命令技能：

```bash
specify init my-project --integration copilot --integration-options="--no-model-invocation"
```

這會將 `disable-model-invocation: true` 寫入核心命令技能。VS Code 的[代理技能文件](https://code.visualstudio.com/docs/agent-customization/agent-skills)表示，這需要只能透過 `/` 斜線命令手動呼叫。GitHub 的 Copilot CLI 技能文件並未列出此欄位，但在以 Copilot CLI 1.0.70 進行的人工檢查中，沒有此旗標時模型曾為 `speckit-specify` 呼叫它的 `skill` 工具，有此旗標時則沒有，而明確的 `/speckit-specify` 仍可執行。有了此旗標，模型仍可將技能的 `SKILL.md` 作為一般檔案讀取，因此這不是硬性阻擋。兩個來源都沒有說明帶有此旗標的技能是否會將其說明排除在模型的上下文之外。

- 此選項在命令版式中沒有作用，無論是以 `--commands` 明確選取，或是在未傳入版式旗標時從既有安裝保留下來：`.agent.md` 與 `.prompt.md` 檔案不是技能，也不會寫入任何旗標。
- 擴充功能技能仍可由模型呼叫，因為強制性的擴充功能 hook 依賴模型呼叫它們。若某個擴充功能的強制 hook 執行核心命令（其 `command:` 是核心的 `speckit.<command>`），請不要啟用此選項：當核心技能僅限使用者呼叫時，模型無法執行該 hook。
- 此選項會與整合的其他選項一併儲存，並由 `specify integration upgrade copilot` 重新套用。將 `--integration-options` 傳給 `upgrade` 會取代所有已儲存的選項；`--integration-options=""` 會清除它們。重新執行 `specify init` 同樣只儲存傳入的選項。
- 被預設集覆寫、或不再被預設集覆寫的核心命令技能，會被那些在不重新安裝 Copilot 的情況下重新註冊預設集技能的命令還原為預設值：安裝、移除或更新預設集的命令（包括帶有預設集的 `specify bundle` 命令）、`specify integration use copilot`，以及當 Copilot 已安裝但不是預設整合時的 `specify integration switch copilot`。若要重新套用此選項，請在 Copilot 是預設整合時執行 `specify integration upgrade copilot --force`（需要 `--force`，因為那些命令會修改已安裝的技能檔案，而且它會覆寫對 Spec Kit 管理檔案的本機編輯）。

## 命令版式

若要選用受支援的命令版式：

```bash
specify init my-project --integration copilot --integration-options="--commands"
```

這會在 `.github/agents/` 之下安裝 `.agent.md` 檔案，在 `.github/prompts/` 之下安裝配套的 `.prompt.md` 檔案，並合併 `.vscode/settings.json`。在此版式中，Copilot CLI 可以透過 `/agents` 選取代理，或在提示詞中直接點名它。

在以 `specify integration upgrade copilot` 遷移既有的命令安裝時，使用 `--integration-options="--skills"` 可明確選取預設的技能版式。傳入它會取代所有已儲存的選項，因此請列出你想保留的選項：例如，若該值中沒有 `--no-model-invocation`，遷移後的技能會被寫成可由模型呼叫。請參閱[共用的升級規則](cli.md#upgrade-an-integration)，包括在預設集成品已註冊時變更版式的限制。

`--skills` 與 `--commands` 互斥。在沒有明確版式旗標的情況下，既有的受管理命令安裝在升級或啟用時會保留其版式；全新安裝則預設使用技能。

命令版式只會加入缺少的 VS Code 設定與子鍵。既有值保持不變。若既有的設定檔是 JSONC，或無法解析為 JSON 物件，合併會被略過，並發出警告與手動操作說明。既有的合併設定檔在解除安裝時會被保留；新建立的設定檔則由清單追蹤。

## 執行階段事件與工作流程權限

原生事件使用 `.github/hooks/speckit.json`。`--integration-options="--events false"` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#runtime-events)。

工作流程步驟另外需要 Copilot CLI，與 IDE 設定分開。在技能模式中，命令步驟會在提示詞中傳入 `/speckit-<command>`。在命令模式中，它們會選取 `--agent speckit.<command>`，並將使用者的參數作為提示詞傳入，而不是把代理檔案當作斜線命令。

無頭分派預設會加上 `--yolo`，允許工具、路徑與 URL 在沒有互動核准的情況下執行。將 `SPECKIT_COPILOT_ALLOW_ALL_TOOLS=0` 設為可阻止 Spec Kit 加上此旗標。已淘汰的 `SPECKIT_ALLOW_ALL_TOOLS` 只作為備援被接受。已設定的 `--model` 與要求的 `--output-format json` 都會被轉傳。
