---
description: 透過提出最多 5 個高度針對性的釐清問題，找出目前功能規格中規格不足的區域，並將答案編碼回規格中。
handoffs:
  - label: 建立技術計畫
    agent: speckit.plan
    prompt: 為規格建立計畫。我正在用以下技術建構……
scripts:
   sh: scripts/bash/check-prerequisites.sh --json --paths-only
   ps: scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly
   py: scripts/python/check_prerequisites.py --json --paths-only
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考量使用者輸入（若非空）。

## 執行前檢查

**檢查擴充功能 hooks（在釐清之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_clarify` 鍵底下的項目
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

目標：偵測並減少目前功能規格中的歧義或缺少的決策點，並將釐清結果直接記錄在規格檔案中。

注意：這個釐清工作流程預期應在叫用 `__SPECKIT_COMMAND_PLAN__` 之前執行（並完成）。若使用者明確表示要略過釐清（例如探索性 spike），你可以繼續，但必須警告下游返工風險會提高。

執行步驟：

1. 從儲存庫根目錄執行 `{SCRIPT}` **一次**（合併的 `--json --paths-only` 模式／`-Json -PathsOnly`）。解析最小 JSON 載荷欄位：
   - `FEATURE_DIR`
   - `FEATURE_SPEC`
   - （可選擇擷取 `IMPL_PLAN`、`TASKS`，供未來串接流程使用。）
   - 若 JSON 解析失敗，中止並指示使用者重新執行 `__SPECKIT_COMMAND_SPECIFY__`，或確認功能分支環境。
   - 對於參數中像 "I'm Groot" 這類單引號，使用跳脫語法：例如 'I'\''m Groot'（或盡可能使用雙引號："I'm Groot"）。

2. **若存在**：載入 `/memory/constitution.md`，取得專案原則與治理限制。

3. 載入目前的規格檔案。使用這套分類法進行結構化的歧義與覆蓋範圍掃描。對每個分類標記狀態：Clear／Partial／Missing。產生一份供優先排序使用的內部覆蓋對照（除非不會提出任何問題，否則不要輸出原始對照）。

   功能範圍與行為：
   - 核心使用者目標與成功判準
   - 明確的範圍外宣告
   - 使用者角色／人物誌的區分

   領域與資料模型：
   - 實體、屬性、關聯
   - 身分與唯一性規則
   - 生命週期／狀態轉換
   - 資料量／規模假設

   互動與 UX 流程：
   - 關鍵使用者旅程／序列
   - 錯誤／空／載入狀態
   - 無障礙或在地化備註

   非功能品質屬性：
   - 效能（延遲、吞吐量目標）
   - 可擴展性（水平／垂直、限制）
   - 可靠性與可用性（上線時間、復原預期）
   - 可觀測性（記錄、指標、追蹤訊號）
   - 安全性與隱私（authN/Z、資料保護、威脅假設）
   - 合規／法規限制（若有）

   整合與外部相依性：
   - 外部服務／API 與失敗模式
   - 資料匯入／匯出格式
   - 通訊協定／版本假設

   邊界案例與失敗處理：
   - 負面情境
   - 速率限制／節流
   - 衝突解決（例如同時編輯）

   限制與取捨：
   - 技術限制（語言、儲存、託管）
   - 明確的取捨或已否決的替代方案

   術語與一致性：
   - 標準詞彙表用語
   - 避免的同義詞／已棄用用語

   完成訊號：
   - 驗收判準的可測試性
   - 可衡量的完成定義式指標

   其他／佔位符：
   - TODO 標記／未決事項
   - 缺乏量化的模糊形容詞（"robust"、"intuitive"）

   對每個狀態為 Partial 或 Missing 的分類，新增一個候選問題機會，除非：
   - 釐清不會實質改變實作或驗證策略
   - 該項目具體涉及實作方法、技術堆疊比較或任務拆解（內部註記即可）

4. （在內部）產生一份依優先順序排列的候選釐清問題佇列（最多 5 題）。不要一次全部輸出。套用下列限制：
    - 整個工作階段最多 5 題。
    - 每個問題都必須能以下列任一方式回答：
       - 簡短的選擇題（2–5 個不同、互斥的選項），或
       - 一個詞／短語的答案（明確限制：「以 5 個詞以內作答」）。
    - 只納入答案會實質影響架構、資料建模、任務拆解、測試設計、UX 行為、營運就緒或合規驗證的問題。
    - 確保分類覆蓋均衡：先嘗試涵蓋影響最高的未決分類；當單一高影響領域（例如安全態勢）尚未解決時，避免提出兩個低影響問題。
    - 排除已回答的問題、瑣碎的風格偏好，或計畫層級的執行細節（除非會阻礙正確性）。
    - 優先選擇能降低下游返工風險，或防止驗收測試不一致的釐清。
    - 若仍有超過 5 個分類未解決，依（影響 × 不確定性）啟發法選出前 5 個。

5. 依序提問迴圈（互動式）：
    - 一次只呈現**恰好一個**問題。
    - **問題撰寫品質（適用於每個問題，無論選擇題或簡答題）：**
       - 以 `**Question:**` 開頭，後接以 `?` 結尾的完整疑問句。`?` 之前的問題文字本身必須能獨立成立。
       - 絕不把主題標籤、章節標題或需求編號本身當成問題。例如 `Acceptance device/runtime matrix (FR-023)` 是無效的，它是標籤，不是問題。
       - 在 `?` 之後，唯一允許的字尾是選擇性的括號需求／問題編號。確切格式：`**Question:** <interrogative>?` 或 `**Question:** <interrogative>? (FR-023)`。絕不把編號放在 `?` 之前，也絕不把編號（單獨或連同主題標籤）當成整個提示。
       - 緊接在問題行之後，在建議／選項之前，加上一句白話的「為什麼重要」說明（與驗收或出貨相關的利害）。
       - 使用日常措辭；只有在同一句中加以定義時才引入術語。自我檢查：不認識 Spec Kit 的讀者，必須只憑 Question 行就能作答。簡潔可以，隱晦的標籤不行。
    - 對於選擇題：
       - **分析所有選項**，並根據下列各點判斷**最適合的選項**：
          - 該專案類型的最佳實務
          - 類似實作中的常見模式
          - 風險降低（安全性、效能、可維護性）
          - 與規格中可見的任何明確專案目標或限制相符
       - 將你的**建議選項醒目地放在最上方**，並清楚說明理由（以 1–2 句說明為什麼這是最佳選擇）。
       - 格式為：`**Recommended:** Option [X] - <reasoning>`
       - 然後將所有選項呈現為 Markdown 表格：

       | Option | Description |
       |--------|-------------|
       | A | <Option A description> |
       | B | <Option B description> |
       | C | <Option C description> (add D/E as needed up to 5) |
       | Short | Provide a different short answer (<=5 words) (Include only if free-form alternative is appropriate) |

       - 在表格之後加上：`You can reply with the option letter (e.g., "A"), accept the recommendation by saying "yes" or "recommended", or provide your own short answer.`
    - 對於簡答形式（沒有有意義的離散選項）：
       - 根據最佳實務與脈絡，提供你的**建議答案**。
       - 格式為：`**Suggested:** <your proposed answer> - <brief reasoning>`
       - 然後輸出：`Format: Short answer (<=5 words). You can accept the suggestion by saying "yes" or "suggested", or provide your own answer.`
    - 在使用者回答之後：
       - 若使用者回覆 "yes"、"recommended" 或 "suggested"，以你先前陳述的建議作為答案。
       - 否則，驗證答案是否對應到某個選項，或符合 5 個詞以內的限制。
       - 若有歧義，要求快速消歧（次數仍屬於同一題；不要往下推進）。
       - 滿意之後，將它記錄在工作記憶中（先不要寫入磁碟），並移到佇列中的下一個問題。
    - 在下列情況停止提問：
       - 所有關鍵歧義都提早解決（佇列中剩餘的項目變得不必要），或
       - 使用者表示完成（"done"、"good"、"no more"），或
       - 你已提出 5 個問題。
    - 絕不提前透露佇列中未來的問題。
    - 若一開始就沒有有效的問題，立即回報沒有關鍵歧義。

6. 在每個接受的答案之後整合（增量更新方式）：
    - 維護規格在記憶體中的表示（在開始時載入一次），加上原始檔案內容。
    - 對於本工作階段第一個整合的答案：
       - 確保存在 `## Clarifications` 章節（若缺少，依規格範本在最高層級的脈絡／概覽章節之後建立）。
       - 在它底下，建立（若尚未存在）今天的 `### Session YYYY-MM-DD` 子標題。
    - 在接受之後立即附加一行項目符號：`- Q: <question> → A: <final answer>`。
    - 然後立即將釐清套用到最合適的章節：
       - 功能歧義 → 在 Functional Requirements 中更新或新增一個項目符號。
       - 使用者互動／行動者區分 → 在 User Stories 或 Actors 子章節（若存在）中，以釐清後的角色、限制或情境更新。
       - 資料形狀／實體 → 更新 Data Model（新增欄位、型別、關聯），保留順序；簡潔註記新增的限制。
       - 非功能限制 → 在 Success Criteria > Measurable Outcomes 中新增／修改可衡量的判準（把模糊的形容詞轉換為指標或明確目標）。
       - 邊界案例／負面流程 → 在 Edge Cases / Error Handling 底下新增一個項目符號（或在範本有其佔位符時建立這類子章節）。
       - 術語衝突 → 在整份規格中正規化用語；只有在必要時才保留原文，並加上 `(formerly referred to as "X")` 一次。
    - 若釐清使先前含糊的陳述失效，取代該陳述而不是重複；不要留下過時且矛盾的文字。
    - 在每次整合之後儲存規格檔案，以盡量降低脈絡遺失的風險（原子覆寫）。
    - 保留格式：不要重排無關的章節；保持標題階層完整。
    - 讓每個插入的釐清保持最小且可測試（避免敘事偏離）。

