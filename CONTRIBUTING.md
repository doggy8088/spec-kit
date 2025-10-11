## 貢獻 Spec Kit 指南

您好！我們非常高興您願意為 Spec Kit 做出貢獻。對本專案的貢獻將[公開釋出](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)，並依照[專案的開源授權條款](LICENSE)。

請注意，本專案遵循[貢獻者行為準則](CODE_OF_CONDUCT.md)。參與本專案即表示您同意遵守其條款。

## 執行與測試程式碼的先決條件

以下為您在提交 Pull Request (PR) 前，於本地測試變更所需的一次性安裝步驟：

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
1. 安裝套件管理工具 [uv](https://docs.astral.sh/uv/)
1. 安裝 [Git](https://git-scm.com/downloads)
1. 準備一個[可用的 AI 編碼代理工具](README.md#-supported-ai-agents)

## 提交 Pull Request 的流程

>[!NOTE]
>如果您的 Pull Request 涉及重大變更，對命令列介面 (Command Line Interface, CLI) 或整個 repository 造成實質影響（例如新增模板、參數或其他重大修改），請務必**先與專案維護者討論並取得共識**。未經事先討論與同意的大型變更 PR 將會被關閉。

1. Fork 並 clone 此 repository
1. 設定並安裝相依套件：`uv sync`
1. 確認 CLI 能在您的機器上正常運作：`uv run specify --help`
1. 建立新分支：`git checkout -b my-branch-name`
1. 進行您的變更、加入測試，並確保一切功能正常
1. 若有相關，請以範例專案測試 CLI 功能
1. Push 到您的 fork 並提交 Pull Request
1. 等待您的 Pull Request 被審查與合併

以下幾點能提升您的 Pull Request 被接受的機會：

- 遵循專案的程式撰寫慣例。
- 為新增功能撰寫測試。
- 若您的變更影響到使用者相關功能，請更新文件（`README.md`、`spec-driven.md`）。
- 盡量讓您的變更聚焦單一主題。若有多個彼此無依賴的變更，建議分開提交多個 Pull Request。
- 撰寫[良好的 commit 訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 以 Spec-Driven Development 工作流程測試您的變更，確保相容性。

## 開發工作流程

當您在開發 spec-kit 時：

1. 使用 `specify` CLI 指令（`/speckit.specify`、`/speckit.plan`、`/speckit.tasks`）於您選擇的 AI 編碼代理工具中測試變更
2. 驗證 `templates/` 目錄中的模板運作正常
3. 測試 `scripts/` 目錄下的腳本功能
4. 若有重大流程變更，請確保記憶檔案（`memory/constitution.md`）已更新

## 在 Spec Kit 中使用 AI 協作的規範

> [!IMPORTANT]
>
> 如果您在貢獻 Spec Kit 時**有使用任何形式的 AI 協助**，
> 必須在 Pull Request 或 Issue 中明確揭露。

我們歡迎並鼓勵使用 AI 工具來協助提升 Spec Kit！許多有價值的貢獻都在程式碼產生、問題偵測、功能定義等方面受益於 AI 協助。

但請注意，若您在貢獻過程中使用了任何 AI 協助（例如代理工具、ChatGPT 等），
**必須在 Pull Request 或 Issue 中揭露**，並說明 AI 協助的範圍（如僅用於文件註解，或包含程式碼產生等）。

若您的 PR 回覆或評論是由 AI 產生，也請一併揭露。

例外情況：若僅為微小的排版或錯字修正，且僅限於程式碼小片段或短語，則無需揭露。

範例揭露：

> 此 PR 主要由 GitHub Copilot 撰寫。

或更詳細的揭露：

> 我諮詢了 ChatGPT 以理解程式碼基礎，但解決方案完全由我手動撰寫。

未揭露 AI 協助，首先對負責審查 PR 的人員不禮貌，同時也會讓我們難以判斷該貢獻需投入多少審查力度。

理想情況下，AI 協助能產生與人類同等或更高品質的成果。但現實上，在缺乏人類監督或專業參與的情況下，AI 產生的程式碼往往難以維護或擴展。

### 我們希望看到的內容

當您提交 AI 協助的貢獻時，請確保包含：

- **明確揭露 AI 使用情形** —— 透明說明您使用 AI 的情況及程度
- **人為理解與測試** —— 您已親自測試變更並理解其作用
- **清楚的理由** —— 能解釋為何需要此變更，以及其如何符合 Spec Kit 的目標  
- **具體證據** —— 提供測試案例、情境或範例以證明改進效果
- **您的分析** —— 分享您對整體開發者體驗的看法

### 我們會關閉的貢獻

我們保留關閉以下類型貢獻的權利：

- 未經測試、未驗證即提交的變更
- 無法解決 Spec Kit 具體需求的泛泛建議
- 缺乏人為審查或理解的大量提交

### 成功的指引

關鍵在於展現您已理解並驗證所提變更。若維護者能輕易判斷該貢獻完全由 AI 產生，且缺乏人為參與或測試，則可能需要進一步完善後再提交。

持續提交低品質 AI 產生內容的貢獻者，維護者有權限制其後續貢獻。

請尊重維護者，並主動揭露 AI 協助情形。

## 相關資源

- [Spec-Driven Development 方法論](./spec-driven.md)
- [如何為開源專案貢獻](https://opensource.guide/how-to-contribute/)
- [使用 Pull Request](https://help.github.com/articles/about-pull-requests/)
- [GitHub 說明](https://help.github.com)
