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
  version: "1.0.0"                      # SemVer recommended; PEP 440 accepted
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

對於新專案，請以 `specify init my-project --integration copilot --integration-options="--skills"` 初始化。如果 Copilot 已以 commands 配置安裝，請遵循 [Copilot 遷移指南](../integrations/copilot.md#命令版式)，不要再次安裝。

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
- `version`：PEP 440 版本（建議使用 SemVer，例如 "1.0.0"）
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
- `aliases`：替代命令名稱（選用）
- `resources`：要複製到產生技能中的檔案（選用；見[技能資源](#skill-resources)）

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
- `before_converge` / `after_converge`：收斂評估之前／之後
- `before_bug_assess` / `after_bug_assess`：錯誤評估之前／之後（內建 `bug` 擴充功能）
- `before_bug_fix` / `after_bug_fix`：錯誤修復之前／之後（內建 `bug` 擴充功能）
- `before_bug_test` / `after_bug_test`：錯誤驗證之前／之後（內建 `bug` 擴充功能）

每個事件可接受單一 hook 物件或 hook 物件清單（一個事件多個命令）。

Hook 物件：

- `command`：要執行的命令（通常來自 `provides.commands`，但可引用任何已註冊命令）
- `priority`：`HookExecutor` 的排序中繼資料（整數 ≥ 1，預設為 10）；目前的命令範本改為依設定的 YAML 順序呈現 hook
- `optional`：若為 true，執行前提示使用者
- `prompt`：選用 hook 的提示文字
- `description`：Hook 說明
- `condition`：由 `HookExecutor` 求值的運算式；目前的命令範本會跳過條件非空的 hook，而非求值它們

所有欄位，以及 Python API 與命令範本行為之間的區別，請參閱[掛鉤設定合約](api.md#hook-設定)。

#### `events`

執行時期事件會回應程式代理的生命週期，而非 Spec Kit 命令。請在頂層宣告正式名稱，並參照帶有可執行 `scripts` 項目的命令範本：

```yaml
events:
  session_start:
    command: speckit.my-ext.initialize
```

例如，`commands/initialize.md` 可以宣告：

```yaml
---
description: "Initialize the extension session"
scripts:
  sh: scripts/initialize.sh
  ps: scripts/initialize.ps1
---
```

請將該命令納入 `provides.commands`，並在你的擴充功能中提供指令稿。執行時期事件會直接執行指令稿；它們不會將命令的 Markdown 主體傳送給程式代理。每個整合支援正式事件的子集。請參閱[執行時期事件合約](api.md#擴充功能執行時期事件)。

#### `tags`

用於型錄探索的標籤陣列。

#### `defaults`

擴充功能的預設設定值。

---

<a id="skill-resources"></a>

## 技能資源

在每個命令上宣告選用的 `resources` 清單，把擴充功能檔案複製到其產生的技能中。項目為擴充功能根目錄相對的明確檔案路徑或萬用字元模式，使用與[`.extensionignore`](#excluding-files-with-extensionignore)相同的 gitignore 風格方言。例如：

```yaml
provides:
  commands:
    - name: speckit.my-ext.review
      file: commands/review.md
      aliases: [speckit.my-ext.rv]
      resources:
        - references/*.md
        - scripts/bash/review.sh
        - scripts/bash/common.sh  # sourced by review.sh
```

當原生技能整合算繪兩個名稱時，副本會在每個技能中保留其擴充功能相對路徑：

```text
<skills>/speckit-my-ext-review/SKILL.md
<skills>/speckit-my-ext-review/references/<matching files>
<skills>/speckit-my-ext-review/scripts/bash/{review.sh,common.sh}
<skills>/speckit-my-ext-rv/SKILL.md
<skills>/speckit-my-ext-rv/references/<matching files>
<skills>/speckit-my-ext-rv/scripts/bash/{review.sh,common.sh}
```

補充技能只算繪主要命令。模式支援 `*`、`?`、`**` 與字元類別；例如，不含斜線的 `*.md` 會在任何深度相符，而 `references/*.md` 只會符合 `references/` 正下方的檔案。否定、絕對路徑與 `..` 區段都不允許。明確檔案必須存在，每個萬用字元至少必須符合一個一般檔案；符號連結相符項目與目的地為 `SKILL.md` 的資源會被拒絕。萬用字元絕不會選取根目錄的 `extension.yml` 或 `.specify-dev` 開發算繪快取（若你真的需要，請明確列出 `extension.yml`；`.specify-dev` 項目會被拒絕）。

非空清單會為技能輸出啟用複製模式：**不會重寫任何路徑**，包括內文路徑與 frontmatter `scripts:` 路徑。請列出每個參照的檔案，包括 frontmatter 指令碼與其來源的任何檔案；`{SCRIPT}` 會使用撰寫的技能相對命令。代理會執行它，而 [Agent Skills 規格](https://agentskills.io/specification)不保證 shell 的工作目錄就是技能根目錄。在依賴技能相對指令碼執行之前，請先確認你的代理行為。Markdown、TOML 與其他非技能輸出會保留既有的算繪方式，不會收到資源副本。

模式會在 `.extensionignore` 篩選套件副本之後，針對已安裝的擴充功能進行比對。請勿在擴充功能套件中使用符號連結：資源比對不會跟隨或審查它們。安裝會在解析連結的情況下複製套件，因此連結目錄的檔案會成為已安裝擴充功能中的一般檔案，並像其他檔案一樣比對，無論連結指向何處。相符的符號連結本身會被拒絕。使用者稍後在 `.specify/extensions/<id>/` 中建立的檔案，例如 `local-config.yml`，在重新算繪時仍可能相符並被複製；技能位置可能不在 gitignore 中。請優先使用明確路徑或狹窄模式，而非 `**` 這類寬泛萬用字元。

副本會以來源檔案的權限位元加上擁有者讀寫權限建立，並受行程 umask 收窄。在 POSIX 上，帶有 shebang 且沒有執行位元的 `.sh` 副本隨後會變成可執行：每個讀取位元都會加上執行位元，至少有擁有者執行權限。例如，`0644` 指令碼可能變成 `0755`；`0600` 指令碼可能變成 `0700`。請勿依賴來源模式會被精確保留。

副本會以雜湊追蹤。算繪期間，除非使用者提供 `--force`，否則已存在非擁有的目的地會跳過並發出警告；重新整理時，除非強制，否則已修改的已記錄副本也會保留並發出警告。擴充功能移除與更新會刪除已記錄的資源，包括編輯過的資源；不安全的路徑可能跳過並發出警告。資源清理不會刪除未記錄的檔案，但非一般的補充技能移除會移除整個技能目錄，包括未記錄的檔案。主目錄範圍的技能目錄會在專案之間共用，而所有權記錄是專案本機的；它們不是跨專案的專屬權威。

省略 `resources` 或留空，會保留既有的無複製行為與路徑重寫。這種撰寫風格在文件中已棄用，但仍受支援，且不會有執行階段棄用警告；請加入 `resources` 並使用技能相對路徑來採用複製模式。

---

## 命令檔案格式

### Frontmatter（YAML）

```yaml
---
description: "Command description"          # Recommended
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

其他整合的呼叫格式，請參閱共用的[命令呼叫參考](../integrations/cli.md#命令呼叫方式)。

### 指令碼路徑重寫

在[技能資源複製模式](#skill-resources)之外，登錄器在渲染命令時會正規化輔助程式路徑。
含有兩個以上 `../` 區段的儲存庫根目錄參照，指向專案的核心指令稿。

**在擴充功能中**：

```yaml
scripts:
  sh: ../../scripts/bash/helper.sh
```

在命令主體中使用 `{SCRIPT}` 來呼叫選取的指令稿變體。對於此範例，產生的呼叫如下：

```bash
.specify/scripts/bash/helper.sh
```

裸寫的 `scripts/helper.sh` 則指向擴充功能自有指令稿 `.specify/extensions/<extension-id>/scripts/helper.sh`。產生的輸出格式可能在解析 `{SCRIPT}` 後省略原始的 `scripts` frontmatter；請勿依賴該中繼資料在已安裝的命令或技能中留存。

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
  key: ""  # Set with SPECKIT_MY_EXT_API_KEY; do not commit credentials

features:
  feature_a: true
  feature_b: false
```

### 設定載入

在你的命令中，以分層優先順序載入設定：

1. 擴充功能預設值（`extension.yml` → `defaults`，再取 `config.defaults` 處理任何衝突的鍵）
2. 專案設定（`.specify/extensions/my-ext/my-ext-config.yml`）
3. 本機覆寫（`.specify/extensions/my-ext/local-config.yml`——gitignored）
4. 環境變數（`SPECKIT_MY_EXT_*`）

對於在已安裝 `specify-cli` 的環境中執行的 Python 程式碼，請使用既有的載入器，而非重複實作合併：

```python
from pathlib import Path
from specify_cli.extensions import ConfigManager

config = ConfigManager(Path.cwd(), "my-ext").get_config()
endpoint = config.get("api", {}).get("endpoint")
```

請從專案根目錄執行，或明確傳入該根目錄。環境變數的組成部分會成為巢狀鍵：`SPECKIT_MY_EXT_API_KEY` 會覆寫 `api.key`。值維持字串；YAML `${...}` 佔位符不會被展開。以其他語言實作的命令若需要此分層，必須自行提供載入。

Spec Kit 不會使用 `config_schema` 來驗證設定。請在你的擴充功能命令或指令稿中驗證必要的值與類型。

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

- **格式**：PEP 440；發行版本建議使用 SemVer（`MAJOR.MINOR.PATCH`）
- **有效**：`1.0.0`、`0.1.0`、`2.5.3`
- **CLI 亦接受**：`1.0`、`v1.0.0`、`1.0.0-beta`
- **無效**：`latest`、`not-a-version`

社群提交對發行版本有更嚴格的要求；請參閱[提交驗證](publishing.md#提交驗證)。

### 命令名稱

- **模式**：`^speckit\.[a-z0-9-]+\.[a-z0-9-]+$`
- **有效**：`speckit.my-ext.hello`、`speckit.tool.cmd`
- **無效**：`other-ext.hello`（錯誤的命名空間）、`speckit.my-ext.Create`（大寫）

舊版的 `my-ext.hello` 與 `speckit.hello` 會正規化為 `speckit.my-ext.hello`，並發出警告。請在新的資訊清單中使用正式名稱。

### 命令檔案路徑

- **必須**相對於擴充功能根目錄
- **有效**：`commands/hello.md`、`commands/subdir/cmd.md`
- **無效**：`/absolute/path.md`、`../outside.md`

---

## 測試擴充功能

### 手動測試

1. 在已設定 [Copilot skills](../integrations/copilot.md#設定) 的專案中**建立測試擴充功能**。
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

### 選項 2：ZIP 封存檔

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
   - 使用者在直接安裝或加入自己信任的型錄之前，會先審查發行封存檔
   - 使用者以 `--from <archive-url>` 安裝，或從他們審查過的型錄安裝

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

一個事件多個命令，依目前命令範本的 YAML 順序呈現（`HookExecutor` 則改為依 `priority` 排序，數字越小越先）：

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

- **修正**：使用[升級指南](../upgrade.md)升級 Spec Kit。`uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git` 仍可作為從原始碼安裝的備援方式。如果你是從 PyPI 安裝並希望沿用該路徑，請遵循 [PyPI 升級指南](../install/pypi.md#升級)。

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

**修正**：確認 Copilot 已設定為 [skills 配置](../integrations/copilot.md#預設技能版式)，然後重新安裝擴充功能以觸發註冊。

### 設定未載入

**檢查**：

1. 設定檔存在：`.specify/extensions/{ext-id}/{ext-id}-config.yml`
2. YAML 語法有效：`yq eval '.' config.yml`
3. 環境變數設定正確

---

## 取得協助

- **Issue**：在 GitHub 儲存庫回報錯誤
- **討論**：在 GitHub Discussions 提問
- **範例**：請參閱內建的 [GitHub](https://github.com/github/spec-kit/tree/main/extensions/github) 與 [bug](https://github.com/github/spec-kit/tree/main/extensions/bug) 擴充功能

---

## 後續步驟

1. 依本指南**建立你的擴充功能**
2. 以 `--dev` 旗標**在本機測試**
3. **與社群分享**（GitHub、型錄）
4. 根據回饋**迭代**

祝擴充愉快！🚀

> 本頁的代理呼叫範例使用 GitHub Copilot 的預設 skills 語法（`/speckit-*`）。其他整合與模式，請參閱[命令呼叫](../integrations/cli.md#命令呼叫方式)。

## 另請參閱

- [擴充功能 API 參考](api.md)
- [擴充功能 CLI 參考](cli.md)
- [擴充功能型錄](catalogs.md)
- [發佈擴充功能](publishing.md)
- [擴充功能使用者指南](overview.md)
