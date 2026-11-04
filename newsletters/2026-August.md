# Spec Kit - 2026 年 8 月電子報

本期涵蓋 Spec Kit 在 2026 年 8 月的活動——這是專案達到 **1.0.0** 的月份。共發布 10 個版本（v0.15.2 至 v1.0.2），走完 0.16 修補系列後跨越里程碑：**8 月 21 日，在首次 commit 滿一年之際，Spec Kit 發布了 v1.0.0**，同日接續 v1.0.1，並於 8 月 31 日發布 v1.0.2。頭條與其說是功能，不如說是一種框架——1.0.0 標誌著專案的**五個基本元件**（整合、擴充功能、預設集、工作流程與工作流程步驟）、其下的型錄／治理層，以及封閉的 `specify → … → converge` 核心迴圈，融合成一個系統，而非任何單一新功能。在其周圍，本月有三股潮流貫穿：**Copilot 技能預設終於翻轉**（`specify init --integration copilot` 現在安裝技能）、**`feature-assess` 代理工作流程**讓專案透過執行*自身*來分類收到的功能請求，以及 7 月的**安全性與穩健性行動**持續成為例行——有界讀取、消除 TOCTOU、URL 連接埠驗證、事件 hook 路徑限制，以及廣泛的非 UTF-8 韌性掃蕩。在外部方面，報導轉向里程碑：一篇重頭的「Spec Kit 如何成為五個基本元件」1.0.0 回顧、一波多框架實地指南，以及——值得注意的是——7 月在 Spec Kit 周圍形成的**配套工具**開始**進入官方型錄**。下表為摘要，後文接續詳述。

