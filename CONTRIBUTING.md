## 貢獻至 Spec Kit

您好！我們非常高興您有意願為 Spec Kit 做出貢獻。本專案的貢獻會以 [開源授權條款](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) 釋出給公眾，並遵循 [專案的開源授權](LICENSE)。

請注意，本專案遵循 [貢獻者公約行為準則 (Contributor Covenant Code of Conduct)](CODE_OF_CONDUCT.md)。參與本專案即表示您同意遵守其條款。

## 執行與測試程式碼的先決條件

以下為 Pull Request（PR）提交流程中，您需在本地測試變更時必須進行的一次性安裝（One-time Usage）：

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
1. 安裝套件管理工具 [uv](https://docs.astral.sh/uv/)
1. 安裝 [Git](https://git-scm.com/downloads)
1. 準備一個 [AI 程式設計代理](README.md#-supported-ai-agents)

## 提交 Pull Request

>[!NOTE]
>如果您的 Pull Request 涉及對 CLI 或 repository 其他部分有重大影響的大型變更（例如新增模板、新增參數，或其他重大修改），請務必**先與專案維護者討論並取得共識**。未經事前討論與同意的大型變更 PR 會被關閉。

1. Fork 並 clone 此 repository
1. 設定並安裝相依性（dependency）：`uv sync`
1. 確認 CLI 能在您的機器上正常運作：`uv run specify --help`
1. 建立新分支：`git checkout -b my-branch-name`
1. 進行您的修改、加入測試，並確保一切功能正常
1. 若有相關，請以範例專案測試 CLI 功能
1. 推送到您的 fork 並提交 Pull Request
1. 等待您的 Pull Request 被審查與合併

以下幾點能提升您的 Pull Request 被接受的機率：

- 遵循專案的程式碼風格（Code Style）
- 為新增功能撰寫測試
- 若您的變更影響到使用者相關功能，請更新文件（`README.md`、`spec-driven.md`）
- 盡量聚焦於單一變更。若有多個彼此無依賴的修改，建議分開提交 Pull Request
- 撰寫[良好的 commit 訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- 以 Spec-Driven Development 方法論測試您的變更，確保相容性

## 開發流程

當您在開發 spec-kit 時：

1. 使用 `specify` CLI 指令（`/speckit.specify`、`/speckit.plan`、`/speckit.tasks`）於您選擇的 AI 程式設計代理中測試變更
2. 驗證 `templates/` 目錄下的模板運作正常
3. 測試 `scripts/` 目錄下的腳本功能
4. 若有重大流程變更，請確保記憶檔案（`memory/constitution.md`）已更新

## Spec Kit 中的 AI 貢獻

> [!IMPORTANT]
>
> 如果您在貢獻 Spec Kit 時**有使用任何形式的 AI 協助**，
> 必須在 Pull Request 或 Issue 中公開說明。

我們歡迎並鼓勵使用 AI 工具來協助提升 Spec Kit！許多有價值的貢獻都透過 AI 協助完成，例如程式碼產生、問題偵測、功能定義等。

但請注意，若您在貢獻過程中使用任何形式的 AI 協助（例如代理、ChatGPT 等），
**必須在 Pull Request 或 Issue 中公開說明**，並說明 AI 協助的範圍（例如僅用於文件註解，或直接產生程式碼）。

如果您的 PR 回覆或評論是由 AI 產生，也請一併說明。

例外情況：若僅為微小的排版或錯字修正，且僅限於程式碼片段或短語，不需特別揭露。

範例揭露方式：

> 這個 PR 主要由 GitHub Copilot 撰寫。

或更詳細的揭露：

> 我有諮詢 ChatGPT 以了解程式碼基礎，但解決方案完全由我本人手動撰寫。

未揭露 AI 協助，首先是不尊重 Pull Request 另一端的人工維護者，也會使我們難以判斷需投入多少審查力道。

理想情況下，AI 協助能產生與人類同等或更高品質的成果。但現實中，多數未經人工監督或專業參與的 AI 產生程式碼，往往難以維護或演進。

### 我們的期待

當您提交 AI 協助的貢獻時，請確保：

- **明確揭露 AI 使用情形** —— 透明說明您使用 AI 及其參與程度
- **人工理解與測試** —— 您已親自測試並理解這些變更的內容
- **清楚的理由** —— 您能解釋為何需要這項變更，以及它如何契合 Spec Kit 的目標
- **具體證據** —— 請附上測試案例、情境或範例，證明改進成效
- **您的分析** —— 分享您對開發者端到端體驗的看法

### 我們會關閉的情況

我們保留關閉下列類型貢獻的權利：

- 未經驗證就提交的變更
- 無法針對 Spec Kit 具體需求的泛泛建議
- 明顯未經人工審查或理解的大量提交

### 成功的指引

關鍵在於展現您已理解並驗證所提出的變更。如果維護者能輕易判斷該貢獻完全由 AI 產生、未經人工參與或測試，則可能需要進一步完善後再提交。

持續提交低品質 AI 產生內容的貢獻者，維護者有權限制其後續貢獻。

請尊重維護者，並主動揭露 AI 協助情形。

## 相關資源

- [Spec-Driven Development 方法論](./spec-driven.md)
- [如何參與開源貢獻](https://opensource.guide/how-to-contribute/)
- [使用 Pull Request](https://help.github.com/articles/about-pull-requests/)
- [GitHub 說明文件](https://help.github.com)

