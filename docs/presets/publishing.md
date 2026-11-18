# 發布預設集

請發布已標示版本的預設集封存檔、用 Spec Kit 測試它，並提交「Preset Submission」議題，讓它能在社群型錄中被找到。新項目、版本更新與修復都使用相同的議題流程。請勿提交手動編輯過的型錄提取請求。

社群上架不是程式碼認證。維護者只檢查型錄項目的完整性與格式，不會審查、稽核、背書或支援社群預設集的程式碼。使用者在安裝第三方預設集之前，必須先加以審查。

## 準備套件

提交之前，請先準備一個公開可存取的儲存庫，內含可正常運作的 `preset.yml`、預設集使用說明 README，以及開源的 `LICENSE`。請使用描述性、字母開頭、全小寫連字號的 ID，以及數字形式的 `X.Y.Z` 版本，例如 `team-traceability` 與 `1.0.0`。描述請保持簡潔（200 字元以下），並選擇二到五個實用的全小寫標籤。建議附上變更日誌。

請從開發指南著手，並查閱 API 參考文件以確認資訊清單欄位與相依性。納入所有已宣告的貢獻檔案，並確認命令參照的章節確實由生效的範本提供。本機資訊清單驗證不是安全性審查，也不是完整的發布檢查清單。

## 測試本機與發布安裝

在已初始化的測試專案中：

```bash
specify preset add --dev /path/to/team-traceability
specify preset info team-traceability
specify preset resolve spec-template
specify preset list
specify preset remove team-traceability
```

請至少在一個真實專案上測試。對於命令貢獻，請檢查並以支援的使用中整合呼叫已交付的命令或技能。請檢查堆疊、組合與移除／還原，而不只是安裝是否成功結束。

請為該版本建立標籤與 GitHub 發布版本。例如：

```bash
git tag v1.0.0
git push origin v1.0.0
```

推送標籤本身並不等於建立 GitHub 發布版本；請透過 GitHub 或你的發布工具建立該發布版本。提交接受屬於所提交儲存庫的固定 ZIP URL：

```text
https://github.com/<owner>/<repo>/archive/refs/tags/v1.0.0.zip
https://github.com/<owner>/<repo>/releases/download/v1.0.0/<asset>.zip
```

標籤可使用 `vX.Y.Z`、`X.Y.Z`，或帶有相符版本後綴的範圍形式，例如 `team-traceability-v1.0.0`。浮動的 `releases/latest/` URL 不被接受。該標籤必須已有對應的 GitHub 發布版本。

CLI 也支援 `.tar.gz` 與 `.tgz`，但社群提交契約目前要求使用標籤固定的 ZIP。若要直接用 CLI 安裝，`preset.yml` 必須位於封存檔根目錄，或在一個頂層目錄內。提交驗證器能在 monorepo 中找到預設集範圍的資訊清單；但這並不表示任意巢狀的 monorepo 封存檔都能用 CLI 安裝。必要時請發布預設集專屬的資產。

請測試你將提交的確切封存檔 URL：

```bash
specify preset add --from https://github.com/example/team-traceability/archive/refs/tags/v1.0.0.zip
specify preset resolve spec-template
specify preset remove team-traceability
```

## 使用說明 README 的要求

提交的 Documentation URL 必須指向 GitHub 上可讀取的 README，說明如何使用此預設集，而不是宣傳更廣泛的框架或另一個 CLI。接受的 URL 形式為 GitHub 的 `blob` 或 `raw` URL，以及 `raw.githubusercontent.com` URL。路徑必須以 `README.md` 結尾（不區分大小寫）；查詢字串與片段在擷取時會被忽略。

在 monorepo 中，請優先使用預設集範圍的 README，例如 `presets/team-traceability/README.md`，而非儲存庫總覽。無論該 README 是否也隨封存檔一同出貨，都請在下載發布版本之前保持可存取。

請說明預設集提供的內容、適用與不適用的時機、支援的整合與相依性，以及有效的安裝命令。建議使用：

