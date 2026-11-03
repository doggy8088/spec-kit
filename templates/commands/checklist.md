---
description: 根據使用者需求，為目前功能產生自訂檢核清單。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --template checklist-template
  ps: scripts/powershell/check-prerequisites.ps1 -Json -Template checklist-template
  py: scripts/python/check_prerequisites.py --json --template checklist-template
---

## 檢核清單目的：「英文的單元測試」

**關鍵概念**：檢核清單是**需求撰寫的單元測試**，用來驗證特定領域中需求的品質、清晰度與完整性。

**不是用於驗證／測試**：

- ❌ 不是「驗證按鈕是否正確點選」
- ❌ 不是「測試錯誤處理是否正常運作」
- ❌ 不是「確認 API 回傳 200」
- ❌ 不是檢查程式碼／實作是否符合規格

**用於需求品質驗證**：

- ✅「所有卡片類型是否都定義了視覺階層需求？」（完整性）
- ✅「『醒目呈現』是否以具體尺寸／位置量化？」（清晰度）
- ✅「所有互動元素的 hover 狀態需求是否一致？」（一致性）
- ✅「鍵盤導覽是否定義了無障礙需求？」（覆蓋範圍）
- ✅「規格是否定義了 logo 圖片載入失敗時會發生什麼事？」（邊界案例）

**比喻**：如果你的規格是用英文寫成的程式碼，檢核清單就是它的單元測試套件。你是在測試需求是否寫得好、是否完整、是否明確、是否已可進入實作，而不是測試實作本身是否能運作。

**所有權與核取方塊生命週期**：

- 本命令產生的自訂檢核清單，是由審查者持有、供需求品質審查使用的產物。
- `[x]` 表示審查者認定該需求品質判準已滿足。
- `[x]` 並不表示實作工作已完成。
- 本命令負責產生或附加檢核清單項目；絕對不得將產生的項目標記為 `[x]`。
- 只有在審查者明確要求時，代理才可協助評估項目。
- `checklists/requirements.md` 是另一份內建的規格品質檢核清單，由 `__SPECKIT_COMMAND_SPECIFY__` 與 `__SPECKIT_COMMAND_CLARIFY__` 維護；不要把該例外套用到這裡產生的自訂檢核清單上。

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考量使用者輸入（若非空）。

## 執行前檢查

