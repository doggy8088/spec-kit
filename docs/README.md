# 文件

此資料夾包含 Spec Kit 的文件原始檔案，使用 [DocFX](https://dotnet.github.io/docfx/) 建置。

## 在本機建置

在本機建置文件的方式如下：

1. 安裝 DocFX：

   ```bash
   dotnet tool install -g docfx
   ```

2. 從本機型錄產生社群預設集目錄：

   ```bash
   python3 docs/generate_presets.py --fetch-stars
   ```

3. 建置文件：

   ```bash
   cd docs
   docfx docfx.json --serve
   ```

4. 在瀏覽器開啟 `http://localhost:8080` 檢視文件。

編輯 `presets/catalog.community.json` 後請再次執行產生器。它會建立被忽略的 `_generated/preset-directory.md` 內含檔與 `community/presets/*.md` 詳細頁面，並移除已刪除項目的頁面。請勿編輯這些產生的檔案。該目錄只使用型錄的中繼資料：建置時不會擷取或執行第三方預設集內容。使用 `--fetch-stars` 時，它會針對每個儲存庫向 GitHub API 讀取一次星數。請設定 `GH_TOKEN` 或 `GITHUB_TOKEN` 以取得經驗證的 API 額度；部署工作流程會使用其儲存庫權杖。星數反映上次建置時的數值，共用的儲存庫會有相同的星數。查詢失敗時會產生警告並顯示「Stars unavailable」，絕不會憑空編出零。離線建置時請省略 `--fetch-stars`，星數會顯示為無法取得。它的搜尋、標籤與排序控制項能強化一份完整的靜態清單；即使沒有 JavaScript，該清單仍可閱讀。

## 結構

目錄將專案背景與共用的 CLI 參考資料歸在 **總覽** 之下。**入門指南** 將每段流程導覽與其命令參考資料配對。**操作指南** 涵蓋專案實務、身分驗證，以及 Spec Kit 本身的本機開發。整合、擴充功能、預設集、工作流程、工作流程步驟、套件組與社群資源則各自保留專屬章節。

Overview 的支援頁面位於 `overview/` 之下，`index.md` 仍為網站首頁。流程命令參考資料與身分驗證仍位於 `reference/` 之下，本機開發指南則位於 `how-to/` 之下。

- `docfx.json` - DocFX 設定檔
- `index.md` - 文件主頁
- `overview/history.md` - 專案歷史與管理
- `toc.yml` - 目錄設定
- `overview/core.md` - 核心 CLI 命令與共用專案設定
- `overview/mcp.md` - 實驗性本機 stdio MCP 伺服器
- `overview/artifacts.md` - 產出物清單與組合參考
- `reference/authentication.md` - 身分驗證設定指南與參考
- `how-to/local-development.md` - 在本機開發與檢查 Spec Kit
- `installation.md` - 安裝指南
- `quickstart.md` - 規格驅動開發導覽
- `guides/agentic-sdlc.md` - Spec Kit 如何將代理式與傳統 SDLC 實務應用於自身
- `guides/bugfix.md` - 錯誤修正導覽
- `guides/assessment.md` - 構想評估導覽
- `how-to/index.md` - 操作指南目錄
- `how-to/sdd.md` - 認識規格驅動開發
- `how-to/existing-projects.md` - 在既有專案中採用 Spec Kit
- `how-to/monorepo.md` - 在 monorepo 中工作
- `how-to/contract-driven-development.md` - 定義並演進元件合約
- `how-to/complex-features.md` - 在有限的執行中實作複雜功能
- `how-to/spec-of-specs.md` - 將大型功能拆成較小的規格
- `how-to/persisting-specs.md` - 交付後保存規格
- `how-to/evolving-specs.md` - 為後續變更演進規格
- `how-to/customization.md` - 依你的流程調整 Spec Kit
- `overview/catalogs.md` - 型錄探索、信任、私人來源與優先順序
- `extensions/overview.md` - 擴充功能使用者指南
- `extensions/cli.md` - 擴充功能管理 CLI 參考
- `extensions/catalogs.md` - 擴充功能型錄設定、信任與發佈結構描述
- `extensions/developing.md` - 擴充功能撰寫指南
- `extensions/api.md` - 擴充功能資訊清單、API、hook 與執行階段事件合約
- `extensions/publishing.md` - 擴充功能發佈與型錄提交指南
- `presets/overview.md` - 預設集使用者指南
- `presets/cli.md` - 預設集管理 CLI 參考
- `presets/developing.md` - 預設集撰寫與本機測試指南
- `presets/api.md` - 資訊清單、組合與生命週期參考
- `presets/catalogs.md` - 預設集型錄設定、結構描述與信任
- `presets/publishing.md` - 預設集發佈與型錄提交指南
- `workflows/overview.md` - 工作流程使用者指南與執行／檢閱／繼續導覽
- `workflows/cli.md` - 工作流程、覆蓋層與工作流程型錄 CLI 參考
- `workflows/developing.md` - 工作流程撰寫指南
- `workflows/api.md` - YAML、執行與持久狀態合約
- `workflows/expressions.md` - 運算式語言、執行階段脈絡與 shell 安全性
- `workflows/overlays.md` - 透過覆蓋層與插槽組合工作流程
- `workflows/catalogs.md` - 工作流程型錄、發佈與信任
- `workflows/publishing.md` - 工作流程發佈與型錄提交指南
- `workflow-steps/overview.md` - 內建與自訂工作流程步驟總覽
- `workflow-steps/cli.md` - 自訂步驟與步驟型錄管理 CLI
- `workflow-steps/developing.md` - 步驟套件撰寫與驗證
- `workflow-steps/api.md` - Python 擴充功能 API、登錄與載入器合約
- `workflow-steps/types.md` - 內建步驟設定與輸出
- `workflow-steps/catalogs.md` - 步驟型錄、發佈與信任
- `workflow-steps/publishing.md` - 步驟發佈與提交指引
- `bundles/overview.md` - 套件組使用者指南與第一方設定
- `bundles/cli.md` - 套件組管理 CLI 參考
- `bundles/developing.md` - 套件組撰寫與安裝測試指南
- `bundles/api.md` - 資訊清單、參照展開與已安裝紀錄合約
- `bundles/catalogs.md` - 套件組型錄、政策與發佈歷史
- `bundles/publishing.md` - 套件組發佈與型錄提交指南
- `community/extensions.md` - 社群擴充功能清單
- `community/integrations.md` - 社群整合探索與貢獻
- `community/workflows.md` - 社群工作流程清單與貢獻
- `community/workflow-steps.md` - 社群步驟清單與提交合約
- `integrations/index.md` - 整合型錄與共用設定指引
- `integrations/cli.md` - 共用整合管理 CLI 參考
- `integrations/api.md` - 公開 Python 配接器與檔案所有權合約
- `integrations/<key>.md` - 代理專屬的設定、呼叫方式、選項與限制
- `integrations/catalog.md` - 型錄結構描述與外部配接器中繼資料
- `integrations/contributing.md` - 整合與型錄貢獻指南
- `reference/agentic-*.md` - 詳細的流程命令參考
- `_site/` - 產生的文件輸出（由 git 忽略）

## 部署

文件、社群預設集型錄與文件工作流程在 `zh-tw` 分支上的變更，會觸發一般的 GitHub Pages 部署。每次建置都會產生預設集目錄與詳細頁面，並在執行 DocFX 之前重新整理儲存庫星數。手動執行使用相同路徑；沒有另外的每週排程。工作流程定義於 `.github/workflows/docs.yml`，且只在本儲存庫中執行。
