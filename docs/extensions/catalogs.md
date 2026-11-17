# 擴充功能型錄

擴充功能型錄決定 `specify extension search` 與 `add` 搜尋擴充功能的位置。型錄堆疊是一起搜尋的來源有序清單。當同一個擴充功能 ID 出現在多個來源時，較小的型錄優先順序數字優先。

## 信任模型：僅供探索與安裝來源

型錄有兩種，區別在於一條**安全性界線**：

- **安裝來源**（`install_allowed: true`）是你信任、可用來安裝的型錄。內建的 `default` 型錄就是其一，你自己撰寫並審查的型錄也是。
- **僅供探索**型錄（`install_allowed: false`）是可用來尋找擴充功能的可搜尋介面，但無法安裝。內建的 `community` 型錄已啟用搜尋；你不需要另外加入它。

| 優先順序 | 內建型錄 | 允許安裝 | 用途 |
| --- | --- | --- | --- |
| 1 | `catalog.json`（`default`） | 是 | 可安裝的擴充功能 |
| 2 | `catalog.community.json`（`community`） | 否 | 探索社群擴充功能 |

社群條目是未經審查的第三方程式碼。維護者檢查的是型錄中繼資料，而非擴充功能程式碼。安裝擴充功能之前，必須先審查它。

> [!WARNING]
> 請勿將未經審查的僅供探索型錄切換為 `install_allowed`。
> 那會破壞探索與安裝之間的區隔。

透過社群型錄找到東西，有兩種安裝方式：

1. **直接安裝單一已審查版本**。從 `specify extension info <name>` 取得候選封存檔 URL，它會為未安裝的僅供探索條目印出「Candidate archive」URL。在審查該版本封存檔之前，請將此 URL 視為不受信任，然後再安裝：

   ```bash
   specify extension info <name>
   specify extension add <name> --from <archive-url>
   ```

2. **整理自己的型錄**。對於受治理、可重用的組織來源，
   請自行審查各版本，並只將受控管的型錄標記為 `install_allowed: true`。

## 型錄解析順序

使用中的堆疊依以下順序選取：

1. **環境變數**：`SPECKIT_CATALOG_URL` 會覆寫整個堆疊。
2. **專案設定**：`.specify/extension-catalogs.yml`。
3. **使用者設定**：`~/.specify/extension-catalogs.yml`。
4. **內建預設值**：`default` 與 `community`。

既有的專案設定優先於使用者設定與內建預設值。空的或格式錯誤的檔案（包含 `catalogs: []`）會以驗證錯誤直接失敗，不會退回另一個來源。請移除設定檔以使用解析順序中的下一個來源，或以有效的型錄條目填寫它。在選取的堆疊內，型錄依優先順序檢查；第一個相符的擴充功能 ID 勝出。確切版本查詢在勝出條目缺少請求的版本時，不會退回另一個型錄。

## 管理型錄

```bash
specify extension catalog list
specify extension catalog --help

# Add an internal source you own and vet
specify extension catalog add \
  --name "internal" \
  --priority 2 \
  --install-allowed \
  --description "Our approved extensions" \
  https://internal.company.com/spec-kit/catalog.json

# Add a discovery-only source (the default permission)
specify extension catalog add \
  --name "partner" \
  --priority 5 \
  https://partner.example.com/spec-kit/catalog.json

specify extension catalog remove internal
```

