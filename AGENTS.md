# AGENTS.md

## 關於 Spec Kit 與 Specify

**GitHub Spec Kit** 是一套完整的工具包，用於實踐 Spec-Driven Development（SDD，規格驅動開發）方法論——這是一種強調在實作前先建立明確規格的開發流程。此工具包包含範本、腳本與工作流程，協助開發團隊以結構化方式進行軟體建置。

**Specify CLI** 是用於專案初始化的命令列介面（Command Line Interface），可透過 Spec Kit 框架快速建立專案。它會設定必要的目錄結構、範本，以及 AI agent 整合，全面支援 Spec-Driven Development 的工作流程。

此工具包支援多種 AI 程式設計輔助工具（AI coding assistants），讓團隊能依偏好選擇工具，同時維持一致的專案結構與開發實踐。

---

## 一般實務

- 任何對 `__init__.py` 的 Specify CLI 變更，都必須在 `pyproject.toml` 進行版本號提升，並於 `CHANGELOG.md` 新增相關紀錄。

## 新增 AI Agent 支援

本節說明如何為 Specify CLI 新增對新 AI agent/輔助工具的支援。整合新 AI 工具進 Spec-Driven Development 工作流程時，請參考本指南。

### 概覽

Specify 能支援多個 AI agent，於專案初始化時會產生 agent 專屬的指令檔案及目錄結構。每個 agent 皆有其專屬慣例，包括：

- **指令檔案格式**（Markdown、TOML 等）
- **目錄結構**（`.claude/commands/`、`.windsurf/workflows/` 等）
- **指令呼叫模式**（斜線指令、CLI 工具等）
- **參數傳遞慣例**（`$ARGUMENTS`、`{{args}}` 等）

### 目前支援的 Agent

| Agent | 目錄 | 格式 | CLI 工具 | 說明 |
|-------|-----------|---------|----------|-------------|
| **Claude Code** | `.claude/commands/` | Markdown | `claude` | Anthropic 的 Claude Code CLI |
| **Gemini CLI** | `.gemini/commands/` | TOML | `gemini` | Google 的 Gemini CLI |
| **GitHub Copilot** | `.github/prompts/` | Markdown | 無（IDE 為主） | GitHub Copilot（VS Code） |
| **Cursor** | `.cursor/commands/` | Markdown | `cursor-agent` | Cursor CLI |
| **Qwen Code** | `.qwen/commands/` | TOML | `qwen` | 阿里巴巴 Qwen Code CLI |
| **opencode** | `.opencode/command/` | Markdown | `opencode` | opencode CLI |
| **Codex CLI** | `.codex/commands/` | Markdown | `codex` | Codex CLI |
| **Windsurf** | `.windsurf/workflows/` | Markdown | 無（IDE 為主） | Windsurf IDE 工作流程 |
| **Kilo Code** | `.kilocode/rules/` | Markdown | 無（IDE 為主） | Kilo Code IDE |
| **Auggie CLI** | `.augment/rules/` | Markdown | `auggie` | Auggie CLI |
| **Roo Code** | `.roo/rules/` | Markdown | 無（IDE 為主） | Roo Code IDE |
| **CodeBuddy CLI** | `.codebuddy/commands/` | Markdown | `codebuddy` | CodeBuddy CLI |
| **Amazon Q Developer CLI** | `.amazonq/prompts/` | Markdown | `q` | Amazon Q Developer CLI |
| **Amp** | `.agents/commands/` | Markdown | `amp` | Amp CLI |

### 步驟式整合指南

請依下列步驟新增一個新 agent（以下以假設的新 agent 為例）：

#### 1. 新增至 AGENT_CONFIG

**重要**：請使用實際的 CLI 工具名稱作為 key，不要用縮寫。

將新 agent 加入 `src/specify_cli/__init__.py` 中的 `AGENT_CONFIG` 字典。這裡是所有 agent metadata 的**唯一真實來源（single source of truth）**：

