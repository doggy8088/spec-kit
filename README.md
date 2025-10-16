<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快打造高品質軟體。</em></h3>
</div>

<p align="center">
    <strong>一個開源工具包，讓你專注於產品情境與可預測的成果，而不必每個部分都從零開始「憑感覺寫程式」。</strong>
</p>

<p align="center">
    <a href="https://github.com/github/spec-kit/actions/workflows/release.yml"><img src="https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg" alt="Release"/></a>
    <a href="https://github.com/github/spec-kit/stargazers"><img src="https://img.shields.io/github/stars/github/spec-kit?style=social" alt="GitHub stars"/></a>
    <a href="https://github.com/github/spec-kit/blob/main/LICENSE"><img src="https://img.shields.io/github/license/github/spec-kit" alt="License"/></a>
    <a href="https://github.github.io/spec-kit/"><img src="https://img.shields.io/badge/docs-GitHub_Pages-blue" alt="Documentation"/></a>
</p>

---

## 目錄

- [🤔 什麼是 Spec-Driven Development 方法論？](#-什麼是-spec-driven-development-方法論)
- [⚡ 快速開始](#-快速開始)
- [📽️ 影片總覽](#️-影片總覽)
- [🤖 支援的 AI agent](#-支援的-ai-agent)
- [🔧 Specify CLI 參考文件](#-specify-cli-參考說明)
- [📚 核心理念](#-核心理念)
- [🌟 開發階段](#-開發階段)
- [🎯 實驗目標](#-實驗目標)
- [🔧 先決條件](#-先決條件)
- [📖 深入了解](#-進一步了解)
- [📋 詳細流程](#-詳細流程)
- [🔍 疑難排解](#-疑難排解)
- [👥 維護者](#-專案維護者)
- [💬 支援](#-支援)
- [🙏 致謝](#-致謝)
- [📄 授權條款](#-授權)
## 🤔 什麼是 Spec-Driven Development 方法論？

Spec-Driven Development **顛覆了傳統軟體開發流程**。數十年來，程式碼一直是主角——而規格說明只是搭建完就丟棄的鷹架，一旦開始「真正的程式設計工作」就被拋諸腦後。Spec-Driven Development 方法論改變了這一點：**規格說明變成可執行的內容**，不再只是指引，而是能直接產生可運作的實作。

## ⚡ 快速開始

### 1. 安裝 Specify CLI

請選擇你偏好的安裝方式：

#### 選項 1：持久安裝（推薦）

只需安裝一次，隨處可用：

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

然後直接使用該工具：

```bash
specify init <PROJECT_NAME>
specify check
```

若要升級，請執行：

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
```

#### 選項 2：一次性使用 (One-time Usage)

可直接執行，無需安裝：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

**持久安裝的好處：**

- 該工具會持續安裝並可在 PATH 中使用
- 無需建立 shell 別名
- 透過 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 進行更好的工具管理
- 讓 shell 設定更乾淨

### 2. 建立專案原則

使用 **`/speckit.constitution`** 指令來建立您的專案憲章與開發指南，這將引導後續所有的開發工作。

```bash
/speckit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements
```

### 3. 建立規格

使用 **`/speckit.specify`** 指令來描述你想要建構的內容。請著重於**做什麼**以及**為什麼**，而非技術堆疊。

```bash
/speckit.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 4. 建立技術實作計畫

使用 **`/speckit.plan`** 指令，提供你的技術堆疊與架構選擇。

```bash
/speckit.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

### 5. 拆解為任務

使用 **`/speckit.tasks`** 根據你的實作計畫，建立可執行的任務清單。

```bash
/speckit.tasks
```

### 6. 執行實作

使用 **`/speckit.implement`** 來執行所有任務，並依照計劃建置你的功能。

```bash
/speckit.implement
```

如需詳細的逐步說明，請參閱我們的 [comprehensive guide](./spec-driven.md)。

## 📽️ 影片總覽

想看看 Spec Kit 的實際運作嗎？歡迎觀看我們的 [video overview](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)！

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
| [CodeBuddy CLI](https://www.codebuddy.ai/cli)             | ✅ |                                                   |
| [Roo Code](https://roocode.com/)                          | ✅ |                                                   |
| [Codex CLI](https://github.com/openai/codex)              | ✅ |                                                   |
| [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/) | ⚠️ | Amazon Q Developer CLI [does not support](https://github.com/aws/amazon-q-developer-cli/issues/3064) slash 指令的自訂參數。 |

## 🔧 Specify CLI 參考說明

`specify` 指令支援以下選項：

### 指令

| 指令     | 說明                                                    |
|-------------|----------------------------------------------------------------|
| `init`      | 以最新範本初始化新的 Specify 專案      |
| `check`     | 檢查已安裝的工具（`git`、`claude`、`gemini`、`code`/`code-insiders`、`cursor-agent`、`windsurf`、`qwen`、`opencode`、`codex`） |

### `specify init` 參數與選項

| 參數／選項        | 類型     | 說明                                                                  |
|------------------------|----------|------------------------------------------------------------------------------|
| `<project-name>`       | 參數 | 新專案目錄名稱（若使用 `--here` 可選填，或使用 `.` 於目前目錄建立） |
| `--ai`                 | 選項   | 指定要使用的 AI assistant：`claude`、`gemini`、`copilot`、`cursor-agent`、`qwen`、`opencode`、`codex`、`windsurf`、`kilocode`、`auggie`、`roo`、`codebuddy` 或 `q` |
| `--script`             | 選項   | 指定腳本類型：`sh`（bash/zsh）或 `ps`（PowerShell）                 |
| `--ignore-agent-tools` | 旗標     | 跳過 AI agent 工具（如 Claude Code）的檢查                             |
| `--no-git`             | 旗標     | 跳過 git repository 初始化                                          |
| `--here`               | 旗標     | 將專案初始化於目前目錄，而非建立新目錄   |
| `--force`              | 旗標     | 在目前目錄初始化時強制合併／覆寫（跳過確認） |
| `--skip-tls`           | 旗標     | 跳過 SSL/TLS 驗證（不建議）                                 |
| `--debug`              | 旗標     | 啟用詳細除錯輸出以便疑難排解                            |
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

執行 `specify init` 後，你的 AI 程式設計代理將能使用以下 Slash 指令，進行結構化開發：

#### 核心指令

Spec-Driven Development 方法論工作流程的基本指令：

| 指令                  | 說明                                                           |
|-----------------------|----------------------------------------------------------------|
| `/speckit.constitution`  | 建立或更新專案憲章與開發指南 |
| `/speckit.specify`       | 定義你想要建構的內容（需求與使用者故事）        |
| `/speckit.plan`          | 以你選擇的技術堆疊建立技術實作計畫     |
| `/speckit.tasks`         | 產生可執行的實作任務清單                     |
| `/speckit.implement`     | 執行所有任務，依照計畫建構功能         |

#### 選用指令

提升品質與驗證的額外指令：

| 指令              | 說明                                                           |
|-------------------|----------------------------------------------------------------|
| `/speckit.clarify`   | 釐清規格中未明確的區塊（建議於 `/speckit.plan` 前執行；前身為 `/quizme`） |
| `/speckit.analyze`   | 跨產物一致性與覆蓋率分析（於 `/speckit.tasks` 後、`/speckit.implement` 前執行） |
| `/speckit.checklist` | 產生自訂的品質檢查清單，驗證需求的完整性、清晰度與一致性（類似「英文的單元測試」） |

### 環境變數 (environment variables)

| 變數         | 說明                                                                                    |
|--------------|----------------------------------------------------------------------------------------|
| `SPECIFY_FEATURE` | 覆寫非 Git repository 的功能偵測。設定為功能目錄名稱（例如 `001-photo-albums`），即可在未使用 Git 分支時針對特定功能作業。<br/>**必須在你所操作的代理上下文中，於使用 `/speckit.plan` 或後續指令前先設定。 |

## 📚 核心理念

Spec-Driven Development 方法論是一套結構化流程，強調：

- **以意圖為導向的開發**，先以規格說明「做什麼」再決定「怎麼做」
- **豐富的規格說明**，結合防呆機制與組織原則
- **多步驟反覆精煉**，而非一次性從提示直接產生程式碼
- **高度依賴先進 AI 模型能力**，用於解讀規格說明

## 🌟 開發階段

| 階段 | 重點 | 主要活動 |
|------|------|----------|
| **0-to-1 開發**（Greenfield） | 從零開始產生 | <ul><li>從高層次需求開始</li><li>產生規格說明</li><li>規劃實作步驟</li><li>建構可上線的應用程式</li></ul> |
| **創意探索** | 平行實作 | <ul><li>探索多元解決方案</li><li>支援多種技術堆疊與架構</li><li>嘗試不同 UX 模式</li></ul> |
| **反覆增強**（Brownfield） | Brownfield 現代化 | <ul><li>逐步新增功能</li><li>現代化舊有系統</li><li>調整流程</li></ul> |

## 🎯 實驗目標

我們的研究與實驗聚焦於：

### 技術獨立性

- 使用多元技術堆疊建立應用程式
- 驗證 Spec-Driven Development 方法論是一種不受特定技術、程式語言或框架綁定的流程

### 企業級限制

- 展示任務關鍵型應用程式開發
- 納入組織層級限制（雲端服務商、技術堆疊、工程實踐）
- 支援企業設計系統與合規需求

### 以使用者為中心的開發

- 為不同用戶族群與偏好打造應用程式
- 支援多種開發方式（從 vibe-coding 到 AI 原生開發）

### 創意與反覆流程

- 驗證平行實作探索的概念
- 提供健全的反覆功能開發工作流程
- 延伸流程以處理升級與現代化任務

## 🔧 先決條件

- **Linux/macOS/Windows**
- [支援的](#-支援的-ai-agent)AI 程式設計代理
- [uv](https://docs.astral.sh/uv/) 套件管理工具
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

如果你在使用代理時遇到問題，請提交 issue 以便我們改進整合。

## 📖 進一步了解

- **[完整 Spec-Driven Development 方法論](./spec-driven.md)** - 深入了解完整流程
- **[詳細操作教學](#-詳細流程)** - 步驟式實作指南

---

## 📋 詳細流程

<details>
<summary>點擊展開詳細的逐步操作教學</summary>

你可以使用 Specify CLI 來快速建立專案，這將會在你的環境中帶入所需的產物。執行：

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

![Specify CLI 在終端機中初始化新專案](./media/specify_cli.gif)

系統會提示你選擇正在使用的 AI agent。你也可以直接在終端機中主動指定：

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

CLI 會檢查你是否已安裝 Claude Code、Gemini CLI、Cursor CLI、Qwen CLI、opencode、Codex CLI 或 Amazon Q Developer CLI。如果尚未安裝，或你希望直接取得模板而不檢查相關工具，請在指令中加入 `--ignore-agent-tools`：

```bash
specify init <project_name> --ai claude --ignore-agent-tools
```

### **步驟 1：** 建立專案原則

進入專案資料夾並執行你的 AI agent。在本範例中，我們使用的是 `claude`。

![Bootstrapping Claude Code environment](./media/bootstrap-claude-code.gif)

如果你看到 `/speckit.constitution`、`/speckit.specify`、`/speckit.plan`、`/speckit.tasks` 和 `/speckit.implement` 指令可用，表示設定正確。

第一步應該是使用 `/speckit.constitution` 指令來建立你的專案治理原則（project’s governing principles）。這有助於確保在後續所有開發階段中，決策能保持一致性：

```text
/speckit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements. Include governance for how these principles should guide technical decisions and implementation choices.
```

這個步驟會建立或更新 `.specify/memory/constitution.md` 檔案，內容包含你的專案基礎指引，AI agent 會在規格說明、規劃與實作階段參考這些指引。

### **步驟 2：** 建立專案規格說明

在你已經建立好專案原則後，現在可以開始撰寫功能規格說明。請使用 `/speckit.specify` 指令，並提供你想開發專案的具體需求。

>[!IMPORTANT]
>請盡可能明確說明你想要建構的「內容」以及「原因」。**此階段請勿聚焦於技術堆疊。**

範例提示：

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

在輸入此提示後，你應該會看到 Claude Code 啟動規劃與規格草擬流程。Claude Code 也會觸發部分內建腳本來設定 repository。

完成這個步驟後，你應該會有一個新建立的分支（例如：`001-create-taskify`），以及一份新的規格說明，位於 `specs/001-create-taskify` 目錄中。

產生的規格說明應該包含一組使用者故事（user stories）與功能性需求（functional requirements），這些內容會依照範本所定義。

此時，你的專案資料夾內容應該會類似以下結構：

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

### **步驟 3：** 功能規格說明釐清（規劃前必須完成）

在建立基準規格說明後，您可以針對第一次嘗試時未正確捕捉到的需求進行釐清。

您應該在建立技術規劃之前，先執行結構化的釐清流程，以減少後續返工。

建議流程順序：
1. 使用 `/speckit.clarify`（結構化）—— 依序、以覆蓋率為基礎的提問，並將答案記錄於 Clarifications 區段。
2. 若仍有不明確之處，可選擇性地進行即席的自由格式細化。

如果您有意跳過釐清流程（例如：進行 spike 或探索性原型），請明確說明，讓代理不會因缺少釐清而中斷。

範例自由格式細化提示（若在 `/speckit.clarify` 後仍有需要）：

```text
For each sample project or project that you create there should be a variable number of tasks between 5 and 15
tasks for each one randomly distributed into different states of completion. Make sure that there's at least
one task in each stage of completion.
```

你也應該請 Claude Code 驗證 **Review & Acceptance Checklist**，將已驗證／通過需求的項目勾選，未通過的則保持未勾選。可以使用以下的用戶提示：

```text
Read the review and acceptance checklist, and check off each item in the checklist if the feature spec meets the criteria. Leave it empty if it does not.
```

與 Claude Code 的互動是一個釐清並詢問規格說明相關問題的好機會——**不要將其第一次嘗試視為最終版本**。

### **步驟 4：** 產生計畫

你現在可以明確指定技術堆疊及其他技術需求。你可以使用專案範本內建的 `/speckit.plan` 指令，並搭配如下提示語：

```text
We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use
Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API,
tasks API, and a notifications API.
```

此步驟的輸出將包含多份實作細節文件，您的目錄結構將會類似如下：

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

請檢查 `research.md` 文件，以確保根據你的指示所使用的技術堆疊（tech stack）正確無誤。如果其中有任何元件特別突出，你可以請 Claude Code 進行優化，甚至讓它檢查你想要使用的平台或框架（例如 .NET）的本地安裝版本。

此外，如果你選擇的技術堆疊屬於變化快速的領域（例如 .NET Aspire、JavaScript 框架），你也可以請 Claude Code 針對該技術堆疊進行細節研究，提示語可以像這樣：

```text
I want you to go through the implementation plan and implementation details, looking for areas that could
benefit from additional research as .NET Aspire is a rapidly changing library. For those areas that you identify that
require further research, I want you to update the research document with additional details about the specific
versions that we are going to be using in this Taskify application and spawn parallel research tasks to clarify
any details using research from the web.
```

在這個過程中，你可能會發現 Claude Code 會卡在研究錯誤的方向——你可以透過像這樣的用戶提示（user prompt）來協助引導它回到正確的方向：

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
>Claude Code 可能會過於積極，新增你未曾要求的元件。請要求它說明這些變更的理由及來源。

### **步驟 5：**讓 Claude Code 驗證計畫

當你已經擬定好計畫後，應該讓 Claude Code 依照計畫執行一遍，以確保沒有遺漏任何部分。你可以使用如下的用戶提示：

```text
Now I want you to go and audit the implementation plan and the implementation detail files.
Read through it with an eye on determining whether or not there is a sequence of tasks that you need
to be doing that are obvious from reading this. Because I don't know if there's enough here. For example,
when I look at the core implementation, it would be useful to reference the appropriate places in the implementation
details where it can find the information as it walks through each step in the core implementation or in the refinement.
```

這有助於細化實作計畫，並協助你避免 Claude Code 在規劃階段可能遺漏的潛在盲點。當初步細化完成後，請再次要求 Claude Code 根據檢查清單進行檢查，確認一切無誤後再進入實作階段。

如果你已安裝 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)，也可以請 Claude Code 直接從你目前的分支建立一個 Pull Request 到 `main`，並附上詳細說明，以確保整個流程都被妥善追蹤。

>[!NOTE]
>在讓代理執行實作前，也建議你提示 Claude Code 交叉檢查細節，確認是否有過度設計（請記住——它有時會過於積極）。如果發現有過度設計的元件或決策，你可以請 Claude Code 協助簡化。請確保 Claude Code 依循 [constitution](base/memory/constitution.md)，這是其制定計畫時必須遵循的基礎文件。

### **步驟 6：** 使用 /speckit.tasks 產生任務拆解

當實作計畫驗證無誤後，你可以將計畫拆解為具體且可執行的任務，並依正確順序執行。使用 `/speckit.tasks` 指令，根據你的實作計畫自動產生詳細的任務拆解：

```text
/speckit.tasks
```

此步驟會在你的功能規格說明目錄中建立一個 `tasks.md` 檔案，內容包含：

- **依使用者故事組織的任務拆解** — 每個使用者故事都會成為獨立的實作階段，並擁有自己的一組任務
- **相依性（dependency）管理** — 任務會依照元件間的相依性排序（例如：先建立 models，再建立 services，最後建立 endpoints）
- **平行執行標記** — 可以平行執行的任務會以 `[P]` 標記，以最佳化開發流程
- **檔案路徑規格** — 每個任務都會包含實作所需的精確檔案路徑
- **測試優先（Test-First）結構** — 若有要求測試，則會包含測試任務，並確保測試在實作前先撰寫
- **檢查點（checkpoints）驗證** — 每個使用者故事階段都包含檢查點，以驗證其獨立功能

產生的 tasks.md 為 `/speckit.implement` 指令提供明確的路線圖，確保系統化實作、維持程式碼品質，並可逐步交付使用者故事。

### **步驟 7：** 實作

準備好後，請使用 `/speckit.implement` 指令來執行你的實作計畫：

```text
/speckit.implement
```

`/speckit.implement` 指令將會：
- 驗證所有前置條件是否齊備（專案憲章、規格、計畫與任務）
- 解析來自 `tasks.md` 的任務分解
- 依正確順序執行任務，並遵循相依性（dependency）與平行執行標記
- 遵循你在任務計畫中定義的 TDD 方法
- 提供進度更新並妥善處理錯誤

>[!IMPORTANT]
>AI agent 會執行本地的 CLI 指令（例如 `dotnet`、`npm` 等）—請確保你已在本機安裝所需工具。

當實作完成後，請測試應用程式，並解決任何在 CLI 日誌中未顯示的執行時錯誤（例如瀏覽器主控台錯誤）。你可以將這類錯誤複製貼上回 AI agent 以協助解決。

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

## 👥 專案維護者

- Den Delimarsky ([@localden](https://github.com/localden))
- John Lam ([@jflam](https://github.com/jflam))

## 💬 支援

如需支援，請開啟 [GitHub issue](https://github.com/github/spec-kit/issues/new)。我們歡迎錯誤回報、功能需求以及關於如何使用 Spec-Driven Development 方法論的提問。

## 🙏 致謝

本專案深受 [John Lam](https://github.com/jflam) 的研究與成果影響與啟發。

## 📄 授權

本專案依 MIT 開源授權條款發布。完整條款請參閱 [LICENSE](./LICENSE) 檔案。

