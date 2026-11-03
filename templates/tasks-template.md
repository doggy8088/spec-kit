---

description: "功能實作的任務清單範本"
---

# 任務：[FEATURE NAME]

**輸入**：設計文件，來自 `/specs/[###-feature-name]/`

**前置條件**：plan.md（必要）、spec.md（使用者故事必要）、research.md、data-model.md、contracts/

**測試**：以下範例包含測試任務。測試為選擇性——只有在功能規格中明確要求時才加入。

**組織方式**：任務依使用者故事分組，讓每個故事都能獨立實作與測試。

## 格式：`[ID] [P?] [Story] Description`

- **[P]**：可平行執行（不同檔案、沒有相依關係）
- **[Story]**：這個任務屬於哪個使用者故事（例如 US1、US2、US3）
- 在說明中加入確切的檔案路徑

## 路徑慣例

- **單一專案**：`src/`、`tests/` 位於儲存庫根目錄
- **Web 應用程式**：`backend/src/`、`frontend/src/`
- **行動應用程式**：`api/src/`、`ios/src/` 或 `android/src/`
- 以下路徑以單一專案為前提——請依 plan.md 的結構調整

<!--
  ============================================================================
  重要：以下任務僅為範例任務，僅供說明之用。

  __SPECKIT_COMMAND_TASKS__ 命令必須將這些任務換成依據下列來源產生的實際任務：
  - spec.md 中的使用者故事（及其優先順序 P1、P2、P3……）
  - plan.md 中的功能需求
  - data-model.md 中的實體
  - contracts/ 中的端點

  任務必須依使用者故事組織，讓每個故事都能：
  - 獨立實作
  - 獨立測試
  - 作為 MVP 增量交付

  產生的 tasks.md 檔案中，不要保留這些範例任務。
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**目的**：專案初始化與基本結構

- [ ] T001 依實作計畫建立專案結構
- [ ] T002 以 [framework] 相依套件初始化 [language] 專案
- [ ] T003 [P] 設定程式碼檢查與格式化工具

---

## Phase 2: Foundational (Blocking Prerequisites)

**目的**：在任何使用者故事開始實作之前，必須先完成的核心基礎設施

**⚠️ 關鍵**：這個階段完成之前，不得開始任何使用者故事的工作

基礎任務範例（請依專案調整）：

- [ ] T004 建立資料庫結構描述與遷移框架
- [ ] T005 [P] 實作身分驗證／授權框架
- [ ] T006 [P] 建立 API 路由與中介軟體結構
- [ ] T007 建立所有故事都相依的基礎模型／實體
- [ ] T008 設定錯誤處理與記錄基礎設施
- [ ] T009 建立環境設定管理

**檢查點**：基礎就緒——使用者故事的實作現在可以平行開始

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**目標**：[Brief description of what this story delivers]

**獨立測試**：[How to verify this story works on its own]

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **注意：先寫這些測試，確保它們在實作之前失敗**

- [ ] T010 [P] [US1] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T011 [P] [US1] Integration test for [user journey] in tests/integration/test_[name].py

### User Story 1 的實作

- [ ] T012 [P] [US1] Create [Entity1] model in src/models/[entity1].py
- [ ] T013 [P] [US1] Create [Entity2] model in src/models/[entity2].py
- [ ] T014 [US1] Implement [Service] in src/services/[service].py (depends on T012, T013)
- [ ] T015 [US1] Implement [endpoint/feature] in src/[location]/[file].py
- [ ] T016 [US1] 加入驗證與錯誤處理
- [ ] T017 [US1] 為使用者故事 1 的操作加入記錄

**檢查點**：到這裡為止，User Story 1 應已功能完整，且可獨立測試

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**目標**：[Brief description of what this story delivers]

**獨立測試**：[How to verify this story works on its own]

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T018 [P] [US2] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T019 [P] [US2] Integration test for [user journey] in tests/integration/test_[name].py

### User Story 2 的實作

- [ ] T020 [P] [US2] Create [Entity] model in src/models/[entity].py
- [ ] T021 [US2] Implement [Service] in src/services/[service].py
- [ ] T022 [US2] Implement [endpoint/feature] in src/[location]/[file].py
- [ ] T023 [US2] Integrate with User Story 1 components (if needed)

