# 擴充功能概覽

使用 Spec Kit 擴充功能強化工作流程的完整指南。

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

---

## 開始使用

### 必要條件

- Spec Kit 0.1.0 或更高版本
- spec-kit 專案（包含 `.specify/` 資料夾的目錄）

### 檢查你的版本

```bash
specify version
# Should show 0.1.0 or higher
```

### 第一個擴充功能

以安裝 Jira 擴充功能為例：

```bash
# 1. Search for the extension
specify extension search jira

# 2. Get detailed information
specify extension info jira

# 3. Install it
specify extension add jira

# 4. Configure it
vim .specify/extensions/jira/jira-config.yml

# 5. Use it
# (Skills are now available in GitHub Copilot)
/speckit-jira-specstoissues
```

---

## 尋找擴充功能

`specify extension search` 會同時搜尋**所有使用中的型錄**，預設包含社群型錄。結果會註記來源型錄與安裝狀態。

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
# By name (from catalog)
specify extension add jira
```

這將會：

1. 從 GitHub 下載擴充功能
2. 驗證資訊清單
3. 檢查與你的 spec-kit 版本的相容性
4. 安裝到 `.specify/extensions/jira/`
5. 向你的程式代理註冊命令
6. 建立設定範本

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

### 安裝輸出

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

✓ Extension 'jira' disabled

Commands will no longer be available. Hooks will not execute.
To re-enable: specify extension enable jira
```

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

1. **擴充功能預設值**（來自 `extension.yml`）
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

最終解析的設定使用環境變數中的 `DEVTEST`。

### 專案層級的擴充功能設定

檔案：`.specify/extensions.yml`

```yaml
# Extensions installed in this project
installed:
  - jira
  - linear

# Global settings
settings:
  auto_execute_hooks: true

# Hook configuration
# Available events: before_specify, after_specify, before_plan, after_plan,
#                   before_tasks, after_tasks, before_implement, after_implement,
#                   before_analyze, after_analyze, before_checklist, after_checklist,
#                   before_clarify, after_clarify, before_constitution, after_constitution,
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

### 核心環境變數

除了擴充功能專屬環境變數（`SPECKIT_{EXT_ID}_*`）外，spec-kit 也支援核心環境變數：

| 變數 | 說明 | 預設值 |
|----------|-------------|---------|
| `SPECKIT_CATALOG_URL`       | 以單一 URL 覆寫完整型錄堆疊（向後相容） | 內建預設堆疊 |
| `GH_TOKEN` / `GITHUB_TOKEN` | 用於向 GitHub 託管 URL（`raw.githubusercontent.com`、`github.com`、`api.github.com`、`codeload.github.com`）發出已驗證請求的 GitHub 權杖。當你的型錄 JSON 或擴充功能 ZIP 託管在私有 GitHub 儲存庫時必填。 | 無 |

#### 範例：使用自訂型錄進行測試

```bash
# Point to a local or alternative catalog (replaces the full stack)
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"

# Or use a staging catalog
export SPECKIT_CATALOG_URL="https://example.com/staging/catalog.json"
```

#### 範例：使用私有 GitHub 託管型錄

```bash
# Authenticate with a token (gh CLI, PAT, or GITHUB_TOKEN in CI)
export GITHUB_TOKEN=$(gh auth token)

# Search a private catalog added via `specify extension catalog add`
specify extension search jira

# Install from a private catalog
specify extension add jira-sync
```

權杖會自動附加到以 GitHub 網域為目標的請求。非 GitHub 型錄 URL 一律在不帶憑證的情況下擷取。

---

## 擴充功能型錄

Spec Kit 使用**型錄堆疊**——一份同時搜尋的有序型錄清單。預設有兩個型錄啟用中：

| 優先順序 | 型錄 | 允許安裝 | 用途 |
|----------|---------|-----------------|---------|
| 1 | `catalog.json`（預設） | ✅ 是 | 可安裝的精選擴充功能 |
| 2 | `catalog.community.json`（社群） | ❌ 否（僅供探索） | 瀏覽社群擴充功能 |

### 列出使用中的型錄

```bash
specify extension catalog list
```

### 透過 CLI 管理型錄

你可以使用 `--help` 查看主要的型錄管理命令：

```text
specify extension catalog --help

 Usage: specify extension catalog [OPTIONS] COMMAND [ARGS]...

 Manage extension catalogs
