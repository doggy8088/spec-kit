# 變更記錄

<!-- markdownlint-disable MD024 -->

所有 Specify CLI 及模板的重要變更都記錄於此。

此格式基於 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，  
本專案遵循 [語意化版本控制 (Semantic Versioning)](https://semver.org/spec/v2.0.0.html)。

## [0.0.20] - 2025-10-14

### 新增

- **智慧分支命名**：`create-new-feature` 腳本現在支援 `--short-name` 參數以自訂分支名稱
  - 提供 `--short-name` 時：直接使用自訂名稱（會自動清理與格式化）
  - 省略時：自動產生有意義的名稱，會過濾停用詞並根據長度篩選
  - 過濾常見停用詞（I、want、to、the、for 等）
  - 移除少於 3 個字元的單字（除非為大寫縮寫）
  - 從描述中擷取 3-4 個最具意義的單字
  - **強制遵守 GitHub 244-byte 分支名稱限制**，自動截斷並發出警告
  - 範例：
    - "I want to create user authentication" → `001-create-user-authentication`
    - "Implement OAuth2 integration for API" → `001-implement-oauth2-integration-api`
    - "Fix payment processing bug" → `001-fix-payment-processing`
    - 過長的描述會自動在單字邊界截斷以符合限制
  - 專為 AI agent 提供語意化短名稱設計，同時維持獨立可用性

### 變更

- 強化 `create-new-feature.sh` 及 `create-new-feature.ps1` 腳本的說明文件，並附上範例
- 分支名稱現在會驗證 GitHub 244-byte 限制，必要時自動截斷

## [0.0.19] - 2025-10-10

### 新增

- 支援 CodeBuddy（感謝 [@lispking](https://github.com/lispking) 的貢獻）。
- Specify CLI 現在可以顯示來自 Git 的錯誤訊息。

### 變更

- 修正 `plan.md` 中憲章的路徑（感謝 [@lyzno1](https://github.com/lyzno1) 指出）。
- 修正為 Gemini 產生的 TOML 檔案中的反斜線跳脫字元（感謝 [@hsin19](https://github.com/hsin19) 的貢獻）。
- 實作指令現在會確保正確加入 ignore 檔案（感謝 [@sigent-amazon](https://github.com/sigent-amazon) 的貢獻）。

## [0.0.18] - 2025-10-06

### 新增

- `.` 現可作為 `specify init .` 指令中目前目錄的簡寫，等同於 `--here` 旗標，但對使用者更直觀。
- 使用 `/speckit.` 指令前綴，可輕鬆探索所有與 Spec Kit 相關的指令。
- 重構提示詞與模板，簡化其功能與追蹤方式。當不需要測試時，不再產生多餘內容。
- 確保每個使用者故事都會建立獨立任務（簡化測試與驗證）。
- 新增支援 Visual Studio Code 提示捷徑與自動腳本執行。

### 變更

- 所有指令檔案現在皆以 `speckit.` 為前綴（如 `speckit.specify.md`、`speckit.plan.md`），方便在 IDE/CLI 指令選單與檔案總管中辨識與區分。

## [0.0.17] - 2025-09-22

### 新增

- 新增 `/clarify` 指令模板，可針對現有規格提出最多 5 個精準釐清問題，並將答案儲存於規格的 Clarifications 區段。
- 新增 `/analyze` 指令模板，提供非破壞性的跨產物差異與對齊報告（spec、clarifications、plan、tasks、constitution），插入於 `/tasks` 之後、`/implement` 之前。
	- 注意：憲章規則明確視為不可協商，任何衝突皆屬「重大」問題，必須修正產物，而非弱化原則。

## [0.0.16] - 2025-09-22

### 新增

- `--force` 旗標可用於 `init` 指令，在非空目錄下使用 `--here` 時可略過確認，直接合併/覆蓋檔案。

## [0.0.15] - 2025-09-21

### 新增

- 新增 Roo Code 支援。

## [0.0.14] - 2025-09-21

### 變更

- 錯誤訊息現在會一致顯示。

## [0.0.13] - 2025-09-21

### 新增

- 新增 Kilo Code 支援。感謝 [@shahrukhkhan489](https://github.com/shahrukhkhan489) 於 [#394](https://github.com/github/spec-kit/pull/394) 的貢獻。
- 新增 Auggie CLI 支援。感謝 [@hungthai1401](https://github.com/hungthai1401) 於 [#137](https://github.com/github/spec-kit/pull/137) 的貢獻。
- 專案配置完成後，會顯示 agent 資料夾安全性提示，提醒用戶部分 agent 可能會將憑證或授權 token 儲存於其 agent 資料夾，建議將相關資料夾加入 `.gitignore` 以避免憑證外洩。

### 變更

- 顯示警告，提醒用戶可能需要將 agent 資料夾加入 `.gitignore`。
- 清理 `check` 指令的輸出內容。

## [0.0.12] - 2025-09-21

### 變更

- 為 OpenAI Codex 用戶新增額外說明——需設定額外的環境變數，詳見 [#417](https://github.com/github/spec-kit/issues/417)。

## [0.0.11] - 2025-09-20

### 新增

- 新增 Codex CLI 支援（感謝 [@honjo-hiroaki-gtt](https://github.com/honjo-hiroaki-gtt) 於 [#14](https://github.com/github/spec-kit/pull/14) 的貢獻）
- 新增 Codex 感知的上下文更新工具（Bash 與 PowerShell），讓功能規劃能自動刷新 `AGENTS.md`，無需手動編輯。

## [0.0.10] - 2025-09-20

### 修正

- 處理 [#378](https://github.com/github/spec-kit/issues/378)，當 GitHub token 為空時，請求中不再附加 token。

## [0.0.9] - 2025-09-19

### 變更

- 改善 agent 選擇器 UI，agent key 以青色高亮，完整名稱以灰色括號標示

## [0.0.8] - 2025-09-19

### 新增

- 新增 Windsurf IDE 支援，作為額外 AI agent 選項（感謝 [@raedkit](https://github.com/raedkit) 於 [#151](https://github.com/github/spec-kit/pull/151) 的貢獻）
- API 請求新增 GitHub token 支援，以因應企業環境與速率限制（由 [@zryfish](https://github.com/@zryfish) 於 [#243](https://github.com/github/spec-kit/pull/243) 貢獻）

### 變更

- README 新增 Windsurf 範例與 GitHub token 用法說明
- 強化發佈流程，納入 Windsurf 模板

## [0.0.7] - 2025-09-18

### 變更

- 更新 CLI 指令說明。
- 清理程式碼，當為通用資訊時不再渲染 agent 專屬資訊。

## [0.0.6] - 2025-09-17

### 新增

- 新增 opencode 支援，作為額外 AI agent 選項

## [0.0.5] - 2025-09-17

### 新增

- 新增 Qwen Code 支援，作為額外 AI agent 選項

## [0.0.4] - 2025-09-14

### 新增

- 企業環境可透過 `httpx[socks]` 相依性 (dependency) 支援 SOCKS 代理

### 修正

無

### 變更

無

