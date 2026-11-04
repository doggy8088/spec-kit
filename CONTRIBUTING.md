# 為 Spec Kit 做出貢獻

你好！我們很高興你想為 Spec Kit 做出貢獻。對這個專案的貢獻會依[專案的開源授權](LICENSE)[釋出](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)給公眾。

請注意，本專案釋出時附有[貢獻者行為準則](CODE_OF_CONDUCT.md)。參與本專案，即表示你同意遵守其條款。

## 執行與測試程式碼的先決條件

以下是一次性的安裝需求，讓你能在提交拉取請求（PR）的過程中，在本機測試你的變更。

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
1. 安裝 [uv](https://docs.astral.sh/uv/) 進行套件管理
1. 安裝 [Git](https://git-scm.com/downloads)
1. 準備一個可用的 [AI 程式代理](https://github.github.io/spec-kit/integrations/index.html)

<details>
<summary><b>💡 如果你使用 <code>VSCode</code> 或 <code>GitHub Codespaces</code> 作為 IDE 的小提示</b></summary>

<br>

只要你的機器上安裝了 [Docker](https://docker.com)，你就能透過這個 [VSCode 擴充功能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)運用 [Dev Containers](https://containers.dev)，輕鬆設定好你的開發環境，上述工具都已預先安裝並設定完成，這要歸功於位於專案根目錄的 `.devcontainer/devcontainer.json` 檔案。

做法很簡單：

- 簽出這個儲存庫
- 用 VSCode 開啟它
- 開啟[命令面板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette)，選擇 "Dev Containers: Open Folder in Container..."

在 [GitHub Codespaces](https://github.com/features/codespaces) 上甚至更簡單，因為它在開啟 codespace 時會自動運用 `.devcontainer/devcontainer.json`。

</details>

## 提交拉取請求

> [!NOTE]
> 如果你的拉取請求引入了對 CLI 或儲存庫其餘部分的工作有實質影響的大型變更（例如你引入了新的範本、參數或其他重大變更），請確保它已事先經過專案維護者的**討論並達成共識**。未經事先對話與同意的大型變更拉取請求將被關閉。

1. Fork 並複製這個儲存庫
1. 設定並安裝相依性：`uv sync --extra test`
1. 確認 CLI 在你的機器上能運作：`uv run specify --help`
1. 建立一個新分支（見下方的[分支命名](#branch-naming)）
1. 進行你的變更、新增測試，並確保一切仍然運作
1. 如有相關，用一個範例專案測試 CLI 功能
1. 推送到你的 fork 並提交拉取請求
1. 等待你的拉取請求被審查並合併。

啟用專案的虛擬環境（見下方的[測試設定](#testing-setup)），然後從你的工作樹安裝 CLI（在 `uv sync --extra test` 之後執行 `uv pip install -e .`），或以其他方式確保 shell 使用本機的 `specify` 執行檔，再執行下方所述的手動斜線命令測試。

以下幾件事能提高你的拉取請求被接受的可能性：

- 遵循專案的程式碼慣例。
- 為新功能撰寫測試。
- 如果你的變更影響面向使用者的功能，更新文件（`README.md`、`spec-driven.md`）。
- 讓你的變更盡可能聚焦。如果有多項你想進行、但彼此不相依的變更，考慮把它們拆成各自獨立的拉取請求。
- 撰寫一則[好的提交訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 用規格驅動開發工作流程測試你的變更，確保相容性。

擁有三個開啟中拉取請求的帳號仍可繼續提交變更，但額外的提交在審查佇列中，可能會被排在其他作者的貢獻之後。程式代理在開啟另一個拉取請求之前，必須遵循[由代理撰寫的 PR 規則](#agent-authored-git-and-review-activity)。

### 整合的拉取請求

新增或更新整合時，請遵循[整合交付邊界](design/integration.md#integration-delivery-boundary)。
把整合專屬的行為保留在
它自己的套件中；註冊表接線、型錄中繼資料、整合專屬的測試、
文件，以及代理專屬的 devcontainer 工具，都可以在同一個
PR 中隨它一起提交，即使這些檔案位於整合套件之外。

如果整合需要變更共用的執行期行為、整合
基底類別、渲染、生命週期管理、CLI 行為，或核心範本
或指令碼，請提交**至少兩個 PR**：一個給前置的共用行為，
一個給整合本身。前置 PR 必須在[證據關卡](#evidence-gate)之下獨立為該共用變更提出理由，並遵循
[測試確定性行為](#testing-deterministic-behavior)，包括
錯誤修正的迴歸證據。它必須在沒有新整合的情況下也能運作並可測試
；把代理專屬的變通做法搬進核心，並不能為它提供理由。

在整合 PR 中指出前置 PR，並在合併
整合 PR 之前先合併它們。整合套件之外、僅用於
接線或記錄該整合的變更，本身並不要求拆分。

### 證據關卡

一份貢獻的評價取決於它所攜帶的證據，而不是它的推理聽起來多有道理。同一套標準適用於所有人——人類與 AI 協助的貢獻受到完全相同的評判。

一個有效且在範圍內的變更，即使沒有證據也不會被直接拒絕。它可能被標記為 [`triage-can-wait`](#triage-and-author-labels)，並排在已證明的工作之後，直到證據補齊為止，屆時它可以被重新排定優先順序。

什麼算作證據：

- **一份重現步驟或連結的真實世界回報**——一個失敗案例、一段堆疊追蹤，或一個問題實際發生過的議題連結。僅憑「理論上這可能會失敗」的推理，無法通過這道關卡。
- **一個在 `main` 上失敗、套用你的變更後通過的迴歸測試**——這同時證明了問題是真的，以及你的變更修好了它。
- **範圍紀律**——每個拉取請求只處理一個關注點。把不相關的變更拆成各自獨立的 PR（見上方[聚焦變更的指引](#submitting-a-pull-request)）；龐雜蔓延的批次差異難以審查，也很慢才能落地。
- **揭露 AI 協助**——如果有任何 AI 工具參與，依 [Spec Kit 中的 AI 貢獻](#ai-contributions-in-spec-kit)揭露它與其參與程度。

臆測性的強化很受歡迎，但它排在已證明、有證據支持的工作之後。如果你能附上一份重現步驟和一個失敗的測試，你的變更會移到最前面；如果還不行，就明說，它會被排入佇列而不是被關閉。

### 審查評分標準

經過分類的項目會在七個維度上衡量，每個維度計 `0`–`2` 分（`0` 缺席、`1` 部分、`2` 明顯展示），最高分為 14 分。這個分數引導**優先順序**——它不是一道硬性的通過／不通過關卡。唯一堅定的規則是上方的[證據關卡](#evidence-gate)：只有理論、沒有證據的變更會被降低優先順序。

| 維度 | 它衡量的內容 |
|---|---|
| D1 — 真實世界證據 | 一份重現步驟或連結的回報，與只有理論的對比 |
| D2 — 可達性／嚴重程度 | 問題是否真的會被碰到，以及它有多嚴重 |
| D3 — 範圍紀律 | 每個 PR 一個聚焦的關注點，沒有不相關的變更 |
| D4 — 測試證據 | 一個在 `main` 上失敗、套用變更後通過的迴歸測試 |
| D5 — 揭露／理解 | 揭露 AI 的使用，且作者理解這項變更 |
| D6 — 成本與效益 | 交付的價值，相對於增加的複雜度與維護成本 |
| D7 — 與產品藍圖的對齊 | 與 Spec Kit 的目標與方向的契合程度 |

### 分類與作者標籤

每個經過分類的項目都會得到一個**裁決**標籤，記錄它目前的狀態。**作者**標籤則指出讓項目向前推進所需採取的具體行動。

裁決（每個項目一個）：

| 標籤 | 意義 |
|---|---|
| `triage-must-have` | 裁決：對 Spec Kit 而言是高價值、重要的工作——優先處理 |
| `triage-nice-to-have` | 裁決：有證據支持的修正，或已獲准的功能——審查後落地 |
| `triage-can-wait` | 裁決：有效且在範圍內，但優先順序較低；被擋在證據關卡之後 |
| `triage-out-of-scope` | 裁決：不會進入核心——無效、重複、偏離使命，或改由擴充功能承接 |

作者行動：

| 標籤 | 意義 |
|---|---|
| `author-needs-proof` | 問題尚未被展示——提供一份重現步驟，或一個在 `main` 上失敗、套用變更後通過的測試 |
| `author-needs-tests` | 變更本身是真的，但缺少迴歸測試——補上一個修正前失敗／修正後通過的測試 |
| `author-needs-rescope` | 差異過於龐雜蔓延或混雜多件事——拆成一個聚焦、單一關注點的 PR |
| `author-needs-disclosure` | AI 協助未被揭露——依 CONTRIBUTING 揭露 AI 的使用 |
| `author-needs-info` | 缺少評估所需的細節——提供所要求的資訊 |
| `author-needs-rebase` | 分支與 `main` 衝突——rebase 並解決衝突後才能合併 |
| `author-over-cap` | 超過 3 個開啟中 PR 的上限，或重複的批次提交——請整合 |
| `author-awaiting` | 正在等待作者回應（交由既有的 stale 工作流程處理） |

有些拉取請求會以 `triage-out-of-scope` 被關閉，而不是被合併——最常見的情況是
同一項變更已經在 `main` 裡了、某個請求更適合作為社群
擴充功能、既有功能已經涵蓋了它，或型錄變更是以直接編輯的方式送進來、
而不是透過提交議題。關閉時總是會附上一則說明原因的留言，
並在相關時指出應該改往何處。

關於這道關卡背後思維的進一步閱讀，請參閱[一位維護者對 AI 來源貢獻的看法](https://blog.manorrock.com/blog/2026/09/08/spec_kit_ai_source.html)。那篇文章是個人觀點，不是專案政策——政策就是此處所記錄的內容。

### 社群型錄提交

若要新增或更新型錄中的社群擴充功能、預設集、套件組或工作流程步驟，請**開啟一個
`[Extension]` / `[Preset]` / `[Bundle]` / `[Workflow Step]` 提交議題**——不要在拉取
請求中直接編輯 `extensions/catalog.community.json`（或預設集／套件組／步驟型錄）。
開啟表單會套用 `triage-must-have` 的收件裁決，但
不會啟動驗證。在分類期間，維護者會套用該元件的提交
標籤（工作流程步驟為 `workflow-step-submission`），以啟動自動化工作流程。
它會驗證版本中繼資料、釘選的下載 URL 與摘要；驗證
成功後會提出一份草稿型錄 PR，供維護者審查。
手動編輯的型錄 PR 會繞過這套驗證，並將被關閉，同時附上指回
議題流程的說明。

這同樣適用於**新項目、版本更新與修復**——版本提升或
修復損壞的項目仍然是一次更新，需要相同的驗證。永遠要把
`download_url` 釘選到一個版本標籤（例如 `.../releases/download/<tag>/...` 或
`.../archive/refs/tags/<tag>.zip`）；絕不要使用 `releases/latest/`。
工作流程步驟的提交仍需要一個釘選的封存 `download_url`，作為版本
出處，以及作者直接以封存安裝測試的證據。型錄
安裝使用的是另外的、依標籤釘選的個別檔案 URL 與逐檔摘要；
請參閱 [Community Workflow Step Types](docs/community/workflow-steps.md)。

### 外部代理轉接器

外部整合轉接宿主的命令與擴充功能／預設集
貢獻；它們不重新散布核心的命令清單。請發佈一個
帶有根目錄 `integration.yml` 與 `__init__.py` 的獨立套件，然後在型錄中宣傳
它釘選的封存 URL，最好再附上它的 SHA-256。註冊一個
型錄只會啟用探索／下載；匯入可執行的轉接器程式碼
需要使用者的信任決定，以及一個啟用安裝的來源。請遵循
[整合 API 與生命週期設計](design/integration.md#external-adapter-package-contract)
與[整合型錄貢獻指南](docs/integrations/contributing.md)。
加上走公開路徑的正向與負向測試，而不是把測試類別直接注入
註冊表；並附上新行程載入與回滾的證據。

### 分支命名

當議題存在時，把分支命名為 `<type>/<issue-number>-<short-slug>`。
對於沒有議題、僅有 PR 的變更，改用 `<type>/<short-slug>`。
從以下選項中選擇前綴：

| 前綴 | 使用時機 | 範例 |
|---|---|---|
| `feat/` | 新功能 | `feat/2342-workflow-cli-alignment` |
| `fix/` | 錯誤修正 | `fix/2653-paths-only-validation` |
| `docs/` | 文件變更 | `docs/2677-branch-naming-convention` |
| `community/` | 社群型錄新增 | `community/2492-add-mde-extension` |
| `chore/` | 維護、工具、CI | `chore/2366-editorconfig` |

把既有議題的編號緊放在前綴之後，讓分支
可被追溯；對於僅有 PR 的變更，不要事後再加上 PR 編號。短 slug 要保持
簡短、具描述性，並使用 kebab-case。

## 開發工作流程

### Spec Kit 有使用 Spec Kit 嗎？

有——我們在開發 Spec Kit 的同時也親自使用 Spec Kit（dogfood），尤其是用於實質的
功能以及開發工作流程的變更。貢獻者被要求透過規格驅動開發命令測試
相關的變更。目前的
[功能評估工作流程](https://github.com/github/spec-kit/blob/main/.github/workflows/feature-assess.md)
是自動化的 dogfooding 路徑：它的設定使用目前簽出版本的 CLI 來初始化 Copilot 並安裝 `assess` 擴充功能，之後
Copilot 會依產生的評估技能，針對功能請求進行評估。
其他代理工作流程目前獨立於 Specify CLI 之外運作。

這不意味著每個變更都要走完完整的工作流程。小型的修正可以
使用一般的議題、拉取請求、審查與測試流程。Dogfooding 的
鷹架與產出物，位於 `.github/agents/`、`.github/prompts/`、
`.github/copilot-instructions.md`、`.grok/`、`.specify/` 與 `specs/` 之下，
是刻意被 gitignore 的。自動化評估工作流程是暫時性的，
既不提交也不推送它產生的 Copilot 技能，因此它的輸出不會
進入儲存庫的歷史紀錄。

### 工作流程期望

在 spec-kit 上工作時：

1. 在你選擇的程式代理中，用 `specify` CLI 命令（`/speckit.specify`、`/speckit.plan`、`/speckit.tasks`）測試變更
2. 驗證 `templates/` 目錄中的範本運作正確
3. 測試 `scripts/` 目錄中的指令碼功能
4. 如果有重大的流程變更，確保記憶檔案（`memory/constitution.md`）有被更新

### 測試確定性行為

對於儲存庫維護的程式碼或設定的行為變更——也就是那些不經 LLM 就能執行或
控制執行的部分——需要同時為預期行為
（正向案例）與相關的無效輸入、失敗或被阻止的行為
（負向案例）撰寫測試。這包括 CLI 中的 Python、shell 與 PowerShell 程式碼、
核心指令碼、擴充功能、預設集與工具；工作流程步驟類型；以及
執行接線，例如指令碼的選擇、工作流程的 shell 步驟與 CI 的 `run:`
步驟。當既有測試已涵蓋變更的行為時，它們也算數。

對於儲存庫維護或產生的 PowerShell
功能的行為變更，必須附上來自 Windows PowerShell 5.1 的證據，或可重現的
能展示 5.1 相容性的證據。儲存庫中的所有 PowerShell 指令碼
以及所有產生的 PowerShell 功能，都必須以 Windows
PowerShell 5.1 為目標。請對照該目標檢查語法、cmdlet 與參數的可用性、.NET Framework
API、編碼，以及行程／執行期行為。

錯誤修正還需要一個迴歸測試，在修正前失敗、修正後通過
。如果某個基線或執行路徑無法自動測試，
請說明這個限制，並為受影響的成功與失敗路徑提供可重現的證據
。僅涉及提示詞的編輯，以及其他非行為性的編輯，不需要
硬湊出測試。

### 建議的驗證流程

為了獲得最順暢的審查體驗，請依這個順序驗證變更：

1. **先執行聚焦的自動化檢查**——使用[下方](#automated-checks)的快速驗證命令，及早捕捉鷹架與設定的迴歸。
2. **再執行手動工作流程測試**——如果你的變更影響斜線命令或開發者工作流程，依[手動測試](#manual-testing)區段選擇正確的命令，在代理中執行它們，並把結果擷取下來放進你的 PR。

### 自動化檢查

#### 代理設定與接線一致性

```bash
uv run python -m pytest tests/test_agent_config_consistency.py -q
```

當你變更代理中繼資料、上下文更新指令碼或整合接線時，執行這個檢查。

#### 執行完整的測試套件

把測試相依性安裝到專案自己的虛擬環境中，並
透過那個解譯器執行 `pytest`：

```bash
uv pip install -e ".[test]"
.venv/bin/python -m pytest tests -q   # Windows: .venv\Scripts\python -m pytest tests -q
```

> **注意：** 請優先使用 `.venv/bin/python -m pytest`，而不是直接執行 `uv run pytest`。
> 如果另一個 Spec Kit 簽出版本在共用／全域環境中註冊了一個可編輯（`-e`）安裝，
> `uv run pytest` 可能會把 `specify_cli` 解析到那個
> *另一個*工作樹，讓它變成一個不完整的命名空間套件，無法
> 匯入新加入的子套件。透過專案的 `.venv` 執行，會把
> `specify_cli` 解析到這個簽出版本的 `src/`。這與 `AGENTS.md`（常見陷阱）中記錄的注意事項一致。

#### 安全性檢查

```bash
uvx --from pip-audit==2.10.0 pip-audit --disable-pip --require-hashes -r .github/security-audit-requirements.txt --progress-spinner off
```

這個命令稽核已提交的、帶雜湊的需求快照。拉取請求、
推送與手動 CI 執行都使用同一份快照，讓它們的結果保持
確定性。如果相依性中繼資料變更，請先重新整理並提交快照，
再進行稽核：

```bash
uv pip compile pyproject.toml --extra test --universal --upgrade --generate-hashes --quiet --no-header --output-file .github/security-audit-requirements.txt
```

排程中的 CI 稽核會在受支援的 Python 與作業系統矩陣上，解析執行期與 `test` 額外相依性集合，以捕捉新發布的資安公告。
上游套件的版本會隨時間漂移，因此即使是一個不相關、但觸及
`pyproject.toml` 的 PR，也可能讓 `dependency-audit` 檢查失敗，直到已提交的檔案
用上方命令重新產生並重新提交為止。

#### Shell 指令碼

```bash
git ls-files -z -- '*.sh' | xargs -0 shellcheck --severity=error
```

CI 的 `lint.yml` 中的 `shellcheck` 工作目前只回報並阻擋
error 嚴重程度的發現。像 SC2155 這類的警告刻意不在
這個工作的範圍內，直到後續的清理工作把門檻收緊為止。

### 手動測試

#### 測試設定

```bash
# Install the project and test dependencies from your local branch
cd <spec-kit-repo>
uv sync --extra test
source .venv/bin/activate  # On Windows (CMD): .venv\Scripts\activate  |  (PowerShell): .venv\Scripts\Activate.ps1
uv pip install -e .
# Ensure the `specify` binary in this environment points at your working tree so the agent runs the branch you're testing.

# Initialize a test project using your local changes
uv run specify init <temp-dir>/speckit-test --integration <agent>
cd <temp-dir>/speckit-test

# Open in your agent
```

#### 手動測試流程

任何影響斜線命令行為的變更，都需要透過程式代理手動測試該命令，並隨 PR 一起提交結果。

1. **找出受影響的命令**——使用[下方的提示詞](#determining-which-tests-to-run)，讓你的代理分析你變更的檔案，判斷哪些命令需要測試。
2. **設定一個測試專案**——從你的本機分支建立鷹架（見[測試設定](#testing-setup)）。
3. **執行每個受影響的命令**——在你的代理中叫用它，驗證它成功完成，並確認它產生預期的輸出（建立的檔案、執行的指令碼、填入的產出物）。
4. **先執行先決條件**——相依於更早命令的命令（例如 `/speckit.tasks` 需要 `/speckit.plan`，而 `/speckit.plan` 需要 `/speckit.specify`）必須依序執行。
5. **回報結果**——把[回報範本](#reporting-results)貼進你的 PR，為每個測試過的命令填上通過／失敗。

#### 回報結果

把這段貼進你的 PR：

```markdown
## Manual test results

**Agent**: [e.g., GitHub Copilot in VS Code]  |  **OS/Shell**: [e.g., macOS/zsh]

| Command tested | Notes |
|----------------|-------|
| `/speckit.command` | |
```

#### 判斷要執行哪些測試

把這段提示詞複製到你的代理中。把代理的回應（選定的測試，加上對應關係的簡要說明）包含在你的 PR 裡。

```text
Read CONTRIBUTING.md, then run `git diff --name-only main` to get my changed files.
For each changed file, determine which slash commands it affects by reading
the command templates in templates/commands/ to understand what each command
invokes. Use these mapping rules:

- templates/commands/X.md → the command it defines
- scripts/bash/Y.sh or scripts/powershell/Y.ps1 → every command that invokes that script (grep templates/commands/ for the script name). Also check transitive dependencies: if the changed script is sourced by other scripts (e.g., common.sh is sourced by create-new-feature.sh, check-prerequisites.sh, setup-plan.sh), then every command invoking those downstream scripts is also affected
- templates/Z-template.md → every command that consumes that template during execution
- src/specify_cli/*.py → CLI commands (`specify init`, `specify check`, `specify extension *`, `specify preset *`); test the affected CLI command and, for init/scaffolding changes, at minimum test /speckit.specify
- extensions/X/commands/* → the extension command it defines
- extensions/X/scripts/* → every extension command that invokes that script
- extensions/X/extension.yml or config-template.yml → every command in that extension. Also check if the manifest defines hooks (look for `hooks:` entries like `before_specify`, `after_implement`, etc.) — if so, the core commands those hooks attach to are also affected
- presets/*/* → test preset scaffolding via `specify init` with the preset
- pyproject.toml → packaging/bundling; test `specify init` and verify bundled assets

Include prerequisite tests (e.g., T5 requires T3 requires T1).

Output in this format:

### Test selection reasoning

| Changed file | Affects | Test | Why |
|---|---|---|---|
| (path) | (command) | T# | (reason) |

### Required tests

Number each test sequentially (T1, T2, ...). List prerequisite tests first.

- T1: /speckit.command — (reason)
- T2: /speckit.command — (reason)
```

## Spec Kit 中的 AI 貢獻

> [!IMPORTANT]
>
> 如果你正在使用**任何形式的 AI 協助**為 Spec Kit 做出貢獻，
> 這必須在拉取請求或議題中揭露。

我們歡迎並鼓勵使用 AI 工具來協助改進 Spec Kit！許多有價值的貢獻都在 AI 的協助下獲得了強化，用於程式碼生成、議題偵測與功能定義。

話雖如此，如果你在為 Spec Kit 做出貢獻時使用了任何形式的 AI 協助（例如代理、ChatGPT），
**這必須在拉取請求或議題中揭露**。當 AI 協助被使用時，揭露內容必須指明：

- **代理／工具**——例如 GitHub Copilot、Claude Code、ChatGPT。
- **模型**——例如 Claude Opus 4.x、GPT-5。
- **設定／模式**——例如推理努力程度，以及它是在自主模式下還是人類監督下執行。
- **參與程度**——例如文件註解與程式碼生成的差別。

如果你的 PR 回應或留言是由 AI 產生的，也請揭露這一點，並指明相同的代理、模型、設定／模式與參與程度。

作為例外，瑣碎的間距或錯字修正不需要揭露，前提是變更僅限於程式碼的小部分或簡短的詞句。型錄提交議題表單（擴充功能、預設集與套件組的提交）餵給的是內容中立的驗證自動化，而不是程式碼審查，因此它們沒有揭露欄位，也豁免於這項要求。Spec Kit 自家隨附的代理工作流程（`.github/workflows/` 下的自動化錯誤修正與社群型錄提示詞）同樣豁免：它們以固定、已知的代理身分執行，並開啟草稿 PR 供維護者審查，因此它們的代理身分是工作流程本身固有的，而不是由每次貢獻自行申報的。
瑣碎修正的例外，並不免除下方針對代表貢獻者行事的代理的揭露要求；隨附的工作流程則保留其豁免。

一則揭露的範例：

> 以 GitHub Copilot 使用 Claude Opus 4.x，在代理／自主模式下實作；程式碼生成。

或一則更詳細的揭露：

> 我諮詢了 ChatGPT（GPT-5、預設設定、由人類監督）來理解程式碼庫，但解決方案
> 完全由我本人手動撰寫。

未能揭露這一點，首先是對拉取請求另一端的人類操作者非常無禮的行為。

要說清楚的是，這份揭露不會改變一份貢獻所受到的審查程度——同一套證據標準適用於
所有人，無論是人類還是 AI 協助的貢獻皆然。它只是讓維護者能看見哪些模型與設定正在被使用，以及
使用到什麼程度，進而協助我們判斷，隨著時間過去，我們的 [`AGENTS.md`](./AGENTS.md) 指引是否需要精煉。

在一個完美的世界裡，AI 協助產出的工作品質會等於或高於任何人類。但那不是我們今天所生活的世界，而且在大多數
缺乏人類監督或專業知識參與的情況下，它產生的程式碼無法被合理地維護或演進。

### 由代理撰寫的 Git 與審查活動

對於代表貢獻者行事的代理而言，揭露是持續性的：
PR 內文、每一個由代理撰寫的提交，以及每一則 AI 產生的 PR 留言或回覆，
都必須各自獨立指出代理的參與。PR 內文的揭露
並不涵蓋後續的提交或審查回合。

- **在開啟 PR 之前：** 檢查提交帳號是否已經在這個儲存庫中有三個
  開啟中的 PR。如果有，請說明另一份提交可能會
  獲得較低的審查優先順序，並取得提交者的明確許可。
  若未取得許可，包括在自主運作期間，請把工作留在分支上，
  並回報需要確認。儲存庫自有的 `gh-aw` 維護
  工作流程豁免於這項數量檢查。
- **對於每一個由代理撰寫的提交：** 附上一行 `Assisted-by:` 結尾標記，指明
  實際的代理與模型，以及它是以 `autonomous` 還是 `supervised` 方式行事，
  例如 `Assisted-by: GitHub Copilot (model: Claude Opus 4.8, autonomous)`。
  只有在真的無法確定模型時，才使用 `model: unknown`。只有在人類於提交前撰寫了這項變更、或逐行審查過它時，
  才使用 `supervised`。不要把代理的作者身分藏在操作者的 git
  身分背後，也不要移除工具產生的 `Co-authored-by:` 結尾標記。
- **對於每一則 AI 產生的 PR 留言：** 指出它所代表的貢獻者、
  代理、模型、設定／模式，以及 AI 參與的程度。在每一回合的審查摘要中重述這一點，而不只是
  在 PR 內文中。每回合發表一篇頂層摘要，包含變更與提交 SHA；
  只有在表達不同意見、延後處理，或進行不明顯的修正時，才使用行內回覆，並讓
  那些回覆保持簡短。不要代表審查者解決對話。
  避免使用表情符號、慶祝式的措辭、檢核清單式的鏡像重述，以及重述
  審查者的留言。在所有回饋都處理完畢後，重新請求審查一次。

快速的回應不能取代揭露：不要在審查後沒幾分鐘就發表一則未說明的「Done」，或
推送一個未揭露的修正。不要為一項自動化變更聲稱是由人類親自審查
或測試的；請如實描述這項自動化。

### 我們所看重的

提交 AI 協助的貢獻時，請確保它們包含：

- **清楚揭露 AI 的使用**——你對 AI 的使用保持透明，指明代理／工具、模型、設定／模式，以及你為這份貢獻使用它的程度
- **人類的理解與測試**——你已親自測試過這些變更，並理解它們的作用
- **清楚的理由**——你能解釋為什麼需要這項變更，以及它如何契合 Spec Kit 的目標
- **具體的證據**——附上展示改進成果的測試案例、情境或範例
- **你自己的分析**——分享你對端到端開發者體驗的想法

### 我們會關閉的貢獻

我們保留關閉看似屬於以下情況的貢獻的權利：

- 未經驗證就提交的未測試變更
- 未針對 Spec Kit 具體需求的泛泛建議
- 看不出有人類審查或理解的大量提交

### 成功的指引

關鍵在於展示你理解並驗證了你提出的變更。如果維護者能輕易看出某份貢獻完全是由 AI 產生、缺乏人類的投入或測試，那它在提交之前很可能還需要更多工作。

持續提交低投入、由 AI 產生的變更的貢獻者，可能會被維護者酌情限制進一步的貢獻。

請尊重維護者，並揭露 AI 協助。

## 資源

- [規格驅動開發方法論](./spec-driven.md)
- [如何為開源做出貢獻](https://opensource.guide/how-to-contribute/)
- [使用拉取請求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 說明](https://help.github.com)