| **Spec Kit 核心（2026 年 8 月）** | **社群與內容** | **SDD 生態系與下一步** |
| --- | --- | --- |
| 共發布 10 個版本（v0.15.2–v1.0.2），於 8 月 21 日達到 **v1.0.0** 里程碑——專案首次 commit 滿一年——同日發布 v1.0.1，8 月 31 日發布 v1.0.2。1.0.0 框架的是**五個基本元件**之間的一致性，而非功能發布。頭條包括：**Copilot 技能預設翻轉**（在 `init` 時是技能而非 markdown 命令）、**`feature-assess` 代理工作流程**（安裝並執行 Spec Kit 來分類功能請求）、資訊清單 **`provides.templates`／`provides.scripts`** 與命令時憲章範本，以及持續的**安全性強化**浪潮。內建整合型錄隨新的 Command Code 代理達到 **38 個**。儲存庫星數從約 124,655 成長至 **約 132,000 顆星**。 [\[github.com\]](https://github.com/github/spec-kit/releases) | 社群擴充功能型錄從 144 個成長至 **162 個條目**；預設集達到 **34 個**，社群工作流程維持 **2 個**，套件組翻倍至 **2 個**。報導以 1.0.0 里程碑為中心——一篇深入的「從一條管線到五個基本元件」回顧——加上多框架實地指南，以及日益強烈的「是否太重／誰來驗證規格？」批評。目前已有 **約 270 位貢獻者**。 | 7 月的**配套工具開始進入型錄**——SpecJudge（模型適配尺寸）與 SpecAssay 套件（多產物擴充功能 + 預設集 + 套件組）列入型錄，證明第三方層正整合至官方生態系。1.0.0「一致性，而非永久性」的框架——README 仍將目標歸於「Experimental」之下——將競爭問題從「哪款工具」重新框架為「哪個平台」。 |

***

> **從一條管線到五個基本元件。** 如果說 7 月是整合，8 月就是標點。本月的實質內容是累積的——10 個版本的強化、封裝、組合與整合工作——但其意義在於包裝上的數字。v1.0.0 在首次 commit 滿一年當日落地，維護者異常直白地表示，它*不是*功能版本，也*不是*穩定性承諾：README 仍將專案的抱負歸於「Experimental Goals」之下，刻意不改名。1.0.0 標誌的是一致性。這個工具在 2 月起初是線性的 `specify → plan → tasks → implement` 管線，現在建立在五個可組合的基本元件之上——整合、擴充功能、預設集、工作流程與工作流程步驟——其下有一個具優先順序的型錄系統，核心迴圈也已封閉，執行 `converge` 來詢問「這真的完成了嗎？」8 月其餘部分朝相同方向推進：Copilot 整合預設翻轉為技能、`feature-assess` 工作流程讓專案分類自己的待辦清單，安全性行動則強化了基本元件開啟的每個新介面。與此同時，7 月在 Spec Kit 周圍湧現的配套工具，開始出現在型錄*之內*。凡此種種，都離不開社群——貢獻者、擴充功能與預設集作者、套件組建置者、代理整合維護者，以及以 20 多種語言撰寫文章的實踐者。謝謝大家。

## Spec Kit 專案更新

### 版本總覽

**v0.15.2–v0.16.5**（8 月 3–19 日）在里程碑之前執行本月的修補節奏。功能工作集中於**安裝、上手與組合**：`specify init` 新增 **`--extension` 旗標**，供在 init 時選擇啟用擴充功能（#3914），擴充功能在加入／啟用時**建立其設定範本鷹架**（#2000），受管理的 **`.specify/.gitignore`** 也在 init 時建立鷹架（#4000）。兩項整合選擇變更同時落地——預設 init 整合變得**能透過 `SPECKIT_INTEGRATION_DEFAULT` 覆寫**（#3952），以及本月低調的頭條，**Copilot 整合現在預設使用技能**（#3976），完成了自 7 月以來預告的技能預設推出。組合層走向成熟：擴充功能資訊清單現在接受 **`provides.templates` 與 `provides.scripts`**（#4012），預設集**在命令時解析憲章範本**（#3984），`specify` **依解析／優先順序列出預設集**（#4104）。在其之下，深入的穩健性工作強化了登錄、資訊清單、bundler 與工作流程引擎對非 UTF-8 與無法讀取輸入的處理。 [\[github.com\]](https://github.com/github/spec-kit/releases)

**v1.0.0–v1.0.2**（8 月 21–31 日）跨越里程碑。**v1.0.0**（#4246）於 8 月 21 日發布——專案首次 commit 滿一年——**v1.0.1** 同日發布，**v1.0.2** 於 8 月 31 日發布。這些版本將這兩週的工作流程、型錄、bundler、跨平台與整合修正帶入已發布的 1.0.0 系列，並附有為此刻打造的文件集：**一週年標記**（#4260）、**專案歷史頁面**（#4262，追溯從線性管線到五個基本元件的弧線）、**品牌刷新**（以 Spec Kit 標誌取代 DocFX 主題，#4264）、**工作流程快速入門指南**（#4258），以及**既有專案採用**的操作指引（#4263）。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 1.0.0 里程碑：一致性，而非永久性

8 月的頭條是 **v1.0.0**（#4246），於 8 月 21 日發布——Spec Kit 首次 commit 滿一年當日——並緊接著 v1.0.1。其框架比數字更重要：1.0.0 明確**不是功能版本，也不是穩定性承諾**。專案新的[歷史頁面](https://github.com/github/spec-kit/blob/main/docs/history.md)闡述的論點是，主版本號過去是對抗破壞性變更成本的保險——而代理已讓該成本崩解，因為你能將代理指向 diff，它就會更新呼叫端。這個版本標誌的是**五個基本元件之間的一致性**，而非永久性；README 仍將專案的抱負歸於「Experimental Goals」之下，刻意不改名。

融合成形的，是工具的形狀。Spec Kit 在 2026 年 2 月起初是線性管線——`/speckit.specify`、`/speckit.plan`、`/speckit.tasks`、`/speckit.implement`——程式代理由旗標選擇。到了 1.0.0，它建立在**五個可組合的基本元件**之上：**整合**（代理成為受登錄支援的外掛，寫入經雜湊追蹤的檔案）、**擴充功能**（透過 `extension.yml` 資訊清單提供命令、範本、指令碼與 hook）、**預設集**（對既有核心內容進行 prepend／append／wrap／replace 組合）、**工作流程**（specify 至 implement 的序列現在是可替換的 YAML 定義，而非寫死的控制流程），以及**工作流程步驟**（任何社群步驟類型都能實作的小型介面）。其下是單一具優先順序的**型錄**系統——環境變數 → 專案設定 → 使用者設定 → 內建——統一治理全部五者的探索與安裝政策，內建的 `community` 型錄在設計上僅供探索：維護者驗證條目格式正確，而非其程式碼安全。在基本元件之上，核心迴圈於 6 月以 `/speckit.converge` 封閉，它對照規格、計畫與任務評估已發布的程式碼，並附加缺少的工作——這是對該工具最常被引用批評「誰來驗證規格？」的回答。1.0.0 的核心序列現在是 constitution → specify → clarify → plan → checklist → tasks → analyze → implement → converge，其中 clarify／checklist／analyze 為選擇性閘門。 [\[medium.com\]](https://stn1slv.medium.com/spec-kit-reaches-1-0-from-one-pipeline-to-five-primitives-f7bb6359e501)

### Copilot 技能預設翻轉

本月低調的結構性變更，是 **Copilot 技能預設推出**的完成。`specify init --integration copilot` 現在**預設安裝 `speckit-*` 技能**（#3976），而非舊有的 markdown 命令版面配置，且預設 init 整合**能透過 `SPECKIT_INTEGRATION_DEFAULT` 覆寫**（#3952），讓團隊無需觸碰旗標就能釘選不同的預設值。這正是 7 月版本說明警告即將到來的翻轉：支援技能的代理安裝技能，markdown 命令版面配置成為舊有路徑，兩種版面配置都持續透過相同的資訊清單系統流動。它讓專案的 Copilot 介面穩固地落在原生技能模式上，而更廣泛的整合層全年都朝此收斂。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### Spec Kit 分類自身：`feature-assess` 工作流程

8 月最具品牌特色的是 **`feature-assess` 代理工作流程**（#4186），它**安裝並執行 Spec Kit，端對端評估收到的功能請求**。該工作流程不讓人從零開始閱讀每個新請求，而是佈建 `uv` 與 Python（#4193）、建立 Spec Kit CLI 與 `assess` 擴充功能（#4195），並針對請求執行 7 月的 `assess`「Idea Assessment Pipeline」——intake → research → define → shape → decide——在維護者接觸它之前就完成。初次落地後，很快接續了讓它在 CI 中可靠執行所需的佈建與每日額度預算修正（#4193、#4195、#4222）。這是專案**以自身基本元件自我驗證**最清晰的實例：這個幫助團隊決定「我們該建置這個嗎？」的工具，現在已接入 Spec Kit 自身的分類流程，對標籤化的功能請求議題執行 `assess` 管線，並將每個階段回報。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 組合層走向成熟

除了里程碑之外，8 月的工程將**組合基本元件**推向日常實用。擴充功能資訊清單現在接受 **`provides.templates` 與 `provides.scripts`**（#4012），讓擴充功能能以出貨命令相同的方式出貨範本與指令碼覆寫，重複的 `provides` 名稱會預先被拒絕（#4016、#4191）。預設集**在命令時解析其憲章範本**，而非急切解析（#3984），在包裝時從核心範本繼承 `argument-hint`，因此包裝不再無聲地遺失它（#3996），`specify` 現在**依解析／優先順序列出預設集**，讓覆寫一目瞭然（#4104）。具命名空間的預設集命令以自包含方式建立鷹架（#4082），bundler 現在讀取權威的 `default_integration` 欄位，而非僅讀其舊有別名（#3880）。其主軸與 1.0.0 的故事相同：核心日益成為一組**具名、可覆寫的插槽**，供預設集與擴充功能組合，而非要被取代的單體。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 安全性與穩健性行動持續

7 月的強化浪潮延續至 8 月，成為常設紀律。**有界 I／O** 延伸至擴充功能型錄／下載路徑（#3775）、整合型錄擷取（#3812、#3818）與套件組下載（#3764），**stdin 讀取上限設為 1 MiB**，以封閉 DoS 路徑（#3857）。**消除競態**移除了檔案解除連結（#3819）、zip 封裝（#3855）與 `RunState.load`（#3839）中的 TOCTOU 窗口。**URL 與主機強化**讓驗證層將確切主機模式視為字面值（#4108），並在本月稍晚，於預設集型錄與憑證比對中，除了主機名稱外也驗證 URL **連接埠**，同時**事件 hook 指令碼路徑現在被限制於專案樹之內**（#4133），社群提交工作流程的輸出允許清單也獲得收緊（#4103）。

與此並行的是廣泛的**非 UTF-8 與「大聲失敗」韌性掃蕩**：預設集與擴充功能登錄、資訊清單、舊有命令、事件、hook `config.toml`、解析器層與型錄回應，現在全都在格式錯誤、無法讀取或編碼錯誤的輸入下**優雅降級而非拋出例外**（#3896、#3955、#3959、#3900、#3998、#3960、#3962、#3834、#3897、#3957、#3963、#3943、#3980、#3902、#4011、#3958）。工作流程驗證同步變得更嚴格——非字串步驟類型、虛假的非對應覆寫與整合描述元、空條件區塊與未經驗證的調度預設值，現在都會以清晰錯誤被拒絕（#4111、#3884、#4187、#4182、#4181）——一項使用者可見的修正也讓 `specify init` 不再於非互動代理環境中**卡在方向鍵選擇器**（#4178）。這些強化是預防，隨著基本元件開啟新介面而到來。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 代理整合

代理組合持續成長。內建整合型錄（`integrations/catalog.json`）從 **37 個成長至 38 個**，新增一個代理——**Command Code** 整合（#4019）。與此同時，既有型錄條目的整合*實作*工作也落地：**Junie** 整合模組以點轉連字號的命令格式實作（#4073），**Mistral Vibe**（`vibe`）整合達到與 Claude 同等水準（#4075），**Qoder CLI 整合遷移至技能版面配置**，供 Qoder IDE 1.24+ 使用（#4205）。既有整合進一步精煉：Claude 與 Alquimia 的 argument-hint 注入變得**能感知折疊**，處理冗長、折疊的描述（#4045、#4063），goose 命令現在透過 `goose run` 調度（#3781，關閉存在 300 天的 #2416），Kimi 保留非 UTF-8 的使用者技能（#3895）。1.0.0 文件列出 **38 個整合**，過往數月的模式維持不變——存續的整合持續更原生於每個代理，而非僅僅數量更多。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 擴充功能、預設集與套件組生態系

社群擴充功能型錄在 8 月從 144 個成長至 **162 個條目**——淨增加 18 個。社群預設集從 29 個成長至 **34 個**，社群工作流程維持 **2 個**，社群**套件組從 1 個翻倍至 2 個**。

本月最具啟示性的訊號，是 **7 月的配套工具進入官方型錄**。**SpecJudge**——讀取 Spec Kit 憲章／規格／任務產物以推薦適配尺寸模型的 CLI，已在 7 月電子報中介紹——列入型錄成為擴充功能（#4079）。**SpecAssay** 則以**多產物套件**形式到來：擴充功能（SpecAssay Check，#4113）、預設集（#4123）與**套件組**（#4125）——第二個列入型錄的社群套件組。7 月在 Spec Kit *周圍*形成的第三方層，正整合*進入*生態系。

依類別列出的值得注意的型錄新增與更新：

- **驗證、審查與治理**：Architecture Governance、SpecAssay Check、Taco Review（人工審查封裝）、adrkit（ADR 撰寫）
- **需求與接收**：SpecKit Grill Me（更徹底的釐清技能）、Pre-Spec Cards、Charter（已更新）
- **知識、記憶與清單**：DUBSAR Memory、Spec Inventory、spec-kit-atlas、Keel Discovery
- **外部追蹤工具與橋接**：Jira Mirror、AgentDocx、AgentPay x402（支出控制）、Azure Cosmos DB 程式碼產生
- **模型路由與尺寸**：SpecJudge、Model Routing Governance（預設集）、Closed Vocabulary Check（預設集）

型錄也展現大量維護：**Archive**（至 v1.3.0）、**Reconcile**（v1.2.1）、**Security Review**（v2.0.0）、**Architecture Guard**（v2.3.6）、**MAQA**、**Superspec** 與 **Spec Kit Figma** 橋接都歷經迭代，龐大的**治理預設集**家族——Security、Architecture、iSAQB、A11Y、Cross-Platform、Agent-Parity，以及 Intake 與 Autonomous-Run 套件——推動協調版本升級。 [\[github.com\]](https://github.github.io/spec-kit/community/extensions.html)

### 文件與文件網站

8 月的文件圍繞里程碑建立。**一週年標記**（#4260）、追溯管線至基本元件弧線的**專案歷史頁面**（#4262），以及至 Spec Kit 標誌的**品牌刷新**（#4264），共同框架了 1.0.0 版本。實用指引擴大：**工作流程快速入門指南**（#4258）、供工作流程使用的 **Python init 指令碼**文件（#4331），以及**既有專案採用**指南（#4263）。**擴充功能型錄信任模式**在文件、說明與訊息中獲得闡明（#4177），強化社群型錄僅供探索的本質，從**自訂套件索引**安裝 `specify-cli` 也已寫入文件（#4032）。 [\[github.com\]](https://github.com/github/spec-kit/releases)

## 社群與內容

### 媒體與產業報導

8 月的報導以 1.0.0 里程碑為中心，組合接續 7 月轉向比較文章、實地指南與尖銳「是否太重？」批評的趨勢。8 月沒有出現第一方 Microsoft 或 GitHub（非維護者）文章；最接近的仍是 6 月的 Microsoft Developer Blog 文章。

**Stanislav Deviatov**（Medium，8 月 24 日）發布了本月重頭文章，標題為 *「Spec Kit Reaches 1.0: From One Pipeline to Five Primitives」*——一篇深入、資料豐富的回顧（EPAM 解決方案架構師），追溯 Spec Kit 如何從線性管線演進為五個基本元件加上型錄與 `/speckit.converge` 迴圈。它肯定這個方向，同時對「1.0.0 = 穩定」的主張、超越機械式呼叫端編輯的真實遷移成本，以及未強制執行的信任邊界提出保留。這是對里程碑意義最清晰的外部闡述。 [\[medium.com\]](https://stn1slv.medium.com/spec-kit-reaches-1-0-from-one-pipeline-to-five-primitives-f7bb6359e501)

**Roan Brasil Monteiro**（Medium，8 月 20 日）發布了 21 分鐘的 *BMAD、Spec Kit、OpenSpec 與 Kiro 實地指南*，以「流程太多燒錢，太少燒更多」為框架，將 Spec Kit 定位為四個 SDD 框架中徹底、較重的選項。 [\[medium.com\]](https://medium.com/@roanmonteiro/bmad-spec-kit-openspec-kiro-a-field-guide-to-getting-real-work-out-of-ai-coding-agents-b17833c24b3f)

**百度百家號**（AI 釘子鋪，8 月 23 日）刊登了五個 SDD 框架的半年成長率評測，肯定 Spec Kit 的 GitHub／Microsoft 品牌拉力與 14 個以上代理支援，但放大了 Martin Fowler「每份規格 8 個以上 markdown 檔案」的批評，主張其成長部分是「品牌溢價」。 [\[baijiahao.baidu.com\]](https://baijiahao.baidu.com/s?id=1874316315966110702) **Andrew**（DEV Community，8 月 28 日）在評測 OpenSpec 時，實質地以 Spec Kit 作為主要比較對象——引用 131,957 顆星、階段閘門、Python 需求與更大的擴充功能型錄。 [\[dev.to\]](https://dev.to/andrew-ooo/openspec-review-spec-driven-dev-without-the-ceremony-8jb)

### 開發者文章與實地報告

8 月的文章偏向誠實的、實際使用後的批評，有數篇第一手實地報告，日文、韓文、中文、西班牙文與泰文的多語言潮流也很強勁。

值得注意的文章：

- **Lusivision**（DEV Community，8 月 28 日）——*「Spec-Driven Development: The New AI Coding Workflow」*，一篇以 Spec Kit 四個閘門階段為核心載體的 SDD 總覽，誠實指出額外負擔在何處獲得回報。 [\[dev.to\]](https://dev.to/lusivision/spec-driven-development-the-new-ai-coding-workflow-24lh)
- **chae_eun_ini**（velog，8 月 26 日，韓文）——一篇坦率的實地報告，其中 13 個功能讓 `specs/` 成長至 12,931 行（占 17,590 行 `src/` 的 73%）；結論是真正的問題在於完成的規格文件讓人「無事可決、只能核准」，並記錄了**離開 Spec Kit、轉向自建的人本鷹架**。 [\[velog.io\]](https://velog.io/@chae_eun_ini/Spec-Kit%EC%97%90%EC%84%9C-%EC%9E%90%EC%B2%B4-%EC%A0%9C%EC%9E%91-%ED%95%98%EB%84%A4%EC%8A%A4%EB%A1%9C-%EA%B7%B8-%EC%82%AC%EC%9D%B4-%EA%B3%BC%EB%8F%84%EA%B8%B0%EC%9D%98-%EA%B8%B0%EB%A1%9D)
- **ta_kawano**（note.com，8 月 10 日，日文）——「要求 AI」系列整合的八篇續作，嚴謹衡量 Spec Kit 新增一項需求的成本／權杖／時間（約 $31、約 34 分鐘；301→331 項測試），結論是 SDD 涵蓋「規格→程式碼」，但將**需求引出留在其範圍之外**。 [\[note.com\]](https://note.com/takawano/n/nd01c18c93580)
- **New2026**（Medium，8 月 19 日）——*「AI Coding Frameworks Explained」*，五層「堆疊」心智模型，將 Spec Kit 定位為約 8 個框架中的一個控制層（「它們並非競爭；它們約束不同的部分」）。 [\[medium.com\]](https://new2026.medium.com/ai-coding-frameworks-explained-superpowers-gsd-gstack-ralph-spec-kit-and-the-agentic-3dd92e559636)
- **Katsumata**（Zenn，8 月 24 日，日文）——一位設計師受 Spec Kit 啟發，建置規格驅動的*設計*系統（YAML 元件規格 → 透過 CI 閘門產生 React／CSS／測試／Storybook），坦承指出規格→生產品質在何處崩解。 [\[zenn.dev\]](https://zenn.dev/katsumata/articles/014affaeb272d00aeae6)
- **guillermodelpino.com**（Guillermo del Pino，8 月 15 日，西班牙文）——一篇正面的分析評論，走訪 `constitution → … → implement → converge` 流程，特別指出 `converge` 的「這真的完成了嗎？」步驟，並主張這套紀律即使對非程式設計師也有價值。 [\[guillermodelpino.com\]](https://guillermodelpino.com/repos/spec-kit-github-desarrollo-guiado-por-especificacion)

其他報導出現在 DEV Community（TekMag、Jeffrey Bakker）、Naver／velog／Tistory（韓文）、Qiita／Zenn（日文）、CSDN 與百家號（中文），以及 Vibe Coding Thailand（泰文）——包含數篇 OpenSpec 與 Spec Kit 的正面對決比較，以及反覆出現的文件激增批評。 [\[dev.to\]](https://dev.to/tekmag/githubs-spec-kit-the-open-source-toolkit-bringing-spec-driven-development-to-ai-coding-agents-ede)

### 社群成長數字

| 指標 | 8 月初 | 8 月底 | 變化 |
| --- | --- | --- | --- |
| GitHub 星數 | 124,655 | ~132,000 | +~7,300 (+6%) |
| Fork 數 | 11,125 | ~11,900 | +~775 |
| 貢獻者 | ~258 | ~270 | +~12 |
| 版本（總計） | 205 | 215 | +10 (v0.15.2–v1.0.2) |
| 社群擴充功能 | 144 | 162 | +18 |
| 社群預設集 | 29 | 34 | +5 |
| 社群工作流程 | 2 | 2 | 持平 |
| 社群套件組 | 1 | 2 | +1 |
| 代理整合（型錄） | 37 | 38 | +1 (Command Code) |
| 討論（總計） | ~474 | ~482 | +~8 |

## SDD 生態系與產業趨勢

### 從配套工具到型錄條目

7 月最清晰的生態系訊號是一種*模式*——獨立開發者在 Spec Kit 產物之上建置工具。8 月的訊號是該模式**正在整合**：這些配套工具開始出現在官方型錄中。**SpecJudge**（模型適配尺寸）列入型錄成為擴充功能，**SpecAssay** 則以完整的多產物套件落地——擴充功能、預設集，以及生態系的第二個套件組。現在 162 個列入型錄的擴充功能中，最響亮的主題仍是驗證與品質（gate、review、validate、drift、evidence、sync），而 1.0.0 的型錄設計——僅供探索的社群清單、具優先順序晉升至組織自身經驗證型錄——將該需求轉為可治理的管線，而非不受管理的蔓延。社群提案，型錄衡量成長，核心晉升贏家；`/speckit.converge`（drift → 核心迴圈）是其範本，8 月的配套工具接收則是該模式的重演。 [\[github.com\]](https://github.github.io/spec-kit/community/extensions.html)

### 競爭格局

「該選哪款 SDD 工具？」類型仍占主導，但 1.0.0 改變了其框架。過往數月進行工具對工具的功能大比拚，8 月最具實質內容的文章——Deviatov 的回顧、Monteiro 的實地指南、百家號成長評測——日益主張各框架正**收斂至相同的基本元件**，這將問題從「哪款工具獲勝」轉向「**哪個平台與治理模式**」。在這個軸線上，Spec Kit 的五基本元件介面、其統一的型錄／信任模式、其代理中立性，以及現正整合至型錄的配套層，是其差異化所在。反覆出現的反批評維持穩定，甚至圍繞里程碑變得更尖銳：文件激增、認知負荷，以及「誰來驗證規格，誰又讀得完這一切？」仍是一致的取捨——本月最尖銳的實地報告（chae_eun_ini）記錄了一個團隊離開 Spec Kit、轉向更輕量的自建鷹架。 [\[medium.com\]](https://stn1slv.medium.com/spec-kit-reaches-1-0-from-one-pipeline-to-five-primitives-f7bb6359e501)

## 路線圖

正在討論或進行中、供未來發展的領域：

- **1.0.0 之後，信任邊界是頭條工作**——社群型錄僅供探索，維護者稱讓指引與強制執行的邊界*清晰可讀*是最有價值的未竟工作。預期將持續投資於組織擁有的型錄、晉升管線與來源，讓「什麼可安裝」能悄然成為「我們核准了什麼」。 [\[medium.com\]](https://stn1slv.medium.com/spec-kit-reaches-1-0-from-one-pipeline-to-five-primitives-f7bb6359e501)
- **更深的組合基本元件**——8 月的 `provides.templates`／`provides.scripts`、命令時範本解析與具優先順序的預設集，指向更細粒度、具名的組合點；里程碑後的早期訊號包含可重用的**工作流程插槽**，以及讓**預設集宣告所需的擴充功能**，收緊一層重塑另一層的代數。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **代理自助服務**——`feature-assess` 加入專案在自身上執行的一組既有 Copilot 引擎代理工作流程：`bug-assess → bug-test → bug-fix` 分類管線，以及 `add-community-extension`／`-preset`／`-bundle` 型錄提交自動化。每個都由標籤觸發，並安裝／執行 Spec Kit 或其工具來完成真實的維護工作；隨著專案以自身基本元件自我驗證，預期這些管線將深化。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **Copilot 技能介面**——隨著技能預設現已翻轉、`SPECKIT_INTEGRATION_DEFAULT` 能覆寫，markdown 命令版面配置成為舊有路徑。第一方 [`github/spec-kit-copilot`](https://github.com/github/spec-kit-copilot) 外掛持續探索**視覺化、由 Copilot 驅動的介面**——附即時啟動進度的 Spec Kit Wizard 畫布——將 CLI 的流程轉為互動層。 [\[github.com\]](https://github.com/github/spec-kit-copilot)
- **安全性與穩健性成為例行**——有界讀取／TOCTOU／URL 連接埠／非 UTF-8／大聲失敗行動，現在是常設紀律而非浪潮。隨著介面（bundles、workflows、catalogs、events、integrations）持續成長，維持無無界讀取與優雅降級的不變量是持續的工作。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **體驗簡化**——文件激增與認知負荷仍是 8 月持平評論中最常被提及的單一疑慮（chae_eun_ini、ta_kawano、百家號評測）。`assess` 上游閘門、精簡預設集、`/speckit.converge` 與正在整合的配套工具層都提供了解答；將它們呈現出來，讓新使用者感受 1.0.0 是*一致性*而非*重量*，是持續的機會。 [\[medium.com\]](https://stn1slv.medium.com/spec-kit-reaches-1-0-from-one-pipeline-to-five-primitives-f7bb6359e501)
