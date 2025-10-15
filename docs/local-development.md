# 本機開發指南

本指南說明如何在不先發佈版本或提交到`main`的情況下，於本機針對`specify` CLI 進行反覆開發。

> 腳本現在同時提供 Bash（`.sh`）與 PowerShell（`.ps1`）兩種版本。CLI 會根據作業系統自動選擇，除非你傳入`--script sh|ps`。

## 1. 複製並切換分支

```bash
git clone https://github.com/github/spec-kit.git
cd spec-kit
# Work on a feature branch
git checkout -b your-feature-branch
```

## 2. 直接執行 CLI（最快速的回饋）

你可以透過模組入口點直接執行 CLI，無需安裝任何東西：

```bash
# From repo root
python -m src.specify_cli --help
python -m src.specify_cli init demo-project --ai claude --ignore-agent-tools --script sh
```

如果你偏好使用腳本檔案風格（使用 shebang）來呼叫：

```bash
python src/specify_cli/__init__.py init demo-project --script ps
```

## 3. 使用可編輯安裝（隔離環境）

使用`uv`建立一個隔離環境，讓相依性（dependency）解析方式與最終用戶獲得的結果完全一致：

```bash
# Create & activate virtual env (uv auto-manages .venv)
uv venv
source .venv/bin/activate  # or on Windows PowerShell: .venv\Scripts\Activate.ps1

# Install project in editable mode
uv pip install -e .

# Now 'specify' entrypoint is available
specify --help
```

在可編輯模式（editable mode）下，編輯程式碼後重新執行不需要重新安裝。

## 4. 直接從 Git 以 uvx 執行

`uvx` 可以從本地路徑（或 Git 參考）執行，以模擬使用者流程：

```bash
uvx --from . specify init demo-uvx --ai copilot --ignore-agent-tools --script sh
```

你也可以讓 uvx 指向特定分支，而不需要進行合併：

```bash
# Push your working branch first
git push origin your-feature-branch
uvx --from git+https://github.com/github/spec-kit.git@your-feature-branch specify init demo-branch-test --script ps
```

### 4a. 絕對路徑 uvx（可在任意目錄執行）

如果你目前位於其他目錄，請使用絕對路徑來取代`.`：

```bash
uvx --from /mnt/c/GitHub/spec-kit specify --help
uvx --from /mnt/c/GitHub/spec-kit specify init demo-anywhere --ai copilot --ignore-agent-tools --script sh
```

為了方便操作，請設定一個環境變數 (environment variable)：
```bash
export SPEC_KIT_SRC=/mnt/c/GitHub/spec-kit
uvx --from "$SPEC_KIT_SRC" specify init demo-env --ai copilot --ignore-agent-tools --script ps
```

（選用）定義一個 shell 函數：
```bash
specify-dev() { uvx --from /mnt/c/GitHub/spec-kit specify "$@"; }
# Then
specify-dev --help
```

## 5. 測試腳本權限邏輯

在執行 `init` 之後，請檢查 shell 腳本在 POSIX 系統上是否具有可執行權限：

```bash
ls -l scripts | grep .sh
# Expect owner execute bit (e.g. -rwxr-xr-x)
```
在 Windows 上，你將會使用 `.ps1` 腳本（不需要執行 chmod）。

## 6. 執行 Lint／基本檢查（可自行新增）

目前尚未內建強制的 lint 設定，但你可以快速檢查是否可正確匯入：
```bash
python -c "import specify_cli; print('Import OK')"
```

## 7. 在本地建置 Wheel（可選）

在發佈前驗證封裝：

```bash
uv build
ls dist/
```
如有需要，請將建置產物安裝到全新的一次性使用（One-time Usage）環境中。

## 8. 使用臨時工作區

當在一個未清理的目錄中測試 `init --here` 時，請建立一個臨時工作區：

```bash
mkdir /tmp/spec-test && cd /tmp/spec-test
python -m src.specify_cli init --here --ai claude --ignore-agent-tools --script sh  # if repo copied here
```
或者，如果你只想要較輕量的沙盒環境，可以只複製已修改的 CLI 部分。

## 9. 偵錯網路 / 跳過 TLS

如果你在實驗過程中需要略過 TLS 驗證，可以這樣操作：

```bash
specify check --skip-tls
specify init demo --skip-tls --ai gemini --ignore-agent-tools --script ps
```
（僅供本地實驗使用。）

## 10. 快速編輯循環摘要

| 動作 | 指令 |
|------|------|
| 直接執行 CLI | `python -m src.specify_cli --help` |
| 可編輯安裝 | `uv pip install -e .` 然後 `specify ...` |
| 本地 uvx 執行（repo 根目錄） | `uvx --from . specify ...` |
| 本地 uvx 執行（絕對路徑） | `uvx --from /mnt/c/GitHub/spec-kit specify ...` |
| Git 分支 uvx | `uvx --from git+URL@branch specify ...` |
| 建置 wheel | `uv build` |

## 11. 清理

快速移除建置產物／虛擬環境：
```bash
rm -rf .venv dist build *.egg-info
```

## 12. 常見問題

| 症狀 | 解決方法 |
|---------|-----|
| `ModuleNotFoundError: typer` | 執行 `uv pip install -e .` |
| 腳本無法執行（Linux） | 重新執行 init 或 `chmod +x scripts/*.sh` |
| Git 步驟被略過 | 你傳入了 `--no-git` 或尚未安裝 Git |
| 下載到錯誤的腳本類型 | 請明確傳入 `--script sh` 或 `--script ps` |
| 在企業網路出現 TLS 錯誤 | 嘗試 `--skip-tls`（勿用於正式環境） |

## 13. 下一步

- 更新文件並使用你修改後的 CLI 執行快速入門
- 滿意後提交 Pull Request
- （選用）當變更合併至 `main` 後標記一個版本