╭─ Options ────────────────────────────────────────────────────────────────────────╮
│ --help          Show this message and exit.                                      │
╰──────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands ───────────────────────────────────────────────────────────────────────╮
│ list     List all active extension catalogs.                                     │
│ add      Add a catalog to .specify/extension-catalogs.yml.                       │
│ remove   Remove a catalog from .specify/extension-catalogs.yml.                  │
╰──────────────────────────────────────────────────────────────────────────────────╯
```

### 新增型錄（專案範疇）

```bash
# Add an internal catalog that allows installs
specify extension catalog add \
  --name "internal" \
  --priority 2 \
  --install-allowed \
  https://internal.company.com/spec-kit/catalog.json

# Add a discovery-only catalog
specify extension catalog add \
  --name "partner" \
  --priority 5 \
  https://partner.example.com/spec-kit/catalog.json
```

這會建立或更新 `.specify/extension-catalogs.yml`。

### 移除型錄

```bash
specify extension catalog remove internal
```

### 手動設定檔

你也可以直接編輯 `.specify/extension-catalogs.yml`：

```yaml
catalogs:
  - name: "default"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json"
    priority: 1
    install_allowed: true
    description: "Built-in catalog of installable extensions"

  - name: "internal"
    url: "https://internal.company.com/spec-kit/catalog.json"
    priority: 2
    install_allowed: true
    description: "Internal company extensions"

  - name: "community"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json"
    priority: 3
    install_allowed: false
    description: "Community-contributed extensions (discovery only)"
```

使用者層級的對應檔案位於 `~/.specify/extension-catalogs.yml`。當專案層級設定包含一個以上型錄條目時，它具有完全優先權。空的 `catalogs: []` 清單會回退到內建預設值。

## 組織型錄自訂

### 為什麼自訂你的型錄

組織自訂型錄是為了：

- **控制可用的擴充功能**——精選團隊可安裝的擴充功能
- **託管私有擴充功能**——不應公開的內部工具
- **依合規自訂**——符合安全性／稽核要求
- **支援氣隙環境**——在無網路存取的情況下運作

### 設定自訂型錄

#### 1. 建立你的型錄檔案

建立包含你擴充功能的 `catalog.json` 檔案：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-02-03T00:00:00Z",
  "catalog_url": "https://your-org.com/spec-kit/catalog.json",
  "extensions": {
    "jira": {
      "name": "Jira Integration",
      "id": "jira",
      "description": "Create Jira issues from spec-kit artifacts",
      "author": "Your Organization",
      "version": "2.1.0",
      "download_url": "https://github.com/your-org/spec-kit-jira/archive/refs/tags/v2.1.0.zip",
      "repository": "https://github.com/your-org/spec-kit-jira",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0",
        "tools": [
          {"name": "atlassian-mcp-server", "required": true}
        ]
      },
      "provides": {
        "commands": 3,
        "hooks": 1
      },
      "tags": ["jira", "atlassian", "issue-tracking"],
      "verified": true
    },
    "internal-tool": {
      "name": "Internal Tool Integration",
      "id": "internal-tool",
      "description": "Connect to internal company systems",
      "author": "Your Organization",
      "version": "1.0.0",
      "download_url": "https://internal.your-org.com/extensions/internal-tool-1.0.0.zip",
      "repository": "https://github.internal.your-org.com/spec-kit-internal",
      "license": "Proprietary",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "provides": {
        "commands": 2
      },
      "tags": ["internal", "proprietary"],
      "verified": true
    }
  }
}
```

#### 2. 託管型錄

託管型錄的選項：

| 方法 | URL 範例 | 使用案例 |
| ------ | ----------- | -------- |
| GitHub Pages | `https://your-org.github.io/spec-kit-catalog/catalog.json` | 公開或組織可見 |
| 內部網頁伺服器 | `https://internal.company.com/spec-kit/catalog.json` | 企業網路 |
| S3／雲端儲存 | `https://s3.amazonaws.com/your-bucket/catalog.json` | 雲端託管團隊 |
| 本機檔案伺服器 | `http://localhost:8000/catalog.json` | 開發／測試 |

**安全性要求**：URL 必須使用 HTTPS（測試用的 `localhost` 除外）。

#### 3. 設定你的環境

##### 選項 A：型錄堆疊設定檔（建議）

在你的專案中加入 `.specify/extension-catalogs.yml`：

```yaml
catalogs:
  - name: "my-org"
    url: "https://your-org.com/spec-kit/catalog.json"
    priority: 1
    install_allowed: true
```

或使用 CLI：

```bash
specify extension catalog add \
  --name "my-org" \
  --install-allowed \
  https://your-org.com/spec-kit/catalog.json
```

