---
description: 使用計劃模板（plan template）執行實作規劃工作流程，以產生設計產物。
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
agent_scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

## 用戶輸入

```text
$ARGUMENTS
```

你在繼續進行前，**必須**考慮用戶輸入（若非空）。

## 大綱

1. **設定**：從 repo 根目錄執行 `{SCRIPT}`，並解析 JSON 以取得 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。對於參數中如 "I'm Groot" 這類含有單引號的內容，請使用跳脫語法：例如 `'I'\''m Groot'`（或若可行則用雙引號："I'm Groot"）。

2. **載入上下文**：讀取 FEATURE_SPEC 與 `/memory/constitution.md`。載入 IMPL_PLAN 範本（已經複製好）。

3. **執行規劃工作流程**：依照 IMPL_PLAN 範本的結構進行：
   - 填寫技術上下文（Technical Context）（未知處標記為 "NEEDS CLARIFICATION"）
   - 從專案憲章填寫 Constitution Check（專案憲章檢查）區段
   - 評估 gates（如有違規且無正當理由則報錯 ERROR）
   - Phase 0：產生 research.md（解決所有 NEEDS CLARIFICATION）
   - Phase 1：產生 data-model.md、contracts/、quickstart.md
   - Phase 1：執行 agent 腳本以更新 agent context
   - 設計後重新評估 Constitution Check

4. **停止並回報**：指令於 Phase 2 規劃結束後終止。回報分支（branch）、IMPL_PLAN 路徑，以及產生的產物。

## 各階段說明

### Phase 0：大綱與研究

1. **從上述技術上下文（Technical Context）中擷取未知項目**：
   - 對每個 NEEDS CLARIFICATION → 產生 research task（研究任務）
   - 對每個相依性（dependency）→ 產生 best practices task（最佳實踐任務）
   - 對每個整合（integration）→ 產生 patterns task（模式任務）

2. **產生並派發 research agents（研究代理）**：

   ```text
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **在 `research.md` 統整發現**，格式如下：
   - 決策（Decision）：[所選擇的內容]
   - 理由（Rationale）：[選擇原因]
   - 考慮過的替代方案（Alternatives considered）：[評估過的其他選項]

**產出**：research.md，所有 NEEDS CLARIFICATION 已解決

### 階段 1：設計與契約

**前置作業：** `research.md` 完成

1. **從功能規格說明中抽取實體** → `data-model.md`：
   - 實體名稱、欄位、關聯
   - 來自需求的驗證規則
   - 若適用，則包含狀態轉換

2. **根據功能性需求產生 API 契約：**
   - 每個使用者動作對應一個 endpoint
   - 採用標準 REST/GraphQL 模式
   - 將 OpenAPI/GraphQL schema 輸出至 `/contracts/`

3. **AI agent 上下文更新：**
   - 執行 `{AGENT_SCRIPT}`
   - 這些腳本會偵測目前使用的 AI agent
   - 更新對應的 agent 專屬上下文檔案
   - 僅新增本次計畫中的新技術
   - 保留標記之間的人工新增內容

**產出**：data-model.md、/contracts/*、quickstart.md、agent 專屬檔案

## 主要規則

- 請使用絕對路徑
- 若檢查點失敗或有未解決的釐清事項，則回報 ERROR
