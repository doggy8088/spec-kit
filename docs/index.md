<div class="landing-hero">

<img class="landing-hero-logo" src="images/spec-kit-logo.webp" alt="" width="120" height="120">

<h1 id="github-spec-kit"><span class="h-word-1">GitHub</span> <span class="h-word-2">Spec</span> <span class="h-word-3">Kit</span></h1>

**以規格打造、修正錯誤，或評估構想，交給你的程式代理。**

Spec Kit 為程式代理提供結構化流程，讓意圖與證據優先於實作。從規格驅動開發（SDD）、錯誤修正或構想評估開始。逐步執行流程、將其自動化，或[塑造屬於自己的流程](how-to/customization.md)，包含軟體開發以外的流程。

<a href="installation.md" class="btn btn-primary btn-lg">安裝 Spec Kit</a>&nbsp;
<a href="#選擇你的流程" class="btn btn-outline-primary btn-lg">選擇你的流程</a>

</div>

---

## 選擇你的流程

| 需求 | 從這裡開始 | 你將獲得 | 命令參考 |
| --- | --- | --- | --- |
| 打造功能或應用程式 | [規格驅動開發](quickstart.md) | 一份貫穿計畫、實作與收斂的規格 | [代理式 SDD](reference/agentic-sdd.md) |
| 診斷並修復異常行為 | [錯誤修正](guides/bugfix.md) | 經評估的原因、範圍明確的修復與記錄的驗證 | [代理式錯誤修正](reference/agentic-bugfix.md) |
| 決定構想是否值得投入 | [構想評估](guides/assessment.md) | 有證據支持的繼續、釐清或停止決策 | [代理式構想評估](reference/agentic-assessment.md) |

這些是各自獨立的切入點，不是必經的階段。SDD 隨核心提供。
錯誤修正與評估是隨附的選擇性擴充功能。評估可獨立運作；決定繼續並不會自動開始實作。

請參閱 [Spec Kit 專案如何執行其代理式 SDLC](guides/agentic-sdlc.md)
以及其在何處使用 Spec Kit 本身。

要將 Spec Kit 加入既有程式碼庫？請從
[existing-project guide](how-to/existing-projects.md).

## Specify CLI

