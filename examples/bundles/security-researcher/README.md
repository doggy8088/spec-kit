# Security Researcher 套件組

給實踐規格驅動開發的安全研究人員使用的角色套件組：
威脅建模、安全審查與合規。

## 安裝內容

- **擴充功能** `agent-context`——讓代理上下文檔案保持同步。
- **預設集** `security-compliance`（優先順序 5，append）——安全與
  合規命令集；預設集依優先順序由低至高套用，因此這個較小的數字（5）會讓它在堆疊中排在數字較大的預設集之前。
- **步驟** `threat-model`、`security-review`。
- **工作流程** `secure-sdd`——一條安全優先的 SDD 工作流程。

這個套件組**與整合無關**：它會沿用專案目前啟用的
整合。

## 用法

```bash
specify bundle validate --path examples/bundles/security-researcher
specify bundle build --path examples/bundles/security-researcher --output dist/
```