```python
AGENT_CONFIG = {
    # ... existing agents ...
    "new-agent-cli": {  # Use the ACTUAL CLI tool name (what users type in terminal)
        "name": "New Agent Display Name",
        "folder": ".newagent/",  # Directory for agent files
        "install_url": "https://example.com/install",  # URL for installation docs (or None if IDE-based)
        "requires_cli": True,  # True if CLI tool required, False for IDE-based agents
    },
}
```

**關鍵設計原則**：字典的 key 應與使用者實際安裝的可執行檔名稱一致。例如：

- ✅ 使用 `"cursor-agent"`，因為命令列工具（CLI tool）的名稱就是 `cursor-agent`
- ❌ 如果工具名稱是 `cursor-agent`，就不要用 `"cursor"` 作為捷徑

這樣可以避免在整個程式碼庫中需要特殊對應的情況。

**欄位說明**：

- `name`：顯示給使用者看的易讀名稱
- `folder`：儲存 agent 專屬檔案的目錄（相對於專案根目錄）
- `install_url`：安裝說明文件的 URL（IDE 型 agent 請設為 `None`）
- `requires_cli`：初始化時 agent 是否需要檢查 CLI 工具

#### 2. 更新 CLI 說明文字

請在 `init()` 指令的 `--ai` 參數說明文字中，加入新 agent：

```python
ai_assistant: str = typer.Option(None, "--ai", help="AI assistant to use: claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, codebuddy, new-agent-cli, or q"),
```

同時更新所有列出可用 AI agent 的函式註解（docstring）、範例與錯誤訊息。

#### 3. 更新 README 文件

在 `README.md` 的 **Supported AI Agents**（支援的 AI agent）區段中，加入新 agent：

- 將新 agent 加入表格，並標註適當的支援等級（Full/Partial）
- 包含該 agent 的官方網站連結
- 加入與該 agent 實作相關的備註
- 確保表格格式保持對齊與一致性

#### 4. 更新 Release Package Script

修改 `.github/workflows/scripts/create-release-packages.sh`：

##### 加入 ALL_AGENTS 陣列

```bash
ALL_AGENTS=(claude gemini copilot cursor-agent qwen opencode windsurf q)
```

##### 為目錄結構新增 case 陳述式

```bash
case $agent in
  # ... existing cases ...
  windsurf)
    mkdir -p "$base_dir/.windsurf/workflows"
    generate_commands windsurf md "\$ARGUMENTS" "$base_dir/.windsurf/workflows" "$script" ;;
esac
```

#### 4. 更新 GitHub Release Script

修改 `.github/workflows/scripts/create-github-release.sh`，將新的 agent 套件納入其中：

```bash
gh release create "$VERSION" \
  # ... existing packages ...
  .genreleases/spec-kit-template-windsurf-sh-"$VERSION".zip \
  .genreleases/spec-kit-template-windsurf-ps-"$VERSION".zip \
  # Add new agent packages here
```

#### 5. 更新 Agent 上下文腳本

##### Bash 腳本 (`scripts/bash/update-agent-context.sh`)

新增檔案變數：

```bash
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/specify-rules.md"
```

新增至 case 陳述式：

```bash
case "$AGENT_TYPE" in
  # ... existing cases ...
  windsurf) update_agent_file "$WINDSURF_FILE" "Windsurf" ;;
  "") 
    # ... existing checks ...
    [ -f "$WINDSURF_FILE" ] && update_agent_file "$WINDSURF_FILE" "Windsurf";
    # Update default creation condition
    ;;
esac
```

##### PowerShell 腳本 (`scripts/powershell/update-agent-context.ps1`)

新增檔案變數：

```powershell
$windsurfFile = Join-Path $repoRoot '.windsurf/rules/specify-rules.md'
```

新增至 switch 陳述式：

