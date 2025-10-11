---
description: 根據用戶需求，為當前功能產生自訂檢查清單。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## 檢查清單目的：「英文需求的單元測試」

**關鍵概念**：檢查清單是**需求撰寫的單元測試**——用來驗證特定領域內需求的品質、清晰度與完整性。

**不是用於驗證／測試**：
- ❌ 不是「驗證按鈕能正確點擊」
- ❌ 不是「測試錯誤處理是否正常」
- ❌ 不是「確認 API 回傳 200」
- ❌ 不是檢查程式碼／實作是否符合規格

**用於需求品質驗證**：
- ✅「是否為所有卡片類型定義了視覺階層需求？」（完整性）
- ✅「『明顯顯示』是否以具體尺寸／位置量化？」（清晰度）
- ✅「所有互動元件的 hover 狀態需求是否一致？」（一致性）
- ✅「是否定義了鍵盤導覽的無障礙需求？」（覆蓋範圍）
- ✅「規格是否定義了當 logo 圖片載入失敗時的處理方式？」（邊界情境）

**比喻**：如果你的規格說明像是用英文寫的程式碼，檢查清單就是它的單元測試套件。你要測試的是需求是否撰寫得好、完整、明確且可供實作——不是測試實作本身是否可行。

## 用戶輸入

```text
$ARGUMENTS
```

你在繼續執行前，**必須**考慮用戶輸入（若非空）。

## 執行步驟

1. **初始化**：從 repo 根目錄執行 `{SCRIPT}`，並解析 JSON 以取得 FEATURE_DIR 與 AVAILABLE_DOCS 清單。
   - 所有檔案路徑必須為絕對路徑。
   - 若參數中有單引號，如 "I'm Groot"，請使用跳脫語法：例如 'I'\''m Groot'（或若可行則用雙引號："I'm Groot"）。

2. **釐清意圖（動態產生）**：根據用戶語句及從規格/計畫/任務中提取的訊號，動態產生最多三個初步情境釐清問題（不得使用預設題庫）。這些問題**必須**：
   - 根據用戶表述 + 從規格/計畫/任務中提取的訊號動態生成
   - 僅詢問會實質影響檢查清單內容的資訊
   - 若在 `$ARGUMENTS` 已明確，則個別略過
   - 優先精確度高於廣度

   產生演算法：
   1. 提取訊號：功能領域關鍵字（如 auth、latency、UX、API）、風險指標（如 "critical"、"must"、"compliance"）、利害關係人提示（如 "QA"、"review"、"security team"）、明確交付物（如 "a11y"、"rollback"、"contracts"）。
   2. 將訊號聚類為候選重點領域（最多 4 組），依相關性排序。
   3. 若未明確，推斷可能的受眾與時機（作者、審查者、QA、發佈）。
   4. 偵測缺漏維度：範圍廣度、深度/嚴謹度、風險強調、排除邊界、可衡量的驗收標準。
   5. 依下列原型類型擬定問題：
      - 範圍細化（例："這是否應包含與 X 和 Y 的整合接點，或僅限於本地模組正確性？"）
      - 風險優先（例："這些潛在風險區域中，哪些需要強制檢查？"）
      - 深度校準（例："這是一份輕量的 pre-commit 檢查清單，還是正式發佈門檻？"）
      - 受眾定位（例："這僅供作者使用，還是 PR 審查時同儕也會用？"）
      - 邊界排除（例："本輪是否明確排除效能調校項目？"）
      - 情境類型缺口（例："未偵測到復原流程——rollback/部分失敗路徑是否在範圍內？"）

   問題格式規則：
   - 若有選項，產生精簡表格，欄位：Option | Candidate | Why It Matters
   - 最多 A–E 選項；若自由回答較清楚則省略表格
   - 絕不要求用戶重述已說過的內容
   - 避免臆測分類（不得幻想）。若不確定，請明確詢問："請確認 X 是否屬於範圍。"

   若無法互動時的預設值：
   - 深度：標準
   - 受眾：若與程式碼相關則為 Reviewer（PR），否則為 Author
   - 重點：前兩大相關性聚類

   輸出問題時標註 Q1/Q2/Q3。獲得回覆後：若仍有兩種以上情境類型（Alternate / Exception / Recovery / Non-Functional domain）不明確，可再追問最多兩題（Q4/Q5），每題附一句理由（如："復原路徑風險未解決"）。總題數不得超過五題。若用戶明確拒絕，則不再追問。