Specify CLI（`specify`）可初始化專案並管理整合、擴充功能、預設集、工作流程、工作流程步驟與套件組。`/speckit.specify` 等流程命令是在程式代理內執行，而非在終端機；各代理的語法請見[命令呼叫](integrations/cli.md#命令呼叫方式)，引數、成品與品質閘門請見上述命令參考。

| 共用能力 | 參考 |
| --- | --- |
| 初始化專案、檢查已安裝工具、檢視版本與系統資訊 | [核心命令](overview/core.md) |
| 透過實驗性本機 stdio 伺服器向 MCP 客戶端公開受支援的 Specify 操作 | [MCP 伺服器](overview/mcp.md) |
| 檢視可見的命令、範本、指令碼與勾點，包含勝出與隱藏的組合層 | [成品](overview/artifacts.md) |
| 透過內建、社群或私人型錄探索元件，並了解來源優先順序與信任 | [型錄](overview/catalogs.md) |

---

<div class="pillar-grid">

<div class="pillar-card">

### 預設即規格驅動

核心 SDD 流程開箱即用：**Specify → Plan → Tasks → Implement → Converge**。

在打造之前先定義要打造什麼。豐富的範本、品質檢核清單與跨產出物分析皆開箱即用。每個階段產生一份 Markdown 產出物，作為下一階段的輸入，讓 AI 程式代理獲得結構化脈絡，而不是臨時提示詞。

<a href="quickstart.md" class="pillar-link">導覽工作流程 →</a>

</div>

<div class="pillar-card">

### 使用任何程式代理

<span class="pillar-stat">43 integration options</span> — 41 個程式代理整合，加上 `generic` 適用其他工具、`none` 適用與代理無關的鷹架。選擇 Copilot、Gemini、Codex、Kilo Code、Zed、Claude、Forge、Kiro 等。以單一命令在代理之間自由切換。無綁定。

以你選擇的代理執行 `specify init`，Spec Kit 會自動設定正確的命令檔案與目錄結構。若你的代理未列於清單中，`generic` 整合可作為任何工具的備用方案。

<a href="integrations/index.md" class="pillar-link">查看所有整合 →</a>

</div>

<div class="pillar-card">

### 打造屬於自己的版本

<span class="pillar-stat">186 community extensions</span>、<span class="pillar-stat">42 community presets</span>，且持續成長。以預設集調整核心流程、以擴充功能擴展流程、以工作流程協調流程，並將一切打包為可分享的套件組，或完全取代流程。流程本身就存在於這些建構區塊中，因此你永遠不會被綁在 SDD，甚至不會被綁在軟體上。

探索社群流程、整合與品質閘門：

- **[Product Forge](https://github.com/VaiYav/speckit-product-forge)** — 產品生命週期協調，從研究到發佈就緒
- **[Architecture Guard](https://github.com/DyanGalih/architecture-guard)** — 架構漂移偵測與治理
- **[DocGuard](https://github.com/raccioly/docguard)** — 文件完整性、追溯性與生命週期檢查
- **[Quality Gates](https://github.com/schwichtgit/spec-gates)** — 在代理、Git 與 CI 邊界的政策驅動檢查
- **[Epic](https://github.com/pmckeown/spec-kit-epic)** — 將大型計畫拆解為有序、協調的功能
- **[Linear Weave](https://github.com/tonydwoodhouse/spec-kit-linear-weave)** — 以 Linear 連結需求、任務與狀態

除了軟體之外，[**小說寫作預設集**](https://github.com/adaumann/speckit-preset-fiction-book-writing)支援小說與長篇小說創作，從故事聖經到投稿。

特別介紹這些獨立維護的社群專案並非稽核或背書。安裝與使用前請先檢閱其原始碼。

<a href="presets/overview.md" class="pillar-link">Presets →</a>&nbsp;&nbsp;
<a href="extensions/overview.md" class="pillar-link">Extensions →</a>&nbsp;&nbsp;
<a href="workflows/overview.md" class="pillar-link">Workflows →</a>&nbsp;&nbsp;
<a href="workflow-steps/overview.md" class="pillar-link">Workflow Steps →</a>&nbsp;&nbsp;
<a href="bundles/overview.md" class="pillar-link">Bundles →</a>

</div>

<div class="pillar-card">

### 整合至你的組織

可在離線、防火牆後，以及 **Windows、macOS 與 Linux** 上運作。自行託管型錄，策展你的組織能探索與推薦的整合、擴充功能、預設集、工作流程與套件組。

像 Quality Gates 與 Architecture Guard 這類社群擴充功能，加入了符合團隊既有工作方式的政策檢查與治理。

<a href="install/air-gapped.md" class="pillar-link">企業版／氣隙環境 →</a>&nbsp;&nbsp;
<a href="overview/catalogs.md" class="pillar-link">Catalogs →</a>

</div>

</div>

---

<div class="community-section">

## 由社群打造

**320+ 位貢獻者**協助打造 Spec Kit。更廣大的社群打造了從整合到全新流程的一切。任何人都能建立並發佈擴充功能、預設集或工作流程。

<div class="stats-grid">
  <div class="stat-item">
    <span class="stat-number">147K+</span>
    <span class="stat-label">GitHub stars</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">320+</span>
    <span class="stat-label">Contributors</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">43</span>
    <span class="stat-label">Integration options</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">186</span>
    <span class="stat-label">Community extensions</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">42</span>
    <span class="stat-label">Community presets</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">11</span>
    <span class="stat-label">Friend projects</span>
  </div>
</div>

<a href="community/presets.md">預設集</a> · <a href="community/walkthroughs.md">實作導覽</a> · <a href="community/friends.md">Friends</a>

</div>

---

## 探索文件

<div class="nav-cards">
  <a href="guides/agentic-sdlc.md" class="nav-card">
    <strong>Spec Kit 的代理式 SDLC</strong>
    <span>此專案如何評估、打造、測試、交付與修復變更</span>
  </a>
  <a href="quickstart.md" class="nav-card">
    <strong>規格驅動開發</strong>
    <span>定義、規劃、實作功能並使其收斂</span>
  </a>
  <a href="guides/bugfix.md" class="nav-card">
    <strong>錯誤修正</strong>
    <span>評估原因、套用範圍明確的修復並驗證結果</span>
  </a>
  <a href="guides/assessment.md" class="nav-card">
    <strong>構想評估</strong>
    <span>研究構想並決定是否值得投入</span>
  </a>
  <a href="how-to/customization.md" class="nav-card">
    <strong>自訂或自帶流程</strong>
    <span>調整流程、加入能力，或打包以角色為基礎的設定</span>
  </a>
  <a href="how-to/existing-projects.md" class="nav-card">
    <strong>既有專案</strong>
    <span>在既有程式碼庫中安全採用 Spec Kit</span>
  </a>
  <a href="upgrade.md" class="nav-card">
    <strong>升級</strong>
    <span>讓既有 Spec Kit 專案在各 release 間保持最新</span>
  </a>
  <a href="overview/core.md" class="nav-card">
    <strong>核心命令</strong>
    <span>初始化專案、檢查工具、檢視版本與系統資訊</span>
  </a>
  <a href="community/overview.md" class="nav-card">
    <strong>社群</strong>
    <span>社群整合、擴充功能、預設集、工作流程、步驟、套件組與配套資源</span>
  </a>
  <a href="how-to/local-development.md" class="nav-card">
    <strong>本地開發</strong>
    <span>執行、除錯並檢查 Spec Kit 本身的變更</span>
  </a>
  <a href="how-to/index.md" class="nav-card">
    <strong>操作指南</strong>
    <span>了解 Spec Kit 實務並應用於你的專案工作</span>
  </a>
  <a href="overview/history.md" class="nav-card">
    <strong>歷史</strong>
    <span>Spec Kit 如何從 SDD 基礎成長為可擴充的流程框架</span>
  </a>
</div>

---

<div class="footer-cta">

```bash
uv tool install specify-cli
specify init my-project --integration copilot
```

準備好開始了嗎？[選擇你的流程](#選擇你的流程)。

</div>

## 另請參閱

每個元件都有各自的指南與管理參考：

| 元件 | 指南 | CLI 參考 |
| --- | --- | --- |
| 整合 | [代理設定與交付](integrations/index.md) | [整合管理](integrations/cli.md) |
| 擴充功能 | [加入能力、命令與勾點](extensions/overview.md) | [擴充功能管理](extensions/cli.md) |
| 預設集 | [自訂範本、命令與指令碼](presets/overview.md) | [預設集管理](presets/cli.md) |
| 工作流程 | [自動化可重複、可續跑的流程](workflows/overview.md) | [工作流程管理](workflows/cli.md) |
| 工作流程步驟 | [重複使用內建行為或開發自訂類型](workflow-steps/overview.md) | [步驟管理](workflow-steps/cli.md) |
| 套件組 | [安裝現有元件的版本化設定](bundles/overview.md) | [套件組管理](bundles/cli.md) |

若要使用私人型錄、下載與發佈檢查，請見[設定身分驗證](reference/authentication.md)。若要選擇哪些建構區塊符合需求，請見[自訂或自帶流程](how-to/customization.md)。

<p class="text-end small text-body-secondary">上次更新：2026 年 11 月 4 日</p>