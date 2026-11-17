# 預設集型錄

型錄負責探索預設集，並為以 ID 安裝挑選版本。型錄的優先順序用來排序型錄來源，與決定成品解析的已安裝預設集優先順序無關。

## 探索與信任

內建的堆疊包含：

| 名稱 | 來源 | 預設權限 |
| --- | --- | --- |
| `default` | [第一方預設集型錄](https://github.com/github/spec-kit/blob/main/presets/catalog.json) | 允許安裝 |
| `community` | [社群預設集型錄](https://github.com/github/spec-kit/blob/main/presets/catalog.community.json) | 僅供探索 |

社群預設集由各方獨立維護。維護者只檢查型錄項目的完整性與格式，不檢查預設集程式碼的安全性或品質。他們不會審查、稽核、背書或支援該程式碼。使用者在安裝與使用前，必須先審查預設集的原始碼。

> [!IMPORTANT]
> 專案的 `.specify/preset-catalogs.yml` 可能會把 `add` 與 `search` 指向你沒有選擇的型錄。在不熟悉的專案中，請執行 `specify preset catalog list` 並檢查允許安裝的來源。專案設定與 `install_allowed: true` 並不是程式碼已審查的證據。只允許從你擁有或已審查過的型錄安裝；不熟悉的來源與社群來源請保持僅供探索。

審查過某個社群版本後，可用明確的 `specify preset add --from <archive-url>` 安裝該封存檔，無須查閱型錄。這只是來源的選擇，不是讓未審查內容變安全的繞道。

## 型錄設定

第一個可用的設定層級提供整個堆疊；專案與使用者的項目不會自動擴增預設值：

| 順序 | 來源 |
| --- | --- |
| 最先 | `SPECKIT_PRESET_CATALOG_URL` 環境變數 |
| 其次 | 專案 `.specify/preset-catalogs.yml` |
| 其次 | 使用者 `~/.specify/preset-catalogs.yml` |
| 最後 | 內建的 `default` 與 `community` 型錄 |

環境變數會選取一個名為 `custom`、允許安裝的型錄。只在來源已審查的情況下使用。若設定檔沒有有效的型錄項目，會遞補到下一個層級；格式錯誤的 YAML，或無效的已設定 URL／優先順序，會引發驗證錯誤，而不是默默選取另一個來源。

專案設定範例：

```yaml
catalogs:
  - name: "my-org-presets"
    url: "https://catalog.example.com/presets.json"
    priority: 5
    install_allowed: true
    description: "Our vetted presets"
```

| 項目欄位 | 意義 |
| --- | --- |
| `url` | HTTPS 型錄 URL，本地開發亦同；純 HTTP 會被拒絕 |
| `name` | CLI 顯示的來源名稱，也用於來源追溯 |
| `priority` | 數字較小者先檢查 |
| `install_allowed` | 是否允許以 ID 安裝；預設為 `false` |
| `description` | 選填的來源描述 |

請使用 CLI 管理專案項目：

```bash
specify preset catalog list
specify preset catalog add https://catalog.example.com/presets.json \
  --name my-org-presets --priority 5 --install-allowed
specify preset catalog remove my-org-presets
```

只有在審查過來源之後，才使用 `--install-allowed`。省略該選項會加入一個僅供探索的型錄。加入第一個專案項目會取代隱含的內建堆疊；若仍需要其他來源，請明確納入。使用者層級的檔案須另外設定，無法用 `catalog add` 設定。

## 項目結構描述

型錄 JSON 含有 `schema_version` 欄位，以及以預設集 ID 為鍵的 `presets` 物件。以下示範私人型錄中可下載的目前版本；使用前請先替換範例 URL 與摘要值：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-11-03T00:00:00Z",
  "presets": {
    "team-traceability": {
      "id": "team-traceability",
      "name": "Team Traceability",
      "description": "Adds team traceability requirements to specifications",
      "author": "Example Team",
      "version": "2.0.0",
      "download_url": "https://github.com/example/team-traceability/archive/refs/tags/v2.0.0.zip",
      "sha256": "<64 hexadecimal digits for this archive>",
      "repository": "https://github.com/example/team-traceability",
      "documentation": "https://github.com/example/team-traceability/blob/main/README.md",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.9.0"
      },
      "provides": {
        "templates": 1,
        "commands": 0,
        "scripts": 0
      },
      "tags": ["traceability", "governance"],
      "created_at": "2026-11-03",
      "updated_at": "2026-11-03"
    }
  }
}
```

型錄的 `provides` 存放的是貢獻數量，與資訊清單的 `provides.templates` 清單不同。請保持中繼資料與已發布的資訊清單一致。`bundled: true` 可描述隨 Spec Kit 一同出貨的第一方預設集；這類項目可能沒有下載 URL，需要相符的已打包檔案，而非透過網路下載。

單一版本的老式項目仍然有效。目前版本可以省略 `sha256`；若有提供，安裝前會先檢查摘要值。即使提交者沒有提供，社群提交自動化流程也會計算並記錄下載封存檔的摘要值。

## 歷史版本

若要宣傳較舊的版本，請加入一個以版本為鍵的 `releases` 對應表：

```json
{
  "version": "2.0.0",
  "download_url": "https://example.com/team-traceability-2.0.0.zip",
  "sha256": "<64 hexadecimal digits for the current archive>",
  "releases": {
    "1.5.0": {
      "download_url": "https://example.com/team-traceability-1.5.0.zip",
      "sha256": "<64 hexadecimal digits for the older archive>",
      "requires": {"speckit_version": ">=0.8.0"},
      "provides": {"templates": 1, "commands": 0, "scripts": 0}
    }
  }
}
```

這只是一個項目的版本相關部分，不是完整的型錄。每筆歷史紀錄都需要自己的 HTTPS 封存檔 URL（開發時可用回送位址 HTTP），以及 64 位數的 SHA-256 摘要值。摘要值可帶不區分大小寫的 `sha256:` 前綴與前後空白；其他演算法前綴會被拒絕。

歷史版本的 `requires` 與 `provides` 為選填，用來描述該版本；缺省時不會繼承目前版本的數值。名稱、描述與型錄權限等共用中繼資料會被繼承。歷史版本的 `requires.extensions` 使用資訊清單的字串或對應表相依性格式。請勿在歷史紀錄內放置 `id`、`version`、巢狀的 `releases`，或內部的 `_catalog_name`／`_install_allowed` 欄位。

版本鍵必須互不相同，包括 PEP 440 下等價的寫法，且不得與目前版本重複。重複的 JSON 鍵會在解析前被拒絕，以免丟棄某筆版本紀錄。

```bash
specify preset info team-traceability --versions
specify preset add team-traceability --version 1.5.0
```

可用版本會先列出目前版本，再依遞減順序列出歷史版本。精確選擇版本時，會在更動已安裝的預設集之前，先檢查下載資訊清單的 ID 與版本。

社群型錄仍維持僅供探索，不必發布版本歷史。套件組固定版本解析是另一項獨立功能；只加入預設集版本紀錄，並不會讓套件組固定版本變得可安裝。

## 查閱與失敗行為

型錄會依優先順序遞增的順序檢查。某個 ID 優先順序最高的項目同時提供其版本中繼資料與安裝權限。較低優先順序的來源無法提供缺少的歷史版本，也無法推翻僅供探索的決定。

精確以 ID 查閱時，在勝出項目之前遇到的格式錯誤或過大型錄會導致解析失敗。格式錯誤的較低優先順序來源無法阻擋已找到的較高優先順序項目。非物件的項目會讓針對其 ID 的精確查閱失敗，但全型錄搜尋會跳過該項目並保留其他有效項目。

跨所有來源的搜尋仍會因格式錯誤的型錄而失敗。歷史版本驗證適用於勝出的項目；來自被遮蔽項目的無效歷史不會阻擋有效的較高優先順序替代項目。無法連線的來源在另有可讀來源時可以跳過。若所有來源都失敗，查閱（包括 `info --versions`）會回報擷取錯誤，而不是宣稱沒有任何版本。

## 快取與私人來源

型錄會在 `.specify/presets/.cache/` 中快取一小時。預設型錄保留舊有的 `catalog.json` 與 `catalog-metadata.json` 檔名；其他來源則使用經 URL 雜湊的快取檔名。快取內容會接受與網路回應相同的形狀驗證；無法讀取或無效的快取內容會觸發重新擷取。

私人型錄與封存檔請求使用 `~/.specify/auth.json` 中共用的自願加入身分驗證設定。僅設定權杖環境變數並不會啟用身分驗證。只設定授權接收憑證的主機；身分驗證參考文件涵蓋 GitHub CLI、權杖、企業版與其他支援的提供者。請勿把憑證放在型錄 JSON 或來源 URL 中。

## 另請參閱

- [預設集總覽](overview.md)
- [型錄 CLI 命令](cli.md#型錄管理)
- [資訊清單 API](api.md)
- [發布與社群提交](publishing.md)
- [跨元件型錄指南](../overview/catalogs.md)
- [型錄與下載身分驗證](../reference/authentication.md)
- [社群預設集](../community/presets.md)
