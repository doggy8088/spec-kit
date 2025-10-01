<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快打造高品質軟體。</em></h3>
</div>

<p align="center">
    <strong>透過 Spec-Driven Development，協助組織專注於產品情境，而非重複撰寫無差異化的程式碼。</strong>
</p>

[![Release](https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg)](https://github.com/github/spec-kit/actions/workflows/release.yml)

---

## 目錄

- [🤔 什麼是 Spec-Driven Development？](#-what-is-spec-driven-development)
- [⚡ 快速開始](#-get-started)
- [📽️ 影片總覽](#️-影片概覽)
- [🤖 支援的 AI Agent](#-supported-ai-agents)
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

Spec-Driven Development **顛覆了**傳統軟體開發的思維。數十年來，程式碼一直是主角——規格僅僅是我們搭建並在「真正開始寫程式」後就丟棄的鷹架。Spec-Driven Development 則不同：**規格本身可以執行**，直接產生可運作的實作，而不只是作為參考指引。

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

#### 選項 2：一次性使用

可直接執行，無需安裝：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

**持久安裝的好處：**

- 工具會持續安裝並可在 PATH 中使用
- 無需建立 shell 別名
- 透過 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 提供更好的工具管理
- 讓 shell 設定更乾淨

### 2. 建立專案原則

使用 **`/constitution`** 指令來建立您的專案治理原則與開發指引，這將引導後續所有的開發工作。

```bash
/constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements
```

### 3. 建立規格說明

使用 **`/specify`** 指令來描述你想要建構的內容。請著重於**做什麼**以及**為什麼要做**，而不是技術堆疊。

```bash
/specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 4. 建立技術實作計畫

使用 **`/plan`** 指令來提供您的技術堆疊與架構選擇。

```bash
/plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

### 5. 拆解為任務

使用 **`/tasks`** 從你的實作計畫中建立可執行的任務清單。

```bash
/tasks
```

### 6. 執行實作

使用 **`/implement`** 來執行所有任務，並依照計劃建置你的功能。

```bash
/implement
```

如需詳細的逐步說明，請參閱我們的[完整指南](./spec-driven.md)。

## 📽️ 影片概覽

想看看 Spec Kit 的實際運作嗎？歡迎觀看我們的[影片概覽](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)！

[![Spec Kit video header](/media/spec-kit-video-header.jpg)](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)

## 🤖 支援的 AI Agent

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
| [Roo Code](https://roocode.com/)                          | ✅ |                                                   |
| [Codex CLI](https://github.com/openai/codex)              | ⚠️ | Codex [不支援](https://github.com/openai/codex/issues/2890) slash 指令的自訂參數。  |

## 🔧 Specify CLI 參考說明

`specify` 指令支援以下選項：

### 指令

| 指令     | 說明                                                    |
|-------------|----------------------------------------------------------------|
| `init`      | 以最新範本初始化一個新的 Specify 專案      |
| `check`     | 檢查已安裝的工具（`git`、`claude`、`gemini`、`code`/`code-insiders`、`cursor-agent`、`windsurf`、`qwen`、`opencode`、`codex`） |

### `specify init` 參數與選項

| 參數/選項        | 類型     | 說明                                                                  |
|------------------------|----------|------------------------------------------------------------------------------|
| `<project-name>`       | 參數 | 新專案目錄名稱（若使用 `--here` 可選填，或使用 `.` 於目前目錄） |
| `--ai`                 | 選項   | 要使用的 AI 助理：`claude`、`gemini`、`copilot`、`cursor`、`qwen`、`opencode`、`codex`、`windsurf`、`kilocode`、`auggie` 或 `roo` |
| `--script`             | 選項   | 指定腳本類型：`sh`（bash/zsh）或 `ps`（PowerShell）                 |
| `--ignore-agent-tools` | 旗標     | 略過對 Claude Code 等 AI agent 工具的檢查                             |
| `--no-git`             | 旗標     | 略過 git 儲存庫初始化                                          |
| `--here`               | 旗標     | 於目前目錄初始化專案，而非建立新目錄   |
| `--force`              | 旗標     | 在目前目錄初始化時強制合併/覆蓋（略過確認提示） |
| `--skip-tls`           | 旗標     | 略過 SSL/TLS 驗證（不建議）                                 |
| `--debug`              | 旗標     | 啟用詳細除錯輸出以利問題排查                            |
| `--github-token`       | 選項   | 用於 API 請求的 GitHub token（或設定 GH_TOKEN/GITHUB_TOKEN 環境變數）  |

### 範例

```bash
# Basic project initialization
specify init my-project

# Initialize with specific AI assistant
specify init my-project --ai claude

# Initialize with Cursor support
specify init my-project --ai cursor

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

執行 `specify init` 後，你的 AI 程式碼代理人將能使用以下這些結構化開發的 slash 指令：

| 指令            | 說明                                                                    |
|-----------------|-------------------------------------------------------------------------|
| `/constitution` | 建立或更新專案治理原則與開發指引                           |
| `/specify`      | 定義你想要建構的內容（需求與使用者故事）                |
| `/clarify`      | 釐清未明確定義的區域（必須在執行 `/plan` 前執行，除非明確跳過；前身為 `/quizme`） |
| `/plan`         | 以你選擇的技術棧建立技術實作計畫                    |
| `/tasks`        | 產生可執行的實作任務清單                             |
| `/analyze`      | 跨產物一致性與覆蓋率分析（於 /tasks 後、/implement 前執行） |
| `/implement`    | 執行所有任務，依照計畫建構功能                         |

### 環境變數

| 變數            | 說明                                                                                           |
|------------------|------------------------------------------------------------------------------------------------|
| `SPECIFY_FEATURE` | 覆寫非 Git 儲存庫的功能偵測。設定為功能目錄名稱（例如 `001-photo-albums`），即可在未使用 Git 分支時針對特定功能進行作業。<br/>**必須在你操作的代理人上下文中於使用 `/plan` 或後續指令前設定。 |

## 📚 核心理念

Spec-Driven Development（規格驅動開發）是一套強調以下重點的結構化流程：

- **以意圖為導向的開發**，先定義「_做什麼_」再決定「_怎麼做_」
- **豐富的規格產出**，結合防呆機制與組織原則
- **多步驟精煉**，而非單次提示就產生程式碼
- **高度依賴** 進階 AI 模型能力來解讀規格

## 🌟 開發階段

| 階段 | 重點 | 主要活動 |
|-------|-------|----------------|
| **0-to-1 開發**（「Greenfield」） | 從零開始產生 | <ul><li>從高階需求出發</li><li>產生規格</li><li>規劃實作步驟</li><li>建構可上線的應用程式</li></ul> |
| **創意探索** | 平行實作 | <ul><li>探索多元解決方案</li><li>支援多種技術棧與架構</li><li>嘗試不同 UX 模式</li></ul> |
| **漸進式強化**（「Brownfield」） | Brownfield 現代化 | <ul><li>逐步新增功能</li><li>現代化舊有系統</li><li>調整流程</li></ul> |

## 🎯 實驗目標

我們的研究與實驗聚焦於：

### 技術獨立性

- 使用多元技術棧建立應用程式
- 驗證 Spec-Driven Development 是一種不受特定技術、程式語言或框架綁定的流程

### 企業級限制

- 展示關鍵任務應用程式的開發能力
- 納入組織層級限制（雲端服務商、技術棧、工程實踐）
- 支援企業設計系統與合規需求

### 以使用者為中心的開發

- 為不同使用者族群與偏好建構應用程式
- 支援多種開發方式（從 vibe-coding 到 AI 原生開發）

### 創意與迭代流程

- 驗證平行實作探索的概念
- 提供健全的迭代式功能開發工作流程
- 延伸流程以支援升級與現代化任務

## 🔧 先決條件

- **Linux/macOS**（或 Windows 上的 WSL2）
- AI 程式碼代理人：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[Gemini CLI](https://github.com/google-gemini/gemini-cli)、[Cursor](https://cursor.sh/)、[Qwen CLI](https://github.com/QwenLM/qwen-code)、[opencode](https://opencode.ai/)、[Codex CLI](https://github.com/openai/codex) 或 [Windsurf](https://windsurf.com/)
- [uv](https://docs.astral.sh/uv/) 套件管理工具
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

若你在使用代理人時遇到問題，請提交 issue 讓我們能持續優化整合體驗。

## 📖 深入了解

- **[完整 Spec-Driven Development 方法論](./spec-driven.md)** - 深入探討完整流程
- **[詳細操作教學](#-detailed-process)** - 步驟式實作指南

---

## 📋 詳細流程

<details>
<summary>點擊展開詳細的逐步操作教學</summary>

你可以使用 Specify CLI 來初始化你的專案，這會自動引入所需的產物到你的環境。執行：

```bash
specify init <project_name>
```

或者在目前目錄中初始化：

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

系統會提示你選擇所使用的 AI agent。你也可以直接在終端機中主動指定：

```bash
specify init <project_name> --ai claude
specify init <project_name> --ai gemini
specify init <project_name> --ai copilot
specify init <project_name> --ai cursor
specify init <project_name> --ai qwen
specify init <project_name> --ai opencode
specify init <project_name> --ai codex
specify init <project_name> --ai windsurf
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

此命令列介面 (Command Line Interface, CLI) 會檢查您是否已安裝 Claude Code、Gemini CLI、Cursor CLI、Qwen CLI、opencode 或 Codex CLI。如果尚未安裝，或您希望在不檢查相關工具的情況下直接取得範本，請在指令中加入 `--ignore-agent-tools`：

```bash
specify init <project_name> --ai claude --ignore-agent-tools
```

### **步驟 1：** 建立專案原則

進入專案資料夾並執行你的 AI agent。在本範例中，我們使用的是 `claude`。

![Bootstrapping Claude Code environment](./media/bootstrap-claude-code.gif)

當你看到 `/constitution`、`/specify`、`/plan`、`/tasks` 和 `/implement` 指令可用時，代表一切已正確設定。

第一步應該是使用 `/constitution` 指令來建立專案的治理原則。這有助於確保在後續所有開發階段中能夠維持一致的決策：

```text
/constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements. Include governance for how these principles should guide technical decisions and implementation choices.
```

此步驟會建立或更新`.specify/memory/constitution.md`檔案，內容包含您的專案基礎指引，AI agent 將在規格制定、規劃與實作階段參考這些指引。

### **步驟 2：** 建立專案規格

在您已經建立專案原則後，現在可以開始撰寫功能規格。請使用`/specify`指令，並提供您想開發專案的具體需求。

>[!IMPORTANT]
>請盡可能明確說明您想要建構的「內容」以及「原因」。**此階段請勿著重於技術堆疊（tech stack）**。

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

在輸入此提示後，您應該會看到 Claude Code 開始進行規劃與規格草擬流程。Claude Code 也會觸發部分內建腳本來設定這個儲存庫。

完成這個步驟後，您應該會有一個新建立的分支（例如：`001-create-taskify`），以及在 `specs/001-create-taskify` 目錄下新增的規格文件。

產生的規格文件應包含一組使用者故事與功能需求，這些內容會依照範本所定義。

在這個階段，您的專案資料夾內容應會類似以下結構：

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

### **步驟 3：** 功能規格澄清（規劃前必須完成）

在建立基準規格後，您可以進一步釐清在首次嘗試時未能正確捕捉到的任何需求。

您應該在制定技術規劃**之前**，執行結構化的澄清流程，以減少後續返工的情況。

建議順序如下：
1. 使用 `/clarify`（結構化）—— 依序、以覆蓋率為導向的提問，並將答案記錄於 Clarifications（澄清事項）區段。
2. 若仍有不明確之處，可選擇性地進行臨時的自由格式細化。

如果您有意跳過澄清步驟（例如：進行 spike 或探索性原型開發），請明確說明，以避免代理程式因缺少澄清而中斷流程。

範例自由格式細化提示（若在 `/clarify` 後仍有需要）：

```text
For each sample project or project that you create there should be a variable number of tasks between 5 and 15
tasks for each one randomly distributed into different states of completion. Make sure that there's at least
one task in each stage of completion.
```

你也應該請 Claude Code 驗證 **Review & Acceptance Checklist**（審查與驗收清單），將已驗證／通過要求的項目勾選，未通過的則保持未勾選狀態。可以使用以下提示詞：

```text
Read the review and acceptance checklist, and check off each item in the checklist if the feature spec meets the criteria. Leave it empty if it does not.
```

與 Claude Code 的互動是一個釐清與詢問規格問題的好機會——**請不要將其第一次嘗試視為最終結果**。

### **步驟 4：** 產生計畫

你現在可以明確指定技術堆疊（tech stack）及其他技術需求。你可以使用專案範本中內建的 `/plan` 指令，搭配如下提示語：

```text
We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use
Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API,
tasks API, and a notifications API.
```

此步驟的輸出將包含多份實作細節文件，您的目錄樹將會類似如下所示：

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

請參閱 `research.md` 文件，以確保根據您的指示所使用的技術堆疊（tech stack）正確無誤。若有任何元件特別突出，您可以請 Claude Code 進行優化，甚至讓它檢查您想使用的平台或框架（例如 .NET）在本地安裝的版本。

此外，如果所選技術堆疊屬於快速變動的領域（例如 .NET Aspire、JavaScript 框架），您也可以請 Claude Code 進一步研究相關細節，建議使用如下提示語：

```text
I want you to go through the implementation plan and implementation details, looking for areas that could
benefit from additional research as .NET Aspire is a rapidly changing library. For those areas that you identify that
require further research, I want you to update the research document with additional details about the specific
versions that we are going to be using in this Taskify application and spawn parallel research tasks to clarify
any details using research from the web.
```

在這個過程中，你可能會發現 Claude Code 正在研究錯誤的內容——你可以透過像這樣的提示，協助它朝正確的方向前進：

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
>Claude Code 可能會過於積極，新增你未要求的元件。請要求它說明這些變更的理由及來源。

### **步驟 5：**讓 Claude Code 驗證方案

當方案擬定完成後，建議讓 Claude Code 依照計畫執行一次，以確保沒有遺漏任何部分。你可以使用如下提示詞：

```text
Now I want you to go and audit the implementation plan and the implementation detail files.
Read through it with an eye on determining whether or not there is a sequence of tasks that you need
to be doing that are obvious from reading this. Because I don't know if there's enough here. For example,
when I look at the core implementation, it would be useful to reference the appropriate places in the implementation
details where it can find the information as it walks through each step in the core implementation or in the refinement.
```

這有助於進一步完善實作計畫，並協助你避免 Claude Code 在規劃階段可能遺漏的潛在盲點。完成初步的細化流程後，請再次要求 Claude Code 依照檢查清單進行檢查，確認無誤後再進入實作階段。

如果你已安裝 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)，也可以請 Claude Code 直接從你目前的分支建立一個 pull request 到 `main`，並附上詳細說明，以確保整個流程都有被妥善追蹤。

>[!NOTE]
>在讓 agent 實作之前，也建議你提示 Claude Code 交叉檢查細節，確認是否有過度設計（請記得——它有時會過於積極）。如果發現有過度設計的元件或決策，可以請 Claude Code 協助調整。請確保 Claude Code 依循 [constitution](base/memory/constitution.md) 作為規劃時必須遵守的基礎原則。

### STEP 6: Implementation

準備就緒後，請使用 `/implement` 指令來執行你的實作計畫：

```text
/implement
```

`/implement` 指令將會：
- 驗證所有必要條件是否齊全（constitution、spec、plan 以及 tasks）
- 解析來自 `tasks.md` 的任務分解
- 按照正確的順序執行任務，並遵循依賴關係及平行執行標記
- 遵循你在任務計畫中定義的 TDD（測試驅動開發）方法
- 提供進度更新並妥善處理錯誤

>[!IMPORTANT]
>AI agent 會執行本機命令列介面（Command Line Interface）指令（例如 `dotnet`、`npm` 等）—請確保你的機器上已安裝所需工具。

當實作完成後，請測試應用程式，並解決任何在命令列介面（Command Line Interface）日誌中未顯示的執行時錯誤（例如瀏覽器主控台錯誤）。你可以將這些錯誤複製貼上回 AI agent 以協助排解。

</details>

---

## 🔍 疑難排解

### Linux 上的 Git Credential Manager

如果你在 Linux 上遇到 Git 認證相關問題，可以安裝 Git Credential Manager：

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

如需支援，請在 [GitHub issue](https://github.com/github/spec-kit/issues/new) 提出。我們歡迎錯誤回報、功能需求，以及關於 Spec-Driven Development 的使用問題。

## 🙏 致謝

本專案深受 [John Lam](https://github.com/jflam) 的研究與成果影響與啟發。

## 📄 授權

本專案採用 MIT 開源授權條款。完整條款請參閱 [LICENSE](./LICENSE) 檔案。
