# 開發擴充功能

使用 GitHub Copilot skills 配置建立 Spec Kit 擴充功能的指南。在 Copilot 聊天中以連字號名稱呼叫 skills，例如 `/speckit-my-ext-hello`。擴充功能資訊清單仍使用帶點的命令識別碼，例如 `speckit.my-ext.hello`；Spec Kit 會在安裝時將它們轉譯為 Copilot skills。

---

## 快速入門

### 1. 建立擴充功能目錄

```bash
mkdir my-extension
cd my-extension
```

### 2. 建立 `extension.yml` 資訊清單

```yaml
schema_version: "1.0"

extension:
  id: "my-ext"                          # Lowercase, alphanumeric + hyphens only
  name: "My Extension"
  version: "1.0.0"                      # Semantic versioning
  description: "My custom extension"
  author: "Your Name"
  repository: "https://github.com/you/spec-kit-my-ext"
  license: "MIT"

requires:
  speckit_version: ">=0.1.0"            # Minimum spec-kit version
  tools:                                # Optional: External tools required
    - name: "my-tool"
      required: true
      version: ">=1.0.0"
  commands:                             # Optional: Core commands needed
    - "speckit.tasks"

provides:
  commands:
    - name: "speckit.my-ext.hello"      # Must follow pattern: speckit.{ext-id}.{cmd}
      file: "commands/hello.md"
      description: "Say hello"

  config:                               # Optional: Config files
    - name: "my-ext-config.yml"
      template: "my-ext-config.template.yml"
      description: "Extension configuration"
      required: false

hooks:                                  # Optional: Integration hooks
  after_tasks:
    command: "speckit.my-ext.hello"
    optional: true
    prompt: "Run hello command?"

tags:                                   # Optional: For catalog search
  - "example"
  - "utility"
```

### 3. 建立命令目錄

```bash
mkdir commands
```

### 4. 建立命令檔案

**檔案**：`commands/hello.md`

````markdown
---
description: "Say hello command"
tools:                              # Optional: AI tools this command uses
  - 'some-tool/function'
scripts:                            # Optional: Helper scripts
  sh: ../../scripts/bash/helper.sh
  ps: ../../scripts/powershell/helper.ps1
---

# Hello Command

This command says hello!

## User Input

$ARGUMENTS

## Steps

1. Greet the user
2. Show extension is working

```bash
echo "Hello from my extension!"
echo "Arguments: $ARGUMENTS"
```

## Extension Configuration

Load extension config from `.specify/extensions/my-ext/my-ext-config.yml`.
````

### 5. 在本機測試

```bash
cd /path/to/spec-kit-project
specify integration install copilot --integration-options="--skills"
specify extension add --dev /path/to/my-extension
```

