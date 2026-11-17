# 貢獻整合

本指南涵蓋內建整合、外部轉接器開發，以及社群型錄投稿。

請先參閱[整合 API 參考](api.md)，了解受支援的轉接器契約、渲染 hook、執行階段分派與檔案擁有權。

## 加入內建整合

內建整合由 Spec Kit 核心團隊維護，並隨 CLI 一起提供。

checkout 設定請參閱[本機開發](../how-to/local-development.md)。請遵循[貢獻者測試指引](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#testing-deterministic-behavior)與[驗證流程](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#recommended-validation-flow)，再參閱[整合 PR 要求](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#integration-pull-requests)。

請對照 [public API](api.md) 實作轉接器，加入正向與負向測試，並在 `docs/integrations/<key>.md` 中記載代理專屬的設定、呼叫方式與限制。請從[整合目錄](index.md)連結該頁面，而非導覽下拉選單，並以下方的型錄綱要加入探索中繼資料。

內建來源註冊與私有實作契約的變更，遵循儲存庫的[貢獻者指引](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#integration-pull-requests)；安裝外部轉接器不需要這些步驟。

內建項目的格式請使用[型錄綱要](catalog.md#型錄綱要)。

## 開發外部轉接器

請使用[外部轉接器契約](api.md#套件契約)實作並打包你的轉接器。[描述檔參考](catalog.md#整合描述檔integrationyml)記載套件中繼資料；[型錄綱要](catalog.md#型錄綱要)記載已發布的項目。

本機安裝與信任決策請遵循[透過型錄安裝的外部轉接器](cli.md#透過型錄安裝的外部轉接器)。更新行為請參閱[升級整合](cli.md#升級整合)。

### 驗證你的轉接器

透過公開途徑測試你的套件：註冊一個本機 loopback 測試型錄，安裝其中立的轉接器，啟動新的 CLI 行程，註冊擴充功能／預設集貢獻，並以無害的行程替身行使命令／提示詞工作流程分派。

請涵蓋[生命週期保證](api.md#外部轉接器生命週期保證)與[檔案擁有權要求](api.md#設定與檔案擁有權)，包括：

- 無效的中繼資料／類別、信任拒絕、不安全的封存檔、設定錯誤，以及升級／解除安裝失敗。
- 套件程式碼與產生的代理檔案分離；復原與清理須保留已修改的檔案、無關的使用者檔案、獨立的工作流程進度與並行編輯。
- 無匯入副作用的中繼資料專用命令；以本機擁有權證明強制復原受損套件，以及缺少該證明時的手動清理警告。
- 符號連結的寫入目的地、保留的根目錄、不安全的舊版路徑，以及主要與舊版輸出路徑之間不區分大小寫的重疊。
- 跨專案的並行分派，包括套件相對匯入仍使用正確的轉接器。
- 對於支援事件的轉接器，在全新的 CLI 行程中進行僅限事件的擴充功能加入／移除與啟用／停用，包括已安裝程式碼無法載入時明確報錯。

## 投稿到社群型錄

外部開發者可以在 `integrations/catalog.community.json` 中列出整合，供他人探索。型錄維護者審查的是列表中繼資料，而不是轉接器實作；使用者必須自行審查程式碼。列表並不授予安裝許可。

### 先決條件

1. **可運作的外部轉接器**——依上述方式封裝並驗證。
2. **公開儲存庫**——託管在 GitHub 或類似服務上。
3. **文件**——附有使用說明的 README。
4. **授權**——開放原始碼授權檔案。

使用[型錄綱要](catalog.md#型錄綱要)準備你的項目。中繼資料必須與封裝的描述檔相符。請發佈釘選的封存檔 URL；建議附上封存檔的 SHA-256 摘要。

### 投稿

1. **Fork** [spec-kit 儲存庫](https://github.com/github/spec-kit)
2. **加入你的項目**，位置在 `integrations/catalog.community.json` 的 `integrations` 鍵之下：

   ```json
   {
     "schema_version": "1.0",
     "integrations": {
       "sample-agent": {
         "id": "sample-agent",
         "name": "Sample Agent",
         "version": "1.0.0",
         "description": "Adapter for Sample Agent",
         "author": "your-name",
         "repository": "https://github.com/your-name/speckit-sample-agent",
         "download_url": "https://github.com/your-name/speckit-sample-agent/releases/download/v1.0.0/sample-agent.zip",
         "tags": ["cli"]
       }
     }
   }
   ```

3. **開啟 pull request**，並附上：
   - 你的型錄項目
   - 指向你的整合儲存庫的連結
   - 確認 `integration.yml` 有效

### 版本更新

若要更新你在型錄中的整合版本：

1. 發佈你的整合的新版本
2. 開啟 PR，更新版本、釘選的封存檔 URL 與摘要（如有提供）
3. 確保向後相容，或記載破壞性變更

## 另請參閱

- [整合 API 參考](api.md)
- [社群整合](../community/integrations.md)
- [整合目錄](index.md)
- [型錄綱要](catalog.md)
