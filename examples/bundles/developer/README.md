# Developer 套件組

給實踐規格驅動開發的開發人員使用的角色套件組：實作
規劃、任務拆解與程式碼審查。

## 安裝內容

- **擴充功能** `agent-context`——讓代理上下文檔案保持同步。
- **預設集** `implementation-planning`（優先順序 10，append）——實作
  規劃命令集。
- **步驟** `plan-implementation`、`break-down-tasks`。
- **工作流程** `spec-to-implementation`——推動規格一路落實為程式碼。

這個套件組**與整合無關**：它會沿用專案目前啟用的
整合。

## 用法

```bash
specify bundle validate --path examples/bundles/developer
specify bundle build --path examples/bundles/developer --output dist/
```
