# Spec Kit－2026 年 4 月電子報

本期涵蓋 Spec Kit 在 2026 年 4 月的動態。本月發佈了十七個版本（v0.4.4 至 v0.8.3），交付完整的整合外掛架構、工作流程引擎、預設集組合策略、整合型錄與完整文件。社群擴充型錄從 26 個條目成長三倍至 83 個，社群預設集從 2 個成長至 12 個，Spec Kit 也登上了 Thoughtworks Technology Radar。下表為摘要，其後為詳細內容。

| **Spec Kit 核心（2026 年 4 月）** | **社群與內容** | **SDD 生態系與下一步** |
| --- | --- | --- |
| 發佈了十七個版本，帶來重大功能：整合外掛架構、工作流程引擎、預設集組合、整合型錄、內建精簡預設集、文件網站，以及學術引用支援。新增三個代理（Forgecode、Goose、Devin for Terminal）。儲存庫從約 82k 顆星成長至 **92,038 顆星**。 [\[github.com\]](https://github.com/github/spec-kit/releases) | Thoughtworks Technology Radar 將 Spec Kit 放入「Assess」圈。社群型錄從 26 個成長至 **83 個擴充功能**，並從 2 個成長至 **12 個預設集**。開發者部落格與產業媒體的外部報導持續出現。XB Software 記錄了一個真實的舊系統專案。Fabián Silva 發佈了 Caramelo VS Code 擴充功能。 | Matt Rickard 主張「更小的規格、更嚴的檢查」。Will Torber 的三框架比較推薦大多數團隊使用 OpenSpec。「Spec Layer」之爭浮現：規格是 AI 代理的約束面。Spec Kit 在廣度與可攜性上領先；競爭者則以漂移偵測與編排深度做出區隔。 |

***

> **重要：** 4 月的發佈節奏超越了外部報導的速度。本月發表的大多數分析（Rickard 於 4 月 1 日、Thoughtworks Radar 於 4 月 15 日、XB Software 於 4 月 17 日、Torber 於 4 月 23 日）所評估的版本，都早於工作流程引擎（v0.7.0）、整合型錄（v0.7.2）、預設集組合（v0.8.0）與型錄探索 CLI（v0.8.3）。他們提出的儀式感與彈性疑慮，正是這些功能所要解決的——精簡預設集、可插拔工作流程、可組合預設集，以及 Conduct、MAQA、Fleet Orchestrator 等社群擴充功能，都已在預設 SDD 流程之外提供替代工作流程。我們期待看到後續評測如何將這些能力納入考量。

## Spec Kit 專案更新

### 版本總覽

**v0.4.4**（4 月 1 日）交付了**整合外掛架構**的第一階段——基礎類別、資訊清單系統，以及取代寫死代理鷹架的註冊表。它也將 Product Forge、Superpowers Bridge、MAQA 套件（7 個擴充功能）、Spec Kit Onboard 與 Plan Review Gate 加入社群型錄，修復了 npm 本機安裝的 Claude Code CLI 偵測，並為 `create-new-feature` 新增 `--allow-existing-branch`。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.4.4)

**v0.4.5**（4 月 2 日）以五個階段完成整合遷移：19 個代理的標準 Markdown 整合、TOML 整合（Gemini、Tabnine）、技能與通用整合，並移除舊鷹架路徑。它也將 Claude Code 安裝為原生技能，為 `create-new-feature` 新增 `--dry-run` 旗標，支援 4 位數以上的功能分支編號、Fix Findings 擴充功能，並將五個生命週期擴充功能加入社群型錄。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.4.5)

**v0.5.0**（4 月 2 日）是重大的封裝變更：**範本 zip 套件組從發佈中移除**，改由 CLI 本身處理所有鷹架建立。這確保了 CLI 與範本保持同步。它也推出了供貢獻者入門的 `DEVELOPMENT.md`。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.5.0)

