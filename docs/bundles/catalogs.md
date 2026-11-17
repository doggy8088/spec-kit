# 套件組型錄

套件組型錄負責定位套件組資訊清單，並描述可供探索的設定。它們不提供這些資訊清單所需的擴充功能、預設集、工作流程或步驟型錄。請另外註冊並審查那些元件型錄。

## 信任與安裝政策

> [!IMPORTANT]
> 安裝前，請同時審查套件組來源及其元件型錄。
> 專案可以在 `.specify/` 下提供套件組與允許安裝的元件型錄；它們的存在並不表示有人審查過。

請檢查所有適用的來源，包括不是你自行加入的來源：

```bash
specify bundle catalog list
specify extension catalog list
specify preset catalog list
specify workflow catalog list
specify workflow step catalog list
```

請將不熟悉的來源視為未經審查，直到你審查過為止。對於工作流程元件，請檢查 shell 的 `run` 與 `env` 欄位及參照的程式碼，包括作用中的覆蓋層。即使是 `strict: true` 的步驟，也可能透過環境繫結改變執行檔查詢或執行階段載入；請參閱[審查 shell 執行](../workflow-steps/types.md#審查-shell-執行)。

| 政策 | 效果 |
| --- | --- |
| `install-allowed` | 允許從此來源安裝／更新 |
| `discovery-only` | 允許搜尋與檢視，但拒絕安裝／更新 |

`verified` 旗標是型錄中繼資料，不是安裝政策或安全保證。社群項目未經驗證，維護者不會審查、稽核、背書或支援其程式碼。安裝套件組不會自動註冊或信任配套型錄。

## 內建來源

| 來源 ID | URL | 優先順序 | 政策 |
| --- | --- | --- | --- |
| `default` | `builtin://default` | `1` | `install-allowed` |
| `community` | `builtin://community` | `20` | `discovery-only` |

預設型錄是 `bundles/catalog.json`；社群提交出現在 `bundles/catalog.community.json` 中。兩者皆從儲存庫線上取得。離線探索使用隨附的 wheel 快照。短暫的內建型錄可用性失敗會發出警告並退回這些快照；格式錯誤的內容或安全驗證失敗不會無聲退回。

套件組資訊清單的 `download_url` 仍需透過網路存取。隨附的型錄快照不是本機承載內容儲存區。

## 設定來源

請在已初始化的專案中，於審查來源之後執行：

```bash
specify bundle catalog add https://example.com/bundles.json \
  --id team --priority 10 --policy install-allowed
specify bundle catalog list
specify bundle catalog remove team
```

CLI 會寫入 `.specify/bundle-catalogs.yml`：

```yaml
schema_version: "1.0"
catalogs:
  - id: team
    url: https://example.com/bundles.json
    priority: 10
    install_policy: install-allowed
```

使用者設定在 `~/.specify/bundle-catalogs.yml` 中使用相同的形狀。CLI 的加入／移除操作只會寫入專案範圍。兩種讀取器為相容性接受缺少的綱要版本，並拒絕不支援的主版本。

來源 URL 可以是 HTTPS、`file://`、本機路徑，或已知的 `builtin://` URL。純 HTTP 會在連網前被拒絕，包括 localhost。加入的本機路徑會儲存為絕對路徑。此彈性適用於型錄檔案，不適用於其套件組下載 URL。

### 優先順序

兩個步驟決定有效的堆疊：

1. 依 ID 合併來源：專案範圍的來源會取代使用者範圍中相同的 ID，使用者範圍則取代內建範圍中相同的 ID。
2. 將存活的來源依數字優先順序、再依來源 ID 排序。優先順序數字較小者獲勝。

對於不同的 ID，範圍不會勝過優先順序。加入的來源預設優先順序為 `10`，排在優先順序 `20` 的社群來源之前，但排在優先順序 `1` 的預設來源之後。請依其 ID 覆寫內建來源，或審慎選擇適當的優先順序。

第一個含有該套件組 ID 的來源獲勝。缺少歷史 release、來源不符，或僅供探索的政策，都不會導致退回優先順序較低的型錄。套件組參照中的 `source` 是斷言此獲勝者；它不會選取來源。

以相符的 ID／設定重新加入既有的 URL 不會有任何作用。衝突的 URL／ID 設定會失敗。內建來源無法移除，但可以移除內建 ID 的專案覆寫，以還原較低範圍的來源。

## 型錄承載內容

型錄檔案是 JSON 物件，含有以套件組 ID 為鍵的 `bundles` 對應：

```json
{
  "schema_version": "1.0",
  "bundles": {
    "team-setup": {
      "id": "team-setup",
      "name": "Team setup",
      "version": "1.2.0",
      "role": "developer",
      "description": "A curated team setup",
      "author": "Example team",
      "license": "MIT",
      "repository": "https://github.com/example/team-setup",
      "download_url": "https://github.com/example/team-setup/releases/download/v1.2.0/team-setup-1.2.0.zip",
      "requires": {"speckit_version": ">=0.9.0"},
      "provides": {"extensions": 1, "presets": 0, "steps": 0, "workflows": 1},
      "tags": ["developer", "bugfix"],
      "verified": false
    }
  }
}
```

項目的 `id` 必須與其外層鍵相符。`requires` 與 `provides` 若存在且非空，必須是對應；`tags` 必須是字串清單；`verified` 必須是真正的布林值。`provides` 描述的是元件數量，不是資訊清單的元件清單。具有不支援主版本的型錄綱要版本與重複的 JSON 鍵會被拒絕。

請使用 `sha256` 摘要驗證成品位元組。社群提交自動化會記錄它從實際封存檔計算出的摘要；提交的檢查碼不符會使驗證失敗。一般的目前項目讀取器仍接受沒有摘要的項目。歷史 release 需要各自的摘要。

型錄套件組下載 URL 必須使用 HTTPS，或 localhost 上的 HTTP，並解析為套件組資訊清單，或含有根目錄層級 `bundle.yml` 的 ZIP。取回的資訊清單 ID 與版本必須與選取的型錄項目相符。本機路徑與 `file://` 不被接受為套件組下載 URL；請將本機套件組來源直接傳給 `bundle install`。

社群提交的發布契約較窄：具版本、標籤釘選的 GitHub release ZIP 成品。請參閱發布指南。

## Release 歷史

一個項目可以在目前 release 之外，加入核准的歷史 release：

```json
{
  "id": "team-setup",
  "version": "1.2.0",
  "download_url": "https://example.com/team-setup-1.2.0.zip",
  "releases": {
    "1.1.0": {
      "download_url": "https://example.com/team-setup-1.1.0.zip",
      "sha256": "<64-character SHA-256 digest>"
    }
  }
}
```

這是項目片段，不是完整的型錄。使用前請替換摘要預留位置。每筆歷史紀錄都需要各自的 HTTPS（或 localhost HTTP）`download_url` 與 64 字元十六進位 SHA-256 摘要。摘要可以帶有不區分大小寫的 `sha256:` 前綴與周圍空白；其他演算法前綴會被拒絕。

歷史鍵必須是嚴格的 SemVer 值，且可依 PEP 440 比較。它們不能與目前版本或彼此重複，包括等價寫法，例如 `1.0.0-rc.1` 與 `1.0.0-rc1`。歷史紀錄不能含有 `id`、`version` 或 `releases`。

名稱、描述與作者等共用中繼資料除非被覆寫，否則會被繼承。release 專屬的 `requires`、`provides` 與 `verified` 不會被繼承：請在每筆歷史紀錄上提供它們，否則該 release 沒有需求、沒有提供的數量，且信任為 `community`。

```bash
specify bundle info team-setup --versions
specify bundle install team-setup --version 1.1.0
```

等價的版本寫法，例如 `v1.1.0` 與 `1.1.0`，會選取同一個 release；型錄鍵的寫法僅供顯示。確切的套件組 release 選取絕不會改變取回的資訊清單中的元件釘選。`bundle update` 一律選取目前的 release。

歷史紀錄會在型錄來源載入時驗證。格式錯誤的歷史紀錄會使任何諮詢該來源的操作失敗。ID 查詢在找到獲勝者後，可能讓格式錯誤的較低優先順序來源不被觀察；搜尋會載入所有來源，因此即使是被遮蔽的格式錯誤項目也會使搜尋失敗。

既有的單一 release 型錄仍有效。第一方與社群套件組型錄目前每個套件組只刊登一個 release，不保留歷史紀錄。

## 另請參閱

- [套件組 CLI 參考](cli.md)
- [資訊清單與來源斷言](api.md)
- [發布與社群提交](publishing.md)
- [社群套件組](../community/bundles.md)
- [共用型錄概念](../overview/catalogs.md)
