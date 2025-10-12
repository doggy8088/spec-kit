# AGENTS.md

## 關於 Spec Kit 與 Specify

**GitHub Spec Kit** 是一套完整的工具包，用於實現 Spec-Driven Development（SDD）——這是一種強調在實作前先建立明確規格的開發方法論。此工具包包含範本、腳本與工作流程，協助開發團隊以結構化的方式進行軟體建置。

**Specify CLI** 是命令列介面（Command Line Interface），可用於以 Spec Kit 框架快速建立專案。它會設定必要的目錄結構、範本，以及 AI agent 整合，以支援 Spec-Driven Development 工作流程。

此工具包支援多種 AI 編碼輔助工具（AI coding assistants），讓團隊能夠在維持一致的專案結構與開發實踐的同時，使用自己偏好的工具。

---

## 一般作業規範

- 任何對 `__init__.py` 的 Specify CLI 變更，都需要在 `pyproject.toml` 進行版本更新，並在 `CHANGELOG.md` 增加對應條目。

## 新增 Agent 支援

本節說明如何為 Specify CLI 新增對新的 AI agent/助理的支援。當你要將新的 AI 工具整合進 Spec-Driven Development 工作流程時，請參考本指南。

### 概述

Specify 透過在初始化專案時產生 agent 專屬的指令檔案與目錄結構，來支援多種 AI agent。每個 agent 都有其專屬的慣例，包括：

- **指令檔案格式**（Markdown、TOML 等）
- **目錄結構**（`.claude/commands/`、`.windsurf/workflows/` 等）
- **指令呼叫模式**（slash 指令、CLI 工具等）
- **參數傳遞慣例**（`$ARGUMENTS`、`{{args}}` 等）

### 目前支援的 Agents

| Agent | 目錄 | 格式 | CLI 工具 | 說明 |
|-------|-----------|---------|----------|-------------|
| **Claude Code** | `.claude/commands/` | Markdown | `claude` | Anthropic 的 Claude Code CLI |
| **Gemini CLI** | `.gemini/commands/` | TOML | `gemini` | Google 的 Gemini CLI |
| **GitHub Copilot** | `.github/prompts/` | Markdown | 無（基於 IDE） | GitHub Copilot in VS Code |
| **Cursor** | `.cursor/commands/` | Markdown | `cursor-agent` | Cursor CLI |
| **Qwen Code** | `.qwen/commands/` | TOML | `qwen` | 阿里巴巴的 Qwen Code CLI |
| **opencode** | `.opencode/command/` | Markdown | `opencode` | opencode CLI |
| **Codex CLI** | `.codex/commands/` | Markdown | `codex` | Codex CLI |
| **Windsurf** | `.windsurf/workflows/` | Markdown | 無（基於 IDE） | Windsurf IDE 工作流程 |
| **Kilo Code** | `.kilocode/rules/` | Markdown | 無（基於 IDE） | Kilo Code IDE |
| **Auggie CLI** | `.augment/rules/` | Markdown | `auggie` | Auggie CLI |
| **Roo Code** | `.roo/rules/` | Markdown | 無（基於 IDE） | Roo Code IDE |
| **CodeBuddy** | `.codebuddy/commands/` | Markdown | `codebuddy` | CodeBuddy |
| **Amazon Q Developer CLI** | `.amazonq/prompts/` | Markdown | `q` | Amazon Q Developer CLI |

### 步驟式整合指南

請依照以下步驟新增 agent（以假設的新 agent 為例）：

#### 1. 加入 AGENT_CONFIG

**重要**：請使用實際的 CLI 工具名稱作為 key，而非簡寫。

將新 agent 加入 `AGENT_CONFIG` dictionary，該 dictionary 位於 `src/specify_cli/__init__.py`。這裡是所有 agent metadata 的**唯一真實來源**：

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

**關鍵設計原則**：字典的 key 應與使用者實際安裝的可執行檔名稱相符。例如：
- ✅ 使用 `"cursor-agent"`，因為命令列工具（CLI tool）實際名稱就是 `cursor-agent`
- ❌ 如果工具名稱是 `cursor-agent`，不要用 `"cursor"` 作為簡寫

這樣可以避免在整個程式碼庫中需要特殊對應的情況。

**欄位說明**：
- `name`：顯示給使用者看的易讀名稱
- `folder`：儲存 agent 專屬檔案的目錄（相對於專案根目錄）
- `install_url`：安裝說明文件的 URL（IDE 型 agent 請設為 `None`）
- `requires_cli`：初始化時是否需要檢查該 agent 的命令列工具

#### 2. 更新 CLI 說明文字

請在 `init()` 指令的 `--ai` 參數說明文字中，加入新 agent：

```python
ai_assistant: str = typer.Option(None, "--ai", help="AI assistant to use: claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, codebuddy, new-agent-cli, or q"),
```

#### 也請更新所有包含可用 AI agent 清單的函式註解、範例，以及錯誤訊息。

#### 3. 更新 README 文件

在 `README.md` 的 **Supported AI Agents**（支援的 AI agent）區段中，加入新 agent：

- 將新 agent 加入表格，並標註適當的支援等級（Full/Partial）
- 包含該 agent 的官方網站連結
- 加入任何與該 agent 實作相關的說明
- 確保表格格式保持對齊且一致

#### 4. 更新發行套件腳本

修改 `.github/workflows/scripts/create-release-packages.sh`：

##### 新增至 ALL_AGENTS 陣列：
```bash
ALL_AGENTS=(claude gemini copilot cursor qwen opencode windsurf q)
```

##### 為目錄結構新增 case 陳述式：
```bash
case $agent in
  # ... existing cases ...
  windsurf)
    mkdir -p "$base_dir/.windsurf/workflows"
    generate_commands windsurf md "\$ARGUMENTS" "$base_dir/.windsurf/workflows" "$script" ;;
esac
```