**v0.5.1**（4 月 8 日）是一個大型修補版本。它新增了**內建 Git 擴充功能**（第 1 與第 2 階段），在所有核心命令上掛上 hook 並支援 `GIT_BRANCH_NAME` 覆寫；新增 **Forgecode** 代理支援；以及用於初始化後整合管理的 `specify integration` 子命令。Claude Code 命令新增了參數提示。許多社群擴充功能加入型錄（Confluence、Canon、Spec Diagram、Branch Convention、Spec Refine、FixIt、Optimize、Security Review），以及預設集（explicit-task-dependencies、toc-navigation、VS Code Ask Questions）。錯誤修復包括釘選 typer≥0.24.0／click≥8.2.1 以修復匯入當機、BSD 可攜的 sed 跳脫、Trae 代理修復、TOML frontmatter 剝除，以及避免含糊的 TOML 結尾引號。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.5.1)

**v0.6.0**（4 月 9 日）為新的整合架構重寫了 **AGENTS.md**，將 SpecKit Companion 加入 Community Friends，並把 Bugfix Workflow、Worktree Isolation 與 MemoryLint 帶入社群型錄。新的 multi-repo-branching 預設集也隨之登場。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.6.0)

**v0.6.1**（4 月 10 日）新增了**內建精簡預設集**，附一組最小工作流程命令——是完整 SDD 儀式之外較輕量的替代方案。它也將 **Cursor** 從 `.cursor/commands` 遷移至 `.cursor/skills`，並將 Brownfield Bootstrap、CI Guard、SpecTest、PR Bridge、TinySpec 與 Status Report 加入社群型錄。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.6.1)

**v0.6.2**（4 月 13 日）新增了 **Goose AI 代理**支援（YAML 式 recipe 格式）、GitHub Issues Integration 擴充功能，以及 What-if Analysis 擴充功能。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.6.2)

**v0.7.0**（4 月 14 日）交付了**帶型錄系統的工作流程引擎**，實現可插拔的多步驟工作流程定義。它新增了 SFSpeckit（Salesforce SDD）、Worktrees 擴充功能、供 gitflow 相容性使用的選用單段分支前綴，以及 claude-ask-questions 與 fiction-book-writing 預設集。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.7.0)

**v0.7.1**（4 月 15 日）在 `specify init` 上棄用了 `--ai` 旗標，改用 `--integration`；將 Windows 加入 CI 測試矩陣；修復了供 hook 執行的 Claude 技能串連；將 TESTING.md 合併至 CONTRIBUTING.md；並新增 Agent Assign 與 Architect Preview 擴充功能。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.7.1)

**v0.7.2**（4 月 16 日）交付了**整合型錄**，用於代理整合的探索、版本管理與社群散佈。它也帶來了大規模的**文件翻修**：核心命令、擴充功能、預設集、工作流程與整合的參考頁面加入 `docs/reference/`，README 的 CLI 章節也予以簡化。Issues 擴充功能與 Catalog CI 擴充功能加入社群型錄。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.7.2)

**v0.7.3**（4 月 17 日）以**標記式 upsert** 機制取代了以 shell 為基礎的上下文更新，消除了上下文檔案意外膨脹。它在文件網站新增了 **Community Friends 頁面**、Spec Scope 與 Blueprint 擴充功能，並在 README 中加入 Claude Code／Copilot CLI 外掛市集參考。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.7.3)

**v0.7.4**（4 月 21 日）新增了用於學術引用支援的 **CITATION.cff 與 .zenodo.json**。它推出了 Ripple（副作用偵測）、Spec Validate、Version Guard、Spec Reference Loader 與 Memory Loader 擴充功能。一項修復從代理上下文檔案中剝除了 UTF-8 BOM，Antigravity（agy）代理版面也遷移至 `.agents/`，並棄用了 `--skills`。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.7.4)

**v0.7.5**（4 月 22 日）新增了 `specify self check` 與 `self upgrade` stub、**預設集 wrap 策略**（與 prepend、append 並列，完成組合三部曲）、Red Team 對抗式審查擴充功能、Wireframe 擴充功能，以及命令寫入路徑的**目錄遍歷安全性修復**。技能佔位符解析擴展至所有 SKILL.md 代理。社群內容（導覽與預設集）從 README 移至文件網站。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.7.5)

**v0.8.0**（4 月 23 日）為範本、命令與指令稿交付了**預設集組合策略**（prepend、append、wrap）——讓預設集能將內容層疊在既有產物周圍。它也為 Copilot 新增了供技能式鷹架使用的 `--integration-options="--skills"`、`pipx` 作為替代安裝方式，以及 Memory MD 擴充功能。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.8.0)

