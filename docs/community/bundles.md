# 社群套件組

> [!NOTE]
> 社群套件組由各自作者獨立建立與維護。維護者僅確認提交中繼資料完整且格式正確，不審查、稽核、背書或支援套件組程式碼或其安裝的元件。安裝前請先檢視套件組資訊清單、元件型錄與原始儲存庫，並自行斟酌使用。

套件組將既有的 Spec Kit 元件，也就是擴充功能、預設集、工作流程與步驟，組合成單一的角色或團隊組合。當使用者應該能一同安裝一組經過測試的元件，而不是分別執行多個安裝命令時，套件組特別實用。

經接受的社群套件組項目發佈於 [`bundles/catalog.community.json`](https://github.com/github/spec-kit/blob/main/bundles/catalog.community.json)，並列於下方。內建社群來源僅供探索：`specify bundle search` 與 `specify bundle info` 可檢視項目，但依 ID 安裝時，必須明確加入經審查且允許安裝的型錄。明確指定的型錄預設優先順序高於內建社群來源。若要提交套件組進行中繼資料驗證，請依循[發佈指南](../bundles/publishing.md)，並提出 [Bundle Submission](https://github.com/github/spec-kit/issues/new?template=bundle_submission.yml) issue。

| 套件組 | 用途 | 角色或團隊 | 提供內容 | 所需型錄 | URL |
|--------|---------|--------------|----------|-------------------|-----|
| Agentstandards Multi-Vendor Architecture | 安裝由 Codex 協調的多廠商架構委員會、其硬性任務關卡，以及支援的 Spec Kit 工作流程。 | `architecture-governance` | 1 個擴充功能、1 個預設集、1 個工作流程 | 已記錄 | [agentstandards](https://github.com/bbjwz/agentstandards) |
| SicarioSpec Security & Governance Bundle | GitHub Spec Kit 的安全預設治理套件組。強制執行資料分類、威脅建模與由程式碼持有的驗證關卡。 | `security-engineer` | 1 個擴充功能、11 個預設集 | 已記錄 | [sicario-spec](https://github.com/dfirs1car1o/sicario-spec) |
| Spec Kit for Azure DevOps | ado 擴充功能加上 ado-lifecycle 工作流程：將 ADO story 推向 Done，在每次看板或 PR 變更時都設有人類關卡。 | `developer` | 1 個擴充功能、1 個工作流程 | 已記錄 | [spec-kit-ado](https://github.com/praveenlavu/spec-kit-ado) |
| SpecAssay | 為原廠 Spec Kit 提供持久 ID 提升：範本、Gate 2 拒絕與追蹤資訊清單產出。 | `developer` | 1 個擴充功能、1 個預設集 | 已記錄 | [specassay](https://github.com/rdryfoos/specassay) |

## 另請參閱

- [套件組總覽](../bundles/overview.md)
- [安裝與檢視套件組](../bundles/cli.md)
- [型錄政策與元件來源審查](../bundles/catalogs.md)
- [開發套件組](../bundles/developing.md)
- [發佈、更新與提交審查範圍](../bundles/publishing.md)
