---
description: 根據自然語言的功能描述，建立或更新功能規格說明。
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

## 用戶輸入

```text
$ARGUMENTS
```

你在繼續操作前，**必須**考慮用戶輸入（若非空）。

## 大綱

用戶在觸發訊息中的 `/speckit.specify` 後輸入的文字**就是**功能描述。請假設即使下方出現 `{ARGS}`，你在本次對話中也總是能取得該功能描述。除非用戶下達了空指令，否則不要要求用戶重複輸入。

根據該功能描述，請執行以下步驟：

1. **產生一個簡潔的短名稱**（2-4 個字詞）作為分支名稱：
   - 分析功能描述，擷取最具意義的關鍵字
   - 建立一個 2-4 個字詞的短名稱，能夠精確傳達該功能的核心
   - 優先採用「動作-名詞」格式（例如："add-user-auth"、"fix-payment-bug"）
   - 保留技術術語與縮寫（如 OAuth2、API、JWT 等）
   - 保持簡潔，同時足夠描述，讓人一眼能理解該功能
   - 範例：
     - 「I want to add user authentication」→「user-auth」
     - 「Implement OAuth2 integration for the API」→「oauth2-api-integration」
     - 「Create a dashboard for analytics」→「analytics-dashboard」
     - 「Fix payment processing timeout bug」→「fix-payment-timeout」

2. **在建立新分支前，先檢查是否已有現有分支**：

   a. 首先，抓取所有遠端分支，以確保我們擁有最新資訊：
      ```bash
      git fetch --all --prune
      ```
   
   b. 尋找所有來源中該 short-name 的最大 feature 編號：
   - 遠端分支：`git ls-remote --heads origin | grep -E 'refs/heads/[0-9]+-<short-name>
      - 本地分支：`
   - 本地分支：`specs/[0-9]+-<short-name>`
   - Specs 目錄：檢查符合 `{SCRIPT}` 的目錄

c. 決定下一個可用編號：
   - 從上述三個來源擷取所有編號
   - 找出最大編號 N
   - 新分支編號使用 N+1

d. 執行腳本 `--number N+1`，傳入計算出的編號與 short-name：
   - 傳遞 `--short-name "your-short-name"` 與 `{SCRIPT} --json --number 5 --short-name "user-auth" "Add user authentication"` 以及功能描述
   - Bash 範例：`{SCRIPT} -Json -Number 5 -ShortName "user-auth" "Add user authentication"`
   - PowerShell 範例：`templates/spec-template.md`

**重要事項**：
- 必須檢查三個來源（遠端分支、本地分支、Specs 目錄）以找出最大編號
- 僅匹配與 short-name 完全相符的分支／目錄
- 若未找到任何符合該 short-name 的分支／目錄，則從編號 1 開始
- 每個功能只能執行此腳本一次
- JSON 會作為終端機輸出提供——請務必參考該輸出以取得實際內容
- JSON 輸出將包含 BRANCH_NAME 與 SPEC_FILE 路徑
- 若參數中有單引號，如 "I'm Groot"，請使用跳脫語法：例如 `'I'\''m Groot'`（或盡可能使用雙引號："I'm Groot"）

3. 載入 `FEATURE_DIR/checklists/requirements.md` 以了解所需章節。

