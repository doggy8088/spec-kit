# 安裝 uv

[uv](https://docs.astral.sh/uv/) 是由 [Astral](https://astral.sh/) 開發的快速 Python 套件管理工具。Spec Kit 使用 `uv`（透過 `uvx` 或 `uv tool install`）執行 `specify` CLI，不會污染你的全域 Python 環境。

> [!NOTE]
> **已經有 uv 了嗎？** 執行 `uv --version` 確認它已安裝，然後回到[安裝指南](../installation.md)。

## 安裝

### macOS 與 Linux——獨立安裝程式

在 macOS 或 Linux 上安裝 uv 最快的方式是使用官方 shell 指令稿：

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

指令稿執行完畢後，請依照安裝程式印出的指示將 uv 加入你的 `PATH`，然後開啟新的終端機。

### Windows——獨立安裝程式

在 **Command Prompt 或 PowerShell** 中執行下列指令：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

指令稿執行完畢後，開啟新的終端機，讓 `uv` 執行檔出現在你的 `PATH` 上。

### macOS——Homebrew

```bash
brew install uv
```

### Windows——WinGet

```powershell
winget install --id=astral-sh.uv -e
```

### Windows——Scoop

```powershell
scoop install uv
```

## 驗證

確認 uv 已安裝且位於你的 `PATH` 上：

```bash
uv --version
```

你應該會看到類似 `uv 0.x.y (...)` 的輸出。

## 延伸閱讀

進階選項（自我更新、代理伺服器設定、解除安裝等）請參閱官方 [uv 安裝文件](https://docs.astral.sh/uv/getting-started/installation/)。
