# 更新日誌

<!-- markdownlint-disable MD024 -->

所有 Specify CLI 及範本的重大變更都會記錄在此檔案中。

此格式基於 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
且本專案遵循 [Semantic Versioning](https://semver.org/spec/v2.0.0.html)。

## [0.0.19] - 2025-10-10

### 新增

- 支援 CodeBuddy（感謝 [@lispking](https://github.com/lispking) 的貢獻）。
- Specify CLI 現在可顯示來自 Git 的錯誤訊息。

### 變更

- 修正 `plan.md` 中憲章檔案的路徑（感謝 [@lyzno1](https://github.com/lyzno1) 指出）。
- 修正 Gemini 產生的 TOML 檔案中的反斜線跳脫問題（感謝 [@hsin19](https://github.com/hsin19) 的貢獻）。
- Implementation 指令現在會確保正確加入 ignore 檔案（感謝 [@sigent-amazon](https://github.com/sigent-amazon) 的貢獻）。

## [0.0.18] - 2025-10-06

### 新增

- 在 `.` 指令中支援使用 `.` 作為目前目錄的簡寫，等同於 `--here` 旗標，但對使用者來說更直觀。
- 使用 `/speckit.` 指令前綴，可輕鬆發現與 Spec Kit 相關的指令。
- 重構提示詞與範本，簡化其功能與追蹤方式。不再在不需要時加入測試內容。
- 確保每個 user story 都會建立對應的任務（簡化測試與驗證）。
- 新增對 Visual Studio Code 提示捷徑與自動腳本執行的支援。

### 變更

- 所有指令檔案現在皆以 `speckit.` 為前綴（例如 `speckit.specify.md`、`speckit.plan.md`），以提升在 IDE/CLI 指令面板與檔案總管中的可發現性與區辨度。

## [0.0.17] - 2025-09-22

### 新增

- 新增 `/clarify` 指令範本，可針對現有規格提出最多 5 個釐清問題，並將答案保存到規格的 Clarifications（釐清）區段。
- 新增 `/analyze` 指令範本，提供非破壞性的跨產出物差異與一致性報告（spec、clarifications、plan、tasks、constitution），該報告會插入於 `/tasks` 之後、`/implement` 之前。
	- 注意：Constitution（原則）規則被明確視為不可協商；任何衝突都屬於「重大」發現，必須修正產出物，而非削弱原則。

## [0.0.16] - 2025-09-22

### 新增

- 為 `init` 指令新增 `--force` 旗標，當在非空目錄下使用 `--here` 時可略過確認，直接進行合併/覆蓋檔案。

## [0.0.15] - 2025-09-21

### 新增

- 新增對 Roo Code 的支援。

## [0.0.14] - 2025-09-21

### 變更

- 錯誤訊息現在會一致地顯示。

## [0.0.13] - 2025-09-21

### 新增

- 新增對 Kilo Code 的支援。感謝 [@shahrukhkhan489](https://github.com/shahrukhkhan489) 於 [#394](https://github.com/github/spec-kit/pull/394) 的貢獻。
- 新增對 Auggie CLI 的支援。感謝 [@hungthai1401](https://github.com/hungthai1401) 於 [#137](https://github.com/github/spec-kit/pull/137) 的貢獻。
- 專案配置完成後會顯示代理資料夾安全提示，提醒使用者部分代理可能會將憑證或授權令牌儲存在其代理資料夾，建議將相關資料夾加入 `.gitignore` 以防止憑證意外外洩。

### 變更

- 顯示警告，確保使用者知道可能需要將代理資料夾加入 `.gitignore`。
- 清理 `check` 指令的輸出內容。

## [0.0.12] - 2025-09-21

### 變更

- 為 OpenAI Codex 用戶新增額外說明——他們需要設定額外的環境變數，詳見 [#417](https://github.com/github/spec-kit/issues/417)。

## [0.0.11] - 2025-09-20

### 新增

- 新增 Codex CLI 支援（感謝 [@honjo-hiroaki-gtt](https://github.com/honjo-hiroaki-gtt) 於 [#14](https://github.com/github/spec-kit/pull/14) 的貢獻）
- 新增 Codex 感知的內容更新工具（Bash 與 PowerShell），讓功能規劃能自動刷新 `AGENTS.md`，無需手動編輯即可同步現有助理。

## [0.0.10] - 2025-09-20

### 修正

- 修正 [#378](https://github.com/github/spec-kit/issues/378)，當 GitHub token 為空時仍可能被附加到請求的問題。

## [0.0.9] - 2025-09-19

### 變更

- 改善代理選擇器 UI，代理鍵會以青色高亮顯示，完整名稱則以灰色括號標示

## [0.0.8] - 2025-09-19

### 新增

- 新增 Windsurf IDE 支援，作為額外的 AI 助理選項（感謝 [@raedkit](https://github.com/raedkit) 於 [#151](https://github.com/github/spec-kit/pull/151) 的貢獻）
- 新增 GitHub token 支援 API 請求，以因應企業環境與速率限制（由 [@zryfish](https://github.com/@zryfish) 於 [#243](https://github.com/github/spec-kit/pull/243) 貢獻）

### 變更

- 更新 README，新增 Windsurf 範例與 GitHub token 用法
- 強化發佈流程，納入 Windsurf 範本

## [0.0.7] - 2025-09-18

### 變更

- 更新 CLI 指令說明。
- 優化程式碼，當資訊為通用時不再顯示代理專屬資訊。

## [0.0.6] - 2025-09-17

### 新增

- 新增 opencode 支援，作為額外的 AI 助理選項

## [0.0.5] - 2025-09-17

### 新增

- 新增 Qwen Code 支援，作為額外的 AI 助理選項

## [0.0.4] - 2025-09-14

### 新增

- 透過 `httpx[socks]` 相依性，新增 SOCKS 代理支援以因應企業環境

### 修正

無

### 變更

無
