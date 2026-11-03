---
description: 對照功能的規格、計畫與任務評估目前的原始碼，將尚未建置的剩餘工作以新任務附加到 tasks.md，讓 implement 能完成它。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-spec --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireSpec -RequireTasks -IncludeTasks
  py: scripts/python/check_prerequisites.py --json --require-spec --require-tasks --include-tasks
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考慮使用者輸入（若非空白）。

## 執行前檢查

**檢查擴充功能 hooks（收斂之前）**：

- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_converge` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後照常繼續
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **選擇性 hook**（`optional: true`）：

    ```text
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

  - **強制 hook**（`optional: false`）：

    ```text
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to the Goal.
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。

- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過

## 目標

縮小功能的規格、計畫與任務所要求的內容，與原始碼目前實作內容之間的
差距。將 `spec.md`、`plan.md` 與 `tasks.md` 讀作**唯一的
意圖來源**（憲章則是治理限制），評估
程式的現況，判定哪些需求、驗收準則、計畫決策與
既有任務未滿足、不完整或只部分滿足，並**將每一份
剩餘工作以新的、可追溯的任務附加**到 `tasks.md` 底部，讓
`__SPECKIT_COMMAND_IMPLEMENT__` 能完成它。這個命令只能在
`__SPECKIT_COMMAND_IMPLEMENT__` 已對目前的 `tasks.md` 執行過，且 `__SPECKIT_COMMAND_TASKS__` 已產生完整的 `tasks.md` 之後執行。

這**不是**差異工具，也**不**追蹤變更。它評估程式目前的狀態
相對於功能產物的情況——不用 git、不用分支比較、不用歷史紀錄。

## 操作限制

**只附加、絕不重寫**：這個命令**唯一**的寫入，是將一個新的
`## Phase N: Convergence` 章節附加到 `tasks.md`。它不得：

- 以任何方式修改 `spec.md` 或 `plan.md`；
- 重寫、重新編號、重排或刪除任何既有任務（包括先前
  Convergence 階段的任務）；
- 修改、建立或刪除任何應用程式程式碼——完成附加的任務是
  `__SPECKIT_COMMAND_IMPLEMENT__` 的工作。

當原始碼已滿足一切時，這個命令必須讓 `tasks.md`
**逐位元不變**（不要加上空白的 Convergence 標題），並回報乾淨的結果。

**憲章權威**：專案憲章（`/memory/constitution.md`）
**不可協商**。違反 MUST 原則的程式碼是最高嚴重程度的發現，並
產生對應的補救任務。若憲章是尚未填寫的範本，
優雅地跳過憲章檢查，不要失敗。

## 執行步驟

### 1. 初始化收斂背景

從儲存庫根目錄執行一次 `{SCRIPT}`，並解析 JSON 中的 FEATURE_DIR 與 AVAILABLE_DOCS。推導絕對路徑：

- SPEC = FEATURE_DIR/spec.md
- PLAN = FEATURE_DIR/plan.md
- TASKS = FEATURE_DIR/tasks.md
- CONSTITUTION = `/memory/constitution.md`（若有）
若 `spec.md`、`plan.md` 或 `tasks.md` 缺失，停下來並顯示清楚、可行動的訊息，指名要執行的前置命令（規格缺失用 `__SPECKIT_COMMAND_SPECIFY__`、計畫缺失用 `__SPECKIT_COMMAND_PLAN__`、
任務缺失用 `__SPECKIT_COMMAND_TASKS__`）。不要產生部分輸出。
若引數中含單引號，例如 "I'm Groot"，使用跳脫語法：例如 'I'\''m Groot'（或盡可能改用雙引號："I'm Groot"）。

### 2. 載入產物（漸進式揭露）

只從每份產物載入最少必要的背景：

**從 spec.md：**

- 功能需求（FR-###）
- 成功準則（SC-###）——只納入需要可建置工作的項目；排除
  上線後的成果指標與業務 KPI
- 使用者故事及其驗收情境
- 邊界案例（若有）

**從 plan.md：**

- 架構／堆疊選擇與技術決策
- 資料模型參照
- 階段與具名的接觸點（計畫說會建立或編輯的檔案／元件）
- 技術限制

**從 tasks.md：**

- 任務 ID（用來計算下一個 ID 與下一個階段編號）
- 說明、階段分組與參照的檔案路徑

**從憲章（若不是尚未填寫的範本）：**

- 原則名稱與 MUST/SHOULD 規範陳述

### 3. 建立意圖清單

建立內部模型（不要回顯原始產物）：

- **需求清單**：每個 FR-### / SC-### / 使用者故事驗收
  情境一個穩定鍵（例如 `US1/AC2`），再加上計畫決策與憲章原則所
  課予的可建置義務。
- **程式碼範圍圖**：從 `plan.md` 與 `tasks.md` 中指名的檔案路徑，再加上對每個需求所描述概念的關鍵字
  搜尋，推導出評估範圍內的原始檔與
  元件集合。將評估限定在這些範圍內——**不要**推斷
  產物定義以外的範圍。

### 4. 評估原始碼並分類發現

