---
description: 處理並執行 tasks.md 中定義的全部任務，執行實作計畫。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
  py: scripts/python/check_prerequisites.py --json --require-tasks --include-tasks
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考慮使用者輸入（若非空白）。

## 執行前檢查

**檢查擴充功能 hooks（實作之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_implement` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後照常繼續
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **強制 hook**（`optional: false`）：
    ```
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to the Outline.
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過

## 大綱

1. 從儲存庫根目錄執行 `{SCRIPT}`，並解析 FEATURE_DIR 與 AVAILABLE_DOCS 清單。所有路徑都必須是絕對路徑。若引數中含單引號，例如 "I'm Groot"，使用跳脫語法：例如 'I'\''m Groot'（或盡可能改用雙引號："I'm Groot"）。

2. **檢查檢核清單狀態**（若 FEATURE_DIR/checklists/ 存在）：
   - 將檢核清單標記視為唯讀關卡：掃描勾選框狀態、回報狀態，並在需要時於繼續之前先詢問；**不要**修改檢核清單檔案或標記
   - `checklists/requirements.md` 是由 `__SPECKIT_COMMAND_SPECIFY__` 與 `__SPECKIT_COMMAND_CLARIFY__` 維護的內建規格品質檢核清單；由 `__SPECKIT_COMMAND_CHECKLIST__` 產生的自訂檢核清單是審查者持有的需求品質審查產物
   - 對於自訂檢核清單，`[x]` 表示審查者判定需求品質準則已滿足；這**不**表示實作工作已完成
   - 掃描 checklists/ 目錄中的全部檢核清單檔案
   - 對每個檢核清單，計算：
     - 項目總數：所有符合 `- [ ]` 或 `- [X]` 或 `- [x]` 的行
     - 已勾選項目：符合 `- [X]` 或 `- [x]` 的行
     - 未勾選項目：符合 `- [ ]` 的行
   - 建立狀態表：

     ```text
     | Checklist | Total | Checked | Unchecked | Status |
     |-----------|-------|---------|-----------|--------|
     | ux.md     | 12    | 12      | 0         | ✓ PASS |
     | test.md   | 8     | 5       | 3         | ✗ FAIL |
     | security.md | 6   | 6       | 0         | ✓ PASS |
     ```

   - 計算整體狀態：
     - **PASS**：所有檢核清單的未勾選項目都是 0
     - **FAIL**：一或多個檢核清單有未勾選項目

   - **若有任何檢核清單有未勾選項目**：
     - 顯示表格，附未勾選項目數
     - **停下來**並詢問：「Some checklists have unchecked items. Do you want to proceed with implementation anyway? (yes/no)」
     - 等待使用者回應後才繼續
     - 若使用者說「no」、「wait」或「stop」，停止執行
     - 若使用者說「yes」、「proceed」或「continue」，繼續到步驟 3

   - **若所有檢核清單都已勾選**：
     - 顯示表格，表明所有檢核清單都通過
     - 自動繼續到步驟 3

3. 載入並分析實作背景：
   - **必要**：讀取 tasks.md，取得完整任務清單與執行計畫
   - **必要**：讀取 plan.md，取得技術堆疊、架構與檔案結構
   - **若存在**：讀取 data-model.md，取得實體與關係
   - **若存在**：讀取 contracts/，取得 API 規格與測試需求
   - **若存在**：讀取 research.md，取得技術決策與限制
   - **若存在**：讀取 /memory/constitution.md，取得治理限制
   - **若存在**：讀取 quickstart.md，取得整合情境

