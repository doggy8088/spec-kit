# 自訂 Spec Kit

三套第一方流程是起點，不是上限。你可以保留內建的 SDD 流程、加入錯誤修復或評估、把某套流程調整成符合組織需要，或帶來一套完全不同的流程。

## 選對建構模組

| 目標 | 使用 |
| --- | --- |
| 把 Spec Kit 連接到程式代理，或調整其命令／skill 的交付方式 | 整合 |
| 新增命令、能力或流程 | 擴充功能 |
| 整合外部工具或服務 | 擴充功能 |
| 變更規格、計畫或任務的格式或術語 | 預設集 |
| 在既有範本中落實組織或法規標準 | 預設集 |
| 發布可重複使用的領域專屬範本 | 覆寫用預設集；新命令隨附的範本用擴充功能 |
| 在單一專案中做一次性的範本調整 | 專案本地覆寫 |
| 自動化多步驟流程 | 工作流程 |
| 為工作流程新增自訂可執行步驟類型 | 工作流程步驟套件 |
| 一次佈建完整的角色型設定 | 套件組 |

整合決定命令與 skill 如何交付給你的程式代理；這與連接外部工具或服務的擴充功能不同。請見[整合指南](../integrations/index.md)了解支援的代理與設定，或見[貢獻整合](../integrations/contributing.md)來開發配接器。

工作流程步驟套件擴充工作流程可用的步驟類型。請見[自訂步驟套件](../reference/workflows.md#custom-step-packages)了解安裝與執行方式，並見[社群工作流程步驟](../community/workflow-steps.md)了解探索與貢獻指引。安裝或使用可執行套件前，請先檢視其內容。

## 擴充功能：新增能力

擴充功能透過命令、範本、script 與 hook 擴展 **Spec Kit 能做的事**。它們可以加入領域專屬流程、外部整合，或核心之外的開發階段。

```bash
specify extension search
specify extension add <extension-name>
```

範例包括 Jira 整合、實作後的程式碼審查、V-Model 測試追溯，以及專案健康診斷。隨附的 [bug](bugfix.md) 與 [assess](assessment.md) 擴充功能是第一方範例。瀏覽[社群擴充功能](../community/extensions.md)，或使用[擴充功能參考](../reference/extensions.md)了解管理與設定方式。

## 預設集：改變流程的運作方式

預設集覆寫核心**以及已安裝擴充功能**提供的範本與命令。它們自訂所產出的產出物與指示，不需要新的工具。

```bash
specify preset search
specify preset add <preset-name>
```

使用預設集可以要求法規追溯、強制測試優先的任務排序、在計畫中加入安全性審查關卡，或把工作流程在地化。預設集也能把方法論調整為 Agile、Kanban、Waterfall、jobs-to-be-done 或領域驅動設計。[pirate-speak 示範](https://github.com/mnriem/spec-kit-pirate-speak-preset-demo)說明了術語可以改變到什麼程度。

多個預設集可以依優先順序堆疊。請見[社群預設集](../community/presets.md)的範例，以及[預設集參考](../reference/presets.md)的安裝、組合策略與優先順序說明。

## 專案本地覆寫與解析

若要在單一專案中做一次性自訂，把範本覆寫放在 `.specify/templates/overrides/`，而不是建立可重複使用的預設集。預設的替換順序是：

1. 專案本地覆寫。
2. 已安裝的預設集，依優先順序。
3. 已安裝的擴充功能，依優先順序。
4. `.specify/templates/` 中的 Spec Kit 核心範本。

範本在需要時解析，預設採用第一個符合的項目。命令則不同：安裝擴充功能或預設集會把命令檔案實體化到作用中整合的目錄裡。代理每次呼叫命令時，不會重新解析那一整疊。移除某個覆寫元件後，透過對帳會還原存續的命令層。

在沒有任何自訂的情況下，核心預設值即適用。[檔案解析參考](../reference/presets.md#file-resolution)是路徑、優先順序與 prepend／append／wrap 組合方式的權威指南。

## 套件組：角色型設定

套件組把一組精選的擴充功能、預設集、工作流程與工作流程步驟，打包成一個有版本、針對某個角色或團隊的設定。它的 `bundle.yml` 資訊清單會釘住各元件，並可指定目標整合；與整合無關的套件組則繼承專案作用中的整合。

```bash
specify bundle search
specify bundle info <bundle-id>
specify bundle install <bundle-id>
```

安裝前先查看 `info`，了解解析後的元件組合。請見[套件組參考](../reference/bundles.md)了解更新、移除、型錄政策、離線限制、驗證與發布方式，並見[範例資訊清單](https://github.com/github/spec-kit/tree/main/examples/bundles)了解產品經理、商業分析師、安全研究員與開發者的設定。

## 分享你的自訂成果

社群元件由各自獨立維護。安裝前請檢視原始碼，並自行判斷是否使用。造訪[社群指南](../community/overview.md)來探索元件或發布自己的成果，並造訪[工作流程參考](../reference/workflows.md)來自動化流程。
