# 貢獻整合

本指南涵蓋內建整合、外部轉接器開發，以及社群目錄投稿。

實作合約、所有權與交付要求，請從[代理整合設計](https://github.com/github/spec-kit/blob/main/design/integration.md)開始。

## 加入內建整合

內建整合由 Spec Kit 核心團隊維護，並隨 CLI 一起提供。

簽出設定請參閱[本機開發](../local-development.md)。請遵循[貢獻者測試指引](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#testing-deterministic-behavior)與[驗證流程](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#recommended-validation-flow)，然後參閱[整合 PR 要求](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#integration-pull-requests)。

### 檢核清單

1. **建立整合子套件**，位置在 `src/specify_cli/integrations/<package_dir>/`，其中 `<package_dir>` 是將整合鍵中的連字號換成底線後的名稱。
2. **實作整合類別**，遵循[加入代理](https://github.com/github/spec-kit/blob/main/design/integration.md#adding-an-agent)。
3. **註冊整合**，位置在 `src/specify_cli/integrations/__init__.py`。
4. **加入測試**，位置在 `tests/integrations/test_integration_<package_dir>.py`。
5. **在 `integrations/catalog.json` 中加入目錄項目**。
6. **更新文件：** 加入 `docs/integrations/<key>.md`，並從[整合索引](index.md)與[導覽](../toc.yml)連結到它。視需要更新[目錄參考](catalog.md)，若合約有變更，也更新[整合設計](https://github.com/github/spec-kit/blob/main/design/integration.md)。

內建項目的格式請使用[目錄綱要](catalog.md#catalog-schema)。

## 開發外部轉接器

使用[外部轉接器合約](https://github.com/github/spec-kit/blob/main/design/integration.md#external-adapter-package-contract)實作並封裝你的轉接器。[描述檔參考](catalog.md#integration-descriptor-integrationyml)記載了套件中繼資料；[目錄綱要](catalog.md#catalog-schema)記載了發佈的項目。

本機安裝與信任決策請遵循[透過目錄安裝的外部轉接器](cli.md#catalog-installed-external-adapters)。更新行為請參閱[升級整合](cli.md#upgrade-an-integration)。

### 驗證你的轉接器

透過公開途徑測試你的套件：註冊一個本機 loopback 測試目錄，安裝其中立的轉接器，啟動新的 CLI 行程，註冊擴充功能／預設集貢獻，並以無害的行程替身行使命令／提示詞工作流程分派。

涵蓋[生命週期合約](https://github.com/github/spec-kit/blob/main/design/integration.md#storage-loading-and-lifecycle)，包括：

- 無效的中繼資料／類別、信任被拒、不安全的封存檔、設定錯誤，以及升級／解除安裝失敗。
- 套件程式碼與產生的檔案清單分開保存；復原與清理會保留已修改的檔案、無關的使用者檔案、獨立的工作流程進度與並行編輯。
- 沒有匯入副作用的純中繼資料命令；使用本機所有權證明強制復原受損的套件，以及在缺少該證明時的手動清理警告。
- 以符號連結指向的寫入目的地、保留的根目錄、不安全的舊版路徑，以及主要與舊版輸出路徑之間不分大小寫的重疊。
- 重疊的專案分派與延遲相對匯入，會保留正確的轉接器，而不序列化獨立的代理行程。
- 對於支援事件的轉接器，在新的 CLI 行程中僅針對事件進行擴充功能的加入／移除與啟用／停用，包括已安裝程式碼無法載入時的明確錯誤。

## 投稿到社群目錄

外部開發者可以在 `integrations/catalog.community.json` 中列出整合，供他人探索。目錄維護者審查的是列表中繼資料，而不是轉接器實作；使用者必須自行審查程式碼。列表並不授予安裝許可。

### 先決條件

1. **可運作的外部轉接器**——依上述方式封裝並驗證。
2. **公開儲存庫**——託管在 GitHub 或類似服務上。
3. **文件**——附有使用說明的 README。
4. **授權**——開放原始碼授權檔案。

使用[目錄綱要](catalog.md#catalog-schema)準備你的項目。中繼資料必須與封裝的描述檔相符。請發佈釘選的封存檔 URL；建議附上封存檔的 SHA-256 摘要。

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
   - 你的目錄項目
   - 指向你的整合儲存庫的連結
   - 確認 `integration.yml` 有效

### 版本更新

若要更新你在目錄中的整合版本：

1. 發佈你的整合的新版本
2. 開啟 PR，更新版本、釘選的封存檔 URL 與摘要（如有提供）
3. 確保向後相容，或記載破壞性變更
