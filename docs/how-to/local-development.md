# 如何在本機開發 Spec Kit

在每個 checkout 或 worktree 中使用各自獨立的 `.venv`，以可編輯模式安裝該 checkout，並透過明確的環境路徑執行其 CLI 與測試。如此可讓本機變更與全域安裝的發行版本及其他 Spec Kit checkout 隔離開來。不需要啟用環境。

## 1. 準備 Checkout

安裝 [Python 3.11+](https://www.python.org/downloads/)、[uv](https://docs.astral.sh/uv/) 與 [Git](https://git-scm.com/downloads/)。複製你的 fork，並依照[分支命名指引](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#branch-naming)在功能分支上工作。從該 checkout 的儲存庫根目錄執行以下設定。

在 macOS 或 Linux 上：

```bash
uv sync --extra test
uv pip install --python .venv/bin/python -e .
.venv/bin/specify --help
```

在 Windows PowerShell 上：

```powershell
uv sync --extra test
uv pip install --python .venv\Scripts\python.exe -e .
.\.venv\Scripts\specify.exe --help
```

`uv sync --extra test` 會建立專案環境並安裝其測試相依性。明確的可編輯安裝會以同一個環境為目標。編輯 Python 原始碼後不需要重新安裝；相依性中繼資料變更時再重新執行設定。

## 2. 執行聚焦的自動化檢查

先從涵蓋你變更的測試開始，並以實際的測試路徑取代以下範例。

在 macOS 或 Linux 上：

```bash
.venv/bin/python -m pytest tests/test_agent_config_consistency.py -q
```

在 Windows PowerShell 上：

```powershell
.\.venv\Scripts\python.exe -m pytest tests/test_agent_config_consistency.py -q
```

要執行完整測試套件，請將測試檔案換成 `tests`。在 macOS 上，請為測試設定 `LC_ALL=en_US.UTF-8`，讓 Bash 的 Unicode 處理使用 UTF-8 locale：

```bash
LC_ALL=en_US.UTF-8 .venv/bin/python -m pytest tests -q
```

執行與 CI 相同的 Ruff 版本：

```bash
uvx ruff@0.15.0 check src tests
```

Ruff 是獨立執行的 lint 工具；Spec Kit CLI 與 pytest 只能透過該 checkout 的 `.venv` 執行。正面與負面覆蓋率、迴歸證據、Windows PowerShell 5.1 相容性及其他檢查，請參閱[貢獻者測試指引](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#testing-deterministic-behavior)。

## 3. 在獨立專案中測試 CLI

在 Spec Kit checkout 之外初始化一個用完即棄的專案，並使用該 checkout 的 CLI。選擇你的代理的[整合金鑰](../integrations/index.md)。

在 macOS 或 Linux 上，從 Spec Kit 儲存庫根目錄執行：

```bash
.venv/bin/specify init /tmp/spec-kit-test --integration <key> --script sh
```

在 Windows PowerShell 上，從 Spec Kit 儲存庫根目錄執行：

```powershell
.\.venv\Scripts\specify.exe init "$env:TEMP\spec-kit-test" --integration <key> --script ps
```

每個獨立測試請使用未使用過的專案目錄。測試 Python 指令稿變體時請使用 `--script py`。在你的程式代理中開啟產生的專案，並在 slash 命令行為變更時遵循[手動測試流程](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#manual-testing-process)。

如果要從產生的專案中執行更多 CLI 命令，請使用 Spec Kit checkout 執行檔的絕對路徑；不要切換到全域安裝的 `specify`。請將以下範例 checkout 路徑換成你實際的 checkout 路徑。例如，要在產生的專案中檢查 CLI 並加入 git 擴充功能：

在 macOS 或 Linux 上：

```bash
"/path/to/spec-kit/.venv/bin/specify" --help
"/path/to/spec-kit/.venv/bin/specify" extension add git
```

在 Windows PowerShell 上：

```powershell
& "C:\path\to\spec-kit\.venv\Scripts\specify.exe" --help
& "C:\path\to\spec-kit\.venv\Scripts\specify.exe" extension add git
```

PowerShell 呼叫運算子（`&`）會執行引用的路徑，包括含有空格的路徑。

產生的指令稿位於 `.specify/scripts/` 之下。在 macOS 或 Linux 上測試 Bash 指令稿權限時，請從產生的專案中檢查它們：

```bash
ls -l .specify/scripts/bash/*.sh
```

指令稿應該具有擁有者執行位元。Windows 上的 PowerShell 指令稿不需要 `chmod`。

## 4. 在相關時檢查封裝

若有封裝變更，請從 Spec Kit 儲存庫根目錄建置 wheel：

```bash
uv build
```

檢查 `dist/` 中的產出物。封裝驗證是可編輯安裝開發循環的補充，不能取代測試環境。

## 常見問題

| 症狀 | 處理方式 |
| --- | --- |
| 缺少 Python 相依性 | 從這個 checkout 的根目錄重新執行設定命令。 |
| 測試或 CLI 使用了另一個 checkout | 使用這個 checkout 明確的 `.venv` 執行檔路徑。 |
| 產生的專案中無法使用 Git 命令 | 從產生的專案中，使用其絕對 `.venv` 路徑執行該 checkout 的 CLI，並執行 `extension add git`。 |
| 產生了錯誤的指令稿變體 | 明確傳入 `--script sh`、`--script ps` 或 `--script py`。 |
| 公司網路發生 TLS 錯誤 | 設定憑證儲存區或 proxy，例如使用 `SSL_CERT_FILE`、`HTTPS_PROXY` 或 `HTTP_PROXY`。已棄用的 `--skip-tls` 旗標沒有作用。 |

## 另請參閱

- [貢獻者指南](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md)
- [貢獻整合](../integrations/contributing.md)
- [整合 API 參考](../integrations/api.md)
- [規格驅動開發快速入門](../quickstart.md)
- [Spec Kit 有使用 Spec Kit 嗎？](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#does-spec-kit-use-spec-kit)
