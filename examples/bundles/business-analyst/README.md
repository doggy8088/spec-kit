# Business Analyst 套件組

給在規格驅動開發流程中工作的業務分析師使用的角色套件組：
需求訪談、可追溯性與驗收標準。

## 安裝內容

- **擴充功能** `agent-context`——讓代理上下文檔案保持同步。
- **預設集** `requirements-elicitation`（優先順序 10，append）——訪談與
  分析命令集。
- **步驟** `capture-requirements`、`trace-acceptance-criteria`。
- **工作流程** `requirements-to-spec`——把擷取到的需求轉成規格。

這個套件組**與整合無關**：它會沿用專案目前啟用的
整合。

## 用法

```bash
specify bundle validate --path examples/bundles/business-analyst
specify bundle build --path examples/bundles/business-analyst --output dist/
```
