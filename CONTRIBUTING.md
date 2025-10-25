# 貢獻指南（Contributing to Spec Kit）

您好！我們很高興您有意願為 Spec Kit 做出貢獻。本專案的貢獻將依據[專案的開源授權條款](LICENSE)[公開釋出](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)。

請注意，本專案遵循[貢獻者公約行為準則 (Contributor Covenant Code of Conduct)](CODE_OF_CONDUCT.md)。參與本專案即表示您同意遵守其條款。

## 執行與測試程式碼的先決條件

以下為您在提交 Pull Request（PR）時，於本地測試變更所需的一次性安裝步驟：

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
1. 安裝套件管理工具 [uv](https://docs.astral.sh/uv/)
1. 安裝 [Git](https://git-scm.com/downloads)
1. 準備一個可用的 [AI 程式設計代理](README.md#-supported-ai-agents)

<details>
<summary><b>💡 提示：如果您使用 <code>VSCode</code> 或 <code>GitHub Codespaces</code> 作為您的 IDE</b></summary>

<br>

只要您的機器上已安裝 [Docker](https://docker.com)，即可透過這個 [VSCode 擴充功能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)利用 [Dev Containers](https://containers.dev)，快速建立開發環境，所需工具皆已安裝並設定完成，這都要歸功於專案根目錄下的 `.devcontainer/devcontainer.json` 檔案。

操作步驟如下：

- 取得（checkout）此 repo
- 使用 VSCode 開啟
- 開啟 [Command Palette](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) 並選擇 "Dev Containers: Open Folder in Container..."

在 [GitHub Codespaces](https://github.com/features/codespaces) 上更為簡單，開啟 codespace 時會自動套用 `.devcontainer/devcontainer.json`。

</details>

## 提交 Pull Request

>[!NOTE]
>如果您的 Pull Request 涉及重大變更，並且會實質影響 CLI 或 repository 其他部分的運作（例如：新增模板、參數，或其他重大更動），請務必**先與專案維護者討論並取得共識**。未經事前討論與同意的重大變更 PR 會被關閉。

1. Fork 並 clone 此 repository
1. 設定並安裝相依性（dependency）：`uv sync`
1. 確認 CLI 能在您的機器上正常運作：`uv run specify --help`
1. 建立新分支：`git checkout -b my-branch-name`
1. 進行您的變更、加入測試，並確保一切功能正常
1. 若有需要，請以範例專案測試 CLI 功能
1. 推送到您的 fork 並提交 Pull Request
1. 等待您的 Pull Request 被審查與合併

以下幾點能提升您的 Pull Request 被接受的機率：

- 遵循專案的程式碼風格
- 為新功能撰寫測試
- 若您的變更影響到使用者相關功能，請更新文件（`README.md`、`spec-driven.md`）
- 盡量讓您的變更聚焦單一主題。若有多個互不相依的變更，建議分開提交 Pull Request
- 撰寫[良好的 commit 訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- 使用 Spec-Driven Development 方法論測試您的變更，以確保相容性

## 開發流程

當您在開發 spec-kit 時：

1. 使用 `specify` CLI 指令（`/speckit.specify`、`/speckit.plan`、`/speckit.tasks`）於您選擇的 AI 程式設計代理中測試變更
2. 在 `templates/` 目錄中驗證模板運作是否正確
3. 在 `scripts/` 目錄中測試腳本功能
4. 若有重大流程變更，請確保記憶檔案（`memory/constitution.md`）已更新

### 在本地測試模板與指令變更

執行 `uv run specify init` 會拉取已釋出的套件，因此不會包含您的本地變更。  
若要在本地測試您的模板、指令及其他變更，請依照下列步驟操作：

1. **建立釋出套件**

   執行以下指令以產生本地套件：
   ```
   ./.github/workflows/scripts/create-release-packages.sh v1.0.0
   ```

2. **將相關套件複製到你的測試專案中**

   ```
   cp -r .genreleases/sdd-copilot-package-sh/. <path-to-test-project>/
   ```

3. **開啟並測試 agent**

   請前往你的測試專案資料夾並開啟 agent，以驗證你的實作。

## Spec Kit 中的 AI 貢獻

> [!IMPORTANT]
>
> 如果你在貢獻 Spec Kit 時**有使用任何形式的 AI 協助**，
> 必須在 Pull Request 或 Issue 中揭露。

我們歡迎並鼓勵使用 AI 工具來協助改進 Spec Kit！許多有價值的貢獻都透過 AI 協助進行了程式碼生成、問題偵測與功能定義等強化。

話雖如此，如果你在貢獻 Spec Kit 時有使用任何形式的 AI 協助（例如：AI agent、ChatGPT），
**必須在 Pull Request 或 Issue 中揭露**，並說明 AI 協助的使用範圍（例如：僅用於文件註解，或包含程式碼生成）。

如果你的 PR 回覆或評論是由 AI 產生，也請一併揭露。

有一個例外：若僅為微不足道的空白或錯字修正，且變更僅限於程式碼的小部分或短語，則無需揭露。

揭露範例：

> 這個 PR 主要由 GitHub Copilot 撰寫。

或更詳細的揭露：

> 我諮詢了 ChatGPT 以理解程式碼庫，但解決方案完全由我手動撰寫。

未揭露 AI 協助，首先對於處理 Pull Request 的人類參與者是不禮貌的，同時也會讓我們難以
判斷該對貢獻進行多少程度的審查。

在理想的世界裡，AI 協助能產出與人類同等或更高品質的工作。但現實並非如此，在多數情況下，
若缺乏人類監督或專業知識介入，AI 產生的程式碼往往難以合理維護或擴展。

### 我們的期待

當你提交有 AI 協助的貢獻時，請確保包含：

- **明確揭露 AI 使用情形** — 你需誠實說明 AI 的使用情形及其在貢獻中的參與程度
- **人類理解與測試** — 你已親自測試這些變更，並理解其運作方式
- **清楚的理由** — 你能解釋為何需要這項變更，以及它如何符合 Spec Kit 的目標  
- **具體證據** — 請包含測試案例、情境或範例，以展示改進成效
- **你自己的分析** — 分享你對整體開發者體驗的看法

### 我們會關閉的貢獻

我們保留關閉以下類型貢獻的權利：

- 未經驗證即提交的未測試變更
- 未針對 Spec Kit 具體需求的泛泛建議
- 未經人類審查或理解的大量提交

### 成功的指引

關鍵在於證明你已理解並驗證你提出的變更。如果專案維護者能輕易判斷某項貢獻完全由 AI 生成、且未經人類參與或測試，則該貢獻很可能還需要進一步完善才能提交。

若貢獻者持續提交低品質的 AI 生成變更，專案維護者有權限制其後續貢獻。

請尊重專案維護者，並主動揭露 AI 協助情形。

## 資源

- [Spec-Driven Development 方法論](./spec-driven.md)
- [如何為開源專案做出貢獻](https://opensource.guide/how-to-contribute/)
- [使用 Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