#### 4. 更新 GitHub Release Script

請修改 `.github/workflows/scripts/create-github-release.sh`，將新的 agent 套件包含進去：

```bash
gh release create "$VERSION" \
  # ... existing packages ...
  .genreleases/spec-kit-template-windsurf-sh-"$VERSION".zip \
  .genreleases/spec-kit-template-windsurf-ps-"$VERSION".zip \
  # Add new agent packages here
```

#### 5. 更新 Agent Context 腳本

##### Bash 腳本（`scripts/bash/update-agent-context.sh`）：

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

##### PowerShell 指令碼 (`scripts/powershell/update-agent-context.ps1`):

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

#### 6. 更新 CLI 工具檢查（可選）

對於需要命令列介面 (Command Line Interface, CLI) 工具的 agent，請在 `check()` 指令與 agent 驗證中新增檢查：

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

**注意**：CLI 工具檢查現在會根據 AGENT_CONFIG 中的 `requires_cli` 欄位自動處理。無需在 `check()` 或 `init()` 指令中額外修改程式碼——它們會自動遍歷 AGENT_CONFIG 並根據需要檢查工具。

## 重要設計決策

### 以實際 CLI 工具名稱作為鍵值

**關鍵**：新增 agent 至 AGENT_CONFIG 時，請務必使用**實際可執行檔名稱**作為字典的 key，而不是縮寫或方便記憶的版本。

**為什麼這很重要**：
- `check_tool()` 函式會用 `shutil.which(tool)` 在系統 PATH 中尋找可執行檔
- 如果 key 與實際 CLI 工具名稱不符，整個程式碼庫就需要特別的對應映射
- 這會造成不必要的複雜性與維護負擔

**範例 - Cursor 的教訓**：

❌ **錯誤做法**（需要特別對應映射）：
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

✅ **正確做法**（無需對應關係）：
```python
AGENT_CONFIG = {
    "cursor-agent": {  # Matches the actual executable name
        "name": "Cursor",
        # ...
    }
}

# No special cases needed - just use agent_key directly!
```

**此方法的優點**：
- 消除分散在程式碼庫中的特殊情境邏輯
- 讓程式碼更易於維護與理解
- 新增代理時可降低產生錯誤的機率
- 工具檢查可「直接運作」，無需額外對應設定

## 代理分類

### CLI 型代理（命令列介面代理）

需要安裝命令列工具（CLI）：
- **Claude Code**：`claude` CLI
- **Gemini CLI**：`gemini` CLI
- **Cursor**：`cursor-agent` CLI
- **Qwen Code**：`qwen` CLI
- **opencode**：`opencode` CLI
- **CodeBuddy**：`codebuddy` CLI

### IDE 型代理（整合式開發環境代理）

於整合式開發環境（IDE）內運作：
- **GitHub Copilot**：內建於 VS Code 或相容編輯器
- **Windsurf**：內建於 Windsurf IDE

## 指令檔案格式

### Markdown 格式

適用於：Claude、Cursor、opencode、Windsurf、Amazon Q Developer

---

*每當新增代理時，請務必同步更新本文件，以維持準確性與完整性。*

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

- **命令列介面 (Command Line Interface) agents**：通常為 `.<agent-name>/commands/`
- **IDE agents**：遵循各自 IDE 的命名規則：
  - Copilot：`.github/prompts/`
  - Cursor：`.cursor/commands/`
  - Windsurf：`.windsurf/workflows/`

## 參數樣式

不同的 agent 會使用不同的參數占位符：
- **Markdown/提示為主**：`$ARGUMENTS`
- **TOML 為主**：`{{args}}`
- **腳本占位符**：`{SCRIPT}`（會被實際腳本路徑取代）
- **Agent 占位符**：`__AGENT__`（會被 agent 名稱取代）

## 測試新 Agent 整合 (integration)

1. **建置測試**：在本機執行套件建立腳本
2. **命令列介面 (Command Line Interface) 測試**：測試 `specify init --ai <agent>` 指令
3. **檔案產生**：確認正確的目錄結構與檔案
4. **指令驗證**：確保產生的指令可與該 agent 正常運作
5. **Context 更新**：測試 agent context 更新腳本

## 常見陷阱

1. **使用簡寫鍵而非實際命令列工具名稱**：請務必使用實際可執行檔名稱作為 AGENT_CONFIG 的鍵值（例如：`"cursor-agent"`，而非 `"cursor"`）。這樣可避免在程式碼中需要特殊對應。
2. **忘記更新腳本**：新增 agent 時，Bash 與 PowerShell 腳本都必須一併更新。
3. **錯誤的 `requires_cli` 值**：僅對有命令列工具可檢查的 agent 設定為 `True`；IDE 型 agent 則設為 `False`。
4. **錯誤的參數格式**：請針對每種 agent 類型使用正確的占位符格式（Markdown 用 `$ARGUMENTS`，TOML 用 `{{args}}`）。
5. **目錄命名**：務必嚴格遵循 agent 專屬的命名慣例（請參考現有 agent 的命名規則）。
6. **說明文字不一致**：所有面向使用者的說明文字（help 字串、docstring、README、錯誤訊息）都需同步更新。

## 未來注意事項

新增 agent 時請注意：

- 考慮該 agent 原生的指令與工作流程模式
- 確保與 Spec-Driven Development 方法論相容
- 詳細記錄任何特殊需求或限制
- 依據經驗更新本指南
- 在加入 AGENT_CONFIG 前，務必確認實際命令列工具名稱

---

*每當新增 agent 時，請務必同步更新本文件，以確保內容正確且完整。*
