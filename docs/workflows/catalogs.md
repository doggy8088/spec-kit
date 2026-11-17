# 工作流程型錄

工作流程型錄控制 `search` 與 `add` 尋找工作流程的位置。型錄會依優先順序檢查。

工作流程型錄會將擷取的 JSON 與新鮮度中繼資料快取一小時，位於 `.specify/workflows/.cache/`。快取 I/O 不會跟隨符號連結的目錄元件或
快取檔案。寫入會以原子方式取代快取檔案，而非截斷其
參照目標，因此既有的快取檔案符號連結可以被取代，而不變更
其目標。若快取無法安全寫入，會記錄警告，且
探索會繼續使用擷取的型錄。

> **專案的 `.specify/workflow-catalogs.yml` 可以將 `add` 與 `search` 指向您未選擇的型錄。** 在執行來自不熟悉專案的工作流程之前，請先執行 `specify workflow catalog list`（以及其步驟可能引入的步驟型錄對應的 `specify workflow step catalog list`）——專案提供該設定，並不表示其工作流程或步驟已經過審查。維護者不會稽核工作流程程式碼；請自行審查其 shell 步驟中的 `run` 與 `env`，包括嚴格步驟（參閱[審查 shell 執行](../workflow-steps/types.md#審查-shell-執行)與[誰維護工作流程？](overview.md#誰維護工作流程)）。

## 探索與信任

工作流程型錄會宣傳 `workflow.yml` 檔案或完整套件。內建來源包括 `default`（允許安裝）與 `community`（僅供探索）。使用者在安裝與使用前必須審查來源；維護者不會稽核或背書元件程式碼。

明確的直接 URL 安裝會在不經型錄查詢的情況下選擇來源。它不會讓未經審查的內容變得安全。

## 型錄設定

| 層級 | 工作流程 |
| --- | --- |
| 環境覆寫 | `SPECKIT_WORKFLOW_CATALOG_URL` |
| 專案 | `.specify/workflow-catalogs.yml` |
| 使用者 | `~/.specify/workflow-catalogs.yml` |
| 預設 | 官方與社群工作流程型錄 |

第一個可用的層級會提供整個堆疊，而非附加層。環境覆寫會選擇一個允許安裝的來源。空白設定會落到下一層；格式錯誤的 YAML 與無效的設定 URL／優先順序會回報錯誤。

```yaml
catalogs:
  - name: my-org
    url: https://catalog.example.com/workflows.json
    priority: 5
    install_allowed: true
    description: Our vetted workflows
```

`url` 需要 HTTPS，包括本機開發；明文 HTTP 會在網路存取前被拒絕。數字較小的優先順序勝出；平手時第一個來源勝出。`install_allowed` 在手寫設定中預設為 false。

`specify workflow catalog add` 會建立允許安裝、優先順序排在既有項目之後的專案項目。它不提供預設集風格的 `--install-allowed` 或 `--priority` 旗標。只新增已審查的來源；若要指定僅供探索的來源，請編輯設定。新增專案堆疊會取代隱含的預設值，除非你明確納入它們。

### 移轉舊版 HTTP 來源

舊設定可能含有不再接受的 loopback HTTP URL。請使用 `specify workflow catalog remove <index>` 移除舊版專案來源；移除不會擷取或驗證來源 URL。索引依優先順序遞增排列，以 YAML 宣告順序打破平手；沒有 URL 的項目會被跳過。`catalog list` 仍會拒絕無效的 URL，因此當它無法列出時，請檢查 `.specify/workflow-catalogs.yml` 以確定索引。在舊版 HTTP 來源仍存在時，也可以移除其他項目。

或者，請編輯專案來源的 `.specify/workflow-catalogs.yml`，或使用者來源的 `~/.specify/workflow-catalogs.yml`。將來源的 `url` 換成可用的 HTTPS 型錄 URL，或將其整個項目從 `catalogs` 中移除。本機 HTTPS 伺服器需要 Python TLS 用戶端信任的憑證；僅有瀏覽器或作業系統信任可能不足。請參閱 [TLS 憑證](../reference/authentication.md#tls-憑證)，了解 `SSL_CERT_FILE` 設定。僅變更 URL 配置並不會啟用 HTTPS。

空白或已刪除的設定會落到下一層。當沒有更高層級提供堆疊時，會套用內建預設值。若 `SPECKIT_WORKFLOW_CATALOG_URL` 仍選擇 HTTP 來源，也請更新或取消設定它。

## 工作流程項目結構描述

型錄 JSON 包含 `schema_version` 與以工作流程 ID 為鍵的 `workflows` 對應。項目帶有 `id`、`name`、`description`、`author`、`version`、`url`，以及可選的 `sha256`、`requires`、`repository`、`license`、`tags` 與時間戳記。下載可以是原始 YAML 或完整的工作流程封存檔。標示為 `bundled: true` 的第一方項目會使用隨附的定義，而非網路下載。

## 工作流程發行版本

型錄項目會在頂層保留目前發行版本的 `version`、`url`、可選的 `sha256`，
以及可選的 `requires`。可選的 `releases` 對應
會宣傳歷史版本，而不變更未限定版本的 `add`、
`search`、`info` 或 `update` 所選取的內容：

```json
{
  "id": "example",
  "version": "2.0.0",
  "url": "https://example.com/example-2.0.0.zip",
  "releases": {
    "1.0.0": {
      "url": "https://example.com/example-1.0.0.zip",
      "sha256": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "requires": {"speckit_version": ">=1.0.0"}
    }
  }
}
```

每個歷史發行版本都需要自己的 URL 與 SHA-256 摘要；`requires` 是
可選的，且若存在，必須與下載的工作流程定義相符。
已宣傳的版本使用工作流程定義的 `X.Y.Z` 版本格式；
選取已宣傳的 `1.0.0` 發行版本時，`--version` 也接受 `v1.0` 等等效拼寫。
要求的版本必須存在於提供該工作流程的最高優先級型錄中。缺失的版本不會退到另一個來源，且僅供探索的型錄無法從中安裝。下載的工作流程 ID、
版本與宣告的摘要會在安裝前驗證。`--version` 並
不適用於本地路徑、直接 URL 或 `--from` 安裝。

## 解析與失敗

工作流程查詢會合併所有作用中的型錄，包括精確 ID 查詢。它們不會在找到 ID 後就停止。來源會依優先順序的反序處理，因此較高優先順序的項目會覆寫較低優先順序的項目；即使另一個來源已提供該 ID，每個來源仍可能被擷取或從快取讀取。請審查每個作用中的來源，而不只是預期勝出的來源。

勝出的項目會一併提供其中繼資料、發行版本與安裝政策。較低優先順序的項目無法補上缺失的版本，也無法覆寫勝出的僅供探索決定。然而，擷取失敗的來源不會提供任何項目，因此當偏好的來源無法使用時，較低優先順序的來源可以提供該 ID。快取回退後仍存在的擷取失敗，在另一個來源成功時會被跳過；若每個已設定的型錄都失敗，查詢會回報錯誤。

擷取的型錄必須是 JSON 物件。其 `workflows` 集合接受對應或清單形式；不支援的集合形狀與非對應項目會被跳過。這些被忽略的內容不計為擷取失敗，因此成功擷取的物件可能不提供任何項目，而查詢可能傳回無結果，而非結構驗證錯誤。發行版本中繼資料會另外驗證，仍可能產生錯誤。

## 快取與私有來源

工作流程型錄快取位於 `.specify/workflows/.cache/`，有效期為一小時。酬載與新鮮度檔案以 URL 雜湊為鍵。無法使用的快取項目會觸發擷取；不安全的快取寫入會記錄警告，而不會捨棄已擷取的探索結果。

私有型錄與套件下載使用來自 `~/.specify/auth.json` 的共用隨選身分驗證。僅有權杖環境變數並不會啟用它。請只設定授權的目的地主機；絕對不要將憑證內嵌於型錄 JSON 或 URL 中。

## 另請參閱

- [型錄 CLI 命令](cli.md#型錄管理)
- [Publishing workflows](publishing.md)
- [Community workflows](../community/workflows.md)
- [Step catalogs](../workflow-steps/catalogs.md)
- [Cross-component catalogs](../overview/catalogs.md)
- [Download authentication](../reference/authentication.md)
- [Shell 原始碼審查](../workflow-steps/types.md#審查-shell-執行)
