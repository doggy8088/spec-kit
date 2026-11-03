---
description: 依據可用的設計產物，為功能產生一份可執行、依相依順序排列的 tasks.md。
handoffs:
  - label: 分析一致性
    agent: speckit.analyze
    prompt: 執行專案一致性分析
    send: true
  - label: 實作專案
    agent: speckit.implement
    prompt: 分階段開始實作
    send: true
scripts:
  sh: scripts/bash/setup-tasks.sh --json
  ps: scripts/powershell/setup-tasks.ps1 -Json
  py: scripts/python/setup_tasks.py --json
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考慮使用者輸入（若非空白）。

## 執行前檢查

**檢查擴充功能 hooks（任務產生之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_tasks` 鍵底下的項目
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

    Wait for the result of the hook command before proceeding to the Outline.
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過

## 大綱

1. **設定**：從儲存庫根目錄執行 `{SCRIPT}`，並解析 FEATURE_DIR、TASKS_TEMPLATE_CONTENT、TASKS_TEMPLATE 與 AVAILABLE_DOCS 清單。`FEATURE_DIR` 與 `TASKS_TEMPLATE` 若有提供，必須是絕對路徑。`AVAILABLE_DOCS` 是 `FEATURE_DIR` 底下可用的文件名稱／相對路徑清單（例如 `research.md` 或 `contracts/`）。若引數中含單引號，例如 "I'm Groot"，使用跳脫語法：例如 'I'\''m Groot'（或盡可能改用雙引號："I'm Groot"）。

2. **載入設計文件**：從 FEATURE_DIR 讀取：
   - **必要**：plan.md（技術堆疊、函式庫、結構）、spec.md（附優先順序的使用者故事）
   - **選擇性**：data-model.md（實體）、contracts/（介面契約）、research.md（決策）、quickstart.md（測試情境）
   - **若存在**：載入 `/memory/constitution.md`，取得專案原則與治理限制
   - 注意：不是所有專案都有全部文件。依可用的文件產生任務。

3. **執行任務產生工作流程**：
   - 載入 plan.md，擷取技術堆疊、函式庫、專案結構
   - 載入 spec.md，擷取使用者故事及其優先順序（P1、P2、P3 等）
   - 若 data-model.md 存在：擷取實體並對應到使用者故事
   - 若 contracts/ 存在：將介面契約對應到使用者故事
   - 若 research.md 存在：擷取決策，作為設定任務的依據
   - 產生依使用者故事組織的任務（見下方的任務產生規則）
   - 產生相依關係圖，顯示使用者故事的完成順序
   - 為每個使用者故事建立平行執行範例
   - 驗證任務完整性（每個使用者故事都有需要的全部任務，且可獨立測試）

4. **產生 tasks.md**：以上方 JSON 輸出的 TASKS_TEMPLATE_CONTENT 作為結構。為相容於省略 TASKS_TEMPLATE_CONTENT 的舊版設定指令碼，改讀 TASKS_TEMPLATE。填入：
   - 從 plan.md 取得的正確功能名稱
   - Phase 1：設定任務（專案初始化）
   - Phase 2：基礎任務（所有使用者故事的阻擋前置條件）
   - Phase 3 起：每個使用者故事一個階段（依 spec.md 的優先順序）
   - 每個階段包含：故事目標、獨立測試準則、測試（若有要求）、實作任務
   - 最後階段：潤飾與跨領域事項
   - 所有任務都必須遵循嚴格的檢核清單格式（見下方的任務產生規則）
   - 每個任務都有清楚的檔案路徑
   - 相依關係一節，顯示故事的完成順序
   - 每個故事的平行執行範例
   - 實作策略一節（MVP 優先、增量交付）

## 強制執行後 Hooks

**在向使用者回報完成之前，你必須先完成這一節。**

檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若它不存在，或 `hooks.after_tasks` 底下沒有註冊任何 hooks，跳到完成報告。
- 若存在，讀取它並尋找 `hooks.after_tasks` 鍵底下的項目。
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後繼續到完成報告。
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **強制 hook**（`optional: false`）——**你必須為每個強制 hook 輸出 `EXECUTE_COMMAND:`**：
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

## 完成報告

輸出產生的 tasks.md 路徑與摘要：
- 任務總數
- 每個使用者故事的任務數
- 找出的平行機會
- 每個故事的獨立測試準則
- 建議的 MVP 範圍（通常就是 User Story 1）
- 格式驗證：確認所有任務都遵循檢核清單格式（勾選框、ID、標籤、檔案路徑）

任務產生的背景：{ARGS}

tasks.md 應可立即執行——每個任務都必須具體到讓 LLM 不需要額外背景就能完成。

## 任務產生規則

**關鍵**：任務必須依使用者故事組織，才能獨立實作與測試。

**測試為選擇性**：只有在功能規格中明確要求，或使用者要求 TDD 做法時，才產生測試任務。

### 檢核清單格式（必要）

每個任務都必須嚴格遵循這個格式：

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**格式組成**：

1. **勾選框**：一律以 `- [ ]` 開頭（Markdown 勾選框）
2. **任務 ID**：依執行順序的流水號（T001、T002、T003……）
3. **[P] 標記**：只有在任務可平行執行時才加入（不同檔案、不相依於未完成的任務）
4. **[Story] 標籤**：只有使用者故事階段的任務才需要
   - 格式：[US1]、[US2]、[US3] 等（對應 spec.md 的使用者故事）
   - 設定階段：沒有故事標籤
   - 基礎階段：沒有故事標籤
   - 使用者故事階段：必須有故事標籤
   - 潤飾階段：沒有故事標籤
5. **說明**：清楚的行動，附確切的檔案路徑

**範例**：

- ✅ CORRECT: `- [ ] T001 Create project structure per implementation plan`
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- ✅ CORRECT: `- [ ] T012 [P] [US1] Create User model in src/models/user.py`
- ✅ CORRECT: `- [ ] T014 [US1] Implement UserService in src/services/user_service.py`
- ❌ WRONG: `- [ ] Create User model` (missing ID and Story label)
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox)
- ❌ WRONG: `- [ ] [US1] Create User model` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [US1] Create model` (missing file path)

