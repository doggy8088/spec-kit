---
description: 根據自然語言的功能描述，建立或更新功能規格說明。
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

## 使用者輸入

使用者輸入可以直接由代理程式（agent）提供，或作為命令參數傳入——在繼續提示前，你**必須**先考慮這些輸入（若非空）。

使用者輸入：

$ARGUMENTS

使用者在觸發訊息中的 `/specify` 後輸入的文字**就是**功能描述。請假設你在本次對話中始終可取得該描述，即使下方出現了 `{ARGS}` 也一樣。除非使用者輸入的命令為空，否則不要要求使用者重複輸入。

根據該功能描述，請執行以下步驟：

1. 從 repository 根目錄執行腳本 `{SCRIPT}`，並解析其 JSON 輸出以取得 BRANCH_NAME 和 SPEC_FILE。所有檔案路徑必須為絕對路徑。  
   **重要：** 你只能執行此腳本一次。JSON 會以終端機輸出提供——請務必參考該輸出以取得你所需的實際內容。
2. 載入 `templates/spec-template.md` 以瞭解所需的章節。
3. 依照模板結構，將規格內容寫入 SPEC_FILE，並以功能描述（參數）中取得的具體細節取代對應的占位符，同時保留章節順序與標題。
4. 回報完成情況，包括分支名稱、規格檔案路徑，以及是否已準備好進入下一階段。

注意：腳本會建立並切換到新分支，並在寫入前初始化規格檔案。

```text
$ARGUMENTS
```

你在繼續執行前，**必須**考慮用戶輸入（若非空）。

## 大綱

用戶在觸發訊息中 `/speckit.specify` 之後輸入的文字**即為**功能描述。請假設在本次對話中你始終可以取得該功能描述，即使下方出現了 `{ARGS}` 也一樣。除非用戶輸入為空，否則請勿要求用戶重複輸入。

根據該功能描述，請執行以下步驟：

1. 從 repo 根目錄執行腳本 `{SCRIPT}`，並解析其 JSON 輸出以取得 BRANCH_NAME 與 SPEC_FILE。所有檔案路徑必須為絕對路徑。  
  **重要**：你只能執行此腳本一次。JSON 會在終端機作為輸出提供——請始終參考該輸出以取得你需要的實際內容。對於引數中如 "I'm Groot" 這類單引號，請使用跳脫語法，例如：'I'\''m Groot'（或若可行則使用雙引號："I'm Groot"）。
2. 載入 `templates/spec-template.md` 以了解所需章節。

3. 請依照以下執行流程：

    1. 從 Input 解析用戶描述  
       若為空：錯誤 "No feature description provided"
    2. 從描述中提取關鍵概念  
       辨識：角色（actors）、行為（actions）、資料（data）、限制條件（constraints）
    3. 對於不明確之處：  
       - 根據上下文與業界標準做出合理推測  
       - 僅在以下情況以 [NEEDS CLARIFICATION: 具體問題] 標記：  
         - 此選擇會顯著影響功能範圍或用戶體驗  
         - 存在多種合理解釋且影響不同  
         - 無合理預設值  
       - **限制：最多僅可有 3 個 [NEEDS CLARIFICATION] 標記**  
       - 按影響程度排序釐清事項：範圍 > 安全/隱私 > 用戶體驗 > 技術細節
    4. 填寫 User Scenarios & Testing 章節  
       若無明確用戶流程：錯誤 "Cannot determine user scenarios"
    5. 產生功能性需求（Functional Requirements）  
       每項需求必須可測試  
       對於未明確說明的細節，請採用合理預設值（並於 Assumptions 章節記錄這些假設）
    6. 定義成功標準（Success Criteria）  
       建立可衡量、與技術無關的成果  
       同時包含量化指標（時間、效能、數量）與質性指標（用戶滿意度、任務完成度）  
       每項標準必須可在無需實作細節的情況下驗證
    7. 辨識主要實體（Key Entities，若涉及資料）
    8. 回傳：SUCCESS（規格已可進行規劃）

4. 依照範本結構，將規格內容寫入 SPEC_FILE，並以從功能描述（引數）推導出的具體細節取代佔位內容，同時保留章節順序與標題。

