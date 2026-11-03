# 從 PyPI 安裝

Spec Kit 以 [`specify-cli`](https://pypi.org/project/specify-cli/) 的名稱發佈到 PyPI，由 Spec Kit 維護者維護。從 PyPI 安裝是受支援的安裝途徑之一，另一條是從 [GitHub 原始碼](../installation.md#install-from-source--persistent-installation-recommended)安裝。請依你的工作流程擇一使用，兩者提供的 `specify` CLI 相同。

> [!NOTE]
> PyPI 的發行版本與 GitHub 的發行標籤對應（例如 PyPI 的 `0.12.11` 對應 `v0.12.11` 標籤）。`specify version` 只是本機的版本與執行環境健全檢查，它會回報已安裝的版本，但不會顯示 `specify` 執行檔的來源，因此無法區分安裝是來自 PyPI 還是 Git。若要確認安裝來源，請查看套件管理工具記錄的來源中繼資料：`pipx list --json` 會回報每個工具的確切安裝規格；若是 uv/pip 安裝，則可檢查套件 `*.dist-info` 目錄內的 [PEP 610](https://peps.python.org/pep-0610/) `direct_url.json`（Git 或 URL 安裝會在該檔案中記錄儲存庫或封存檔 URL，一般的 PyPI 索引安裝則不會產生該檔案）。請注意，`pip show specify-cli` 只會印出套件中繼資料，且無法從主機解譯器看到 uv/pipx 管理的環境。

## 安裝 Specify CLI

使用你手邊已有的 Python 工具即可：

```bash
# Using uv (recommended)
uv tool install specify-cli

# Or using pipx
pipx install specify-cli

# Or using pip
pip install specify-cli
```

若你以 uv 安裝 Spec Kit，重複執行 `uv tool install specify-cli` 會保留已安裝的版本，不會升級。請將 `specify version` 顯示的版本與 [PyPI 上的最新版本](https://pypi.org/project/specify-cli/)比較。若版本較舊，請先依下方的[升級](#upgrade)說明，使用原本安裝時的同一個工具（uv、pipx 或 pip）完成升級，再執行 `specify init`。不要為了升級而更換安裝工具：那樣可能會產生第二份安裝，而舊的 `specify` 仍排在 `PATH` 的最前面。

### 安裝特定發行版本

釘選確切版本可讓安裝結果可重現（可用版本請查 [PyPI](https://pypi.org/project/specify-cli/#history) 或 [Releases](https://github.com/github/spec-kit/releases)）：

```bash
# Using uv
uv tool install specify-cli==0.12.11

# Or using pipx
pipx install specify-cli==0.12.11

# Or using pip
pip install specify-cli==0.12.11
```

## 從自訂或私有套件索引安裝

某些環境（公司網路、鏡像站、代理伺服器或成品摘要來源）需要從預設的公開 PyPI 以外的套件索引安裝 `specify-cli`。每個 Python 工具都提供指向不同索引的方法，請在執行上述安裝指令前先完成設定。請將此處的佔位索引 URL 換成你自己的索引 URL。

```bash
# uv — via environment variable (applies to the whole command)
UV_DEFAULT_INDEX=https://your-index.example.com/pypi/simple/ uv tool install specify-cli

# uv — via flag
uv tool install --default-index https://your-index.example.com/pypi/simple/ specify-cli

# pipx — pass a pip argument through
pipx install specify-cli --index-url https://your-index.example.com/pypi/simple/

# pip
pip install specify-cli --index-url https://your-index.example.com/pypi/simple/
```

> [!NOTE]
> 相同的索引設定也適用於釘選安裝、升級（`--force`/`--upgrade`）與一次性使用，請在那些指令上也加上環境變數或旗標。若你的索引需要驗證，請遵循所用工具的文件，並優先使用憑證環境變數、keyring 或 netrc；不要將秘密嵌入指令列 URL，因為秘密可能透過 shell 歷史紀錄、行程清單或記錄檔外洩。避免提交秘密。若需完全離線安裝，請參閱[氣隙安裝指南](air-gapped.md)。

## 驗證

```bash
specify version
```

## 初始化專案

```bash
specify init <PROJECT_NAME> --integration copilot
```

## 升級

透過原本安裝時使用的同一個工具重新安裝套件即可升級。若你原本釘選了版本，請注意 `uv tool upgrade` 會保留該釘選；若要改用 PyPI 上的最新發行版本，請使用未釘選的安裝指令，以免保留既有版本釘選：

```bash
# Using uv
uv tool install --force specify-cli

# Or using pipx
pipx install --force specify-cli

# Or using pip
pip install --upgrade specify-cli
```

> [!NOTE]
> `specify self upgrade` 目前會以 GitHub 原始碼發行 URL 重建 `uv tool` 與 `pipx` 的安裝，而不會保留以 PyPI 為基礎的安裝。若你想留在 PyPI 途徑，請使用上述套件管理工具指令。一般的 `pip install specify-cli` 會被視為未受管理的安裝，請以 `pip install --upgrade specify-cli` 升級。詳情請參閱[升級指南](../upgrade.md)。

## 解除安裝

```bash
# Using uv
uv tool uninstall specify-cli

# Or using pipx
pipx uninstall specify-cli

# Or using pip
pip uninstall specify-cli
```

## 後續步驟

前往[快速入門](../quickstart.md)初始化你的第一個專案。