```powershell
switch ($AgentType) {
    # ... existing cases ...
    'windsurf' { Update-AgentFile $windsurfFile 'Windsurf' }
    '' {
        foreach ($pair in @(
            # ... existing pairs ...
            @{file=$windsurfFile; name='Windsurf'}
        )) {
            if (Test-Path $pair.file) { Update-AgentFile $pair.file $pair.name }
        }
        # Update default creation condition
    }
}
```

#### 6. 更新 CLI 工具檢查（選用）

對於需要 CLI 工具的 agent，請在 `check()` 指令與 agent 驗證中加入檢查：

```python
# In check() command
tracker.add("windsurf", "Windsurf IDE (optional)")
windsurf_ok = check_tool_for_tracker("windsurf", "https://windsurf.com/", tracker)

# In init validation (only if CLI tool required)
elif selected_ai == "windsurf":
    if not check_tool("windsurf", "Install from: https://windsurf.com/"):
        console.print("[red]Error:[/red] Windsurf CLI is required for Windsurf projects")
        agent_tool_missing = True
```

**注意**：CLI 工具檢查現在會根據 AGENT_CONFIG 中的 `requires_cli` 欄位自動處理。不需要對 `check()` 或 `init()` 指令做任何額外的程式碼變更——它們會自動遍歷 AGENT_CONFIG 並根據需要檢查工具。

## 重要設計決策

### 使用實際 CLI 工具名稱作為鍵值

**關鍵**：當你在 AGENT_CONFIG 中新增代理（agent）時，請務必使用**實際可執行檔名稱**作為字典的鍵值，而不是縮寫或方便記憶的版本。

**為什麼這很重要：**

- `check_tool()` 函式會使用 `shutil.which(tool)` 來在系統 PATH 中尋找可執行檔
- 如果鍵值與實際 CLI 工具名稱不符，你將需要在整個程式碼庫中做特殊對應處理
- 這會造成不必要的複雜度與維護負擔

**範例——Cursor 的教訓：**

❌ **錯誤做法**（需要特殊對應處理）：

```python
AGENT_CONFIG = {
    "cursor": {  # Shorthand that doesn't match the actual tool
        "name": "Cursor",
        # ...
    }
}

# Then you need special cases everywhere:
cli_tool = agent_key
if agent_key == "cursor":
    cli_tool = "cursor-agent"  # Map to the real tool name
```

✅ **正確做法**（無需對應）：

```python
AGENT_CONFIG = {
    "cursor-agent": {  # Matches the actual executable name
        "name": "Cursor",
        # ...
    }
}

# No special cases needed - just use agent_key directly!
```

**此方法的優點：**

- 消除了分散在整個程式碼庫中的特殊情境邏輯
- 讓程式碼更容易維護且更易於理解
- 當新增 AI agent 時，降低產生 bug 的機率
- 工具檢查可「直接運作」，無需額外對應設定

#### 7. 更新 Devcontainer 檔案（選用）

針對有 VS Code 擴充功能或需要命令列介面 (Command Line Interface, CLI) 安裝的 AI agent，請更新 devcontainer 設定檔案：

##### 以 VS Code 擴充功能為基礎的 AI agent

若 AI agent 可作為 VS Code 擴充功能取得，請將其加入 `.devcontainer/devcontainer.json`：

```json
{
  "customizations": {
    "vscode": {
      "extensions": [
        // ... existing extensions ...
        // [New Agent Name]
        "[New Agent Extension ID]"
      ]
    }
  }
}
```

##### 基於 CLI 的 Agent

對於需要 CLI 工具的 agent，請將安裝指令加入 `.devcontainer/post-create.sh`：

```bash
#!/bin/bash

# Existing installations...

echo -e "\n🤖 Installing [New Agent Name] CLI..."
# run_command "npm install -g [agent-cli-package]@latest" # Example for node-based CLI
# or other installation instructions (must be non-interactive and compatible with Linux Debian "Trixie" or later)...
echo "✅ Done"

```

**快速提示：**

