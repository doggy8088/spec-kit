# AGENTS.md

## 關於 Spec Kit 與 Specify

**GitHub Spec Kit** 是一套完整的工具包，用於實現規格驅動開發（Spec-Driven Development, SDD）——這是一種強調在實作前先建立明確規格的開發方法論。此工具包包含範本、腳本與工作流程，協助開發團隊以結構化的方式進行軟體建置。

**Specify CLI** 是一個命令列介面（Command Line Interface），可用於以 Spec Kit 框架快速建立專案。它會設定必要的目錄結構、範本，以及 AI agent 整合，以支援規格驅動開發的工作流程。

此工具包支援多種 AI 程式輔助工具（coding assistants），讓團隊能夠在維持一致的專案結構與開發實踐的同時，使用自己偏好的工具。

---

## 一般作業規範

- 任何對 `__init__.py` 的 Specify CLI 變更，都需要在 `pyproject.toml` 進行版本更新，並在 `CHANGELOG.md` 增加對應條目。

## 新增 Agent 支援

本節說明如何為 Specify CLI 新增對新的 AI agent/助理的支援。當你要將新的 AI 工具整合進規格驅動開發工作流程時，請參考本指南。

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
| **Windsurf** | `.windsurf/workflows/` | Markdown | 無（基於 IDE） | Windsurf IDE 工作流程 |

### 步驟式整合指南

請依照以下步驟新增 agent（以 Windsurf 為例）：

#### 1. 更新 AI_CHOICES 常數

將新 agent 加入 `src/specify_cli/__init__.py` 中的 `AI_CHOICES` dictionary：

```python
AI_CHOICES = {
    "copilot": "GitHub Copilot",
    "claude": "Claude Code", 
    "gemini": "Gemini CLI",
    "cursor": "Cursor",
    "qwen": "Qwen Code",
    "opencode": "opencode",
    "windsurf": "Windsurf"  # Add new agent here
}
```

同時也請在同一個檔案中的 `agent_folder_map` 加入新 agent 資料夾，以納入安全性公告：

```python
agent_folder_map = {
    "claude": ".claude/",
    "gemini": ".gemini/",
    "cursor": ".cursor/",
    "qwen": ".qwen/",
    "opencode": ".opencode/",
    "codex": ".codex/",
    "windsurf": ".windsurf/",  # Add new agent folder here
    "kilocode": ".kilocode/",
    "auggie": ".auggie/",
    "copilot": ".github/"
}
```

#### 2. 更新 CLI 說明文字

更新所有說明文字與範例，以納入新代理（agent）：

- 指令選項說明：`--ai` 參數描述
- 函式（function）註解與範例
- 包含代理列表的錯誤訊息

#### 3. 更新 README 文件

在 `README.md` 的 **Supported AI Agents**（支援的 AI 代理）區段中，加入新代理：

- 將新代理加入表格，並標註適當的支援等級（Full/Partial）
- 包含該代理的官方網站連結
- 加入任何與該代理實作相關的說明
- 確保表格格式保持對齊且一致

#### 4. 更新發行套件腳本

修改 `.github/workflows/scripts/create-release-packages.sh`：

##### 新增至 ALL_AGENTS 陣列：
```bash
ALL_AGENTS=(claude gemini copilot cursor qwen opencode windsurf)
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

對於需要 CLI 工具的 agent，請在 `check()` 指令與 agent 驗證中新增檢查：

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

**注意**：針對以 IDE 為基礎的 agent（如 Copilot、Windsurf），請略過 CLI 檢查。

## Agent 分類

### 基於 CLI 的 Agent
需要安裝命令列工具（Command Line Interface）：
- **Claude Code**：`claude` CLI
- **Gemini CLI**：`gemini` CLI  
- **Cursor**：`cursor-agent` CLI
- **Qwen Code**：`qwen` CLI
- **opencode**：`opencode` CLI

### 基於 IDE 的 Agent
在整合式開發環境（IDE）中運作：
- **GitHub Copilot**：內建於 VS Code 或相容的編輯器
- **Windsurf**：內建於 Windsurf IDE

## 指令檔案格式

### Markdown 格式
適用於：Claude、Cursor、opencode、Windsurf

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

- **CLI agents（命令列代理）**：通常為 `.<agent-name>/commands/`
- **IDE agents（整合式開發環境代理）**：遵循各 IDE 的專屬命名規則：
  - Copilot：`.github/prompts/`
  - Cursor：`.cursor/commands/`
  - Windsurf：`.windsurf/workflows/`

## 參數格式慣例

不同代理會使用不同的參數占位符：
- **Markdown/提示式**：`$ARGUMENTS`
- **TOML 格式**：`{{args}}`
- **腳本占位符**：`{SCRIPT}`（會被實際腳本路徑取代）
- **代理占位符**：`__AGENT__`（會被代理名稱取代）

## 測試新代理整合

1. **建置測試**：在本地執行套件建立腳本
2. **CLI 測試**：測試 `specify init --ai <agent>` 指令
3. **檔案產生**：確認目錄結構與檔案正確
4. **指令驗證**：確保產生的指令可與代理正常運作
5. **Context 更新**：測試代理 context 更新腳本

## 常見陷阱

1. **忘記更新腳本**：bash 與 PowerShell 腳本都必須一併更新
2. **漏加 CLI 檢查**：僅針對實際有 CLI 工具的代理新增
3. **參數格式錯誤**：針對不同代理型態，請使用正確的占位符格式
4. **目錄命名**：務必完全遵循代理專屬命名慣例
5. **說明文字不一致**：所有對使用者顯示的文字都需同步更新

## 未來注意事項

新增代理時請注意：
- 考量代理本身的原生指令/工作流程慣例
- 確保與 Spec-Driven Development 流程相容
- 詳細記錄任何特殊需求或限制
- 將經驗教訓補充至本指南

---

*每當新增代理時，請務必同步更新本文件，以維持準確性與完整性。*