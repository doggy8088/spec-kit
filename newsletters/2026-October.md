# Spec Kit - 2026 年 10 月電子報

本期涵蓋 Spec Kit 在 2026 年 10 月的活動——這個月，專案在十個版本中從 v1.0.x 修補系列一路推進至 **v1.1 與 v1.2**。有三股潮流貫穿全月。首先，實驗性的 **MCP 伺服器成為真正的機器對接介面**，具備版本、產物與已安裝工作流程清單的具型別工具。其次，工作流程引擎從執行流程跨越到**組合流程**：本機自訂步驟、可重複使用的運算式篩選器、統一執行樹中的巢狀工作流程、輸出擷取，以及內建 GitHub 步驟。第三，型錄模型同時變得更可重現、也更開放——精確的版本選擇涵蓋了其餘所有產物家族，而外部代理配接器與可包含套件組的套件組拓寬了組合邊界。在更廣泛的 SDD 生態系中，多語言的公開報導——包括一篇第一方 Microsoft 續篇——檢視了流程適配性、審查負擔、產物耐久性與可強制執行的核准。同任務比較則在時間、提示詞、產物數量、驗收檢查與 API 等效成本上加入了具體量測。摘要如下，後文接續詳述。

| **Spec Kit 核心（2026 年 10 月）** | **社群與內容** | **SDD 生態系與下一步** |
| --- | --- | --- |
| 共發布十個版本，橫跨 **v1.1.0–v1.2.5**。頭條：實驗性 MCP 伺服器成熟為具型別的**版本、產物清單、產物資訊與已安裝工作流程清單工具**；工作流程新增**本機自訂步驟、巢狀工作流程執行、輸出擷取、GitHub 步驟與更豐富的運算式**；精確的型錄版本選擇涵蓋預設集、套件組與工作流程步驟；型錄安裝的**外部代理配接器**讓整合超越內建登錄。套件組新增精確的釘選協調與組合。10 月 1 日與 29 日的快照顯示，儲存庫從 139,708 顆星成長至 **143,888 顆星**。 [\[github.com\]](https://github.com/github/spec-kit/releases) | 社群型錄從 176 個擴充功能 ID 成長至 **185 個**，預設集從 40 個增至 **42 個**，並迎來首個社群**工作流程步驟**。公開報導橫跨英文、中文、日文、韓文、西班牙文、葡萄牙文、德文、波蘭文與俄文，以一篇第一方 Microsoft Developer Blog 續篇為首，加上經過量測的框架比較，以及關於審查、遷移、產物維護與流程適配性的實地報告。 | 這個月讓 Spec Kit 看起來不再像提示詞集合，而更像**代理開發的控制平面**：可透過 MCP 檢視、可透過型錄擴充，並可在工作流程、步驟、配接器與套件組層級組合。這也擴大了信任範圍。公開比較日益針對同一任務回報時間、提示詞、產物數量、驗收檢查與工作流程成本。月底的工作聚焦於真正的運算式語法、嚴格的殼層執行、執行範圍的工作流程定義，以及淘汰舊的核心 `taskstoissues` 命令。 |

***

> **控制平面到來。** 9 月教會系統解釋其產物如何組合。10 月先為這套解釋提供了傳輸方式，接著讓系統中更多部分變得可組合。MCP 伺服器能告訴代理正在執行哪個版本、安裝了哪些產物、誰擁有它們的 hook，以及安裝了哪些工作流程。一個工作流程可以包含另一個工作流程。一項整合可以來自型錄，而非核心。一個套件組可以包含另一個套件組。這不是四個互不相關的功能；它們勾勒出開發流程控制平面的輪廓。這項權衡同樣清晰可見。每新增一個可執行邊界，就多一項信任決策；每多一層組合，就多一種失敗模式；而每個徹底的工作流程都會消耗注意力與 token。10 月的公開比較從多個維度量測了這項權衡，而不只是點出它的存在。現在的工作，是讓系統保持可檢視、可重現，並與所做的變更相稱。這一切都離不開社群——貢獻者、型錄作者、整合維護者、工作流程建置者、審查者，以及願意公開分享觀察與成本的實踐者。謝謝大家。

## Spec Kit 專案更新

### 版本總覽

**v1.1.0–v1.2.5**（10 月 2–28 日）共發布十個版本：1.1 系列四個，1.2 系列六個。與 9 月僅有修補版本的節奏不同，10 月跨越了兩個次要版本邊界，同時維持了大致相同的兩到三天發布節奏。第一週確立了 MCP，並在更多型錄家族中完成精確的版本選擇；月中落地了工作流程組合與外部配接器；下半月則鞏固了型錄契約、整合行為、套件組組合與生命週期安全。在 10 月 1 日與 10 月 29 日的快照之間，儲存庫從 139,708 顆星增至 143,888 顆星，fork 從 12,517 個增至 12,881 個。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### MCP 成為一等介面

10 月最具影響力的介面，始於一個**實驗性的 stdio MCP 伺服器**，於 10 月 2 日合併、隨 v1.1.1 發布（[github/spec-kit#4822](https://github.com/github/spec-kit/pull/4822)）。第一版實作提供了版本存取；數日內便新增了具型別的 **`specify_version`** 工具（[github/spec-kit#4864](https://github.com/github/spec-kit/pull/4864)）、有界且可分頁的**產物清單**（[github/spec-kit#4867](https://github.com/github/spec-kit/pull/4867)），以及**產物檢視**（[github/spec-kit#4885](https://github.com/github/spec-kit/pull/4885)）。這些工具與 CLI 共用與傳輸無關的操作，而非為 MCP 重新實作命令行為（[github/spec-kit#4863](https://github.com/github/spec-kit/pull/4863)、[github/spec-kit#4866](https://github.com/github/spec-kit/pull/4866)、[github/spec-kit#4882](https://github.com/github/spec-kit/pull/4882)）。架構已明確記錄在案（[github/spec-kit#4847](https://github.com/github/spec-kit/pull/4847)），一等的 MCP 指引也隨之而來（[github/spec-kit#4969](https://github.com/github/spec-kit/pull/4969)）。

工作流程支援分兩個不同步驟推進。**內部命令清單**先將工作流程 CLI 介面分類，以供未來透過 MCP 暴露，且未註冊新工具（[github/spec-kit#5054](https://github.com/github/spec-kit/pull/5054)）；接著**已安裝工作流程清單**便可透過 MCP 取得（[github/spec-kit#5115](https://github.com/github/spec-kit/pull/5115)）。暴露的工具維持唯讀且僅限本機：它們不暴露工作流程執行或執行狀態。對照 9 月的 `specify artifact` 工作，進展很清晰：先讓組合變得可檢視，再透過具型別的協定讓代理也能取得這份檢視。代理不再需要爬梳 CLI 文字，或從私有檔案推斷專案狀態，就能回答關於已安裝系統的基本問題。 [\[github.com\]](https://github.github.io/spec-kit/reference/mcp.html)

### 工作流程學會組合

工作流程引擎 10 月的變化，比任何單一版本都廣泛。自訂步驟類型現在可從**本機目錄與封存檔**安裝（[github/spec-kit#4769](https://github.com/github/spec-kit/pull/4769)），並獲得了社群提交路徑（[github/spec-kit#4861](https://github.com/github/spec-kit/pull/4861)、[github/spec-kit#4873](https://github.com/github/spec-kit/pull/4873)）。運算式新增了 `upper`、`lower`、`split`、`length` 與 `to_json` 篩選器（[github/spec-kit#4766](https://github.com/github/spec-kit/pull/4766)）、正確的短路求值（[github/spec-kit#4923](https://github.com/github/spec-kit/pull/4923)）、精確的整數處理而非浮點數捨入（[github/spec-kit#5027](https://github.com/github/spec-kit/pull/5027)），以及跨非 ASCII 與無法解碼的殼層輸出、更安全的輸出行為（[github/spec-kit#4877](https://github.com/github/spec-kit/pull/4877)、[github/spec-kit#5048](https://github.com/github/spec-kit/pull/5048)、[github/spec-kit#5064](https://github.com/github/spec-kit/pull/5064)）。命令與提示詞步驟可選擇加入**輸出擷取**（[github/spec-kit#4957](https://github.com/github/spec-kit/pull/4957)）。

結構上的變化是**統一執行樹**（[github/spec-kit#4764](https://github.com/github/spec-kit/pull/4764)）。已安裝的工作流程現在可以在另一個工作流程內作為步驟執行，同時共用狀態、續跑與狀態語意。內建的 **GitHub 步驟**（[github/spec-kit#4905](https://github.com/github/spec-kit/pull/4905)）將明確的議題與 pull request 標籤帶入這棵樹，隨附的 bug 工作流程則在評估、修正與測試周圍新增了生命週期 hook（[github/spec-kit#4878](https://github.com/github/spec-kit/pull/4878)）。到了月底，引擎共暴露十四種內建步驟類型，包括巢狀工作流程、slot、fan-in／fan-out、閘門、迴圈、殼層、提示詞與 GitHub 操作。9 月引入了可重複使用的插入點；10 月讓整個工作流程成為可重複使用的執行單元。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 可重現的型錄、外部配接器與可組合的套件組

9 月為擴充功能與工作流程出貨了精確的型錄版本選擇。10 月則為**預設集**（[github/spec-kit#4823](https://github.com/github/spec-kit/pull/4823)）、**自訂工作流程步驟**（[github/spec-kit#4840](https://github.com/github/spec-kit/pull/4840)）與**套件組**（[github/spec-kit#4849](https://github.com/github/spec-kit/pull/4849)）補齊了這個模式，整合則獲得了具版本的歷史中繼資料（[github/spec-kit#4841](https://github.com/github/spec-kit/pull/4841)）。套件組接著學會協調精確的元件釘選，並拒絕不相容的已安裝版本（[github/spec-kit#4844](https://github.com/github/spec-kit/pull/4844)）；到了月底，還能**參照其他套件組**（[github/spec-kit#5067](https://github.com/github/spec-kit/pull/5067)）。套件模型現在是遞迴的：一個套件組可以組合一組具版本的元件，並重複使用另一個套件組的宣告。

同時，**型錄安裝的外部代理配接器**（[github/spec-kit#4862](https://github.com/github/spec-kit/pull/4862)）將整合生命週期拓展至核心內建配接器之外。安裝、切換、更新與移除，都能透過與內建配接器相同的生命週期，使用型錄提供的代理支援。這是一條有意義的生態系邊界：新增代理不再必然需要一次核心發布。好處是獨立的整合工作可以更快進行；代價是可執行的配接器程式碼加入了擴充功能與自訂步驟，進入專案的信任模型。使用者在安裝或使用第三方元件之前，必須先行審查；社群型錄清單只是探索途徑，不是程式碼稽核或安全性背書。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 整合與身分驗證

內建整合型錄從 42 個增至 **43 個條目**，但這次新增的刻意不是另一個代理。新的 **`none` 整合**（[github/spec-kit#5030](https://github.com/github/spec-kit/pull/5030)）會安裝共用的鷹架，但不提供代理專屬的交付內容，支援那些希望將 Spec Kit 專案結構納入版本控管、同時讓貢獻者自行選擇代理的團隊。身分驗證新增了 **GitHub CLI 認證**（[github/spec-kit#4960](https://github.com/github/spec-kit/pull/4960)），減少已登入 `gh` 的使用者重複設定認證的需求。

既有配接器持續變得更原生。Claude 與 Vibe 新增了 `--no-model-invocation` 選項（[github/spec-kit#4919](https://github.com/github/spec-kit/pull/4919)、[github/spec-kit#5119](https://github.com/github/spec-kit/pull/5119)）；Kimi 與 Pi 修正了 JSON 派送模式（[github/spec-kit#5031](https://github.com/github/spec-kit/pull/5031)、[github/spec-kit#5043](https://github.com/github/spec-kit/pull/5043)）；ZCode 移除了一個不支援的模型旗標（[github/spec-kit#5009](https://github.com/github/spec-kit/pull/5009)）；Junie 將提示詞移至其必要的 `--task` 選項（[github/spec-kit#5065](https://github.com/github/spec-kit/pull/5065)）；Docker Agent 與 Junie 現在能正確顯示連字號命令名稱（[github/spec-kit#4910](https://github.com/github/spec-kit/pull/4910)）。整合切換也變得更安全：會在解除安裝目前整合之前先驗證必要選項（[github/spec-kit#5008](https://github.com/github/spec-kit/pull/5008)）、在解除安裝期間保留擴充功能產物（[github/spec-kit#4911](https://github.com/github/spec-kit/pull/4911)），並保持使用者擁有的 hook 檔案與註解完好無損（[github/spec-kit#4646](https://github.com/github/spec-kit/pull/4646)、[github/spec-kit#5017](https://github.com/github/spec-kit/pull/5017)、[github/spec-kit#5055](https://github.com/github/spec-kit/pull/5055)、[github/spec-kit#5109](https://github.com/github/spec-kit/pull/5109)）。

### 安全性、驗證與復原

10 月的強化工作遵循與先前月份相同的原則：及早拒絕格式錯誤的輸入，並讓使用者擁有的狀態保持原樣。遠端工作流程型錄讀取現在有了界限（[github/spec-kit#3766](https://github.com/github/spec-kit/pull/3766)），工作流程與步驟型錄快取被限制在預期路徑內（[github/spec-kit#4931](https://github.com/github/spec-kit/pull/4931)），專案符號連結政策則在命令邊界之間持續有效（[github/spec-kit#4934](https://github.com/github/spec-kit/pull/4934)）。SemVer 拒絕非 ASCII 數字（[github/spec-kit#4835](https://github.com/github/spec-kit/pull/4835)），套件組優先順序必須為正數（[github/spec-kit#5012](https://github.com/github/spec-kit/pull/5012)），格式錯誤的擴充功能與預設集型錄條目會在移除之前被拒絕（[github/spec-kit#5033](https://github.com/github/spec-kit/pull/5033)、[github/spec-kit#4992](https://github.com/github/spec-kit/pull/4992)），擴充功能 hook 必須包含字串命令（[github/spec-kit#5146](https://github.com/github/spec-kit/pull/5146)）。結尾帶有換行字元的擴充功能與預設集 ID，也在月底的工作中遭到拒絕（[github/spec-kit#5186](https://github.com/github/spec-kit/pull/5186)、[github/spec-kit#5188](https://github.com/github/spec-kit/pull/5188)）。

狀態保存獲得了同等的重視。中斷的閘門提示詞不再能核准閘門（[github/spec-kit#4529](https://github.com/github/spec-kit/pull/4529)）；重複的套件組初始化會避免刷新已安裝的元件（[github/spec-kit#4963](https://github.com/github/spec-kit/pull/4963)）；事件清理會保留非擁有的 JSON、Vibe 與派送器狀態（[github/spec-kit#5017](https://github.com/github/spec-kit/pull/5017)、[github/spec-kit#4646](https://github.com/github/spec-kit/pull/4646)、[github/spec-kit#5055](https://github.com/github/spec-kit/pull/5055)）；套件組步驟刷新則獲得**交易式回滾**（[github/spec-kit#4827](https://github.com/github/spec-kit/pull/4827)）。本機套件組安裝現在接受大寫的 `.ZIP` 封存檔（[github/spec-kit#5106](https://github.com/github/spec-kit/pull/5106)），套件組中繼資料與整合對應則接受更嚴格的驗證（[github/spec-kit#5131](https://github.com/github/spec-kit/pull/5131)、[github/spec-kit#5161](https://github.com/github/spec-kit/pull/5161)）。有幾項變更在 v1.2.5 之後才合併，排入下一個版本，但它們屬於同一個 10 月工程週期：可執行的組合唯有在失敗的操作具備有界、可預測的後果時才有用。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 擴充功能、預設集、工作流程步驟與套件組生態系

社群擴充功能型錄在 10 月期間從 176 個成長至 **185 個 ID**。預設集從 40 個增至 **42 個**，工作流程維持 **2 個**，套件組維持 **3 個**，新的社群工作流程步驟型錄則迎來首個條目。

本月的各項新增顯示，生態系同時朝三個方向擴展。**安全性與驗證**新增了 AttackTree（建模攻擊者設定檔與 AND／OR 威脅路徑）與 `gh-address-cr`（在明確的信任閘門之後處理 pull request 審查意見）。**外部系統橋接**新增了 Log Intake（將龐大的錯誤回報記錄檔縮減為耐久證據）與 OpenProject 擴充功能／預設集配對（透過 MCP 同步工作套件）。**知識與治理**新增了 CSDD、Shared Knowledge（跨儲存庫決策）與 Domain Spec Maintenance（每個領域的標準規格）。

10 月新增條目：

- **擴充功能**：Conformidad Software Humano（[github/spec-kit#4812](https://github.com/github/spec-kit/pull/4812)）、Log Intake／logreduce（[github/spec-kit#4813](https://github.com/github/spec-kit/pull/4813)）、AttackTree（[github/spec-kit#4859](https://github.com/github/spec-kit/pull/4859)）、OpenProject Integration（[github/spec-kit#4893](https://github.com/github/spec-kit/pull/4893)）、Epic（[github/spec-kit#4896](https://github.com/github/spec-kit/pull/4896)）、gh-address-cr（[github/spec-kit#4971](https://github.com/github/spec-kit/pull/4971)）、CSDD — Controlled Spec-Driven Development（[github/spec-kit#5062](https://github.com/github/spec-kit/pull/5062)）、Shared Knowledge（[github/spec-kit#5140](https://github.com/github/spec-kit/pull/5140)）與 Domain Spec Maintenance（[github/spec-kit#5162](https://github.com/github/spec-kit/pull/5162)）
- **預設集**：Software Humano（[github/spec-kit#4816](https://github.com/github/spec-kit/pull/4816)）與 OpenProject Work Packages（[github/spec-kit#4897](https://github.com/github/spec-kit/pull/4897)）
- **工作流程步驟**：Decision v0.9.0（[github/spec-kit#4872](https://github.com/github/spec-kit/pull/4872)），新增具型別的選擇、明確的機率與評分指引

既有家族大幅迭代。Applied Epistemic Engineering 經多次發布推進至 v1.5.2；Quality Gates 達到 v0.5.0；Product Spec 達到 v2.1.0；SpecAssay、DocGuard、Evaluator Contract、Reconcile、Linear Weave、Architecture Governance、Security Governance、Secure Development Assurance、SFSpeckit 與 iSAQB Architecture Governance 也都向前推進。 [\[github.com\]](https://github.github.io/spec-kit/community/extensions.html)

### 文件與文件網站

文件隨著架構一同成長。一份整合的**型錄參考文件**（[github/spec-kit#4976](https://github.com/github/spec-kit/pull/4976)）現在涵蓋探索、信任、優先順序、私有來源與離線操作；跨擴充功能、預設集、整合、工作流程、步驟與套件組的共用契約已記錄在案（[github/spec-kit#4977](https://github.com/github/spec-kit/pull/4977)）；而實作的擴充功能架構也從生命週期、hook 到產物解析完整記錄（[github/spec-kit#4978](https://github.com/github/spec-kit/pull/4978)）。文件網站新增了擴充功能發布、總覽、開發與 API 參考資料（[github/spec-kit#5163](https://github.com/github/spec-kit/pull/5163)、[github/spec-kit#5165](https://github.com/github/spec-kit/pull/5165)、[github/spec-kit#5166](https://github.com/github/spec-kit/pull/5166)、[github/spec-kit#5174](https://github.com/github/spec-kit/pull/5174)）。

上手流程收緊了，而不只是擴大：README 能力對照表（[github/spec-kit#4974](https://github.com/github/spec-kit/pull/4974)）、精簡的上手與流程指南（[github/spec-kit#5029](https://github.com/github/spec-kit/pull/5029)），以及代理專屬的整合文件（[github/spec-kit#5034](https://github.com/github/spec-kit/pull/5034)），讓讀者能以更短的路徑進入更大的系統。Windows PowerShell 5.1 成為明確的相容性基準（[github/spec-kit#4973](https://github.com/github/spec-kit/pull/4973)），**韓文（한국어）README** 也加入了在地化文件集（[github/spec-kit#4939](https://github.com/github/spec-kit/pull/4939)）。舊的核心 `taskstoissues` 命令已棄用，改由 `github` 擴充功能接手（[github/spec-kit#4879](https://github.com/github/spec-kit/pull/4879)），為基礎流程與選擇性的 GitHub 行為之間準備更乾淨的邊界。

## 社群與內容

### 媒體與產業報導

10 月帶來了大量的報導，而且連續第二個月出現一篇由非維護者撰寫的專屬第一方 Microsoft 文章。

**Microsoft Developer Blog**（10 月 7 日）刊登了 Apoorv Gupta 的 *“From Spec-First to Enterprise-Ready: Extending GitHub Spec Kit,”*，這是他 6 月 SDD 介紹文章的續篇。文章說明了預設集、擴充功能、套件組、工作流程、受治理的組織型錄、分層憲章、來源追溯與提示詞注入防護。其最有用的一句話，同時也是 10 月快速擴張的組合模型的邊界：「**automate only what is understood.**」文章將型錄定位為企業治理介面，而非便利清單——其套件需要釘選版本、審查與可追溯的來源。 [\[developer.microsoft.com\]](https://developer.microsoft.com/blog/from-spec-first-to-enterprise-ready-extending-github-spec-kit/)

**Golem.de**（10 月 3 日，德文）刊登了 Stefanie Schmidt 的專屬實作文章，從需求、任務到程式碼建置披薩應用程式，同時指出開發者仍須介入之處。**Jesse Liberty**（Microsoft MVP）接著推出 10 月 8–10 日的三篇客製化系列文章，從四個產物基本元件進展到實作預設集與 C# 支援的擴充功能撰寫，涵蓋資訊清單、測試、發布、檢查碼與安全性注意事項。 [\[golem.de\]](https://www.golem.de/news/spec-kit-fuer-die-softwareentwicklung-erst-spezifizieren-dann-programmieren-2610-213651.html) [\[jesseliberty.com\]](https://jesseliberty.com/2026/10/08/4-solutions-to-spec-kit-issues/)

**Open Source Friday：Spec Kit Part 2**（10 月 16 日）邀請 Manfred Riem 與 Nicole Haugen 回來討論 Spec Kit 1.0 與擴大的工具組。對話超越了原本 constitution→spec→plan→tasks 的序列，進入如今環繞其外的擴充功能、預設集、工作流程與套件組模型。 [\[youtube.com\]](https://www.youtube.com/watch?v=8hHCpNVLhmI)

### 開發者文章與實地報告

10 月的公開文章帶來橫跨中文、日文、韓文、西班牙文、葡萄牙文、德文、波蘭文與俄文的廣泛多語言潮流。內容涵蓋規格審查、工作流程成本、產物維護、棕地遷移、團隊治理，以及提示詞層級核准與可強制執行閘門之間的關係。

值得注意的文章：

- **Felipe Fontoura**（10 月 29 日更新）——*“OpenSpec vs. Superpowers vs. Spec Kit: Which One, or Both?”* 收錄了 10 月 13 日在同一儲存庫中，以相同模型、請求與驗收檢查測試 OpenSpec、BMAD、Spec Kit 1.2.0 與 Superpowers 的結果。針對 Spec Kit 的執行，文章回報 **13／13 項驗收檢查、473 秒、10 個提示詞、690 行功能產物，以及 2.84 美元的 API 等效成本**。文章也指出，analyze 步驟找出了四項在功能出現之前就會通過的測試，而且在該實驗中，沒有任何工具記錄下程式碼可以強制執行的硬性核准。 [\[felipefontoura.com\]](https://felipefontoura.com/articles/spec-driven-development-tools-compared/)
- **Sergei Gordeichuk**（Stackness，10 月 12 日）——以 API 為後援，比較 Spec Kit、OpenSpec 與其他框架，採用儲存庫、下載量、整合與程式碼搜尋量測，並結合工作流程特性。其選擇指引考量了專案範圍、代理選擇，以及一項變更所需的流程多寡。 [\[stackness.dev\]](https://stackness.dev/blog/spec-driven-development-tools-for-coding-agents-openspec-spec-kit-and-four-new-frameworks-compared)
- **rosidotidev**（DEV Community，10 月 12–25 日彙整）——三篇系列文章，從 Todo 範例進展到 RoomBook，再到 Spring Boot→NestJS 遷移。文章回報約 110 項後端測試、91 項前端測試，以及 **99 項重播請求、零差異**，同時指出規格錯誤可能一致地傳播至實作中。 [\[dev.to\]](https://dev.to/rosidotidev/series/46023)
- **Alfredo Perez**（10 月 15 日與 21 日）——以 **94 個累積的功能資料夾**檢視 Spec Kit 凍結的快照與重複的再探索，接著在 SpecKit Companion 中實作能力層級的即時規格、折返、漂移偵測與同步。後續文章在計畫中加入可審查的呼叫路徑、狀態、畫面與程式碼註記區塊，但未宣稱程式碼品質有經過量測的變化。 [\[alfredo-perez.dev\]](https://www.alfredo-perez.dev/blog/2026-10-15-living-specs) [\[alfredo-perez.dev\]](https://www.alfredo-perez.dev/blog/2026-10-21-plans-you-can-see)
- **Vinit Shahdeo**（Substack，10 月 9 日）——*“SDLC is Dead. Long Live the Spec,”* 以 LLM 路由器範例、棕地規則與兩道審查閘門為核心的第一人稱團隊採用紀錄。文章討論了前期時間、產物數量、僅靠慣例的強制執行，以及決定何時採用此流程的標準。 [\[substack.com\]](https://vinitshahdeo.substack.com/p/spec-driven-development-github-spec-kit)
- **Javier Armesto**（Substack，10 月 24 日；Microsoft MVP／MCT）——將 SDD 應用於 Business Central 棕地工作，並以**每 token 花費所獲得的證據**來框架每個流程步驟，同時指出「更多 Markdown 並不等於更多控制」。 [\[substack.com\]](https://javiarmesto.substack.com/p/spec-driven-development-en-business)

其他報導出現在 HackerNoon 與 Towards AI；Medium 與 Substack；Qiita、note.com、Naver、velog 與 GPTers；CSDN 與 Habr；以及西班牙文、德文與波蘭文刊物。反覆出現的主題包括：被誤解的需求透過產生的產物傳播、已完成功能資料夾的維護、提示詞層級核准與可強制執行核准的對比、視覺化需求模型、基礎設施使用案例，以及多代理團隊工作流程。 [\[note.com\]](https://note.com/takawano/n/n817697978988)

### 社群成長數字

這些是 10 月 1 日與 10 月 29 日的快照，並非精確的行事曆月份邊界。型錄數量也與 v1.0.13 與 v1.2.5 的發布快照相符。

| 指標 | 10 月 1 日快照 | 10 月 29 日快照 | 變化 |
| --- | --- | --- | --- |
| GitHub 星數 | 139,708 | 143,888 | +4,180 (+3.0%) |
| Fork | 12,517 | 12,881 | +364 (+2.9%) |
| 關注者 | 713 | 720 | +7 |
| 已發布 GitHub 版本（總數） | 227 | 237 | +10（v1.1.0–v1.2.5） |
| 社群擴充功能 ID | 176 | 185 | +9 |
| 社群預設集 | 40 | 42 | +2 |
| 社群工作流程 | 2 | 2 | 持平 |
| 社群工作流程步驟 | 0 | 1 | 首個條目 |
| 社群套件組 | 3 | 3 | 持平 |
| 整合型錄條目 | 42 | 43 | +1（`none`，非程式代理） |
| 討論（總數） | 509 | 518 | +9 |

## SDD 生態系與產業趨勢

### 從提示詞框架到流程控制平面

本月的核心工作指向比「規格產生器」更廣泛的範疇。控制平面需要回答四個問題：安裝了什麼、如何組合、什麼可以執行，以及哪個版本擁有行為。9 月的產物檢視回答了前兩個問題。10 月的 MCP 工具讓代理也能取得這些答案；外部配接器與本機步驟擴大了可執行的範圍；精確的型錄版本與套件組協調強化了版本所有權。

這個方向的重要性超越 Spec Kit 本身。代理開發框架日益封裝的不只是提示詞，還有可執行的 hook、殼層步驟、配接器、遠端型錄與具狀態的工作流程。一旦這些元件可以修改儲存庫、呼叫 GitHub 或派送另一個代理，它們的來源追溯與復原語意就與任何其他開發相依性同等重要。因此，10 月的有界讀取、快取限制、符號連結政策、釘選協調與交易式回滾並不是附帶工作。它們是安全性模型趕上產品模型的表現。

### 競爭格局：重量變得可量測

比較的框架從功能清單轉向**流程範圍如何選擇與量測**。Fontoura 的同任務實驗（`n=1`、一個模型、一個小型儲存庫）記錄了四款工具的驗收檢查、代理耗時、提示詞、產物行數、token 用量與 API 等效成本。文章也記錄了每個工作流程如何呈現未決決策，以及核准狀態儲存在何處。Stackness 以 API 為後援的調查、Armesto 的每 token 證據框架，以及本月的實地報告，將這種量測延伸至人工審查與產物維護。

公開文章區分出幾個重心：**規格優先、執行優先、角色優先與編輯器原生**，以及核准究竟是對話慣例還是可強制執行的狀態轉換。Spec Kit 普遍被討論為代理中立的框架，具備循序的產物管線與不斷成長的組合模型；作者們檢視了團隊如何選擇其流程範圍、審查其輸出，以及長期維護其產物。

## 藍圖

以下取樣自 10 月 31 日邊界時已開啟或已合併、但尚未發布的實質工作——公開的提案與 pull request，並非承諾：

- **執行範圍的工作流程定義**——已於 10 月 30 日合併、尚未發布，[`specify workflow definition`](https://github.com/github/spec-kit/pull/4912) 為整合提供了一個受支援的方式，可讀取某次執行背後的精確定義，填補了 9 月執行檢視提案中指出的缺口。
- **真正的運算式語法**——一份開啟的 pull request 提案[以 Lark LALR 語法取代臨時拼湊的工作流程運算式解析器](https://github.com/github/spec-kit/pull/5171)，隨著篩選器與運算式形式增多，減少歧義。
- **嚴格的殼層執行**——已於 10 月 30 日合併、尚未發布，[選擇性的嚴格殼層語意](https://github.com/github/spec-kit/pull/5181)讓工作流程作者能選擇快速失敗的行為，而非繼承寬鬆的殼層預設值。
- **完成 GitHub 邊界**——隨著 10 月的棄用，一份開啟的 pull request 提案[從核心移除 `taskstoissues`](https://github.com/github/spec-kit/pull/5053)，將議題發布留給選擇性的 GitHub 擴充功能。
- **更多代理的無模型交付**——為 [Copilot](https://github.com/github/spec-kit/pull/5118) 與 [Droid](https://github.com/github/spec-kit/pull/5116) 開啟的 pull request，提案將 Claude 與 Vibe 已有的明確 `--no-model-invocation` 選項延伸至更多代理。
- **工具重新定位韌性**——一份開啟的 pull request 提案[偵測已搬移的 `uv` 與 `pipx` 安裝](https://github.com/github/spec-kit/pull/5103)，處理記錄的可執行檔路徑已不存在的升級與環境變更。
