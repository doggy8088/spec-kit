---
description: "功能實作的任務清單範本"
---

# 任務: [FEATURE NAME]

**輸入**：來自 `/specs/[###-feature-name]/` 的設計文件  
**前置需求**：plan.md（必填）、spec.md（若有 user stories 必填）、research.md、data-model.md、contracts/

**測試**：下方範例包含測試任務。測試為「選填」——僅在功能規格明確要求時才需包含。

**組織方式**：任務依 user story 分組，以便每個 user story 可獨立實作與測試。

## 格式: `[ID] [P?] [Story] Description`
- **[P]**：可平行執行（不同檔案、無相依性）
- **[Story]**：此任務所屬的 user story（如 US1、US2、US3）
- 描述中需包含精確的檔案路徑

## 路徑慣例
- **單一專案**：`src/`、`tests/` 於 repository 根目錄
- **Web app**：`backend/src/`、`frontend/src/`
- **Mobile**：`api/src/`、`ios/src/` 或 `android/src/`
- 下方所示路徑預設為單一專案——請依 plan.md 結構調整

<!-- 
  ============================================================================
  重要說明：下方任務僅為「範例任務」，僅供說明用途。

  /speckit.tasks 指令必須根據下列來源產生實際任務，取代這些範例：
  - spec.md 中的 user stories（含其優先順序 P1、P2、P3...）
  - plan.md 的功能需求
  - data-model.md 的實體
  - contracts/ 的 endpoint

  任務必須依 user story 分組，以確保每個 story 可：
  - 獨立實作
  - 獨立測試
  - 以 MVP 增量方式交付

  請勿在產生的 tasks.md 文件中保留這些範例任務。
  ============================================================================
-->

## 階段 1：初始化（共用基礎設施）

**目的**：專案初始化與基本結構建立

- [ ] T001 依實作計畫建立專案結構
- [ ] T002 初始化 [language] 專案並安裝 [framework] 相依套件
- [ ] T003 [P] 設定 lint 與格式化工具

---

## 階段 2：基礎建設（阻斷性前置）

**目的**：所有 user story 開始前必須完成的核心基礎設施

**⚠️ 關鍵**：本階段未完成前，禁止開始 user story 實作

基礎建設任務範例（請依專案調整）：

- [ ] T004 設定資料庫 schema 與 migration framework
- [ ] T005 [P] 實作驗證/授權（authentication/authorization）框架
- [ ] T006 [P] 設定 API 路由與 middleware 結構
- [ ] T007 建立所有 story 依賴的基礎 models/entities
- [ ] T008 設定錯誤處理與日誌基礎設施
- [ ] T009 設定環境參數管理

**檢查點**：基礎建設完成——可開始平行實作 user story

---

## 階段 3：User Story 1 - [標題] (Priority: P1) 🎯 MVP

**目標**：[簡述此 story 的交付內容]

**獨立測試**：[如何單獨驗證此 story 是否運作]

### User Story 1 測試（選填——僅在需求明確要求時）⚠️

**注意：請先撰寫這些測試，並確保在實作前測試會失敗**

- [ ] T010 [P] [US1] 為 [endpoint] 撰寫契約測試於 tests/contract/test_[name].py
- [ ] T011 [P] [US1] 為 [user journey] 撰寫整合測試於 tests/integration/test_[name].py

### User Story 1 實作

- [ ] T012 [P] [US1] 在 src/models/[entity1].py 建立 [Entity1] model
- [ ] T013 [P] [US1] 在 src/models/[entity2].py 建立 [Entity2] model
- [ ] T014 [US1] 在 src/services/[service].py 實作 [Service]（依賴 T012、T013）
- [ ] T015 [US1] 在 src/[location]/[file].py 實作 [endpoint/feature]
- [ ] T016 [US1] 加入驗證與錯誤處理
- [ ] T017 [US1] 為 User Story 1 操作加入日誌紀錄

**檢查點**：此時 User Story 1 應可獨立完整運作並測試

---

## 階段 4：User Story 2 - [標題] (Priority: P2)

**目標**：[簡述此 story 的交付內容]

**獨立測試**：[如何單獨驗證此 story 是否運作]

### User Story 2 測試（選填——僅在需求明確要求時）⚠️

- [ ] T018 [P] [US2] 為 [endpoint] 撰寫契約測試於 tests/contract/test_[name].py
- [ ] T019 [P] [US2] 為 [user journey] 撰寫整合測試於 tests/integration/test_[name].py

### User Story 2 實作