7. 驗證（在每次寫入之後執行，加上最終檢查）：
   - 釐清工作階段中，每個接受的答案恰好有一個項目符號（無重複）。
   - 提出的（已接受）問題總數 ≤ 5。
   - 更新後的章節中，不再殘留新答案本應解決的模糊佔位符。
   - 沒有矛盾的先前陳述殘留（掃描已移除的、現已無效的替代選項）。
   - Markdown 結構有效；唯一允許的新標題：`## Clarifications`、`### Session YYYY-MM-DD`。
   - 術語一致性：所有更新後的章節都使用相同的標準用語。

8. 將更新後的規格寫回 `FEATURE_SPEC`。

9. **重新驗證規格品質檢核清單**（若存在）：
   - 檢查 `FEATURE_DIR/checklists/requirements.md` 是否存在。
   - 若不存在，默默略過這一步。
   - 若存在：
     1. 讀取檢核清單檔案。
     2. 辨識所有 GitHub 任務清單核取方塊行，也就是符合 `- [ ]`、`- [x]` 或 `- [X]` 的行（不分大小寫，容許巢狀項目的前置空白），且位於程式碼圍欄之外。忽略所有其他內容（標題、備註、非核取方塊的項目符號、中繼資料）。
     3. 對每個核取方塊行，將其目前的標記狀態（已核取或未核取）與項目文字記錄到一份事前快照清單中。
     4. 對照**更新後**的規格（剛在步驟 7 儲存的版本），重新評估每個核取方塊項目。
     5. 對每個核取方塊項目，只有在已核取／未核取狀態確實改變時才更新：
        - 若該項目現在通過且先前未核取：把 `[ ]` 改為 `[x]`。
        - 若該項目現在未通過且先前已核取：把 `[x]`／`[X]` 改為 `[ ]`。
        - 若狀態未變：保持標記原樣（保留既有的大小寫，避免無謂的外觀差異）。
     6. 儲存更新後的檢核清單檔案。**只切換狀態有變動的核取方塊行中的 `[ ]`／`[x]` 標記部分。** 所有其他檔案內容，包括標題、中繼資料、備註、行序、空白，都必須保持不變，避免產生雜訊差異。
     7. 比較事前快照與目前狀態，計算出完成報告所需的三份清單：
        - **新通過**：從未核取變為已核取的項目。
        - **退步**：從已核取變為未核取的項目。
        - **仍未核取**：保持未核取的項目。
     8. 以已核取／核取方塊項目總數記錄事前／事後通過數（例如 "12/16 → 15/16 items passing"）。

