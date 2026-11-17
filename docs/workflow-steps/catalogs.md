# 工作流程步驟型錄

步驟型錄決定 `specify workflow step search` 與 `add` 搜尋自訂步驟套件的位置。它們獨立於工作流程型錄。

## 探索與信任

步驟型錄透過個別的檔案 URL 宣傳可執行的 Python 套件。內建來源包含 `default`（允許安裝）與 `community`（僅供探索）。使用者在安裝與使用前必須審查來源；維護者不會稽核或背書元件程式碼。

專案的 `.specify/step-catalogs.yml` 可能選取你未選擇的來源。
請在安裝或載入自訂步驟之前，以 `specify workflow step catalog list` 檢查它們。
直接的封存檔 URL 會繞過型錄查詢，而非來源審查；
直接 URL 安裝會在發出網路請求之前要求確認信任。

## 型錄設定

| 層級 | 步驟類型 |
| --- | --- |
| 環境覆寫 | `SPECKIT_STEP_CATALOG_URL` |
| 專案 | `.specify/step-catalogs.yml` |
| 使用者 | `~/.specify/step-catalogs.yml` |
| 預設 | 官方與社群步驟型錄 |

第一個可用的層級提供整個堆疊，而非附加的層。
環境覆寫會選取一個允許安裝的來源。空的設定會遞補；
格式錯誤的 YAML 與無效的已設定 URL／優先順序會回報錯誤。

```yaml
catalogs:
  - name: my-org
    url: https://catalog.example.com/steps.json
    priority: 5
    install_allowed: true
    description: Our vetted workflow steps
```

`url` 需要 HTTPS，包含本機開發；純 HTTP 會在網路存取之前被拒絕。
數字較小的優先順序勝出；相同時第一個來源勝出。`install_allowed` 在手寫設定中預設為 false。

`specify workflow step catalog add` 會建立允許安裝的專案條目，優先順序排在既有條目之後。它不提供預設集風格的 `--install-allowed` 或 `--priority` 旗標。只加入審查過的來源；若要使用僅供探索的來源，請編輯設定。加入專案堆疊會取代隱含的預設值，除非你明確納入它們。

### 遷移舊版 HTTP 來源

舊版設定可能包含不再接受的 loopback HTTP URL。請以 `specify workflow step catalog remove <index>` 移除舊版專案來源；移除不會擷取或驗證來源 URL。索引依優先順序遞增排列，YAML 宣告順序打破相同情況；沒有 URL 的條目會被跳過。`step catalog list` 仍會拒絕無效的 URL，因此當它無法列出時，請檢查 `.specify/step-catalogs.yml` 以確定索引。其他條目也可以在舊版 HTTP 來源仍存在時移除。

