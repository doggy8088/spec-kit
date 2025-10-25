---
description: 透過處理並執行 tasks.md 中定義的所有任務，來執行實作計畫
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
---

## 用戶輸入

```text
$ARGUMENTS
```

在繼續執行前，你**必須**考慮用戶輸入（若非空）。

## 大綱

1. 從 repo 根目錄執行 `{SCRIPT}`，並解析 FEATURE_DIR 及 AVAILABLE_DOCS 清單。所有路徑必須為絕對路徑。對於參數中如 "I'm Groot" 這類帶有單引號的字串，請使用跳脫語法：例如 'I'\''m Groot'（或若可行則使用雙引號："I'm Groot"）。

2. **檢查 checklists 狀態**（若 FEATURE_DIR/checklists/ 存在）：
   - 掃描 checklists/ 目錄下所有檢查清單檔案
   - 對每個檢查清單，統計：
     - 總項目數：所有符合 `- [ ]`、`- [X]` 或 `- [x]` 的行
     - 已完成項目數：符合 `- [X]` 或 `- [x]` 的行
     - 未完成項目數：符合 `- [ ]` 的行
   - 建立一個狀態表：

     ```text
     | Checklist | Total | Completed | Incomplete | Status |
     |-----------|-------|-----------|------------|--------|
     | ux.md     | 12    | 12        | 0          | ✓ PASS |
     | test.md   | 8     | 5         | 3          | ✗ FAIL |
     | security.md | 6   | 6         | 0          | ✓ PASS |
     ```

   - 計算整體狀態：
     - **PASS**：所有 checklists 都沒有未完成項目（incomplete items 數量為 0）
     - **FAIL**：有一個或多個 checklists 存在未完成項目

   - **若有任何 checklist 未完成**：
     - 顯示包含未完成項目數量的表格
     - **停止**並詢問：「有些 checklists 尚未完成。你仍要繼續進行實作嗎？（yes/no）」
     - 等待用戶回應後才繼續
     - 若用戶回覆 "no"、"wait" 或 "stop"，則停止執行
     - 若用戶回覆 "yes"、"proceed" 或 "continue"，則繼續執行第 3 步

   - **若所有 checklists 均已完成**：
     - 顯示所有 checklists 通過的表格
     - 自動進入第 3 步

3. 載入並分析實作上下文（implementation context）：
   - **必須**：讀取 tasks.md 以取得完整任務清單與執行計畫
   - **必須**：讀取 plan.md 以取得技術堆疊、架構與檔案結構
   - **若存在**：讀取 data-model.md 以取得 entity 與關聯
   - **若存在**：讀取 contracts/ 以取得 API 契約與測試需求
   - **若存在**：讀取 research.md 以了解技術決策與限制
   - **若存在**：讀取 quickstart.md 以取得整合（integration）場景

