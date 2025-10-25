---
description: 根據互動式或提供的原則輸入，建立或更新專案憲章，確保所有相依的模板保持同步
---

## 用戶輸入

```text
$ARGUMENTS
```

你在繼續操作前，**必須**考慮用戶輸入（若非空）。

## 大綱

你正在更新位於 `/memory/constitution.md` 的專案憲章（project constitution）。此檔案為一個模板（TEMPLATE），內含以方括號標示的占位符（placeholder token）（例如：`[PROJECT_NAME]`、`[PRINCIPLE_1_NAME]`）。你的工作是：(a) 收集或推導具體值，(b) 精確填入模板，(c) 將任何修訂同步至所有相依產物。

請依照以下執行流程（Execution Flow）操作：

1. 載入現有的專案憲章模板（project constitution template），路徑為 `/memory/constitution.md`。
   - 辨識所有形式為 `[ALL_CAPS_IDENTIFIER]` 的占位符。
   **重要事項**：用戶可能需要的原則（principle）數量比模板中多或少。若指定數量，請遵循該數量，並依一般模板格式調整。你將相應更新文件內容。

2. 收集／推導占位符的具體值：
   - 若用戶輸入（對話內容）有提供值，則直接採用。
   - 否則，從現有 repository 上下文（如 README、文件、過往憲章版本（若有嵌入））推導。
   - 關於治理日期（governance dates）：`RATIFICATION_DATE` 為最初通過日期（original adoption date）（若不明請詢問或標記 TODO），`LAST_AMENDED_DATE` 若有變更則為今日，否則維持原值。
   - `CONSTITUTION_VERSION` 必須依語意化版本控制（Semantic Versioning）規則遞增：
     - MAJOR：治理或原則有向下不相容的移除或重新定義。
     - MINOR：新增原則／章節，或指引有實質擴充。
     - PATCH：釐清、措辭、錯字修正、非語意性微調。
   - 若版本號遞增類型不明確，請先提出推論理由再定案。

3. 擬定更新後的專案憲章內容：
   - 用具體文字取代所有占位符（除非專案選擇暫不定義的模板欄位，否則不得殘留方括號 token——如有保留，需明確說明理由）。
   - 保留標題階層，已被取代的註解可移除，除非仍具釐清指引價值。
   - 確保每個原則（Principle）章節：有簡明命名行、段落（或條列）說明不可協商規則，若理由不明顯則需明確說明。
   - 確保治理（Governance）章節列出修訂程序、版本管理政策、合規審查預期。

4. 一致性同步檢查清單（將先前檢查清單轉為主動驗證）：
   - 閱讀 `/templates/plan-template.md`，確保所有「專案憲章檢查（Constitution Check）」或規則與最新原則一致。
   - 閱讀 `/templates/spec-template.md`，檢查範疇／需求一致性——若憲章增減強制章節或限制，需同步更新。
   - 閱讀 `/templates/tasks-template.md`，確保任務分類反映新增或移除的原則驅動任務類型（如可觀察性、版本管理、測試紀律）。
   - 閱讀 `/templates/commands/*.md` 內每個指令檔（包括本檔），確認無過時引用（如僅限 agent 專屬名稱 CLAUDE，若需通用指引則移除）。
   - 閱讀所有執行時指引文件（如 `README.md`、`docs/quickstart.md`，或 agent 專屬指引檔如有），同步更新原則相關引用。

5. 產生同步影響報告（Sync Impact Report）（更新後於憲章檔案頂端以 HTML 註解形式前置）：
   - 版本變更：舊版 → 新版
   - 修改過的原則（若標題有更名則列出 舊標題 → 新標題）
   - 新增章節
   - 移除章節
   - 需同步更新的模板（✅ 已更新 / ⚠ 待處理），附檔案路徑
   - 若有占位符刻意延後，列為後續 TODO

6. 輸出前驗證：
   - 無未解釋的方括號 token 殘留。
   - 版本號行與報告一致。
   - 日期採用 ISO 格式 YYYY-MM-DD。
   - 原則必須具宣告性、可測試，且避免模糊語言（如「should」→ 視情況改為 MUST／SHOULD 並給出理由）。

7. 將完成的專案憲章覆寫寫回 `/memory/constitution.md`。

8. 向用戶輸出最終摘要，內容包含：
   - 新版本號與遞增理由。
   - 任何需人工後續處理的檔案。
   - 建議的 commit message（如 `docs: amend constitution to vX.Y.Z (principle additions + governance update)`）。

格式與風格要求：

- Markdown 標題層級必須與模板完全一致（不得升降標題層級）。
- 長的理由說明請適度換行以保持可讀性（理想上 <100 字元），但勿為換行而造成不自然斷句。
- 各章節間僅保留一個空白行。
- 不要有多餘的結尾空白。

若用戶僅提供部分更新（如只修訂一條原則），仍須執行驗證與版本決策步驟。

若關鍵資訊缺失（如通過日期確實不明），請插入 `TODO(<FIELD_NAME>): explanation`，並於同步影響報告（Sync Impact Report）之延後項目中列出。

請勿建立新模板；一律操作現有 `/memory/constitution.md` 檔案。
