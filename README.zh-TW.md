<div align="center">
    <img src="https://raw.githubusercontent.com/github/spec-kit/main/media/logo_large.webp" alt="Spec Kit 標誌" width="200" height="200"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>帶著規格來開發、修好一個錯誤，或評估一個想法——與你的程式代理一起。</em></h3>
</div>

<p align="center">
    <a href="https://github.com/github/spec-kit/releases/latest"><img src="https://img.shields.io/github/v/release/github/spec-kit" alt="最新版本"/></a>
    <a href="https://github.com/github/spec-kit/stargazers"><img src="https://img.shields.io/github/stars/github/spec-kit?style=social" alt="GitHub stars"/></a>
    <a href="https://github.com/github/spec-kit/blob/main/LICENSE"><img src="https://img.shields.io/github/license/github/spec-kit" alt="授權"/></a>
    <a href="https://github.github.io/spec-kit/"><img src="https://img.shields.io/badge/docs-GitHub_Pages-blue" alt="文件"/></a>
</p>

<p align="center">
    <a href="./README.md">English</a> ·
    <a href="./README.zh-CN.md">简体中文</a> ·
    <strong>繁體中文</strong> ·
    <a href="./README.ja.md">日本語</a> ·
    <a href="./README.ko.md">한국어</a>
</p>

Spec Kit 是一套開源工具組，為 AI 程式代理提供結構化的
流程、可重用的範本，以及有記錄的成果。你可以從現成的
流程開始，將它客製化，或帶來你自己的流程。

## 選擇你的流程

