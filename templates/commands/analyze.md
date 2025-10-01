---
description: 在任務產生後，對 spec.md、plan.md 與 tasks.md 進行非破壞性的跨產物一致性與品質分析。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
---

使用者輸入可以直接由代理程式提供，或作為命令參數傳入——你在執行提示前**必須**考慮該輸入（若不為空）。

使用者輸入：

$ARGUMENTS

目標：在實作前，識別三大核心產物（`spec.md`、`plan.md`、`tasks.md`）中的不一致、重複、模糊及規格不足項目。本指令**僅能**於`/tasks`已成功產出完整`tasks.md`後執行。

嚴格唯讀：**請勿**修改任何檔案。請輸出結構化分析報告。可選擇性提供修正建議方案（使用者必須明確同意後，才會手動執行後續編輯指令）。

憲章權威：專案憲章（`/memory/constitution.md`）在本分析範圍內**不可協商**。若有與憲章衝突，視為「嚴重」等級（CRITICAL），必須調整規格、計畫或任務——不得稀釋、重新詮釋或靜默忽略原則。若需修改原則，必須在`/analyze`以外，另行明確進行憲章更新。

執行步驟：

1. 從 repo 根目錄執行`{SCRIPT}`一次，並解析 JSON 以取得 FEATURE_DIR 與 AVAILABLE_DOCS。推導出絕對路徑：
   - SPEC = FEATURE_DIR/spec.md
   - PLAN = FEATURE_DIR/plan.md
   - TASKS = FEATURE_DIR/tasks.md
   若缺少任何必要檔案，請中止並顯示錯誤訊息（指示使用者執行缺失的前置指令）。

2. 載入產物：
   - 解析 spec.md 各區段：Overview/Context、Functional Requirements、Non-Functional Requirements、User Stories、Edge Cases（如有）。
   - 解析 plan.md：Architecture/stack 選擇、Data Model 參考、Phases、Technical constraints。
   - 解析 tasks.md：Task ID、描述、階段分組、平行標記 [P]、參考檔案路徑。
   - 載入憲章`/memory/constitution.md`以進行原則驗證。

3. 建立內部語意模型：
   - 需求清單：每個功能性與非功能性需求，並給予穩定鍵值（依命令式片語產生 slug，例如 "User can upload file" -> `user-can-upload-file`）。
   - 使用者故事／行動清單。
   - 任務覆蓋對應：將每個任務對應到一個或多個需求或故事（可依關鍵字／明確參照模式如 ID 或關鍵片語推斷）。
   - 憲章規則集：擷取原則名稱及所有 MUST/SHOULD 規範性敘述。

4. 啟動檢測流程：
   A. 重複檢測：
      - 識別近似重複的需求。標記語意較差者以利合併。
   B. 模糊檢測：
      - 標記缺乏可衡量標準的模糊形容詞（如 fast、scalable、secure、intuitive、robust）。
      - 標記未解決的占位符（如 TODO、TKTK、???、<placeholder> 等）。
   C. 規格不足：
      - 僅有動詞但缺少受詞或可衡量結果的需求。
      - 未對齊驗收標準的使用者故事。
      - 任務參考了在 spec/plan 未定義的檔案或元件。
   D. 憲章對齊：
      - 任何與 MUST 原則衝突的需求或計畫元素。
      - 憲章要求但缺失的區段或品質檢查點。
   E. 覆蓋缺口：
      - 沒有任何任務對應的需求。
      - 沒有對應需求／故事的任務。
      - 非功能性需求未反映於任務（如效能、安全性）。
   F. 不一致性：
      - 術語漂移（同一概念於不同檔案名稱不一）。
      - plan 參考的資料實體未於 spec 定義（或反之）。
      - 任務順序矛盾（如整合任務早於基礎設置，卻無依賴說明）。
      - 需求互相衝突（如一條要求使用 Next.js，另一條要求框架為 Vue）。

5. 嚴重性分級準則：
   - 嚴重（CRITICAL）：違反憲章 MUST、缺少核心規格產物，或阻礙基本功能的零覆蓋需求。
   - 高（HIGH）：重複或衝突需求、模糊的安全／效能屬性、無法測試的驗收標準。
   - 中（MEDIUM）：術語漂移、缺少非功能性任務覆蓋、規格不足的邊界案例。
   - 低（LOW）：風格／措辭優化、對執行順序無影響的小幅冗餘。

6. 輸出 Markdown 格式報告（不寫入檔案），包含以下區段：

   ### 規格分析報告
   | ID | 類別 | 嚴重性 | 位置 | 摘要 | 建議 |
   |----|------|--------|------|------|------|
   | A1 | 重複 | HIGH | spec.md:L120-134 | 兩條相似需求 ... | 合併語句，保留較清晰版本 |
   （每項發現新增一列；ID 以類別首字母為前綴並保持穩定。）

   其他子區段：
   - 覆蓋摘要表：
     | 需求鍵值 | 有任務？ | 任務 ID | 備註 |
   - 憲章對齊問題（如有）
   - 未對應任務（如有）
   - 指標統計：
     * 總需求數
     * 總任務數
     * 覆蓋率（有 >=1 任務的需求）
     * 模糊項目數
     * 重複項目數
     * 嚴重問題數

7. 報告結尾，輸出簡明「後續行動」區塊：
   - 若有嚴重（CRITICAL）問題：建議於`/implement`前解決。
   - 若僅有低／中等級：可繼續進行，但提供改進建議。
   - 明確建議指令：例如「執行 /specify 進行細化」、「執行 /plan 調整架構」、「手動編輯 tasks.md，補足 'performance-metrics' 覆蓋」。

8. 詢問使用者：「需要我針對前 N 項問題，建議具體修正編輯內容嗎？」（**請勿**自動套用。）

行為規則：
- **絕不**修改檔案。
- **絕不**臆造不存在的區段——如缺失，請如實回報。
- 保持發現結果可重現：若內容未變，重跑應產生一致的 ID 與統計。
- 主表格最多顯示 50 項發現；其餘請彙總於附註。
- 若無任何問題，請輸出成功報告，附覆蓋統計及繼續建議。

Context: {ARGS}
