---
description: 根據現有設計產物，為功能產生可執行、依賴順序排列的 tasks.md。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

你收到的使用者輸入可能直接由代理程式提供，或作為命令參數傳入——你在進行提示前**必須**考慮該輸入（若不為空）。

使用者輸入：

$ARGUMENTS

1. 從 repo 根目錄執行 `{SCRIPT}`，並解析 FEATURE_DIR 與 AVAILABLE_DOCS 清單。所有路徑必須為絕對路徑。
2. 載入並分析現有設計文件：
   - 一定要讀取 plan.md 以獲取技術棧與函式庫
   - 若存在：讀取 data-model.md 以取得實體資訊
   - 若存在：讀取 contracts/ 以取得 API 端點
   - 若存在：讀取 research.md 以了解技術決策
   - 若存在：讀取 quickstart.md 以取得測試場景

   注意：並非所有專案都包含上述所有文件。例如：
   - 命令列工具（CLI tools）可能沒有 contracts/
   - 簡單函式庫可能不需要 data-model.md
   - 請根據實際可用文件產生任務

3. 依照下列模板產生任務：
   - 以 `/templates/tasks-template.md` 為基礎
   - 以實際情況取代範例任務，依據：
     * **初始化任務**：專案初始化、依賴安裝、程式碼檢查（linting）
     * **測試任務 [P]**：每個 contract 一個、每個整合場景一個
     * **核心任務**：每個實體、服務、命令列指令、端點各一
     * **整合任務**：資料庫連線、中介軟體、日誌
     * **優化任務 [P]**：單元測試、效能、文件

4. 任務產生規則：
   - 每個 contract 檔案 → contract 測試任務，標記 [P]
   - data-model 中每個實體 → model 建立任務，標記 [P]
   - 每個端點 → 實作任務（若有共用檔案則不可並行）
   - 每個 user story → 整合測試，標記 [P]
   - 不同檔案 = 可並行 [P]
   - 相同檔案 = 順序執行（不標記 [P]）

5. 依照依賴順序排列任務：
   - 初始化任務優先
   - 測試在實作前（TDD）
   - Model 在 service 前
   - Service 在 endpoint 前
   - 核心任務在整合任務前
   - 所有任務在優化任務前

6. 包含並行執行範例：
   - 將可同時執行的 [P] 任務分組
   - 展示實際 Task agent 指令

7. 建立 FEATURE_DIR/tasks.md，內容包含：
   - 從實作計畫取得正確的功能名稱
   - 任務編號（T001、T002 等）
   - 每個任務的明確檔案路徑
   - 依賴說明
   - 並行執行指引

任務產生的上下文：{ARGS}

tasks.md 應可立即執行——每個任務都必須具體明確，使大型語言模型 (LLM) 能在無需額外上下文的情況下完成。
