---

description: "功能實作的任務清單範本"
---

# 任務清單： [FEATURE NAME]

**輸入**：來自 `/specs/[###-feature-name]/` 的設計文件  
**前置需求**：plan.md（必填）、spec.md（用於 user stories 時必填）、research.md、data-model.md、contracts/

**測試**：下方範例包含測試任務。測試為「選填」——僅在功能規格說明中明確要求時才需包含。

**組織方式**：任務依 user story 分組，以便每個 user story 可獨立實作與測試。

## 格式：`[ID] [P?] [Story] Description`

- **[P]**：可平行執行（不同檔案、無相依性）
- **[Story]**：此任務所屬的 user story（如 US1、US2、US3）
- 描述中請包含精確的檔案路徑

## 路徑命名慣例

- **單一專案**：`src/`、`tests/` 於 repository 根目錄
- **Web app**：`backend/src/`、`frontend/src/`
- **Mobile**：`api/src/`、`ios/src/` 或 `android/src/`
- 下方路徑皆假設為單一專案——請依 plan.md 結構調整

<!-- 
  ============================================================================
  重要說明：下方任務僅為「範例任務」，僅供說明用途。
  
  /speckit.tasks 指令「必須」根據下列內容產生實際任務，並取代這些範例：
  - 來自 spec.md 的 user stories（含其優先級 P1、P2、P3...）
  - 來自 plan.md 的功能需求
  - 來自 data-model.md 的實體
  - 來自 contracts/ 的 endpoint
  
  任務「必須」依 user story 分組，以便每個 story 可：
  - 獨立實作
  - 獨立測試
  - 作為 MVP（最小可行性產品）增量交付
  
  產生的 tasks.md 檔案「不得」保留這些範例任務。
  ============================================================================
-->

## 階段 1：專案初始化（共用基礎設施）

**目的**：專案初始化與基本結構建立

- [ ] T001 依實作計畫建立專案結構
- [ ] T002 以 [language] 初始化專案，並安裝 [framework] 相依套件
- [ ] T003 [P] 設定 lint 與格式化工具

---

## 階段 2：基礎建設（阻擋性前置需求）

**目的**：所有 user story 開始前「必須」完成的核心基礎設施

**⚠️ 關鍵**：此階段未完成前，不得開始任何 user story 的工作

基礎建設任務範例（請依專案實際情況調整）：

- [ ] T004 設定資料庫 schema 與 migration framework
- [ ] T005 [P] 實作驗證/授權框架
- [ ] T006 [P] 設定 API 路由與 middleware 結構
- [ ] T007 建立所有 story 依賴的基礎 models/entities
- [ ] T008 設定錯誤處理與日誌基礎設施
- [ ] T009 設定環境設定管理

**檢查點**：基礎設施就緒——user story 實作可平行展開

---

## 階段 3：User Story 1 - [標題] (Priority: P1) 🎯 MVP

**目標**：[簡述此 user story 所交付的內容]

**獨立測試**：[如何驗證此 story 能獨立運作]

### User Story 1 測試（選填——僅在有測試需求時）⚠️

> **注意：請「先」撰寫這些測試，並確保在實作前測試會失敗**

- [ ] T010 [P] [US1] 針對 [endpoint] 的契約測試，路徑：tests/contract/test_[name].py
- [ ] T011 [P] [US1] 針對 [user journey] 的整合測試，路徑：tests/integration/test_[name].py

### User Story 1 實作

- [ ] T012 [P] [US1] 建立 [Entity1] model，路徑：src/models/[entity1].py
- [ ] T013 [P] [US1] 建立 [Entity2] model，路徑：src/models/[entity2].py
- [ ] T014 [US1] 實作 [Service]，路徑：src/services/[service].py（依賴 T012、T013）
- [ ] T015 [US1] 實作 [endpoint/feature]，路徑：src/[location]/[file].py
- [ ] T016 [US1] 加入驗證與錯誤處理
- [ ] T017 [US1] 為 User Story 1 操作加入日誌

**檢查點**：此時 User Story 1 應可獨立完整運作並可獨立測試

---

## 階段 4：User Story 2 - [標題] (Priority: P2)

**目標**：[簡述此 user story 所交付的內容]

**獨立測試**：[如何驗證此 story 能獨立運作]

### User Story 2 測試（選填——僅在有測試需求時）⚠️

- [ ] T018 [P] [US2] 針對 [endpoint] 的契約測試，路徑：tests/contract/test_[name].py
- [ ] T019 [P] [US2] 針對 [user journey] 的整合測試，路徑：tests/integration/test_[name].py

### User Story 2 實作

