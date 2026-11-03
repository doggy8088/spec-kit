---
description: "建立功能分支，採循序或時間戳記編號"
---

# 建立功能分支

為指定的規格建立新的 Git 功能分支並切換過去。本命令**只負責建立分支**——規格目錄與檔案由核心的 `__SPECKIT_COMMAND_SPECIFY__` 工作流程建立。

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**先考量使用者輸入（若非空白）。

## 環境變數覆寫

若使用者明確提供了 `GIT_BRANCH_NAME`（例如透過環境變數、引數，或在其要求中註明），請在呼叫指令碼之前設定 `GIT_BRANCH_NAME` 環境變數，將它傳給指令碼。設定 `GIT_BRANCH_NAME` 時：
- 指令碼會直接以該值作為分支名稱，略過所有前綴／後綴的產生邏輯
- `--short-name`、`--number` 與 `--timestamp` 旗標會被忽略
- 當最後一個路徑段以數字或時間戳記功能標記開頭時（例如 `042-name`、`feat/042-name` 或 `jdoe/app/042-name`），會從中擷取 `FEATURE_NUM`；否則 `FEATURE_NUM` 設為完整的分支名稱

## 前置條件

- 執行 `git rev-parse --is-inside-work-tree 2>/dev/null`，確認 Git 可用
- 若 Git 不可用，警告使用者並略過分支建立

## 分支編號模式

依下列順序檢查設定，決定分支編號策略：

1. 檢查 `.specify/extensions/git/git-config.yml` 中的 `branch_numbering` 值
2. 檢查 `.specify/init-options.json` 中的 `feature_numbering` 值（繼承自核心）
3. 檢查 `.specify/init-options.json` 中的 `branch_numbering` 值（已棄用，為向後相容保留——將在未來版本移除）
4. 以上皆無時，預設為 `sequential`

## 分支名稱範本

檢查 `.specify/extensions/git/git-config.yml` 中可選的 `branch_template` 值。若為空白或未設定，使用預設的分支形式 `{number}-{slug}`。若已設定，`{slug}` 不得出現在 `{number}` 之前，最後一個路徑段必須以 `{number}-` 開頭，且指令碼會展開下列權杖：

- `{author}`：清理過的 Git 設定作者（`user.name`，找不到時改用電子郵件的本地部分）
- `{app}`：清理過的 Spec Kit 初始化目錄名稱
- `{number}`：循序編號或時間戳記
- `{slug}`：產生的簡短分支代稱

對於 monorepo，`{author}/{app}/{number}-{slug}` 這類範本會建立像 `jdoe/web/008-guided-tour` 的名稱，同時保留各專案獨立的功能編號。

指令碼也接受 `branch_prefix` 作為簡單命名空間的簡寫，會展開為 `<branch_prefix>/{number}-{slug}`。

## 執行

為分支產生簡潔的簡稱（2～4 個字詞）：
- 分析功能說明，擷取最有意義的關鍵字
- 盡量採用「動作－名詞」格式（例如 "add-user-auth"、"fix-payment-bug"）
- 保留技術術語與縮寫（OAuth2、API、JWT 等）

依所在平台執行對應的指令碼：

- **Bash**：`.specify/extensions/git/scripts/bash/create-new-feature-branch.sh --json --short-name "<short-name>" "<feature description>"`
- **Bash（時間戳記）**：`.specify/extensions/git/scripts/bash/create-new-feature-branch.sh --json --timestamp --short-name "<short-name>" "<feature description>"`
- **PowerShell**：`.specify/extensions/git/scripts/powershell/create-new-feature-branch.ps1 -Json -ShortName "<short-name>" "<feature description>"`
- **PowerShell（時間戳記）**：`.specify/extensions/git/scripts/powershell/create-new-feature-branch.ps1 -Json -Timestamp -ShortName "<short-name>" "<feature description>"`

**重要**：
- 不要傳入 `--number`——指令碼會自動決定正確的下一個編號
- 務必加上 JSON 旗標（Bash 用 `--json`，PowerShell 用 `-Json`），輸出才能可靠地解析
- 每個功能只能執行此指令碼一次
- JSON 輸出會包含 `BRANCH_NAME` 與 `FEATURE_NUM`
- 不要手動展開 `branch_template`；指令碼會讀取 Git 擴充功能設定並一致地套用

## 優雅降級

若 Git 未安裝，或目前目錄不是 Git 儲存庫：
- 分支建立會略過並顯示警告：`[specify] Warning: Git repository not detected; skipped branch creation`
- 指令碼仍會輸出 `BRANCH_NAME` 與 `FEATURE_NUM`，供呼叫端參照

## 輸出

指令碼輸出 JSON，包含：
- `BRANCH_NAME`：分支名稱（例如 `003-user-auth`、`20260319-143022-user-auth` 或 `jdoe/web/003-user-auth`）
- `FEATURE_NUM`：所使用的數字或時間戳記前綴
