<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快打造高品質軟體。</em></h3>
</div>

<p align="center">
    <strong>透過 Spec-Driven Development 方法論，協助組織專注於產品情境，而非重複撰寫無差異化的程式碼。</strong>
</p>

<p align="center">
    <a href="https://github.com/github/spec-kit/actions/workflows/release.yml""><img src="https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg"" alt="Release"/></a>
    <a href="https://github.com/github/spec-kit/stargazers""><img src="https://img.shields.io/github/stars/github/spec-kit?style=social"" alt="GitHub stars"/></a>
    <a href="https://github.com/github/spec-kit/blob/main/LICENSE""><img src="https://img.shields.io/github/license/github/spec-kit"" alt="License"/></a>
    <a href="https://github.github.io/spec-kit/""><img src="https://img.shields.io/badge/docs-GitHub_Pages-blue"" alt="Documentation"/></a>
</p>

---

## 目錄

- [🤔 什麼是 Spec-Driven Development？](#-what-is-spec-driven-development)
- [⚡ 快速開始](#-get-started)
- [📽️ 影片總覽](#-video-overview)
- [🤖 支援的 AI agent](#-supported-ai-agents)
- [🔧 Specify CLI 參考](#-specify-cli-reference)
- [📚 核心理念](#-core-philosophy)
- [🌟 開發階段](#-development-phases)
- [🎯 實驗目標](#-experimental-goals)
- [🔧 先決條件](#-prerequisites)
- [📖 進一步了解](#-learn-more)
- [📋 詳細流程](#-detailed-process)
- [🔍 疑難排解](#-troubleshooting)
- [👥 維護者](#-maintainers)
- [💬 支援](#-support)
- [🙏 致謝](#-acknowledgements)
- [📄 授權條款](#-license)

## 🤔 什麼是 Spec-Driven Development？

Spec-Driven Development 方法論**顛覆了**傳統軟體開發的流程。數十年來，程式碼一直是主角——規格僅僅是我們搭建並在「真正開始寫程式」後就丟棄的鷹架。Spec-Driven Development 則不同：**規格本身可以執行**，不只是作為參考指引，而是能直接產生可運作的實作。

## ⚡ 快速開始

### 1. 安裝 Specify

請選擇你偏好的安裝方式：

#### 方式一：持久安裝（推薦）

只需安裝一次，隨處可用：

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

然後直接使用該工具：

```bash
specify init <PROJECT_NAME>
specify check
```

#### 升級方式

若要升級，請執行下列指令：

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
```

#### 選項 2：一次性使用 (One-time Usage)

直接執行，無需安裝：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

**持久安裝的好處：**

- 工具會持續安裝並可在 PATH 中使用
- 無需建立 shell 別名
- 使用 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 可更好地管理工具
- 讓 shell 設定更乾淨

### 2. 建立專案原則

使用 **`/speckit.constitution`** 指令來建立你的專案治理原則與開發指南，這將指引後續的所有開發工作。

```bash
/speckit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements
```

### 3. 建立規格說明

使用 **`/speckit.specify`** 指令來描述您想要建構的內容。請著重於**做什麼（what）**以及**為什麼（why）**，而非技術堆疊。

```bash
/speckit.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 4. 建立技術實作計畫

使用 **`/speckit.plan`** 指令來說明你的技術堆疊與架構選擇。

```bash
/speckit.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

### 5. 拆解為任務

使用 **`/speckit.tasks`** 根據你的實作計畫建立可執行的任務清單。

```bash
/speckit.tasks
```

### 6. 執行實作

使用 **`/speckit.implement`** 來執行所有任務，並依照計畫建構你的功能。

```bash
/speckit.implement
```

如需詳細的逐步操作說明，請參閱我們的 [comprehensive guide](./spec-driven.md)。

## 📽️ 影片總覽

想看看 Spec Kit 的實際運作嗎？歡迎觀看我們的 [video overview](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)！

[![Spec Kit video header](/media/spec-kit-video-header.jpg)](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)

## 🤖 支援的 AI agent

| Agent                                                     | 支援狀態 | 備註                                             |
|-----------------------------------------------------------|---------|---------------------------------------------------|
| [Claude Code](https://www.anthropic.com/claude-code)      | ✅ |                                                   |
| [GitHub Copilot](https://code.visualstudio.com/)          | ✅ |                                                   |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | ✅ |                                                   |
| [Cursor](https://cursor.sh/)                              | ✅ |                                                   |
| [Qwen Code](https://github.com/QwenLM/qwen-code)          | ✅ |                                                   |
| [opencode](https://opencode.ai/)                          | ✅ |                                                   |
| [Windsurf](https://windsurf.com/)                         | ✅ |                                                   |
| [Kilo Code](https://github.com/Kilo-Org/kilocode)         | ✅ |                                                   |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview)   | ✅ |                                                   |
| [CodeBuddy](https://www.codebuddy.ai/)                    | ✅ |                                                   |
| [Roo Code](https://roocode.com/)                          | ✅ |                                                   |
| [Codex CLI](https://github.com/openai/codex)              | ✅ |                                                   |
| [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/) | ⚠️ | Amazon Q Developer CLI [does not support](https://github.com/aws/amazon-q-developer-cli/issues/3064) slash 指令的自訂參數。 |

## 🔧 Specify CLI 參考

`specify` 指令支援下列選項：

### 指令

| 指令     | 說明                                                    |
|-------------|----------------------------------------------------------------|
| `init`      | 從最新範本初始化新的 Specify 專案      |
| `check`     | 檢查已安裝的工具（`git`、`claude`、`gemini`、`code`/`code-insiders`、`cursor-agent`、`windsurf`、`qwen`、`opencode`、`codex`） |

### `specify init` 參數與選項

| 參數/選項        | 類型     | 說明                                                                  |
|------------------------|----------|------------------------------------------------------------------------------|
| `<project-name>`       | 參數 | 新專案目錄名稱（若使用 `--here` 可選填，或用 `.` 於目前目錄） |
| `--ai`                 | 選項   | 指定要使用的 AI assistant：`claude`、`gemini`、`copilot`、`cursor`、`qwen`、`opencode`、`codex`、`windsurf`、`kilocode`、`auggie`、`roo`、`codebuddy` 或 `q` |
| `--script`             | 選項   | 指定腳本類型：`sh`（bash/zsh）或 `ps`（PowerShell）                 |
| `--ignore-agent-tools` | 旗標     | 跳過 AI agent 工具檢查（如 Claude Code）                             |
| `--no-git`             | 旗標     | 跳過 git 儲存庫初始化                                          |
| `--here`               | 旗標     | 於目前目錄初始化專案（不建立新目錄）   |
| `--force`              | 旗標     | 強制合併/覆蓋於目前目錄初始化時（跳過確認） |
| `--skip-tls`           | 旗標     | 跳過 SSL/TLS 驗證（不建議）                                 |
| `--debug`              | 旗標     | 啟用詳細除錯輸出以協助問題排查                            |
| `--github-token`       | 選項   | 用於 API 請求的 GitHub token（或設定 GH_TOKEN/GITHUB_TOKEN 環境變數）  |

### 範例

```bash
# Basic project initialization
specify init my-project

# Initialize with specific AI assistant
specify init my-project --ai claude

# Initialize with Cursor support
specify init my-project --ai cursor-agent

# Initialize with Windsurf support
specify init my-project --ai windsurf

# Initialize with PowerShell scripts (Windows/cross-platform)
specify init my-project --ai copilot --script ps

# Initialize in current directory
specify init . --ai copilot
# or use the --here flag
specify init --here --ai copilot

# Force merge into current (non-empty) directory without confirmation
specify init . --force --ai copilot
# or 
specify init --here --force --ai copilot

# Skip git initialization
specify init my-project --ai gemini --no-git

# Enable debug output for troubleshooting
specify init my-project --ai claude --debug

# Use GitHub token for API requests (helpful for corporate environments)
specify init my-project --ai claude --github-token ghp_your_token_here

# Check system requirements
specify check
```

### 可用的 Slash 指令

執行 `specify init` 後，你的 AI 編碼代理工具將能使用以下 Slash 指令，進行結構化開發：

#### 核心指令

Spec-Driven Development 方法論工作流程的基本指令：

| 指令                  | 說明                                                           |
|-----------------------|----------------------------------------------------------------|
| `/speckit.constitution`  | 建立或更新專案憲章與開發指南 |
| `/speckit.specify`       | 定義你想要建構的內容（需求與使用者故事）        |
| `/speckit.plan`          | 以選定的技術堆疊建立技術實作計劃     |
| `/speckit.tasks`         | 產生可執行的實作任務清單                     |
| `/speckit.implement`     | 執行所有任務，依照計劃建構功能         |

#### 選用指令

提升品質與驗證的額外指令：

| 指令              | 說明                                                           |
|-------------------|----------------------------------------------------------------|
| `/speckit.clarify`   | 釐清規格中未明確的區域（建議於 `/speckit.plan` 前執行；原為 `/quizme`） |
| `/speckit.analyze`   | 進行跨產出物一致性與覆蓋率分析（於 `/speckit.tasks` 之後、`/speckit.implement` 之前執行） |
| `/speckit.checklist` | 產生自訂品質檢查清單，驗證需求的完整性、明確性與一致性（如同「英文的單元測試」） |

### 環境變數

| 變數         | 說明                                                                                    |
|--------------|-----------------------------------------------------------------------------------------|
| `SPECIFY_FEATURE` | 覆寫非 Git 儲存庫的功能偵測。設為功能目錄名稱（例如 `001-photo-albums`），可在未使用 Git 分支時針對特定功能作業。<br/>**必須在你操作的代理工具上下文中，於使用 `/speckit.plan` 或後續指令前設定。 |

## 📚 核心理念

Spec-Driven Development 方法論強調：

- **意圖導向開發**：先定義「做什麼」（what），再決定「怎麼做」（how）
- **豐富的規格撰寫**：結合防呆機制與組織原則
- **多步驟精煉**：避免單次提示直接產生程式碼
- **高度依賴**先進 AI 模型對規格的解讀能力

## 🌟 開發階段

| 階段 | 重點 | 主要活動 |
|------|------|----------|
| **0-to-1 開發**（Greenfield） | 從零開始產生 | <ul><li>從高階需求開始</li><li>產生規格</li><li>規劃實作步驟</li><li>建構可上線的應用程式</li></ul> |
| **創意探索** | 平行實作 | <ul><li>探索多元解法</li><li>支援多種技術堆疊與架構</li><li>實驗不同 UX 模式</li></ul> |
| **漸進式強化**（Brownfield） | 舊系統現代化 | <ul><li>逐步新增功能</li><li>現代化既有系統</li><li>調整流程</li></ul> |

## 🎯 實驗目標

我們的研究與實驗聚焦於：

### 技術中立

- 使用多元技術堆疊建立應用程式
- 驗證 Spec-Driven Development 方法論是一種流程，不受限於特定技術、程式語言或框架

### 企業級限制

- 展示任務關鍵型應用程式開發
- 納入組織限制（雲端供應商、技術堆疊、工程實踐）
- 支援企業設計系統與合規需求

### 以使用者為中心的開發

- 為不同用戶族群與偏好打造應用程式
- 支援多種開發模式（從 vibe-coding 到 AI-native 開發）

### 創意與迭代流程

- 驗證平行實作探索的概念
- 提供健全的迭代式功能開發工作流程
- 擴展流程以支援升級與現代化任務

## 🔧 先決條件

- **Linux/macOS**（或 Windows 上的 WSL2）
- AI 編碼代理工具：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[Gemini CLI](https://github.com/google-gemini/gemini-cli)、[Cursor](https://cursor.sh/)、[Qwen CLI](https://github.com/QwenLM/qwen-code)、[opencode](https://opencode.ai/)、[Codex CLI](https://github.com/openai/codex)、[Windsurf](https://windsurf.com/)、或 [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/)
- [uv](https://docs.astral.sh/uv/)（套件管理）
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

若你在使用代理工具時遇到問題，請提交 issue 以便我們優化整合。

## 📖 進一步了解

- **[完整 Spec-Driven Development 方法論](./spec-driven.md)**－深入了解完整流程
- **[詳細操作教學](#-detailed-process)**－逐步實作指南

---

## 📋 詳細流程

<details>
<summary>點擊展開詳細的逐步操作說明</summary>

你可以使用 Specify CLI 來初始化你的專案，這會將所需產出物帶入你的環境。執行：

```bash
specify init <project_name>
```

![Specify CLI bootstrapping a new project in the terminal](./media/specify_cli.gif)

或在目前目錄中初始化：

```bash
specify init .
# or use the --here flag
specify init --here
# Skip confirmation when the directory already has files
specify init . --force
# or
specify init --here --force
```

![Specify CLI bootstrapping a new project in the terminal](./media/specify_cli.gif)

系統會提示您選擇正在使用的 AI agent。您也可以直接在終端機中主動指定：

```bash
specify init <project_name> --ai claude
specify init <project_name> --ai gemini
specify init <project_name> --ai copilot

# Or in current directory:
specify init . --ai claude
specify init . --ai codex

# or use --here flag
specify init --here --ai claude
specify init --here --ai codex

# Force merge into a non-empty current directory
specify init . --force --ai claude

# or
specify init --here --force --ai claude
```

命令列介面 (Command Line Interface) 會檢查你是否已安裝 Claude Code、Gemini CLI、Cursor CLI、Qwen CLI、opencode、Codex CLI 或 Amazon Q Developer CLI。如果你尚未安裝這些工具，或你希望在不檢查工具的情況下直接取得範本，請在指令中加入 `--ignore-agent-tools`：

```bash
specify init <project_name> --ai claude --ignore-agent-tools
```

### **步驟 1：** 建立專案原則

進入專案資料夾並啟動您的 AI agent。在本範例中，我們使用的是 `claude`。

![Bootstrapping Claude Code environment](./media/bootstrap-claude-code.gif)

當您看到 `/speckit.constitution`、`/speckit.specify`、`/speckit.plan`、`/speckit.tasks` 和 `/speckit.implement` 指令可用時，代表環境已正確設定。

第一步應該是使用 `/speckit.constitution` 指令來建立專案的治理原則（governing principles）。這有助於在後續所有開發階段中確保決策的一致性：

```text
/speckit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements. Include governance for how these principles should guide technical decisions and implementation choices.
```

此步驟會建立或更新 `.specify/memory/constitution.md` 檔案，內容為您專案的基礎指導原則，AI agent 會在規格說明、規劃與實作階段參考這份文件。

### **步驟 2：**建立專案規格

在確立專案原則後，您現在可以建立功能規格。請使用 `/speckit.specify` 指令，並提供您想開發專案的具體需求。

>[!IMPORTANT]
>請盡可能明確說明您想要建構的 _內容_ 以及 _原因_。**此階段請不要聚焦於技術堆疊。**

範例提示如下：

```text
Develop Taskify, a team productivity platform. It should allow users to create projects, add team members,
assign tasks, comment and move tasks between boards in Kanban style. In this initial phase for this feature,
let's call it "Create Taskify," let's have multiple users but the users will be declared ahead of time, predefined.
I want five users in two different categories, one product manager and four engineers. Let's create three
different sample projects. Let's have the standard Kanban columns for the status of each task, such as "To Do,"
"In Progress," "In Review," and "Done." There will be no login for this application as this is just the very
first testing thing to ensure that our basic features are set up. For each task in the UI for a task card,
you should be able to change the current status of the task between the different columns in the Kanban work board.
You should be able to leave an unlimited number of comments for a particular card. You should be able to, from that task
card, assign one of the valid users. When you first launch Taskify, it's going to give you a list of the five users to pick
from. There will be no password required. When you click on a user, you go into the main view, which displays the list of
projects. When you click on a project, you open the Kanban board for that project. You're going to see the columns.
You'll be able to drag and drop cards back and forth between different columns. You will see any cards that are
assigned to you, the currently logged in user, in a different color from all the other ones, so you can quickly
see yours. You can edit any comments that you make, but you can't edit comments that other people made. You can
delete any comments that you made, but you can't delete comments anybody else made.
```

輸入此提示後，您應該會看到 Claude Code 啟動規劃與規格草擬流程。Claude Code 也會觸發部分內建腳本來設定儲存庫。

完成這個步驟後，您應該會看到已建立一個新分支（例如：`001-create-taskify`），以及在 `specs/001-create-taskify` 目錄下產生一份新的規格說明。

產生的規格說明應包含一組使用者故事與功能性需求，內容依範本所定義。

此時，您的專案資料夾內容應類似如下：

```text
└── .specify
    ├── memory
    │	 └── constitution.md
    ├── scripts
    │	 ├── check-prerequisites.sh
    │	 ├── common.sh
    │	 ├── create-new-feature.sh
    │	 ├── setup-plan.sh
    │	 └── update-claude-md.sh
    ├── specs
    │	 └── 001-create-taskify
    │	     └── spec.md
    └── templates
        ├── plan-template.md
        ├── spec-template.md
        └── tasks-template.md
```

### **步驟 3：** 釐清功能規格（規劃前必須執行）

在建立好基準規格（baseline specification）後，你可以針對第一次嘗試未能正確捕捉的需求進行釐清。

你應該在建立技術規劃（technical plan）**之前**，先執行結構化的釐清流程，以減少後續返工。

建議順序如下：
1. 優先使用 `/speckit.clarify`（結構化）——依序、覆蓋式提問，並將答案記錄於 Clarifications 區段。
2. 如仍有不明確之處，可選擇性地進行自由形式（ad-hoc）的細化提問。

如果你有意跳過釐清流程（例如：進行 spike 或探索性原型開發），請明確說明，讓 agent 不會因缺乏釐清而中斷流程。

自由形式細化提示詞範例（如在 `/speckit.clarify` 後仍有需要）：

```text
For each sample project or project that you create there should be a variable number of tasks between 5 and 15
tasks for each one randomly distributed into different states of completion. Make sure that there's at least
one task in each stage of completion.
```

你也應該請 Claude Code 驗證 **Review & Acceptance Checklist**，將已通過驗證／符合需求的項目勾選，未通過的則保持未勾選狀態。可以使用以下提示語：

```text
Read the review and acceptance checklist, and check off each item in the checklist if the feature spec meets the criteria. Leave it empty if it does not.
```

與 Claude Code 的互動應視為釐清與詢問規格問題的機會——**不要將其第一次回應視為最終結果**。

### **步驟 4：** 產生計畫

此時，您可以明確指定技術堆疊及其他技術需求。您可以使用專案範本內建的 `/speckit.plan` 指令，並搭配如下提示語：

```text
We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use
Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API,
tasks API, and a notifications API.
```

此步驟的輸出將包含多份實作細節文件，您的目錄樹將類似如下所示：

```text
.
├── CLAUDE.md
├── memory
│	 └── constitution.md
├── scripts
│	 ├── check-prerequisites.sh
│	 ├── common.sh
│	 ├── create-new-feature.sh
│	 ├── setup-plan.sh
│	 └── update-claude-md.sh
├── specs
│	 └── 001-create-taskify
│	     ├── contracts
│	     │	 ├── api-spec.json
│	     │	 └── signalr-spec.md
│	     ├── data-model.md
│	     ├── plan.md
│	     ├── quickstart.md
│	     ├── research.md
│	     └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

請參閱 `research.md` 文件，根據你的指示確認所使用的技術堆疊是否正確。如有任何組件特別突出，你可以請 Claude Code 進一步優化，甚至讓它檢查你想使用的平台或框架（例如 .NET）在本地安裝的版本。

此外，如果你選擇的技術堆疊屬於快速變動的領域（例如 .NET Aspire、JavaScript 框架），你也可以請 Claude Code 針對該技術堆疊進行詳細研究，提示語例如：

```text
I want you to go through the implementation plan and implementation details, looking for areas that could
benefit from additional research as .NET Aspire is a rapidly changing library. For those areas that you identify that
require further research, I want you to update the research document with additional details about the specific
versions that we are going to be using in this Taskify application and spawn parallel research tasks to clarify
any details using research from the web.
```

在這個過程中，你可能會發現 Claude Code 研究的方向不正確——你可以用如下的提示詞協助它回到正確的方向：

```text
I think we need to break this down into a series of steps. First, identify a list of tasks
that you would need to do during implementation that you're not sure of or would benefit
from further research. Write down a list of those tasks. And then for each one of these tasks,
I want you to spin up a separate research task so that the net results is we are researching
all of those very specific tasks in parallel. What I saw you doing was it looks like you were
researching .NET Aspire in general and I don't think that's gonna do much for us in this case.
That's way too untargeted research. The research needs to help you solve a specific targeted question.
```

>[!NOTE]
>Claude Code 有時可能會過於積極，新增你未要求的元件。請要求它說明這些變更的理由及來源。

### **步驟 5：**請 Claude Code 驗證計畫

當你完成計畫後，應該讓 Claude Code 依照計畫檢查一遍，以確保沒有遺漏任何部分。你可以使用如下提示詞：

```text
Now I want you to go and audit the implementation plan and the implementation detail files.
Read through it with an eye on determining whether or not there is a sequence of tasks that you need
to be doing that are obvious from reading this. Because I don't know if there's enough here. For example,
when I look at the core implementation, it would be useful to reference the appropriate places in the implementation
details where it can find the information as it walks through each step in the core implementation or in the refinement.
```

這有助於細化你的實作計畫，並協助你避免 Claude Code 在規劃流程中可能遺漏的盲點。完成初步細化後，請再要求 Claude Code 依據檢查清單重新檢查一次，確認可以進入實作階段。

你也可以要求 Claude Code（如果你已安裝 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)）直接從你目前的分支建立一個 Pull Request 到 `main`，並附上詳細說明，以確保所有工作都能被妥善追蹤。

>[!NOTE]
>在讓 AI agent 進行實作前，也建議你提示 Claude Code 交叉檢查細節，確認是否有過度設計（記住——它有時會過於積極）。如果發現有過度設計的元件或決策，可以請 Claude Code 協助修正。請確保 Claude Code 依循 [constitution](base/memory/constitution.md)，作為制定計畫時必須遵守的基礎。

### STEP 6: Implementation

準備好後，請使用 `/speckit.implement` 指令來執行你的實作計畫：

```text
/speckit.implement
```

`/speckit.implement` 指令將會執行以下動作：
- 驗證所有前置條件是否齊備（專案憲章、規格、計畫和任務）
- 解析來自 `tasks.md` 的任務拆解
- 依正確順序執行任務，並遵循相依性（dependency）及平行執行標記
- 遵循你在任務計畫中定義的 TDD 方法
- 提供進度更新並妥善處理錯誤

>[!IMPORTANT]
>AI agent 會執行本機命令列介面（Command Line Interface）指令（例如 `dotnet`、`npm` 等）——請確保你的機器已安裝所需工具。

實作完成後，請測試應用程式，並解決任何在命令列介面（Command Line Interface）日誌中未顯示的執行時錯誤（例如：瀏覽器主控台錯誤）。你可以將這些錯誤複製貼回 AI agent 以協助排除。

</details>

---

## 🔍 疑難排解

### Linux 上的 Git Credential Manager

如果你在 Linux 上遇到 Git 認證問題，可以安裝 Git Credential Manager：

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```

## 👥 維護者

- Den Delimarsky ([@localden](https://github.com/localden))
- John Lam ([@jflam](https://github.com/jflam))

## 💬 支援

如需支援，請開啟一個 [GitHub issue](https://github.com/github/spec-kit/issues/new)。我們歡迎錯誤回報、功能需求，以及關於如何使用 Spec-Driven Development 方法論 的問題。

## 🙏 致謝

本專案深受 [John Lam](https://github.com/jflam) 的研究與工作影響與啟發。

## 📄 授權

本專案依據 MIT 開源授權條款發佈。完整條款請參閱 [LICENSE](./LICENSE) 檔案。
