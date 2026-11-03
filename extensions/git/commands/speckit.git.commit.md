---
description: "在 Spec Kit 命令完成後自動提交變更"
---

# 自動提交變更

在 Spec Kit 命令完成後，自動暫存並提交所有變更。

## 行為

本命令會作為 hook，在核心命令之後（或之前）觸發。它會：

1. 從 hook 情境判斷事件名稱（例如以 `after_specify` hook 觸發時，事件為 `after_specify`；若為 `before_plan`，事件則為 `before_plan`）
2. 檢查 `.specify/extensions/git/git-config.yml` 中的 `auto_commit` 區段
3. 查詢對應的事件鍵，確認是否啟用自動提交
4. 若沒有事件專屬的鍵，改用 `auto_commit.default`
5. 依 `commit_style` 決定提交訊息（見下文）
6. 若已啟用且有未提交的變更，執行 `git add .` + `git commit`

## 提交訊息樣式

由 `.specify/extensions/git/git-config.yml` 中的 `commit_style` 鍵控制：

- **`fixed`**（預設）：若有設定，使用各命令專屬的 `message`；否則使用通用的 `[Spec Kit] Auto-commit <phase> <command>` 訊息。
- **`conventional`**：檢視自上次提交以來的實際變更（`git diff`／`git status`），產生單行的 [Conventional Commit](https://www.conventionalcommits.org/) 訊息（`type(scope): subject`，例如 `feat: add OAuth specification` 或 `docs: update implementation plan`），準確摘要這次變更。將訊息寫入暫存檔，並把檔案路徑傳給指令碼（見下方的執行說明）。在此模式下，已設定的 `message` 值會被忽略。

## 執行

從觸發本命令的 hook 判斷事件名稱，然後執行指令碼：

- **Bash**：`.specify/extensions/git/scripts/bash/auto-commit.sh <event_name> [--message-file <path>]`
- **PowerShell**：`.specify/extensions/git/scripts/powershell/auto-commit.ps1 <event_name> [-MessageFile <path>]`

將 `<event_name>` 換成實際的 hook 事件（例如 `after_specify`、`before_plan`、`after_implement`）。只有在設定為 `commit_style: conventional` 時，才傳入產生的訊息——先檢查 `.specify/extensions/git/git-config.yml` 中 `commit_style` 的值：

- 若為 `conventional`：檢視差異並產生 Conventional Commit 訊息。**不要將產生的訊息直接插入 shell 命令字串**——其內容來自儲存庫變更，可能包含 shell 會執行或破壞命令引號的字元（引號、`$(...)`、反引號）。應改用檔案編輯工具（而非 shell 的 `echo`／`printf`）將訊息寫入暫存檔，再透過 `--message-file <path>`（Bash）或 `-MessageFile <path>`（PowerShell）傳入該檔案的路徑。
- 若為 `fixed` 或未設定：只以 `<event_name>` 執行指令碼；它會使用已設定／固定的訊息。

## 設定

在 `.specify/extensions/git/git-config.yml` 中：

```yaml
# "fixed" (default) uses the messages below; "conventional" asks the agent
# to generate a Conventional Commit message from the diff instead.
commit_style: fixed

auto_commit:
  default: false          # Global toggle — set true to enable for all commands
  after_specify:
    enabled: true          # Override per-command
    message: "[Spec Kit] Add specification"
  after_plan:
    enabled: false
    message: "[Spec Kit] Add implementation plan"
```

## 優雅降級

- 若 Git 不可用，或目前目錄不是儲存庫：略過並顯示警告
- 若設定檔不存在：略過（預設停用）
- 若沒有可提交的變更：略過並顯示訊息
- 若已設定 `commit_style: conventional`，但未提供產生的訊息：以明確的錯誤失敗，而不是靜默改用固定訊息格式
