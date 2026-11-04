# 本地開發指南

本指南說明如何在本地反覆迭代 `specify` CLI，而不必先發布 release 或提交到 `main`。

> Script 提供 Bash（`.sh`）、PowerShell（`.ps1`）與 Python（`.py`）三種變體。互動式 `specify init` 會提示你選擇一種；非互動執行（沒有 TTY，或 `--non-interactive`）預設使用你作業系統的 shell 變體。傳入 `--script sh|ps|py` 可明確選擇。

關於專案如何使用自己的 SDD 與評估流程，請見貢獻者指南中的 [Does Spec Kit use Spec Kit?](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#does-spec-kit-use-spec-kit)。

## 1. 複製並切換分支

```bash
git clone https://github.com/github/spec-kit.git
cd spec-kit
# Work on a feature branch
git checkout -b your-feature-branch
```

## 2. 直接執行 CLI（回饋最快）

你可以透過模組進入點執行 CLI，不必安裝任何東西：

```bash
# From repo root
python -m src.specify_cli --help
python -m src.specify_cli init demo-project --integration claude --ignore-agent-tools --script sh
```

若你偏好以 script 檔案風格呼叫（使用 shebang）：

```bash
python src/specify_cli/__init__.py init demo-project --script ps
```

## 3. 使用可編輯安裝（隔離環境）

用 `uv` 建立隔離環境，讓相依性的解析方式與終端使用者完全一致：

```bash
# Create & activate virtual env (uv auto-manages .venv)
uv venv
source .venv/bin/activate  # or on Windows PowerShell: .venv\Scripts\Activate.ps1

# Install project in editable mode
uv pip install -e .

# Now 'specify' entrypoint is available
specify --help
```

由於是可編輯模式，編輯程式碼後重新執行不需要重新安裝。

## 4. 直接從 Git 以 uvx 呼叫（目前分支）

`uvx` 可以從本地路徑（或 Git 參照）執行，模擬使用者流程：

```bash
uvx --from . specify init demo-uvx --integration copilot --ignore-agent-tools --script sh
```

你也可以讓 uvx 指向特定分支而不合併：

```bash
# Push your working branch first
git push origin your-feature-branch
uvx --from git+https://github.com/github/spec-kit.git@your-feature-branch specify init demo-branch-test --script ps
```

### 4a. 絕對路徑 uvx（從任何地方執行）

若你在另一個目錄中，改用絕對路徑而不是 `.`：

```bash
uvx --from /mnt/c/GitHub/spec-kit specify --help
uvx --from /mnt/c/GitHub/spec-kit specify init demo-anywhere --integration copilot --ignore-agent-tools --script sh
```

為方便起見，設定一個環境變數：

```bash
export SPEC_KIT_SRC=/mnt/c/GitHub/spec-kit
uvx --from "$SPEC_KIT_SRC" specify init demo-env --integration copilot --ignore-agent-tools --script ps
```

（選用）定義一個 shell 函式：

```bash
specify-dev() { uvx --from /mnt/c/GitHub/spec-kit specify "$@"; }
# Then
specify-dev --help
```

## 5. 測試 Script 權限邏輯

執行 `init` 後，檢查 shell script 在 POSIX 系統上是否可執行：

```bash
ls -l scripts | grep .sh
# Expect owner execute bit (e.g. -rwxr-xr-x)
```

在 Windows 上，你改用 `.ps1` script（不需要 chmod）。

## 6. 開發內建整合

請依[代理整合設計](https://github.com/github/spec-kit/blob/main/design/integration.md#adding-an-agent)，了解實作契約、註冊與行為涵蓋範圍。型錄條目與提交指引請見[貢獻整合](integrations/contributing.md)。

## 7. 執行 Lint／基本檢查

CI 強制執行 `ruff check src tests`（見 `.github/workflows/test.yml`），所以推送前請先在本地執行：

```bash
uvx ruff check src tests
```

你也可以快速健全檢查是否可匯入：

```bash
python -c "import specify_cli; print('Import OK')"
```

## 8. 本地建置 Wheel（選用）

發布前先驗證封裝：

```bash
uv build
ls dist/
```

若需要，把建置出的產出物安裝到一個全新的拋棄式環境中。

## 9. 使用暫時工作區

在骯髒的目錄中測試 `init --here` 時，建立一個暫時工作區：

```bash
mkdir /tmp/spec-test && cd /tmp/spec-test
python -m src.specify_cli init --here --integration claude --ignore-agent-tools --script sh  # if repo copied here
```

或者只複製修改過的 CLI 部分，取得更輕量的沙箱。

## 10. 除錯網路／TLS 問題

> **已棄用：** `--skip-tls` 旗標是無作用的，不會有任何效果。
> 它先前用於在本地測試期間繞過 TLS 驗證。
> 若你遇到 TLS 錯誤（例如在公司網路上），請改為設定你環境的憑證存放區或 proxy。
>
> 例如，設定 `SSL_CERT_FILE`，或設定 `HTTPS_PROXY`／`HTTP_PROXY`。

## 11. 快速編輯循環摘要

| 動作 | 命令 |
|--------|---------|
| 直接執行 CLI | `python -m src.specify_cli --help` |
| 可編輯安裝 | `uv pip install -e .` 再 `specify ...` |
| 本地 uvx 執行（儲存庫根目錄） | `uvx --from . specify ...` |
| 本地 uvx 執行（絕對路徑） | `uvx --from /mnt/c/GitHub/spec-kit specify ...` |
| Git 分支 uvx | `uvx --from git+URL@branch specify ...` |
| 建置 wheel | `uv build` |

## 12. 清理

快速移除建置產出物／虛擬環境：

```bash
rm -rf .venv dist build *.egg-info
```

## 13. 常見問題

| 症狀 | 修復方式 |
|---------|-----|
| `ModuleNotFoundError: typer` | 執行 `uv pip install -e .` |
| Script 不可執行（Linux） | 重新執行 init，或 `chmod +x scripts/*.sh` |
| Git 命令不可用 | 用 `specify extension add git` 安裝 git 擴充功能 |
| 下載到錯誤的 script 類型 | 明確傳入 `--script sh`、`--script ps` 或 `--script py` |
| 公司網路上的 TLS 錯誤 | 設定你環境的憑證存放區或 proxy。`--skip-tls` 旗標已棄用且無作用。 |

## 14. 後續步驟

- 更新文件，並用你修改過的 CLI 跑一次快速入門
- 滿意後開啟 PR
- （選用）變更進入 `main` 後標記一個 release
