# 套件組

套件組將既有的 Spec Kit 擴充功能、預設集、工作流程與工作流程步驟類型，組合成一個具版本、可安裝的設定，供特定角色或團隊使用。套件組在 `bundle.yml` 中宣告要安裝的元件；它本身不增加任何執行階段行為。每個元件都透過各自的機制安裝。

用擴充功能加入能力，用預設集自訂既有能力，用工作流程自動化一連串步驟。當這些部分應一併散佈與安裝時，請使用套件組。

> [!IMPORTANT]
> 使用第三方套件組及其安裝的元件前，請先審查它們。社群型錄是探索管道，不是安全背書。維護者只檢查提交中繼資料的完整性與格式；他們不會審查、稽核、背書或支援社群套件組程式碼及其元件。

## 快速入門

探索套件組，並檢視型錄套件組宣告的元件：

```bash
specify bundle search
specify bundle info bugfix
```

安裝第一方套件組，檢視已安裝的紀錄，再將其移除：

```bash
specify bundle install bugfix
specify bundle list
specify bundle remove bugfix
```

`add` 是 `install` 的別名。安裝時若有需要，會初始化 Spec Kit 專案；例如使用 `--integration copilot` 為新專案選取整合。它不會切換既有專案的現用整合。

對於你已撰寫或審查過的套件組，請傳入本機目錄、資訊清單或已建置的成品：

```bash
specify bundle install ./team-setup/bundle.yml
specify bundle install ./team-setup-1.0.0.zip
```

本機來源只提供資訊清單，不是內嵌的元件儲存庫。其元件仍需從隨附資產、相容的已安裝元件，或各自的型錄解析。社群搜尋結果本身並不允許以 ID 安裝。

## 第一方套件組

Spec Kit 在 `bundles/catalog.json` 中維護第一方型錄，透過允許安裝的 `builtin://default` 來源公開。其項目標示為 `verified: true`。

| 套件組 | 元件 | 使用情境 |
| --- | --- | --- |
| `bugfix` | `bug` 擴充功能與 `bugfix` 工作流程 | 引導式評估、評估閘門、修復與測試 |
| `assess` | `assess` 擴充功能與 `assess` 工作流程 | 規格驅動開發前的構想分流 |

```bash
specify bundle add assess
```

安裝工作流程並不會執行它。請依循[錯誤修復指南](../guides/bugfix.md)或[構想評估指南](../guides/assessment.md)使用已安裝的設定。

內建型錄會在線上取得，離線時使用隨附的快照。透過型錄探索到的套件組資訊清單仍需透過網路下載，即使是第一方項目也一樣。本機資訊清單可以搭配 `--offline` 安裝隨附元件；確切的限制請參閱 CLI 參考。

## 生命週期與擁有權

套件組同時記錄所需的元件與它貢獻的元件。獨立安裝的相容元件可以滿足需求，而不會成為套件組擁有。移除套件組後，它會留在原地。與其他套件組共用的元件在仍被需要時會保持安裝。

重複執行不變的安裝會保留既有元件與本機編輯。請使用 `bundle update <id>` 套用型錄 release，或使用 `bundle install <path> --refresh` 套用修訂後的本機來源，以重新套用擁有的元件。更新不是全域交易：稍後失敗時，不會復原已安裝元件的變更。

## 另請參閱

- [CLI 參考](cli.md)
- [開發套件組](developing.md)
- [資訊清單與組合 API](api.md)
- [型錄](catalogs.md)
- [發布套件組](publishing.md)
- [社群套件組](../community/bundles.md)
- [社群逐步解說](../community/walkthroughs.md)
- [選擇自訂 building block](../how-to/customization.md)
