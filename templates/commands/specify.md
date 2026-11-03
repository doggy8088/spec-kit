---
description: 根據自然語言的功能描述，建立或更新功能規格。
handoffs:
  - label: 建立技術計畫
    agent: speckit.plan
    prompt: 為規格建立計畫。我正在用以下技術建構……
  - label: 釐清規格需求
    agent: speckit.clarify
    prompt: 釐清規格需求
    send: true
scripts:
  sh: scripts/bash/resolve-template.sh spec-template --json
  ps: scripts/powershell/resolve-template.ps1 spec-template -Json
  py: scripts/python/resolve_template.py spec-template --json
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考量使用者輸入（若非空）。

## 執行前檢查

**檢查擴充功能 hooks（在規格建立之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_specify` 鍵底下的項目
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

    Wait for the result of the hook command before proceeding to the Outline.
    ```
    輸出上面這個區塊之後，你必須實際叫用該 hook 並等它完成，才能繼續。叫用方式與你在這個代理／工作階段中自行執行該命令的方式相同（實際叫用可能與上面顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默略過

## 大綱

使用者在觸發訊息中於 `__SPECKIT_COMMAND_SPECIFY__` 之後輸入的文字，**就是**功能描述。即使下方字面出現 `{ARGS}`，也要假設你在這段對話中隨時能取得它。除非使用者給了空命令，否則不要要求使用者重述。

有了該功能描述，請執行下列事項：

1. **為功能產生簡潔的短名稱**（2–4 個詞）：
   - 分析功能描述，擷取最有意義的關鍵字
   - 建立一個 2–4 個詞的短名稱，抓住功能的本質
   - 盡可能使用動作—名詞格式（例如 "add-user-auth"、"fix-payment-bug"）
   - 保留技術用語與縮寫（OAuth2、API、JWT 等）
   - 保持簡潔，但要有足夠的描述性，讓人一眼就能理解功能
   - 範例：
     - "I want to add user authentication" → "user-auth"
     - "Implement OAuth2 integration for the API" → "oauth2-api-integration"
     - "Create a dashboard for analytics" → "analytics-dashboard"
     - "Fix payment processing timeout bug" → "fix-payment-timeout"

2. **建立分支**（選用，透過 hook）：

   若上方執行前檢查中有 `before_specify` hook 成功執行，它會建立／切換到一個 git 分支，並輸出包含 `BRANCH_NAME` 與 `FEATURE_NUM` 的 JSON。記下這些值供參照，但分支名稱**不會**決定規格目錄名稱。

   若使用者明確提供了 `GIT_BRANCH_NAME`，將它傳給 hook，讓分支指令碼直接以該值作為分支名稱（繞過所有前綴／後綴產生邏輯）。

3. **建立規格功能目錄**：

   除非使用者明確提供 `SPECIFY_FEATURE_DIRECTORY`，否則規格存放在預設的 `specs/` 目錄底下。

   **`SPECIFY_FEATURE_DIRECTORY` 的解析順序**：
   1. 若使用者明確提供了 `SPECIFY_FEATURE_DIRECTORY`（例如透過環境變數、參數或設定），直接使用它
   2. 否則，在 `specs/` 底下自動產生：
      - 檢查 `.specify/init-options.json` 中的 `feature_numbering`（偏好）或 `branch_numbering`（已棄用，僅供遷移，未來版本將移除）
      - 若為 `"timestamp"`：前綴是 `YYYYMMDD-HHMMSS`（目前時間戳記）
      - 若為 `"sequential"` 或未設定：前綴是 `NNN`（掃描 `specs/` 中既有目錄後，下一個可用的 3 位數編號）
      - 組成目錄名稱：`<prefix>-<short-name>`（例如 `003-user-auth` 或 `20260319-143022-user-auth`）
      - 將 `SPECIFY_FEATURE_DIRECTORY` 設為 `specs/<directory-name>`
      - 若使用了 `branch_numbering`（且 `feature_numbering` 未設定），輸出一行警告："⚠️ `branch_numbering` in init-options.json is deprecated. Rename to `feature_numbering`."

   **建立目錄與規格檔案**：
   - 從儲存庫根目錄執行 `{SCRIPT}`，並將 `TEMPLATE_CONTENT` 解析為目前的 `spec-template`。共用解析器會在核心範本之上，組合專案覆寫、預設集層與擴充功能層，包括 `append`、`prepend` 與 `wrap` 策略。若它失敗，停止並回報解析錯誤；不要只用單一貢獻範本層繼續。
   - `mkdir -p SPECIFY_FEATURE_DIRECTORY`
   - 將 `TEMPLATE_CONTENT` 寫入 `SPECIFY_FEATURE_DIRECTORY/spec.md` 作為起點。不要改為從磁碟複製範本檔案：當預設集組合 `spec-template` 時，沒有任何單一檔案持有完整範本。
   - 將 `SPEC_FILE` 設為 `SPECIFY_FEATURE_DIRECTORY/spec.md`
   - 將解析後的路徑保存到 `.specify/feature.json`：
     ```json
     {
       "feature_directory": "<resolved feature dir>"
     }
     ```
     寫入實際解析後的目錄路徑值（例如 `specs/003-user-auth`），而不是字面字串 `SPECIFY_FEATURE_DIRECTORY`。
     這讓下游命令（`__SPECKIT_COMMAND_PLAN__`、`__SPECKIT_COMMAND_TASKS__` 等）能找到功能目錄，不必依賴 git 分支名稱慣例。

   **重要**：
   - 每次叫用 `__SPECKIT_COMMAND_SPECIFY__`，你只能建立一個功能
   - 規格目錄名稱與 git 分支名稱彼此獨立，它們可能相同，但那是使用者的選擇
   - 規格目錄與檔案一律由本命令建立，絕不由 hook 建立