**檢查擴充功能 hooks（在產生檢核清單之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_checklist` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默略過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析錯誤），且未檢查任何 hooks，包括其中註冊的必要（`optional: false`）hooks，然後正常繼續
- 濾除 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為已啟用。
- 對其餘每個 hook，不要嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或該欄位為 null／空值，將該 hook 視為可執行
  - 若 hook 定義了非空的 `condition`，略過該 hook，將條件評估留給 HookExecutor 實作處理
- 對每個可執行的 hook，依其 `optional` 旗標輸出下列內容：
  - **選用 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **必要 hook**（`optional: false`）：
    ```
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to the Execution Steps.
    ```
    輸出上面這個區塊之後，你必須實際叫用該 hook 並等它完成，才能繼續。叫用方式與你在這個代理／工作階段中自行執行該命令的方式相同（實際叫用可能與上面顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默略過

## 執行步驟

1. **設定**：從儲存庫根目錄執行 `{SCRIPT}`，並解析 JSON 取得 FEATURE_DIR、AVAILABLE_DOCS 清單與 TEMPLATE_CONTENT。
   - 所有檔案路徑都必須是絕對路徑。
   - 對於參數中像 "I'm Groot" 這類單引號，使用跳脫語法：例如 'I'\''m Groot'（或盡可能使用雙引號："I'm Groot"）。

2. **若存在**：載入 `/memory/constitution.md`，取得專案原則與治理限制。

3. **釐清意圖（動態）**：推導最多三個初步的脈絡釐清問題（不使用預製題庫）。這些問題必須：
   - 由使用者的措辭，加上從 spec／plan／tasks 擷取的訊號產生
   - 只詢問會實質改變檢核清單內容的資訊
   - 若 `$ARGUMENTS` 中已明確無歧義，個別問題可略過
   - 精確優先於廣度

   產生演算法：
   1. 擷取訊號：功能領域關鍵字（例如 auth、latency、UX、API）、風險指標（"critical"、"must"、"compliance"）、利害關係人線索（"QA"、"review"、"security team"），以及明確交付物（"a11y"、"rollback"、"contracts"）。
   2. 將訊號分群為候選重點領域（最多 4 個），依相關性排序。
   3. 若未明確，辨識可能的對象與時機（作者、審查者、QA、發行）。
   4. 偵測缺少的面向：範圍廣度、深度／嚴謹度、風險著重、排除邊界、可衡量的驗收判準。
   5. 從下列原型中選用並組成問題：
      - 範圍細化（例如：「這應該涵蓋與 X 和 Y 的整合接觸點，還是只限於本機模組的正確性？」）
      - 風險優先排序（例如：「這些潛在風險領域中，哪些應該設為必要把關檢查？」）
      - 深度校準（例如：「這是輕量的提交前健全性清單，還是正式的發行把關？」）
      - 對象定位（例如：「這只會由作者本人使用，還是同儕在 PR 審查時也會使用？」）
      - 邊界排除（例如：「這一輪是否應明確排除效能調校項目？」）
      - 情境類型缺口（例如：「未偵測到復原流程，rollback／部分失敗路徑是否在範圍內？」）

   問題格式規則：
   - 若要呈現選項，產生精簡表格，欄位為：Option | Candidate | Why It Matters
   - 最多 A–E 個選項；若自由作答更清楚，可省略表格
   - 絕不要求使用者重述已經說過的內容
   - 避免臆測的分類（不要憑空捏造）。若不確定，明確詢問：「請確認 X 是否屬於範圍內。」

   無法互動時的預設值：
   - 深度：Standard
   - 對象：與程式碼相關時為 Reviewer（PR），否則為 Author
   - 重點：相關性最高的 2 個分群

   輸出問題（標示 Q1／Q2／Q3）。回答之後：若仍有 2 個以上情境類型（Alternate／Exception／Recovery／Non-Functional 領域）不清楚，你可以再提出最多兩個針對性的後續問題（Q4／Q5），每個附上一行理由（例如：「復原路徑風險尚未解決」）。問題總數不得超過五個。若使用者明確婉拒更多問題，略過升級追問。

4. **理解使用者需求**：結合 `$ARGUMENTS` 與釐清答案：
   - 推導檢核清單主題（例如 security、review、deploy、ux）
   - 彙整使用者提到的明確必備項目
   - 將重點選擇對應到分類鷹架
   - 從 spec／plan／tasks 推斷缺少的脈絡（不要憑空捏造）

5. **載入功能脈絡**：從 FEATURE_DIR 讀取：
   - spec.md：功能需求與範圍
   - plan.md（若存在）：技術細節、相依性
   - tasks.md（若存在）：實作任務

   **脈絡載入策略**：
   - 只載入與目前重點領域相關的必要部分（避免傾倒整份檔案）
   - 優先將較長的章節摘要為精簡的情境／需求條列
   - 採漸進式揭露：只有偵測到缺口時才追加擷取
   - 若來源文件很大，產生中繼摘要項目，不要嵌入原始文字

6. **產生檢核清單**：以 TEMPLATE_CONTENT 作為結構範本，建立「需求的單元測試」：
   - 若 `FEATURE_DIR/checklists/` 目錄不存在，建立它
   - 產生唯一的檢核清單檔名：
     - 使用依領域而定的簡短、具描述性的名稱（例如 `ux.md`、`api.md`、`security.md`）
     - 格式：`[domain].md`
   - 檔案處理行為：
     - 若檔案不存在：建立新檔，項目從 CHK001 開始編號
     - 若檔案已存在：將新項目附加到既有檔案，從最後一個 CHK ID 接續編號（例如最後一項是 CHK015，新項目就從 CHK016 開始）
   - 絕不刪除或取代既有的檢核清單內容，一律保留並附加
   - 每個新產生的項目都保持未核取（`[ ]`）；核取方塊狀態屬於審查者

   **核心原則：測試需求，而不是實作**：
   每個檢核清單項目都必須針對**需求本身**評估：
   - **完整性**：所有必要需求是否齊備？
   - **清晰度**：需求是否明確且具體？
   - **一致性**：需求之間是否彼此相符？
   - **可衡量性**：需求是否可客觀驗證？
   - **覆蓋範圍**：所有情境／邊界案例是否都已處理？

   **分類結構**：依需求品質面向分組項目：
   - **需求完整性**（所有必要需求是否都已記錄？）
   - **需求清晰度**（需求是否具體且無歧義？）
   - **需求一致性**（需求之間是否相符且無衝突？）
   - **驗收判準品質**（成功判準是否可衡量？）
   - **情境覆蓋範圍**（所有流程／案例是否都已處理？）
   - **邊界案例覆蓋範圍**（邊界條件是否已定義？）
   - **非功能需求**（效能、安全性、無障礙等，是否已規範？）
   - **相依性與假設**（是否已記錄並驗證？）
   - **歧義與衝突**（哪些地方需要釐清？）

   **如何撰寫檢核清單項目：「英文的單元測試」**：

   ❌ **錯誤**（測試實作）：
   - "Verify landing page displays 3 episode cards"
   - "Test hover states work on desktop"
   - "Confirm logo click navigates home"

   ✅ **正確**（測試需求品質）：
   - "Are the exact number and layout of featured episodes specified?" [Completeness]
   - "Is 'prominent display' quantified with specific sizing/positioning?" [Clarity]
   - "Are hover state requirements consistent across all interactive elements?" [Consistency]
   - "Are keyboard navigation requirements defined for all interactive UI?" [Coverage]
   - "Is the fallback behavior specified when logo image fails to load?" [Edge Cases]
   - "Are loading states defined for asynchronous episode data?" [Completeness]
   - "Does the spec define visual hierarchy for competing UI elements?" [Clarity]

   **項目結構**：
   每個項目都應遵循這個模式：
   - 以詢問需求品質的問題形式呈現
   - 聚焦於 spec／plan 中**已寫**（或未寫）的內容
   - 在方括號中包含品質面向 [Completeness/Clarity/Consistency/etc.]
   - 檢查既有需求時，參照規格章節 `[Spec §X.Y]`
   - 檢查缺少的需求時，使用 `[Gap]` 標記

   **依品質面向分類的範例**：

   完整性：
   - "Are error handling requirements defined for all API failure modes? [Gap]"
   - "Are accessibility requirements specified for all interactive elements? [Completeness]"
   - "Are mobile breakpoint requirements defined for responsive layouts? [Gap]"

   清晰度：
   - "Is 'fast loading' quantified with specific timing thresholds? [Clarity, Spec §NFR-2]"
   - "Are 'related episodes' selection criteria explicitly defined? [Clarity, Spec §FR-5]"
   - "Is 'prominent' defined with measurable visual properties? [Ambiguity, Spec §FR-4]"

   一致性：
   - "Do navigation requirements align across all pages? [Consistency, Spec §FR-10]"
   - "Are card component requirements consistent between landing and detail pages? [Consistency]"

   覆蓋範圍：
   - "Are requirements defined for zero-state scenarios (no episodes)? [Coverage, Edge Case]"
   - "Are concurrent user interaction scenarios addressed? [Coverage, Gap]"
   - "Are requirements specified for partial data loading failures? [Coverage, Exception Flow]"

   可衡量性：
   - "Are visual hierarchy requirements measurable/testable? [Acceptance Criteria, Spec §FR-1]"
   - "Can 'balanced visual weight' be objectively verified? [Measurability, Spec §FR-2]"

   **情境分類與覆蓋範圍**（聚焦需求品質）：
   - 檢查是否存在下列情境的需求：Primary、Alternate、Exception/Error、Recovery、Non-Functional
   - 對每個情境類型，詢問：「[scenario type] 需求是否完整、清楚且一致？」
   - 若缺少某個情境類型：「[scenario type] 需求是刻意排除，還是遺漏了？[Gap]」
   - 發生狀態變更時，納入韌性／rollback：「遷移失敗時的 rollback 需求是否已定義？[Gap]」

   **可追溯性需求**：
   - 最低要求：至少 80% 的項目必須包含至少一個可追溯性參照
   - 每個項目都應參照：規格章節 `[Spec §X.Y]`，或使用標記：`[Gap]`、`[Ambiguity]`、`[Conflict]`、`[Assumption]`
   - 若沒有 ID 系統：「是否已建立需求與驗收判準的 ID 方案？[Traceability]」

   **呈現並解決問題**（需求品質問題）：
   針對需求本身提問：
   - 歧義："Is the term 'fast' quantified with specific metrics? [Ambiguity, Spec §NFR-1]"
   - 衝突："Do navigation requirements conflict between §FR-10 and §FR-10a? [Conflict]"
   - 假設："Is the assumption of 'always available podcast API' validated? [Assumption]"
   - 相依性："Are external podcast API requirements documented? [Dependency, Gap]"
   - 缺少的定義："Is 'visual hierarchy' defined with measurable criteria? [Gap]"

   **內容整併**：
   - 軟性上限：若原始候選項目超過 40 個，依風險／影響排序優先處理
   - 合併檢查同一需求面向的近似重複項目
   - 若低影響的邊界案例超過 5 個，建立一個項目：「需求是否處理了邊界案例 X、Y、Z？[Coverage]」

   **🚫 絕對禁止**：這些會讓它變成實作測試，而不是需求測試：
   - ❌ 任何以 "Verify"、"Test"、"Confirm"、"Check" 加上實作行為開頭的項目
   - ❌ 參照程式碼執行、使用者動作、系統行為
   - ❌ "Displays correctly"、"works properly"、"functions as expected"
   - ❌ "Click"、"navigate"、"render"、"load"、"execute"
   - ❌ 測試案例、測試計畫、QA 程序
   - ❌ 實作細節（框架、API、演算法）

   **✅ 必要模式**：這些才是測試需求品質：
   - ✅ "Are [requirement type] defined/specified/documented for [scenario]?"
   - ✅ "Is [vague term] quantified/clarified with specific criteria?"
   - ✅ "Are requirements consistent between [section A] and [section B]?"
   - ✅ "Can [requirement] be objectively measured/verified?"
   - ✅ "Are [edge cases/scenarios] addressed in requirements?"
   - ✅ "Does the spec define [missing aspect]?"

7. **結構參照**：依 `templates/checklist-template.md` 中的標準範本產生檢核清單，包括標題、meta 章節、分類標題、所有權說明、備註章節與 ID 格式。若範本無法取得，則使用：H1 標題、用途／建立日期 meta 行、一段所有權說明（解釋 `[x]` 表示審查者認可需求品質）、包含 `- [ ] CHK### <requirement item>` 行的 `##` 分類章節（ID 全域遞增，從 CHK001 開始），以及備註（說明 `__SPECKIT_COMMAND_IMPLEMENT__` 會讀取檢核清單狀態，但不會修改標記）。