這些命令會編輯專案的 `.specify/extension-catalogs.yml`。以相同設定重新加入同名的型錄會成功，且不會變更設定；不同的設定會被拒絕。完整的選項參考請參閱[型錄管理](cli.md#型錄管理)。

你也可以直接編輯設定：

```yaml
catalogs:
  - name: "default"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json"
    priority: 1
    install_allowed: true
    description: "Built-in catalog of installable extensions"

  - name: "internal"
    url: "https://internal.company.com/spec-kit/catalog.json"
    priority: 2
    install_allowed: true
    description: "Our approved extensions"

  - name: "community"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json"
    priority: 3
    install_allowed: false
    description: "Community-contributed extensions (discovery only)"
```

## 組織型錄自訂

組織使用私人型錄來控制可用的版本、整合內部工具、滿足合規要求，或支援離線網路。

### 建立型錄

建立一個 `catalog.json` 檔案，包含你的團隊已審查的版本：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-02-03T00:00:00Z",
  "catalog_url": "https://your-org.com/spec-kit/catalog.json",
  "extensions": {
    "jira": {
      "name": "Jira Integration",
      "id": "jira",
      "description": "Create Jira issues from spec-kit artifacts",
      "author": "Your Organization",
      "version": "2.1.0",
      "download_url": "https://github.com/your-org/spec-kit-jira/archive/refs/tags/v2.1.0.zip",
      "repository": "https://github.com/your-org/spec-kit-jira",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0",
        "tools": [
          {"name": "atlassian-mcp-server", "required": true}
        ]
      },
      "provides": {
        "commands": 3,
        "hooks": 1
      },
      "tags": ["jira", "atlassian", "issue-tracking"],
      "verified": true
    },
    "internal-tool": {
      "name": "Internal Tool Integration",
      "id": "internal-tool",
      "description": "Connect to internal company systems",
      "author": "Your Organization",
      "version": "1.0.0",
      "download_url": "https://internal.your-org.com/extensions/internal-tool-1.0.0.zip",
      "repository": "https://github.internal.your-org.com/spec-kit-internal",
      "license": "Proprietary",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "provides": {
        "commands": 2
      },
      "tags": ["internal", "proprietary"],
      "verified": true
    }
  }
}
```

### 託管與設定型錄

| 方法 | URL 範例 | 使用情境 |
| --- | --- | --- |
| GitHub Pages | `https://your-org.github.io/spec-kit-catalog/catalog.json` | 公開或組織可見 |
| 內部網頁伺服器 | `https://internal.company.com/spec-kit/catalog.json` | 企業網路 |
| S3／雲端儲存 | `https://s3.amazonaws.com/your-bucket/catalog.json` | 雲端託管的團隊 |
| 本機 HTTPS 伺服器 | `https://localhost:8443/catalog.json` | 使用 Python 信任的憑證進行開發／測試 |

型錄 URL 必須使用 HTTPS，包含 localhost。純 HTTP 型錄會在網路存取之前被拒絕。使用 `specify extension catalog add` 加入你的型錄，或使用：

```yaml
# .specify/extension-catalogs.yml
catalogs:
  - name: "my-org"
    url: "https://your-org.com/spec-kit/catalog.json"
    priority: 1
    install_allowed: true
    description: "Our approved extensions"
```

對於 CI/CD 或單一型錄環境，請取代整個堆疊：

```bash
export SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json"
```

檢查結果：

```bash
specify extension catalog list
specify extension search
specify extension add jira
```

### 私人 GitHub 託管型錄

`GH_TOKEN` 或 `GITHUB_TOKEN` 會對 GitHub 託管的 URL（`raw.githubusercontent.com`、`github.com`、`api.github.com` 與 `codeload.github.com`）進行身分驗證。
私人型錄 JSON 與擴充功能 ZIP 需要存取相關的儲存庫。
非 GitHub 的型錄 URL 會在不使用這些憑證的情況下擷取。

```bash
export GITHUB_TOKEN=$(gh auth token)
specify extension search jira
specify extension add jira-sync
```

### 精選與離線環境

型錄可以只列出經核准的擴充功能，例如 `jira` 與 `github`。若只有這些條目應出現在搜尋中，請將它設定為唯一的型錄。私人／專有擴充功能可以指向內部封存檔主機；提交至公開型錄是選用的。

對於離線網路，請將審查過的擴充功能 ZIP 下載到內部檔案伺服器，
建立指向這些內部 URL 的型錄，並在網路內託管該型錄。
例如，條目可以使用 `"download_url": "https://files.internal/spec-kit/jira-2.1.0.zip"`。

### 開發與測試

