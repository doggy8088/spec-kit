# 文件

此資料夾包含 Spec Kit 的文件原始檔，採用 [DocFX](https://dotnet.github.io/docfx/) 建置。

## 本地建置

若要在本地建置文件：

1. 安裝 DocFX：
   ```bash
   dotnet tool install -g docfx
   ```

2. 建置文件：
   ```bash
   cd docs
   docfx docfx.json --serve
   ```

3. 在瀏覽器中開啟 `http://localhost:8080` 以檢視文件。

## 結構

- `docfx.json` - DocFX 設定檔
- `index.md` - 主要文件首頁
- `toc.yml` - 目錄結構設定
- `installation.md` - 安裝指南
- `quickstart.md` - 快速入門指南
- `_site/` - 產生的文件輸出（已被 git 忽略）

## 部署

當變更被推送至 `main` 分支時，文件會自動建置並部署到 GitHub Pages。相關工作流程定義於 `.github/workflows/docs.yml`。

