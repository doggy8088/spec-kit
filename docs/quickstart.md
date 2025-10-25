# 快速入門指南

本指南將協助你使用 Spec Kit 開始進行 Spec-Driven Development 方法論。

> 新功能：所有自動化腳本現在皆提供 Bash (`.sh`) 與 PowerShell (`.ps1`) 兩種版本。`specify` 命令列介面 (CLI) 會根據作業系統自動選擇，除非你指定 `--script sh|ps`。

## 四步驟流程

### 1. 安裝 Specify

根據你所使用的 AI 程式設計代理，初始化你的專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

明確選擇腳本類型（可選）：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script ps  # Force PowerShell
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script sh  # Force POSIX shell
```

### 2. 建立規格說明

使用 `/speckit.specify` 指令來描述你想要建構的內容。請著重於**做什麼**以及**為什麼要做**，而不是技術堆疊。

```bash
/speckit.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 3. 建立技術實作計畫

使用 `/speckit.plan` 指令來提供你的技術堆疊與架構選擇。

```bash
/speckit.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

### 4. 拆解並實作

使用 `/speckit.tasks` 來建立可執行的任務清單，然後請你的 agent 實作該功能。

## 詳細範例：打造 Taskify

以下是一個建立團隊生產力平台的完整範例：

### 步驟 1：使用 `/speckit.specify` 定義需求

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

### 步驟 2：細化規格說明

在初步規格說明建立後，請釐清任何遺漏的需求：

```text
For each sample project or project that you create there should be a variable number of tasks between 5 and 15
tasks for each one randomly distributed into different states of completion. Make sure that there's at least
one task in each stage of completion.
```

同時請驗證規格說明檢查清單：

```text
Read the review and acceptance checklist, and check off each item in the checklist if the feature spec meets the criteria. Leave it empty if it does not.
```

### 步驟 3：使用 `/speckit.plan` 產生技術計畫

請明確說明您的技術堆疊（tech stack）與技術需求：

```text
We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use
Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API,
tasks API, and a notifications API.
```

### 步驟 4：驗證與實作

讓你的 AI agent 審核實作計畫：

```text
Now I want you to go and audit the implementation plan and the implementation detail files.
Read through it with an eye on determining whether or not there is a sequence of tasks that you need
to be doing that are obvious from reading this. Because I don't know if there's enough here.
```

最後，實作解決方案：

```text
implement specs/002-create-taskify/plan.md
```

## 主要原則

- **明確說明**你正在建構什麼以及原因
- 在規格說明階段**不要聚焦於技術堆疊**
- 在實作前**反覆修正與完善**你的規格說明
- 在開始撰寫程式碼前**驗證**計畫
- **讓 AI agent 處理**實作細節

## 下一步

- 閱讀完整的 Spec-Driven Development 方法論以獲得深入指引
- 在 repository 中查看更多範例
- 前往 GitHub 探索原始碼