4. 使用 `TEMPLATE_CONTENT` 來理解必要章節。

5. **若存在**：載入 `/memory/constitution.md`，取得專案原則與治理限制。

6. 依循這個執行流程：
    1. 從參數解析使用者描述
       若為空：ERROR "No feature description provided"
    2. 從描述中擷取關鍵概念
       辨識：行動者、動作、資料、限制
    3. 對於不清楚的面向：
       - 根據脈絡與產業標準做有依據的推測
       - 只有在下列情況才以 [NEEDS CLARIFICATION: specific question] 標記：
         - 該選擇會顯著影響功能範圍或使用者體驗
         - 存在多種合理解讀且含義不同
         - 沒有合理的預設值
       - **限制：[NEEDS CLARIFICATION] 標記總數最多 3 個**
       - 依影響排序釐清的優先順序：範圍 > 安全性／隱私 > 使用者體驗 > 技術細節
    4. 填寫 User Scenarios & Testing 章節
       若沒有清楚的使用者流程：ERROR "Cannot determine user scenarios"
    5. 產生 Functional Requirements
       每項需求都必須可測試
       對未指明的細節使用合理的預設值（在 Assumptions 章節中記錄假設）
    6. 定義 Success Criteria
       建立可衡量、與技術無關的成果
       同時納入量化指標（時間、效能、量）與質化衡量（使用者滿意度、任務完成度）
       每項判準都必須能在不涉及實作細節的情況下驗證
    7. 辨識 Key Entities（若涉及資料）
    8. 回傳：SUCCESS (spec ready for planning)

7. 使用範本結構將規格寫入 SPEC_FILE，以從功能描述（參數）推導出的具體細節取代佔位符，同時保留章節順序與標題。

