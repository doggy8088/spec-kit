# 社群擴充功能

> [!NOTE]
> 社群擴充功能由各自作者獨立建立與維護。維護者僅確認型錄項目完整且格式正確，不審查、稽核、背書或支援擴充功能程式碼本身。Community Extensions 網站也是第三方資源。安裝前請先檢視擴充功能原始碼，並自行斟酌使用。

🔍 **在 [Community Extensions 網站](https://speckit-community.github.io/extensions/)瀏覽與搜尋社群擴充功能。**

以下社群貢獻的擴充功能可於 [`catalog.community.json`](https://github.com/github/spec-kit/blob/main/extensions/catalog.community.json) 取得：

**類別**（常見值，但可使用任何字串）：

- `docs` — 讀取、驗證或產生規格產出物
- `code` — 審查、驗證或修改原始碼
- `process` — 跨階段協調工作流程
- `integration` — 與外部平台同步
- `visibility` — 回報專案健康狀況或進度

**效果**（標準的 `extension.yml`／型錄值）：

- `read-only` — 產生報告而不修改檔案（在表格中顯示為 `Read-only`）
- `read-write` — 修改檔案、建立產出物或更新規格（在表格中顯示為 `Read+Write`）

> [!TIP]
> 擴充功能作者可在 `extension.yml` 的 `extension:` 區塊下宣告 `category` 與 `effect`。這些欄位也可在 `catalog.community.json` 中取得，供工具與 CLI（`specify extension info`）使用。

| 擴充功能 | 用途 | 類別 | 效果 | URL |
|-----------|---------|----------|--------|-----|
| adrkit — decision memory for spec-driven development | 將主導此工作的決策帶入代理脈絡、對照決策檢查產生的計畫，並從計畫產出物起草 ADR | `process` | 讀寫 | [adrkit](https://github.com/mbeacom/adrkit) |
| Agent Assign | 將專門的 Claude Code 代理指派給 spec-kit 任務，以進行目標明確的執行 | `process` | 讀寫 | [spec-kit-agent-assign](https://github.com/xymelon/spec-kit-agent-assign) |
| Agent Governance | 從 Spec Kit 中繼資料產生代理平台儲存庫治理檔案 | `process` | 讀寫 | [spec-kit-agent-governance](https://github.com/bigsmartben/spec-kit-agent-governance) |
| AgentDocx | 全端多代理規格管線，具備 VS Code 擴充功能控制、自動化 Kanban/Jira 同步與 React 監控儀表板 | `integration` | 讀寫 | [extension-github-spec-kit](https://github.com/abir-ommezzine/extension-github-spec-kit) |
| AgentDocx SpecKit V2 | AgentDocx 的進化版：相同管線加上更自主的 Ticket Manager（5 個 CLI、專案專屬 Kanban、批次同步、自動切換、Auditor） | `integration` | 讀寫 | [Extension_GithubSpecKit](https://github.com/ahmed200346/Extension_GithubSpecKit) |
| AgentPay Pre-Pay Audit — Grade an endpoint before your agent pays it | 在資金移動前稽核付費 API：評級端點的 402 條款、查看即時市場實際收費，並確認錢包此刻能完成付款。 | `visibility` | 唯讀 | [spec-kit-prepay-audit](https://github.com/shawnhvac/spec-kit-prepay-audit) |
| AgentPay x402 — Spend Controls for Spec Kit Agents | 設定 USDC 支出上限、在付款前檢查交易對手的信用，並在規格實作期間支付支援 x402 的 API。在 Base 或 Solana 上結算。 | `integration` | 讀寫 | [spec-kit-pay-x402](https://github.com/shawnhvac/spec-kit-pay-x402) |
| Agentstandards Architecture Council | 在 Spec Kit 規劃與任務產生之間，執行有界的多廠商架構委員會。 | `process` | 讀寫 | [agentstandards](https://github.com/bbjwz/agentstandards) |
| AI-Driven Engineering (AIDE) | 以 AI 助理從零開始打造新專案的結構化 7 步驟工作流程，從願景到實作 | `process` | 讀寫 | [aide](https://github.com/mnriem/spec-kit-extensions/tree/main/aide) |
| Analytics | 測量 AI 打造的成果，以及它為你節省多少時間 | `visibility` | 讀寫 | [spec-kit-analytics](https://github.com/Fyloss/spec-kit-analytics) |
| API Evolve | 受管理的 API 合約演進，包含破壞性變更偵測、semver 強制、棄用協調，以及橫跨 REST、GraphQL 與 gRPC 的生命週期關卡 | `process` | 讀寫 | [spec-kit-api-evolve](https://github.com/Quratulain-bilal/spec-kit-api-evolve) |
| Applied Epistemic Engineering | 在每個階段對照證據檢查規格驅動專案中的主張，並清楚顯示哪些已驗證、哪些未驗證，以及哪些仍未理解。 | `process` | 讀寫 | [spec-kit-aee](https://github.com/electrohire/spec-kit-aee) |
| Architect Impact Previewer | 在實作前預測建議變更的架構影響、複雜度與風險。 | `visibility` | 唯讀 | [spec-kit-architect-preview](https://github.com/UmmeHabiba1312/spec-kit-architect-preview) |
| Architecture Governance | 讓規格、程式碼與 ADRs 保持同步：引用槽位加上唯讀、失敗即關閉的驗證器 | `docs` | 讀寫 | [spec-kit-arch-governance](https://github.com/ashbrener/spec-kit-arch-governance) |
| Architecture Guard | 與框架無關的 Spec Kit 工作流程架構治理，偵測漂移、強制架構規則，並產生可據以行動的重構任務 | `process` | 讀寫 | [architecture-guard](https://github.com/DyanGalih/architecture-guard) |
| Architecture Workflow | 以各觀點與完整工作流程命令，產生或反向產生專案層級的 4+1 架構觀點 | `docs` | 讀寫 | [spec-kit-arch](https://github.com/bigsmartben/spec-kit-arch) |
| Archive Extension | 將已合併的功能封存至專案主要記憶中，解決落差與衝突。 | `docs` | 讀寫 | [spec-kit-archive](https://github.com/stn1slv/spec-kit-archive) |
| ASCII Diagram Renderer | 呈現 spec/plan/tasks/analyze 已述內容的手繪 ASCII/Unicode 圖表（狀態機、架構、流程、涵蓋地圖），純文字，無需 Mermaid 呈現器 | `docs` | 讀寫 | [spec-kit-ascii-diagram](https://github.com/MRZHUH/spec-kit-ascii-diagram) |
| Atlas | 將 spec-kit 規格綜合成忠實、互動的架構故事書與文件入口網站。 | `docs` | 唯讀 | [spec-kit-atlas](https://github.com/ashbrener/spec-kit-atlas) |
| AttackTree — Attack Tree Modeling & Control Simulation | 攻擊樹，具備攻擊者設定檔、AND/OR 路徑模擬、控制藍圖與控制到測試的可追蹤性 | `process` | 讀寫 | [spec-kit-attacktree](https://github.com/hupe1980/spec-kit-attacktree) |
| Axi Extension | Spec Kit 擴充功能，將功能的 Markdown 呈現在本機瀏覽器審查介面上供人工註解，再將排入佇列的註記交回代理套用。 | `docs` | 讀寫 | [spec-kit-axi](https://github.com/d0whc3r/spec-kit-axi) |
| Azure Cosmos DB | 適用於任何 AI 程式代理的最佳實務 Azure Cosmos DB 程式碼產生與審查 | `code` | 讀寫 | [spec-kit-cosmosdb](https://github.com/AzureCosmosDB/spec-kit-cosmosdb) |
| Azure DevOps Integration | 使用 OAuth 驗證，將使用者故事與任務同步至 Azure DevOps 工作項目 | `integration` | 讀寫 | [spec-kit-azure-devops](https://github.com/pragya247/spec-kit-azure-devops) |
| BDD | 將規格轉換為 Gherkin 情境、建立步驟定義鷹架，並驗證驗收測試涵蓋範圍 | `process` | 讀寫 | [spec-kit-bdd](https://github.com/RSginer/spec-kit-bdd) |
| Blueprint | 在 AI 驅動開發中保持程式素養：在 /speckit.implement 執行前，從規格產出物審查每個任務的完整程式碼藍圖 | `docs` | 讀寫 | [spec-kit-blueprint](https://github.com/chordpli/spec-kit-blueprint) |
| Blueprint Index — Living Architecture Map | 規格驅動專案的活架構地圖，由確定性、低摩擦、機器優先的 CI 關卡（JSON、可自我修復）保持誠實，僅在地圖與規格或程式碼矛盾時封鎖。適用於既有或全新專案。 | `process` | 讀寫 | [spec-kit-blueprint](https://github.com/ogil109/spec-kit-blueprint) |
| Branch Convention | /specify 的可設定分支與資料夾命名慣例，具備預設集與自訂模式 | `process` | 讀寫 | [spec-kit-branch-convention](https://github.com/Quratulain-bilal/spec-kit-branch-convention) |
| Brownfield Bootstrap | 為既有程式碼庫啟動 spec-kit，自動探索架構並逐步採用 SDD | `process` | 讀寫 | [spec-kit-brownfield](https://github.com/Quratulain-bilal/spec-kit-brownfield) |
| BrownKit — Brownfield Discovery for Spec-Kit | 針對既有程式碼庫的證據驅動能力探索、安全與 QA 風險評估。 | `process` | 讀寫 | [BrownKit](https://github.com/MaksimShevtsov/BrownKit) |
| Bugfix Workflow | 結構化錯誤修正工作流程，捕捉錯誤、追蹤至規格產出物，並精準修補規格 | `process` | 讀寫 | [spec-kit-bugfix](https://github.com/Quratulain-bilal/spec-kit-bugfix) |
| Canon | 加入以 canon 為驅動（以基線為驅動）的工作流程：spec-first、code-first、spec-drift。需要安裝 Canon Core 預設集。 | `process` | 讀寫 | [spec-kit-canon](https://github.com/maximiliamus/spec-kit-canon/tree/master/extension) |
| Catalog CI | spec-kit 社群型錄項目的自動化驗證，包含結構、URL、差異與 linting | `process` | 唯讀 | [spec-kit-catalog-ci](https://github.com/Quratulain-bilal/spec-kit-catalog-ci) |
| Charter | 從共用片段登錄組合專案憲章 | `process` | 讀寫 | [spec-kit-charter](https://github.com/Fyloss/spec-kit-charter) |
| CI Guard | CI/CD 的規格合規關卡，驗證規格存在、檢查漂移，並在有落差時封鎖合併 | `process` | 唯讀 | [spec-kit-ci-guard](https://github.com/Quratulain-bilal/spec-kit-ci-guard) |
| Checkpoint Extension | 在實作中途提交變更，避免最後只留下一個非常大的提交 | `code` | 讀寫 | [spec-kit-checkpoint](https://github.com/aaronrsun/spec-kit-checkpoint) |
| Cleanup Extension | 實作後的品質關卡，審查變更、修正小問題（scout 規則）、為中型問題建立任務，並為大型問題產生分析 | `code` | 讀寫 | [spec-kit-cleanup](https://github.com/dsrednicki/spec-kit-cleanup) |
| Coding Standards Drift Control | 為作用中的 Spec Kit 功能產生程式標準漂移報告與修復任務 | `code` | 讀寫 | [spec-kit-coding-standards-drift-control](https://github.com/benizzio/spec-kit-coding-standards-drift-control) |
| Conduct Extension | 透過子代理委派協調 spec-kit 階段，以減少脈絡污染。 | `process` | 讀寫 | [spec-kit-conduct-ext](https://github.com/twbrandon7/spec-kit-conduct-ext) |
| Confluence Extension | 在 Confluence 中建立文件，摘要規格與規劃檔案 | `integration` | 讀寫 | [spec-kit-confluence](https://github.com/aaronrsun/spec-kit-confluence) |
| Conformidad Software Humano | 檢查專案產出物是否包含 Software Humano 宣言要求的內容，且每項缺漏都宣告為經核准的例外。 | `docs` | 唯讀 | [software-humano-speckit](https://github.com/dacunao/software-humano-speckit) |
| ContextForge MCP | 將 codebase-memory-mcp + headroom 整合至 Spec Kit，為 implement 階段提供圖形化程式碼智慧與脈絡壓縮 | `code` | 讀寫 | [contextforge-mcp](https://github.com/capatinore/contextforge-mcp) |
| Cost Tracker | 追蹤 SDD 工作流程中的真實 LLM 美元成本，包含各功能預算、各整合比較與可供財務使用的匯出 | `visibility` | 讀寫 | [spec-kit-cost](https://github.com/Quratulain-bilal/spec-kit-cost) |
| CSDD — Controlled Spec-Driven Development | 將治理規範、門禁、範本安裝至已有儲存庫；第三方擴充功能依清單選擇性安裝，預設不安裝。 | `process` | 讀寫 | [csdd](https://github.com/yuansanche/csdd) |
| Data Model Diagram | 在規劃後，從 Spec Kit 資料模型產生 Mermaid ER 圖表 | `docs` | 讀寫 | [spec-kit-data-model-diagram](https://github.com/benizzio/spec-kit-data-model-diagram) |
| DocGuard — CDD Enforcement | AI 輔助儲存庫的文件完整性：生命週期登錄、漂移驗證、可追蹤性、安全封存、SARIF/JUnit、MCP、GitHub Actions 與 Spec Kit 掛鉤。 | `docs` | 讀寫 | [spec-kit-docguard](https://github.com/raccioly/docguard) |
| Domain Spec Maintenance | 維護各領域的標準規格：在 specify/plan 前讀取，在 implement 後更新 | `docs` | 讀寫 | [spec-kit-domain-spec](https://github.com/jinaparkdev/spec-kit-domain-spec) |
| Dotdog | 將 GitHub Spec Kit 產出物匯入本機知識圖譜，以進行驗證、分析、搜尋與 MCP 查詢。 | `docs` | 讀寫 | [dotdog](https://github.com/specdog/dotdog) |
| DUBSAR Memory | Spec Kit 的本機專案記憶，具備明確檢查點、跨工作階段恢復，以及已記錄規格、計畫與任務參照的 SHA-256 新鮮度。 | `visibility` | 讀寫 | [dubsar-memory](https://github.com/kotnisofiane-bit/dubsar-memory) |
| EARS Requirements Syntax | 使用 EARS 撰寫、lint 與轉換需求，EARS 是五種業界標準句型，用於無歧義、可測試的需求 | `docs` | 讀寫 | [spec-kit-ears](https://github.com/dhruv-15-03/spec-kit-ears) |
| Epic | 將過大而無法以單一功能完成的工作拆解為多個功能，依序交付，並讓決策在各功能間保持一致。 | `process` | 讀寫 | [spec-kit-epic](https://github.com/pmckeown/spec-kit-epic) |
| Evaluator Contract | 與服務提供者無關的評估器合約，涵蓋規格驅動開發各階段的證據、出處、不確定性與復原。 | `process` | 讀寫 | [spec-kit-evaluator](https://github.com/electrohire/spec-kit-evaluator) |
| Extensify | 建立並驗證擴充功能與擴充功能型錄 | `process` | 讀寫 | [extensify](https://github.com/mnriem/spec-kit-extensions/tree/main/extensify) |
| Figma Starter | 將 Figma 區段的畫面轉換為源自 Figma 的規格，並將 OpenAPI/Swagger 文件轉換為實體模型與各頁面的 UI 到 API 綁定，再交接至 /speckit.specify | `docs` | 讀寫 | [spec-kit-figma-starter](https://github.com/OmneWave/spec-kit-figma-starter) |
| Fix Findings | 自動化的 analyze-fix-reanalyze 迴圈，解決規格發現事項直到乾淨為止 | `code` | 讀寫 | [spec-kit-fix-findings](https://github.com/Quratulain-bilal/spec-kit-fix-findings) |
| FixIt Extension | 具規格意識的錯誤修正，將錯誤對應至規格產出物、提出計畫，並套用最小變更 | `code` | 讀寫 | [spec-kit-fixit](https://github.com/speckit-community/spec-kit-fixit) |
| Fleet Orchestrator | 以人工介入關卡，協調橫跨所有 SpecKit 階段的完整功能生命週期 | `process` | 讀寫 | [spec-kit-fleet](https://github.com/sharathsatish/spec-kit-fleet) |
| gh-address-cr | Spec Kit 工作流程中可稽核的 PR 審查解決與信任關卡處理引擎。 | `process` | 讀寫 | [spec-kit-extensions](https://github.com/RbBtSn0w/spec-kit-extensions) |
| GitHub Issue Triage | 擷取開啟中的 GitHub issues，將每個分類為 bug、feature 或 chore，再委派至正確的工作流程，不將 bugs 或 chores 存為規格。 | `integration` | 讀寫 | [speckit-extensions](https://github.com/arrrrny/speckit-extensions) |
| GitHub Issues Integration 1 | 從 GitHub Issues 產生規格產出物，匯入 issues、同步更新，並維持雙向可追蹤性 | `integration` | 讀寫 | [spec-kit-github-issues](https://github.com/Fatima367/spec-kit-github-issues) |
| GitHub Issues Integration 2 | 從既有 GitHub issue 建立並同步本機規格 | `integration` | 讀寫 | [spec-kit-issue](https://github.com/aaronrsun/spec-kit-issue) |
| Golden Demo | 確定性行為漂移預言器。擷取驗收標準、產生模糊測試向量（seed=42）、以任何語言將黃金 Python 實作與真實程式碼比較。CI/CD 守門員，具備 warn/strict 模式。 | `docs` | 讀寫 | [spec-kit-golden-demo](https://github.com/jasstt/spec-kit-golden-demo) |
| Guildwork: request, verdict, register | 在具名的人員核准書面請求之前，不撰寫任何程式碼，且每個判定都被保留。 | `process` | 讀寫 | [Guildwork](https://github.com/Simon-Pacifae-Dupont/Guildwork) |
| Improve Extension | 以資深顧問身分稽核任何程式碼庫，並在 specs/ 之下撰寫優先排序、自包含的規格提示詞，供 spec-kit 生命週期處理 | `process` | 讀寫 | [spec-kit-improve](https://github.com/d0whc3r/spec-kit-improve) |
| Intake | 將 PRD、設計、HTML SSOT 與測試案例證據正規化為可供 SDD 使用的 intake 產出物。 | `docs` | 讀寫 | [spec-kit-intake](https://github.com/bigsmartben/spec-kit-intake) |
| Intelligent Agent Orchestrator | 跨型錄代理探索與智慧的提示詞到命令路由 | `process` | 讀寫 | [spec-kit-orchestrator](https://github.com/pragya247/spec-kit-orchestrator) |
| Intent Reconciliation | 將實作過程中發現的決策，與已核准的功能意圖對帳 | `process` | 讀寫 | [spec-kit-reconcile](https://github.com/SuhaibAslam/spec-kit-reconcile) |
| Iterate | 以兩階段的定義與套用工作流程迭代規格文件，在實作中途精修規格，並直接回到打造 | `docs` | 讀寫 | [spec-kit-iterate](https://github.com/imviancagrace/spec-kit-iterate) |
| Jira Integration | 從 spec-kit 規格與任務拆解建立 Jira Epics、Stories 與 Issues，支援可設定的階層與自訂欄位 | `integration` | 讀寫 | [spec-kit-jira](https://github.com/mbachorik/spec-kit-jira) |
| Jira Integration (Sync Engine) | 冪等、具漂移意識、失敗即關閉的對帳引擎，將 spec-kit 規格鏡像至 Jira（每個儲存庫一個 Epic、每個規格一個 Story、每個階段一個 Subtask） | `integration` | 讀寫 | [spec-kit-jira-sync](https://github.com/ashbrener/spec-kit-jira-sync) |
| Jira Mirror | Spec Kit ↔ Jira 橋梁，適用於團隊管理與公司管理專案：可設定的工作流程與階層（Scrum/SAFe）、多專案、冪等且失敗即關閉。macOS/Linux/Windows。 | `integration` | 讀寫 | [spec-kit-jira-mirror](https://github.com/Fyloss/spec-kit-jira-mirror) |
| Keel Connect | 在不離開代理的情況下，將本機 Keel 執行環境連結至 Keel Cloud。 | `integration` | 唯讀 | [spec-kit-keel](https://github.com/keeldiscovery/spec-kit-keel) |
| Learning Extension | 從實作產生教育指南，並以導師脈絡強化釐清 | `docs` | 讀寫 | [spec-kit-learn](https://github.com/imviancagrace/spec-kit-learn) |
| Linear Integration | 自動將 spec-kit 規格鏡像至 Linear，每個規格一個 issue、每個任務階段一個子 issue，並在工作過程中保持同步。 | `integration` | 讀寫 | [spec-kit-linear-sync](https://github.com/ashbrener/spec-kit-linear-sync) |
| Linear Weave | 將 Spec Kit 織入 Linear：拉取需求、將 tasks.md 鏡像為子 issues、同步狀態 | `integration` | 讀寫 | [spec-kit-linear-weave](https://github.com/tonydwoodhouse/spec-kit-linear-weave) |
| LLM Wiki | 由 LLM 維護的複利式專案 wiki：來源擷取、附引用的回答與一致性 linting | `docs` | 讀寫 | [spec-kit-wiki](https://github.com/formin/spec-kit-wiki) |
| Log Intake (logreduce) | 在評估前，將錯誤報告所附的大型記錄縮減為已儲存的證據 | `process` | 讀寫 | [log_tfidf_reducer](https://github.com/alexcpn/log_tfidf_reducer) |
| Loop Engineering | 為規格驅動開發設計安全的自主代理迴圈：maker/checker 分工、外化的迴圈狀態，以及保持工程師角色的護欄，防止理解債與認知投降 | `process` | 讀寫 | [spec-kit-loop](https://github.com/formin/spec-kit-loop) |
| MAQA — Multi-Agent & Quality Assurance | 冪等、與代理無關的 coordinator → feature → QA 工作流程，以 GitHub Issues 為事實來源。使用 Spec Kit taskstoissues 處理遺失的 issues，並支援平行或循序派送。 | `process` | 讀寫 | [spec-kit-maqa-ext](https://github.com/GenieRobot/spec-kit-maqa-ext) |
| MAQA Azure DevOps Integration | MAQA 的 Azure DevOps Boards 整合，隨著功能進展同步 User Stories 與 Task 子項目 | `integration` | 讀寫 | [spec-kit-maqa-azure-devops](https://github.com/GenieRobot/spec-kit-maqa-azure-devops) |
| MAQA CI/CD Gate | 自動偵測 GitHub Actions、CircleCI、GitLab CI 與 Bitbucket Pipelines。在管線變綠之前封鎖 QA 交接。 | `process` | 讀寫 | [spec-kit-maqa-ci](https://github.com/GenieRobot/spec-kit-maqa-ci) |
| MAQA GitHub Projects Integration | MAQA 的 GitHub Projects v2 整合，隨著功能進展同步草稿 issues 與 Status 欄位 | `integration` | 讀寫 | [spec-kit-maqa-github-projects](https://github.com/GenieRobot/spec-kit-maqa-github-projects) |
| MAQA Jira Integration | MAQA 的 Jira 整合，隨著功能在看板上進展同步 Stories 與 Subtasks | `integration` | 讀寫 | [spec-kit-maqa-jira](https://github.com/GenieRobot/spec-kit-maqa-jira) |
| MAQA Linear Integration | MAQA 的 Linear 整合，隨著功能進展跨工作流程狀態同步 issues 與子 issues | `integration` | 讀寫 | [spec-kit-maqa-linear](https://github.com/GenieRobot/spec-kit-maqa-linear) |
| MAQA Trello Integration | MAQA 的 Trello 看板整合，從規格填入看板、移動卡片、即時勾選檢核清單 | `integration` | 讀寫 | [spec-kit-maqa-trello](https://github.com/GenieRobot/spec-kit-maqa-trello) |
| MarkItDown Document Converter | 將文件（PDF、Word、PowerPoint、Excel 等）轉換為 Markdown，作為規格參照資料 | `docs` | 讀寫 | [spec-kit-markitdown](https://github.com/BenBtg/spec-kit-markitdown) |
| MDE | 極簡的模型驅動工程工作流程，具備 setup、next 與 status 命令 | `process` | 讀寫 | [spec-kit-mde](https://github.com/AI-MDE/spec-kit-mde) |
| Memory Loader | 在生命週期命令前載入 .specify/memory/ 檔案，讓 LLM 代理具備專案治理脈絡 | `docs` | 唯讀 | [spec-kit-memory-loader](https://github.com/KevinBrown5280/spec-kit-memory-loader) |
| Memory MD | Spec Kit 擴充功能，提供儲存庫原生的 Markdown 記憶，捕捉持久決策、錯誤與專案脈絡 | `docs` | 讀寫 | [spec-kit-memory-hub](https://github.com/DyanGalih/spec-kit-memory-hub) |
| MemoryLint | 證據驅動的指令漂移檢查器：稽核代理記憶檔案的邊界、現實、衝突與冗餘漂移。 | `process` | 讀寫 | [memorylint](https://github.com/RbBtSn0w/spec-kit-extensions/tree/main/memorylint) |
| Microsoft 365 Integration | 擷取 Teams 訊息、會議逐字稿與 SharePoint/OneDrive 檔案為本機 Markdown，以產生規格 | `integration` | 讀寫 | [spec-kit-m365](https://github.com/BenBtg/spec-kit-m365) |
| Multi-Model Review | 跨模型的 Spec Kit 交接，用於規格撰寫、實作路由與審查。 | `process` | 讀寫 | [multi-model-review](https://github.com/formin/multi-model-review) |
| Multi-Repo Branch Sync | 透過 plan/tasks 掛鉤，在受影響的子儲存庫與 git 子模組中建立功能分支 | `process` | 讀寫 | [multi-repo-sync](https://github.com/fyloss/spec-kit-multi-repo-sync) |
| Multi-Sites Spec Kit | 具多站點意識的 specify 命令，具備各站點規格資料夾、自動遞增與 Drupal 支援 | `process` | 讀寫 | [spec-kit-multi-sites](https://github.com/teeyo/spec-kit-multi-sites) |
| .NET Framework to Modern .NET Migration | 協調橫跨 7 個階段的端到端 .NET Framework 到現代 .NET 遷移，並整合 SDD 生命週期 | `process` | 讀寫 | [spec-kit-fx-to-net](https://github.com/RogerBestMsft/spec-kit-FxToNet) |
| OKF Knowledge Bundle Generator | 從原始碼儲存庫產生並維護 Open Knowledge Format（OKF v0.1）知識套件組。挖掘 git 歷史以找出程式碼背後的理由，將無法確立的內容停放為開放問題而不是猜測，並驗證套件組的主張確實受儲存庫支持。 | `docs` | 讀寫 | [catalogify](https://github.com/alexcpn/catalogify) |
| Onboard | 為 spec-kit 專案新手開發者提供脈絡化入門與漸進成長。說明規格、對應相依性、驗證理解，並指引下一步 | `process` | 讀寫 | [spec-kit-onboard](https://github.com/dmux/spec-kit-onboard) |
| OpenProject Integration | 透過 MCP 在 spec-kit 與 OpenProject 之間同步欄位、狀態、文件、版本與時間 | `integration` | 讀寫 | [speckit-openproject](https://github.com/Nachklang-io/speckit-openproject) |
| OpenSpec | 為 Spec Kit 專案加入規格驅動的變更管理工作流程（propose → implement → verify → archive），讓規格、設計與程式碼保持同步 | `process` | 讀寫 | [spec-kit-openspec](https://github.com/aaronrsun/spec-kit-openspec) |
| OpenUP Governed Lifecycle | 為 Spec Kit 加入 OpenUP 生命週期：階段、迭代、七層 WBS、可執行的風險登錄、雙向可追蹤性與機器可檢查的里程碑關卡。 | `process` | 讀寫 | [specup](https://github.com/anvigo12/specup) |
| Optimize | 稽核並最佳化 AI 治理的脈絡效率，包含權杖預算、規則健康、可解讀性、壓縮、一致性與回聲偵測 | `process` | 讀寫 | [spec-kit-optimize](https://github.com/sakitA/spec-kit-optimize) |
| Orchestration Task Context Management | 為產生的 Spec Kit 任務檔案加入子代理工作單位協調 | `process` | 讀寫 | [spec-kit-orchestration-task-context-management](https://github.com/benizzio/spec-kit-orchestration-task-context-management) |
| OWASP LLM Threat Model | 針對代理產出物的 OWASP Top 10 for LLM Applications 2026 威脅分析 | `code` | 唯讀 | [spec-kit-threatmodel](https://github.com/NaviaSamal/spec-kit-threatmodel) |
| PatchWarden Evidence Pack | 將 Spec Kit 任務對應至受保護的 PatchWarden Goal，並為已接受的譜系匯出有界、可追蹤的證據。 | `process` | 讀寫 | [spec-kit-patchwarden](https://github.com/jiezeng2004-design/spec-kit-patchwarden) |
| Plan Review Gate | 要求 spec.md 與 plan.md 先透過 MR/PR 合併，才允許產生任務 | `process` | 唯讀 | [spec-kit-plan-review-gate](https://github.com/luno/spec-kit-plan-review-gate) |
| PR Bridge | 從規格產出物自動產生 pull request 說明、檢核清單與摘要 | `process` | 唯讀 | [spec-kit-pr-bridge-](https://github.com/Quratulain-bilal/spec-kit-pr-bridge-) |
| Pre-Spec Cards | 以卡片為基礎的規格前思考：貼上構想，取得你的卡片與可能遺漏的路徑，再逐一推演，包含故事、障礙、取捨、難度與回報，然後才執行 /speckit.specify | `process` | 讀寫 | [pre-spec](https://github.com/bendlikeabamboo/pre-spec) |
| Presetify | 建立並驗證預設集與預設集型錄 | `process` | 讀寫 | [presetify](https://github.com/mnriem/spec-kit-extensions/tree/main/presetify) |
| Product Definition as Code (PDaC) | 將 Spec Kit 功能奠基於已接受的產品定義，再驗證交付產出物中的引用 | `process` | 讀寫 | [productshape](https://github.com/juangcarmona/productshape) |
| Product Forge | Spec Kit 的完整產品生命週期協調器：research → product-spec → plan → tasks → implement → verify → test → release-readiness，橫跨 express/lite/standard/v-model 模式，具備人工介入關卡。 | `process` | 讀寫 | [speckit-product-forge](https://github.com/VaiYav/speckit-product-forge) |
| Product Spec Extension | 從工程規格產生 PRFAQ、Lean PRD、利害關係人摘要與技術設計。 | `docs` | 讀寫 | [spec-kit-product](https://github.com/d0whc3r/spec-kit-product) |
| ProductShape PRODUCT workflows | 在獨立的 Spec Kit 通道中，撰寫、精修、驗證、套用、封存與復原 ProductShape 產品意涵。 | `process` | 讀寫 | [productshape](https://github.com/juangcarmona/productshape) |
| Project Health Check | 診斷 Spec Kit 專案，並回報橫跨結構、代理、功能、指令碼、擴充功能與 git 的健康問題 | `visibility` | 唯讀 | [spec-kit-doctor](https://github.com/KhawarHabibKhan/spec-kit-doctor) |
| Project Status | 顯示目前的 SDD 工作流程進度，包含作用中功能、產出物狀態、任務完成度、工作流程階段與擴充功能摘要 | `visibility` | 唯讀 | [spec-kit-status](https://github.com/KhawarHabibKhan/spec-kit-status) |
| QA Testing Extension | 系統化 QA 測試，以瀏覽器驅動或 CLI 型方式驗證規格中的驗收標準 | `code` | 唯讀 | [spec-kit-qa](https://github.com/arunt14/spec-kit-qa) |
| Quality Gates (Enforcement Layer) | Spec Kit 專案的確定性品質強制，在三個邊界執行：代理邊界（Claude Code PreToolUse/PostToolUse/Stop 掛鉤）、git 邊界（pre-commit / pre-merge-commit / commit-msg），以及 CI 邊界（投射的 GitHub Actions / GitLab CI / Jenkins 管線）。一份政策檔案、一個驗證進入點；CI 執行整份政策，較早的邊界僅略過政策以名稱宣告的項目。 | `process` | 讀寫 | [spec-gates](https://github.com/schwichtgit/spec-gates) |
| RAG Azure Builder | Spec Kit 擴充功能，以引導式工作流程入門並操作 Azure RAG 堆疊。 | `process` | 讀寫 | [spec-kit-extension-rag-azure-builder](https://github.com/Sertxito/spec-kit-extension-rag-azure-builder) |
| Ralph Loop | 使用 AI 代理 CLI 的自主實作迴圈 | `code` | 讀寫 | [spec-kit-ralph](https://github.com/Rubiss-Projects/spec-kit-ralph) |
| Reconcile Extension | 透過精準更新功能自身的規格、計畫與任務，對帳實作漂移。 | `docs` | 讀寫 | [spec-kit-reconcile](https://github.com/stn1slv/spec-kit-reconcile) |
| Red Team | 在 /speckit.plan 前對規格進行對抗性審查，平行 lens 代理呈現 clarify/analyze 在結構上無法發現的風險（提示詞注入、完整性落差、跨規格漂移、靜默失敗）。產生結構化發現報告；不自動編輯規格。 | `docs` | 讀寫 | [spec-kit-red-team](https://github.com/ashbrener/spec-kit-red-team) |
| Research Harness | 將狀態外化的研究框架：具預算的探索、證據策展與規格驅動開發的主張驗證 | `process` | 讀寫 | [spec-kit-harness](https://github.com/formin/spec-kit-harness) |
| Repository Governance | 從 Spec Kit 中繼資料產生專案治理投射 | `process` | 讀寫 | [spec-kit-agent-governance](https://github.com/bigsmartben/spec-kit-agent-governance) |
| Repository Index | 為既有儲存庫產生索引，涵蓋概觀、架構與模組層級。 | `docs` | 唯讀 | [spec-kit-repoindex](https://github.com/liuyiyu/spec-kit-repoindex) |
| Reqnroll BDD | 為 Spec Kit 加入 Reqnroll BDD 規劃、Gherkin 產生、可追蹤性、安全任務注入、交接與驗證 | `process` | 讀寫 | [spec-kit-reqnroll-bdd](https://github.com/LoogacyStudio/spec-kit-reqnroll-bdd) |
| Retro Extension | Sprint 回顧分析，具備指標、規格準確度評估與改進建議 | `process` | 讀寫 | [spec-kit-retro](https://github.com/arunt14/spec-kit-retro) |
| Retrospective Extension | 實作後回顧，具備規格遵循評分、漂移分析與人工關卡的規格更新 | `docs` | 讀寫 | [spec-kit-retrospective](https://github.com/emi-dm/spec-kit-retrospective) |
| Review Extension | 實作後全面程式碼審查，具備專門代理，涵蓋程式碼品質、註解、測試、錯誤處理、型別設計與簡化 | `code` | 唯讀 | [spec-kit-review](https://github.com/ismaelJimenez/spec-kit-review) |
| Ripple | 偵測測試無法捕捉的實作後副作用，呈現橫跨 9 個分析類別的隱藏漣漪效應 | `code` | 讀寫 | [spec-kit-ripple](https://github.com/chordpli/spec-kit-ripple) |
| SDD Utilities | 恢復中斷的工作流程、驗證專案健康，並驗證規格到任務的可追蹤性 | `process` | 讀寫 | [speckit-utils](https://github.com/mvanhorn/speckit-utils) |
| Security Review | 全專案的安全預設安全稽核，以及分階段、分支/PR、計畫、任務、後續與套用審查 | `code` | 讀寫 | [security-review](https://github.com/DyanGalih/security-review) |
| SFSpeckit | 企業級規格驅動開發（SDD）框架，適用於 Salesforce。 | `process` | 讀寫 | [spec-kit-sf](https://github.com/Evernorth/spec-kit-sf) |
| Shared Knowledge | 將跨儲存庫決策、合約與慣例注入 spec-kit 工作流程。 | `integration` | 讀寫 | [spec-kit-shared-knowledge](https://github.com/rnoap/spec-kit-shared-knowledge) |
| Ship Release Extension | 自動化 release 管線：預檢、分支同步、changelog 產生、CI 驗證與 PR 建立 | `process` | 讀寫 | [spec-kit-ship](https://github.com/arunt14/spec-kit-ship) |
| Spec Changelog | 從規格 git 歷史與需求差異自動產生 changelogs 與 release 說明 | `docs` | 唯讀 | [spec-kit-changelog](https://github.com/Quratulain-bilal/spec-kit-changelog) |
| Spec Critique Extension | 從產品策略與工程風險觀點，對規格與計畫進行雙重視角批判性審查 | `docs` | 唯讀 | [spec-kit-critique](https://github.com/arunt14/spec-kit-critique) |
| Spec Diagram | 自動產生 SDD 工作流程狀態、功能進度與任務相依性的 Mermaid 圖表 | `visibility` | 唯讀 | [spec-kit-diagram-](https://github.com/Quratulain-bilal/spec-kit-diagram-) |
| Spec Inventory | 即時需求與任務 ID 的唯讀清單，附聚焦的各任務脈絡包，而不是整份檔案傾印 | `visibility` | 唯讀 | [spec-kit-inventory-alignment](https://github.com/Yash-Chindam/spec-kit-inventory-alignment) |
| Spec Kit Design System | 給它一份 RFC。它會執行 Spec Kit 工作流程，並使用你的設計系統實作變更。 | `integration` | 讀寫 | [spec-kit-design-system](https://github.com/artursopelnik/spec-kit-design-system) |
| Spec Kit Discovery Extension | 執行技術探索命令，涵蓋可行性、技術選擇、情境專屬技術決策、既有程式碼庫評估、實作理解與概念驗證 | `process` | 讀寫 | [spec-kit-discovery](https://github.com/bigsmartben/spec-kit-discovery) |
| Spec Kit Figma | 透過 REST 或 MCP，將 SpecKit spec/plan/tasks 奠基於 Figma 設計脈絡，支援 macOS/Linux/Windows。 | `integration` | 讀寫 | [spec-kit-figma](https://github.com/Fyloss/spec-kit-figma) |
| Spec Kit Memory | 在 SDLC 各階段前，從可設定的記憶工具（如 memsearch）回想先前的規格與決策，讓規劃與規格制定從專案已知的內容出發 | `docs` | 讀寫 | [spec-kit-memory](https://github.com/zaytsevand/spec-kit-memory) |
| Spec Kit Preview | 從 Spec Kit 產出物產生具證據支持的低、中或高保真預覽，格式為 Markdown 或自包含 HTML | `docs` | 讀寫 | [spec-kit-preview](https://github.com/bigsmartben/spec-kit-preview) |
| Spec Kit Schedule — parallel subagent rounds | 零設定規劃器，將 tasks.md 轉換為子代理的最佳平行輪次（CP-SAT、關鍵路徑意識、檔案衝突安全），並提供 implement 命令逐輪執行，以 tasks.md 核取方塊為進度的單一來源。 | `process` | 讀寫 | [spec-kit-schedule](https://github.com/jfranc38/spec-kit-schedule) |
| Spec Kit TLDR | 將功能的 spec.md / plan.md 呈現為以審查為導向的 TLDR（自包含 HTML 儀表板 + PR 原生 Markdown），呈現風險以加快 PR 審查。 | `visibility` | 讀寫 | [speckit-tldr](https://github.com/qurore/speckit-tldr) |
| Spec Orchestrator | 跨功能協調，追蹤狀態、選取任務，並偵測平行規格間的衝突 | `process` | 唯讀 | [spec-kit-orchestrator](https://github.com/Quratulain-bilal/spec-kit-orchestrator) |
| Spec Reference Loader | 讀取功能規格中的 ## References 區段，並僅將列出的文件載入脈絡 | `docs` | 唯讀 | [spec-kit-spec-reference-loader](https://github.com/KevinBrown5280/spec-kit-spec-reference-loader) |
| Spec Refine | 就地更新規格、將變更傳播至計畫與任務，並比較各產出物的影響差異 | `process` | 讀寫 | [spec-kit-refine](https://github.com/Quratulain-bilal/spec-kit-refine) |
| Spec Roadmap | 在憲章後捕捉持久的規格藍圖，再於實作前後對照藍圖審查規格，讓規格專屬決策、成果與限制永不遺失。 | `process` | 讀寫 | [speckit-roadmap](https://github.com/srobroek/speckit-roadmap) |
| Spec Scope | 工作量估計與範圍追蹤，估計工作、偵測範圍蔓延，並為各階段編列時間預算 | `process` | 唯讀 | [spec-kit-scope-](https://github.com/Quratulain-bilal/spec-kit-scope-) |
| Spec Sync | 偵測並解決規格與實作之間的漂移。AI 輔助解決，附人工核准 | `docs` | 讀寫 | [spec-kit-sync](https://github.com/bgervin/spec-kit-sync) |
| Spec Trace | 從 spec.md 與測試套件建立需求 → 測試可追蹤性矩陣，呈現未測試的需求與孤立測試 | `code` | 讀寫 | [spec-kit-trace](https://github.com/Quratulain-bilal/spec-kit-trace) |
| Spec Validate | spec-kit 產出物的理解驗證、審查關卡與核准狀態，包含分階段測驗、同儕審查 SLA，以及 /speckit.implement 前的硬性關卡 | `process` | 讀寫 | [spec-kit-spec-validate](https://github.com/aeltayeb/spec-kit-spec-validate) |
| Spec2Cloud | 為交付至 Azure 調整的規格驅動工作流程 | `process` | 讀寫 | [spec2cloud](https://github.com/Azure-Samples/Spec2Cloud) |
| SpecAssay Check | Gate 2 拒絕靜默落差，並產出追蹤資訊清單（`trace-manifest.json`）。 | `visibility` | 讀寫 | [specassay](https://github.com/rdryfoos/specassay) |
| SpecJudge — right-size the model before you implement | 推薦適合你任務的模型，並引用每個等級背後的規格片段。 | `process` | 唯讀 | [SpecJudge](https://github.com/JoaquinRuiz/SpecJudge) |
| SpecKit Companion | 即時記錄你的 spec-kit 執行：狀態、恢復，以及實際發生情況的健康檢查。 | `process` | 讀寫 | [speckit-companion](https://github.com/alfredoperez/speckit-companion) |
| SpecKit Grill Me | 詳盡釐清規格，並可選擇性地同步標準領域知識 | `process` | 讀寫 | [speckit-grill-me](https://github.com/yoshi1220/speckit-grill-me) |
| SpecTest | 從規格標準自動產生測試鷹架、對應涵蓋範圍，並找出未測試的需求 | `code` | 讀寫 | [spec-kit-spectest](https://github.com/Quratulain-bilal/spec-kit-spectest) |
| Squad Bridge | 從你的 Speckit 規格與任務啟動並同步 Squad 代理團隊。 | `process` | 讀寫 | [spec-kit-squad](https://github.com/jwill824/spec-kit-squad) |
| Staff Review Extension | 資深工程師層級的程式碼審查，對照規格驗證實作、檢查安全、效能與測試涵蓋範圍 | `code` | 唯讀 | [spec-kit-staff-review](https://github.com/arunt14/spec-kit-staff-review) |
| Status Report | 規格驅動工作流程的專案狀態、功能進度與下一步行動建議 | `visibility` | 唯讀 | [Open-Agent-Tools/spec-kit-status](https://github.com/Open-Agent-Tools/spec-kit-status) |
| Superpowers Bridge | 將選定的 Superpowers 紀律橋接至 Spec Kit，作為代理工作流程中證據優先的信任關卡。 | `process` | 讀寫 | [superpowers-bridge](https://github.com/RbBtSn0w/spec-kit-extensions/tree/main/superpowers-bridge) |
| Superpowers Implementation Bridge | Spec Kit 設計產出物與 Superpowers 實作紀律之間的輕量協調器。跨代理；已針對 Codex 與 Claude Code 驗證。 | `process` | 讀寫 | [speckit-superpowers-bridge](https://github.com/lihan3238/speckit-superpowers-bridge) |
| Superspec | 將 spec-kit 與 obra/superpowers（腦力激盪、TDD、子代理、程式碼審查）橋接為統一、可恢復的工作流程，具備優雅降級與工作階段進度追蹤 | `process` | 讀寫 | [superspec](https://github.com/WangX0111/superspec) |
| Taco Review | 將 Spec Kit 功能打包供人工審查，並將編輯與留言同步回來。 | `integration` | 讀寫 | [taco](https://github.com/Arcadia822/taco) |
| Tasks to GitHub Project | 將 Spec Kit 任務發佈並同步為 GitHub Project（v2）看板上的卡片，並在 spec.md/tasks.md 與看板之間同步優先順序與狀態。 | `integration` | 讀寫 | [spec-kit-tasks-to-project](https://github.com/mancioshell/spec-kit-tasks-to-project) |
| TDD Extension | 以測試驅動 spec-kit 實作：與語言無關的 red-green-refactor 迴圈，具備各功能測試清單、記錄的 red 與 green 證據，以及經突變檢查的測試強度。 | `process` | 讀寫 | [spec-kit-tdd](https://github.com/d0whc3r/spec-kit-tdd) |
| Team Assign | 將 tasks.md 項目指派給人類工程師、拆解為子任務，並產生各工程師的工作看板 | `process` | 讀寫 | [spec-kit-team-assign](https://github.com/tarunkumarbhati/spec-kit-team-assign) |
| Test Coverage Drift Control | 在實作後產生增量涵蓋漂移報告與已規劃的修復任務 | `code` | 讀寫 | [spec-kit-test-coverage-drift-control](https://github.com/benizzio/spec-kit-test-coverage-drift-control) |
| Test Validation | 驗證驗收情境，並透過 Playwright 對即時應用程式執行 CSV 驅動的 E2E 測試 | `process` | 讀寫 | [speckit-test-validate](https://github.com/andstepanuk/speckit-test-validate) |
| ThreatSpec | STRIDE 與 AI/ML 威脅建模，具備威脅到測試的可追蹤性與安全收斂 | `process` | 讀寫 | [spec-kit-threatspec](https://github.com/hupe1980/spec-kit-threatspec) |
| Time Machine | 將完整的 SDD 工作流程追溯套用至既有程式碼庫，逐功能分析、制定規格並交付 | `process` | 讀寫 | [spec-kit-time-machine](https://github.com/teeyo/spec-kit-time-machine) |
| TinySpec | 適用於小任務的輕量單檔工作流程，略過繁重的多步驟 SDD 流程 | `process` | 讀寫 | [spec-kit-tinyspec](https://github.com/Quratulain-bilal/spec-kit-tinyspec) |
| Token Budget | 降低 Spec Kit 工作流程中的 LLM 權杖消耗：就地精簡產出物、限定各階段讀取範圍、抑制散文填充，並回報權杖用量 | `process` | 讀寫 | [spec-kit-token-budget](https://github.com/tinesoft/spec-kit-token-budget) |
| Token Consumption Analyzer | 捕捉、分析並比較 SDD 工作流程中的權杖消耗 | `visibility` | 唯讀 | [spec-kit-token-analyzer](https://github.com/coderandhiker/spec-kit-token-analyzer) |
| Token Economy | 權杖路由、測得的節省與脈絡稽核工作流程 | `process` | 讀寫 | [spec-kit-token-economy](https://github.com/formin/spec-kit-token-economy) |
| V-Model Extension Pack | 強制 V-Model 配對產生開發規格與測試規格，具備完整可追蹤性 | `docs` | 讀寫 | [spec-kit-v-model](https://github.com/leocamello/spec-kit-v-model) |
| Verify Extension | 實作後的品質關卡，對照規格產出物驗證已實作的程式碼 | `code` | 唯讀 | [spec-kit-verify](https://github.com/ismaelJimenez/spec-kit-verify) |
| Verify Review Ship | 收斂後的操作驗證、技術審查、學習治理與交易式交付。 | `process` | 讀寫 | [spec-kit-verify-review-ship](https://github.com/cadugevaerd/spec-kit-verify-review-ship) |
| Verify Tasks Extension | 偵測幻影完成：tasks.md 中標記為 [X] 但沒有真實實作的任務。 | `code` | 讀寫 | [spec-kit-verify-tasks](https://github.com/datastone-inc/spec-kit-verify-tasks) |
| Version Guard | 在規劃與實作前，對照即時 npm 登錄驗證技術堆疊版本 | `process` | 唯讀 | [spec-kit-version-guard](https://github.com/KevinBrown5280/spec-kit-version-guard) |
| Vurnix Honest Gate | 針對 AI 撰寫程式碼的確定性三態誠實關卡：編譯 + 幻影匯入 + 誠實測試計數合為一個判定，以程式碼執行，而不是代理自我審查。以結束碼判定 PASS/BLOCK/UNPROVEN。 | `process` | 唯讀 | [vurnix-spec-kit](https://github.com/shiersa/vurnix-spec-kit) |
| What-if Analysis | 在承諾之前，預覽需求變更的下游影響（複雜度、工作量、任務、風險） | `visibility` | 唯讀 | [spec-kit-whatif](https://github.com/DevAbdullah90/spec-kit-whatif) |
| Wireframe Visual Feedback Loop | 規格驅動開發的 SVG 線框圖產生、審查與簽核。經核准的線框圖成為 /speckit.plan、/speckit.tasks 與 /speckit.implement 遵循的規格限制 | `visibility` | 讀寫 | [spec-kit-extension-wireframe](https://github.com/TortoiseWolfe/spec-kit-extension-wireframe) |
| Work IQ | 將 Microsoft 365 組織知識整合至規格驅動開發工作流程 | `integration` | 唯讀 | [spec-kit-workiq](https://github.com/sakitA/spec-kit-workiq) |
| Worktree Isolation | 產生隔離的 git worktrees，以進行平行功能開發，無需切換簽出 | `process` | 讀寫 | [spec-kit-worktree](https://github.com/Quratulain-bilal/spec-kit-worktree) |
| Worktrees | 預設啟用的 worktree 隔離，服務平行代理，採同層或巢狀配置 | `process` | 讀寫 | [spec-kit-worktree-parallel](https://github.com/dango85/spec-kit-worktree-parallel) |

若要提交你自己的擴充功能，請參閱 [Extension Publishing Guide](../extensions/publishing.md)。