##### 選項 B：環境變數（建議用於 CI/CD，單一型錄）

```bash
# In ~/.bashrc, ~/.zshrc, or CI pipeline
export SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json"
```

#### 4. 驗證設定

```bash
# List active catalogs
specify extension catalog list

# Search should now show your catalog's extensions
specify extension search

# Install from your catalog
specify extension add jira
```

### 型錄 JSON 結構描述

每個擴充功能條目的必填欄位：

| 欄位 | 類型 | 必填 | 說明 |
| ----- | ---- | -------- | ----------- |
| `name` | string | 是 | 方便閱讀的名稱 |
| `id` | string | 是 | 唯一識別碼（小寫、連字號） |
| `version` | string | 是 | 語意化版本（X.Y.Z） |
| `download_url` | string | 是 | ZIP 封存檔的 URL |
| `repository` | string | 是 | 原始碼 URL |
| `description` | string | 否 | 簡短說明 |
| `author` | string | 否 | 作者／組織 |
| `license` | string | 否 | SPDX 授權識別碼 |
| `requires.speckit_version` | string | 否 | 版本限制 |
| `requires.tools` | array | 否 | 所需的外部工具 |
| `provides.commands` | number | 否 | 命令數量 |
| `provides.hooks` | number | 否 | hook 數量 |
| `tags` | array | 否 | 搜尋標籤 |
| `verified` | boolean | 否 | 驗證狀態 |

### 使用案例

#### 私有／內部擴充功能

託管與內部系統整合的專有擴充功能：

```json
{
  "internal-auth": {
    "name": "Internal SSO Integration",
    "download_url": "https://artifactory.company.com/spec-kit/internal-auth-1.0.0.zip",
    "verified": true
  }
}
```

#### 精選團隊型錄

限制團隊可安裝的擴充功能：

```json
{
  "extensions": {
    "jira": { "..." },
    "github": { "..." }
  }
}
```

只有 `jira` 與 `github` 會出現在 `specify extension search` 中。

#### 氣隙環境

對於無網路存取的網路：

1. 將擴充功能 ZIP 下載到內部檔案伺服器
2. 建立指向內部 URL 的型錄
3. 將型錄託管在內部網頁伺服器上

```json
{
  "jira": {
    "download_url": "https://files.internal/spec-kit/jira-2.1.0.zip"
  }
}
```

#### 開發／測試

在發佈前測試新擴充功能：

```bash
# Start local server
python -m http.server 8000 --directory ./my-catalog/

# Point spec-kit to local catalog
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"

# Test installation
specify extension add my-new-extension
```

### 與直接安裝並用

你仍可使用 `--from` 安裝不在型錄中的擴充功能：

```bash
# From catalog
specify extension add jira

# Direct URL (bypasses catalog)
specify extension add <extension-name> --from https://github.com/someone/spec-kit-ext/archive/v1.0.0.zip

# Local development
specify extension add --dev /path/to/extension
```

**注意**：直接以 URL 安裝會顯示安全性警告，因為該擴充功能並非來自你設定的型錄。

---

## 疑難排解

### 找不到擴充功能

**錯誤**：`Extension 'jira' not found in catalog

**解決方法**：

1. 檢查拼字：`specify extension search jira`
2. 重新整理型錄：`specify extension search --help`
3. 檢查網路連線
4. 擴充功能可能尚未發佈

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

**釘選版本以求穩定**：

```yaml
# .specify/extensions.yml
installed:
  - id: jira
    version: "1.0.0"  # Pin to specific version
```

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

**A**：不會。擴充功能按需載入，且只在使用其命令時載入。

### Q：我可以建立私有擴充功能嗎？

**A**：可以。使用 `--dev` 或 `--from` 安裝並保持私有。提交到公開型錄是選用的。

### Q：我如何知道擴充功能是否安全？

**A**：尋找 ✓ 已驗證徽章。已驗證的擴充功能經過維護者審查。安裝前請一律審查擴充功能程式碼。

### Q：擴充功能可以修改 spec-kit 核心嗎？

**A**：不行。擴充功能只能新增命令與 hook。它們無法修改核心功能。

### Q：如果兩個擴充功能有相同的命令名稱怎麼辦？

**A**：擴充功能使用具命名空間的命令（`speckit.{extension}.{command}`），因此衝突非常罕見。若發生衝突，擴充功能系統會警告你。

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

> 本頁的代理呼叫範例使用 GitHub Copilot 的預設 skills 語法（`/speckit-*`）。其他整合與模式，請參閱[命令呼叫](../integrations/cli.md#command-invocation)。
