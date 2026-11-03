<a id="quick-start-guide"></a>

# 規格驅動開發快速入門

本指南將協助你使用 Spec Kit 開始規格驅動開發。全程我們以一個貫串範例說明每個步驟：**Taskify**，一個小型團隊生產力平台。

使用 SDD 從規格打造功能或應用程式。若是修復，請依[錯誤修復快速入門](guides/bugfix.md)；若要判斷一個構想是否值得投資，請依[構想評估快速入門](guides/assessment.md)。這些是獨立的流程，不是本指南的前置條件。

> [!NOTE]
> 自動化 script 提供 Bash（`.sh`）、PowerShell（`.ps1`）與 Python（`.py`）三種變體。互動式 `specify init` 會提示你選擇一種；非互動執行（沒有 TTY，或 `--non-interactive`）預設使用你作業系統的 shell 變體。傳入 `--script sh|ps|py` 可明確選擇。

這裡的流程步驟使用 GitHub Copilot 的預設 skills 模式（`/speckit-*`）。其他代理或模式，請見[命令呼叫](integrations/cli.md#command-invocation)。請在代理的聊天中分別呼叫每個 `/speckit-*` skill，並在進到下一步之前檢視結果。這些是代理 skill，不是終端機命令；只有 CLI 安裝與專案設定使用終端機。

## 建議流程

> [!TIP]
> **脈絡感知**：Spec Kit 以 `.specify/feature.json` 中記錄的功能目錄來追蹤作用中的功能（可用 `SPECIFY_FEATURE_DIRECTORY` 環境變數覆寫）。命令從該狀態解析功能，**不是**從已簽出的 Git 分支解析——不需要 Git。選用的 **git** 擴充功能會加入有編號的功能分支（例如 `001-feature-name`），用來在版本控制中組織工作，但作用中的功能仍是該狀態指向的目錄；光是 `git checkout` 不會改變它。若要讓命令指向不同的功能，請更新 `.specify/feature.json`（或設定 `SPECIFY_FEATURE_DIRECTORY`）。

安裝 Spec Kit 後，下面的每個 skill 都是流程中的一個步驟。常見的有兩條路徑：

開始任一條路徑之前，先用 `/speckit-constitution` 為專案建立一次憲章。

**較短路徑**——適用於較小的功能：

1. `/speckit-specify`
2. `/speckit-plan`
3. `/speckit-tasks`
4. `/speckit-implement`
5. `/speckit-converge`

**完整路徑**——適用於正式環境功能，加入 `/speckit-clarify`、`/speckit-checklist` 與 `/speckit-analyze` 作為品質關卡：

1. `/speckit-constitution`（每個專案一次）
2. `/speckit-specify`
3. `/speckit-clarify`
4. `/speckit-plan`
5. `/speckit-checklist`
6. `/speckit-tasks`
7. `/speckit-analyze`
8. `/speckit-implement`
9. `/speckit-converge`

### 安裝 Specify

**在你的終端機中**，從 PyPI 安裝 CLI（需要 [uv](install/uv.md)），接著初始化你的專案：

```bash
uv tool install specify-cli
specify init taskify --integration copilot
cd taskify
```

`init` 讓你以互動方式挑選程式代理，或用 `--integration` 明確傳入（例如 `--integration copilot`）。對於 CI 與 AI 代理框架，加入 `--non-interactive`，讓未指定的選項使用文件記載的預設值，而不是卡在方向鍵選擇器上。

> [!NOTE]
> 偏好 `pipx`、一次性的 `uvx` 執行、釘住的版本，或離線／氣隙設定？請見[安裝指南](installation.md)了解所有支援的方法。
> 要把 Spec Kit 加入已有程式碼的儲存庫？在開始下面的工作流程之前，先依[在既有專案中採用 Spec Kit](guides/existing-projects.md)。

在專案目錄中啟動你的程式代理。在它的聊天中逐一呼叫下列 skill。

<a id="step-1-speckitconstitution--set-the-ground-rules"></a>

### 步驟 1：`/speckit-constitution`——設定基本規則

建立專案的指導原則，後續每個步驟都會對照它來評估。請在一開始執行一次，並把你的原則作為引數傳入。

```text
/speckit-constitution Taskify is a "Security-First" application. All user inputs must be validated. We use a microservices architecture. Code must be fully documented.
```

<a id="step-2-speckitspecify--describe-what-to-build"></a>

### 步驟 2：`/speckit-specify`——描述要打造什麼

從自然語言描述建立功能規格。聚焦在**做什麼**與**為什麼**，而不是技術堆疊。

```text
/speckit-specify Develop Taskify, a team productivity platform where predefined users create projects, assign tasks, comment, and move tasks across Kanban columns (To Do, In Progress, In Review, Done). Five users (one product manager, four engineers), three sample projects, no login for this first phase.
```

<a id="step-3-speckitclarify--resolve-ambiguities"></a>

### 步驟 3：`/speckit-clarify`——釐清模糊之處

針對任何未充分說明的部分提出有針對性的問題，並把你的回答折回規格中，讓你不會在模糊的基礎上做計畫。在計畫之前執行它，可選擇帶上一個聚焦領域。

```text
/speckit-clarify Focus on task card behavior — status changes, comment permissions, and user assignment.
```

<a id="step-4-speckitplan--choose-the-tech-stack"></a>

### 步驟 4：`/speckit-plan`——選擇技術堆疊

從規格產生設計產出物。實作細節屬於這裡——請提供你的技術堆疊與架構。

```text
/speckit-plan Use .NET Aspire with Postgres. The frontend is Blazor Server with drag-and-drop boards and real-time updates. Expose REST APIs for projects, tasks, and notifications.
```

<a id="step-5-speckitchecklist--validate-the-spec"></a>

### 步驟 5：`/speckit-checklist`——驗證規格

產生一份自訂的品質檢核清單——「需求的單元測試」——在你拆解工作之前，確認規格完整、清楚且一致。這些自訂檢核清單是由審查者擁有的需求品質審查產出物：只有當審查者認定該需求品質準則已滿足時，才把項目標為 `[x]`。勾選的自訂項目不代表實作工作已完成。

```text
/speckit-checklist
```

<a id="step-6-speckittasks--break-the-work-down"></a>

### 步驟 6：`/speckit-tasks`——拆解工作

從設計產出物產生一份可執行、依相依順序排列的 `tasks.md`。

```text
/speckit-tasks
```

<a id="step-7-speckitanalyze--check-consistency"></a>

### 步驟 7：`/speckit-analyze`——檢查一致性

回報 `spec.md`、`plan.md` 與 `tasks.md` 之間的衝突、缺口與模糊之處。它是唯讀的——若它標出了問題，請在源頭修正並在實作前重新執行。

```text
/speckit-analyze
```

<a id="step-8-speckitimplement--build-it"></a>

### 步驟 8：`/speckit-implement`——打造它

依相依順序執行 `tasks.md` 中的任務。實作之前，它會讀取檢核清單的勾選狀態作為關卡，若有任何項目未勾選，會先詢問再繼續；它不會變更任何檢核清單檔案或標記。內建的 `checklists/requirements.md` 檢核清單由 `/speckit-specify` 與 `/speckit-clarify` 維護，而自訂檢核清單仍由審查者擁有。執行一次即可打造全部內容，或針對大型功能一次限定一個階段。

```text
/speckit-implement
```

<a id="step-9-speckitconverge--verify-completeness"></a>

### 步驟 9：`/speckit-converge`——驗證完整性

對照規格、計畫與任務檢查程式碼庫。若發現缺口，它會把新任務追加到 `tasks.md`；再執行 `/speckit-implement` 並再次收斂，直到它回報 **Converged**。否則你就完成了——接著進行審查或開啟 PR。

```text
/speckit-converge
```

> [!TIP]
> 每個命令的完整參考——引數、輸出、分階段實作，以及它們如何互動——請見[代理式 SDD](reference/agentic-sdd.md)。

## 關鍵原則

- **明確說明**你要打造什麼，以及為什麼
- **在規格階段不要聚焦**技術堆疊
- 在實作之前**反覆迭代並精煉**你的規格
- 在開始寫程式之前**驗證**需求與計畫
- **讓程式代理處理**實作細節

## 後續步驟

- 請見[代理式 SDD](reference/agentic-sdd.md)參考，了解每個命令的完整細節
- 了解如何用擴充功能、預設集、工作流程與套件組[自訂流程](guides/customization.md)
- 閱讀[完整方法論](https://github.com/github/spec-kit/blob/main/spec-driven.md)，取得深入指引
- 比較[核心範本](https://github.com/github/spec-kit/tree/main/templates)與[社群導覽](community/walkthroughs.md)，了解規格驅動開發在真實專案中的使用方式
- 探索 [GitHub 上的原始碼](https://github.com/github/spec-kit)
