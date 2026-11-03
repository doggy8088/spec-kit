# 企業／氣隙環境安裝

若你的環境無法存取 PyPI 或 GitHub，你可以在可連網的機器上建立可攜式 wheel 套件組，再將其傳輸到氣隙環境的目標機器。

## 步驟 1：在可連網的機器上建置 wheel

> **重要：** `pip download` 會解析平台專屬的 wheel（例如 PyYAML 包含原生擴充功能）。你必須在與氣隙目標**相同的作業系統與 Python 版本**的機器上執行此步驟。若需支援多個平台，請在每個目標作業系統（Linux、macOS、Windows）與 Python 版本上重複此步驟。

```bash
# Clone the repository
git clone https://github.com/github/spec-kit.git
cd spec-kit

# Build the wheel
pip install build
python -m build --wheel --outdir dist/

# Download the wheel and all its runtime dependencies
pip download -d dist/ dist/specify_cli-*.whl
```

## 步驟 2：傳輸 `dist/` 目錄

透過 USB、網路共用或其他核准的傳輸方式，將整個 `dist/` 目錄（內含 `specify-cli` wheel 與所有相依性 wheel）複製到目標機器。

## 步驟 3：在氣隙機器上安裝

```bash
pip install --no-index --find-links=./dist specify-cli
```

## 步驟 4：初始化專案

不需要網路存取，預設會使用隨附的資產：

```bash
specify init my-project --integration copilot
```

> **注意：** 需要 Python 3.11 以上版本。
>
> **Windows 注意事項：** 離線建置專案骨架需要 PowerShell 7 以上版本（`pwsh`），而非 Windows PowerShell 5.x（`powershell.exe`）。請從 <https://aka.ms/powershell> 安裝。

## 元件目錄與來源

內建整合與隨附元件在無網路存取時仍可使用。透過目錄安裝外部整合轉接器、擴充功能、預設集、工作流程、工作流程步驟與套件組時，需要目錄中繼資料以及其所參照的發行成品。對於支援直接或本機來源的元件類型，該安裝途徑不需要目錄中繼資料。

若受限網路可以連線到核准的內部服務，請將經過審查的目錄與成品託管在內部 HTTPS 端點上，再以各元件專屬的 `catalog add` 指令註冊每個來源。若是完全斷網的網路，請透過你核准的流程傳輸經過審查的元件成品，並從其支援的直接或本機來源安裝，不要依賴無法連線的遠端目錄。

外部整合轉接器是例外。`specify integration install` 沒有直接或本機來源選項：它必須透過允許安裝的整合目錄解析轉接器並下載其封存檔。若要在隔離環境中加入外部轉接器，請讓核准的內部目錄與其轉接器封存檔在該環境中都能連線取得，或在目標斷網前先安裝轉接器。僅傳輸封存檔本身並不足夠。

套件組要分開處理：傳輸的套件組目錄或 ZIP 提供的是套件組清單，而不是它所命名的元件承載內容。斷網前，請先另外安裝相符的非套件組元件。帶有明確目錄 `source` 的元件即使已安裝，仍需要網路驗證；工作流程步驟的承載內容目前只能透過步驟目錄解析。在依賴 `specify bundle install --offline` 之前，請先檢視[套件組離線限制](../reference/bundles.md#install-a-bundle)。

目錄類型、信任政策與來源優先順序請參閱[目錄參考](../reference/catalogs.md)。若內部端點需要憑證，也請設定[驗證](../reference/authentication.md)。

## Linux 上的 Git Credential Manager

若你在 Linux 上遇到 Git 驗證問題，可以安裝 Git Credential Manager：

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
