# 安裝指南

## 前置條件

- **Linux／macOS**（或 Windows；PowerShell script 現在不需 WSL 即可支援）
- AI 程式代理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[CodeBuddy CLI](https://www.codebuddy.cn/docs/cli/installation)、[Gemini CLI](https://github.com/google-gemini/gemini-cli)、[Pi Coding Agent](https://pi.dev)，或 [Oh My Pi](https://www.npmjs.com/package/@oh-my-pi/pi-coding-agent)
- [uv](https://docs.astral.sh/uv/) 用於套件管理（建議），或 [pipx](https://pipx.pypa.io/) 用於持久安裝
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads) *（選用——只有在啟用 git 擴充功能時才需要）*

## 安裝

> [!IMPORTANT]
> Spec Kit 透過兩個官方管道發行，兩者都由 Spec Kit 維護者發布與維護：[github/spec-kit](https://github.com/github/spec-kit) GitHub 儲存庫（原始碼安裝），以及 [PyPI](https://pypi.org/project/specify-cli/) 上的 [`specify-cli`](https://pypi.org/project/specify-cli/) 套件。一般安裝兩條路線都受支援——使用下面所示的命令。安裝後，執行 `specify version` 做本地版本／執行環境健全檢查。它確認 `specify` 命令可用並回報其版本，但無法證明該可執行檔來自 PyPI 還是 GitHub。對於離線或氣隙環境，從本儲存庫本地建置的 wheel 也是有效的。

Spec Kit 支援兩條安裝路線：

1. **從原始碼安裝（GitHub）**——建議路線，釘住到某個 release 標籤。
2. **從 PyPI 安裝**——用你慣用的 Python 工具安裝已發布的 `specify-cli` 套件。

### 從原始碼安裝——持久安裝（建議）

安裝一次，到處使用。把 `vX.Y.Z` 換成 [Releases](https://github.com/github/spec-kit/releases) 中的某個 release 標籤——保留開頭的 `v`（例如 `v0.12.11`，不是 `0.12.11`）：

> [!NOTE]
> 下面的命令需要 **[uv](https://docs.astral.sh/uv/)**。若你看到 `command not found: uv`，請[先安裝 uv](./install/uv.md)。

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@vX.Y.Z
```

接著初始化專案：

```bash
specify init <PROJECT_NAME> --integration copilot
```

### 從 PyPI 安裝

Spec Kit 也以 [`specify-cli`](https://pypi.org/project/specify-cli/) 發布到 PyPI，所以你可以用偏好的 Python 套件管理工具安裝它，不必參照 Git URL：

```bash
# Using uv (recommended)
uv tool install specify-cli

# Or using pipx
pipx install specify-cli

# Or using pip
pip install specify-cli
```

若 `specify-cli` 已經安裝，即使有較新的 release，這些命令仍會保留已安裝的版本。把 `specify version` 顯示的版本與 [PyPI 上的最新版本](https://pypi.org/project/specify-cli/) 比較。若要取代較舊的安裝，請使用與原始安裝相同的工具：`uv tool install --force specify-cli`、`pipx install --force specify-cli` 或 `pip install --upgrade specify-cli`。不同的工具可能安裝第二份副本，而讓舊的 `specify` 仍排在 `PATH` 的前面。舊的 CLI 無法從目前的 release 設定專案：例如在 0.1.6，`specify init --integration ...` 會以 `No such option: --integration` 失敗，而 `specify init --ai ...` 會以 `No matching release asset found` 失敗。

若要安裝特定 release，請釘住版本——例如 `uv tool install specify-cli==0.12.11`。詳情請見 [PyPI 安裝指南](install/pypi.md)，包括如何升級，以及如何[從自訂或私有套件索引安裝](install/pypi.md#install-from-a-custom-or-private-package-index)。

### 一次性使用

直接執行而不安裝——請見[一次性使用（uvx）](install/one-time.md)指南。

### 其他套件管理工具

- **PyPI**——請見 [PyPI 安裝指南](install/pypi.md)
- **pipx**——請見 [pipx 安裝指南](install/pipx.md)
- **企業／氣隙**——請見[氣隙安裝指南](install/air-gapped.md)

### 指定整合

互動式終端機會在初始化期間提示你選擇程式代理整合。非互動式工作階段，例如 CI 或管線執行，預設為 GitHub Copilot，除非你傳入 `--integration`。

你可以在初始化時主動指定程式代理整合：

```bash
specify init <project_name> --integration claude
specify init <project_name> --integration gemini
specify init <project_name> --integration copilot
specify init <project_name> --integration codebuddy
specify init <project_name> --integration pi
specify init <project_name> --integration omp
```

README 範例使用 GitHub Copilot 的預設 skills 模式。若要使用其他受支援的代理，把 `copilot` 換成它的[整合鍵](integrations/index.md)。每個代理與模式所使用的語法，請見[命令呼叫](integrations/cli.md#command-invocation)。

### 指定 Script 類型（Shell、PowerShell 或 Python）

自動化 script 提供 Bash（`.sh`）、PowerShell（`.ps1`）與 Python（`.py`）三種變體。

自動行為：

- Windows 預設：`ps`
- 其他作業系統預設：`sh`
- 互動模式：除非你傳入 `--script`，否則會提示你

強制指定特定 script 類型：

```bash
specify init <project_name> --script sh
specify init <project_name> --script ps
specify init <project_name> --script py
```

### CI 與 AI 代理框架

對於沒有鍵盤、或 PTY 無法傳送方向鍵的環境，傳入 `--non-interactive`，讓初始化永遠不會卡在選擇器上：

```bash
specify init my-project --non-interactive --ignore-agent-tools
```

`--ignore-agent-tools` 會在代理將在其他地方執行時，略過代理可執行檔檢查；若你想要那項檢查，就省略它。非互動式初始化預設為 Copilot，除非你明確選擇其他整合。

對於非空目錄，`--force` 表示確認合併警告。在初始化之前，請檢視[既有專案指南](guides/existing-projects.md)，並提交或備份本地變更：

```bash
specify init --here --force --non-interactive --integration claude
```

### 略過代理工具檢查

若你偏好在不檢查正確工具的情況下取得範本：

```bash
specify init <project_name> --integration claude --ignore-agent-tools
```

## 驗證

安裝後，執行下列命令做本地版本／執行環境檢查：

```bash
specify version
```

這確認 `specify` 命令可用，並回報預期的版本。它無法證明該可執行檔來自 PyPI 還是 GitHub。

**保持最新**：定期執行 `specify self check`，了解是否有較新的 release 可用——它是唯讀的，永遠不會修改你的安裝。當你準備好升級時，請依[升級指南](./upgrade.md)。

初始化之後，你應該會在程式代理中看到下列命令可用：

- `/speckit.specify` - 建立規格
- `/speckit.plan` - 產生成實作計畫
- `/speckit.tasks` - 拆解為可執行的任務
- `/speckit.implement` - 執行實作任務
- `/speckit.analyze` - 驗證跨產出物的一致性
- `/speckit.clarify` - 找出並釐清模糊之處
- `/speckit.checklist` - 產生品質檢核清單
- `/speckit.constitution` - 建立或更新專案原則
- `/speckit.converge` - 對照產出物評估程式碼庫，並追加剩餘任務

Script 會安裝到與所選 script 類型相符的變體子目錄中：

- `.specify/scripts/bash/`——包含 `.sh` script（Linux／macOS 預設）
- `.specify/scripts/powershell/`——包含 `.ps1` script（Windows 預設）
- `.specify/scripts/python/`——包含 `.py` script（以 `--script py` 選擇；同時安裝平台 shell 的後備）

## 選擇流程

初始化之後，在專案目錄中啟動你的程式代理，並依 [SDD 快速入門](quickstart.md)、[錯誤修復快速入門](guides/bugfix.md) 或[構想評估快速入門](guides/assessment.md)。這些是獨立的進入點。SDD 可以立即使用；其他指南說明如何安裝它們隨附的選用擴充功能。

## 疑難排解

### 企業／氣隙安裝

若你的環境封鎖了對 PyPI 或 GitHub 的存取，請見[企業／氣隙安裝](install/air-gapped.md)指南，了解建立可攜式 wheel 套件組的逐步說明。

### Linux 上的 Git Credential Manager

若你在 Linux 上遇到 Git 驗證問題，請見[氣隙安裝指南](install/air-gapped.md#git-credential-manager-on-linux)了解 Git Credential Manager 的設定說明。
