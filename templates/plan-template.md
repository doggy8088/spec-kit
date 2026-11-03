# 實作計畫：[FEATURE]

**分支**：`[###-feature-name]` | **日期**：[DATE] | **規格**：[link]

**輸入**：功能規格，來自 `/specs/[###-feature-name]/spec.md`

**注意**：這份範本由 `__SPECKIT_COMMAND_PLAN__` 命令填入；其定義說明了執行工作流程。

## 摘要

[Extract from feature spec: primary requirement + technical approach from research]

## 技術背景

<!--
  需要處理：將這一節的內容換成專案的技術細節。
  這裡的結構僅供參考，用來引導反覆迭代的過程。
-->

**語言／版本**：[e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]

**主要相依套件**：[e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]

**儲存**：[if applicable, e.g., PostgreSQL, CoreData, files or N/A]

**測試**：[e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]

**目標平台**：[e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]

**專案類型**：[e.g., library/cli/web-service/mobile-app/compiler/desktop-app or NEEDS CLARIFICATION]

**效能目標**：[domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]

**限制**：[domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]

**規模／範圍**：[domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## 憲章檢查

*門檻：必須在 Phase 0 研究之前通過。Phase 1 設計之後再檢查一次。*

[Gates determined based on constitution file]

## 專案結構

### 文件（本功能）

```text
specs/[###-feature]/
├── plan.md              # This file (__SPECKIT_COMMAND_PLAN__ command output)
├── research.md          # Phase 0 output (__SPECKIT_COMMAND_PLAN__ command)
├── data-model.md        # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command)
├── quickstart.md        # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command)
├── contracts/           # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command)
└── tasks.md             # Phase 2 output (__SPECKIT_COMMAND_TASKS__ command - NOT created by __SPECKIT_COMMAND_PLAN__)
```

### 原始碼（儲存庫根目錄）
<!--
  需要處理：將下方的佔位目錄樹換成本功能的實際版面配置。
  刪除未使用的選項，並以真實路徑展開所選的結構（例如 apps/admin、
  packages/something）。交付的計畫不得包含 Option 標籤。
-->

```text
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

**結構決策**：[Document the selected structure and reference the real
directories captured above]

## 複雜度追蹤

> **只有在憲章檢查出現必須說明的違規時才填寫**

| 違規 | 為何需要 | 為何拒絕更簡單的替代方案 |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