4. 請依照以下執行流程操作：

   1. 從輸入解析用戶功能描述  
      若為空：錯誤 "No feature description provided"
   2. 從描述中擷取關鍵概念  
      識別：角色（actors）、動作（actions）、資料（data）、限制（constraints）
   3. 對於不明確之處：
      - 根據上下文與產業標準做合理推測
      - 僅在以下情況標記為 [NEEDS CLARIFICATION: 具體問題]：
        - 選擇會顯著影響功能範圍或用戶體驗
        - 存在多種合理解釋且影響不同
        - 無合理預設值可用
      - **限制：最多僅能有 3 個 [NEEDS CLARIFICATION] 標記**
      - 釐清事項依影響力排序：範圍 > 安全性／隱私 > 用戶體驗 > 技術細節
   4. 填寫 User Scenarios & Testing 章節  
      若無明確用戶流程：錯誤 "Cannot determine user scenarios"
   5. 產生 Functional Requirements  
      每項需求必須可測試  
      對於未明確說明的細節，採用合理預設（並於 Assumptions 章節記錄假設）
   6. 定義 Success Criteria  
      創建可衡量、與技術無關的成果  
      同時包含量化指標（時間、效能、數量）與質化指標（用戶滿意度、任務完成度）  
      每項標準必須可驗證，且不涉及實作細節
   7. 識別 Key Entities（若涉及資料）
   8. 回傳：SUCCESS（spec ready for planning）

5. 使用模板結構，將規格寫入 SPEC_FILE，依據功能描述（arguments）替換各佔位符，同時保留章節順序與標題。

