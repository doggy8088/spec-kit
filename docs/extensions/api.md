# 擴充功能 API 參考

Spec Kit 擴充功能系統 API 與資訊清單結構描述的技術參考。

## 目錄

1. [擴充功能資訊清單](#擴充功能資訊清單)
2. [Python API](#python-api)
3. [命令檔案格式](#命令檔案格式)
4. [設定結構描述](#設定結構描述)
5. [Hook 系統](#hook-系統)
6. [CLI 命令](#cli-命令)

---

## 擴充功能資訊清單

### 結構描述版本 1.0

檔案：`extension.yml`

```yaml
schema_version: "1.0"  # Required

extension:
  id: string           # Required, pattern: ^[a-z0-9-]+$
  name: string         # Required, human-readable name
  version: string      # Required, semantic version (X.Y.Z)
  description: string  # Required, brief description (<200 chars)
  author: string       # Required
  repository: string   # Required, valid URL
  license: string      # Required (e.g., "MIT", "Apache-2.0")
  homepage: string     # Optional, valid URL

requires:
  speckit_version: string  # Required, version specifier (>=X.Y.Z)
  tools:                   # Optional, array of tool requirements
    - name: string         # Tool name
      version: string      # Optional, version specifier
      required: boolean    # Optional, default: false

provides:
  commands:              # At least one of commands/templates/scripts/hooks/events required
    - name: string       # Required, pattern: ^speckit\.[a-z0-9-]+\.[a-z0-9-]+$
      file: string       # Required, relative path to command file
      description: string # Required

  templates:             # Optional, array of declared templates. Always resolve
                          # as "replace" -- 'strategy' is not an authorable field here.
    - name: string       # Required, pattern: ^[a-z0-9-]+$
      file: string       # Required, relative path to template file
      description: string # Optional

  scripts:               # Optional, array of declared scripts. Always resolve
                          # as "replace" -- 'strategy' is not an authorable field here.
    - name: string       # Required, pattern: ^[a-z0-9-]+$
      file: string       # Required, relative path to script file
      description: string # Optional
      runtimes: [string] # Optional, subset of: bash, powershell, python

  config:                # Optional, array of config files
    - name: string       # Config file name
      template: string   # Template file path
      description: string
      required: boolean  # Default: false

hooks:                   # Optional, event hooks. Each event accepts either form below.
  event_name:            # e.g., "after_specify", "after_plan", "after_tasks", "after_implement"
    command: string      # Command to execute
    priority: integer    # Optional, >= 1, default 10 (lower runs first)
    optional: boolean    # Default: true
    prompt: string       # Prompt text for optional hooks
    description: string  # Hook description
    condition: string    # Optional, condition expression
  another_event:         # Any event may instead use a list of mappings (multiple commands)
    - command: string    # Same fields as the single mapping, per entry
      priority: integer
    - command: string
      priority: integer

tags:                    # Optional, array of tags (2-10 recommended)
  - string

defaults:                # Optional, default configuration values
  key: value             # Any YAML structure
```

### 欄位規格

#### `extension.id`

- **類型**：string
- **模式**：`^[a-z0-9-]+$`
- **說明**：唯一的擴充功能識別碼
- **範例**：`jira`、`linear`、`azure-devops`
- **無效**：`Jira`、`my_extension`、`extension.id`

#### `extension.version`

- **類型**：string
- **格式**：語意化版本（X.Y.Z）
- **說明**：擴充功能版本
- **範例**：`1.0.0`、`0.9.5`、`2.1.3`
- **無效**：`v1.0`、`1.0`、`1.0.0-beta`

#### `requires.speckit_version`

- **類型**：string
- **格式**：版本指定子
- **說明**：所需的 spec-kit 版本範圍
- **範例**：
  - `>=0.1.0`——0.1.0 或更高版本
  - `>=0.1.0,<2.0.0`——0.1.x 或 1.x 版本
  - `==0.1.0`——恰好 0.1.0
- **無效**：`0.1.0`、`>= 0.1.0`（空格）、`latest`

#### `provides.commands[].name`

- **類型**：string
- **模式**：`^speckit\.[a-z0-9-]+\.[a-z0-9-]+$`
- **說明**：具命名空間的命令名稱
- **格式**：`speckit.{extension-id}.{command-name}`
- **範例**：`speckit.jira.specstoissues`、`speckit.linear.sync`
- **無效**：`jira.specstoissues`、`speckit.command`、`speckit.jira.CreateIssues`

#### `provides.templates[].name` / `provides.scripts[].name`

- **類型**：string
- **模式**：`^[a-z0-9-]+$`
- **說明**：與命令不同，範本與指令碼不是依名稱呼叫，因此它們使用與 `extension.id` 相同的純 slug 模式，而非具命名空間的命令模式。
- **範例**：`myext-template`、`myext-collect`

#### `provides.templates[].strategy` / `provides.scripts[].strategy`

- 不是可撰寫的欄位。擴充功能提供的範本與指令碼一律解析為 `replace`；若資訊清單在其中一個條目上包含 `strategy` 鍵，將以 `ValidationError` 拒絕。可組合策略（`wrap`/`prepend`/`append`）僅供預設集使用。

#### `provides.scripts[].runtimes`

- **類型**：字串陣列
- **值**：`bash`、`powershell`、`python`
- **說明**：宣告指令碼支援的執行環境。純粹是資訊性後設資料——不用於選擇或呼叫指令碼。

#### `hooks`

- **類型**：object
- **鍵**：事件名稱（例如 `after_specify`、`after_plan`、`after_tasks`、`after_implement`、`before_analyze`）
- **值**：單一 hook 對應，或 hook 對應清單（在一個事件上註冊多個命令）
- **說明**：在生命週期事件執行的 hook
- **事件**：由核心 spec-kit 命令定義
- **順序**：在一個事件內，hook 依 `priority` 遞增執行（整數 ≥ 1，預設 10；數字越小越先執行；優先順序相同時透過穩定排序保留撰寫順序）

---

## Python API

### ExtensionManifest

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionManifest

manifest = ExtensionManifest(Path("extension.yml"))
```

**屬性**：

```python
manifest.id                        # str: Extension ID
manifest.name                      # str: Extension name
manifest.version                   # str: Version
manifest.description               # str: Description
manifest.requires_speckit_version  # str: Required spec-kit version
manifest.commands                  # List[Dict]: Command definitions
manifest.templates                 # List[Dict]: Declared template definitions
manifest.scripts                   # List[Dict]: Declared script definitions
manifest.hooks                     # Dict: Hook definitions
```

**方法**：

```python
manifest.get_hash()  # str: SHA256 hash of manifest file
```

**例外**：

```python
ValidationError       # Invalid manifest structure
CompatibilityError    # Incompatible with current spec-kit version
```

### ExtensionRegistry

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionRegistry

registry = ExtensionRegistry(extensions_dir)
```

**方法**：

```python
# Add extension to registry
registry.add(extension_id: str, metadata: dict)

# Remove extension from registry
registry.remove(extension_id: str)

# Get extension metadata
metadata = registry.get(extension_id: str)  # Optional[dict]

# List all extensions
extensions = registry.list()  # Dict[str, dict]

# Check if installed
is_installed = registry.is_installed(extension_id: str)  # bool
```

**登錄格式**：

```json
{
  "schema_version": "1.0",
  "extensions": {
    "jira": {
      "version": "1.0.0",
      "source": "catalog",
      "manifest_hash": "sha256...",
      "enabled": true,
      "registered_commands": ["speckit.jira.specstoissues", ...],
      "installed_at": "2026-01-28T..."
    }
  }
}
```

### ExtensionManager

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionManager

manager = ExtensionManager(project_root)
```

**方法**：

```python
# Install from directory
manifest = manager.install_from_directory(
    source_dir: Path,
    speckit_version: str,
    register_commands: bool = True
)  # Returns: ExtensionManifest

# Install from ZIP
manifest = manager.install_from_zip(
    zip_path: Path,
    speckit_version: str
)  # Returns: ExtensionManifest

# Remove extension
success = manager.remove(
    extension_id: str,
    keep_config: bool = False
)  # Returns: bool

# List installed extensions
extensions = manager.list_installed()  # List[Dict]

# Get extension manifest
manifest = manager.get_extension(extension_id: str)  # Optional[ExtensionManifest]

# Check compatibility
manager.check_compatibility(
    manifest: ExtensionManifest,
    speckit_version: str
)  # Raises: CompatibilityError if incompatible
```

### CatalogEntry

**模組**：`specify_cli.extensions`

表示使用中目錄堆疊中的單一目錄。

```python
from specify_cli.extensions import CatalogEntry

entry = CatalogEntry(
    url="https://example.com/catalog.json",
    name="default",
    priority=1,
    install_allowed=True,
    description="Built-in catalog of installable extensions",
)
```

**欄位**：

| 欄位 | 類型 | 說明 |
|-------|------|-------------|
| `url` | `str` | 目錄 URL（必須使用 HTTPS，或 localhost 使用 HTTP） |
| `name` | `str` | 方便閱讀的目錄名稱 |
| `priority` | `int` | 排序順序（數字越小優先順序越高，衝突時勝出） |
| `install_allowed` | `bool` | 是否可安裝此目錄的擴充功能 |
| `description` | `str` | 目錄的選用說明（預設：空） |

### ExtensionCatalog

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionCatalog

catalog = ExtensionCatalog(project_root)
```

**類別屬性**：

```python
ExtensionCatalog.DEFAULT_CATALOG_URL    # default catalog URL
ExtensionCatalog.COMMUNITY_CATALOG_URL  # community catalog URL
```

**方法**：

```python
# Get the ordered list of active catalogs
entries = catalog.get_active_catalogs()  # List[CatalogEntry]

# Fetch catalog (primary catalog, backward compat)
catalog_data = catalog.fetch_catalog(force_refresh: bool = False)  # Dict

# Search extensions across all active catalogs
# Each result includes _catalog_name and _install_allowed
results = catalog.search(
    query: Optional[str] = None,
    tag: Optional[str] = None,
    author: Optional[str] = None,
    verified_only: bool = False
)  # Returns: List[Dict]  — each dict includes _catalog_name, _install_allowed

# Get extension info (searches all active catalogs)
# Returns None if not found; includes _catalog_name and _install_allowed
ext_info = catalog.get_extension_info(extension_id: str)  # Optional[Dict]

# Check cache validity (primary catalog)
is_valid = catalog.is_cache_valid()  # bool

# Clear all catalog caches
catalog.clear_cache()
```

**結果註記欄位**：

`search()` 與 `get_extension_info()` 回傳的每個擴充功能 dict 都包含：

| 欄位 | 類型 | 說明 |
|-------|------|-------------|
| `_catalog_name` | `str` | 來源目錄的名稱 |
| `_install_allowed` | `bool` | 是否允許從此目錄安裝 |

**目錄設定檔**（`.specify/extension-catalogs.yml`）：

```yaml
catalogs:
  - name: "default"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json"
    priority: 1
    install_allowed: true
    description: "Built-in catalog of installable extensions"
  - name: "community"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json"
    priority: 2
    install_allowed: false
    description: "Community-contributed extensions (discovery only)"
```

### HookExecutor

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import HookExecutor

hook_executor = HookExecutor(project_root)
```

**方法**：

```python
# Get project config
config = hook_executor.get_project_config()  # Dict

# Save project config
hook_executor.save_project_config(config: Dict)

# Register hooks
hook_executor.register_hooks(manifest: ExtensionManifest)

# Unregister hooks
hook_executor.unregister_hooks(extension_id: str)

# Get hooks for event
hooks = hook_executor.get_hooks_for_event(event_name: str)  # List[Dict]

# Check if hook should execute
should_run = hook_executor.should_execute_hook(hook: Dict)  # bool

# Format hook message
message = hook_executor.format_hook_message(
    event_name: str,
    hooks: List[Dict]
)  # str
```

### CommandRegistrar

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import CommandRegistrar

registrar = CommandRegistrar()
```

**方法**：

```python
# Register commands for Claude Code
registered = registrar.register_commands_for_claude(
    manifest: ExtensionManifest,
    extension_dir: Path,
    project_root: Path
)  # Returns: List[str] (command names)

# Parse frontmatter
frontmatter, body = registrar.parse_frontmatter(content: str)

# Render frontmatter
yaml_text = registrar.render_frontmatter(frontmatter: Dict)  # str
```

---

## 命令檔案格式

### 通用命令格式

**檔案**：`commands/{command-name}.md`

```markdown
---
description: "Command description"
tools:
  - 'mcp-server/tool_name'
  - 'other-mcp-server/other_tool'
---

# Command Title

Command documentation in Markdown.

## Prerequisites

1. Requirement 1
2. Requirement 2

## User Input

$ARGUMENTS

## Steps

### Step 1: Description

Instruction text...

\`\`\`bash
# Shell commands
\`\`\`

### Step 2: Another Step

More instructions...

## Configuration Reference

Information about configuration options.

## Notes

Additional notes and tips.
```

### Frontmatter 欄位

```yaml
description: string   # Required, brief command description
tools: [string]       # Optional, MCP tools required
```

### 特殊變數

- `$ARGUMENTS`——使用者提供參數的佔位符
- 自動注入的擴充功能上下文：

  ```markdown
  <!-- Extension: {extension-id} -->
  <!-- Config: .specify/extensions/{extension-id}/ -->
  ```

---

## 設定結構描述

### 擴充功能設定檔

**檔案**：`.specify/extensions/{extension-id}/{extension-id}-config.yml`

擴充功能自行定義設定結構描述。常見模式：

```yaml
# Connection settings
connection:
  url: string
  api_key: string

# Project settings
project:
  key: string
  workspace: string

# Feature flags
features:
  enabled: boolean
  auto_sync: boolean

# Defaults
defaults:
  labels: [string]
  assignee: string

# Custom fields
field_mappings:
  internal_name: "external_field_id"
```

### 設定層級

1. **擴充功能預設值**（來自 `extension.yml` 的 `defaults` 區段）
2. **專案設定**（`{extension-id}-config.yml`）
3. **本機覆寫**（`{extension-id}-config.local.yml`，已加入 gitignore）
4. **環境變數**（`SPECKIT_{EXTENSION}_*`）

### 環境變數模式

格式：`SPECKIT_{EXTENSION}_{KEY}`

範例：

- `SPECKIT_JIRA_PROJECT_KEY`
- `SPECKIT_LINEAR_API_KEY`
- `SPECKIT_GITHUB_TOKEN`

---

## Hook 系統

### Hook 定義

每個事件可接受單一 hook 對應或對應清單。清單可在同一事件上註冊多個命令。

**單一對應（在 extension.yml 中）**：

```yaml
hooks:
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    prompt: "Create Jira issues from tasks?"
    description: "Automatically create Jira hierarchy"
    condition: null
```

**附優先順序的對應清單**：

```yaml
hooks:
  after_plan:
    - command: "speckit.my-ext.verify"
      priority: 5
      optional: false
      description: "Verify the plan"
    - command: "speckit.my-ext.report"
      priority: 10
      optional: true
      prompt: "Generate the report?"
      description: "Generate a report from the plan"
```

在單一資訊清單的清單中，重複的 `command` 會以「最後者勝出」去重並移到末尾，因此它也會在撰寫順序上打破優先順序相同的平手。

### Hook 事件

標準事件（由核心定義）：

- `before_specify`——規格產生之前
- `after_specify`——規格產生之後
- `before_plan`——實作規劃之前
- `after_plan`——實作規劃之後
- `before_tasks`——任務產生之前
- `after_tasks`——任務產生之後
- `before_implement`——實作之前
- `after_implement`——實作之後
- `before_analyze`——跨成品分析之前
- `after_analyze`——跨成品分析之後
- `before_checklist`——檢核清單產生之前
- `after_checklist`——檢核清單產生之後
- `before_clarify`——規格釐清之前
- `after_clarify`——規格釐清之後
- `before_constitution`——憲章更新之前
- `after_constitution`——憲章更新之後

#### 內建 `bug` 擴充功能事件（安裝該擴充功能時可用）

Hook 是在同一工作階段中執行的提示詞；它們重用從對話中解析的 `BUG_SLUG` 與 `BUG_DIR`（post-hook 則重用已寫入的報告），不會注入任何變數。Pre-hook 在 slug 解析與必要條件之後執行；post-hook 在報告寫入後、回報完成之前執行。

- `before_bug_assess`——bug 目錄存在之後、擷取報告之前
- `after_bug_assess`——寫入 `assessment.md` 之後；報告難以理解導致提早停止時不會到達
- `before_bug_fix`——套用修復之前
- `after_bug_fix`——寫入 `fix.md` 之後
- `before_bug_test`——執行驗證之前
- `after_bug_test`——寫入 `test.md` 之後

### Hook 設定

**在 `.specify/extensions.yml` 中**：

```yaml
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"
      description: "..."
      condition: null
```

### Hook 訊息格式

```markdown
## Extension Hooks

**Optional Hook**: {extension}
Command: `/{command}`
Description: {description}

Prompt: {prompt}
To execute: `/{command}`
```

或強制 hook：

```markdown
**Automatic Hook**: {extension}
Executing: `/{command}`
EXECUTE_COMMAND: {command}
```

---

## CLI 命令

### extension list

**用法**：`specify extension list [OPTIONS]`

**選項**：

- `--available`——顯示目錄中可用的擴充功能
- `--all`——同時顯示已安裝與可用的擴充功能

**輸出**：已安裝擴充功能清單及後設資料

### extension catalog list

**用法**：`specify extension catalog list`

列出目前目錄堆疊中所有使用中的目錄，顯示名稱、說明、URL、優先順序與 `install_allowed` 狀態。

### extension catalog add

**用法**：`specify extension catalog add URL [OPTIONS]`

**選項**：

- `--name NAME`——目錄名稱（必填）
- `--priority INT`——優先順序（數字越小優先順序越高，預設：10）
- `--install-allowed / --no-install-allowed`——是否允許從此目錄安裝（預設：false）
- `--description TEXT`——目錄的選用說明

**參數**：

- `URL`——目錄 URL（必須使用 HTTPS）

將目錄條目加入 `.specify/extension-catalogs.yml`。

### extension catalog remove

**用法**：`specify extension catalog remove NAME`

**參數**：

- `NAME`——要移除的目錄名稱

從 `.specify/extension-catalogs.yml` 移除目錄條目。

### extension add

**用法**：`specify extension add EXTENSION [OPTIONS]`

**選項**：

- `--from URL`——從自訂 URL 安裝
- `--dev PATH`——從本機目錄安裝

**參數**：

- `EXTENSION`——擴充功能名稱或 URL

**注意**：`install_allowed: false` 的目錄中的擴充功能無法透過此命令安裝。

### extension remove

**用法**：`specify extension remove EXTENSION [OPTIONS]`

**選項**：

- `--keep-config`——保留設定檔
- `--force`——跳過確認

**參數**：

- `EXTENSION`——擴充功能 ID

### extension search

**用法**：`specify extension search [QUERY] [OPTIONS]`

同時搜尋所有使用中的目錄。結果包含來源目錄名稱與 install_allowed 狀態。

**選項**：

- `--tag TAG`——依標籤篩選
- `--author AUTHOR`——依作者篩選
- `--verified`——僅顯示已驗證的擴充功能

**參數**：

- `QUERY`——選用的搜尋查詢

### extension info

**用法**：`specify extension info EXTENSION`

顯示來源目錄與 install_allowed 狀態。

**參數**：

- `EXTENSION`——擴充功能 ID

### extension update

**用法**：`specify extension update [EXTENSION]`

**參數**：

- `EXTENSION`——選用，擴充功能 ID（預設：全部）

### extension enable

**用法**：`specify extension enable EXTENSION`

**參數**：

- `EXTENSION`——擴充功能 ID

### extension disable

**用法**：`specify extension disable EXTENSION`

**參數**：

- `EXTENSION`——擴充功能 ID

---

## 例外

### ValidationError

當擴充功能資訊清單驗證失敗時擲出。

```python
from specify_cli.extensions import ValidationError

try:
    manifest = ExtensionManifest(path)
except ValidationError as e:
    print(f"Invalid manifest: {e}")
```

### CompatibilityError

當擴充功能與目前的 spec-kit 版本不相容時擲出。

```python
from specify_cli.extensions import CompatibilityError

try:
    manager.check_compatibility(manifest, "0.1.0")
except CompatibilityError as e:
    print(f"Incompatible: {e}")
```

### ExtensionError

所有擴充功能相關錯誤的基底例外。

```python
from specify_cli.extensions import ExtensionError

try:
    manager.install_from_directory(path, "0.1.0")
except ExtensionError as e:
    print(f"Extension error: {e}")
```

---

## 版本函式

### version_satisfies

檢查版本是否符合指定子。

```python
from specify_cli.extensions import version_satisfies

# True if 1.2.3 satisfies >=1.0.0,<2.0.0
satisfied = version_satisfies("1.2.3", ">=1.0.0,<2.0.0")  # bool
```

---

## 檔案系統配置

```text
.specify/
├── extensions/
│   ├── .registry               # Extension registry (JSON)
│   ├── .cache/                 # Catalog cache
│   │   ├── catalog.json
│   │   └── catalog-metadata.json
│   ├── .backup/                # Config backups
│   │   └── {ext}-{config}.yml
│   ├── {extension-id}/         # Extension directory
│   │   ├── extension.yml       # Manifest
│   │   ├── {ext}-config.yml    # User config
│   │   ├── {ext}-config.local.yml  # Local overrides (gitignored)
│   │   ├── {ext}-config.template.yml  # Template
│   │   ├── commands/           # Command files
│   │   │   └── *.md
│   │   ├── scripts/            # Helper scripts
│   │   │   └── *.sh
│   │   ├── docs/               # Documentation
│   │   └── README.md
│   └── extensions.yml          # Project extension config
└── scripts/                    # (existing spec-kit)

.claude/
└── commands/
    └── speckit.{ext}.{cmd}.md  # Registered commands
```

---

*最後更新：2026-01-28*
*API 版本：1.0*
*Spec Kit 版本：0.1.0*