行為規則：

- 若未發現有意義的歧義（或所有潛在問題的影響都很低），回覆：「未偵測到值得正式釐清的關鍵歧義。」並建議繼續。
- 若規格檔案缺少，指示使用者先執行 `__SPECKIT_COMMAND_SPECIFY__`（不要在這裡建立新規格）。
- 絕不超過總共提出 5 個問題（單一問題的釐清重試不計為新問題）。
- 避免臆測的技術堆疊問題，除非其缺少會阻礙功能清晰度。
- 尊重使用者提早終止的訊號（"stop"、"done"、"proceed"）。
- 若因覆蓋完整而沒有提出任何問題，輸出精簡的覆蓋摘要（所有分類皆為 Clear），然後建議往下推進。
- 若配額已達且仍有高影響分類未解決，在 Deferred 底下明確標記它們並說明理由。

優先排序脈絡：{ARGS}

## 強制執行後 Hooks

**在向使用者回報完成之前，你必須完成本節。**

檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若它不存在，或 `hooks.after_clarify` 底下沒有註冊任何 hooks，略過並前往完成報告。
- 若存在，讀取它並尋找 `hooks.after_clarify` 鍵底下的項目。
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

回報完成（在提問迴圈結束或提早終止之後）：
- 提出與回答的問題數量。
- 更新後規格的路徑。
- 觸及的章節（列出名稱）。
- 規格品質檢核清單狀態（若重新驗證了 `FEATURE_DIR/checklists/requirements.md`）：顯示事前／事後通過數（例如 "Spec Quality Checklist: 12/16 → 15/16 items passing"），並列出任何狀態改變的項目，包括新核取的（未核取 → 已核取）與任何退步的（已核取 → 未核取）。若有任何項目仍未核取，將它們列為需要留意的區域。
- 覆蓋摘要表，列出每個分類法分類及其狀態：Resolved（先前為 Partial／Missing 且已處理）、Deferred（超出問題配額，或剩餘項目具體涉及實作方法、技術堆疊比較或任務拆解）、Clear（已經足夠）、Outstanding（仍為 Partial／Missing 但影響低）。
- 若仍有任何 Outstanding 或 Deferred，建議應該繼續前往 `__SPECKIT_COMMAND_PLAN__`，還是稍後在計畫之後再次執行 `__SPECKIT_COMMAND_CLARIFY__`。
- 建議的下一個命令。

## 完成條件

- [ ] 已辨識規格歧義，並將釐清整合進規格檔案
- [ ] 已對照更新後的規格重新驗證規格品質檢核清單（若 `FEATURE_DIR/checklists/requirements.md` 存在）
- [ ] 已依上方強制執行後 Hooks 的規則分派或略過擴充功能 hooks
- [ ] 已向使用者回報完成，包括回答的問題、觸及的章節、檢核清單狀態與覆蓋摘要
