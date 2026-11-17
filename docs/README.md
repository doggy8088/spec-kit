# 文件

此資料夾包含 Spec Kit 的文件原始檔案，使用 [DocFX](https://dotnet.github.io/docfx/) 建置。

## 在本機建置

在本機建置文件的方式如下：

1. 安裝 DocFX：

   ```bash
   dotnet tool install -g docfx
   ```

2. 建置文件：

   ```bash
   cd docs
   docfx docfx.json --serve
   ```

3. 在瀏覽器開啟 `http://localhost:8080` 檢視文件。

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

當變更推送至 `main` 分支時，文件會自動建置並部署至 GitHub Pages。工作流程定義於 `.github/workflows/docs.yml`。