8. **報告**：輸出檢核清單檔案的完整路徑、項目數量，並摘要說明本次執行是建立新檔還是附加到既有檔案。摘要包括：
   - 選定的重點領域
   - 深度層級
   - 行動者／時機
   - 已納入的任何使用者明確指定的必備項目

**重要**：每次叫用 `__SPECKIT_COMMAND_CHECKLIST__` 命令時，都會使用簡短、具描述性的檢核清單檔名，並建立新檔或附加到既有檔案。這讓你可以：

- 建立多份不同類型的檢核清單（例如 `ux.md`、`test.md`、`security.md`）
- 使用簡單、好記、能表明檢核清單用途的檔名
- 在 `checklists/` 資料夾中輕鬆辨識與瀏覽

為避免雜亂，請使用具描述性的類型，並在完成後清理過時的檢核清單。

## 檢核清單類型範例與示例項目

**UX 需求品質：** `ux.md`

示例項目（測試需求，而不是實作）：

- "Are visual hierarchy requirements defined with measurable criteria? [Clarity, Spec §FR-1]"
- "Is the number and positioning of UI elements explicitly specified? [Completeness, Spec §FR-1]"
- "Are interaction state requirements (hover, focus, active) consistently defined? [Consistency]"
- "Are accessibility requirements specified for all interactive elements? [Coverage, Gap]"
- "Is fallback behavior defined when images fail to load? [Edge Case, Gap]"
- "Can 'prominent display' be objectively measured? [Measurability, Spec §FR-4]"

