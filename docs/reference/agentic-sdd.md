# 代理式 SDD

`/speckit.*` 斜線命令驅動核心規格驅動開發（SDD）流程，這是由程式代理逐步執行的 **agentic 流程**。如需引導式的端到端執行，請參見[快速入門指南](../quickstart.md)；本頁是每個命令的詳細參考，包括參數、輸出與它們之間的互動。如需流程背後的理念，請參見[什麼是 SDD？](../concepts/sdd.md)。錯誤分流請參見 [代理式錯誤修復](agentic-bugfix.md)。

這些命令設計為依序執行，但只有 `/speckit.specify` 是在 `/speckit.plan` 之前嚴格必須的。釐清、檢核清單與分析命令是品質關卡，適用於任何有明顯模糊之處的情況。

若要在投入規格前評估想法，請參見[代理式想法評估](agentic-assessment.md)。評估是選用的，且獨立於 SDD 流程。

> [!NOTE]
> 本頁的命令一律以 `/speckit.*` 形式撰寫。GitHub Copilot 的預設 skills 模式使用 `/speckit-*`；部分其他代理使用 `$speckit-*`（例如 Codex、ZCode）或 `/skill:speckit-*`（例如 Kimi）。請參見[命令呼叫方式](../integrations/cli.md#command-invocation)。

```text
/speckit.constitution -> /speckit.specify -> /speckit.clarify -> /speckit.plan -> /speckit.checklist -> /speckit.tasks -> /speckit.analyze -> /speckit.implement -> /speckit.converge
```

## 命令總覽

在 `specify init` 之後，這些命令可在所選整合中使用。支援選用 skills 模式的整合，可以用 `--integration-options="--skills"` 選取；部分整合（包括 Copilot）預設使用 skills。

| 命令 | 代理技能 | 用途 |
| --- | --- | --- |
| `/speckit.constitution` | `speckit-constitution` | 建立或更新專案原則 |
| `/speckit.specify` | `speckit-specify` | 定義需求與使用者故事 |
| `/speckit.plan` | `speckit-plan` | 建立技術實作計畫 |
| `/speckit.tasks` | `speckit-tasks` | 將計畫拆解為可執行的任務 |
| `/speckit.implement` | `speckit-implement` | 執行任務 |
| `/speckit.converge` | `speckit-converge` | 對照成品評估實作，並附加剩餘工作 |
| `/speckit.clarify` | `speckit-clarify` | 在規劃前解決模糊（選用品質關卡；原名 `/quizme`） |
| `/speckit.analyze` | `speckit-analyze` | 在任務後、實作前檢查成品一致性（選用品質關卡） |
| `/speckit.checklist` | `speckit-checklist` | 產生需求品質檢核清單（選用品質關卡） |

## `/speckit.constitution`

建立或更新專案**憲章**，也就是每個後續階段都要對照評估的指導原則，並讓相依範本保持同步。在一開始執行一次，每當原則變更時再更新。將原則作為參數傳入。

```text
/speckit.constitution This project follows a "Library-First" approach. All features must be implemented as standalone libraries first. We use TDD strictly. We prefer functional programming patterns.
```

更通用的起點：

```text
/speckit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements.
```

## `/speckit.specify`

從自然語言描述建立或更新功能**規格**。聚焦於**做什麼**與**為什麼**，也就是使用者面向的行為與目標，而非技術堆疊，技術堆疊屬於 `/speckit.plan`。

此工作流程也可能維護 `checklists/requirements.md`，這是內建的規格品質檢核清單，由 `/speckit.specify` 建立、由 `/speckit.clarify` 重新評估。該生命週期與 `/speckit.checklist` 產生的自訂檢核清單是分開的。

```text
/speckit.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

## `/speckit.clarify`

針對目前規格中未明確的區域，提出最多五個有針對性的問題，並將你的回答編碼回 `spec.md`。在規劃前視需要多次執行，每次處理不同區域。可以選用將聚焦區域作為參數傳入。

```text
/speckit.clarify Focus on the task card behavior: status changes, comment limits, and who can be assigned.
```

在規劃前釐清，可避免在模糊之上做設計。若 `/speckit.analyze` 之後發現需求缺口，請回來再次執行 `/speckit.clarify`（或 `/speckit.specify`）。

當 `checklists/requirements.md` 存在時，`/speckit.clarify` 可能會在收緊規格的過程中更新其評估狀態。此例外只適用於內建的需求檢核清單，不適用於自訂審查檢核清單。

## `/speckit.plan`

執行規劃流程，從規格產生設計成品。實作細節屬於此處，請將技術堆疊、架構與技術限制作為參數提供。

```text
/speckit.plan Use .NET Aspire with Postgres. The frontend is Blazor Server with drag-and-drop boards and real-time updates. Expose REST APIs for projects, tasks, and notifications.
```

以上述相簿範例為例：

```text
/speckit.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

## `/speckit.checklist`

為功能產生品質檢核清單，可以將它想成是「**需求的單元測試」**。它不是測試程式碼，而是檢查規格本身是否完整、清楚、無歧義且一致（例如：「是否為每一欄都定義了拖放規則？」、「是否為被刪除的被指派使用者指定了行為？」）。

此命令產生的自訂檢核清單是審查者擁有的需求品質審查成品。代理在被明確要求時可以協助評估，但實作不得默默自行核准。在自訂檢核清單中，`[x]` 表示審查者判定需求品質標準已滿足；它不表示實作工作已完成。

不帶參數執行可做廣泛的檢查，或傳入聚焦區域以針對某個面向：

```text
/speckit.checklist
```

```text
/speckit.checklist Focus on the Kanban board interactions and comment permissions.
```

檢視產生的檢核清單。若它發現缺口，請回到 `/speckit.clarify` 或 `/speckit.specify` 收緊規格，然後再拆解工作，且只有在需求品質標準已審查並滿足後，才將每個自訂檢核清單項目標為 `[x]`。

## `/speckit.tasks`

從設計成品產生可執行、依相依順序排列的 `tasks.md`。任務組織為多個階段：**Setup**、**Foundational**（阻擋性的前置條件），然後**每個使用者故事一個階段**（依優先順序），以及最後處理橫切關注點的 **Polish** 階段。測試在被要求時，於使用者故事的階段內產生，而非獨立階段，且任務在可行的情況下會標示為可平行執行。

```text
/speckit.tasks
```

## `/speckit.analyze`

對 `spec.md`、`plan.md` 與 `tasks.md` 執行**唯讀**的跨成品一致性與品質分析，回報衝突、缺口與模糊（例如沒有對應需求的任務，或與規格矛盾的計畫選擇）。它絕不編輯檔案，只產生報告，並可選用提出供你核准的修復建議。

```text
/speckit.analyze
```

在實作前執行，此時成品仍可低成本調整。若它發現問題，**回到擁有該問題的較早步驟**，並在源頭修正，需求問題用 `/speckit.specify` 或 `/speckit.clarify`，設計問題用 `/speckit.plan`，任務清單用 `/speckit.tasks` 重新產生，然後再次執行 `/speckit.analyze`，直到結果乾淨。你也可以在實作後再次執行 `/speckit.analyze` 作為額外審查。

## `/speckit.implement`

執行 `tasks.md` 中的任務，依相依順序執行每個階段，並尊重平行標記。

在執行任務前，它會讀取檢核清單的勾選狀態作為關卡。檢核清單標記對此命令而言是唯讀的：`/speckit.implement` 會計算已勾選與未勾選的項目數，並在有任何未勾選時於繼續前先詢問，但不得變更檢核清單標記。對於自訂檢核清單，已勾選項目表示審查者核准了需求品質，不是實作工作已完成。

對於小型功能，執行一次即可建置全部：

```text
/speckit.implement
```

對於大型功能，請分階段進行，避免壓垮代理的上下文，每次執行以參數限定範圍，驗證結果，然後再繼續：

```text
/speckit.implement Implement only the Setup and Foundational phases: project scaffolding and the project/task data model with basic CRUD. Stop before the user-story features.
```

```text
/speckit.implement Now implement the Kanban board user story: drag-and-drop between columns.
```

每個階段都要驗證可運作後，再進入下一個階段。

## `/speckit.converge`

對照功能的規格、計畫與任務評估程式碼庫，確認沒有遺漏。它是**僅附加**的：絕不編輯或刪除程式碼，其唯一可能的寫入是將任務新增到 `tasks.md`。只有在 `/speckit.implement` 已對目前的 `tasks.md` 執行後，才執行它。

```text
/speckit.converge
```

它會先列印依嚴重程度分級的發現摘要，然後歸結為兩種結果之一：

- **已收斂**——未發現缺口。`tasks.md` 保持逐位元不變，你會看到乾淨的結果，例如 `✅ Converged — the implementation satisfies the spec, plan, and tasks.`。你已完成；請進行審查或開啟 PR。
- **已附加任務**——發現缺口。Converge 會將它們作為新任務附加到 `tasks.md` 的 Convergence 區段下，並告訴你數量。再次執行 `/speckit.implement` 完成它們，然後再執行一次 `/speckit.converge`。每一輪發現的項目會更少；重複直到它回報已收斂。