對於新專案，請以 `specify init my-project --integration copilot --integration-options="--skills"` 初始化。如果 Copilot 已以 commands 配置安裝，請遵循 [Copilot 遷移指南](../integrations/copilot.md#commands-layout)，不要再次安裝。

### 6. 驗證安裝

```bash
specify extension list

# Should show:
#  ✓ My Extension (v1.0.0)
#     My custom extension
#     Commands: 1 | Hooks: 1 | Status: Enabled
```

### 7. 測試 Skill

開啟 GitHub Copilot 聊天並呼叫該 skill：

```text
/speckit-my-ext-hello world
```

產生的 skill 位於 `.github/skills/speckit-my-ext-hello/SKILL.md`。此呼叫應在 Copilot 聊天中進行，不是在終端機中。

---

## 資訊清單結構描述參考

### 必填欄位

#### `schema_version`

擴充功能資訊清單結構描述版本。目前為：`"1.0"`

#### `extension`

擴充功能後設資料區塊。

**必填子欄位**：

- `id`：擴充功能識別碼（小寫、英數字元、連字號）
- `name`：方便閱讀的名稱
- `version`：語意化版本（例如 "1.0.0"）
- `description`：簡短說明

**選用子欄位**：

- `author`：擴充功能作者
- `repository`：原始碼 URL
- `license`：SPDX 授權識別碼
- `homepage`：擴充功能首頁 URL

#### `requires`

相容性需求。

**必填子欄位**：

- `speckit_version`：語意化版本指定子（例如 ">=0.1.0,<2.0.0"）

**選用子欄位**：

- `tools`：所需的外部工具（工具物件陣列）
- `commands`：所需的核心 spec-kit 命令（命令名稱陣列）
- `scripts`：所需的核心指令碼（指令碼名稱陣列）

#### `provides`

擴充功能提供的內容。

**選用子欄位：**

- `commands`：命令物件陣列
- `templates`：範本物件陣列
- `scripts`：指令碼物件陣列

`hooks` 與 `events` 是獨立的頂層資訊清單欄位（與 `provides` 同層級，不巢狀於其下——見下文 [`hooks`](#hooks)）。`provides.commands`、`provides.templates`、`provides.scripts`、`hooks` 或 `events` 至少需要一個。

**命令物件**：

- `name`：命令名稱（必須符合 `speckit.{ext-id}.{command}`）
- `file`：命令檔案路徑（相對於擴充功能根目錄）
- `description`：命令說明（選用）

**範本物件**：

- `name`：範本名稱（小寫、英數字元、連字號——例如 `myext-template`）
- `file`：範本檔案路徑（相對於擴充功能根目錄）
- `description`：範本說明（選用）

**指令碼物件**：

- `name`：指令碼名稱（小寫、英數字元、連字號——例如 `myext-collect`）
- `file`：指令碼檔案路徑（相對於擴充功能根目錄）
- `description`：指令碼說明（選用）
- `runtimes`：指令碼支援的執行環境（選用，陣列；`bash`、`powershell`、`python` 的子集——僅供資訊參考，不用於選擇或呼叫指令碼）

擴充功能提供的範本與指令碼一律解析為 `replace`；若資訊清單在其中一個條目上包含 `strategy` 鍵，將以 `ValidationError` 拒絕。可組合策略（`wrap`/`prepend`/`append`）僅供預設集使用。

### 選用欄位

#### `hooks`

用於自動執行的整合 hook。

可用的 hook 點：

- `before_specify` / `after_specify`：規格產生之前／之後
- `before_plan` / `after_plan`：實作規劃之前／之後
- `before_tasks` / `after_tasks`：任務產生之前／之後
- `before_implement` / `after_implement`：實作之前／之後
- `before_analyze` / `after_analyze`：跨成品分析之前／之後
- `before_checklist` / `after_checklist`：檢核清單產生之前／之後
- `before_clarify` / `after_clarify`：規格釐清之前／之後
- `before_constitution` / `after_constitution`：憲章更新之前／之後
- `before_bug_assess` / `after_bug_assess`：錯誤評估之前／之後（內建 `bug` 擴充功能）
- `before_bug_fix` / `after_bug_fix`：錯誤修復之前／之後（內建 `bug` 擴充功能）
- `before_bug_test` / `after_bug_test`：錯誤驗證之前／之後（內建 `bug` 擴充功能）

每個事件可接受單一 hook 物件或 hook 物件清單（一個事件多個命令）。

Hook 物件：

- `command`：要執行的命令（通常來自 `provides.commands`，但可引用任何已註冊命令）
- `priority`：事件內的執行順序（整數 ≥ 1，預設 10；數字越小越先執行；優先順序相同時保留撰寫順序）
- `optional`：若為 true，執行前提示使用者
- `prompt`：選用 hook 的提示文字
- `description`：Hook 說明
- `condition`：執行條件（未來功能）

#### `tags`

用於型錄探索的標籤陣列。

#### `defaults`

擴充功能的預設設定值。

#### `config_schema`

用於驗證擴充功能設定的 JSON Schema。

---

## 命令檔案格式

### Frontmatter（YAML）

```yaml
---
description: "Command description"          # Required
tools:                                      # Optional
  - 'tool-name/function'
scripts:                                    # Optional
  sh: ../../scripts/bash/helper.sh
  ps: ../../scripts/powershell/helper.ps1
---
```

### 內文（Markdown）

使用標準 Markdown 搭配特殊佔位符：

- `$ARGUMENTS`：使用者提供的參數
- `{SCRIPT}`：註冊時替換為指令碼路徑
- `__SPECKIT_COMMAND_<NAME>__`：替換為另一個命令的呼叫方式，使用目前整合的分隔符轉譯（見[引用其他命令](#引用其他命令)）

**範例**：

````markdown
## Steps

1. Parse arguments
2. Execute logic

```bash
args="$ARGUMENTS"
echo "Running with args: $args"
```
````

### 引用其他命令

命令內文是 Spec Kit 轉譯為 Copilot skill 的*範本*。從該內文引用另一個命令時，**不要硬編碼其呼叫方式**。請使用命令引用權杖，讓 Spec Kit 轉譯出正確的 skill 語法，並保持擴充功能的可攜性。

使用權杖 `__SPECKIT_COMMAND_<NAME>__`。在 Copilot 的 skills 配置中，Spec Kit 會將它解析為 `/speckit-...` 呼叫。

命令名稱以大寫編碼，省略 `speckit.` 前綴，並將每個以點分隔的區段分隔符轉為底線。區段內的連字號保持為連字號：

| 命令檔案 | 權杖 |
| --- | --- |
| `speckit.plan.md` | `__SPECKIT_COMMAND_PLAN__` |
| `speckit.bug.fix.md` | `__SPECKIT_COMMAND_BUG_FIX__` |
| `speckit.git.commit.md` | `__SPECKIT_COMMAND_GIT_COMMIT__` |
| `speckit.agent-context.update.md` | `__SPECKIT_COMMAND_AGENT-CONTEXT_UPDATE__` |

底線分隔命令區段，連字號屬於它所在的區段，因此 `AGENT-CONTEXT_UPDATE` 是 `agent-context` 與 `update` 兩個區段，而不是三個。Copilot 會將此轉譯為 `/speckit-agent-context-update`。

**範例**——將使用者指向下一步的命令內文：

```markdown
Once the assessment exists, the next step is `__SPECKIT_COMMAND_BUG_FIX__ slug=<slug>`.
```

在 Copilot 聊天中，這會轉譯為 `/speckit-bug-fix slug=<slug>`。第一方的 `bug` 與 `git` 擴充功能專門使用此權杖；實際範例見 `extensions/bug/commands/`。

其他整合的呼叫格式，請參閱共用的[命令呼叫參考](../integrations/cli.md#command-invocation)。

### 指令碼路徑重寫

擴充功能命令使用相對路徑，註冊時會被重寫：

**在擴充功能中**：

```yaml
scripts:
  sh: ../../scripts/bash/helper.sh
```

**註冊後**：

```yaml
scripts:
  sh: .specify/scripts/bash/helper.sh
```

這讓指令碼能引用核心 spec-kit 指令碼。

---

## 設定檔

### 設定範本

**檔案**：`my-ext-config.template.yml`

```yaml
# My Extension Configuration
# Copy this to my-ext-config.yml and customize

# Example configuration
api:
  endpoint: "https://api.example.com"
  timeout: 30

features:
  feature_a: true
  feature_b: false

credentials:
  # DO NOT commit credentials!
  # Use environment variables instead
  api_key: "${MY_EXT_API_KEY}"
```

### 設定載入

在你的命令中，以分層優先順序載入設定：

1. 擴充功能預設值（`extension.yml` → `defaults`）
2. 專案設定（`.specify/extensions/my-ext/my-ext-config.yml`）
3. 本機覆寫（`.specify/extensions/my-ext/my-ext-config.local.yml`——已加入 gitignore）
4. 環境變數（`SPECKIT_MY_EXT_*`）

**載入指令碼範例**：

```bash
#!/usr/bin/env bash
EXT_DIR=".specify/extensions/my-ext"

# Load and merge config
config=$(yq eval '.' "$EXT_DIR/my-ext-config.yml" -o=json)

# Apply env overrides
if [ -n "${SPECKIT_MY_EXT_API_KEY:-}" ]; then
  config=$(echo "$config" | jq ".api.api_key = \"$SPECKIT_MY_EXT_API_KEY\"")
fi

echo "$config"
```

---

## 以 `.extensionignore` 排除檔案

擴充功能作者可以在擴充功能根目錄建立 `.extensionignore` 檔案，排除使用者以 `specify extension add` 安裝擴充功能時不應複製的檔案與資料夾。這對於將僅供開發的檔案（測試、CI 設定、文件來源等）排除在安裝副本之外很有用。

### 格式

此檔案使用與 `.gitignore` 相容的模式（每行一個），由 [`pathspec`](https://pypi.org/project/pathspec/) 程式庫驅動：

- 空行會被忽略
- 以 `#` 開頭的行是註解
- `*` 符合除 `/` 以外的任何內容（不跨目錄邊界）
- `**` 符合零個或多個目錄（例如 `docs/**/*.draft.md`）
- `?` 符合除 `/` 以外的任何單一字元
- 結尾的 `/` 將模式限制為僅目錄
- 包含 `/` 的模式（結尾斜線除外）會錨定到擴充功能根目錄
- 不含 `/` 的模式可在樹狀結構的任何深度符合
- `!` 否定先前已排除的模式（重新包含檔案）
- 模式中的反斜線會正規化為正斜線，以確保跨平台相容性
- `.extensionignore` 檔案本身一律自動排除

### 範例

```gitignore
# .extensionignore

# Development files
tests/
.github/
.gitignore

# Build artifacts
__pycache__/
*.pyc
dist/

# Documentation source (keep only the built README)
docs/
CONTRIBUTING.md
```

### 模式比對

| 模式 | 符合 | 不符合 |
|---------|---------|----------------|
| `*.pyc` | 任何目錄中的任何 `.pyc` 檔案 | — |
| `tests/` | `tests` 目錄（及其全部內容） | 名為 `tests` 的檔案 |
| `docs/*.draft.md` | `docs/api.draft.md`（直接位於 `docs/` 內） | `docs/sub/api.draft.md`（巢狀） |
| `.env` | 任何層級的 `.env` 檔案 | — |
| `!README.md` | 即使被先前模式符合，也重新包含 `README.md` | — |
| `docs/**/*.draft.md` | `docs/api.draft.md`、`docs/sub/api.draft.md` | — |

### 不支援的功能

以下 `.gitignore` 功能在此情境中**不適用**：

- **多個 `.extensionignore` 檔案**：僅支援擴充功能根目錄的單一檔案（`.gitignore` 支援子目錄中的檔案）
- **`$GIT_DIR/info/exclude` 與 `core.excludesFile`**：這些是 Git 專屬功能，此處無對應功能
- **已排除目錄內的否定**：由於檔案複製使用 `shutil.copytree`，排除目錄會完全阻止遞迴進入。否定模式無法重新包含本身已被排除的目錄內的檔案。例如，`tests/` 後接 `!tests/important.py` 的組合將**不會**保留 `tests/important.py`——`tests/` 目錄會在根層級被跳過，其內容永遠不會被評估。若要解決此問題，請個別排除目錄的內容，而非目錄本身（例如使用 `tests/*.pyc` 與 `tests/.cache/`，而非 `tests/`）。

---

## 驗證規則

### 擴充功能 ID

- **模式**：`^[a-z0-9-]+$`
- **有效**：`my-ext`、`tool-123`、`awesome-plugin`
- **無效**：`MyExt`（大寫）、`my_ext`（底線）、`my ext`（空格）

### 擴充功能版本

- **格式**：語意化版本（MAJOR.MINOR.PATCH）
- **有效**：`1.0.0`、`0.1.0`、`2.5.3`
- **無效**：`1.0`、`v1.0.0`、`1.0.0-beta`

### 命令名稱

- **模式**：`^speckit\.[a-z0-9-]+\.[a-z0-9-]+$`
- **有效**：`speckit.my-ext.hello`、`speckit.tool.cmd`
- **無效**：`my-ext.hello`（缺少前綴）、`speckit.hello`（無擴充功能命名空間）

### 命令檔案路徑

- **必須**相對於擴充功能根目錄
- **有效**：`commands/hello.md`、`commands/subdir/cmd.md`
- **無效**：`/absolute/path.md`、`../outside.md`

---

## 測試擴充功能

### 手動測試

1. 在已設定 [Copilot skills](../integrations/copilot.md#setup) 的專案中**建立測試擴充功能**。
2. **在本機安裝**：

   ```bash
   specify extension add --dev /path/to/extension
   ```

3. **驗證安裝**：

   ```bash
   specify extension list
   ```

4. 在 Copilot 聊天中**測試 skills**，例如 `/speckit-my-ext-hello world`。
5. **檢查 skill 註冊**：

   ```bash
   ls .github/skills/speckit-my-ext-*/SKILL.md
   ```

6. **移除擴充功能**：

   ```bash
   specify extension remove my-ext
   ```

### 自動化測試

為你的擴充功能建立測試：

```python
# tests/test_my_extension.py
import pytest
from pathlib import Path
from specify_cli.extensions import ExtensionManifest

def test_manifest_valid():
    """Test extension manifest is valid."""
    manifest = ExtensionManifest(Path("extension.yml"))
    assert manifest.id == "my-ext"
    assert len(manifest.commands) >= 1

def test_command_files_exist():
    """Test all command files exist."""
    manifest = ExtensionManifest(Path("extension.yml"))
    for cmd in manifest.commands:
        cmd_file = Path(cmd["file"])
        assert cmd_file.exists(), f"Command file not found: {cmd_file}"
```

---

## 發佈

### 選項 1：GitHub 儲存庫

1. **建立儲存庫**：`spec-kit-my-ext`
2. **加入檔案**：

   ```text
   spec-kit-my-ext/
   ├── extension.yml
   ├── commands/
   ├── scripts/
   ├── docs/
   ├── README.md
   ├── LICENSE
   └── CHANGELOG.md
   ```

3. **建立發行版本**：以版本標記（例如 `v1.0.0`）
4. **從儲存庫安裝**：

   ```bash
   git clone https://github.com/you/spec-kit-my-ext
   specify extension add --dev spec-kit-my-ext/
   ```

### 選項 2：ZIP 封存檔（未來功能）

建立 ZIP 封存檔並託管在 GitHub Releases：

```bash
zip -r spec-kit-my-ext-1.0.0.zip extension.yml commands/ scripts/ docs/
```

使用者以下列方式安裝：

```bash
specify extension add <extension-name> --from https://github.com/.../spec-kit-my-ext-1.0.0.zip
```

### 選項 3：社群參考型錄

提交到社群型錄供公開探索：

1. 為你的擴充功能**建立 GitHub 發行版本**
2. 使用 [Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml) 範本**建立 issue**
3. **審查後**，維護者會更新型錄，你的擴充功能即可用：
   - 使用者可瀏覽 `catalog.community.json` 探索你的擴充功能
   - 使用者將條目複製到自己的 `catalog.json`
   - 使用者安裝：`specify extension add my-ext`（從其型錄）

詳細提交說明請參閱[擴充功能發佈指南](publishing.md)。

---

## 最佳實務

### 命名慣例

- **擴充功能 ID**：使用具描述性的連字號名稱（`jira-integration`，而非 `ji`）
- **命令**：使用動詞-名詞模式（`create-issue`、`sync-status`）
- **設定檔**：與擴充功能 ID 相符（`jira-config.yml`）

### 文件

- **README.md**：概覽、安裝、使用
- **CHANGELOG.md**：版本歷史
- **docs/**：詳細指南
- **命令說明**：清晰、簡潔

### 版本管理

- **遵循 SemVer**：`MAJOR.MINOR.PATCH`
- **MAJOR**：破壞性變更
- **MINOR**：新功能
- **PATCH**：錯誤修正
- **每次內容變更都要提升版本**：`specify extension update` 的更新提供由版本驅動，因此未提升版本就出貨的內容變更，永遠不會自動交付給已安裝的副本。對於此儲存庫中的內建擴充功能，提升版本由 CI 強制執行（`extension-version-guard.yml`）：變更 `extensions/<id>/` 下檔案的 PR，也必須提升該擴充功能的 `extension.yml` 版本，並保持 `extensions/catalog.json` 同步。

### 安全性

- **絕不提交機密**：使用環境變數
- **驗證輸入**：清理使用者參數
- **記錄權限**：會存取哪些檔案／API

### 相容性

- **指定版本範圍**：不要要求精確版本
- **以多個版本測試**：確保相容性
- **優雅降級**：處理缺少的功能

---

## 擴充功能範例

### 最小擴充功能

最小可行的擴充功能：

```yaml
# extension.yml
schema_version: "1.0"
extension:
  id: "minimal"
  name: "Minimal Extension"
  version: "1.0.0"
  description: "Minimal example"
requires:
  speckit_version: ">=0.1.0"
provides:
  commands:
    - name: "speckit.minimal.hello"
      file: "commands/hello.md"
```

````markdown
<!-- commands/hello.md -->
---
description: "Hello command"
---

# Hello World

```bash
echo "Hello, $ARGUMENTS!"
```
````

### 附設定的擴充功能

使用設定的擴充功能：

```yaml
# extension.yml
# ... metadata ...
provides:
  config:
    - name: "tool-config.yml"
      template: "tool-config.template.yml"
      required: true
```

```yaml
# tool-config.template.yml
api_endpoint: "https://api.example.com"
timeout: 30
```

````markdown
<!-- commands/use-config.md -->
# Use Config

Load config:
```bash
config_file=".specify/extensions/tool/tool-config.yml"
endpoint=$(yq eval '.api_endpoint' "$config_file")
echo "Using endpoint: $endpoint"
```
````

### 附 Hook 的擴充功能

自動執行的擴充功能：

```yaml
# extension.yml
hooks:
  after_tasks:
    command: "speckit.auto.analyze"
    optional: false  # Always run
    description: "Analyze tasks after generation"
```

一個事件多個命令，依 `priority` 排序（數字越小越先執行）：

```yaml
# extension.yml
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

---

## 疑難排解

### 擴充功能無法安裝

**錯誤**：`Invalid extension ID`

- **修正**：僅使用小寫、英數字元加連字號

**錯誤**：`Extension requires spec-kit >=0.2.0`

- **修正**：使用[升級指南](../upgrade.md)升級 Spec Kit。`uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git` 仍可作為從原始碼安裝的備援方式。如果你是從 PyPI 安裝並希望沿用該路徑，請遵循 [PyPI 升級指南](../install/pypi.md#upgrade)。

**錯誤**：`Command file not found`

- **修正**：確保命令檔案存在於資訊清單指定的路徑

### Skills 未註冊

**症狀**：Skills 未出現在 GitHub Copilot 聊天中

**檢查**：

1. 產生的 skill 存在於 `.github/skills/speckit-my-ext-hello/SKILL.md`
2. 擴充功能安裝成功
3. 命令已在登錄中註冊：

   ```bash
   cat .specify/extensions/.registry
   ```

**修正**：確認 Copilot 已設定為 [skills 配置](../integrations/copilot.md#default-skills-layout)，然後重新安裝擴充功能以觸發註冊。

### 設定未載入

**檢查**：

1. 設定檔存在：`.specify/extensions/{ext-id}/{ext-id}-config.yml`
2. YAML 語法有效：`yq eval '.' config.yml`
3. 環境變數設定正確

---

## 取得協助

- **Issue**：在 GitHub 儲存庫回報錯誤
- **討論**：在 GitHub Discussions 提問
- **範例**：參閱 `spec-kit-jira` 完整功能範例（Phase B）

---

## 後續步驟

1. 依本指南**建立你的擴充功能**
2. 以 `--dev` 旗標**在本機測試**
3. **與社群分享**（GitHub、型錄）
4. 根據回饋**迭代**

祝擴充愉快！🚀

> 本頁的代理呼叫範例使用 GitHub Copilot 的預設 skills 語法（`/speckit-*`）。其他整合與模式，請參閱[命令呼叫](../integrations/cli.md#command-invocation)。
