# Spec Kit 整合型錄

整合型錄讓 Spec Kit 的 AI 代理整合可以被探索、版本化與散佈。

## 型錄檔案

### 內建型錄（`integrations/catalog.json`）

包含隨 Spec Kit 一起提供的整合。這些由核心團隊維護，且永遠可以安裝。

### 社群型錄（`integrations/catalog.community.json`）

由社群貢獻的整合。預設的社群來源僅供探索：在型錄中列出某個轉接器，既不是安裝許可，也不是程式碼稽核。使用允許安裝的型錄之前，請先審查外部程式碼。

## 型錄設定

第一個設定的層級會取代較低的層級。在該層級內，數字較小的優先順序勝出：

1. **環境變數**——`SPECKIT_INTEGRATION_CATALOG_URL` 以單一 URL 覆寫所有型錄
2. **專案設定**——專案根目錄中的 `.specify/integration-catalogs.yml`
3. **使用者設定**——使用者主目錄中的 `~/.specify/integration-catalogs.yml`
4. **內建預設值**——`catalog.json` + `catalog.community.json`

加入第一個專案型錄會取代預設來源，除非你也在專案檔案中列出它們。共用的探索、信任與私有來源指引請參閱[型錄](../reference/catalogs.md)。

`integration-catalogs.yml` 範例：

```yaml
catalogs:
  - url: "https://example.com/my-catalog.json"
    name: "my-catalog"
    priority: 1
    install_allowed: true
```

## CLI 命令

使用 `specify integration list --catalog`、`search` 與 `info` 瀏覽。請參閱 CLI 參考中的[型錄管理](cli.md#catalog-management)與[外部轉接器安裝](cli.md#catalog-installed-external-adapters)。

## 整合描述檔（`integration.yml`）

每個外部整合套件都包含一個僅供轉接器使用的 `integration.yml` 描述檔，以及一個匯出 `IntegrationBase` 子類別的根目錄 `__init__.py`。不需要命令清單，也不需要複製核心範本：

```yaml
schema_version: "1.0"
integration:
  id: "sample-agent"
  name: "Sample Agent"
  version: "1.0.0"
  description: "Adapter for Sample Agent"
  license: "MIT"
requires:
  speckit_version: ">=1.1.2.dev0"
  tools:
    - name: "sample-agent"
      required: true
```

必要的描述檔欄位：

| 欄位 | 驗證 |
|-------|------------|
| `schema_version` | 必須是字串 `"1.0"` |
| `integration.id` | 外部 ID 必須符合 `^[a-z0-9][a-z0-9-]*$`。名稱 `con`、`prn`、`aux`、`nul`、`com1` 到 `com9`，以及 `lpt1` 到 `lpt9` 為保留字 |
| `integration.name`、`integration.description` | 必須是字串 |
| `integration.version` | 必須是 PEP 440 版本字串 |
| `requires.speckit_version` | 必填，且為非空的 PEP 440 版本指定字串 |

`requires.tools` 是選用的；對於沒有必要執行檔的轉接器，可以省略它。選用的舊版 `provides` 中繼資料仍然有效，但不會提供主機命令。類別中繼資料、執行階段方法、工具與儲存要求請參閱[整合設計](https://github.com/github/spec-kit/blob/main/design/integration.md#external-adapter-package-contract)。

## 型錄綱要

兩個型錄檔案都遵循相同的 JSON 綱要：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-04-08T00:00:00Z",
  "catalog_url": "https://...",
  "integrations": {
    "sample-agent": {
      "id": "sample-agent",
      "name": "Sample Agent",
      "version": "1.0.0",
      "description": "Adapter for Sample Agent",
      "download_url": "https://example.com/sample-agent/1.0.0/sample-agent.zip",
      "tags": ["cli"]
    }
  }
}
```

### 最上層欄位

| 欄位 | 類型 | 說明 |
|-------|------|-------------|
| `schema_version` | string | 必須是 `"1.0"` |
| `updated_at` | string | 選用的 ISO 8601 時間戳記 |
| `integrations` | object | 整合 ID → 中繼資料的對應 |

### 整合項目欄位

| 欄位 | 類型 | 必填 | 說明 |
|-------|------|----------|-------------|
| `id` | string | 否 | 選用的明確 ID；必須與對應鍵相符 |
| `name` | string | 是 | 方便閱讀的顯示名稱 |
| `version` | string | 是 | PEP 440 版本（例如 `1.0.0`、`1.0.0a1`） |
| `description` | string | 是 | 單行說明 |
| `author` | string | 否 | 作者名稱或組織 |
| `repository` | string | 否 | 原始碼儲存庫 URL |
| `license` | string | 否 | 與描述檔相符的授權識別字 |
| `tags` | array | 否 | 可搜尋的標籤（例如 `["cli", "ide"]`） |
| `download_url` | string | 外部安裝 | 釘選的 ZIP、tar.gz 或 tgz 封存檔 URL；HTTPS 或 loopback HTTP |
| `sha256` | string | 否 | 封存檔的 64 字元十六進位 SHA-256 |
| `requires` | object | 否 | 提供時必須與描述檔要求相符 |
| `releases` | object | 否 | [歷來版本中繼資料](cli.md#historical-integration-metadata)；不是可安裝的版本 |

對應鍵與任何宣告的 `id` 都必須與 `integration.id` 相符。名稱、版本、說明，以及選用的作者／儲存庫／授權中繼資料，都必須與描述檔相符。內建項目不需要下載欄位，因為它們的實作隨 CLI 一起提供。

## 安裝政策與儲存

以 `integration catalog add` 註冊型錄會建立一個允許安裝的專案來源。在其設定中將 `install_allowed: false` 設為僅允許探索。此政策無法以 `--trust-integration` 或 `--force` 覆寫。每次外部安裝／更新在下載／匯入 Python 之前都會先提示，除非以 `--trust-integration` 明確預先授權。需要驗證的 GitHub 成品會使用既有的 Spec Kit 驗證提供者。

已安裝的程式碼儲存在 `.specify/integrations/packages/<id>/`，出處與雜湊則在 `packages.json` 中；兩者都會被受管理的 `.specify/.gitignore` 排除。執行同意會另外儲存在 `~/.specify/integration-trust.json`，並與專案、整合 ID 以及經驗證的套件摘要綁定。產生的檔案有各自以雜湊追蹤的 `<id>.manifest.json`。

不要就地編輯已安裝的套件程式碼：請發佈新的封存檔／版本並改以升級方式處理。請參閱 CLI 參考中的[信任與重新授權](cli.md#catalog-installed-external-adapters)與[升級與復原](cli.md#upgrade-an-integration)。

## 貢獻

加入內建整合或提交外部整合型錄項目，請參閱[貢獻指南](contributing.md)。代理專屬的設定請從[整合目錄](index.md)開始。共用的使用者命令記載於[整合管理參考](cli.md)中。