### 任務組織

1. **來自使用者故事（spec.md）**——主要組織方式：
   - 每個使用者故事（P1、P2、P3……）都有自己的階段
   - 將所有相關元件對應到它們的故事：
     - 該故事需要的模型
     - 該故事需要的服務
     - 該故事需要的介面／UI
     - 若有要求測試：該故事專屬的測試
   - 標記故事相依關係（多數故事應彼此獨立）

2. **來自契約**：
   - 將每個介面契約對應到它服務的使用者故事
   - 若有要求測試：每個介面契約 → 在該故事階段的實作之前，先有一個契約測試任務 [P]

3. **來自資料模型**：
   - 將每個實體對應到需要它的使用者故事
   - 若實體服務多個故事：放在最早的故事或設定階段
   - 關係 → 適當故事階段中的服務層任務
   - 對於 data-model.md 中有條件限制的每個欄位（最大長度、可為空／必填、列舉值、驗證規則），在任務說明中逐字引用該限制，不要留到實作時自行裁量

4. **來自設定／基礎設施**：
   - 共用基礎設施 → 設定階段（Phase 1）
   - 基礎／阻擋任務 → 基礎階段（Phase 2）
   - 故事專屬的設定 → 放在該故事的階段內

### 階段結構

- **Phase 1**：設定（專案初始化）
- **Phase 2**：基礎（阻擋前置條件——必須在使用者故事之前完成）
- **Phase 3 起**：依優先順序排列的使用者故事（P1、P2、P3……）
  - 每個故事內部：測試（若有要求）→ 模型 → 服務 → 端點 → 整合
  - 每個階段都應是一個完整、可獨立測試的增量
- **最後階段**：潤飾與跨領域事項

## 完成條件

- [ ] tasks.md 已產生，包含所有階段、任務 ID 與檔案路徑
- [ ] 擴充功能 hooks 已依上方強制執行後 Hooks 的規則派送或跳過
- [ ] 已向使用者回報完成，附任務數、故事明細與 MVP 範圍