6. **規格品質驗證**：完成初步規格後，請依下列品質標準進行驗證：

   a. **建立規格品質檢查清單**：於 `
      - 本地分支：⟦C2⟧
      - Specs 目錄：檢查符合 ` 位置，依檢查清單模板結構產生 checklist 檔案，內容包含以下驗證項目：

      ```markdown
      # Specification Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate specification completeness and quality before proceeding to planning
      **Created**: [DATE]
      **Feature**: [Link to spec.md]
      
      ## Content Quality
      
      - [ ] No implementation details (languages, frameworks, APIs)
      - [ ] Focused on user value and business needs
      - [ ] Written for non-technical stakeholders
      - [ ] All mandatory sections completed
      
      ## Requirement Completeness
      
      - [ ] No [NEEDS CLARIFICATION] markers remain
      - [ ] Requirements are testable and unambiguous
      - [ ] Success criteria are measurable
      - [ ] Success criteria are technology-agnostic (no implementation details)
      - [ ] All acceptance scenarios are defined
      - [ ] Edge cases are identified
      - [ ] Scope is clearly bounded
      - [ ] Dependencies and assumptions identified
      
      ## Feature Readiness
      
      - [ ] All functional requirements have clear acceptance criteria
      - [ ] User scenarios cover primary flows
      - [ ] Feature meets measurable outcomes defined in Success Criteria
      - [ ] No implementation details leak into specification
      
      ## Notes
      
      - Items marked incomplete require spec updates before `/speckit.clarify` or `/speckit.plan`
      ```

   b. **執行驗證檢查**：根據每一項檢查清單，審查規格說明：
      - 對每一項目，判斷是否通過或未通過
      - 記錄發現的具體問題（引用相關規格說明段落）

   c. **處理驗證結果**：

      - **若所有項目皆通過**：標記檢查清單為完成，並進入步驟 6

      - **若有項目未通過（不含 [NEEDS CLARIFICATION] 標記）**：
        1. 列出未通過的項目及具體問題
        2. 更新規格說明以針對每個問題進行修正
        3. 重新執行驗證，直到所有項目通過（最多 3 次循環）
        4. 若 3 次後仍有未通過項目，請於檢查清單備註中記錄剩餘問題並提醒用戶

      - **若仍有 [NEEDS CLARIFICATION] 標記**：
        1. 從規格說明中擷取所有 [NEEDS CLARIFICATION: ...] 標記
        2. **數量限制檢查**：若標記超過 3 個，僅保留 3 個最關鍵者（依據範圍／安全性／UX 影響），其餘部分請做合理推測
        3. 對於每個需釐清事項（最多 3 個），以以下格式向用戶提供選項：

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant spec section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the feature] |
           | B      | [Second suggested answer] | [What this means for the feature] |
           | C      | [Third suggested answer] | [What this means for the feature] |
           | Custom | Provide your own answer | [Explain how to provide custom input] |
           
           **Your choice**: _[Wait for user response]_
           ```

        4. **重要 - 表格格式化**：請確保 Markdown 表格格式正確：
           - 使用一致的間距，並對齊豎線（pipes）
           - 每個儲存格內容前後需有空格：`| Content |` 而非 `|Content|`
           - 標頭分隔線必須至少有 3 個橫線：`|--------|`
           - 測試表格在 Markdown 預覽中能正確顯示
        5. 問題請依序編號（Q1、Q2、Q3，最多 3 題）
        6. 所有問題請一次性全部列出，然後再等待回覆
        7. 等待用戶針對所有問題回覆其選擇（例如："Q1: A, Q2: Custom - [details], Q3: B"）
        8. 依據用戶選擇或提供的答案，將每個 [NEEDS CLARIFICATION] 標記替換為對應內容
        9. 所有釐清完成後，重新執行驗證

   d. **更新檢查清單**：每次驗證流程後，請將目前的通過/未通過狀態更新至檢查清單檔案

7. 報告完成情況，包含分支名稱、規格檔案路徑、檢查清單結果，以及是否已準備進入下一階段（`/speckit.clarify` 或 `/speckit.plan`）。

**注意：** 此腳本會建立並切換至新分支，並在寫入前初始化規格檔案。

## 一般指引

## 快速指引

- 著重於用戶**需要什麼（WHAT）**以及**為什麼（WHY）**。
- 避免討論如何實作（不涉及技術堆疊、API、程式碼結構）。
- 文件對象為業務相關人員，而非開發者。
- 請勿在規格中嵌入任何檢查清單。檢查清單將由其他指令產生。

### 各區段要求

- **必填區段**：每個功能皆須完成
- **選填區段**：僅在與該功能相關時納入
- 若某區段不適用，請直接移除（不要保留為 "N/A"）

### AI 產生規格時

當根據用戶提示建立此規格時：

1. **合理推測**：運用上下文、產業標準及常見模式補足資訊缺口
2. **記錄假設**：將合理預設記錄於 Assumptions（假設）區段
3. **限制釐清數量**：最多僅能有 3 個 [NEEDS CLARIFICATION] 標記，僅用於以下關鍵決策：
   - 重大影響功能範圍或用戶體驗
   - 有多種合理解釋且影響不同
   - 完全沒有合理預設值
4. **釐清事項優先順序**：範圍 > 安全/隱私 > 用戶體驗 > 技術細節
5. **以測試者角度思考**：每個模糊需求都應無法通過「可測試且明確」的檢查項目
6. **常見需釐清區域**（僅在無合理預設時）：
   - 功能範圍與邊界（納入/排除哪些使用情境）
   - 用戶類型與權限（若有多種合理但互斥的解釋）
   - 安全/合規需求（具法律或財務重大影響時）

**合理預設範例**（這些不需額外詢問）：

- 資料保留：依產業標準慣例
- 效能目標：除非特別說明，採用標準網頁/行動應用預期
- 錯誤處理：提供友善訊息並有適當備援
- 驗證方式：Web 應用預設為 session-based 或 OAuth2
- 整合模式：預設為 RESTful API，除非另有說明

### 成功標準指引

成功標準必須：

1. **可衡量**：包含具體指標（時間、百分比、數量、比率）
2. **技術中立**：不得提及框架、語言、資料庫或工具
3. **以用戶為中心**：從用戶/業務角度描述結果，而非系統內部細節
4. **可驗證**：無需了解實作細節即可測試/驗證

**良好範例**：

- 「用戶可於 3 分鐘內完成結帳」
- 「系統可支援 10,000 名同時用戶」
- 「95% 搜尋結果於 1 秒內返回」
- 「任務完成率提升 40%」

**不良範例**（過於實作導向）：

- 「API 回應時間低於 200ms」（過於技術，請改為「用戶可即時看到結果」）
- 「資料庫可處理 1000 TPS」（屬於實作細節，請改用用戶面指標）
- 「React 元件能有效渲染」（框架限定）
- 「Redis 快取命中率高於 80%」（技術限定）