請透過 HTTPS 伺服器提供 `./my-catalog/`，使用 Python TLS 用戶端信任的憑證，而不只是你的瀏覽器或作業系統信任的憑證。對於開發 CA，請在執行 CLI 之前將 `SSL_CERT_FILE` 指向包含該 CA 的 PEM CA 套組（請參閱 [TLS 憑證](../reference/authentication.md#tls-憑證)）：

```bash
export SSL_CERT_FILE="/absolute/path/to/ca-bundle.pem"
export SPECKIT_CATALOG_URL="https://localhost:8443/catalog.json"
specify extension add my-new-extension
```

型錄設定不會阻止直接安裝：

```bash
specify extension add jira
specify extension add <extension-name> --from https://github.com/someone/spec-kit-ext/archive/refs/tags/v1.0.0.zip
specify extension add --dev /path/to/extension
```

直接 URL 安裝會顯示安全性警告，因為該封存檔不是透過你設定的型錄選取的。安裝前請先審查它。

## 型錄條目結構描述

以下說明型錄欄位；社群提交要求也需要完整的描述性中繼資料。

型錄根目錄必須包含 `schema_version` 與 `extensions` 對應。每個對應鍵是權威的擴充功能 ID；條目內重複的 `id` 欄位是選用的。

| 欄位 | 類型 | 必填 | 說明 |
| --- | --- | --- | --- |
| `name` | string | 是 | 方便閱讀的名稱 |
| `id` | string | 否 | 權威對應鍵的選用重複 |
| `version` | string | 是 | 目前的擴充功能版本 |
| `download_url` | string | 適用於封存檔版本 | 發行封存檔的 URL；內建條目可以省略 |
| `bundled` | boolean | 否 | 標記隨 Spec Kit 出貨的擴充功能，從執行中的發行版本解析 |
| `repository` | string | 否 | 原始碼 URL（社群提交時必填） |
| `description` | string | 是 | 簡短說明；社群提交需少於 200 個字元 |
| `author` | string | 否 | 作者／組織（提交時必填） |
| `license` | string | 否 | SPDX 授權識別碼（提交時必填） |
| `homepage`、`documentation`、`changelog` | string | 否 | 相關 URL |
| `sha256` | string | 否 | 封存檔 SHA-256 摘要；提供時會在安裝前驗證 |
| `requires.speckit_version` | string | 否 | 版本限制（提交時必填） |
| `requires.tools` | array | 否 | 具有必填 `name`、選用 `version` 與 `required`（預設為 `false`）的物件 |
| `provides.commands`、`provides.hooks` | number | 否 | 能力計數 |
| `tags` | array | 否 | 搜尋標籤（建議 2–10 個） |
| `verified` | boolean | 否 | 由維護者設定的中繼資料旗標，預設為 `false`；並非程式碼稽核保證 |
| `created_at`、`updated_at` | string | 否 | ISO 8601 時間戳記 |
| `releases` | object | 否 | 依版本鍵入的歷史版本 |

### 歷史發行版本

型錄可以在頂層欄位保留目前版本，並在 `releases` 對應中加入較舊的版本。較舊的單一版本型錄仍可不變地運作。
每個歷史版本都需要自己的下載 URL 與 SHA-256 摘要；版本專屬的需求或提供的能力必須放在該版本的記錄中，而非從目前版本繼承。
與目前版本一樣，摘要可以使用不區分大小寫的 `sha256:` 前綴與前後空白。

```json
{
  "extensions": {
    "my-extension": {
      "name": "My Extension",
      "version": "0.5.1",
      "download_url": "https://example.com/my-extension-0.5.1.zip",
      "sha256": "<64-character SHA-256 for 0.5.1>",
      "releases": {
        "0.4.12": {
          "download_url": "https://example.com/my-extension-0.4.12.zip",
          "sha256": "<64-character SHA-256 for 0.4.12>"
        }
      }
    }
  }
}
```

此範例為簡潔起見省略了其他中繼資料。目前版本不得在 `releases` 中重複；格式錯誤或重複的版本記錄會被拒絕。等效的 PEP 440 寫法（例如 `v1.0` 與 `1.0`）會選取相同的版本；型錄宣傳的寫法仍會顯示。

型錄支援的套件組擴充功能釘選也會從勝出的來源選取歷史版本，使用該版本自己的封存檔與摘要，並檢查下載資訊清單的 ID 與版本。內建擴充功能遵循套件版本政策：較新且相容的套件修補版本可以在發出警告的情況下使用。套件組安裝請參閱[套件組 CLI 參考](../bundles/cli.md#安裝套件組)。

## 另請參閱

- [擴充功能使用者指南](overview.md)
- [擴充功能 CLI 參考](cli.md)
- [發佈擴充功能](publishing.md)
- [社群擴充功能](../community/extensions.md)
- [共用型錄參考](../overview/catalogs.md)
