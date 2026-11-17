# 擴充功能概覽

使用 Spec Kit 擴充功能新增命令、外部工具整合、品質閘門與其他能力的指南，超越內建的規格驅動開發流程。

## 目錄

1. [簡介](#簡介)
2. [開始使用](#開始使用)
3. [尋找擴充功能](#尋找擴充功能)
4. [安裝擴充功能](#安裝擴充功能)
5. [使用擴充功能](#使用擴充功能)
6. [管理擴充功能](#管理擴充功能)
7. [設定](#設定)
8. [疑難排解](#疑難排解)
9. [最佳實務](#最佳實務)

---

## 簡介

### 什麼是擴充功能？

擴充功能是模組化套件，能為 Spec Kit 新增命令與功能，又不會讓核心框架臃腫。它們讓你能：

- **整合**外部工具（Jira、Linear、GitHub 等）
- 以 hook **自動化**重複性任務
- 為你的團隊**自訂**工作流程
- 跨專案**分享**解決方案

### 為什麼使用擴充功能？

- **精簡核心**：讓 spec-kit 保持輕量且專注
- **選用功能**：只安裝你需要的
- **社群驅動**：任何人都能建立並分享擴充功能
- **版本控制**：擴充功能獨立進行版本管理

### 規格成品維護

擴充功能可以定義命令或 hook，在功能交付期間或之後對帳 `spec.md`、`plan.md` 與 `tasks.md`。任何這類編輯都遵循擴充功能記載的行為與專案的治理；它們不是由核心 Spec Kit 命令執行，也不加入其職責。團隊的保存模型另外決定成品在交付後如何維護。

---

## 開始使用

### 必要條件

- 與擴充功能的 `requires.speckit_version` 限制相容的目前 Spec Kit 版本
- 以 `specify init` 初始化的專案（含有 `.specify/` 資料夾的目錄）

### 檢查你的版本

```bash
specify version
```

### 第一個擴充功能

先從內建的 GitHub 擴充功能開始：

```bash
# 1. Search for the extension
specify extension search github

# 2. Get detailed information
specify extension info github

# 3. Install it
specify extension add github
```

此擴充功能需要 Git 與已設定的 GitHub MCP 伺服器。具備這些條件後，在 GitHub Copilot 聊天中呼叫 `/speckit-github-taskstoissues`，將功能的 `tasks.md` 轉換為 GitHub issues。這是聊天命令，不是終端機命令。

以下 Jira 範例說明一個經過獨立審查的第三方擴充功能。這些範例假設你已從審查過的封存檔安裝它，或已設定自己信任的型錄；Jira 在內建社群型錄中僅供探索。

---

## 尋找擴充功能

`specify extension search` 會同時搜尋**所有使用中的型錄**，預設包含社群型錄。結果會註記來源型錄與安裝狀態。

社群型錄僅供探索。在直接安裝或加入自己信任的型錄之前，請先審查版本；請參閱[型錄信任模型](catalogs.md#信任模型僅供探索與安裝來源)。

### 瀏覽所有擴充功能

```bash
specify extension search
```

顯示所有使用中型錄（預設為預設型錄與社群型錄）中的全部擴充功能。

### 依關鍵字搜尋

```bash
# Search for "jira"
specify extension search jira

# Search for "issue tracking"
specify extension search issue
```

### 依標籤篩選

```bash
# Find all issue-tracking extensions
specify extension search --tag issue-tracking

# Find all Atlassian tools
specify extension search --tag atlassian
```

### 依作者篩選

```bash
# Extensions by Stats Perform
specify extension search --author "Stats Perform"
```

### 僅顯示已驗證

```bash
# Only show verified extensions
specify extension search --verified
```

### 取得擴充功能詳細資訊

```bash
# Detailed information
specify extension info jira
```

顯示：

- 說明
- 需求
- 提供的命令
- 可用的 hook
- 連結（文件、儲存庫、變更紀錄）
- 安裝狀態

---

## 安裝擴充功能

### 從型錄安裝

```bash
# Install a bundled extension by name
specify extension add github
```

對於由啟用安裝的型錄所宣傳的擴充功能，安裝時會：

1. 下載所宣傳的封存檔（內建擴充功能使用隨附的副本）
2. 驗證資訊清單
3. 檢查與你的 spec-kit 版本的相容性
4. 安裝至 `.specify/extensions/<extension-id>/`
5. 向你的程式代理註冊命令
6. 為已宣告的設定範本建立鷹架，且不覆寫既有的設定

審查 Jira 之後，你控制的型錄可以將它宣傳為可安裝：

```bash
specify extension add jira
```

### 從 URL 安裝

```bash
# From GitHub release
specify extension add <extension-name> --from https://github.com/org/spec-kit-ext/archive/refs/tags/v1.0.0.zip
```

### 從本機目錄安裝（開發用）

```bash
# For testing or development
specify extension add --dev /path/to/extension
```

### 安裝特定的型錄版本

```bash
specify extension info jira --versions
specify extension add jira --version <version>
```

請求的版本必須由勝出的啟用安裝型錄項目宣傳。選取規則與選項限制請參閱 [CLI 參考](cli.md#安裝擴充功能)。

### 安裝輸出

以下為從審查過的來源安裝的 Jira 版本的示意輸出：

```text
✓ Extension installed successfully!

Jira Integration (v1.0.0)
  Create Jira Epics, Stories, and Issues from spec-kit artifacts

Provided commands:
  • speckit-jira-specstoissues - Create Jira hierarchy from spec and tasks
  • speckit-jira-discover-fields - Discover Jira custom fields for configuration
  • speckit-jira-sync-status - Sync task completion status to Jira

⚠  Configuration may be required
   Check: .specify/extensions/jira/
```

---

## 使用擴充功能

### 使用擴充功能命令

擴充功能新增的 skills 會出現在 GitHub Copilot 中：

```text
# In GitHub Copilot
> /speckit-jira-specstoissues
```

### 擴充功能設定

大多數擴充功能需要設定：

```bash
# 1. Find the config file
ls .specify/extensions/jira/

# 2. Copy template to config
cp .specify/extensions/jira/jira-config.template.yml \
   .specify/extensions/jira/jira-config.yml

# 3. Edit configuration
vim .specify/extensions/jira/jira-config.yml

# 4. Use the extension
# (Commands will now work with your config)
```

### 擴充功能 Hook

部分擴充功能提供在核心命令之後執行的 hook：

**範例**：Jira 擴充功能 hook 到 `/speckit-tasks`

```text
# Run core command
> /speckit-tasks

# Output includes:
## Extension Hooks

**Optional Hook**: jira
Command: `/speckit-jira-specstoissues`
Description: Automatically create Jira hierarchy after task generation

Prompt: Create Jira issues from tasks?
To execute: `/speckit-jira-specstoissues`
```

你接著可以選擇執行該 hook 或跳過它。

強制性掛鉤會以自動命令的形式呈現。目前的命令範本使用已設定的 YAML 順序，跳過已停用的掛鉤與條件非空的掛鉤，且不會參考保留的 `auto_execute_hooks` 設定。詳情請參閱[掛鉤設定合約](api.md#hook-設定)。

擴充功能也可以回應程式代理生命週期事件，例如工作階段開始或工具使用。與掛鉤不同，執行時期事件是直接執行指令稿，而非將 Markdown 指示傳送給程式代理。請參閱[擴充功能執行時期事件](api.md#擴充功能執行時期事件)。

---

## 管理擴充功能

### 列出已安裝的擴充功能

```bash
specify extension list
```

輸出：

```text
Installed Extensions:

  ✓ Jira Integration (v1.0.0)
     Create Jira Epics, Stories, and Issues from spec-kit artifacts
     Commands: 3 | Hooks: 1 | Status: Enabled
```

### 更新擴充功能

```bash
# Check for updates (all extensions)
specify extension update

# Update specific extension
specify extension update jira
```

輸出：

```text
🔄 Checking for updates...

Updates available:

  • jira: 1.0.0 → 1.1.0

Update these extensions? [y/N]:
```

### 暫時停用擴充功能

```bash
# Disable without removing
specify extension disable jira
```

宣告式掛鉤會在 `.specify/extensions.yml` 中標記為停用。接著會盡力重新整理原生執行時期事件設定。重新整理失敗會產生警告，但可能讓過時的原生掛鉤保持啟用並可執行。請以 `specify integration upgrade <key>` 重試受影響的整合。以 `specify extension enable jira` 重新啟用擴充功能。

對於通用整合，停用也會移除所屬的命令或技能檔案。
其他整合可以保留仍可呼叫的已產生檔案，
直到整合切換、解除安裝或協調將它們移除為止。
已停用的擴充功能會排除在登錄檔驅動的成品解析與
未來的整合註冊之外；停用並非通用的檔案移除或
執行阻擋機制。

### 重新啟用擴充功能

```bash
specify extension enable jira

✓ Extension 'jira' enabled
```

### 移除擴充功能

```bash
# Remove extension (with confirmation)
specify extension remove jira

# Keep configuration when removing
specify extension remove jira --keep-config

# Force removal (no confirmation)
specify extension remove jira --force
```

---

## 設定

### 設定檔

擴充功能可以有多個設定檔：

```text
.specify/extensions/jira/
├── jira-config.yml           # Main config (version controlled)
├── local-config.yml         # Local overrides (gitignored)
└── jira-config.template.yml  # Template (reference)
```

### 設定層級

設定依以下順序合併（最後者優先順序最高）：

1. **擴充功能預設值**（頂層 `defaults` 與 `config.defaults` 合併，
   衝突時以 `config.defaults` 為準）
2. **專案設定**（`jira-config.yml`）
3. **本機覆寫**（`local-config.yml`）
4. **環境變數**（`SPECKIT_JIRA_*`）

### 範例：Jira 設定

**專案設定**（`.specify/extensions/jira/jira-config.yml`）：

```yaml
project:
  key: "MSATS"

defaults:
  epic:
    labels: ["spec-driven"]
```

**本機覆寫**（`.specify/extensions/jira/local-config.yml`）：

```yaml
project:
  key: "MYTEST"  # Override for local development
```

**環境變數**：

```bash
export SPECKIT_JIRA_PROJECT_KEY="DEVTEST"
```

當擴充功能使用 `ConfigManager` 或對等的載入方式時，最終解析的設定會使用環境變數中的 `DEVTEST`。
Spec Kit 不會自動將合併後的設定注入任意命令或指令稿；
擴充功能必須自行載入。YAML `${...}` 字串不會由 `ConfigManager` 內插。
請參閱[設定載入](developing.md#設定載入)。

### 專案層級的擴充功能設定

檔案：`.specify/extensions.yml`

```yaml
# Extensions installed in this project
installed:
  - jira
  - linear

# Global settings
settings:
  auto_execute_hooks: true  # Reserved; currently not consulted

# Hook configuration
# Available events: before_specify, after_specify, before_plan, after_plan,
#                   before_tasks, after_tasks, before_implement, after_implement,
#                   before_analyze, after_analyze, before_checklist, after_checklist,
#                   before_clarify, after_clarify, before_constitution, after_constitution,
#                   before_converge, after_converge,
# Bundled bug extension events (when installed):
#                   before_bug_assess, after_bug_assess, before_bug_fix, after_bug_fix,
#                   before_bug_test, after_bug_test
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"
```

所有欄位與目前的執行限制，請參閱[掛鉤設定合約](api.md#hook-設定)。

---

## 疑難排解

### 找不到擴充功能

**錯誤**：`Extension 'jira' not found in catalog`

**解決方法**：

1. 檢查拼字：`specify extension search jira`
2. 檢查使用中的型錄：`specify extension catalog list`
3. 檢查網路連線
4. 擴充功能可能尚未發佈

`specify extension search --help` 會顯示說明；它不會重新整理快取的型錄資料。型錄快取通常在一小時後過期。Python 呼叫者可以明確以 `ExtensionCatalog.clear_cache()` 清除它們。

### 找不到設定

**錯誤**：`Jira configuration not found`

**解決方法**：

1. 檢查擴充功能是否已安裝：`specify extension list`
2. 從範本建立設定：

   ```bash
   cp .specify/extensions/jira/jira-config.template.yml \
      .specify/extensions/jira/jira-config.yml
   ```

3. 重新安裝擴充功能：`specify extension remove jira && specify extension add jira`

### 命令無法使用

**問題**：擴充功能命令未出現在程式代理中

**解決方法**：

1. 檢查擴充功能已啟用：`specify extension list`
2. 重新啟動 GitHub Copilot
3. 檢查 skill 檔案是否存在：

   ```bash
   ls .github/skills/speckit-jira-*/SKILL.md
   ```

4. 重新安裝擴充功能

### 版本不相容

**錯誤**：`Extension requires spec-kit >=0.2.0, but you have 0.1.0`

**解決方法**：

1. 升級 spec-kit：

   ```bash
   uv tool upgrade specify-cli
   ```

2. 安裝較舊版本的擴充功能：

   ```bash
   specify extension add <extension-name> --from https://github.com/org/ext/archive/v1.0.0.zip
   ```

### MCP 工具無法使用

**錯誤**：`Tool 'jira-mcp-server/epic_create' not found`

**解決方法**：

1. 檢查 MCP 伺服器已安裝
2. 檢查程式代理的 MCP 設定
3. 重新啟動程式代理
4. 檢查擴充功能需求：`specify extension info jira`

### 權限被拒

**錯誤**：存取 Jira 時出現 `Permission denied`

**解決方法**：

1. 檢查 MCP 伺服器設定中的 Jira 憑證
2. 驗證 Jira 中的專案權限
3. 獨立測試 MCP 伺服器連線

---

## 最佳實務

### 1. 版本控制

**應提交**：

- `.specify/extensions.yml`（專案擴充功能設定）
- `.specify/extensions/*/jira-config.yml`（專案設定）

**不應提交**：

- `.specify/extensions/.cache/`（型錄快取）
- `.specify/extensions/.backup/`（設定備份）
- `.specify/extensions/*/local-config.yml`（本機覆寫）
- `.specify/extensions/.registry`（安裝狀態）

加入 `.gitignore`：

```gitignore
.specify/extensions/.cache/
.specify/extensions/.backup/
.specify/extensions/*/local-config.yml
.specify/extensions/.registry
```

### 2. 團隊工作流程

**對於團隊**：

1. 就要使用的擴充功能達成共識
2. 提交擴充功能設定
3. 在 README 中記錄擴充功能用法
4. 一起保持擴充功能為最新

**README 區段範例**：

```markdown
## Extensions

This project uses:
- **jira** (v1.0.0) - Jira integration
  - Config: `.specify/extensions/jira/jira-config.yml`
  - Requires: jira-mcp-server

To install: `specify extension add jira`
```

### 3. 本機開發

使用本機設定進行開發：

```yaml
# .specify/extensions/jira/local-config.yml
project:
  key: "DEVTEST"  # Your test project

defaults:
  task:
    custom_fields:
      customfield_10002: 1  # Lower story points for testing
```

### 4. 環境專屬設定

在 CI/CD 中使用環境變數：

```bash
# .github/workflows/deploy.yml
env:
  SPECKIT_JIRA_PROJECT_KEY: ${{ secrets.JIRA_PROJECT }}

- name: Create Jira Issues
  run: specify extension add jira && ...
```

### 5. 擴充功能更新

**定期檢查更新**：

```bash
# Weekly or before major releases
specify extension update
```

**為可重現的安裝選取確切的型錄版本**：

```bash
specify extension add jira --version 1.0.0
```

請為你的團隊記錄安裝命令。`.specify/extensions.yml` 中的 `installed` 清單不是版本鎖定機制；明確執行 `update` 可能會安裝較新的版本。

### 6. 最小化擴充功能

只安裝你實際使用的擴充功能：

- 降低複雜度
- 加快命令載入
- 減少設定

### 7. 文件

在你的專案中記錄擴充功能用法：

```markdown
# PROJECT.md

## Working with Jira

After creating tasks, sync to Jira:
1. Run `/speckit-tasks` to generate tasks
2. Run `/speckit-jira-specstoissues` to create Jira issues
3. Run `/speckit-jira-sync-status` to update status
```

---

## 常見問題

### Q：我可以同時使用多個擴充功能嗎？

**A**：可以！擴充功能設計為能協同運作。依需要安裝任意數量。

### Q：擴充功能會拖慢 spec-kit 嗎？

**A**：擴充功能的中繼資料會在列出、安裝與成品解析等操作期間讀取。掛鉤可以在 Spec Kit 命令周圍加入工作，執行時期事件可以在程式代理生命週期事件期間執行指令稿。其成本取決於已安裝的擴充功能與設定的行為。

### Q：我可以建立私有擴充功能嗎？

**A**：可以。使用 `--dev` 或 `--from` 安裝並保持私有。提交到公開型錄是選用的。

### Q：我如何知道擴充功能是否安全？

**A**：已驗證徽章並非程式碼稽核的保證。Spec Kit 維護者不會審查、稽核、背書或支援獨立維護的擴充功能程式碼。安裝前必須審查來源與發行封存檔；請自行斟酌使用擴充功能。

### Q：擴充功能可以修改 spec-kit 核心嗎？

**A**：擴充功能無需變更 Spec Kit 的原始碼，即可貢獻命令、範本、指令稿、掛鉤與執行時期事件。它們的命令與掛鉤可以在其記載的行為與專案治理之下編輯專案檔案；請參閱[規格成品維護](#規格成品維護)。

### Q：如果兩個擴充功能有相同的命令名稱怎麼辦？

**A**：具命名空間的命令（`speckit.{extension}.{command}`）可減少衝突。安裝時會拒絕與已安裝擴充功能完全相同的命令名稱或別名衝突，以及與核心命令正規化輸出名稱的衝突。解析優先順序決定貢獻成品（例如範本）的優先次序；它不允許安裝衝突的命令名稱。使用 [`specify extension set-priority`](cli.md#設定擴充功能優先順序) 變更成品解析優先順序。

### Q：我可以為既有擴充功能貢獻嗎？

**A**：可以！大多數擴充功能都是開放原始碼。請查看 `specify extension info {extension}` 中的儲存庫連結。

### Q：我如何回報擴充功能錯誤？

**A**：前往擴充功能的儲存庫（在 `specify extension info` 中顯示）並建立 issue。

### Q：擴充功能可以離線運作嗎？

**A**：安裝後，擴充功能可離線運作。不過，部分擴充功能的功能可能需要網路（例如 Jira 需要存取 Jira API）。

### Q：我如何備份擴充功能設定？

**A**：擴充功能設定位於 `.specify/extensions/{extension}/`。請備份此目錄或將設定提交到 git。

---

## 支援

- **擴充功能 Issue**：回報到擴充功能儲存庫（見 `specify extension info`）
- **Spec Kit Issue**：<https://github.com/github/spec-kit/issues>
- **擴充功能型錄**：<https://github.com/github/spec-kit/tree/main/extensions>
- **文件**：參閱[開發擴充功能](developing.md)與[擴充功能發佈指南](publishing.md)

---

*最後更新：2026-01-28*
*Spec Kit 版本：0.1.0*

> 本頁的代理呼叫範例使用 GitHub Copilot 的預設 skills 語法（`/speckit-*`）。其他整合與模式，請參閱[命令呼叫](../integrations/cli.md#命令呼叫方式)。

## 另請參閱

- [擴充功能 CLI 參考](cli.md)
- [擴充功能型錄](catalogs.md)
- [社群擴充功能](../community/extensions.md)
- [開發擴充功能](developing.md)
- [擴充功能 API 參考](api.md)
- [發佈擴充功能](publishing.md)
- [持久化規格](../how-to/persisting-specs.md)