| 你的需求 | 流程 | 成果 |
| --- | --- | --- |
| 開發一個功能或應用程式 | [規格驅動開發](#spec-driven-development) | 一份貫穿規劃、實作與收斂的規格 |
| 診斷並修復損壞的行為 | [錯誤修正](#bug-fixing) | 經評估的原因、範圍明確的修正，以及記錄下來的驗證 |
| 決定一個想法是否值得投入 | [想法評估](#idea-assessment) | 有證據支持的 go、釐清或停止決定 |
| 採用或建立一套不同的流程 | [你自己的流程](#capabilities) | 從可重用的原語調整或組裝而成的流程 |

這些是各自獨立的入口，不是必經的階段。SDD 隨核心一同提供；
錯誤修正與評估是套件組形式的擴充功能，需要時再安裝，而
下方的原語能讓你採用或建立其他流程。

## 功能總覽

Spec Kit 把現成的流程與可組合的機制結合在一起：

| 功能 | Spec Kit 機制 |
| --- | --- |
| 連接程式代理，或在它們之間切換 | [整合](https://github.github.io/spec-kit/integrations/index.html) |
| 新增一個命令、品質關卡或完整的流程 | [擴充功能](https://github.github.io/spec-kit/reference/extensions.html) |
| 把流程連接到外部工具或服務 | [擴充功能](https://github.github.io/spec-kit/reference/extensions.html) |
| 對程式代理的生命週期事件做出反應 | [擴充功能執行期事件](https://github.github.io/spec-kit/reference/extensions.html#extension-runtime-events) |
| 在 Spec Kit 命令之前或之後執行擴充功能命令 | [擴充功能掛鉤](https://github.github.io/spec-kit/reference/extensions.html#project-extension-and-hook-configuration) |
| 調整範本、命令、術語或方法論 | [預設集](https://github.github.io/spec-kit/reference/presets.html) |
| 強制執行組織或法規標準 | [預設集](https://github.github.io/spec-kit/reference/presets.html) |
| 為單一專案覆寫某個範本 | [專案本機覆寫](https://github.github.io/spec-kit/guides/customization.html#project-local-overrides-and-resolution) |
| 自動化提示詞、命令、關卡與 shell 任務 | [工作流程](https://github.github.io/spec-kit/reference/workflows.html) |
| 修改已安裝的工作流程而不 fork 它 | [工作流程覆疊](https://github.github.io/spec-kit/reference/workflows.html#workflow-overlays) |
| 為工作流程加入可重用的可執行行為 | [工作流程步驟](https://github.github.io/spec-kit/reference/workflows.html#custom-step-packages) |
| 為某個角色或團隊安裝精選的設定 | [套件組](https://github.github.io/spec-kit/reference/bundles.html) |
| 探索社群元件 | [目錄](https://github.github.io/spec-kit/reference/catalogs.html) |
| 代管一份核准元件的私有目錄 | [目錄](https://github.github.io/spec-kit/reference/catalogs.html) |
| 存取私有目錄與元件下載 | [驗證](https://github.github.io/spec-kit/reference/authentication.html) |
| 在離線或防火牆後工作 | [本機來源與自架目錄](https://github.github.io/spec-kit/install/air-gapped.html) |
| 檢查某個命令、範本或指令碼是由哪一層提供的 | [資產清單](https://github.github.io/spec-kit/reference/artifacts.html) |

用 `specify extension search`、
`specify preset search`、`specify workflow search` 與 `specify bundle search` 等命令搜尋目前啟用的目錄。
Spec Kit 內含社群目錄，組織也可以加入自己的
精選來源。目錄中的列表不是稽核或背書，因此在安裝或執行社群原始碼之前，
請先審查它。

<a id="-get-started"></a>
<a id="-prerequisites"></a>

## 開始使用

你需要 Python 3.11+、[uv](https://github.github.io/spec-kit/install/uv.html)，
以及一個在 Linux、macOS 或 Windows 上受支援的 AI 程式代理。

在終端機中執行這些命令來安裝 Spec Kit 並建立專案。
這個範例使用 GitHub Copilot。

```bash
uv tool install specify-cli
specify init my-project --integration copilot
cd my-project
```

<a id="-supported-ai-coding-agent-integrations"></a>

安裝 Specify CLI 並建立專案之後，在專案目錄中啟動你的程式
代理，然後從下方選擇一個流程。

其他設定方式：

- [安裝](https://github.github.io/spec-kit/installation.html)：釘選的版本、其他安裝方式、CI 與疑難排解。
- [既有專案](https://github.github.io/spec-kit/guides/existing-projects.html)：從你已經擁有的程式碼開始。
- [其他代理](https://github.github.io/spec-kit/integrations/index.html)：整合鍵與[叫用語法](https://github.github.io/spec-kit/integrations/cli.html#command-invocation)。
- [升級](https://github.github.io/spec-kit/upgrade.html)：更新既有的安裝。

<a id="-what-is-spec-driven-development"></a>
<a id="sdd-quickstart"></a>

## 規格驅動開發

先定義要開發什麼、為什麼，然後把規格轉化為計畫、任務，
以及能運作的程式碼。

最小流程如下所示。每個專案建立一次憲章，
其餘步驟則為每個功能重複進行。這些技能要在代理的
對話中執行，而不是在終端機中；一次執行一個，在繼續之前先審查每個結果。

這個範例使用 GitHub Copilot 的預設技能語法。若使用其他代理，
請使用它[對等的叫用語法](https://github.github.io/spec-kit/integrations/cli.html#command-invocation)。

```text
/speckit-constitution Create principles focused on code quality, testing, and maintainability.
/speckit-specify Build a photo organizer with albums grouped by date and a tile preview of each album.
/speckit-plan Use Vite with vanilla JavaScript. Keep images local and store metadata in SQLite.
/speckit-tasks
/speckit-implement
/speckit-converge
```

重複實作與收斂，直到收斂報告顯示 `Converged`。
關於釐清、檢核清單與一致性分析，請參閱 SDD 導覽。

[SDD 導覽](https://github.github.io/spec-kit/quickstart.html) ·
[命令參考](https://github.github.io/spec-kit/reference/agentic-sdd.html)

<a id="-bug-fixing-with-spec-kit"></a>
<a id="bug-fix-quickstart"></a>

## 錯誤修正

評估原因、修正錯誤，並驗證原始症狀已經解決。
不需要先跑 SDD 功能工作流程。

在終端機中、從專案目錄安裝錯誤修正擴充功能：

```bash
specify extension add bug
```

這些技能要在代理的對話中執行，而不是在終端機中；一次執行一個，
在繼續之前先審查每個結果。

這個範例使用 GitHub Copilot 的預設技能語法。若使用其他代理，
請使用它[對等的叫用語法](https://github.github.io/spec-kit/integrations/cli.html#command-invocation)。

```text
/speckit-bug-assess "Submitting an empty password crashes the login form." slug=login-crash
/speckit-bug-fix slug=login-crash
/speckit-bug-test slug=login-crash
```

審查 `.specify/bugs/login-crash/` 中的報告。最終裁決為
`verified`、`partial` 或 `failed`；只有 `verified` 才確認修正成功。

[錯誤修正導覽](https://github.github.io/spec-kit/guides/bugfix.html) ·
[命令參考](https://github.github.io/spec-kit/reference/agentic-bugfix.html)

<a id="-assessing-ideas-with-spec-kit"></a>
<a id="idea-assessment-quickstart"></a>

## 想法評估

蒐集證據，決定一個想法是否值得推進。
不需要原始碼或 SDD 功能工作流程。

在終端機中、從專案目錄安裝評估擴充功能：

```bash
specify extension add assess
```

這些技能要在代理的對話中執行，而不是在終端機中；一次執行一個，
在繼續之前先審查每個結果。

這個範例使用 GitHub Copilot 的預設技能語法。若使用其他代理，
請使用它[對等的叫用語法](https://github.github.io/spec-kit/integrations/cli.html#command-invocation)。

```text
/speckit-assess-intake "Let users work offline and sync when they reconnect." slug=offline-mode
/speckit-assess-research slug=offline-mode
/speckit-assess-define slug=offline-mode
/speckit-assess-shape slug=offline-mode
/speckit-assess-decide slug=offline-mode
```

審查 `.specify/assessments/offline-mode/` 中的產出物與最終
決定：`go`、`needs-clarification` 或 `kill`。遇到未知事項時，直接編輯
既有的 Markdown 產出物來解決（親自編輯或與你的代理一起），而不是
重跑整個階段。如果你決定以 `go` 決議來開發一個軟體想法，
視需要先建立專案憲章，然後把 `decision.md` 中的交接摘要
傳給 `/speckit-specify`。帶著有記錄的原因停下來，同樣是
有用的成果。

[評估導覽](https://github.github.io/spec-kit/guides/assessment.html) ·
[命令參考](https://github.github.io/spec-kit/reference/agentic-assessment.html)

<a id="-making-spec-kit-your-own-extensions--presets"></a>
<a id="-bundles-role-based-setups"></a>
<a id="-community"></a>

## 客製化，或帶來你自己的流程

把規格驅動開發、錯誤修正或想法評估客製化，以符合你
團隊的標準。或者完全不採用它們，帶來你自己的流程。
組合[上方的功能](#capabilities)來達成你的目標：

- 用預設集調整既有流程，例如要求計畫具備法規可追溯性。一次性的範本變更則使用專案本機覆寫。
- 帶來你自己的流程：透過擴充功能加入它的命令，再透過整合把它們呈現給你的程式代理。
- 在工作流程中自動化命令與檢查。使用覆疊來調整已安裝的工作流程而不 fork 它，或在內建類型不足時加入自訂的工作流程步驟。
- 把可重用的設定分享出去：把它的擴充功能、預設集、工作流程與工作流程步驟打包成套件組。

從能滿足需求的最小變更開始；你不需要
取代整個流程。

[客製化指南](https://github.github.io/spec-kit/guides/customization.html) ·
[社群元件與導覽](https://github.github.io/spec-kit/community/overview.html)

<a id="-specify-cli-reference"></a>
<a id="available-slash-commands"></a>
<a id="-learn-more"></a>
<a id="-core-philosophy"></a>
<a id="-development-phases"></a>
<a id="-experimental-goals"></a>
<a id="-does-spec-kit-use-spec-kit"></a>

## 文件

- [CLI 參考](https://github.github.io/spec-kit/reference/overview.html) 與 [流程命令](https://github.github.io/spec-kit/reference/agentic-sdd.html#command-overview)
- [SDD 哲學](https://github.github.io/spec-kit/concepts/sdd.html)、[完整方法論](./spec-driven.md)，以及[演進既有規格](https://github.github.io/spec-kit/guides/evolving-specs.html)
- [專案歷史](https://github.github.io/spec-kit/history.html)
- [Spec Kit 如何使用 Spec Kit](./CONTRIBUTING.md#does-spec-kit-use-spec-kit)

## 媒體報導

- [Open Source Friday: Spec Kit Part 2](https://www.youtube.com/watch?v=8hHCpNVLhmI)（2026 年 10 月 16 日）——Manfred Riem 與 Nicole Haugen 討論 Spec Kit 1.0 與擴充後的工具組。
- [Open Source Friday with Spec Kit](https://www.youtube.com/watch?v=2IArMAhkJcE)（2026 年 5 月 8 日）——與 Manfred Riem 一起介紹並示範 SDD。

## 星星歷史

<p align="center">
    <a href="https://www.star-history.com/#github/spec-kit&Date">
        <picture>
            <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=github%2Fspec-kit&type=Date&theme=dark"/>
            <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=github%2Fspec-kit&type=Date"/>
            <img src="https://api.star-history.com/svg?repos=github%2Fspec-kit&type=Date" alt="Spec Kit 星星歷史圖表"/>
        </picture>
    </a>
</p>

<p align="center">
    <em>感謝每一位讓 Spec Kit 閃耀的人。</em>
</p>

<a id="-support"></a>

## 支援與貢獻

[回報錯誤或請求功能](https://github.com/github/spec-kit/issues/new) ·
[貢獻指南](./CONTRIBUTING.md) · [行為準則](./CODE_OF_CONDUCT.md)

<a id="-license"></a>

Spec Kit 採用 [MIT 授權](./LICENSE)。