5. **規格品質驗證**：撰寫初步規格後，請依據品質標準進行驗證：

   a. **建立規格品質檢查清單**：依照檢查清單範本結構，在 `FEATURE_DIR/checklists/requirements.md` 產生一份檢查清單檔案，內容包含以下驗證項目：
   
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
   
   b. **執行驗證檢查（Run Validation Check）**：依據檢查清單逐項審查規格（spec）：
      - 對每一項目，判斷是否通過或未通過
      - 記錄發現的具體問題（引用相關規格說明段落）
   
   c. **處理驗證結果**：
      
      - **若所有項目均通過**：標記檢查清單為完成，並繼續執行步驟 6
      
      - **若有項目未通過（不含 [NEEDS CLARIFICATION] 標記）**：
        1. 列出未通過的項目及具體問題
        2. 更新規格以解決每個問題
        3. 重新執行驗證，直到所有項目通過（最多 3 次循環）
        4. 若 3 次循環後仍未全部通過，請於檢查清單備註中記錄剩餘問題，並提醒用戶
      
      - **若仍有 [NEEDS CLARIFICATION] 標記存在**：
        1. 從規格中擷取所有 [NEEDS CLARIFICATION: ...] 標記
        2. **數量限制檢查（LIMIT CHECK）**：若標記超過 3 個，只保留 3 個最關鍵的（依範圍／安全性／使用者體驗影響排序），其餘部分請根據合理判斷給出建議
        3. 對於每個需釐清事項（最多 3 項），請以以下格式向用戶呈現選項：
        
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
           - 使用一致的間距，並對齊分隔線
           - 每個儲存格內容前後都要有空格：`| Content |` 而非 `|Content|`
           - 標頭分隔線必須至少有 3 個破折號：`|--------|`
           - 測試表格在 Markdown 預覽中能正確顯示
        5. 問題請依序編號（Q1、Q2、Q3，最多 3 題）
        6. 請將所有問題一次全部呈現，再等待回覆
        7. 等待使用者針對所有問題回覆其選擇（例如："Q1: A, Q2: Custom - [details], Q3: B"）
        8. 依據使用者選擇或提供的答案，將每個 [NEEDS CLARIFICATION] 標記替換更新規格
        9. 所有釐清完成後，請重新執行驗證

   d. **更新檢查清單**：每次驗證後，請將目前通過/未通過狀態更新至檢查清單檔案

6. 回報完成情況，包括分支名稱、規格檔案路徑、檢查清單結果，以及是否已準備好進入下一階段（`/speckit.clarify` 或 `/speckit.plan`）。

**注意：** 腳本會自動建立並切換到新分支，並在寫入前初始化規格檔案。

## 一般指引

## 快速指引

- 著重於使用者**需要什麼**以及**為什麼需要**。
- 避免描述如何實作（不涉及技術堆疊、API、程式碼結構）。
- 內容對象為業務相關人員，而非開發者。
- 請勿在規格中嵌入任何檢查清單。檢查清單將由其他指令產生。

### 各區塊要求

- **必填區塊**：每個功能都必須填寫
- **選填區塊**：僅在與功能相關時才納入
- 若某區塊不適用，請直接移除（不要留 "N/A"）

### 給 AI 產生時的說明

當根據用戶提示產生此規格時：

1. **合理推測**：運用上下文、產業標準與常見模式補足資訊缺口
2. **記錄假設**：將合理預設記錄於「假設」區塊
3. **限制釐清數量**：最多僅能有 3 個 [NEEDS CLARIFICATION] 標記——僅用於那些：
   - 會顯著影響功能範圍或使用者體驗
   - 存在多種合理解釋且影響不同
   - 無任何合理預設值可用
4. **釐清事項優先順序**：範圍 > 安全/隱私 > 使用者體驗 > 技術細節
5. **以測試者角度思考**：每個模糊需求都應無法通過「可測試且明確」的檢查項目
6. **常見需釐清區域**（僅在無合理預設時）：
   - 功能範圍與界線（包含/排除哪些使用情境）
   - 使用者類型與權限（若有多種合理但互斥的解釋）
   - 安全/合規需求（具法律或財務重大影響時）

**合理預設範例**（不需釐清）：

- 資料保留：依該領域產業標準
- 效能目標：除非特別指定，採用標準 Web/行動應用預期
- 錯誤處理：以友善訊息及適當備援為原則
- 驗證方式：Web 應用預設使用標準 Session 或 OAuth2
- 整合模式：除非另有說明，預設使用 RESTful API

### 成功標準指引

成功標準必須：

1. **可衡量**：包含明確指標（時間、百分比、數量、比率）
2. **與技術無關**：不得提及框架、語言、資料庫或工具
3. **以使用者為中心**：從使用者/業務角度描述成果，而非系統內部
4. **可驗證**：無須了解實作細節即可測試/驗證

**良好範例**：

- 「使用者可在 3 分鐘內完成結帳」
- 「系統可支援 10,000 名同時使用者」
- 「95% 搜尋結果於 1 秒內返回」
- 「任務完成率提升 40%」

**不良範例**（過於實作導向）：

- 「API 回應時間小於 200ms」（太技術性，應改為「使用者能即時看到結果」）
- 「資料庫可處理 1000 TPS」（屬於實作細節，應改為使用者面向指標）
- 「React 元件渲染效率高」（特定框架）
- 「Redis 快取命中率超過 80%」（特定技術）
