# Product Manager 套件組

給產品經理使用的角色套件組，讓 Spec Kit 專案準備好由產品經理推動
規格驅動開發：探索、規格制定與產品藍圖規劃。

## 安裝內容

- **擴充功能** `agent-context`——讓代理上下文檔案保持同步。
- **預設集** `product-discovery`（優先順序 10，append）——以探索為導向的
  命令集。
- **步驟** `draft-spec`、`review-spec`——規格撰寫步驟。
- **工作流程** `spec-to-roadmap`——把核准的規格轉成產品藍圖。

這個套件組**與整合無關**：它會沿用專案
已經在使用的整合（例如 `copilot`、`claude`）。

## 用法

```bash
specify bundle validate --path examples/bundles/product-manager
specify bundle build --path examples/bundles/product-manager --output dist/
```
