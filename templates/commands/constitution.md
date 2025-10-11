---
description: 依據互動式或提供的原則輸入，建立或更新專案憲章，並確保所有相依的模板保持同步。
---

## 使用者輸入

```text
$ARGUMENTS
```

你在執行前（若用戶輸入非空）**必須**考慮用戶輸入內容。

## 大綱

你正在更新位於 `/memory/constitution.md` 的專案憲章（project constitution）。此檔案為範本（TEMPLATE），包含以中括號標示的占位符（placeholder token）（例如：`[PROJECT_NAME]`、`[PRINCIPLE_1_NAME]`）。你的工作是：(a) 收集／推導具體值，(b) 精確填寫範本，(c) 將任何修訂同步至所有相依產物。

請依照以下執行流程（Execution Flow）操作：

1. 載入現有的憲章範本（constitution template），路徑為 `/memory/constitution.md`。
   - 辨識所有形式為 `[ALL_CAPS_IDENTIFIER]` 的占位符。
   **重要**：用戶可能需要比範本中更多或更少的原則（principle）。若用戶指定數量，請遵循該要求，並依照一般範本進行。你需相應更新文件。

2. 收集／推導占位符的具體值：
   - 若用戶輸入（對話內容）有提供值，則直接使用。
   - 否則，從現有 repo 上下文（README、文件、過往憲章版本（若有嵌入））推導。
   - 關於治理日期（governance dates）：`RATIFICATION_DATE` 為最初採用日期（若未知請詢問或標記 TODO），`LAST_AMENDED_DATE` 若有變更則為今日，否則維持原值。
   - `CONSTITUTION_VERSION` 必須依語意化版本控制（Semantic Versioning）規則遞增：
     * MAJOR：治理或原則有向下不相容的移除或重新定義。
     * MINOR：新增原則／章節，或實質擴充指引。
     * PATCH：釐清、措辭、錯字修正、非語意性微調。
   - 若版本升級類型有歧義，請在定稿前提出推論理由。

3. 草擬更新後的憲章內容：
   - 用具體文字取代所有占位符（除非專案明確選擇保留的範本欄位，否則不得留有中括號占位符——如有保留，請明確說明理由）。
   - 保留標題階層，已被取代的註解可移除，除非仍具釐清說明作用。
   - 確保每個原則（Principle）章節：有簡明名稱、段落（或條列）描述不可協商規則，若理由不明顯則需明確說明。
   - 確保「治理」（Governance）章節列出修訂程序、版本政策，以及合規審查預期。

4. 一致性同步檢查清單（將先前檢查清單轉為主動驗證）：
   - 閱讀 `/templates/plan-template.md`，確保任何「專案憲章檢查」或規則與更新後原則一致。
   - 閱讀 `/templates/spec-template.md`，確認範疇／需求一致——若憲章新增／移除強制章節或限制，需同步更新。
   - 閱讀 `/templates/tasks-template.md`，確保任務分類反映新增或移除的原則驅動任務類型（如：可觀察性、版本管理、測試紀律）。
   - 閱讀 `/templates/commands/*.md` 內每個指令檔（包括本檔案），確認無過時引用（如僅限於代理工具名稱 CLAUDE），如需通用指引則修正。
   - 閱讀任何執行時指引文件（例如：`README.md`、`docs/quickstart.md`，或代理工具專屬指引檔），更新對已變更原則的引用。

5. 產出同步影響報告（Sync Impact Report）（更新後於憲章檔案頂部以 HTML 註解加註）：
   - 版本變更：舊版 → 新版
   - 已修改原則清單（如有更名，列出舊標題 → 新標題）
   - 新增章節
   - 移除章節
   - 需更新之範本（✅ 已更新 / ⚠ 待處理），附檔案路徑
   - 若有占位符刻意延後，請列於後續 TODO

6. 輸出前驗證：
   - 不得有未說明的中括號占位符殘留。
   - 版本行需與報告一致。
   - 日期採用 ISO 格式 YYYY-MM-DD。
   - 原則需具宣告性、可測試，避免模糊語言（如 "should" → 視情況改為 MUST/SHOULD 並說明理由）。

7. 將完成的憲章覆寫寫回 `/memory/constitution.md`。

8. 向用戶輸出最終摘要，內容包括：
   - 新版本及升級理由。
   - 任何需人工後續處理的檔案。
   - 建議的 commit 訊息（如 `docs: amend constitution to vX.Y.Z (principle additions + governance update)`）。

格式與風格要求：
- Markdown 標題層級必須與範本完全一致（不得升降標題層級）。
- 長篇理由請適度換行以提升可讀性（理想上 <100 字元），但避免為換行而破壞語意。
- 各章節間僅留一個空白行。
- 不得有多餘尾端空白。

若用戶僅提供部分更新（如僅修訂一條原則），仍須執行驗證與版本決策步驟。

若關鍵資訊缺失（如採認日期確實未知），請插入 `TODO(<FIELD_NAME>): explanation`，並於同步影響報告的延後項目中列出。

請勿建立新範本，務必僅操作現有 `/memory/constitution.md` 檔案。
