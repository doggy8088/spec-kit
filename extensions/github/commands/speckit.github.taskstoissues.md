---
description: 根據可用的設計產出，將既有任務轉換為可執行、依相依順序排列的 GitHub issues，供該功能使用。
tools: ['github/github-mcp-server/list_issues', 'github/github-mcp-server/issue_write']
scripts:
  sh: scripts/bash/resolve-tasks.sh --json
  ps: scripts/powershell/resolve-tasks.ps1 -Json
  py: scripts/python/resolve_tasks.py --json
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考量使用者輸入（若非空）。

## 執行前檢查

**檢查擴充功能 hooks（在任務轉換為 issues 之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_taskstoissues` 鍵下的條目
- 若 YAML 無法解析或無效，不要默默略過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且未檢查任何 hooks，包括在該處註冊的任何強制（`optional: false`）hooks，然後正常繼續
- 濾除 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個其餘的 hook，**不要**試圖解讀或求值 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null/空，則視該 hook 為可執行
  - 若 hook 定義了非空的 `condition`，略過該 hook，將條件求值留給 HookExecutor 實作
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **強制 hook**（`optional: false`）：
    ```
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to the Outline.
    ```
    在輸出上述區塊之後，你必須實際叫用該 hook 並等待其完成，才能繼續。以你自己在此代理／工作階段中執行命令的相同方式執行它（實際叫用方式可能與上方顯示的字面 `{command}` id 不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行它）。僅輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默略過

## 大綱

1. 在儲存庫根目錄執行 `{SCRIPT}`，並解析 FEATURE_DIR、TASKS 與 AVAILABLE_DOCS 清單。所有路徑都必須是絕對路徑。對於引數中像 "I'm Groot" 這樣的單引號，使用跳脫語法：例如 'I'\''m Groot'（或儘可能用雙引號："I'm Groot"）。
1. **若存在**：載入 `/memory/constitution.md`，取得專案原則與治理限制。
1. 從已執行指令碼的結果中，擷取 **tasks** 的路徑（即 `TASKS` 值）。
1. 執行以下命令取得 Git 遠端：

```bash
git config --get remote.origin.url
```

> [!CAUTION]
> 只有當遠端是 GitHub URL 時，才繼續進行後續步驟

1. **擷取既有 issues 以便去重**：在建立任何東西之前，先從 `tasks.md` 建立你即將處理的任務 ID 集合（每個 ID 都是 `T` 後接**至少**三位數字，例如 `T001`——`__SPECKIT_COMMAND_CONVERGE__` 以 `T{M+1:03d}` 指派新 ID，這是下限而非上限，因此當檔案中的任務超過 999 個時，ID 就會是四位數或更長）。接著使用 GitHub MCP server 的 `list_issues` 工具，尋找已涵蓋這些 ID 的 issues。不要傳入 `state` 值，因為省略它會讓工具同時回傳開啟中與已關閉的 issues。要求 `perPage: 100` 以減少呼叫次數；由於該工具使用以游標為基礎的分頁，以 `after` 參數請求後續頁面（使用前一次回應的 `endCursor`）。對每個 issue 標題，以任務 ID 模式 `\bT\d{3,}\b` 比對（`{3,}` 接受四位數及更長的 ID——若用 `\d{3}`，含有 `T1000` 的標題將完全無法命中，因為尾端的 `\b` 無法落在兩個數字之間，如此該任務就會被默默地既不去重、也不建立；單字邊界仍能阻止像 `ST001` 這樣的詞元命中，並強制整個數字串被完整消耗，因此 `T100` 永遠無法在 `T1000` 內部命中；這也能辨識寫成 `T001 ...`、`T001: ...` 或 `[T001] ...` 的標題），當它命中你的一個任務 ID 時，將該 ID 標記為已有 issue。一旦每個任務 ID 都已命中，或已沒有更多頁面，立即停止分頁，以免在所有任務 ID 都已交代清楚後，還繼續擷取整個儲存庫的 issue 歷史。這能限制 issue 歷史龐大之儲存庫的呼叫次數，同時在 `tasks.md` 重新產生或 skill 被重新叫用後再次執行此命令時，仍可防止重複。
1. 對清單中的每個任務，使用 GitHub MCP server 在 Git 遠端所代表的儲存庫中建立一個新 issue。`tasks.md` 中的任務行以 Markdown 核取方塊開頭，因此先去除開頭的 `- [ ]`（以及任何 `[P]`／`[US#]` 標記），以還原任務 ID 與其說明。以 `T001: <description>` 形式的單一正式標題建立 issue，ID 只寫一次，其後接任務說明（例如，`- [ ] T001 Create project structure` 這一行會成為標題 `T001: Create project structure`）。
   - **略過** ID 已出現在前一步既有 issues 集合中的任何任務，並回報它（例如 `T001 already has an issue, skipping`）。
   - 只為尚未有相符 issue 的任務建立 issues。

> [!CAUTION]
> 在任何情況下，絕對不要在與遠端 URL 不相符的儲存庫中建立 issues

## 執行後檢查

**檢查擴充功能 hooks（在任務轉換為 issues 之後）**：
檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.after_taskstoissues` 鍵下的條目
- 若 YAML 無法解析或無效，不要默默略過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且未檢查任何 hooks，包括在該處註冊的任何強制（`optional: false`）hooks，然後正常繼續
- 濾除 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個其餘的 hook，**不要**試圖解讀或求值 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null/空，則視該 hook 為可執行
  - 若 hook 定義了非空的 `condition`，略過該 hook，將條件求值留給 HookExecutor 實作
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **強制 hook**（`optional: false`）：
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    在輸出上述區塊之後，你必須實際叫用該 hook 並等待其完成，才能繼續。以你自己在此代理／工作階段中執行命令的相同方式執行它（實際叫用方式可能與上方顯示的字面 `{command}` id 不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行它）。僅輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默略過