**檢查點**：到這裡為止，User Stories 1 與 2 應都能獨立運作

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**目標**：[Brief description of what this story delivers]

**獨立測試**：[How to verify this story works on its own]

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T024 [P] [US3] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T025 [P] [US3] Integration test for [user journey] in tests/integration/test_[name].py

### User Story 3 的實作

- [ ] T026 [P] [US3] Create [Entity] model in src/models/[entity].py
- [ ] T027 [US3] Implement [Service] in src/services/[service].py
- [ ] T028 [US3] Implement [endpoint/feature] in src/[location]/[file].py

**檢查點**：所有使用者故事現在都應能獨立運作

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**目的**：影響多個使用者故事的改善

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX 程式碼清理與重構
- [ ] TXXX 跨所有故事的效能最佳化
- [ ] TXXX [P] Additional unit tests (if requested) in tests/unit/
- [ ] TXXX 安全性強化
- [ ] TXXX 執行 quickstart.md 驗證

---

## 相依關係與執行順序

### 階段相依關係

- **Setup (Phase 1)**：沒有相依關係——可以立即開始
- **Foundational (Phase 2)**：相依於 Setup 完成——會阻擋所有使用者故事
- **User Stories (Phase 3+)**：全都相依於 Foundational 階段完成
  - 之後使用者故事可以平行進行（若人力足夠）
  - 或依優先順序依序進行（P1 → P2 → P3）
- **Polish（最後階段）**：相依於所有預期的使用者故事完成

### 使用者故事相依關係

- **User Story 1 (P1)**：可在 Foundational（Phase 2）之後開始——不相依於其他故事
- **User Story 2 (P2)**：可在 Foundational（Phase 2）之後開始——可能與 US1 整合，但應可獨立測試
- **User Story 3 (P3)**：可在 Foundational（Phase 2）之後開始——可能與 US1/US2 整合，但應可獨立測試

### 每個使用者故事內部

- 測試（若有加入）必須先寫好，且在實作之前失敗
- 模型先於服務
- 服務先於端點
- 核心實作先於整合
- 故事完成後才移到下一個優先順序

### 平行機會

- 所有標記 [P] 的 Setup 任務都可以平行執行
- 所有標記 [P] 的 Foundational 任務都可以平行執行（在 Phase 2 內）
- Foundational 階段完成後，所有使用者故事都可以平行開始（若團隊人力允許）
- 使用者故事中所有標記 [P] 的測試都可以平行執行
- 故事內標記 [P] 的模型可以平行執行
- 不同的使用者故事可由不同的團隊成員平行處理

---

## 平行範例：User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
```

---

## 實作策略

### MVP 優先（只做 User Story 1）

1. 完成 Phase 1：Setup
2. 完成 Phase 2：Foundational（關鍵——會阻擋所有故事）
3. 完成 Phase 3：User Story 1
4. **停下來驗證**：獨立測試 User Story 1
5. 就緒後部署／展示

### 增量交付

1. 完成 Setup + Foundational → 基礎就緒
2. 加入 User Story 1 → 獨立測試 → 部署／展示（MVP！）
3. 加入 User Story 2 → 獨立測試 → 部署／展示
4. 加入 User Story 3 → 獨立測試 → 部署／展示
5. 每個故事都增加價值，且不破壞先前的故事

### 平行團隊策略

有多位開發者時：

1. 團隊一起完成 Setup + Foundational
2. Foundational 完成後：
   - 開發者 A：User Story 1
   - 開發者 B：User Story 2
   - 開發者 C：User Story 3
3. 各故事獨立完成與整合

---

## 備註

- [P] 任務 = 不同檔案、沒有相依關係
- [Story] 標籤將任務對應到特定使用者故事，方便追溯
- 每個使用者故事都應可獨立完成與測試
- 實作之前先確認測試失敗
- 每完成一個任務或一組邏輯相關的任務就提交一次
- 在任何檢查點停下來，獨立驗證故事
- 避免：含糊的任務、同一檔案衝突、破壞獨立性的跨故事相依關係