3. **理解用戶需求**：結合 `$ARGUMENTS` 與釐清回覆：
   - 推導檢查清單主題（如 security、review、deploy、ux）
   - 彙整用戶明確要求的 must-have 項目
   - 將重點選擇對應到分類架構
   - 從規格/計畫/任務中推測缺漏情境（**不得幻想**）

4. **載入功能情境**：從 FEATURE_DIR 讀取：
   - spec.md：功能需求與範圍
   - plan.md（若存在）：技術細節、相依性
   - tasks.md（若存在）：實作任務

   **情境載入策略**：
   - 僅載入與當前重點相關的必要部分（避免整檔貼出）
   - 長段落優先摘要為精簡情境/需求條列
   - 採漸進式揭露：僅在發現缺口時再補充檢索
   - 若原始文件過大，請產生中繼摘要項目，勿直接嵌入原文

5. **產生檢查清單** - 建立「需求單元測試」：
   - 若 `FEATURE_DIR/checklists/` 目錄不存在，請先建立
   - 產生唯一檢查清單檔名：
     - 以領域為基礎，使用簡短且具描述性的名稱（如 `ux.md`、`api.md`、`security.md`）
     - 格式：`[domain].md`
     - 若檔案已存在，則附加於現有檔案
   - 項目編號從 CHK001 依序遞增
   - 每次 `/speckit.checklist` 執行都會建立**新檔案**（絕不覆蓋現有檢查清單）

   **核心原則 - 測試需求本身，而非實作**：
   每個檢查清單項目**必須**評估「需求本身」的下列面向：
   - **完整性**：所有必要需求是否齊全？
   - **明確性**：需求是否明確且具體？
   - **一致性**：需求之間是否相符？
   - **可衡量性**：需求是否可客觀驗證？
   - **覆蓋性**：所有情境/邊界情況是否涵蓋？

   **分類結構** - 依需求品質維度分組：
   - **需求完整性**（所有必要需求是否有文件記載？）
   - **需求明確性**（需求是否具體且無歧義？）
   - **需求一致性**（需求間是否無衝突？）
   - **驗收標準品質**（成功標準是否可衡量？）
   - **情境覆蓋**（所有流程/案例是否涵蓋？）
   - **邊界情境覆蓋**（邊界條件是否有定義？）
   - **非功能性需求**（效能、安全性、無障礙等是否有規範？）
   - **相依性與假設**（是否有記載並驗證？）
   - **歧義與衝突**（哪些需要釐清？）

   **如何撰寫檢查清單項目 -「英文需求單元測試」**：

   ❌ **錯誤範例**（測試實作）：
   - "Verify landing page displays 3 episode cards"
   - "Test hover states work on desktop"
   - "Confirm logo click navigates home"

   ✅ **正確範例**（測試需求品質）：
   - "Are the exact number and layout of featured episodes specified?" [Completeness]
   - "Is 'prominent display' quantified with specific sizing/positioning?" [Clarity]
   - "Are hover state requirements consistent across all interactive elements?" [Consistency]
   - "Are keyboard navigation requirements defined for all interactive UI?" [Coverage]
   - "Is the fallback behavior specified when logo image fails to load?" [Edge Cases]
   - "Are loading states defined for asynchronous episode data?" [Completeness]
   - "Does the spec define visual hierarchy for competing UI elements?" [Clarity]

   **項目結構**：
   每個項目應遵循以下模式：
   - 以問題形式詢問需求品質
   - 聚焦於規格/計畫中「已寫或未寫」的內容
   - 於括號內標註品質維度 [Completeness/Clarity/Consistency/…]
   - 檢查現有需求時引用規格章節 `[Spec §X.Y]`
   - 檢查缺漏需求時使用 `[Gap]` 標記

   **依品質維度舉例**：

   完整性：
   - "Are error handling requirements defined for all API failure modes? [Gap]"
   - "Are accessibility requirements specified for all interactive elements? [Completeness]"
   - "Are mobile breakpoint requirements defined for responsive layouts? [Gap]"

   明確性：
   - "Is 'fast loading' quantified with specific timing thresholds? [Clarity, Spec §NFR-2]"
   - "Are 'related episodes' selection criteria explicitly defined? [Clarity, Spec §FR-5]"
   - "Is 'prominent' defined with measurable visual properties? [Ambiguity, Spec §FR-4]"

   一致性：
   - "Do navigation requirements align across all pages? [Consistency, Spec §FR-10]"
   - "Are card component requirements consistent between landing and detail pages? [Consistency]"

   覆蓋性：
   - "Are requirements defined for zero-state scenarios (no episodes)? [Coverage, Edge Case]"
   - "Are concurrent user interaction scenarios addressed? [Coverage, Gap]"
   - "Are requirements specified for partial data loading failures? [Coverage, Exception Flow]"

   可衡量性：
   - "Are visual hierarchy requirements measurable/testable? [Acceptance Criteria, Spec §FR-1]"
   - "Can 'balanced visual weight' be objectively verified? [Measurability, Spec §FR-2]"

   **情境分類與覆蓋**（聚焦需求品質）：
   - 檢查下列情境是否有需求：主要、替代、例外/錯誤、復原、非功能性情境
   - 每種情境類型都要問：「[情境類型] 需求是否完整、明確且一致？」
   - 若缺少某類情境：「[情境類型] 需求是有意排除還是遺漏？[Gap]」
   - 若有狀態變更，請納入韌性/rollback：「遷移失敗時 rollback 需求是否有定義？[Gap]」

   **可追溯性需求**：
   - 最低要求：80% 以上項目**必須**包含至少一個可追溯性引用
   - 每項應引用：spec 章節 `[Spec §X.Y]`，或使用標記：`[Gap]`、`[Ambiguity]`、`[Conflict]`、`[Assumption]`
   - 若無 ID 系統：「是否已建立需求與驗收標準的 ID 編碼？[Traceability]」

   **顯示並解決問題**（需求品質問題）：
   針對需求本身提出問題：
   - 歧義："Is the term 'fast' quantified with specific metrics? [Ambiguity, Spec §NFR-1]"
   - 衝突："Do navigation requirements conflict between §FR-10 and §FR-10a? [Conflict]"
   - 假設："Is the assumption of 'always available podcast API' validated? [Assumption]"
   - 相依性："Are external podcast API requirements documented? [Dependency, Gap]"
   - 定義缺漏："Is 'visual hierarchy' defined with measurable criteria? [Gap]"

   **內容整併**：
   - 軟上限：若原始候選項目超過 40 條，請依風險/影響力排序
   - 合併重複檢查同一需求面的近似項目
   - 若低影響邊界案例超過 5 條，請合併為一條：「需求中是否涵蓋 X、Y、Z 等邊界情境？[Coverage]」

   **🚫 絕對禁止** - 以下會變成實作測試而非需求測試：
   - ❌ 任何以 "Verify"、"Test"、"Confirm"、"Check" 加實作行為開頭的項目
   - ❌ 涉及程式碼執行、用戶操作、系統行為的描述
   - ❌ "Displays correctly"、"works properly"、"functions as expected"
   - ❌ "Click"、"navigate"、"render"、"load"、"execute"
   - ❌ 測試案例、測試計畫、QA 流程
   - ❌ 實作細節（如 frameworks、API、演算法）

   **✅ 必須遵循的模式** - 這些才是測試需求品質：
   - ✅ "Are [requirement type] defined/specified/documented for [scenario]?"
   - ✅ "Is [vague term] quantified/clarified with specific criteria?"
   - ✅ "Are requirements consistent between [section A] and [section B]?"
   - ✅ "Can [requirement] be objectively measured/verified?"
   - ✅ "Are [edge cases/scenarios] addressed in requirements?"
   - ✅ "Does the spec define [missing aspect]?"

