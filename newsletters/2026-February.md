# Spec Kit－2026 年 2 月電子報

本期涵蓋 Spec Kit 在 2026 年 2 月的動態。本月發佈了 v0.1.7 至 v0.1.13，修復錯誤並新增功能，包括雙型錄擴充系統與更多代理整合。社群動態包括部落格文章、教學與聚會分享。下表為分類摘要，其後為詳細內容。

| **Spec Kit 核心（2026 年 2 月）** | **社群與內容** | **藍圖與下一步** |
| --- | --- | --- |
| 發佈了 **v0.1.7** 至 **v0.1.13**，包含錯誤修復與新功能，包括**雙型錄擴充系統**與新的代理整合。關閉了 300 多個 issue（共提出約 800 個）。儲存庫達到 71k 顆星與 6.4k 個 fork。 [\[github.com\]](https://github.com/github/spec-kit/releases) [\[github.com\]](https://github.com/github/spec-kit/issues) [\[rywalker.com\]](https://rywalker.com/research/github-spec-kit) | Eduardo Luz 在 LinkedIn 發表了關於 SDD 與 Spec Kit 的文章 [\[linkedin.com\]](https://www.linkedin.com/pulse/specification-driven-development-sdd-github-spec-kit-elevating-luz-tojmc?tl=en)。Erick Matsen 在部落格分享了用 Spec Kit 打造生物資訊管線的完整導覽 [\[matsen.fredhutch.org\]](https://matsen.fredhutch.org/general/2026/02/10/spec-kit-walkthrough.html)。Microsoft MVP [Eric Boyd](https://ericboyd.com/)（與同名的 Microsoft AI Platform 副總裁並非同一人）在 Cleveland .NET User Group 分享 [\[ericboyd.com\]](https://ericboyd.com/events/cleveland-csharp-user-group-february-25-2026-spec-driven-development-sdd-github-spec-kit)。 | **v0.2.0** 於 3 月初發佈，彙整了 2 月的工作成果。新增了 Jira 與 Azure DevOps 擴充功能、社群外掛支援，以及 Tabnine CLI 與 Kiro CLI 代理 [\[github.com\]](https://github.com/github/spec-kit/releases)。未來工作包括規格生命週期管理，以及邁向穩定的 1.0 版本 [\[martinfowler.com\]](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)。 |

***

## Spec Kit 專案更新

Spec Kit 在 2 月發佈了 **v0.1.7** 至 **v0.1.13**。0.1.7 版（2 月初）更新了新推出的**雙型錄擴充系統**文件，該系統讓核心與社群兩種擴充型錄能並存。後續修補版本（0.1.8、0.1.9 等）升級了 GitHub Actions 版本等相依套件，並解決了若干小問題。**v0.1.10** 修復了產生檔案中的 YAML front-matter 處理。到了 2 月下旬，**v0.1.12** 與 **v0.1.13** 發佈了更多修復，為下一次版本升級做準備。 [\[github.com\]](https://github.com/github/spec-kit/releases)

本月最主要的架構新增是**模組化擴充系統**，為第三方附加元件分別提供「core」與「community」擴充型錄。本月合併了多個社群貢獻的擴充功能，包括用於 issue 追蹤整合的 **Jira 擴充功能**、**Azure DevOps 擴充功能**，以及用於程式碼審查、回顧文件與 CI/CD 同步的工具型擴充功能。待發佈的 0.2.0 版變更記錄列出了十多項來自 2 月的變更，包括擴充功能的新增，以及同時支援**多個代理型錄**。 [\[github.com\]](https://github.com/github/spec-kit/releases)

截至 2 月底，**GitHub 上已關閉超過 330 個 issue／功能請求**（迄今共提出約 870 個）。外部貢獻者提交了 pull request，其中包括 2 月下旬合併的 **Tabnine CLI 支援**。儲存庫達到約 71k 顆星，並突破 6,000 個 fork。 [\[github.com\]](https://github.com/github/spec-kit/issues) [\[github.com\]](https://github.com/github/spec-kit/releases) [\[rywalker.com\]](https://rywalker.com/research/github-spec-kit)

在穩定性方面，2 月的工作聚焦於收緊核心工作流程，並修復規格、計畫與任務產生命令中的邊界情況錯誤。團隊處理了檔案處理問題（例如釐清輸出檔案的建立／附加方式），並提升了自動化發佈管線的可靠性。專案也將 **Kiro CLI** 加入支援的代理清單，並更新了 Cursor 與 Code Interpreter 的整合指令稿，使支援的 AI 程式助理總數超過 20 個。 [\[github.com\]](https://github.com/github/spec-kit/releases) [\[github.com\]](https://github.com/github/spec-kit)

## 社群與內容

**Eduardo Luz** 於 2 月 15 日在 LinkedIn 發表文章，題為 *「Specification Driven Development (SDD) and the GitHub Spec Kit: Elevating Software Engineering」*。文章以他資深工程師的經驗，說明技術債與設計不一致的常見成因，以及 SDD 如何應對這些問題。文章逐步介紹了 Spec Kit 的**四層作法**（憲章、設計、任務、實作），並探討將規格視為真實來源的做法。這篇文章在 LinkedIn 上引發了軟體架構師之間的討論，聚焦於如何透過規格驅動工作流程減少誤解與重工。 [\[linkedin.com\]](https://www.linkedin.com/pulse/specification-driven-development-sdd-github-spec-kit-elevating-luz-tojmc?tl=en)

**Erick Matsen**（Fred Hutchinson Cancer Center）於 2 月 10 日發表了詳細導覽，題為 *「Spec-Driven Development with spec-kit」*。他描述如何用 Spec Kit 的工作流程（從 `speckit.constitution` 到 `speckit.implement`）在一天內打造一條**生物資訊管線**。文章包含命令輸出，以及沿途決策的說明，例如精煉規格以加入領域專屬需求。他寫道：「我真心推薦這種作法。這感覺就是軟體開發本該有的樣子。」 [\[matsen.fredhutch.org\]](https://matsen.fredhutch.org/general/2026/02/10/spec-kit-walkthrough.html) [\[github.com\]](https://github.com/mnriem/spec-kit-dotnet-cli-demo)

本月還出現了其他幾篇教學與指南。*IntuitionLabs* 的一篇文章（2 月 21 日更新）提供了 Spec Kit 指南，涵蓋 SDD 背後的理念，以及附範例的四階段工作流程導覽。Ry Walker 於 2 月 22 日發表的文章彙整了 Spec Kit 的關鍵面向，指出其與代理無關的設計與 71k 顆星的成績。Microsoft Developer Blog 在 2025 年底發表的文章（*「Diving Into Spec-Driven Development with GitHub Spec Kit」*，作者為 Den Delimarsky）持續在新使用者之間流傳。 [\[intuitionlabs.ai\]](https://intuitionlabs.ai/articles/spec-driven-development-spec-kit) [\[rywalker.com\]](https://rywalker.com/research/github-spec-kit)

**2 月 25 日**，Cleveland C# .NET User Group 舉辦了一場題為 *「Spec Driven Development with GitHub Spec Kit」* 的分享。主講者為 Microsoft MVP **[Eric Boyd](https://ericboyd.com/)**（駐 Cleveland 的 .NET 開發者；請勿與同名的 Microsoft AI Platform 副總裁混淆）。Boyd 講述了規格如何改變 AI 程式助理的輸出、如何跨多個週期迭代與精煉規格的模式，以及如何從臨時下提示詞轉向可重複的規格驅動工作流程。包括 GDG Madison 在內的其他社群，也在 2 月下旬與 3 月初排定了規格驅動開發的分享場次。 [\[ericboyd.com\]](https://ericboyd.com/events/cleveland-csharp-user-group-february-25-2026-spec-driven-development-sdd-github-spec-kit)

在 GitHub 上，**Spec Kit Discussions 論壇**的討論主題圍繞在安裝疑難排解、以 Spec Kit 的分支模型處理多功能專案，以及功能建議。其中一串討論談到 Spec Kit 如何將每份規格視為與功能分支綁定的短期產物，進而引發了對未來支援長期「記錄規格」（spec of record）使用情境的討論。 [\[martinfowler.com\]](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)

## SDD 生態系

其他規格驅動開發工具在 2 月也有動態。

AWS **Kiro** 於 2 月 18 日發佈 0.10 版，帶來兩個新的規格工作流程：**Design-First** 模式（從架構／虛擬碼出發推導需求）與 **Bugfix** 模式（結構化的根本原因分析，產出 `bugfix.md` 規格檔）。Kiro 也新增了針對 AI 產生變更的 hunk 層級程式碼審查，以及用於自訂自動化的任務前／後 hook。AWS 於 2 月 17 日將 Kiro 擴展至 GovCloud 區域，以因應政府合規使用情境。 [\[kiro.dev\]](https://kiro.dev/changelog/)

**OpenSpec**（由 Fission AI 開發）是一個輕量 SDD 框架，達到約 29.3k 顆星與近 2k 個 fork。其社群在本月發佈了指南與比較文章，包括 *「Spec-Driven Development Made Easy: A Practical Guide with OpenSpec」*。OpenSpec 強調簡單與彈性，透過 YAML 設定與多個 AI 程式助理整合。

**Tessl** 仍處於私人 beta 階段。如 Thoughtworks 作者 Birgitta Boeckeler 所述，Tessl 追求的是 **spec-as-source** 模型：規格長期維護，並直接一對一產生程式碼檔案，產生的程式碼會標示為「請勿編輯」。這與 Spec Kit 目前依功能／分支建立規格的作法形成對比。 [\[martinfowler.com\]](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)

一篇 **arXiv 預印本**（2026 年 1 月）將 SDD 實作分為三個層級：*spec-first*、*spec-anchored* 與 *spec-as-source*。Spec Kit 被歸類為以 spec-first 為主、兼具 spec-anchored 元素。科技媒體發表了多篇評測，包括 *Vibe Coding* 的「GitHub Spec Kit Review (2026)」，以及一篇題為 *「Putting Spec Kit Through Its Paces: Radical Idea or Reinvented Waterfall?」* 的部落格文章，其結論認為，結合 AI 協助的 SDD 比傳統瀑布式開發更具迭代性。 [\[intuitionlabs.ai\]](https://intuitionlabs.ai/articles/spec-driven-development-spec-kit) [\[martinfowler.com\]](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)

## 藍圖

**v0.2.0** 於 2026 年 3 月 10 日發佈，彙整了本月的工作成果。內容包括新擴充功能（Jira、Azure DevOps、review、sync）、對多個擴充型錄與社群外掛的支援，以及更多代理整合（Tabnine CLI、Kiro CLI）。 [\[github.com\]](https://github.com/github/spec-kit/releases)

未來開發中正在討論或進行中的領域：

- **規格生命週期管理**——支援壽命更長的規格，讓規格能跨多次迭代演進，而不是綁定在單一功能分支上。使用者已在 GitHub Discussions 提出此需求，「spec-anchored」開發的概念也在考量中。 [\[martinfowler.com\]](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)
- **CI/CD 整合**——將 Spec Kit 驗證（例如 `speckit.checklist` 或 `speckit.verify`）納入 pull request 工作流程與專案管理工具。2 月的 Jira 與 Azure DevOps 擴充功能是朝這個方向邁出的一步。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **持續擴充代理支援**——隨著新的 AI 程式助理出現而加入整合。專案目前支援超過 20 個代理，並在新代理可用時陸續加入（Kiro CLI、Tabnine CLI）。 [\[github.com\]](https://github.com/github/spec-kit)
- **社群生態系**——開放的擴充模型讓外部貢獻者能直接新增功能。2 月的 Jira 與 Azure DevOps 外掛即由社群貢獻。Spec Kit README 現在連結到 .NET、Spring Boot 與其他技術堆疊的社群導覽示範。 [\[github.com\]](https://github.com/github/spec-kit)