**v0.8.1**（4 月 24 日）透過 `.specify/feature.json` 修復了自訂 git 分支上的 `/speckit.plan`，將 **Mistral Vibe** 整合遷移至 SkillsIntegration，新增 **Screenwriting** 與 **Jira** 預設集，並依整合類型解析命令參考格式（點號與連字號寫法）。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.8.1)

**v0.8.2**（4 月 28 日）為私人型錄與擴充功能下載推出了 **GITHUB_TOKEN／GH_TOKEN 驗證**，棄用了 `--no-git` 旗標（預定於 v0.10.0 移除），將文件中所有已棄用的 `--ai` 參考換成 `--integration`，並新增 MarkItDown Document Converter、Microsoft 365 Integration、Spec Orchestrator，以及附 RAG（Chroma DB）離線語意搜尋的 Fiction Book Writing v1.7 預設集。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.8.2)

**v0.8.3**（4 月 29 日）以**型錄探索 CLI 命令**（search、info、catalog list／add／remove）為本月收尾，支援 **Devin for Terminal** 作為技能式整合，修復 opencode 命令派送，並加入 OWASP LLM Threat Model、iSAQB Architecture Governance 與 Work IQ 擴充功能。升級提示也新增一項修復，避免使用者意外安裝 PyPI 搶註套件。 [\[github.com\]](https://github.com/github/spec-kit/releases/tag/v0.8.3)

### 架構與基礎設施亮點

4 月最重大的架構變更是**整合外掛架構**（v0.4.4–v0.4.5），以自描述整合類別的註冊表取代寫死的代理鷹架。每個代理現在都是 `src/specify_cli/integrations/<key>/` 下的獨立子套件，具備 Markdown、TOML、YAML 與 Skills 格式的基礎類別。這次六階段遷移觸及全部 28 個受支援的代理，並為整合型錄（v0.7.2）與社群散佈的整合奠定基礎。

**工作流程引擎**（v0.7.0）推出了以型錄為基礎的系統，支援可插拔的多步驟工作流程定義——超越固定的七步驟 SDD 序列。

**預設集組合策略**（v0.7.5／v0.8.0）以 prepend、append 與 wrap 模式完成了預設集系統。預設集現在能將內容層疊在既有範本、命令與指令稿周圍，而不只是取代它們。

**標記式上下文 upsert**（v0.7.3）取代了脆弱的 shell 式 sed 操作來更新代理上下文檔案，消除了一整類與上下文膨脹及編碼問題相關的錯誤。

**範本 zip 套件組被移除**（v0.5.0），將 CLI 與範本耦合成單一可散佈產物。

### 錯誤修復與安全性

最關鍵的修復是**阻擋命令寫入路徑中的目錄遍歷**（#2229，v0.7.5），避免了 CommandRegistrar 中潛在的路徑遍歷弱點。其他與安全相關的修復包括針對升級提示中 **PyPI 搶註套件**的防護（v0.8.3），以及為私人型錄下載新增 **GITHUB_TOKEN 驗證**（v0.8.2）。

值得注意的錯誤修復包括：typer／click 匯入當機（v0.5.1）、BSD 可攜的 sed 跳脫（v0.5.1）、從上下文檔案剝除 UTF-8 BOM（v0.7.4）、PowerShell 自動提交中的 CRLF 警告抑制（v0.7.3）、供 hook 使用的 Claude 技能串連（v0.7.1）、TOML 含糊結尾引號（v0.5.1），以及 `/speckit.plan` 的自訂分支支援（v0.8.1）。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 擴充功能與預設集生態系

社群擴充型錄在 4 月**成長三倍**，從 26 個條目成長至 **83 個條目**。新增了 59 個擴充功能，移除了 2 個（Cognitive Squad 與 Understanding，其儲存庫已不再可用）。社群預設集從 2 個成長至 **12 個條目**，新增了 10 個預設集。

依類別值得注意的新擴充功能：

- **專案管理**：GitHub Issues Integration（Fatima367、aaronrsun）、Spec Orchestrator（Quratulain-bilal）、Agent Assign（xuyang）、Status Report（Open-Agent-Tools）
- **品質與安全**：Red Team 對抗式審查（Ash Brener）、Security Review（DyanGalih）、Ripple 副作用偵測（chordpli）、Spec Validate（Ahmed Eltayeb）、CI Guard（Quratulain-bilal）、OWASP LLM Threat Model（NaviaSamal）
- **多代理與編排**：MAQA 套件，7 個擴充功能涵蓋多代理 QA、Jira、Azure DevOps、GitHub Projects、Linear 與 Trello 整合（GenieRobot）、Product Forge（VaiYav）
- **規格生命週期**：Spec Refine（Quratulain-bilal）、Bugfix Workflow（Quratulain-bilal）、Fix Findings（Quratulain-bilal）、Brownfield Bootstrap（Quratulain-bilal）、TinySpec（Quratulain-bilal）
- **開發者體驗**：Blueprint 程式碼審查（chordpli）、Confluence（aaronrsun）、MarkItDown Document Converter（BenBtg）、Microsoft 365 Integration（BenBtg）、Memory MD（DyanGalih）、Memory Loader（KevinBrown5280）、MemoryLint（RbBtSn0w）
- **領域專屬**：供 Salesforce 使用的 SFSpeckit（Sumanth Yanamala）、iSAQB Architecture Governance 預設集（Thorsten Hindermann）、Canon 以基線驅動的工作流程（Maxim Stupakov）
- **創意**：附 RAG／Chroma DB 支援的 Fiction Book Writing 預設集 v1.7（Andreas Daumann）、Screenwriting 預設集（Andreas Daumann）

值得注意的貢獻者 **Quratulain-bilal** 在本月貢獻了 15 個擴充功能，橫跨規格生命週期、工作流程管理與 CI/CD 整合。**GenieRobot** 貢獻了 7 個擴充功能的 MAQA 套件。**BenBtg** 同時貢獻了 MarkItDown 與 Microsoft 365 整合。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 文件翻修

4 月展開了全面的文件工作。**核心命令、擴充功能、預設集、工作流程與整合**的參考頁面在 `docs/reference/` 下建立。社群內容——**導覽、預設集與 Community Friends 頁面**——從 README 移至 `docs/community/`，在縮短 README 長度的同時提升可發現性。已棄用的 `--ai` 旗標參考在所有文件中換成 `--integration`。TESTING.md 合併至 CONTRIBUTING.md，並推出供貢獻者入門的 `DEVELOPMENT.md`。 [\[github.com\]](https://github.com/github/spec-kit/releases)

## 社群與內容

### Thoughtworks Technology Radar

**4 月 15 日**，**Thoughtworks Technology Radar 第 34 卷**將 GitHub Spec Kit 放入 Languages & Frameworks 類別的**「Assess」圈**。該條目指出，團隊回報其在 brownfield 專案中有價值，憲章能掌握專案範圍與架構，但也標示了潛在的**指令膨脹、上下文腐蝕與冗長的 markdown 輸出**等需要留意的疑慮。這是任何 SDD 專屬工具首次登上 Radar。 [\[thoughtworks.com\]](https://www.thoughtworks.com/radar/languages-and-frameworks/github-spec-kit)

### 開發者文章與部落格貼文

4 月出現了源源不絕的外部文章。

**Matt Rickard** 於 4 月 1 日發表 *「The Spec Layer: Why Spec-Driven Development (SDD) Works」*。他的論點是：規格降低了 AI 代理的執行自由度，發揮約束面的作用。他比較了 Spec Kit、Kiro、OpenSpec、Tessl、Intent 與 Symphony，並倡導**「更小的規格、更嚴的檢查、更少的猜測」**。 [\[blog.matt-rickard.com\]](https://blog.matt-rickard.com/p/the-spec-layer)

**Fabián Silva** 於 4 月 3 日在 DEV Community 發表 *「I Built a Visual Spec-Driven Development Extension for VS Code That Works With Any LLM」*。他的 **Caramelo** VS Code 擴充功能在 Spec Kit 的工作流程之上加入視覺化 UI、核准關卡、Jira 整合與多 LLM 支援，並讀寫標準的 `specs/` 目錄。 [\[dev.to\]](https://dev.to/fabian_silva_/i-built-a-visual-spec-driven-development-extension-for-vs-code-that-works-with-any-llm-36ok)

**James M** 於 4 月 4 日發表 *「GitHub Spec Kit in 2026: SDD Goes Mainstream」*，稱這次轉變是「從框架到平台」，並點出 Claude Code 原生技能、多代理支援與生態系的大幅成長。 [\[jamesm.blog\]](https://jamesm.blog/ai/github-spec-kit-2026-update/)

**Peter Saktor** 於 4 月 6 日在 DEV Community 發表詳細教學：*「GitHub Spec-Kit: From Vibe Coding to Spec-Driven Development」*，逐步走完完整的 7 步驟 SDD 工作流程，重構一個 Azure Container App，涵蓋 6 個階段、33 項任務。 [\[dev.to\]](https://dev.to/petersaktor/github-spec-kit-from-vibe-coding-to-spec-driven-development-1pgd)

**Codexplorer** 於 4 月 11 日在 Medium 發表 *「Spec Kit: GitHub's Answer to 'The AI Built the Wrong Thing Again'」*，將 Spec Kit 定位為翻轉了規格與程式碼的關係，並以 Go 程式碼範例涵蓋七個斜線命令。 [\[medium.com\]](https://codexplorer.medium.com/spec-kit-githubs-answer-to-the-ai-built-the-wrong-thing-again-22f122f142fb)

**XB Software** 於 4 月 17 日發表 *「Spec Kit on a Real Project: Implementation Experience in Large Legacy Code」*——一份將 SDD 應用於舊系統的實地報告。一項為期一週的任務以一半的時間完成。AI 浮現了隱藏的需求缺口。他們指出 API 整合是弱點、SDD 對小任務來說過於繁重，而且資深審查者仍然不可或缺。 [\[xbsoftware.com\]](https://xbsoftware.com/blog/ai-in-legacy-systems-spec-driven-development/)

**What IT Is** 於 4 月 21 日發表 *「Perspectives in Spec Driven Development」*，綜覽 SDD 格局（Spec Kit、Kiro、Tessl），並稱 Spec Kit 是「很好的入門點」。 [\[theitsolutionist.com\]](https://theitsolutionist.com/2026/04/21/perspectives-in-spec-driven-development/)

**Will Torber** 於 4 月 23 日在 DEV Community 發表 *「Spec Kit vs BMAD vs OpenSpec: Choosing an SDD Framework in 2026」*。他推薦 Spec Kit 用於 greenfield，但標示了 brownfield 的摩擦與每分支一份規格的限制，最終**推薦大多數團隊使用 OpenSpec**。 [\[dev.to\]](https://dev.to/willtorber/spec-kit-vs-bmad-vs-openspec-choosing-an-sdd-framework-in-2026-d3j)

**Truong Phung** 於 4 月 25 日在 DEV Community 發表 *「Spec Kit vs. Superpowers: A Comprehensive Comparison & Practical Guide to Combining Both」*——一篇 11 個章節的比較，提出混合作法：「Spec Kit 規劃 WHAT，Superpowers 控制 HOW」，並附逐步操作手冊。 [\[dev.to\]](https://dev.to/truongpx396/spec-kit-vs-superpowers-a-comprehensive-comparison-practical-guide-to-combining-both-52jj)

**Markus Wondrak** 於 4 月 26 日在 LinkedIn 發表 *「Re-evaluating GitHub's Spec Kit: Structured SDLC Automation」*，探討 Spec Kit 作為結構化 SDLC 自動化作法、需要在各階段邊界由人工審查的一面。 [\[linkedin.com\]](https://www.linkedin.com/pulse/re-evaluating-githubs-spec-kit-structured-sdlc-markus-wondrak-eewqf/)

**FintechExtra** 於 4 月 28 日發表了 v0.8.2 的事實性發佈說明摘要，點出已驗證的型錄下載、UTF-8 資訊清單修復，以及小說寫作預設集中的 Chroma DB 語意搜尋。 [\[fintechextra.com\]](https://www.fintechextra.com/news/github-spec-kit-v082-expands-catalog-support-and-tightens-cli-behavior-331)

### Community Friends 與工具

**SpecKit Companion** VS Code 擴充功能加入了 Community Friends 章節（v0.6.0）。一個由社群維護、供 **Claude Code 與 GitHub Copilot CLI** 使用、透過外掛市集安裝 Spec Kit 技能的外掛，在 README 中被引用（v0.7.3）。Fabián Silva 的 **Caramelo** VS Code 擴充功能展示了 SDD 的視覺化 UI 作法。 [\[github.com\]](https://github.com/github/spec-kit)

## SDD 生態系與產業趨勢

### 「Spec Layer」之爭

Matt Rickard 的「The Spec Layer」一文為 SDD 建立了新的框架：規格是降低 AI 代理執行自由度的**約束面**。他對六種 SDD 工具的比較主張更小、更聚焦的規格，搭配更嚴格的驗證檢查——有別於面面俱到的規格文件。這套框架在社群中引起共鳴，Thoughtworks Radar 條目與多篇比較文章都呼應了規格深度與實務開銷之間的張力。

### 競爭格局

**Will Torber** 的三框架比較（Spec Kit、BMAD、OpenSpec）**推薦大多數團隊使用 OpenSpec**，理由是儀式感較低且 brownfield 支援較好。**Truong Phung** 提議將 Spec Kit 與 **Superpowers**（Jesse Vincent）結合，形成「規劃 WHAT＋控制 HOW」的混合作法。這些比較反映了一個日趨成熟的市場：實務者會組合工具，而非只挑一種。

**Thoughtworks Radar** 的收錄肯定了 SDD 是值得追蹤的類別，但也標示了指令膨脹與上下文腐蝕等未解疑慮——與 Augment Code 在 3 月比較中提出的問題相同。XB Software 的實地報告在實務中證實了這一點：SDD 對複雜的舊系統工作有價值，但對小任務會帶來不必要的開銷。

Spec Kit 持續在 **GitHub 人氣**（92k 顆星）與**代理廣度**（29 個整合）上領先。市場持續沿幾條軸線分化：Spec Kit 以可攜性與生態系廣度取勝，Intent 以活規格與漂移偵測取勝，BMAD-METHOD 以多代理編排取勝，OpenSpec 則以簡單取勝。 [\[dev.to\]](https://dev.to/willtorber/spec-kit-vs-bmad-vs-openspec-choosing-an-sdd-framework-in-2026-d3j) [\[thoughtworks.com\]](https://www.thoughtworks.com/radar/languages-and-frameworks/github-spec-kit)

## 藍圖

未來開發中正在討論或進行中的領域：

- **規格生命週期管理**——上下文腐蝕與規格漂移仍是各篇文章中最常被提及的疑慮（Thoughtworks Radar、XB Software、Will Torber）。標記式 upsert（v0.7.3）處理了上下文檔案漂移；規格層級的漂移偵測仍是未解領域。Reconcile 與 Archive 擴充功能是社群朝這個方向邁出的步伐。 [\[thoughtworks.com\]](https://www.thoughtworks.com/radar/languages-and-frameworks/github-spec-kit)
- **工作流程自訂**——工作流程引擎（v0.7.0）與預設集組合策略（v0.8.0）提供了基礎。用於小說寫作、編劇、Jira 追蹤與架構治理的社群預設集，展示了標準 SDD 之外可能工作流程的廣度。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **型錄探索與散佈**——整合型錄（v0.7.2）與型錄探索 CLI（v0.8.3）讓 `specify` 更接近擴充功能、預設集與整合的套件管理員體驗。私人型錄驗證（v0.8.2）支援企業散佈。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **體驗簡化**——內建精簡預設集（v0.6.1）、`specify self check`（v0.7.5），以及棄用 `--ai` 改用 `--integration`（v0.7.1），反映了持續減少儀式感、改善入門體驗的工作。多篇外部文章（Torber、XB Software）指出 SDD 的開銷是一道門檻。 [\[dev.to\]](https://dev.to/willtorber/spec-kit-vs-bmad-vs-openspec-choosing-an-sdd-framework-in-2026-d3j)
- **跨平台與企業**——Windows CI（v0.7.1）、GITHUB_TOKEN 驗證（v0.8.2）、Salesforce 專屬擴充功能，以及 iSAQB 架構治理預設集，都顯示企業採用正在成長。 [\[github.com\]](https://github.com/github/spec-kit)
