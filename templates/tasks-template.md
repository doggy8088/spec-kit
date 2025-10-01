# 任務: [FEATURE NAME]

**輸入**：來自 `/specs/[###-feature-name]/` 的設計文件  
**前置需求**：plan.md（必填）、research.md、data-model.md、contracts/

## 執行流程（主流程）
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. Generate tasks by category:
   → Setup: project init, dependencies, linting
   → Tests: contract tests, integration tests
   → Core: models, services, CLI commands
   → Integration: DB, middleware, logging
   → Polish: unit tests, performance, docs
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All contracts have tests?
   → All entities have models?
   → All endpoints implemented?
9. Return: SUCCESS (tasks ready for execution)
```

## 格式：`[ID] [P?] Description`
- **[P]**：可並行執行（不同檔案，無相依性）
- 請在描述中包含精確的檔案路徑

## 路徑命名慣例
- **單一專案**：`src/`、`tests/` 位於版本庫根目錄
- **Web 應用**：`backend/src/`、`frontend/src/`
- **行動裝置**：`api/src/`、`ios/src/` 或 `android/src/`
- 下方所示路徑預設為單一專案，請依據 plan.md 結構調整

## 階段 3.1：環境設置
- [ ] T001 依據實作計畫建立專案結構
- [ ] T002 使用 [language] 與 [framework] 相依套件初始化專案
- [ ] T003 [P] 設定 lint 與格式化工具

## 階段 3.2：先寫測試（TDD） ⚠️ 必須於 3.3 前完成
**重要：這些測試必須撰寫，且在任何實作前必須為失敗狀態**
- [ ] T004 [P] 在 tests/contract/test_users_post.py 撰寫 POST /api/users 合約測試
- [ ] T005 [P] 在 tests/contract/test_users_get.py 撰寫 GET /api/users/{id} 合約測試
- [ ] T006 [P] 在 tests/integration/test_registration.py 撰寫使用者註冊整合測試
- [ ] T007 [P] 在 tests/integration/test_auth.py 撰寫驗證流程整合測試

## 階段 3.3：核心實作（僅於測試失敗後開始）
- [ ] T008 [P] 在 src/models/user.py 建立 User 模型
- [ ] T009 [P] 在 src/services/user_service.py 完成 UserService CRUD
- [ ] T010 [P] 在 src/cli/user_commands.py 實作 CLI --create-user
- [ ] T011 實作 POST /api/users endpoint
- [ ] T012 實作 GET /api/users/{id} endpoint
- [ ] T013 輸入驗證
- [ ] T014 錯誤處理與日誌記錄

## 階段 3.4：整合
- [ ] T015 將 UserService 連接至資料庫
- [ ] T016 驗證中介軟體（Auth middleware）
- [ ] T017 請求／回應日誌記錄
- [ ] T018 CORS 與安全性標頭

## 階段 3.5：完善
- [ ] T019 [P] 在 tests/unit/test_validation.py 撰寫驗證單元測試
- [ ] T020 效能測試（<200ms）
- [ ] T021 [P] 更新 docs/api.md
- [ ] T022 移除重複內容
- [ ] T023 執行 manual-testing.md

## 相依性
- 測試（T004-T007）需先於實作（T008-T014）完成
- T008 阻擋 T009、T015
- T016 阻擋 T018
- 實作需先於完善（T019-T023）完成

## 並行範例
```
# Launch T004-T007 together:
Task: "Contract test POST /api/users in tests/contract/test_users_post.py"
Task: "Contract test GET /api/users/{id} in tests/contract/test_users_get.py"
Task: "Integration test registration in tests/integration/test_registration.py"
Task: "Integration test auth in tests/integration/test_auth.py"
```

## 注意事項
- [P] tasks = 不同檔案，無相依性
- 在實作前請先確認測試會失敗
- 每完成一個任務請提交一次
- 避免：任務描述不明確、同一檔案產生衝突

## 任務產生規則
*於 main() 執行時套用*

1. **來自 Contracts**：
   - 每個 contract 檔案 → contract 測試任務 [P]
   - 每個 endpoint → 實作任務

2. **來自資料模型（Data Model）**：
   - 每個 entity → model 建立任務 [P]
   - 關聯（Relationships）→ service 層任務

3. **來自使用者故事（User Stories）**：
   - 每個故事 → 整合測試 [P]
   - 快速入門場景（Quickstart scenarios）→ 驗證任務

4. **執行順序**：
   - 設定 → 測試 → 模型 → 服務 → Endpoint → 優化
   - 有相依性的任務會阻擋平行執行

## 驗證檢查清單
*GATE：由 main() 在返回前檢查*

- [ ] 所有 contract 都有對應的測試
- [ ] 所有 entity 都有 model 任務
- [ ] 所有測試皆在實作之前
- [ ] 平行任務確實互不相依
- [ ] 每個任務皆明確指定檔案路徑
- [ ] 無任務會修改與其他 [P] 任務相同的檔案