**API 需求品質：** `api.md`

示例項目：

- "Are error response formats specified for all failure scenarios? [Completeness]"
- "Are rate limiting requirements quantified with specific thresholds? [Clarity]"
- "Are authentication requirements consistent across all endpoints? [Consistency]"
- "Are retry/timeout requirements defined for external dependencies? [Coverage, Gap]"
- "Is versioning strategy documented in requirements? [Gap]"

**效能需求品質：** `performance.md`

示例項目：

- "Are performance requirements quantified with specific metrics? [Clarity]"
- "Are performance targets defined for all critical user journeys? [Coverage]"
- "Are performance requirements under different load conditions specified? [Completeness]"
- "Can performance requirements be objectively measured? [Measurability]"
- "Are degradation requirements defined for high-load scenarios? [Edge Case, Gap]"

**安全性需求品質：** `security.md`

示例項目：

- "Are authentication requirements specified for all protected resources? [Coverage]"
- "Are data protection requirements defined for sensitive information? [Completeness]"
- "Is the threat model documented and requirements aligned to it? [Traceability]"
- "Are security requirements consistent with compliance obligations? [Consistency]"
- "Are security failure/breach response requirements defined? [Gap, Exception Flow]"

## 反面範例：不該做的事

**❌ 錯誤：這些測試的是實作，而不是需求：**

