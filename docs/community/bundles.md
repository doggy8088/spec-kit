# 社群套件組

> [!NOTE]
> 社群套件組由各自作者獨立建立與維護。維護者僅確認提交中繼資料完整且格式正確，不審查、稽核、背書或支援套件組程式碼或其安裝的元件。安裝前請先檢視套件組資訊清單、元件型錄與原始儲存庫，並自行斟酌使用。

套件組將既有的 Spec Kit 元件，也就是擴充功能、預設集、工作流程與步驟，組合成單一的角色或團隊組合。當使用者應該能一同安裝一組經過測試的元件，而不是分別執行多個安裝命令時，套件組特別實用。

經接受的社群套件組項目發佈於 [`bundles/catalog.community.json`](https://github.com/github/spec-kit/blob/main/bundles/catalog.community.json)，並列於下方。內建的社群來源僅供探索：`specify bundle search` 與 `specify bundle info` 可檢視項目，但依 ID 安裝時，必須明確加入允許安裝的型錄。明確指定的型錄預設優先順序高於內建社群來源。若要提交套件組供審查，請提出 [Bundle Submission](https://github.com/github/spec-kit/issues/new?template=bundle_submission.yml) issue。

| 套件組 | 用途 | 角色或團隊 | 提供內容 | 所需型錄 | URL |
|--------|---------|--------------|----------|-------------------|-----|
| Agentstandards Multi-Vendor Architecture | 安裝由 Codex 協調的多廠商架構委員會、其硬性任務關卡，以及支援的 Spec Kit 工作流程。 | `architecture-governance` | 1 個擴充功能、1 個預設集、1 個工作流程 | 已記錄 | [agentstandards](https://github.com/bbjwz/agentstandards) |
| SicarioSpec Security & Governance Bundle | GitHub Spec Kit 的安全預設治理套件組。強制執行資料分類、威脅建模與由程式碼持有的驗證關卡。 | `security-engineer` | 1 個擴充功能、11 個預設集 | 已記錄 | [sicario-spec](https://github.com/dfirs1car1o/sicario-spec) |
| SpecAssay | 為原廠 Spec Kit 提供持久 ID 提升：範本、Gate 2 拒絕與追蹤資訊清單產出。 | `developer` | 1 個擴充功能、1 個預設集 | 已記錄 | [specassay](https://github.com/rdryfoos/specassay) |

## 提交內容

套件組提交應包含：

- 具有有效 `bundle.yml` 資訊清單的公開儲存庫。
- 具版本編號的 GitHub release，其中包含由 `specify bundle build` 建立的套件組產出物。
- 說明預期角色、安裝元件、所需型錄與預期工作流程的文件。
- 包含套件組中繼資料與元件數量的建議型錄項目。
- 來自乾淨 Spec Kit 專案的測試證據。

## 元件解析

套件組型錄項目描述套件組產出物的下載位置，但使用者安裝時，套件組的元件參照仍需能成功解析。參照可從隨附元件、已安裝元件，或作用中的擴充功能、預設集、工作流程與步驟型錄解析。

若套件組依賴的元件無法從預設的 Spec Kit 型錄取得，請在提交內容與 README 中包含所需的型錄 URL。提交前，請在加入這些型錄的乾淨專案中測試完整的安裝路徑。

例如：

```bash
specify preset catalog add https://example.com/presets.json --name example-bundle --install-allowed
specify extension catalog add https://example.com/extensions.json --name example-bundle --install-allowed
curl -L -o example-bundle-1.0.0.zip https://example.com/example-bundle-1.0.0.zip
specify bundle install ./example-bundle-1.0.0.zip

# Or install by id from an install-allowed bundle catalog.
specify bundle catalog add https://example.com/bundles.json --id example-bundle-catalog --policy install-allowed
specify bundle install example-bundle
```

## 審查範圍

維護者會檢查：

- 提交欄位完整且格式正確。
- release 產出物與文件 URL 可連通。
- 儲存庫包含 `bundle.yml` 資訊清單。
- 提交內容清楚標示任何所需的元件型錄。
- 建議的型錄項目使用預期的套件組型錄項目格式。

維護者不會稽核已安裝的擴充功能、預設集、工作流程、步驟或指令碼的行為。使用者在安裝社群套件組前，應先檢視這些元件。

## 更新套件組

若要更新已提交的套件組，請再提出一個 [Bundle Submission](https://github.com/github/spec-kit/issues/new?template=bundle_submission.yml) issue，附上新版本、下載 URL、變更的元件清單與更新的測試證據，並註明此 issue 是更新既有的套件組項目。
