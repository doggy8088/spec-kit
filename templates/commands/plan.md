---
description: 使用計畫範本執行實作規劃工作流程，產生設計產物。
handoffs:
  - label: 建立任務
    agent: speckit.tasks
    prompt: 將計畫拆解為任務
    send: true
  - label: 建立檢核清單
    agent: speckit.checklist
    prompt: 為以下領域建立一份檢核清單……
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
  py: scripts/python/setup_plan.py --json
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考慮使用者輸入（若非空白）。

## 執行前檢查

**檢查擴充功能 hooks（規劃之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_plan` 鍵底下的項目
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

1. **設定**：從儲存庫根目錄執行 `{SCRIPT}`，並解析 JSON 中的 FEATURE_SPEC、IMPL_PLAN、FEATURE_DIR、BRANCH。若引數中含單引號，例如 "I'm Groot"，使用跳脫語法：例如 'I'\''m Groot'（或盡可能改用雙引號："I'm Groot"）。

2. **載入背景**：讀取 FEATURE_SPEC 與 `/memory/constitution.md`。載入 IMPL_PLAN 範本（已複製）。

3. **執行計畫工作流程**：依照 IMPL_PLAN 範本的結構：
   - 填寫技術背景（未知項標記為「NEEDS CLARIFICATION」）
   - 從憲章填寫憲章檢查一節
   - 評估關卡（違規且無正當理由時回報 ERROR）
   - Phase 0：產生 research.md（解決所有 NEEDS CLARIFICATION）
   - Phase 1：產生 data-model.md、contracts/、quickstart.md
   - 設計之後重新評估憲章檢查

## 強制執行後 Hooks

**在向使用者回報完成之前，你必須先完成這一節。**

檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若它不存在，或 `hooks.after_plan` 底下沒有註冊任何 hooks，跳到完成報告。
- 若存在，讀取它並尋找 `hooks.after_plan` 鍵底下的項目。
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

命令在 Phase 1 設計之後結束。回報分支、IMPL_PLAN 路徑與產生的產物。

## 階段

### Phase 0：大綱與研究

1. **從上方的技術背景擷取未知項**：
   - 每個 NEEDS CLARIFICATION → 一個研究任務
   - 每個相依套件 → 一個最佳實務任務
   - 每個整合 → 一個模式任務

2. **產生並派送研究代理**：

   ```text
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **彙整發現**到 `research.md`，格式如下：
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**輸出**：research.md，所有 NEEDS CLARIFICATION 都已解決

### Phase 1：設計與契約

**前置條件：** `research.md` 已完成

1. **從功能規格擷取實體** → `data-model.md`：
   - 實體名稱、欄位、關係
   - 來自需求的驗證規則
   - 狀態轉換（若適用）

2. **定義介面契約**（若專案有外部介面）→ `/contracts/`：
   - 找出專案對使用者或其他系統公開的介面
   - 記錄適合該專案類型的契約格式
   - 範例：函式庫的公開 API、CLI 工具的命令結構描述、Web 服務的端點、剖析器的文法、應用程式的 UI 契約
   - 若專案純屬內部用途（建置指令碼、一次性工具等），跳過

3. **建立快速入門驗證指南** → `quickstart.md`：
   - 記錄可執行的驗證情境，證明功能可端到端運作
   - 加入前置條件、設定命令、測試／執行命令與預期成果
   - 用連結或參照指向契約與資料模型的細節，不要重複抄寫
   - 不要加入完整的實作程式碼、模型／服務／控制器本體、遷移，或完整的測試套件
   - 這份產物定位為驗證／執行指南；實作細節屬於 `tasks.md` 與實作階段

**輸出**：data-model.md、/contracts/*、quickstart.md

## 關鍵規則

- 檔案系統操作使用絕對路徑；文件中的參照使用專案相對路徑
- 關卡失敗或釐清未解決時回報 ERROR

## 完成條件

- [ ] 計畫工作流程已執行，設計產物已產生
- [ ] 擴充功能 hooks 已依上方強制執行後 Hooks 的規則派送或跳過
- [ ] 已向使用者回報完成，附分支、計畫路徑與產生的產物
