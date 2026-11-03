# Spec Kit－2026 年 9 月電子報

本期涵蓋 Spec Kit 在 2026 年 9 月的動態——這是 **v1.0.x 系列**的第一個完整月份，共發佈十一個修補版本（v1.0.3 至 v1.0.13）。本月有三股潮流貫穿其中。第一，**組合代數在 8 月藍圖所指的方向上深化**——預設集現在可以要求某個擴充功能，工作流程獲得了可重用的槽位，步驟也能攜帶個別步驟的整合設定。第二，新的 **`specify artifact` 內省介面**讓工具能以機器可讀的方式檢視擴充功能、預設集與 hook 如何組合，其後還有一波大規模的 **CLI 重新組織**。第三，**安全性與穩健性運動**持續成為日常。在更廣的生態系中，本月頭條來自第一方：**Microsoft 發佈了 Spec Kit 的第一個資料庫擴充功能**——公開預覽中的 Azure Cosmos DB 擴充功能。下表為摘要，其後為詳細內容。

| **Spec Kit 核心（2026 年 9 月）** | **社群與內容** | **SDD 生態系與下一步** |
| --- | --- | --- |
| 十一個修補版本（v1.0.3–v1.0.13）。頭條包括：**組合代數深化**，帶來預設集的 **`requires.extensions`**、**工作流程槽位**與**個別步驟整合設定**；新的 **`specify artifact`** 內省介面，將組合堆疊與 hook 貢獻以 JSON 公開；月底的 **CLI 重新組織**，將命令分為各領域的命令家族；以及持續的**安全性強化**浪潮（以標籤釘選的目錄 URL、TOCTOU、封存校驗和、元件釘選驗證）。內建整合目錄達到 **42 個**，新增 Docker Agent、DeepSeek Harness、Muse Code 與 MiniMax Code，以及 **Bitbucket** 驗證提供者。儲存庫從約 132,000 顆星成長至 **約 139,700 顆星**，超越 `golang/go` 與 `microsoft/PowerToys`。 [\[github.com\]](https://github.com/github/spec-kit/releases) | 社群擴充目錄從 162 個成長至 **176 個條目**；預設集達到 **40 個**，社群工作流程維持 **2 個**，套件組達到 **3 個**，新增 Agentstandards Multi-Vendor Architecture 套件組。報導相當可觀，由第一方 Microsoft DevBlogs 文章領銜，另有兩篇 Microsoft MVP 文章，以及一波 token 成本批評與多框架實地指南。**日語 README** 隨之發佈。 | **Microsoft 發佈了 Spec Kit 的第一個資料庫擴充功能**——公開預覽中的 Azure Cosmos DB，並附坦率的成效章節——這是第一方（而非第三方）里程碑，開啟了新的擴充類別。真正的第三方訊號是社群目錄自身的成長。圍繞日趨成熟的 1.x 系列，「該選哪個 SDD 平台」的框架愈發定型。 |

***

> **1.0 只是一個數字。** 8 月把數字放上了盒子；9 月問的是這個數字的價值。答案是一個月穩定的發佈——發佈的目的不是捍衛穩定的 API，而是持續在開放中重塑五個基本元素。這正是 1.0 論點的日常化：當代理能機械化地跟隨破壞性變更找到其呼叫點，大版本號便不再是保險，而是標點符號。因此專案在這個月選擇迭代而非停滯——收緊基本元素之間的接合處、教會自家工具描述自己，並讓安全工作與發佈一樣成為日常。與此同時，擴充模型持續吸引建置者——一個成長中的社群目錄，以及來自 Microsoft 產品團隊的第一個資料庫擴充功能。這一切都離不開社群——貢獻者、擴充功能與預設集作者、套件組建置者、代理整合維護者，以及以 20 多種語言寫作的實務者。謝謝你們。

## Spec Kit 專案更新

### 版本總覽

**v1.0.3–v1.0.13**（9 月 1–29 日）以穩定節奏運行里程碑後的修補列車——三十天內十一個版本，大約每兩到三天一個，PyPI 的 `specify-cli` 保持同步。與其說每個版本是一次功能投放，不如說每個建置都把這兩週的工作流程引擎、目錄、打包器、跨平台與整合修復帶進已發佈的系列。即使工程焦點輪替——月初是組合基本元素、月中是 `specify artifact` 內省介面、月底是大規模 CLI 重新組織——節奏依然穩定，儲存庫也從約 132,000 顆星攀升至約 139,700 顆星，超越 `golang/go` 與 `microsoft/PowerToys`。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 組合代數深化

8 月的藍圖標示了「更細粒度的組合點」、一個能「宣告所需擴充功能」的預設集，以及「可重用的工作流程槽位」。三者全數發佈。預設集現在能透過 **`requires.extensions`**（#4250）宣告其所假設的擴充功能，因此安裝預設集時會一併帶來它所依賴的行為，而非默默假設其存在。**工作流程槽位**（#4352）為工作流程定義新增具名、可重用的插入點——這與核心內部所做的動作相同，把受控自訂變成填入槽位，而非取代整個流程。而**個別步驟整合設定**（#4425）讓單一工作流程步驟能攜帶它所需的整合設定，而非繼承整個流程共用的一份設定。貫穿其中的主線與 1.0.0 的故事相同，只是推進了一個層次：這些基本元素愈來愈像一組**具名、可覆寫的接合處**，供預設集、工作流程與步驟在其上組合。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 機器可讀的檢視：`specify artifact`

9 月結構上最重大的新功能是 **`specify artifact` 內省介面**。基礎命令將專案的**組合堆疊以 JSON 公開**（#4305），後續版本透過同一命令呈現 **hook 貢獻與執行期繫結**（#4348），第三步則**將每項貢獻解析回擁有它的產物**（#4550）。三者合起來，隨著真實專案中擴充功能、預設集與 hook 的數量成長，能給工具——以及代理——一個機器可讀的答案，回答「這裡實際上由什麼組合而成，又是誰貢獻的？」。第一方的 [`github/spec-kit-copilot`](https://github.com/github/spec-kit-copilot) 外掛在同月以 artifact 內省技能與之呼應。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 目錄易用性與 CLI 重新組織

在基本元素之外，9 月讓目錄與命令介面更為實用。**擴充功能**（#4726）與**工作流程**（#4788）現在都能**選取確切的目錄版本**，而非永遠取最新版；`catalog add` 在**每個目錄家族中都變得冪等**（#4543），重複執行也安全；專案發佈了**第一方的 bugfix 與 assess 套件組**，攜帶各自的工作流程（#4504），以及 **`specify preset update`** 便利包裝命令（#4599）。月底，一次大規模的 **CLI 重新組織**將每個命令家族移入其結構化領域——extension（#4641）、preset（#4657）、integration（#4662）、bundle（#4663）、artifact（#4671）、workflow（#4673）與 authentication（#4678），一路到根命令配接器（#4687）與 preset 領域模組拆分（#4747）。這項工作是結構性而非行為性的，為仍在成長的命令集騰出空間。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 安全性與穩健性運動持續進行

強化浪潮進入 9 月後，成為常設紀律而非專案。本月由 **URL 與供應鏈收緊**領銜：目錄下載現在**要求以標籤釘選的 URL**（#4194），堵住了一條 `latest` 參考可能解析到非預期內容的繞過路徑；GitHub HTTP 層**驗證發佈資產中繼資料 URL**（#4438）；套件組安裝則**驗證獨立安裝元件的釘選**（#4789），堵住了元件與其紀錄釘選之間的漂移路徑。**消除競態**移除了 `catalog_fetch()` 中的檢查時／使用時（TOCTOU）窗口（#3910），**社群封存驗證獲得恢復**，讓提交的校驗和在信任前先行比對（#4689）。8 月的 URL 連接埠驗證持續擴及預設集目錄、憑證比對與 GitHub HTTP 處理（#4341、#4362、#4372），發佈標籤輸入獲得強化（#4386），無法讀取的來源資訊現在會**失敗即關閉**（#4092）。

與之並行的是工作流程與目錄引擎中持續的**「大聲失敗」驗證掃蕩**。工作流程驗證變得更嚴格——格式錯誤的步驟資訊清單、為假值的非對映目錄設定、非字串的目錄標籤，以及不受支援的目錄酬載版本，現在都會以清楚的錯誤被拒絕（#4321、#4320、#4318、#4090）——產生的事件派送器也以與 CLI 命令相同的方式為 stdin 設上限（#4337）。一項 CI 防護現在**要求內建擴充功能變更時提升版本**（#4395），社群投稿工作流程也再次獲得強化（#4510）。這些強化是預防工作，隨著基本元素與目錄持續開啟新的介面而到來。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 代理整合

代理陣容持續成長。內建整合目錄（`integrations/catalog.json`）從 **38 個成長至 42 個**，本月新增四個代理——**Docker Agent**（#4302）、**DeepSeek Harness**（#4336）、**Muse Code**（#4413）與 **MiniMax Code**（#4645）。驗證新增了 **Bitbucket 提供者**（#4629）。在新條目之外，整合*派送*工作精煉了既有代理：**Antigravity** CLI 相容性與執行旗標（#4612）、**Forge** 派送縮減為僅提示旗標（#4668）、**Vibe** 移除了無效的 `--model`／`--output-format` 旗標（#4784）、**Bob** 命令透過 `bob run` 派送（#4492），以及僅技能的 **Alquimia** 代理學會算繪 `/speckit-<name>` 呼叫（#4137）。在 Windows 上，`specify init` 現在會偵測 `copilot.exe`，而非假設為 `copilot.cmd`（#4758）；**通用整合**則學會註冊擴充命令與技能並算繪 `SKILL.md`（#4785、#4562）。前幾個月的模式依然成立——存續的整合對每個代理愈來愈原生，而不只是數量愈來愈多。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 擴充功能、預設集與套件組生態系

社群擴充目錄在 9 月從 162 個成長至 **176 個條目**——淨增十四個。社群預設集從 34 個成長至 **40 個**，社群工作流程維持 **2 個**，社群**套件組達到 3 個**。

本月最有說服力的訊號，是目錄中出現了完整的**多產物套件**。一條**產品定義通道**從 ProductShape 專案浮現：**ProductShape PRODUCT 工作流程**（#4485）與 **Product Definition as Code (PDaC)**（#4514）將規格奠基於有出處的產品模型。而 **Agentstandards** 家族升級為完整的多產物套件——**Architecture Council** 擴充功能（#4730）、**Task Gate** 預設集（#4749），以及將它們打包在一起的套件組（#4751）——這是 SpecAssay 以來的第一個新套件組。

依類別值得注意的 9 月新增項目：

- **驗證、審查與測試**：Vurnix Honest Gate（確定性的編譯／匯入／測試計數關卡）、Evaluator Contract、ThreatSpec（STRIDE + AI/ML 威脅建模）、Applied Epistemic Engineering、Test Validation（Playwright E2E）、Axi（瀏覽器審查介面）
- **方法論與生命週期**：OpenUP Governed Lifecycle（+ OpenUP Governance 預設集）、ProductShape、Product Definition as Code、Spec Kit Design System
- **需求、收件與付款**：GitHub Issue Triage、Agentstandards Architecture Council、AgentPay Pre-Pay Audit（402 條款稽核）
- **治理預設集**：Secure Development Assurance、NIEM Information Exchanges、Database Standards、Project Statistics Governance、Agentstandards Task Gate（外加上述 OpenUP Governance 預設集）

目錄在本月也有大量維護：**SpecAssay**（擴充功能、預設集與套件組至 v0.5.2）、**DocGuard**、**Azure Cosmos DB**（至 v0.2.0）、**adrkit**、**MAQA**、**Ralph Loop**、**Figma Starter**、**BrownKit**，以及 **Intake** 治理預設集家族，全都有迭代。 [\[github.com\]](https://github.github.io/spec-kit/community/extensions.html)

### 文件與文件網站

9 月的文件偏向簡化與在地化。**README 圍繞三個核心流程予以簡化**（#4591），**日語（日本語）README** 隨之登場（#4560），README 也新增了**星數歷史圖表**（#4672）。操作指引擴充了：更新的**發佈流程指南**（#4502）、收緊為須包含代理、模型與設定的 **AI 揭露要求**（#4512）、**合約驅動開發**解說（#4616）、**代理式 SDLC 解說**（#4774），以及專案如何**在自身上 dogfood Spec Kit** 的文件（#4381）。**擴充目錄信任模型**再次獲得釐清——更正了一項工作流程發佈的安全審查主張，並新增目錄審核說明（#4736）——重申社群目錄僅供探索，而**過時政策**也縮短為 60 天標記過時／30 天關閉（#4503）。 [\[github.com\]](https://github.com/github/spec-kit/releases)

## 社群與內容

### 媒體與產業報導

9 月帶來了大量報導，而且——與 7 月和 8 月不同——包含了一篇專門的第一方 Microsoft（非維護者）文章。

**Microsoft DevBlogs／Azure Cosmos DB**（9 月 21 日）發表了本月的重頭戲——*「Spec-Driven Development comes to Azure Cosmos DB: The First Database Extension for GitHub Spec Kit」*，作者為 Theo van Kraay（Cosmos DB 工程團隊 Principal Program Manager）。文章宣佈了公開預覽中的 Cosmos DB 擴充功能——Spec Kit 生態系中的第一個*資料庫*擴充功能——它為分割、RU 與索引指引新增了 `before_implement`／`after_implement` hook。值得注意的是，其成效章節異常坦率：最佳實務遵循度測得約提升 10 個百分點，但端到端表現與單用 Spec Kit 大致相當，且仍需要人工審查。 [\[devblogs.microsoft.com\]](https://devblogs.microsoft.com/cosmosdb/spec-driven-development-comes-to-azure-cosmos-db-the-first-database-extension-for-github-spec-kit/)

**Jesse Liberty**（Microsoft MVP）發表了兩篇文章——9 月 1 日的解說文章，逐步走過 Specify CLI 與憲章／規格／計畫／任務鏈；以及 9 月 17 日的實地報告，描述用 Spec Kit 搭配 Copilot 新增 Cosmos 支援的記憶功能時被*「徹底驚艷」*。 [\[jesseliberty.com\]](https://jesseliberty.com/2026/09/17/spec-driven-development/) **Tproger**（俄語，9 月 11 日）對 1.0.x 系列做了深入的新聞分析——六命令工作流程、擴充功能／預設集／套件組，以及「不承諾穩定性」的立場——並衡量了完整鏈條何時會過於繁重。 [\[tproger.ru\]](https://tproger.ru/news/spec-kit-1-0-i-eshhyo-desyat-ii-repozitoriev-sobravwih-zvyozdy-za-n)

### 開發者文章與實地報告

9 月的文章偏向 token 成本核算、誠實的實地報告，以及一股強勁的多語系潮流，橫跨日語、韓語、中文、葡萄牙語、義大利語與泰語。

值得注意的文章：

- **Chew Loong Nian**（Medium，9 月 13 日）——*「GitHub Spec Kit Ships an 18,799-Token Workflow. One Preset Collapses It to 863」*，公平地核算了 Spec Kit 冗長斜線命令範本的收穫與成本，並與內建的 `lean` 預設集對照衡量。 [\[medium.com\]](https://medium.com/@chewloongnian/github-spec-kit-ships-an-18-799-token-workflow-one-preset-collapses-it-to-863-b38211e85f44)
- **Alfredo Perez**（DEV Community，9 月 11 日）——*「I Wrote 238 Specs and Never Read One Again」*，肯定 Spec Kit 迫使決策落於紙面，隨後批評已完成的規格如何累積並「說謊」，促使他提出以 spec-kit 為基礎的「活規格」作法——其後於 9 月 28 日發表了其 **SpecKit Companion** 擴充功能的教學。 [\[dev.to\]](https://dev.to/alfredoperez/i-wrote-238-specs-and-never-read-one-again-5705)
- **Serge Aleynikov**（Medium，9 月 18 日）——*「Beyond Vibe Coding: Spec-Driven AI Frameworks for Tech Debt」*，在混亂的程式碼庫上實地測試五種 SDD 框架，其中 GitHub Spec Kit 一節稱其為最乾淨的 SDD+TDD 組合，儘管對單人工作較重。 [\[medium.com\]](https://medium.com/@saleyn/beyond-vibe-coding-spec-driven-ai-frameworks-for-tech-debt-cab9cc07ae65)
- **Robert Wimmer**（tauceti.blog，9 月 15 日）——一篇 7,500 字的動手實作，在 Copilot 上用 Spec Kit 打造一個 greenfield Go 應用程式，衡量完整的 specify→converge 工作流程與其 token 成本，以及代理交付的錯誤。 [\[tauceti.blog\]](https://www.tauceti.blog/posts/spec-driven-development-with-spec-kit/)
- **ta_kawano**（note.com，9 月 13–21 日彙整，日語）——「要求AI」系列的 9 月續篇，將 Spec Kit 用於真實的人資／出勤使用情境，與 Kiro 比較，並把其行為對照到一篇需求工程論文的風險（規格過度擬合、自動化偏誤、規格債）。 [\[note.com\]](https://note.com/takawano/n/nc45c05d4c5d8)
- **Graziano**（Gomoot，9 月 28 日，義大利語）——完整 constitution→converge 流程的動手導覽，外加 `bug`／`assess` 擴充功能與 brownfield `--here` 初始化，推薦用於多日／多代理工作，同時衡量時間與 token 成本。 [\[gomoot.com\]](https://gomoot.com/spec-kit-come-far-lavorare-gli-agenti-ai-su-una-specifica-invece-che-su-un-prompt-improvvisato/)

其他報導出現在 DEV Community（Ayush Bisht、Rost Glukhov 的 gstack、Dmitry Amelchenko、Manjush、Abhishek Banerjee）、Medium（Prince Kumar Sharma、Kristopher Dunham、Dean Lin）、Qiita／Zenn（日語）、Naver／velog／GPTers（韓語）、CSDN（中文），以及葡萄牙語與泰語媒體——包括數篇工具正面對決比較，以及反覆出現的 token 成本與文件增生批評。 [\[dev.to\]](https://dev.to/dmitryame/stop-asking-which-agentic-coding-methodology-to-use-1bij)

### 以數字看社群成長

| 指標 | 9 月初 | 9 月底 | 變化 |
| --- | --- | --- | --- |
| GitHub 星數 | ~132,000 | ~139,700 | +~7,700（+6%） |
| Fork 數 | ~11,900 | ~12,500 | +~600 |
| 貢獻者 | ~270 | ~315 | +~45 |
| 版本（總計） | 215 | 226 | +11（v1.0.3–v1.0.13） |
| 社群擴充功能 | 162 | 176 | +14 |
| 社群預設集 | 34 | 40 | +6 |
| 社群工作流程 | 2 | 2 | 持平 |
| 社群套件組 | 2 | 3 | +1 |
| 代理整合（目錄） | 38 | 42 | +4 |
| Discussions（總計） | ~482 | ~509 | +~27 |

## SDD 生態系與產業趨勢

### 第一個資料庫擴充功能

9 月締造了生態系首例：**Microsoft 發佈了 Spec Kit 的第一個*資料庫*擴充功能**——公開預覽中的 Azure Cosmos DB（見上文）。GitHub 與 Microsoft 是同一家公司，因此這是第一方，而非外部採用——但它本身仍值得注意：一個與 Spec Kit 維護者不同的 Microsoft 產品團隊，選擇以 Spec Kit 擴充功能、而非獨立工具的形式，發佈其資料庫最佳實務指引，開啟了新的擴充類別。真正的第三方訊號在別處——在社群目錄中，它在本月新增了十四個獨立擴充功能。 [\[devblogs.microsoft.com\]](https://devblogs.microsoft.com/cosmosdb/spec-driven-development-comes-to-azure-cosmos-db-the-first-database-extension-for-github-spec-kit/)

### 競爭格局

「該選哪個 SDD 工具？」這個類型依然占主導地位，而 9 月最具實質內容的文章延續了 8 月的轉向，從功能對決走向平台與治理框架。實地指南（Aleynikov 的五框架測試、Dmitry Amelchenko 的方法論堆疊）將 Spec Kit 定位為徹底、治理導向的選項——與模型無關、開源，且擁有最廣的產物目錄——同時點出其反覆出現的取捨。本月，這項取捨更聚焦於 **token 成本**，數篇實地報告直接測量了它——這是 Spec Kit 徹底作風反覆付出的代價。 [\[medium.com\]](https://medium.com/@chewloongnian/github-spec-kit-ships-an-18-799-token-workflow-one-preset-collapses-it-to-863-b38211e85f44)

## 藍圖

以下抽樣列出實質的開放工作與提案——進行中的 pull request、已提出的功能 issue 與活躍的討論（全數公開，皆非承諾）：

- **目錄版本管理**——[支援每個 ID 跨目錄類型的多個版本](https://github.com/github/spec-kit/issues/4719)，一個由維護者提出的 issue，以依家族切分的方式交付；擴充功能與工作流程的切分已完成，預設集、步驟、套件組與整合的切分仍開放中。
- **更細的預設集組合**——一個開放中的 pull request 要[支援 regex 資源選取器](https://github.com/github/spec-kit/pull/4776)，讓預設集能以模式、而非確切名稱，鎖定命令、範本與指令稿（關閉 issue #4659）。
- **工作流程組合與自訂步驟**——一個開放中的 pull request 新增了[自訂步驟類型的本機 `--dev` 安裝](https://github.com/github/spec-kit/pull/4769)，同時討論也在探索[將已安裝的工作流程作為步驟執行](https://github.com/github/spec-kit/discussions/4647)與[工作流程覆疊的通用選取器](https://github.com/github/spec-kit/discussions/4578)。
- **供整合使用的執行內省**——[支援以執行為範圍存取工作流程執行的定義](https://github.com/github/spec-kit/issues/4792)提議了一個穩定介面，讓外部工具——例如算繪關卡進度的 GitHub Action——不必讀取內部的執行狀態檔案。
- **與代理無關的專案狀態**——[將代理專屬狀態排除在 `.specify/` 之外](https://github.com/github/spec-kit/discussions/4740)衡量了一個團隊（其貢獻者使用不同代理）如何共用儲存庫，而不必提交某個人的代理選擇。
