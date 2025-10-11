# 安裝指南

## 先決條件

- **Linux/macOS**（或 Windows；現已支援 PowerShell 腳本，無需 WSL）
- AI 編碼代理工具：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- 用於套件管理的 [uv](https://docs.astral.sh/uv/)
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 安裝

### 初始化新專案

最簡單的入門方式是初始化一個新專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

或者在目前目錄中初始化：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init .
# or use the --here flag
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

### 指定 AI agent

您可以在初始化時主動指定您的 AI agent：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai gemini
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai copilot
```

### 指定腳本類型（Shell 與 PowerShell）

所有自動化腳本現在都提供 Bash（`.sh`）與 PowerShell（`.ps1`）兩種版本。

自動行為：
- Windows 預設：`ps`
- 其他作業系統預設：`sh`
- 互動模式 (Interactive mode)：除非你傳遞 `--script`，否則系統會提示你選擇

強制指定特定腳本類型：
```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --script sh
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --script ps
```

### 忽略 Agent 工具檢查

如果你希望在不檢查正確工具的情況下取得範本：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude --ignore-agent-tools
```

## 驗證

初始化完成後，你應該會在你的 AI agent 中看到以下指令可用：
- `/speckit.specify` - 建立規格說明
- `/speckit.plan` - 產生實作計畫  
- `/speckit.tasks` - 拆解為可執行任務

`.specify/scripts` 目錄將會包含 `.sh` 和 `.ps1` 腳本。

## 疑難排解

### Linux 上的 Git Credential Manager

如果你在 Linux 上遇到 Git 認證相關問題，可以安裝 Git Credential Manager：

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```