```markdown
- [ ] CHK001 - Verify landing page displays 3 episode cards [Spec §FR-001]
- [ ] CHK002 - Test hover states work correctly on desktop [Spec §FR-003]
- [ ] CHK003 - Confirm logo click navigates to home page [Spec §FR-010]
- [ ] CHK004 - Check that related episodes section shows 3-5 items [Spec §FR-005]
```

**✅ 正確：這些測試的是需求品質：**

```markdown
- [ ] CHK001 - Are the number and layout of featured episodes explicitly specified? [Completeness, Spec §FR-001]
- [ ] CHK002 - Are hover state requirements consistently defined for all interactive elements? [Consistency, Spec §FR-003]
- [ ] CHK003 - Are navigation requirements clear for all clickable brand elements? [Clarity, Spec §FR-010]
- [ ] CHK004 - Is the selection criteria for related episodes documented? [Gap, Spec §FR-005]
- [ ] CHK005 - Are loading state requirements defined for asynchronous episode data? [Gap]
- [ ] CHK006 - Can "visual hierarchy" requirements be objectively measured? [Measurability, Spec §FR-001]
```

**主要差異：**

- 錯誤：測試系統是否正確運作
- 正確：測試需求是否正確撰寫
- 錯誤：行為的驗證
- 正確：需求品質的驗證
- 錯誤：「它有做 X 嗎？」
- 正確：「X 是否有被明確規範？」

## 執行後檢查

**檢查擴充功能 hooks（在產生檢核清單之後）**：
檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.after_checklist` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默略過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析錯誤），且未檢查任何 hooks，包括其中註冊的必要（`optional: false`）hooks，然後正常繼續
- 濾除 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為已啟用。
- 對其餘每個 hook，不要嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或該欄位為 null／空值，將該 hook 視為可執行
  - 若 hook 定義了非空的 `condition`，略過該 hook，將條件評估留給 HookExecutor 實作處理
- 對每個可執行的 hook，依其 `optional` 旗標輸出下列內容：
  - **選用 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **必要 hook**（`optional: false`）：
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    輸出上面這個區塊之後，你必須實際叫用該 hook 並等它完成，才能繼續。叫用方式與你在這個代理／工作階段中自行執行該命令的方式相同（實際叫用可能與上面顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默略過