- [ ] T020 [P] [US2] 建立 [Entity] model，路徑：src/models/[entity].py
- [ ] T021 [US2] 實作 [Service]，路徑：src/services/[service].py
- [ ] T022 [US2] 實作 [endpoint/feature]，路徑：src/[location]/[file].py
- [ ] T023 [US2] 與 User Story 1 元件整合（如有需要）

**檢查點**：此時 User Story 1 與 2 均應可獨立運作

---

## 階段 5：User Story 3 - [標題] (Priority: P3)

**目標**：[簡述此 user story 所交付的內容]

**獨立測試**：[如何驗證此 story 能獨立運作]

### User Story 3 測試（選填——僅在有測試需求時）⚠️

- [ ] T024 [P] [US3] 針對 [endpoint] 的契約測試，路徑：tests/contract/test_[name].py
- [ ] T025 [P] [US3] 針對 [user journey] 的整合測試，路徑：tests/integration/test_[name].py

### User Story 3 實作

- [ ] T026 [P] [US3] 建立 [Entity] model，路徑：src/models/[entity].py
- [ ] T027 [US3] 實作 [Service]，路徑：src/services/[service].py
- [ ] T028 [US3] 實作 [endpoint/feature]，路徑：src/[location]/[file].py

**檢查點**：所有 user story 均應可獨立運作

---

[如有更多 user story，請依此模式繼續新增階段]

---

## 階段 N：優化與橫向議題

**目的**：影響多個 user story 的改進事項

- [ ] TXXX [P] 更新文件於 docs/
- [ ] TXXX 程式碼清理與重構
- [ ] TXXX 全體效能優化
- [ ] TXXX [P] 額外單元測試（如有需求）於 tests/unit/
- [ ] TXXX 安全性強化
- [ ] TXXX 執行 quickstart.md 驗證

---

## 相依性與執行順序

### 階段相依性

- **初始化（階段 1）**：無相依性——可立即開始
- **基礎建設（階段 2）**：依賴初始化完成——阻擋所有 user story
- **User Story（階段 3 以後）**：皆依賴基礎建設完成
  - user story 可平行進行（若人力足夠）
  - 或依優先順序（P1 → P2 → P3）依序進行
- **優化（最終階段）**：依賴所有目標 user story 完成

### User Story 相依性

- **User Story 1（P1）**：基礎建設（階段 2）完成後可開始——不依賴其他 story
- **User Story 2（P2）**：基礎建設（階段 2）完成後可開始——可與 US1 整合，但應可獨立測試
- **User Story 3（P3）**：基礎建設（階段 2）完成後可開始——可與 US1/US2 整合，但應可獨立測試

### 每個 User Story 內部

- 若有測試，必須先撰寫且確保未實作前會失敗
- 先 model，後 service
- 先 service，後 endpoint
- 先完成核心實作，再進行整合
- Story 完成前，不得進入下一優先順序

### 可平行執行的機會

- 所有標記 [P] 的初始化任務可平行執行
- 所有標記 [P] 的基礎建設任務可於階段 2 內平行執行
- 基礎建設完成後，所有 user story 可平行展開（若團隊人力允許）
- 同一 user story 下所有標記 [P] 的測試可平行執行
- 同一 story 下標記 [P] 的 model 可平行開發
- 不同 user story 可由不同團隊成員平行開發

---

## 平行執行範例：User Story 1

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

### 先完成 MVP（僅 User Story 1）

1. 完成階段 1：Setup
2. 完成階段 2：基礎建設（**關鍵**－阻擋所有 user story）
3. 完成階段 3：User Story 1
4. **停止並驗證**：獨立測試 User Story 1
5. 若已準備好則部署／展示

### 漸進式交付

1. 完成 Setup + 基礎建設 → 基礎已就緒
2. 加入 User Story 1 → 獨立測試 → 部署／展示（MVP！）
3. 加入 User Story 2 → 獨立測試 → 部署／展示
4. 加入 User Story 3 → 獨立測試 → 部署／展示
5. 每個 user story 都能在不破壞前一個的情況下增加價值

### 團隊並行策略

若有多位開發者：

1. 團隊共同完成 Setup + 基礎建設
2. 基礎建設完成後：
   - 開發者 A：User Story 1
   - 開發者 B：User Story 2
   - 開發者 C：User Story 3
3. 各 user story 獨立完成並整合

---

## 備註

- `[P]` 任務 = 不同檔案，無相依性 (dependency)
- `[Story]` 標籤將任務對應到特定 user story，方便追蹤
- 每個 user story 都應能獨立完成並測試
- 實作前請先確認測試會失敗
- 每完成一個任務或邏輯群組就提交一次
- 可在任何檢查點 (checkpoint) 停下來，獨立驗證該 user story
- 避免：模糊不清的任務、同檔案衝突、跨 user story 的相依性 (dependency) 破壞獨立性
