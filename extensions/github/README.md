# GitHub 整合擴充功能

這個隨附的**選擇性啟用**擴充功能，是 Spec Kit 的 GitHub *平台*功能的所在之處。目前它提供一個命令 `speckit.github.taskstoissues`，可將某功能的 `tasks.md` 轉換為依相依順序排列的 GitHub issues。

> 注意：`git` 與 `github` 是刻意分開的領域。[`git` 擴充功能](../git/README.md) 負責本機版本控制工作流程（功能分支、提交、遠端偵測）；本擴充功能負責與 GitHub 平台本身的互動。

## 為什麼做成擴充功能？

建立 GitHub issues 屬於特定供應商的專案管理，不屬於供應商中立的規格驅動開發生命週期。將它放在專屬的選擇性啟用擴充功能中，讓使用者可以：

- **自行決定到底要不要安裝**——`specify init` **不會**安裝它。
- **改用其他 issue 追蹤工具**，不必為了 GitHub 專屬的核心命令另尋變通方式。
- 從其他擴充功能**相依於一個穩定的具名空間命令**。

## 安裝

在已初始化的 Spec Kit 專案根目錄執行：

```bash
specify extension add github
```

`generic`（自備代理）整合會在 commands 與 skills 兩種版面中，將此命令註冊於其設定的 `--commands-dir` 之下。安裝 `github` 後，在 commands 模式下會建立 `speckit.github.taskstoissues.md`，在 skills 模式下則建立 `speckit-github-taskstoissues/SKILL.md`。請參閱[各整合專屬選項](https://github.github.io/spec-kit/integrations/cli.html#integration-specific-options)。

## 移除

```bash
specify extension remove github
```

## 命令

| 命令                           | 說明                                                                 |
| ------------------------------ | -------------------------------------------------------------------- |
| `speckit.github.taskstoissues` | 建議使用：將 `tasks.md` 中的任務轉換為依相依順序排列的 GitHub issues。 |

> 注意：上方的命令 ID 是正式的。請依你的整合所用語法叫用它：dot-command 整合用 `/speckit.github.taskstoissues`；slash-hyphen 整合（含 Forge 與 Cline）用 `/speckit-github-taskstoissues`；skills 模式下的 Codex、ZCode 或 Command Code 用 `$speckit-github-taskstoissues`；Kimi 用 `/skill:speckit-github-taskstoissues`。

### 此命令的功能

1. 解析目前作用中的功能並載入其 `tasks.md`（透過本擴充功能自己的 `resolve-tasks` 指令碼——見[指令碼](#指令碼)）。
2. 讀取 Git 遠端，**除非它指向 GitHub，否則停止**。
3. 列出儲存庫中既有的 issues——開啟中*與*已關閉的皆然——並將它們的標題與 `tasks.md` 中的任務 ID 比對（`\bT\d{3,}\b`，因此四位數及更長的 ID 也能處理）。
4. 只為尚未有對應 issue 的任務 ID，在遠端所指明的儲存庫中建立標題為 `T001: <description>` 的 issues。

## Hooks

本擴充功能使用既有的 `before_taskstoissues` 與 `after_taskstoissues` hook 點，它們在執行時從 `.specify/extensions.yml` 讀取。Hook 鍵與核心命令相同，因此其他擴充功能註冊的 hooks——例如 `git` 擴充功能的自動提交 hooks——會一如以往確實觸發。

## 需求

- Spec Kit **0.12.17 或更新版本**。擴充功能本機的 `scripts/...` 路徑重寫在
  0.12.6 引入，但自動註冊的 skills 直到 0.12.17 才會解析 `__SPECKIT_COMMAND_*__` 參照。
  較早的版本無法在每種支援的版面中正確呈現此命令，因此 `specify extension add github` 拒絕在低於 0.12.17 的版本安裝。
- 一個指向 GitHub 的 Git 遠端。
- 你的程式代理可使用 **GitHub MCP server**，並提供 `list_issues` 與 `issue_write` 工具。

> 注意：不支援 MCP 的代理（例如開箱即用的 Pi Coding Agent）無法按預期執行此命令。

## 指令碼

本擴充功能在三種支援的執行環境中都附有自己的功能解析指令碼，因此自給自足，不需伸入核心：

| 執行環境   | 指令碼                                   |
| ---------- | ---------------------------------------- |
| Bash       | `scripts/bash/resolve-tasks.sh`          |
| PowerShell | `scripts/powershell/resolve-tasks.ps1`   |
| Python     | `scripts/python/resolve_tasks.py`        |

安裝後它們位於 `.specify/extensions/github/scripts/` 之下。該指令碼是核心 `check-prerequisites` 的精簡雙生版：它解析專案根目錄與作用中的功能目錄，要求 `plan.md` 與 `tasks.md` 存在，並一併回報隨附的設計文件。`spec.md` 仍為選擇性。預設情況下，`SPECIFY_FEATURE_DIRECTORY` 的覆寫值會保存到 `.specify/feature.json`，讓日後未設定該變數的執行也能解析到同一功能。當 `SPECIFY_FEATURE_NO_PERSIST=1` 或 `true` 時，覆寫值仍會為本次執行選定功能，但指令碼不會建立或修改 `feature.json`。

前置條件錯誤會指出 Spec Kit 命令名稱，但不預設任何整合的叫用語法。請使用[命令](#命令)一節中針對你的整合所描述的語法。

## 從核心 `taskstoissues` 命令遷移

**破壞性變更：**核心命令已被移除。整合升級會刪除舊有受 manifest 追蹤的 `taskstoissues` 命令與 skill 檔案，而不是以更新後的提示詞取代它們。在升級**之前**，將自訂的舊版與擴充功能命令或 skill 檔案備份到產生目錄之外；以 `--force` 強制升級也等同授權刪除自訂的舊版檔案。只能在完成下方遷移步驟之後才重新套用自訂內容，因為升級可能會覆寫產生的擴充功能檔案。安裝本擴充功能不會還原舊的叫用方式，也不提供相容性別名。

對既有專案而言，只升級 CLI 並不會重新整理產生的核心命令檔案。升級 CLI 之後，在專案根目錄執行：

```bash
specify integration upgrade <integration>
```

將 `<integration>` 換成已安裝的整合鍵，或省略它以升級預設整合。對每個已安裝的整合重複此步驟。若本機修改過的檔案阻擋升級，在決定是否以 `--force` 刪除舊版檔案之前，先將它們備份。請參閱[升級整合](https://github.github.io/spec-kit/integrations/cli.html#upgrade-an-integration)。

接著安裝本擴充功能（**若 `github` 已安裝，略過此步驟**），並改用具名空間命令：

```bash
specify extension add github
```

若 `github` 已安裝但被停用，執行 `specify extension enable github`，再執行 `specify integration use <integration>` 以註冊其命令，即使該整合已是預設整合也一樣。

已安裝且已啟用的擴充功能，只會在升級預設整合時重新註冊。在非預設整合中使用替代命令之前，執行 `specify integration use <integration>` 選定該整合，並在該處註冊擴充功能。完成升級、必要時安裝，以及選定整合之後，將你另外備份的自訂內容重新套用到具名空間的擴充功能命令上。

`generic` 整合在其設定的 `--commands-dir` 之下，於 commands 與 skills 兩種版面中都支援此遷移。

| 核心命令                  | 建議的擴充功能命令                |
| ------------------------- | --------------------------------- |
| `/speckit.taskstoissues`  | `/speckit.github.taskstoissues`   |

轉換行為不變：相同的功能解析、相同的 `plan.md` 與 `tasks.md` 前置條件、相同的遠端驗證、對開啟中與已關閉 issues 相同的去重邏輯、相同的 issue 標題，以及相同的 hook 契約。本擴充功能**不會**將 `speckit.taskstoissues` 註冊為別名。

### 預設集與相依的擴充功能

盤點預設集、擴充功能提示詞、工作流程步驟、交接、hook 的 `command` 繫結，
以及專案自動化中對 `speckit.taskstoissues` 的參照。
若要進行 GitHub issue 轉換，使用正式的 `speckit.github.taskstoissues`
命令 ID，並依[命令](#命令)一節中各代理專屬的語法呈現它。
在支援範本呈現之處，將跨命令參照 `__SPECKIT_COMMAND_TASKSTOISSUES__` 換成
`__SPECKIT_COMMAND_GITHUB_TASKSTOISSUES__`。
將 `specify extension add github` 記錄為一項設定前置條件。

保持 `before_taskstoissues` 與 `after_taskstoissues` 事件鍵不變；
擴充功能仍會使用它們。只有當 hook 的 `command` 繫結叫用的是已被移除的 `speckit.taskstoissues` 命令時才更新它，不是僅因 hook 使用了其中一個事件鍵就更新。

若某個擴充功能提案或外部相依性宣告使用了
`requires.commands: [speckit.taskstoissues]`，將其目標更新為
`speckit.github.taskstoissues`。在目前的擴充功能 manifest API 中，`requires.commands` 並非強制執行的相依性欄位，因此不要依賴該宣告
來安裝或檢查 GitHub 擴充功能。請遵循
[擴充功能 API 參考](https://github.github.io/spec-kit/extensions/api.html#extension-manifest)中受支援的需求。

預設集的命令覆寫與命令參照是分開的：對
`speckit.taskstoissues` 的覆寫不會自動自訂具名空間的 GitHub
命令。請審查並移植任何需要的自訂內容，然後在範例專案中驗證已安裝的
命令，再淘汰舊的覆寫。使用其他 issue 追蹤工具的預設集，應保留其供應商專屬的工作流程，
而不是將它轉向 GitHub 命令。