4. **專案設定驗證（Project Setup Verification）**：
   - **必須**：根據實際專案設定建立／驗證 ignore 檔案：

   **偵測與建立邏輯（Detection & Creation Logic）**：
   - 檢查下列指令是否成功，以判斷 repository 是否為 git repo（若是則建立／驗證 .gitignore）：

     ```sh
     git rev-parse --git-dir 2>/dev/null
     ```

   - 檢查是否存在 Dockerfile* 或 plan.md 中有 Docker → 建立/驗證 .dockerignore
   - 檢查是否存在 .eslintrc* 或 eslint.config.* → 建立/驗證 .eslintignore
   - 檢查是否存在 .prettierrc* → 建立/驗證 .prettierignore
   - 檢查是否存在 .npmrc 或 package.json → 建立/驗證 .npmignore（若需發佈時）
   - 檢查是否存在 terraform 檔案（*.tf）→ 建立/驗證 .terraformignore
   - 檢查是否需要 .helmignore（有 helm charts 時）→ 建立/驗證 .helmignore

   **若忽略檔案已存在**：請確認其內容包含必要的模式，僅補充缺少的關鍵模式
   **若忽略檔案不存在**：根據偵測到的技術建立完整模式集

   **依技術分類的常見忽略模式**（來自 plan.md 技術堆疊）：
   - **Node.js/JavaScript/TypeScript**：`node_modules/`、`dist/`、`build/`、`*.log`、`.env*`
   - **Python**：`__pycache__/`、`*.pyc`、`.venv/`、`venv/`、`dist/`、`*.egg-info/`
   - **Java**：`target/`、`*.class`、`*.jar`、`.gradle/`、`build/`
   - **C#/.NET**：`bin/`、`obj/`、`*.user`、`*.suo`、`packages/`
   - **Go**：`*.exe`、`*.test`、`vendor/`、`*.out`
   - **Ruby**：`.bundle/`、`log/`、`tmp/`、`*.gem`、`vendor/bundle/`
   - **PHP**：`vendor/`、`*.log`、`*.cache`、`*.env`
   - **Rust**：`target/`、`debug/`、`release/`、`*.rs.bk`、`*.rlib`、`*.prof*`、`.idea/`、`*.log`、`.env*`
   - **Kotlin**：`build/`、`out/`、`.gradle/`、`.idea/`、`*.class`、`*.jar`、`*.iml`、`*.log`、`.env*`
   - **C++**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.so`、`*.a`、`*.exe`、`*.dll`、`.idea/`、`*.log`、`.env*`
   - **C**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.a`、`*.so`、`*.exe`、`Makefile`、`config.log`、`.idea/`、`*.log`、`.env*`
   - **Swift**：`.build/`、`DerivedData/`、`*.swiftpm/`、`Packages/`
   - **R**：`.Rproj.user/`、`.Rhistory`、`.RData`、`.Ruserdata`、`*.Rproj`、`packrat/`、`renv/`
   - **通用（Universal）**：`.DS_Store`、`Thumbs.db`、`*.tmp`、`*.swp`、`.vscode/`、`.idea/`

   **工具專屬忽略模式**：
   - **Docker**：`node_modules/`、`.git/`、`Dockerfile*`、`.dockerignore`、`*.log*`、`.env*`、`coverage/`
   - **ESLint**：`node_modules/`、`dist/`、`build/`、`coverage/`、`*.min.js`
   - **Prettier**：`node_modules/`、`dist/`、`build/`、`coverage/`、`package-lock.json`、`yarn.lock`、`pnpm-lock.yaml`
   - **Terraform**：`.terraform/`、`*.tfstate*`、`*.tfvars`、`.terraform.lock.hcl`
   - **Kubernetes/k8s**：`*.secret.yaml`、`secrets/`、`.kube/`、`kubeconfig*`、`*.key`、`*.crt`

5. 解析 tasks.md 結構並擷取：
   - **任務階段**：Setup、Tests、Core、Integration、Polish
   - **任務相依性**：依序（sequential）與平行（parallel）執行規則
   - **任務細節**：ID、描述、檔案路徑、平行標記 [P]
   - **執行流程**：順序與相依性需求

6. 依照任務計畫執行實作：
   - **逐階段執行**：每個階段完成後再進入下一階段
   - **遵循相依性**：依序執行需串接的任務，帶有 [P] 標記的平行任務可同時執行  
   - **採用 TDD 方法**：先執行測試任務，再執行對應的實作任務
   - **以檔案為協調單位**：影響同一檔案的任務必須依序執行
   - **檢查點驗證**：每個階段完成後需驗證，才能繼續下一步

7. 實作執行規則：
   - **先進行 Setup**：初始化專案結構、相依性、設定檔
   - **測試優先於程式碼**：若需為 contracts、entities 及整合情境撰寫測試，請優先進行
   - **核心開發**：實作 models、services、CLI commands、endpoints
   - **整合作業**：資料庫連線、中介軟體（middleware）、日誌、外部服務
   - **優化與驗證**：單元測試、效能優化、文件撰寫

8. 進度追蹤與錯誤處理：
   - 每完成一個任務後回報進度
   - 若任何非平行任務失敗，立即停止執行
   - 對於平行任務 [P]，僅繼續執行成功的任務，並回報失敗者
   - 提供具體且有脈絡的錯誤訊息以利除錯
   - 若無法繼續實作，請建議下一步行動
   - **重要**：已完成的任務，請務必在 tasks 檔案中標記為 [X]

9. 完成驗證：
   - 確認所有必要任務皆已完成
   - 檢查已實作功能是否符合原始規格
   - 驗證測試通過且覆蓋率達標
   - 確認實作內容符合技術計畫
   - 回報最終狀態並摘要已完成工作

注意：本指令假設 tasks.md 已有完整的任務拆解。若任務不完整或缺失，請建議先執行 `/speckit.tasks` 以重新產生任務清單。

