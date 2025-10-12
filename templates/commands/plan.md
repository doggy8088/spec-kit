---
description: 使用計劃模板（plan template）執行實作規劃工作流程，以產生設計產物。
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
agent_scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續執行前，**必須**考慮用戶輸入（若非空）。

## 大綱

1. **設定**：於 repository 根目錄執行 `{SCRIPT}`，並解析 JSON 以取得 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。對於參數中如 "I'm Groot" 這類帶有單引號的字串，請使用跳脫語法：例如 'I'\''m Groot'（或若可行則使用雙引號："I'm Groot"）。

2. **載入上下文**：讀取 FEATURE_SPEC 與 `/memory/constitution.md`。載入已複製的 IMPL_PLAN 範本。

3. **執行計畫工作流程**：依照 IMPL_PLAN 範本的結構進行：
   - 填寫 Technical Context（技術上下文，未知處標記為 "NEEDS CLARIFICATION"）
   - 從專案憲章填寫 Constitution Check（專案憲章檢查）區段
   - 評估 gates（若有違規且無正當理由則報 ERROR）
   - 第 0 階段：產生 research.md（解決所有 NEEDS CLARIFICATION）
   - 第 1 階段：產生 data-model.md、contracts/、quickstart.md
   - 第 1 階段：執行 agent 腳本以更新 agent context
   - 設計後重新評估 Constitution Check

4. **停止並回報**：指令於第 2 階段規劃後結束。回報分支、IMPL_PLAN 路徑及產生的產物。

## 階段說明

### 第 0 階段：大綱與研究

1. **從上述 Technical Context 擷取未知項目**：
   - 對每個 NEEDS CLARIFICATION → 產生 research task（研究任務）
   - 對每個相依性（dependency）→ 產生 best practices task（最佳實踐任務）
   - 對每個整合（integration）→ 產生 patterns task（模式任務）

2. **產生並派發 research agents（研究代理工具）**：
   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. 在 `research.md` **彙整發現結果**，格式如下：
   - 決策： [選擇了什麼]
   - 理由： [為何選擇]
   - 考慮過的替代方案： [還評估了哪些]

**輸出**：research.md，所有 NEEDS CLARIFICATION 均已解決

### 階段 1：設計與契約

**前置條件**： `research.md` 完成

1. **從功能規格說明中擷取 entity** → `data-model.md`：
   - entity 名稱、欄位、關聯
   - 從需求中取得的驗證規則
   - 若適用，則包含狀態轉換

2. **根據功能性需求產生 API 契約**：
   - 每個使用者動作對應一個 endpoint
   - 採用標準 REST/GraphQL 模式
   - 將 OpenAPI/GraphQL schema 輸出到 `/contracts/`

3. **Agent 上下文更新**：
   - 執行 `{AGENT_SCRIPT}`
   - 這些腳本會偵測目前使用的 AI agent
   - 更新對應的 agent 專屬上下文檔案
   - 僅新增本次計畫中使用的新技術
   - 保留標記區間內的手動新增內容

**輸出**：data-model.md、/contracts/*、quickstart.md、agent 專屬檔案

## 主要規則

- 使用絕對路徑
- 若檢查點失敗或釐清未解決則顯示 ERROR
