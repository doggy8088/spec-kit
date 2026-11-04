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

- `docfx.json` - DocFX 設定檔
- `index.md` - 文件主頁
- `toc.yml` - 目錄設定
- `installation.md` - 安裝指南
- `quickstart.md` - 規格驅動開發導覽
- `guides/agentic-sdlc.md` - Spec Kit 如何將代理式與傳統 SDLC 實務應用於自身
- `guides/bugfix.md` - 錯誤修正導覽
- `guides/assessment.md` - 構想評估導覽
- `guides/customization.md` - 選擇與組合自訂建構區塊
- `reference/catalogs.md` - 型錄探索、信任、私有來源與優先順序
- `extensions/overview.md` - 擴充功能使用者指南
- `extensions/publishing.md` - 擴充功能發佈與型錄提交指南
- `integrations/index.md` - 整合型錄與共用設定指引
- `integrations/cli.md` - 共用整合管理 CLI 參考
- `integrations/<key>.md` - 代理專屬的設定、呼叫方式、選項與限制
- `integrations/catalog.md` - 型錄結構描述與外部配接器中繼資料
- `integrations/contributing.md` - 整合與型錄貢獻指南
- `reference/agentic-*.md` - 詳細的流程命令參考
- `_site/` - 產生的文件輸出（由 git 忽略）

## 部署

當變更推送至 `main` 分支時，文件會自動建置並部署至 GitHub Pages。工作流程定義於 `.github/workflows/docs.yml`。
