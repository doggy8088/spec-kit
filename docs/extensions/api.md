# 擴充功能 API 參考

Spec Kit 擴充功能系統 API 與資訊清單結構描述的技術參考。

## 目錄

1. [擴充功能資訊清單](#擴充功能資訊清單)
2. [Python API](#python-api)
3. [命令檔案格式](#命令檔案格式)
4. [設定結構描述](#設定結構描述)
5. [Hook 系統](#hook-系統)
6. [擴充功能執行時期事件](#擴充功能執行時期事件)

---

## 擴充功能資訊清單

### 結構描述版本 1.0

檔案：`extension.yml`

```yaml
schema_version: "1.0"  # Required

extension:
  id: string           # Required, pattern: ^[a-z0-9-]+$
  name: string         # Required, human-readable name
  version: string      # Required, PEP 440 version; SemVer recommended
  description: string  # Required, brief description
  author: string       # Optional
  repository: string   # Optional, source URL
  license: string      # Optional (e.g., "MIT", "Apache-2.0")
  homepage: string     # Optional, homepage URL

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
      description: string # Optional

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
    priority: integer    # Optional, >= 1, default 10 (HookExecutor sort metadata)
    optional: boolean    # Default: true
    prompt: string       # Prompt text for optional hooks
    description: string  # Hook description
    condition: string    # Optional, condition expression
  another_event:         # Any event may instead use a list of mappings (multiple commands)
    - command: string    # Same fields as the single mapping, per entry
      priority: integer
    - command: string
      priority: integer

events:                  # Optional, coding-agent lifecycle events
  session_start:
    command: string      # Command template with a runnable scripts entry

tags:                    # Optional, array of tags (2-10 recommended)
  - string

defaults:                # Optional, default configuration values
  key: value             # Any YAML structure

config:                  # Optional, separate from provides.config
  defaults:              # Merged over top-level defaults
    key: value
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
- **格式**：PEP 440；發行版本建議使用 `MAJOR.MINOR.PATCH`
- **說明**：擴充功能版本
- **範例**：`1.0.0`、`0.9.5`、`2.1.3`
- **亦接受**：`v1.0`、`1.0`、`1.0.0-beta`
- **無效**：`latest`、`not-a-version`

#### `requires.speckit_version`

- **類型**：string
- **格式**：版本指定子
- **說明**：所需的 spec-kit 版本範圍
- **範例**：
  - `>=0.1.0`——0.1.0 或更高版本
  - `>=0.1.0,<2.0.0`——0.1.x 或 1.x 版本
  - `==0.1.0`——恰好 0.1.0
- **亦接受**：`>= 0.1.0`（運算子後有空白）
- **無效**：`0.1.0`、`latest`

資訊清單載入時，此處必須是非空字串；相容性檢查會將它解析為 `packaging.specifiers.SpecifierSet`，並檢查已安裝的 Spec Kit 版本。

#### `provides.commands[].name`

- **類型**：string
- **模式**：`^speckit\.[a-z0-9-]+\.[a-z0-9-]+$`
- **說明**：具命名空間的命令名稱
- **格式**：`speckit.{extension-id}.{command-name}`
- **範例**：`speckit.jira.specstoissues`、`speckit.linear.sync`
- **Invalid**: `another-extension.command`, `speckit.jira.CreateIssues`

舊版的雙段名稱 `speckit.command` 與 `<extension-id>.command` 會正規化為 `speckit.<extension-id>.command`，並發出警告。作者應使用正式名稱，而非依賴此相容性行為。安裝時也會檢查主要名稱屬於擴充功能的命名空間，並拒絕與已安裝擴充功能完全相同的命令名稱或別名衝突，以及與核心命令正規化輸出名稱的衝突。

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
- **排序**：目前的命令範本會依設定的 YAML 順序呈現 hook。
  `HookExecutor.get_hooks_for_event()` 則改為依 `priority` 遞增回傳（整數 ≥ 1，預設為 10），相同時以穩定的撰寫順序排列。執行限制請參閱[掛鉤設定](#hook-設定)。

#### `events`

- **類型**：object
- **鍵**：正式的程式代理事件名稱
- **值**：參照可執行命令的事件對應
- **說明**：與整合無關的宣告，會翻譯為
  已安裝程式代理的原生事件設定；請參閱[擴充功能執行時期事件](#擴充功能執行時期事件)。

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
      "source": {"kind": "catalog", "catalog": "my-org"},
      "manifest_hash": "sha256...",
      "enabled": true,
      "priority": 10,
      "registered_commands": {
        "claude": ["speckit.jira.specstoissues"]
      },
      "registered_skills": [],
      "installed_at": "2026-01-28T00:00:00"
    }
  }
}
```

`registered_commands` 將整合鍵對應至已註冊的命令名稱；`registered_skills` 記錄補充的技能名稱。安裝程式將 `"local"` 儲存為原始的本機來源，或如上所示的型錄物件。CLI 正規化的 `--json` 輸出使用另一種[公開來源格式](cli.md#列出已安裝的擴充功能)。

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

表示使用中型錄堆疊中的單一型錄。

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
| `url` | `str` | 型錄 URL（必須使用 HTTPS，包含 localhost） |
| `name` | `str` | 方便閱讀的型錄名稱 |
| `priority` | `int` | 排序順序（數字越小優先順序越高，衝突時勝出） |
| `install_allowed` | `bool` | 是否可安裝此型錄的擴充功能 |
| `description` | `str` | 型錄的選用說明（預設：空） |

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
| `_catalog_name` | `str` | 來源型錄的名稱 |
| `_install_allowed` | `bool` | 是否允許從此型錄安裝 |

**型錄設定檔**（`.specify/extension-catalogs.yml`）：

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
description: string   # Recommended, brief command description
tools: [string]       # Optional, MCP tools required
```

### 特殊變數

- `$ARGUMENTS`——使用者提供參數的佔位符
- Markdown 命令輸出包含擴充功能上下文註解：

  ```markdown
  <!-- Extension: {extension-id} -->
  <!-- Config: .specify/extensions/{extension-id}/ -->
  ```

產生的技能則在 frontmatter 的 `metadata.source` 中帶有來源資訊，且不會自動包含這些 HTML 註解。其他輸出格式使用各自整合專屬的渲染器。

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

1. **擴充功能預設值**（頂層 `defaults` 與 `config.defaults` 合併，
   衝突時以 `config.defaults` 為準）
2. **專案設定**（`{extension-id}-config.yml`）
3. **本機覆寫**（`local-config.yml`，gitignored）
4. **環境變數**（`SPECKIT_{EXTENSION}_*`）

`ConfigManager` 在呼叫時執行此合併；擴充功能命令與指令稿必須使用它或自行實作載入。它不會內插 YAML 中的 `${...}` 字串，也不會驗證 `config_schema` 欄位。設定驗證屬於擴充功能命令或指令稿的責任。

### 環境變數模式

格式：`SPECKIT_{EXTENSION}_{KEY}`

擴充功能 ID 會轉為大寫，連字號改為底線。該前綴之後每個以底線分隔的組成部分會成為巢狀小寫鍵：`SPECKIT_JIRA_PROJECT_KEY` 設定的是 `project.key`，而非 `project_key`。環境變數值維持字串。當已安裝擴充功能 ID 的正規化前綴重疊時，較長的相符擴充功能 ID 擁有該變數。

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
- `before_converge`——收斂評估之前
- `after_converge`——收斂評估之後

#### 內建 `bug` 擴充功能事件（安裝該擴充功能時可用）

Hook 是在同一工作階段中執行的提示詞；它們重用從對話中解析的 `BUG_SLUG` 與 `BUG_DIR`（post-hook 則重用已寫入的報告），不會注入任何變數。Pre-hook 在 slug 解析與必要條件之後執行；post-hook 在報告寫入後、回報完成之前執行。

- `before_bug_assess`——bug 目錄存在之後、擷取報告之前
- `after_bug_assess`——寫入 `assessment.md` 之後；報告難以理解導致提早停止時不會到達
- `before_bug_fix`——套用修復之前
- `after_bug_fix`——寫入 `fix.md` 之後
- `before_bug_test`——執行驗證之前
- `after_bug_test`——寫入 `test.md` 之後

### Hook 設定

Spec Kit 將專案層級的擴充功能註冊與掛鉤設定儲存在 `.specify/extensions.yml`。`installed` 清單記錄已安裝的擴充功能 ID，`settings` 儲存專案範圍的擴充功能設定，`hooks` 依事件分組已註冊的掛鉤。

```yaml
installed:
  - git
  - my-extension

settings:
  auto_execute_hooks: true

hooks:
  before_implement:
    - extension: git
      command: speckit.git.commit
      enabled: true
      optional: true
      priority: 10
      prompt: "Commit outstanding changes before implementation?"
      description: "Auto-commit before implementation"
      condition: null

  after_implement:
    - extension: my-extension
      command: speckit.my-extension.verify
      enabled: true
      optional: false
      priority: 5
      description: "Run verification after implementation"
```

`auto_execute_hooks` 預設為 `true`，但屬於保留設定，在呈現或呼叫掛鉤時不會被參考。

| 欄位 | 說明 |
| --- | --- |
| `extension` | 註冊 hook 的擴充功能 ID。 |
| `command` | 與 hook 關聯的擴充功能命令。 |
| `enabled` | Hook 是否啟用。`enabled: false` 的 hook 會被略過。 |
| `optional` | 若為 `true`，掛鉤會連同其 `prompt` 一起呈現，且可以跳過。若為 `false`，則會以帶有 `EXECUTE_COMMAND` 標記的自動掛鉤形式發出。 |
| `priority` | 整數中繼資料 ≥ 1，預設為 `10`。目前的命令範本使用設定的 YAML 順序，而非依優先順序排序。 |
| `prompt` | 詢問是否執行選用 hook 時顯示的訊息。 |
| `description` | 掛鉤的人類可讀說明。 |
| `condition` | 由 `HookExecutor` 求值的選用運算式：`config.<path>` 或 `env.<VAR>`，搭配 `is set`、`==` 或 `!=`。目前的命令範本不會求值條件，並會跳過條件非空的掛鉤。 |

掛鉤事件名稱用來識別掛鉤被呼叫的時機，一般使用 `before_<command>` 或 `after_<command>`，例如 `before_implement`、`after_implement`、`before_tasks` 與 `after_tasks`。

擴充功能資訊清單會在安裝期間拒絕無效的掛鉤優先順序。對於既有的註冊，`HookExecutor.get_hooks_for_event()` 會使用 `normalize_priority()` 排序：缺少的值、布林值、`int()` 拒絕的值（包含非有限浮點數）以及小於 `1` 的值會退回 `10`。數值字串與有限浮點數會以 `int()` 強制轉型。較小的值會先回傳，相同時以穩定的撰寫順序排列。目前的命令範本會直接讀取掛鉤清單，而非使用該 Python API，因此會依設定的 YAML 順序呈現掛鉤。

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

## 擴充功能執行時期事件

擴充功能可以透過在 `extension.yml` 中宣告最上層的 `events` 對應，來回應程式代理的生命週期事件：

```yaml
events:
  session_start:
    command: speckit.my-extension.initialize
  pre_tool_use:
    command: speckit.my-extension.validate
```

事件宣告與整合無關。Spec Kit 會重新整理每一個已安裝且支援事件的整合，各整合會將正式事件名稱翻譯為其程式代理的原生事件設定。支援的正式事件為 `session_start`、`pre_tool_use`、`post_tool_use`、`user_prompt_submit`、`stop` 與 `session_end`；整合可能只支援其中一部分。

執行時期事件與擴充功能 hook 不同。事件回應程式代理的生命週期，並直接執行被參照命令範本的 `scripts` 項目。因此，被參照的命令必須提供可執行的指令碼；其 Markdown 指示不會傳送給程式代理。Hook 則是在 Spec Kit 命令（例如 `plan`、`tasks` 與 `implement`）之前或之後呈現擴充功能命令。

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
│   │   ├── local-config.yml    # Local overrides (gitignored)
│   │   ├── {ext}-config.template.yml  # Template
│   │   ├── commands/           # Command files
│   │   │   └── *.md
│   │   ├── scripts/            # Helper scripts
│   │   │   └── *.sh
│   │   ├── docs/               # Documentation
│   │   └── README.md
├── extensions.yml              # Project extension config
└── scripts/                    # (existing spec-kit)

.claude/
└── commands/
    └── speckit.{ext}.{cmd}.md  # Registered commands
```

---

*最後更新：2026-01-28*
*API 版本：1.0*
*Spec Kit 版本：0.1.0*

## 另請參閱

- [開發擴充功能](developing.md)
- [擴充功能 CLI 參考](cli.md)
- [擴充功能型錄](catalogs.md)
- [擴充功能使用者指南](overview.md)
- [發佈擴充功能](publishing.md)