- **基於擴充套件的 AI agent**：請加入 `devcontainer.json` 中的 `extensions` 陣列
- **基於命令列介面 (CLI) 的 AI agent**：請將安裝腳本加入 `post-create.sh`
- **混合型 AI agent**：可能同時需要擴充套件與 CLI 的安裝
- **請徹底測試**：確保安裝流程可在 devcontainer 環境中正常運作

## AI agent 分類

### 基於命令列介面 (CLI) 的 AI agent

需要安裝命令列工具：

- **Claude Code**：`claude` CLI
- **Gemini CLI**：`gemini` CLI  
- **Cursor**：`cursor-agent` CLI
- **Qwen Code**：`qwen` CLI
- **opencode**：`opencode` CLI
- **Amazon Q Developer CLI**：`q` CLI
- **CodeBuddy CLI**：`codebuddy` CLI
- **Amp**：`amp` CLI

### 基於 IDE 的 AI agent

於整合式開發環境 (IDE) 內運作：

- **GitHub Copilot**：內建於 VS Code 或相容編輯器
- **Windsurf**：內建於 Windsurf IDE

## 指令檔案格式

### Markdown 格式

適用於：Claude、Cursor、opencode、Windsurf、Amazon Q Developer、Amp

```markdown
---
description: "Command description"
---

Command content with {SCRIPT} and $ARGUMENTS placeholders.
```

### TOML 格式

使用於：Gemini、Qwen

```toml
description = "Command description"

prompt = """
Command content with {SCRIPT} and {{args}} placeholders.
"""
```

## 目錄命名慣例

- **CLI agents**：通常為 `.<agent-name>/commands/`
- **IDE agents**：遵循各 IDE 的命名規則：
  - Copilot：`.github/prompts/`
  - Cursor：`.cursor/commands/`
  - Windsurf：`.windsurf/workflows/`

## 參數模式

不同的 agent 會使用不同的參數占位符：

- **Markdown/提示式**：`$ARGUMENTS`
- **TOML 格式**：`{{args}}`
- **腳本占位符**：`{SCRIPT}`（會被實際腳本路徑取代）
- **Agent 占位符**：`__AGENT__`（會被 agent 名稱取代）

## 測試新 Agent 整合 (integration)

1. **建置測試**：在本地執行套件建立腳本
2. **CLI 測試**：測試 `specify init --ai <agent>` 指令
3. **檔案產生**：確認正確的目錄結構與檔案
4. **指令驗證**：確保產生的指令可與該 agent 正常運作
5. **上下文更新**：測試 agent 專屬上下文檔案的更新腳本

## 常見陷阱

1. **使用簡寫鍵而非實際 CLI 工具名稱**：AGENT_CONFIG 的 key 一律要使用實際可執行檔名稱（例如 `"cursor-agent"`，而不是 `"cursor"`）。這可避免在程式碼中到處需要特例對應。
2. **忘記更新腳本**：新增 agent 時，Bash 與 PowerShell 兩種腳本都必須一併更新。
3. **`requires_cli` 值設定錯誤**：僅對實際有 CLI 工具可檢查的 agent 設為 `True`；IDE 型 agent 請設為 `False`。
4. **參數格式錯誤**：每種 agent 類型請使用正確的占位符格式（Markdown 用 `$ARGUMENTS`，TOML 用 `{{args}}`）。
5. **目錄命名錯誤**：請完全遵循 agent 專屬的命名慣例（可參考現有 agent 的命名模式）。
6. **說明文字不一致**：所有面向使用者的文字（說明字串、docstring、README、錯誤訊息等）都需同步更新。

## 未來注意事項

新增 agent 時請注意：

- 考量該 agent 原生的指令與工作流程模式
- 確保與 Spec-Driven Development 方法論相容
- 詳細記錄任何特殊需求或限制
- 將學到的經驗補充到本指南
- 新增至 AGENT_CONFIG 前，務必確認實際 CLI 工具名稱

---

*每當新增 agent 時，請務必同步更新本文件，以維持準確性與完整性。*