- [ ] T020 [P] [US2] 在 src/models/[entity].py 建立 [Entity] model
- [ ] T021 [US2] 在 src/services/[service].py 實作 [Service]
- [ ] T022 [US2] 在 src/[location]/[file].py 實作 [endpoint/feature]
- [ ] T023 [US2] 與 User Story 1 元件整合（如有需要）

**檢查點**：此時 User Story 1 與 2 均應可獨立運作

---

## 階段 5：User Story 3 - [標題] (Priority: P3)

**目標**：[簡述此 story 的交付內容]

**獨立測試**：[如何單獨驗證此 story 是否運作]

### User Story 3 測試（選填——僅在需求明確要求時）⚠️

- [ ] T024 [P] [US3] 為 [endpoint] 撰寫契約測試於 tests/contract/test_[name].py
- [ ] T025 [P] [US3] 為 [user journey] 撰寫整合測試於 tests/integration/test_[name].py

### User Story 3 實作

- [ ] T026 [P] [US3] 在 src/models/[entity].py 建立 [Entity] model
- [ ] T027 [US3] 在 src/services/[service].py 實作 [Service]
- [ ] T028 [US3] 在 src/[location]/[file].py 實作 [endpoint/feature]

**檢查點**：所有 user story 均應可獨立運作

---

[如有更多 user story，請依此模式新增階段]

---

## 階段 N：優化與橫向議題

**目的**：影響多個 user story 的改進事項

- [ ] TXXX [P] 更新文件於 docs/
- [ ] TXXX 程式碼重構與清理
- [ ] TXXX 全體效能優化
- [ ] TXXX [P] 額外單元測試（如有需求）於 tests/unit/
- [ ] TXXX 安全性強化
- [ ] TXXX 執行 quickstart.md 驗證

---

## 相依性與執行順序

### 階段相依性

- **初始化（階段 1）**：無相依性——可立即開始
- **基礎建設（階段 2）**：依賴初始化完成——阻斷所有 user story
- **User Story（階段 3+）**：皆依賴基礎建設完成
  - user story 可平行進行（若人力允許）
  - 或依優先順序（P1 → P2 → P3）依序進行
- **優化（最終階段）**：依賴所有目標 user story 完成

### User Story 相依性

- **User Story 1（P1）**：基礎建設（階段 2）完成後可開始——不依賴其他 story
- **User Story 2（P2）**：基礎建設（階段 2）完成後可開始——可與 User Story 1 整合，但應可獨立測試
- **User Story 3（P3）**：基礎建設（階段 2）完成後可開始——可與 User Story 1/User Story 2 整合，但應可獨立測試

### 每個 User Story 內部

- 測試（如有）必須先撰寫，且在實作前應為失敗狀態
- 先建立 model，再實作 service
- 先完成 service，再實作 endpoint
- 先完成核心實作，再進行整合
- 完成一個 story 再進入下一優先順序

### 可平行處理項目

- 所有標註 [P] 的初始化任務可平行執行
- 所有標註 [P] 的基礎建設任務可平行執行（於階段 2 內）
- 基礎建設完成後，所有 user story 可平行展開（若團隊人力允許）
- 同一 user story 內所有標註 [P] 的測試可平行執行
- 同一 story 內標註 [P] 的 model 可平行開發
- 不同 user story 可由不同成員平行進行

---

## 平行處理範例：User Story 1

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

### MVP 優先（僅 User Story 1）

1. 完成階段 1：環境設置
2. 完成階段 2：基礎建設（**關鍵**－阻擋所有 user story）
3. 完成階段 3：User Story 1
4. **停止並驗證**：獨立測試 User Story 1
5. 若已準備好則部署／展示

### 漸進式交付

1. 完成環境設置 + 基礎建設 → 基礎就緒
2. 加入 User Story 1 → 獨立測試 → 部署／展示（MVP！）
3. 加入 User Story 2 → 獨立測試 → 部署／展示
4. 加入 User Story 3 → 獨立測試 → 部署／展示
5. 每個 user story 都能在不破壞前一個 story 的情況下增加價值

### 團隊並行策略

多人開發時：

1. 團隊共同完成環境設置 + 基礎建設
2. 當基礎建設完成後：
   - 開發者 A：User Story 1
   - 開發者 B：User Story 2
   - 開發者 C：User Story 3
3. 各 story 可獨立完成並整合

---

## 備註

- [P] 任務＝不同檔案，無相依性 (dependency)
- [Story] 標籤可將任務對應至特定 user story 以便追蹤
- 每個 user story 應能獨立完成並測試
- 實作前請先驗證測試確實失敗
- 每完成一個任務或邏輯群組即提交 (commit)
- 可於任何檢查點 (checkpoint) 停止並獨立驗證 story
- 避免：模糊任務、同檔案衝突、跨 story 相依性導致無法獨立

---


