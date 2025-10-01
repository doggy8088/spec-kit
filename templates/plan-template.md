---
description: "功能開發的實作計畫範本"
scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

# 實作計畫：[FEATURE]

**分支**：`[###-feature-name]` | **日期**：[DATE] | **規格**：[link]  
**輸入**：來自`/specs/[###-feature-name]/spec.md`的功能規格

## 執行流程（/plan 指令範圍）
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from file system structure or context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Fill the Constitution Check section based on the content of the constitution document.
4. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
6. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, `GEMINI.md` for Gemini CLI, `QWEN.md` for Qwen Code or `AGENTS.md` for opencode).
7. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
9. STOP - Ready for /tasks command
```

**重要說明**：`/plan` 指令會在步驟 7 停止。第 2-4 階段將由其他指令執行：
- 第 2 階段：`/tasks` 指令會建立 `tasks.md`
- 第 3-4 階段：執行實作（可手動或透過工具進行）

## 摘要
【從功能規格中擷取：主要需求 + 研究所得的技術方案】

## 技術背景
**語言／版本**：【例如：Python 3.11、Swift 5.9、Rust 1.75 或 需進一步釐清】  
**主要相依套件**：【例如：FastAPI、UIKit、LLVM 或 需進一步釐清】  
**儲存方式**：【如適用，例如：PostgreSQL、CoreData、檔案 或 不適用】  
**測試方式**：【例如：pytest、XCTest、cargo test 或 需進一步釐清】  
**目標平台**：【例如：Linux server、iOS 15+、WASM 或 需進一步釐清】  
**專案類型**：【單一／Web／行動裝置 - 決定原始碼結構】  
**效能目標**：【領域相關，例如：1000 req/s、10k lines/sec、60 fps 或 需進一步釐清】  
**限制條件**：【領域相關，例如：<200ms p95、<100MB 記憶體、可離線運作 或 需進一步釐清】  
**規模／範圍**：【領域相關，例如：1 萬名用戶、100 萬行程式碼、50 個畫面 或 需進一步釐清】

## 憲章檢查
*門檻：必須通過後才能進行第 0 階段研究。第 1 階段設計後需再次檢查。*

【根據憲章檔案決定的門檻】

## 專案結構

### 文件（本功能）
```
specs/[###-feature]/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### 原始碼（repository 根目錄）
<!--
  請執行以下操作：將下方的佔位樹狀結構替換為此功能的實際專案結構。
  刪除未使用的選項，並以實際路徑（例如：apps/admin、packages/something）擴充所選結構。
  交付的計畫中不得包含 Option 標籤。
-->
```
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**結構決策**：［記錄所選結構，並參考上方實際目錄］

## 階段 0：大綱與研究
1. **從上方技術背景中萃取未知事項**：
   - 對於每個 NEEDS CLARIFICATION → 研究任務
   - 對於每個 dependency（相依性）→ 最佳實踐任務
   - 對於每個 integration（整合）→ 模式任務

2. **產生並分派研究代理人**：
   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **彙整發現結果**於`research.md`，格式如下：
   - 決策： [所選擇的內容]
   - 理由： [選擇原因]
   - 考慮過的替代方案： [評估過的其他選項]

**產出**：research.md，所有 NEEDS CLARIFICATION 已解決

## 階段 1：設計與契約（Design & Contracts）
*前置條件：research.md 完成*

1. **從功能規格中萃取實體** → `data-model.md`：
   - 實體名稱、欄位、關聯
   - 來自需求的驗證規則
   - 若適用，包含狀態轉換

2. **根據功能需求產生 API 契約**：
   - 每個使用者動作 → 一個 endpoint
   - 採用標準 REST/GraphQL 模式
   - 輸出 OpenAPI/GraphQL schema 至`/contracts/`

3. **根據契約產生契約測試**：
   - 每個 endpoint 一個測試檔案
   - 驗證 request/response schema
   - 測試必須失敗（尚未有實作）

4. **從使用者故事萃取測試情境**：
   - 每個故事 → 一個整合測試情境
   - Quickstart 測試 = 故事驗證步驟

5. **逐步更新 agent 檔案**（O(1) 操作）：
   - 執行`{SCRIPT}`
     **重要**：請完全依照上述指定方式執行，不要增減任何參數。
   - 若已存在：只新增本次計畫中的新技術
   - 保留標記間的手動新增內容
   - 更新最近變更（保留最後 3 筆）
   - 為提升 token 效率，保持 150 行以內
   - 輸出至 repository 根目錄

**產出**：data-model.md、/contracts/*、失敗測試、quickstart.md、agent 專用檔案

## 階段 2：任務規劃方法（Task Planning Approach）
*本節說明 /tasks 指令將執行的內容——/plan 階段請勿執行*

**任務產生策略**：
- 載入`.specify/templates/tasks-template.md`作為基礎
- 根據階段 1 的設計文件（契約、資料模型、quickstart）產生任務
- 每個契約 → 一個契約測試任務 [P]
- 每個實體 → 一個模型建立任務 [P]
- 每個使用者故事 → 一個整合測試任務
- 產生讓測試通過的實作任務

**排序策略**：
- TDD 順序：測試優先於實作
- 依賴順序：模型優先於服務，服務優先於 UI
- 標記 [P] 代表可平行執行（獨立檔案）

**預估產出**：tasks.md 中 25-30 個編號且有順序的任務

**重要**：本階段由 /tasks 指令執行，非 /plan

## 階段 3+：後續實作（Future Implementation）
*這些階段超出 /plan 指令的範圍*

**階段 3**：任務執行（/tasks 指令產生 tasks.md）  
**階段 4**：實作（依據 tasks.md 及憲法原則執行）  
**階段 5**：驗證（執行測試、quickstart.md、效能驗證）

## 複雜度追蹤（Complexity Tracking）
*僅當憲法檢查有違規且需說明時填寫*

| 違規項目 | 為何需要 | 拒絕更簡單替代方案的原因 |
|-----------|------------|-------------------------------------|
| [例如：第 4 個專案] | [目前需求] | [為何 3 個專案不夠] |
| [例如：Repository pattern] | [特定問題] | [為何直接 DB 存取不夠] |


## 進度追蹤（Progress Tracking）
*此清單於執行流程中持續更新*

**階段狀態**：
- [ ] 階段 0：研究完成（/plan 指令）
- [ ] 階段 1：設計完成（/plan 指令）
- [ ] 階段 2：任務規劃完成（/plan 指令——僅描述方法）
- [ ] 階段 3：任務產生（/tasks 指令）
- [ ] 階段 4：實作完成
- [ ] 階段 5：驗證通過

**關卡狀態**：
- [ ] 初始憲法檢查：通過
- [ ] 設計後憲法檢查：通過
- [ ] 所有 NEEDS CLARIFICATION 已解決
- [ ] 複雜度偏差已記錄

---
*根據 Constitution v2.1.1 - 詳見`/memory/constitution.md`*