```bash
specify preset add --from https://github.com/example/team-traceability/archive/refs/tags/v1.0.0.zip
```

`--from` URL 必須與提交的 Download URL 完全一致。驗證也接受有效的 `specify preset add <id>` 或 `specify preset add --dev <path>` 命令。以 ID 安裝仍需要允許安裝的型錄，因此對社群使用者而言，直接使用固定封存檔最清楚。

沒有有效安裝命令的 README 會驗證失敗。可識別為屬於此預設集的過期發布 URL 也會失敗，即使已有另一個有效命令。monorepo 中不相關預設集的發布範例會加以區分，不會自動視為過期。

## 提交至社群型錄

請開啟[預設集提交議題](https://github.com/github/spec-kit/issues/new?template=preset_submission.yml)。請提供 ID、名稱、版本、描述、作者、儲存庫 URL、固定的 Download URL、Documentation URL、授權、所需的 Spec Kit 版本、所需的擴充功能 ID、提供的範本／命令／指令碼、標籤與主要功能。請完成測試與提交檢查清單。

所需的擴充功能也請在 `preset.yml` 中宣告。僅憑型錄中繼資料，無法為本機與直接封存檔安裝傳達相依性。

選填的提交檢查碼，可在議題中附加一個 `### SHA-256` 標題、附上恰好 64 個十六進位字元來提供。表單中沒有專用的檢查碼欄位。若有提供，必須與擷取到的封存檔相符；不符即為驗證失敗，自動化流程不會默默替換數值。

請勿自行編輯 `presets/catalog.community.json` 來取代提交。驗證通過後，自動化流程會準備型錄變更；文件網站會依據該型錄產生預設集目錄。

## 提交之後會發生什麼事

1. 議題表單會套用 `triage-must-have` 的收件判定。這並不會啟動型錄驗證。
2. 分流期間，維護者會另外套用 `preset-submission` 以啟動驗證工作流程。貢獻者無須套用或請求該標籤。
3. 驗證會檢查提交的中繼資料、儲存庫／授權可用性、連結的 README 與安裝參照、版本固定、封存檔可用性、選填的提交檢查碼，以及必要的檢查清單。驗證器會解析已發布的資訊清單而不執行封存檔內容，並比對其 ID、版本、Spec Kit 需求與所需的擴充功能是否與議題相符。
4. 成功時，自動化流程會提出一份草稿提取請求，更新型錄。它會記錄實際的封存檔摘要值、更新時保留 `created_at`、排序型錄 ID，並在標記驗證通過之前先驗證產生的型錄。文件建置會產生按字母排序的目錄與個別的預設集頁面；沒有需要另外維護的表格。
5. 維護者會審查產生的型錄變更，核准後合併。預設集隨即變得可被找到；社群型錄仍維持僅供探索。

已確認的提交缺陷會以 `validation-failed` 回報。權限、網路或工具阻礙會回報為已阻擋，而非成功的檢查，也不一定是預設集本身的缺陷。工作流程會回報哪些步驟無法執行，讓維護者調查並重新執行。

這些是中繼資料與成品一致性檢查，不是對預設集指示、範本品質或可執行程式碼安全性的審查。沒有社群程式碼核准或支援保證。

## 版本更新

請更新資訊清單版本與變更日誌、發布新的不可變標籤版本，並重新測試其確切封存檔。更新該版本的 README 安裝參照，然後再提交一個附上新版本與 URL 的 Preset Submission 議題。修復損壞的項目也適用相同的議題流程。

對於你自行營運的私人型錄，請依型錄參考文件維護目前與歷史的版本紀錄。不要假設社群提交流程會發布版本歷史，或讓該型錄變得允許安裝。

## 另請參閱

- [預設集總覽](overview.md)
- [開發預設集](developing.md)
- [資訊清單 API](api.md)
- [型錄項目與歷史版本](catalogs.md)
- [CLI 參考文件](cli.md)
- [社群預設集](../community/presets.md)
