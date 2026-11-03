---
description: 在任務產生之後，對 spec.md、plan.md 與 tasks.md 執行非破壞性的跨產物一致性與品質分析。
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

**檢查擴充功能 hooks（分析之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_analyze` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後照常繼續
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
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

    Wait for the result of the hook command before proceeding to the Goal.
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過

## 目標

在實作之前，找出三份核心產物（`spec.md`、`plan.md`、`tasks.md`）之間的不一致、重複、含糊與規格不足之處。這個命令只能在 `__SPECKIT_COMMAND_TASKS__` 成功產生完整的 `tasks.md` 之後執行。

## 操作限制

**嚴格唯讀**：**不要**修改任何檔案。輸出結構化的分析報告。提供選擇性的補救計畫（在任何後續編輯命令被手動呼叫之前，使用者必須明確核准）。

**憲章權威**：專案憲章（`/memory/constitution.md`）在這個分析範圍內**不可協商**。與憲章衝突一律自動列為 CRITICAL，必須調整規格、計畫或任務——不得稀釋、重新詮釋或默默忽略原則。若原則本身需要變更，必須在 `__SPECKIT_COMMAND_ANALYZE__` 之外，以獨立、明確的憲章更新進行。

## 執行步驟

### 1. 初始化分析背景

從儲存庫根目錄執行一次 `{SCRIPT}`，並解析 JSON 中的 FEATURE_DIR 與 AVAILABLE_DOCS。推導絕對路徑：

- SPEC = FEATURE_DIR/spec.md
- PLAN = FEATURE_DIR/plan.md
- TASKS = FEATURE_DIR/tasks.md

若有任何必要檔案缺失，中止並顯示錯誤訊息（指示使用者執行缺失的前置命令）。
若引數中含單引號，例如 "I'm Groot"，使用跳脫語法：例如 'I'\''m Groot'（或盡可能改用雙引號："I'm Groot"）。

### 2. 載入產物（漸進式揭露）

只從每份產物載入最少必要的背景：

**從 spec.md：**

- 概觀／背景
- 功能需求
- 成功準則（可衡量的成果——例如效能、安全性、可用性、使用者成功、業務影響）
- 使用者故事
- 邊界案例（若有）

**從 plan.md：**

- 架構／堆疊選擇
- 資料模型參照
- 階段
- 技術限制

**從 tasks.md：**

- 任務 ID
- 說明
- 階段分組
- 平行標記 [P]
- 參照的檔案路徑

**從憲章：**

- 載入 `/memory/constitution.md` 以驗證原則

### 3. 建立語意模型

建立內部表示（不要在輸出中加入原始產物）：

- **需求清單**：為每個功能需求（FR-###）與成功準則（SC-###）記錄一個穩定鍵。有明確的 FR-/SC- 識別字時，以它為主鍵；也可以再推導一個祈使句形式的代稱以利閱讀（例如「User can upload file」→ `user-can-upload-file`）。只納入需要可建置工作的成功準則項目（例如負載測試基礎設施、安全性稽核工具），排除上線後的成果指標與業務 KPI（例如「Reduce support tickets by 50%」）。
- **使用者故事／行動清單**：離散的使用者行動，附驗收準則
- **任務涵蓋對應**：將每個任務對應到一或多個需求或故事（依關鍵字推斷／ID 或關鍵詞等明確參照模式）
- **憲章規則集**：擷取原則名稱與 MUST/SHOULD 規範陳述

### 4. 偵測階段（節省 token 的分析）

聚焦於高訊號的發現。總數以 50 項為限；其餘彙整到溢出摘要中。

#### A. 重複偵測

- 找出近似重複的需求
- 標記品質較差的措辭，建議彙整

#### B. 含糊偵測

- 標記缺乏可衡量準則的含糊形容詞（fast、scalable、secure、intuitive、robust）
- 標記未解決的佔位符（TODO、TKTK、???、`<placeholder>` 等）

#### C. 規格不足

- 有動詞但缺少受詞或可衡量成果的需求
- 使用者故事缺少與驗收準則的對齊
- 任務參照了規格／計畫中未定義的檔案或元件

#### D. 憲章對齊

- 任何與 MUST 原則衝突的需求或計畫元素
- 憲章要求但缺失的章節或品質關卡

#### E. 涵蓋缺口

- 沒有任何對應任務的需求
- 沒有對應需求／故事的任務
- 需要可建置工作的成功準則（效能、安全性、可用性）未反映在任務中

#### F. 不一致

- 用語漂移（同一概念在不同檔案中名稱不同）
- 資料實體在計畫中被參照，但規格中沒有（或反之）
- 任務順序矛盾（例如整合任務排在基礎設定任務之前，且沒有相依說明）
- 互相衝突的需求（例如一個要求 Next.js，另一個指定 Vue）

### 5. 嚴重程度指派

用以下經驗法則排定發現的優先順序：

- **CRITICAL**：違反憲章 MUST、核心規格產物缺失，或涵蓋率為零且阻擋基準功能的需求
- **HIGH**：重複或衝突的需求、含糊的安全性／效能屬性、無法測試的驗收準則
- **MEDIUM**：用語漂移、非功能性任務涵蓋缺失、規格不足的邊界案例
- **LOW**：風格／措辭改善、不影響執行順序的輕微冗餘

### 6. 產生精簡分析報告

輸出 Markdown 報告（不寫入檔案），結構如下：

## Specification Analysis Report

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | Duplication | HIGH | spec.md:L120-134 | Two similar requirements ... | Merge phrasing; keep clearer version |

（每個發現一列；產生以分類字首為前綴的穩定 ID。）

**涵蓋摘要表：**

| Requirement Key | Has Task? | Task IDs | Notes |
|-----------------|-----------|----------|-------|

**憲章對齊問題：**（若有）

**未對應的任務：**（若有）

**指標：**

- 需求總數
- 任務總數
- 涵蓋率 %（至少有 1 個任務的需求）
- 含糊數量
- 重複數量
- 關鍵問題數量

### 7. 提供下一步行動

在報告結尾，輸出精簡的下一步行動區塊：

- 若有 CRITICAL 問題：建議在 `__SPECKIT_COMMAND_IMPLEMENT__` 之前先解決
- 若只有 LOW/MEDIUM：使用者可以繼續，但提供改善建議
- 提供明確的命令建議：例如「Run __SPECKIT_COMMAND_SPECIFY__ with refinement」、「Run __SPECKIT_COMMAND_PLAN__ to adjust architecture」、「Manually edit tasks.md to add coverage for 'performance-metrics'」

### 8. 提供補救

詢問使用者：「Would you like me to suggest concrete remediation edits for the top N issues?」（**不要**自動套用。）

### 9. 檢查擴充功能 hooks

回報之後，檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.after_analyze` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後照常繼續
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
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
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過

## 操作原則

### 背景效率

- **最少的高訊號 token**：聚焦於可行動的發現，而非詳盡的文件
- **漸進式揭露**：逐步載入產物；不要將全部內容傾倒進分析
- **節省 token 的輸出**：發現表以 50 列為限；溢出部分做摘要
- **確定性結果**：在沒有變更的情況下重跑，應產生一致的 ID 與計數

### 分析指引

- **絕不修改檔案**（這是唯讀分析）
- **絕不捏造缺失的章節**（若不存在，據實回報）
- **優先處理憲章違規**（這些一律是 CRITICAL）
- **用範例勝於詳盡規則**（引用具體實例，而非一般模式）
- **優雅地回報零問題**（發出附涵蓋統計的成功報告）

## 背景

{ARGS}