將每個既有任務都納入意圖清單，不論其勾選框狀態或
Convergence 階段為何：完成主張不是證據。對照
規格、計畫、任務與憲章驗證目前的行為；對於修正型任務鏈，評估最終產生的
行為，而不是已被取代的實作細節。同時檢查未滿足的義務，以及
與所述意圖矛盾、超出或落在意圖之外的實作。

對意圖清單中的每個項目，檢查範圍內的目前程式碼，只在有缺口處產生
`Finding`。依**缺口類型**分類每個發現：

- **`missing`**：需要的程式碼中完全沒有這份工作。
- **`partial`**：工作存在，但尚未完全滿足需求／
  驗收準則／計畫決策。
- **`contradicts`**：程式碼做了與所述意圖或
  憲章 MUST 原則衝突的事。
- **`unrequested`**：程式碼包含規格、計畫或任務未要求的工作
  （提出來讓人知道——converge **不**刪除程式碼，它只附加一個任務來
  審查／說明理由或移除它）。

每個 `Finding` 記錄：一個穩定 id、它追溯到的 `source-ref`、`gap-type`、一個
嚴重程度，以及附證據（觀察到的檔案／區域）的簡短易讀說明。

**邊界案例：**

- **程式碼很少或還沒有**：將整個規格範圍視為 `missing` 的剩餘工作，
  不要失敗。
- **沒有剩餘工作**：產生零個發現，並依步驟 7 的已收斂分支處理。

### 5. 指派嚴重程度

- **CRITICAL**：違反憲章 MUST 原則，或阻擋 P1 使用者故事基準功能的 `missing`／`contradicts` 缺口。
- **HIGH**：核心功能需求或驗收準則上的 `missing` 或 `partial` 缺口。
- **MEDIUM**：次要需求上的 `partial` 缺口，或理由不明的 `unrequested` 新增內容。
- **LOW**：輕微的部分缺口、潤飾，或低風險的 `unrequested` 新增內容。

### 6. 呈現工作階段內的發現摘要

在附加任何內容之前，先輸出精簡、依嚴重程度分級的摘要（此時還不要寫入檔案）：

## Convergence Findings

| ID | Gap Type | Severity | Source | Evidence | Remaining Work |
|----|----------|----------|--------|----------|----------------|
| F1 | missing  | HIGH     | FR-008 | Example: no append-only guard detected in path/to/module.py when writing tasks.md | Add append-only enforcement |

**摘要指標：**

- 檢查的需求／驗收準則
- 檢查的計畫決策
- 檢查的憲章原則（或「skipped — template」）
- 依缺口類型統計的發現（missing / partial / contradicts / unrequested）
- 依嚴重程度統計的發現

### 7. 附加收斂任務（或回報已收斂）

**若有一或多個可行動的發現**（`tasks_appended` 成果）：

依附加契約，將內容附加到 `tasks.md` 的**結尾**：

1. 掃描所有既有任務 ID；令 `M` 為最大值。決定下一個階段編號 `N`
   （既有最高階段 + 1）。
2. 寫入單一個新章節標題 `## Phase N: Convergence`。
3. 每個可行動的發現輸出一列檢核清單項目，CRITICAL/HIGH 排在前面，並指派
   補零的 ID `T{M+1:03d}, T{M+2:03d}, …`：

   ```markdown
   - [ ] T042 <imperative description> per <source-ref> (<gap-type>)
   ```

   `<source-ref>` 將任務追溯到它的來源：例如 `FR-003`、`SC-002`、
   `US1/AC2`、`plan: storage decision`、`Constitution II`。

   `<gap-type>` 是 `missing`、`partial`、`contradicts`、`unrequested` 其中之一。

   違反憲章的任務必須排在最前面，並描述為
   `CRITICAL`。
4. 絕不重用或重新編號既有 ID。若已有先前的 Convergence 階段，在它下面新增一個
   獨立編號的新階段——不要動舊的。

**若沒有可行動的發現**（`converged` 成果）：

- 完全**不要**修改 `tasks.md`——不要加上空白的階段標題。
- 回報：**「✅ Converged — the implementation satisfies the spec, plan, and tasks.」**
- 附上檢查內容的摘要計數。

### 8. 提供下一步行動（交接）

- 若是 `tasks_appended`：說明在哪個階段底下附加了多少任務，並建議
  執行 `__SPECKIT_COMMAND_IMPLEMENT__` 完成它們；並指出後續再跑一次 converge
  會找到更少或沒有剩餘項目。
- 若是 `converged`：建議進入審查／開啟 PR。這個功能的規格範圍不需要再做一次 implement。

### 9. 檢查擴充功能 hooks

產生結果之後，檢查專案根目錄是否存在 `.specify/extensions.yml`。

- 若存在，讀取它並尋找 `hooks.after_converge` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後照常繼續
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
- 在列出任何 hooks 之前，先在工作階段內回報
  收斂成果（`converged` 或 `tasks_appended`），讓使用者能決定是否執行選擇性的後續命令。
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **選擇性 hook**（`optional: true`）：

    ```text
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

  - **強制 hook**（`optional: false`）：

    ```text
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。

- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過