8. **規格品質驗證**：寫入初步規格之後，對照品質判準驗證它：

   a. **建立規格品質檢核清單**：使用檢核清單範本結構，在 `SPECIFY_FEATURE_DIRECTORY/checklists/requirements.md` 產生一份檢核清單檔案，包含下列驗證項目：

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

      - Items marked incomplete require spec updates before `__SPECKIT_COMMAND_CLARIFY__` or `__SPECKIT_COMMAND_PLAN__`
      ```

   b. **執行驗證檢查**：對照每個檢核清單項目審查規格：
      - 對每個項目，判斷它通過或未通過
      - 記錄找到的具體問題（引用相關的規格章節）

   c. **處理驗證結果**：

      - **若所有項目都通過**：將檢核清單標記為完成，並前往強制執行後 Hooks 章節

      - **若有項目未通過（不含 [NEEDS CLARIFICATION]）**：
        1. 列出未通過的項目與具體問題
        2. 更新規格以處理每個問題
        3. 重新執行驗證，直到所有項目都通過（最多 3 次迭代）
        4. 若 3 次迭代後仍未通過，在檢核清單備註中記錄剩餘問題並警告使用者

      - **若 [NEEDS CLARIFICATION] 標記仍有殘留**：
        1. 從規格中擷取所有 [NEEDS CLARIFICATION: ...] 標記
        2. **限制檢查**：若標記超過 3 個，只保留最關鍵的 3 個（依範圍／安全性／UX 影響），其餘做有依據的推測
        3. 對每個需要的釐清（最多 3 個），以這個格式向使用者呈現選項：

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

        4. **關鍵：表格格式**：確保 markdown 表格格式正確：
           - 使用一致的間距，讓直線對齊
           - 每個儲存格的內容前後都應有空格：`| Content |`，而不是 `|Content|`
           - 標題分隔列必須至少有 3 個連字號：`|--------|`
           - 測試表格能在 markdown 預覽中正確呈現
        5. 將問題依序編號（Q1、Q2、Q3，最多總共 3 題）
        6. 在等待回覆之前，將所有問題一起呈現
        7. 等待使用者回覆所有問題的選擇（例如 "Q1: A, Q2: Custom - [details], Q3: B"）
        8. 以使用者選定或提供的答案，取代規格中的每個 [NEEDS CLARIFICATION] 標記，藉此更新規格
        9. 在所有釐清都解決之後，重新執行驗證

   d. **更新檢核清單**：在每次驗證迭代之後，以目前的通過／未通過狀態更新檢核清單檔案

## 強制執行後 Hooks

**在向使用者回報完成之前，你必須完成本節。**

檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若它不存在，或 `hooks.after_specify` 底下沒有註冊任何 hooks，略過並前往完成報告。
- 若存在，讀取它並尋找 `hooks.after_specify` 鍵底下的項目。
- 若 YAML 無法解析或無效，不要默默略過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析錯誤），且未檢查任何 hooks，包括其中註冊的必要（`optional: false`）hooks，然後繼續前往完成報告。
- 濾除 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為已啟用。
- 對其餘每個 hook，不要嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或該欄位為 null／空值，將該 hook 視為可執行
  - 若 hook 定義了非空的 `condition`，略過該 hook，將條件評估留給 HookExecutor 實作處理
- 對每個可執行的 hook，依其 `optional` 旗標輸出下列內容：
  - **必要 hook**（`optional: false`）——**你必須為每個必要 hook 輸出 `EXECUTE_COMMAND:`**：
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    輸出上面這個區塊之後，你必須實際叫用該 hook 並等它完成，才能繼續。叫用方式與你在這個代理／工作階段中自行執行該命令的方式相同（實際叫用可能與上面顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
  - **選用 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

## 完成報告

向使用者回報完成，並附上：
- `SPECIFY_FEATURE_DIRECTORY`：功能目錄路徑
- `SPEC_FILE`：規格檔案路徑
- 檢核清單結果摘要
- 下一階段的就緒狀態（`__SPECKIT_COMMAND_CLARIFY__` 或 `__SPECKIT_COMMAND_PLAN__`）

**注意：** 分支建立由 `before_specify` hook（git 擴充功能）處理。規格目錄與檔案的建立一律由這個核心命令處理。

## 快速指引

- 聚焦於使用者需要**什麼**，以及**為什麼**。
- 避免如何實作（不要技術堆疊、API、程式碼結構）。
- 為業務利害關係人撰寫，而不是為開發者撰寫。
- 不要建立任何嵌入規格中的檢核清單。那會是另一個獨立命令。

### 章節要求

- **必要章節**：每個功能都必須完成
- **選用章節**：只有在與功能相關時才納入
- 當某個章節不適用時，完全移除它（不要留成 "N/A"）

### 供 AI 產生使用

從使用者提示建立這份規格時：

1. **做有依據的推測**：使用脈絡、產業標準與常見模式來填補缺口
2. **記錄假設**：在 Assumptions 章節中記錄合理的預設值
3. **限制釐清**：[NEEDS CLARIFICATION] 標記最多 3 個，只用於下列關鍵決策：
   - 顯著影響功能範圍或使用者體驗
   - 有多種合理解讀且含義不同
   - 缺乏任何合理的預設值
4. **釐清的優先順序**：範圍 > 安全性／隱私 > 使用者體驗 > 技術細節
5. **像測試者一樣思考**：每個模糊的需求都應該無法通過「可測試且無歧義」的檢核清單項目
6. **常見需要釐清的區域**（只有在沒有合理預設值時）：
   - 功能範圍與邊界（納入／排除特定使用案例）
   - 使用者類型與權限（若可能有多種互相衝突的解讀）
   - 安全性／合規需求（在法律或財務上重大時）

**合理預設值的範例**（不要詢問這些）：

- 資料保留：該領域的產業標準實務
- 效能目標：除非另有指明，否則採標準的 web／行動應用預期
- 錯誤處理：友善的訊息搭配適當的備援
- 驗證方法：web 應用採標準的 session 型或 OAuth2
- 整合模式：使用適合專案的模式（web 服務用 REST/GraphQL、函式庫用函式呼叫、工具用 CLI 參數等）

### 成功判準指引

成功判準必須：

1. **可衡量**：包含具體指標（時間、百分比、數量、速率）
2. **與技術無關**：不提及框架、語言、資料庫或工具
3. **以使用者為中心**：從使用者／業務觀點描述成果，而不是系統內部
4. **可驗證**：能在不知道實作細節的情況下測試／驗證

**良好範例**：

- "Users can complete checkout in under 3 minutes"
- "System supports 10,000 concurrent users"
- "95% of searches return results in under 1 second"
- "Task completion rate improves by 40%"

**不良範例**（聚焦實作）：

- "API response time is under 200ms"（太技術性，改用「使用者立即看到結果」）
- "Database can handle 1000 TPS"（實作細節，改用面向使用者的指標）
- "React components render efficiently"（特定框架）
- "Redis cache hit rate above 80%"（特定技術）

## 完成條件

- [ ] 規格已寫入 `SPEC_FILE`，並已對照品質檢核清單驗證
- [ ] 已依上方強制執行後 Hooks 的規則分派或略過擴充功能 hooks
- [ ] 已向使用者回報完成，包括功能目錄、規格檔案路徑與檢核清單結果