6. **結構參考**：依照 `templates/checklist-template.md` 的標準範本產生檢查清單，包括標題、meta 區塊、分類標題及 ID 格式。若無範本，請使用：H1 標題、目的/建立者 meta 行、`##` 分類區段，內含以全域遞增 ID（從 CHK001 起）標註的 `- [ ] CHK### <requirement item>` 條目。

7. **報告**：輸出建立的檢查清單完整路徑、項目數，並提醒用戶每次執行都會產生新檔案。摘要包含：
   - 選定重點領域
   - 深度層級
   - 角色/時機
   - 用戶明確指定的 must-have 項目

**重要**：每次執行 `/speckit.checklist` 指令都會以簡短、具描述性的名稱建立檢查清單檔案，除非檔案已存在。這樣可：

- 建立多種不同類型的檢查清單（如 `ux.md`、`test.md`、`security.md`）
- 使用簡單易記的檔名，明確標示檢查清單用途
- 方便在 `checklists/` 資料夾中辨識與瀏覽

為避免雜亂，請使用具描述性的類型，並於完成後清理不再需要的檢查清單。

## 檢查清單類型範例與範本項目

**UX 需求品質：** `ux.md`

範例項目（測試需求，**非**實作）：
- "Are visual hierarchy requirements defined with measurable criteria? [Clarity, Spec §FR-1]"
- "Is the number and positioning of UI elements explicitly specified? [Completeness, Spec §FR-1]"
- "Are interaction state requirements (hover, focus, active) consistently defined? [Consistency]"
- "Are accessibility requirements specified for all interactive elements? [Coverage, Gap]"
- "Is fallback behavior defined when images fail to load? [Edge Case, Gap]"
- "Can 'prominent display' be objectively measured? [Measurability, Spec §FR-4]"