4. **專案設定驗證**：
   - **必要**：依實際專案設定建立／驗證忽略檔案：

   **偵測與建立邏輯**：
   - 檢查以下命令是否成功，以判定儲存庫是否為 git 儲存庫（若是，建立／驗證 .gitignore）：

     ```sh
     git rev-parse --git-dir 2>/dev/null
     ```

   - 若 Dockerfile* 存在，或 plan.md 提到 Docker → 建立／驗證 .dockerignore
   - 若 .eslintrc* 存在 → 建立／驗證 .eslintignore
   - 若 eslint.config.* 存在 → 確保該設定的 `ignores` 項目涵蓋必要模式
   - 若 .prettierrc* 存在 → 建立／驗證 .prettierignore
   - 若 .npmrc 或 package.json 存在 → 建立／驗證 .npmignore（若要發佈）
   - 若有 terraform 檔案（*.tf）→ 建立／驗證 .terraformignore
   - 若需要 .helmignore（有 helm charts）→ 建立／驗證 .helmignore

   **若忽略檔案已存在**：驗證它包含必要的模式，只附加缺失的關鍵模式
   **若忽略檔案不存在**：以偵測到的技術的完整模式集建立

   **依技術分類的常見模式**（來自 plan.md 的技術堆疊）：
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
   - **C**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.a`、`*.so`、`*.exe`、`*.dll`、`autom4te.cache/`、`config.status`、`config.log`、`.idea/`、`*.log`、`.env*`
   - **Swift**：`.build/`、`DerivedData/`、`*.swiftpm/`、`Packages/`
   - **R**：`.Rproj.user/`、`.Rhistory`、`.RData`、`.Ruserdata`、`*.Rproj`、`packrat/`、`renv/`
   - **通用**：`.DS_Store`、`Thumbs.db`、`*.tmp`、`*.swp`、`.vscode/`、`.idea/`

   **工具專屬模式**：
   - **Docker**：`node_modules/`、`.git/`、`Dockerfile*`、`.dockerignore`、`*.log*`、`.env*`、`coverage/`
   - **ESLint**：`node_modules/`、`dist/`、`build/`、`coverage/`、`*.min.js`
   - **Prettier**：`node_modules/`、`dist/`、`build/`、`coverage/`、`package-lock.json`、`yarn.lock`、`pnpm-lock.yaml`
   - **Terraform**：`.terraform/`、`*.tfstate*`、`*.tfvars`、`.terraform.lock.hcl`
   - **Kubernetes/k8s**：`*.secret.yaml`、`secrets/`、`.kube/`、`kubeconfig*`、`*.key`、`*.crt`

5. 解析 tasks.md 的結構並擷取：
   - **任務階段**：Setup、Tests、Core、Integration、Polish
   - **任務相依關係**：循序與平行執行規則
   - **任務細節**：ID、說明、檔案路徑、平行標記 [P]
   - **執行流程**：順序與相依要求

6. 依照任務計畫執行實作：
   - **逐階段執行**：完成每個階段後才移到下一個
   - **尊重相依關係**：循序任務依序執行，平行任務 [P] 可以一起執行
   - **遵循 TDD 做法**：在對應的實作任務之前先執行測試任務
   - **以檔案協調**：影響相同檔案的任務必須循序執行
   - **驗證檢查點**：繼續之前先驗證每個階段完成

7. 實作執行規則：
   - **先做設定**：初始化專案結構、相依套件、設定
   - **測試先於程式碼**：若需要為契約、實體與整合情境寫測試
   - **核心開發**：實作模型、服務、CLI 命令、端點
   - **整合工作**：資料庫連線、中介軟體、記錄、外部服務
   - **潤飾與驗證**：單元測試、效能最佳化、文件

8. 進度追蹤與錯誤處理：
   - 每完成一個任務後回報進度
   - 若有任何非平行任務失敗，停止執行
   - 對於平行任務 [P]，繼續執行成功的任務，並回報失敗的任務
   - 提供附背景的清楚錯誤訊息，方便除錯
   - 若實作無法繼續，建議下一步
   - **重要**：對於已完成的任務，務必在任務檔案中將該任務標記為 [X]。

9. 完成驗證：
   - 驗證所有必要任務都已完成
   - 檢查已實作的功能與原始規格相符
   - 驗證測試通過，且涵蓋率符合要求
   - 確認實作遵循技術計畫

注意：這個命令假設 tasks.md 中已有完整的任務拆解。若任務不完整或缺失，建議先執行 `__SPECKIT_COMMAND_TASKS__` 重新產生任務清單。

## 強制執行後 Hooks

**在向使用者回報完成之前，你必須先完成這一節。**

檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若它不存在，或 `hooks.after_implement` 底下沒有註冊任何 hooks，跳到完成報告。
- 若存在，讀取它並尋找 `hooks.after_implement` 鍵底下的項目。
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後繼續到完成報告。
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **強制 hook**（`optional: false`）——**你必須為每個強制 hook 輸出 `EXECUTE_COMMAND:`**：
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

## 完成報告

回報最終狀態，附已完成工作的摘要。

## 完成條件

- [ ] tasks.md 中的所有任務都已完成並標記為 `[X]`
- [ ] 實作已對照規格、計畫與測試涵蓋率驗證
- [ ] 擴充功能 hooks 已依上方強制執行後 Hooks 的規則派送或跳過
- [ ] 已向使用者回報完成，附已完成工作的摘要
