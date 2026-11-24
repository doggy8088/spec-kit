# 社群工作流程

社群工作流程將 Spec Kit 步驟組合成獨立維護、可重複的流程。

> [!NOTE]
> 維護者僅檢查型錄項目的形式與完整性，不檢查工作流程程式碼、指令碼或相依性。收錄不等同於稽核、背書或支援承諾。安裝與使用前，請先檢視原始碼、必要的整合、副作用與審查關卡。

## 可用的工作流程

以下為[社群工作流程型錄](https://github.com/github/spec-kit/blob/main/workflows/catalog.community.json)中的項目：

| 工作流程 | 版本 | 說明 |
| --- | --- | --- |
| [ADO story lifecycle](https://github.com/praveenlavu/spec-kit-ado/tree/v0.4.0/workflows/ado-lifecycle) (`ado-lifecycle`) | 0.4.0 | 將 Azure DevOps story 推向已開啟的 pull request，過程中提供預覽，並在每次 Azure Boards 或 PR 變更時設有人類關卡與套用步驟 |
| [GitHub issue lifecycle](https://github.com/praveenlavu/spec-kit-ghp/tree/v0.1.2/workflows/ghp-lifecycle) (`ghp-lifecycle`) | 0.1.2 | 將 GitHub story issue 推向已開啟的 pull request，過程中提供預覽，並在每次 GitHub issue、Project 或 PR 變更時設有人類關卡與套用步驟 |
| [Spec Kit lifecycle for Jira](https://github.com/praveenlavu/spec-kit-jira/tree/v0.1.0/workflows/jira-lifecycle) (`jira-lifecycle`) | 0.1.0 | 將 Jira Cloud story 推向已開啟的 pull request，過程中提供預覽，並在每次 Jira 或 PR 變更時設有人類關卡與套用步驟 |
| [Guided SDD Pipeline](https://github.com/domattioli/spec-kit-workflow-pipeline) (`pipeline`) | 1.1.0 | 串連 specify、clarify、plan、tasks、analyze、implement 與 converge，設有 clarify 關卡與實作後的收斂迴圈 |
| [Full SDD Cycle - no gates](https://github.com/clintcparker/speckit-addons/tree/yolo-v0.1.0/workflows/yolo) (`yolo`) | 0.1.0 | 執行 specify、plan、tasks 與 implement，不設審查關卡 |

這些是社群定義的工作流程，與 Spec Kit 內建的工作流程不同。請檢視啟用的來源與公告的 release：

```bash
specify workflow catalog list
specify workflow search
specify workflow info <id> --versions
```

搜尋使用所有啟用的工作流程型錄。內建社群來源僅供探索：收錄不等同於可透過該來源以 `specify workflow add <id>` 安裝。審查 release 後，請明確安裝其固定 URL，或使用另行設定且信任並允許安裝的型錄。

## 貢獻工作流程

發佈具版本編號的工作流程定義或完整套件，並提交專門編輯 `workflows/catalog.community.json` 的 PR。請附上 release 中繼資料、文件、必要的整合與副作用，以及端對端測試證據，包含適用的關卡與續跑行為。

工作流程定義不使用提交 issue 表單。Workflow Step Type Submission 表單適用於可執行的自訂步驟套件，不適用於工作流程。發佈指南負責型錄項目格式與 release 更新程序。

## 另請參閱

- [工作流程總覽與內建定義](../workflows/overview.md)
- [工作流程管理 CLI](../workflows/cli.md)
- [開發工作流程](../workflows/developing.md)
- [發佈與提交工作流程](../workflows/publishing.md)
- [工作流程型錄](../workflows/catalogs.md)
- [社群工作流程步驟類型](workflow-steps.md)