**API 需求品質：** `api.md`

範例項目：
- "Are error response formats specified for all failure scenarios? [Completeness]"
- "Are rate limiting requirements quantified with specific thresholds? [Clarity]"
- "Are authentication requirements consistent across all endpoints? [Consistency]"
- "Are retry/timeout requirements defined for external dependencies? [Coverage, Gap]"
- "Is versioning strategy documented in requirements? [Gap]"

**效能需求品質：** `performance.md`

範例項目：
- "Are performance requirements quantified with specific metrics? [Clarity]"
- "Are performance targets defined for all critical user journeys? [Coverage]"
- "Are performance requirements under different load conditions specified? [Completeness]"
- "Can performance requirements be objectively measured? [Measurability]"
- "Are degradation requirements defined for high-load scenarios? [Edge Case, Gap]"

**安全性需求品質：** `security.md`

```markdown
- [ ] CHK001 - Verify landing page displays 3 episode cards [Spec §FR-001]
- [ ] CHK002 - Test hover states work correctly on desktop [Spec §FR-003]
- [ ] CHK003 - Confirm logo click navigates to home page [Spec §FR-010]
- [ ] CHK004 - Check that related episodes section shows 3-5 items [Spec §FR-005]
```

**✅ 正確 - 這些測試需求品質良好：**

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
- 錯誤：驗證行為
- 正確：驗證需求品質 (requirement quality)
- 錯誤：「它有做 X 嗎？」
- 正確：「X 是否有明確規範？」