或者，編輯專案來源的 `.specify/step-catalogs.yml`，或使用者來源的 `~/.specify/step-catalogs.yml`。
將來源的 `url` 換成可用的 HTTPS 型錄 URL，或從 `catalogs` 中移除其整個項目。
本機 HTTPS 伺服器需要 Python TLS 用戶端信任的憑證；僅有瀏覽器或作業系統的信任可能不夠。
請參閱 [TLS 憑證](../reference/authentication.md#tls-憑證)了解 `SSL_CERT_FILE` 的設定。
僅變更 URL 的配置並不會啟用 HTTPS。

空的或已刪除的設定會遞補到下一個層級。當沒有更高層級提供堆疊時，套用內建預設值。若 `SPECKIT_STEP_CATALOG_URL` 仍選取 HTTP 來源，也請更新或取消設定它。

## 步驟條目結構描述

型錄 JSON 包含 `schema_version` 與 `steps` 集合。條目識別類型與版本、其 `step_yml_url`（或 `url`）、`init_url`、選用的 `extra_files`，以及每個檔案的 `sha256` 摘要。型錄安裝會下載個別的套件檔案，而非 `--from` 使用的封存檔。

社群提交指南定義社群條目所需的額外中繼資料與釘選檔案要求。

## 步驟發行版本

`specify workflow step info <id> --versions` 會列出勝出型錄中的目前與歷史發行版本。`specify workflow step add <id> --version <v>` 會選取精確的型錄發行版本；未加上 `--version` 時，`add` 會安裝已宣傳的目前發行版本。要求的版本永遠不會退到較低優先級的型錄，且僅供探索的來源仍不可安裝。`--version` 不能與直接的 `--dev` 或 `--from` 安裝組合使用。

既有的單版本型錄項目會繼續運作。請將目前發行版本的 `version`、`step_yml_url`（或 `url`）、`init_url` 與可選檔案保留在頂層。可選的 `releases` 對應會新增歷史版本：

```json
{
  "steps": {
    "my-step": {
      "version": "2.0",
      "step_yml_url": "https://example.com/my-step/2.0/step.yml",
      "releases": {
        "1.0": {
          "step_yml_url": "https://example.com/my-step/1.0/step.yml",
          "init_url": "https://example.com/my-step/1.0/__init__.py",
          "extra_files": {"helper.py": "https://example.com/my-step/1.0/helper.py"},
          "sha256": {
            "step.yml": "<64 hex digits>",
            "__init__.py": "<64 hex digits>",
            "helper.py": "<64 hex digits>"
          }
        }
      }
    }
  }
}
```

每個歷史發行版本都必須為每個下載的檔案提供自己的步驟 URL 與 SHA-256 摘要。當 `step_yml_url` 以 `step.yml` 結尾時，可以省略 `init_url`，由其推導。若要明確選取目前版本，其頂層項目同樣必須提供逐檔案的 `sha256` 對應。發行版本專屬的檔案與要求不會從目前發行版本繼承。重複或格式錯誤的版本會被拒絕；`v1.0` 與 `1.0` 等等效的 PEP 440 拼寫會選取同一個已宣傳的發行版本。下載的 `step.yml` 必須宣告所選的步驟 ID 與版本。未限定的舊型錄安裝不需要摘要或步驟版本。每個步驟 ID 一次只能安裝一個版本；請在審查所選套件後，使用 `--force` 取代先前的安裝。

## 解析與失敗

步驟查詢會合併所有使用中的型錄，包含確切 ID 的查詢。它們不會在找到 ID 後停止。來源會依優先順序的反向處理，因此較高優先順序的條目會覆寫較低優先順序的條目；即使另一個來源已提供該 ID，每個來源仍可能被擷取或從快取讀取。請審查每一個使用中的來源，而不只是預期勝出的來源。

勝出的條目會一併提供其中繼資料、版本與安裝政策。較低優先順序的條目無法提供缺少的版本，也無法覆寫勝出的僅供探索決定。然而，擷取失敗的來源不會貢獻條目，因此當偏好的來源無法使用時，較低優先順序的來源可以提供該 ID。在快取遞補後仍存在的擷取失敗，若另一個來源成功會被跳過；若每個已設定的型錄都失敗，查詢會回報錯誤。

擷取到的型錄必須是 JSON 物件。其 `steps` 集合接受對應或清單形式；不支援的集合形狀與非對應條目會被跳過。這些被忽略的內容不計為擷取失敗，因此成功擷取的物件可能貢獻零個條目，查詢也可能回傳零筆結果，而非結構驗證錯誤。步驟型錄還會拒絕重複的 JSON 欄位與清單形式中重複的步驟 ID。版本中繼資料會另外驗證，仍可能產生錯誤。

## 快取與私人來源

步驟型錄會將擷取到的 JSON 與新鮮度中繼資料快取一小時，存放於 `.specify/workflows/steps/.cache/`。酬載與新鮮度檔案依 URL 雜湊鍵入。無法使用的快取條目會觸發擷取。快取 I/O 不會跟隨符號連結的目錄元件或快取檔案。寫入會以原子方式取代快取檔案，而非截斷其參照對象，因此既有的快取檔案符號連結可以在不變更目標的情況下被取代。不安全的快取寫入會記錄警告，但不會捨棄已擷取的探索結果。

私人型錄與套件下載使用來自 `~/.specify/auth.json` 的共用選用身分驗證。僅靠 token 環境變數不會啟用它。請只設定授權的目的地主機；切勿將憑證嵌入型錄 JSON 或 URL。

## 另請參閱

- [型錄 CLI 命令](cli.md#型錄管理)
- [發佈步驟](publishing.md)
- [社群步驟提交](../community/workflow-steps.md)
- [工作流程型錄](../workflows/catalogs.md)
- [跨元件型錄](../overview/catalogs.md)
- [下載身分驗證](../reference/authentication.md)
