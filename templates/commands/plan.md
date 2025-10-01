---
description: 使用計劃模板執行實作規劃工作流程，以產生設計產物。
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
---

你收到的使用者輸入可以直接由代理（agent）提供，或作為命令參數傳入——在繼續提示前，你**必須**先考慮這些輸入（如果不為空）。

使用者輸入：

$ARGUMENTS

根據作為參數提供的實作細節，請執行以下步驟：

1. 從儲存庫根目錄執行 `{SCRIPT}`，並解析 JSON 以取得 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。所有後續的檔案路徑必須為絕對路徑。
   - 在繼續之前，請檢查 FEATURE_SPEC 是否包含有至少一個 `Session` 子標題的 `## Clarifications` 區段。如果缺少，或明顯存在模糊之處（如形容詞不明確、關鍵選擇未決），請**暫停**並指示使用者先執行 `/clarify` 以減少返工。僅在以下情況下繼續進行：（a）已有明確釐清，或（b）使用者明確要求略過釐清（例如「直接執行，不需釐清」）。請勿自行捏造釐清內容。

2. 閱讀並分析功能規格，以理解：
   - 功能需求與使用者故事
   - 功能性與非功能性需求
   - 成功標準與驗收標準
   - 任何提及的技術限制或相依性

3. 閱讀 `/memory/constitution.md` 的憲章內容，了解憲章要求。

4. 執行實作計劃模板：
   - 載入 `/templates/plan-template.md`（已複製到 IMPL_PLAN 路徑）
   - 將 Input 路徑設為 FEATURE_SPEC
   - 執行主流程（Execution Flow）步驟 1-9
   - 此模板為自包含且可執行
   - 請依照指定的錯誤處理與檢查機制執行
   - 依模板指引，在 $SPECS_DIR 產生設計產物：
     * 第 0 階段產生 research.md
     * 第 1 階段產生 data-model.md、contracts/、quickstart.md
     * 第 2 階段產生 tasks.md
   - 將使用者從參數提供的細節納入 Technical Context: {ARGS}
   - 每完成一個階段，請更新進度追蹤（Progress Tracking）

5. 驗證執行是否完成：
   - 檢查進度追蹤，確認所有階段均已完成
   - 確認所有必要產物均已產生
   - 確認執行過程中無 ERROR 狀態

6. 回報結果，包括分支名稱、檔案路徑與產生的設計產物。

所有檔案操作請務必使用以儲存庫根目錄為基準的絕對路徑，以避免路徑問題。
