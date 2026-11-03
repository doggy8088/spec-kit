# Git 分支工作流程擴充功能

為 Spec Kit 提供 Git 儲存庫初始化、功能分支建立、編號（循序／時間戳記）、驗證、遠端偵測與自動提交。

## 總覽

本擴充功能將 Git 操作封裝為選用的獨立模組，負責管理：

- **儲存庫初始化**，提交訊息可自訂
- **功能分支建立**，採循序（`001-feature-name`）或時間戳記（`20260319-143022-feature-name`）編號，並可選用分支命名空間範本
- **分支驗證**，確保分支符合命名慣例
- **Git 遠端偵測**，供 GitHub 整合使用（例如建立 issue）
- **自動提交**，在核心命令之後執行（可依命令分別設定並自訂訊息，或由代理產生 Conventional Commit 訊息）

## 命令

| 命令 | 說明 |
|---------|-------------|
| `speckit.git.initialize` | 初始化 Git 儲存庫，提交訊息可自訂 |
| `speckit.git.feature` | 建立功能分支，採循序或時間戳記編號 |
| `speckit.git.validate` | 驗證目前分支是否符合功能分支命名慣例 |
| `speckit.git.remote` | 偵測 Git 遠端 URL，供 GitHub 整合使用 |
| `speckit.git.commit` | 自動提交變更（可依命令分別啟用／停用並設定訊息） |

## Hooks

| 事件 | 命令 | 選用 | 說明 |
|-------|---------|----------|-------------|
| `before_constitution` | `speckit.git.initialize` | 否 | 在憲章之前初始化 Git 儲存庫 |
| `before_specify` | `speckit.git.feature` | 否 | 在規格之前建立功能分支 |
| `before_clarify` | `speckit.git.commit` | 是 | 在釐清之前提交未完成的變更 |
| `before_plan` | `speckit.git.commit` | 是 | 在計畫之前提交未完成的變更 |
| `before_tasks` | `speckit.git.commit` | 是 | 在產生任務之前提交未完成的變更 |
| `before_implement` | `speckit.git.commit` | 是 | 在實作之前提交未完成的變更 |
| `before_checklist` | `speckit.git.commit` | 是 | 在檢核清單之前提交未完成的變更 |
| `before_analyze` | `speckit.git.commit` | 是 | 在分析之前提交未完成的變更 |
| `before_taskstoissues` | `speckit.git.commit` | 是 | 在同步 issue 之前提交未完成的變更 |
| `after_constitution` | `speckit.git.commit` | 是 | 在更新憲章之後自動提交 |
| `after_specify` | `speckit.git.commit` | 是 | 在規格之後自動提交 |
| `after_clarify` | `speckit.git.commit` | 是 | 在釐清之後自動提交 |
| `after_plan` | `speckit.git.commit` | 是 | 在計畫之後自動提交 |
| `after_tasks` | `speckit.git.commit` | 是 | 在產生任務之後自動提交 |
| `after_implement` | `speckit.git.commit` | 是 | 在實作之後自動提交 |
| `after_checklist` | `speckit.git.commit` | 是 | 在檢核清單之後自動提交 |
| `after_analyze` | `speckit.git.commit` | 是 | 在分析之後自動提交 |
| `after_taskstoissues` | `speckit.git.commit` | 是 | 在同步 issue 之後自動提交 |

## 設定

設定存放於 `.specify/extensions/git/git-config.yml`：

```yaml
# Branch numbering strategy: "sequential" or "timestamp"
branch_numbering: sequential

# Optional branch name template. Leave empty for the default "{number}-{slug}".
# Supported tokens: {author}, {app}, {number}, {slug}; {slug} must not appear
# before {number}, and the final path segment must start with {number}-.
# Example for monorepos: "{author}/{app}/{number}-{slug}"
branch_template: ""

# Optional shorthand namespace. Leave empty to use branch_template/default behavior.
# Example: "features/{app}" expands to "features/{app}/{number}-{slug}"
branch_prefix: ""

# Custom commit message for git init
init_commit_message: "[Spec Kit] Initial commit"

# Commit message style for auto-commit hooks: "fixed" (default) uses the
# messages below; "conventional" asks the agent to generate a Conventional
# Commit message (e.g. "feat: add OAuth spec") from the diff instead.
commit_style: fixed

# Auto-commit per command (all disabled by default)
# Example: enable auto-commit after specify
auto_commit:
  default: false
  after_specify:
    enabled: true
    message: "[Spec Kit] Add specification"
```

`{author}` 取自 Git 設定，並已清理為適合分支名稱的格式。`{app}` 取自 Spec Kit 初始化目錄名稱。自訂範本不得將 `{slug}` 放在 `{number}` 之前，且最後一個路徑段必須以 `{number}-` 開頭，產生的名稱才會是有效的功能分支。以位於 `apps/web/.specify/` 的 monorepo 專案為例，`{author}/{app}/{number}-{slug}` 這類範本會產生像 `jdoe/web/008-guided-tour` 的分支。

若只需要簡單的命名空間自訂，也可使用 `branch_prefix` 作為簡寫，會展開為 `<branch_prefix>/{number}-{slug}`。

## 安裝

```bash
# Install the bundled git extension (no network required)
specify extension add git
```

## 停用

```bash
# Disable the git extension (spec creation continues without branching)
specify extension disable git

# Re-enable it
specify extension enable git
```

## 優雅降級

當 Git 未安裝，或目錄不是 Git 儲存庫時：
- 規格目錄仍會在 `specs/` 下建立
- 分支建立會略過並顯示警告
- 分支驗證會略過並顯示警告
- 遠端偵測會回傳空白結果

## 指令碼

本擴充功能內附跨平台指令碼：

- `scripts/bash/create-new-feature-branch.sh` — Bash 實作（僅負責分支建立）
- `scripts/bash/git-common.sh` — 共用 Git 工具（Bash）
- `scripts/powershell/create-new-feature-branch.ps1` — PowerShell 實作（僅負責分支建立）
- `scripts/powershell/git-common.ps1` — 共用 Git 工具（PowerShell）
