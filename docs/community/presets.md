# 社群預設集

> [!NOTE]
> 社群預設集由各自作者獨立建立與維護。維護者僅確認型錄項目完整且格式正確，不審查、稽核、背書或支援預設集程式碼本身。安裝前請先檢視預設集原始碼，並自行斟酌使用。

以下社群貢獻的預設集可自訂 Spec Kit 的行為，在不更動任何工具的情況下覆寫範本、命令與術語。預設集可於 [`catalog.community.json`](https://github.com/github/spec-kit/blob/main/presets/catalog.community.json) 取得：

| 預設集 | 用途 | 提供內容 | 需要 | URL |
|--------|---------|----------|----------|-----|
| A11Y Governance | 為 Spec Kit 加入無障礙（WCAG 2.2 AA）、無障礙文字與 JSON 狀態一致性、雙語 DE/EN 交付、CEFR-B2 可讀性、包容性內容治理、教學式行內程式碼註解審查，以及可供稽核的 Spec-Kit 執行證據。 | 11 個範本、3 個命令 | — | [spec-kit-preset-a11y-governance](https://github.com/hindermath/spec-kit-preset-a11y-governance) |
| Agent Parity Governance | 在已宣告的 AI 代理介面上，加入共用指引一致性、機群完成證據、無秘密的執行器中繼資料、可供稽核的 Spec Kit 證據，以及與代理無關的模型路由。 | 7 個範本、3 個命令 | — | [spec-kit-preset-agent-parity-governance](https://github.com/hindermath/spec-kit-preset-agent-parity-governance) |
| Agentstandards Task Gate | 嚴格封鎖 Spec Kit 任務產生，直到已持久化的多廠商架構關卡為 READY 為止。 | 1 個命令 | agentstandards 擴充功能 | [agentstandards](https://github.com/bbjwz/agentstandards) |
| AIDE In-Place Migration | 將 AIDE 擴充功能工作流程調整為就地技術遷移（X → Y 模式），加入遷移目標、驗證關卡、知識文件與行為等價標準 | 2 個範本、8 個命令 | AIDE 擴充功能 | [spec-kit-presets](https://github.com/mnriem/spec-kit-presets) |
| Architecture Governance | 為 Spec Kit 加入安全架構、STRIDE/CAPEC 威脅模型、arc42、S-ADRs、Zero Trust、SAMM、C3A/C5 雲端保證，以及可供稽核的證據。 | 15 個範本、3 個命令 | — | [spec-kit-preset-architecture-governance](https://github.com/hindermath/spec-kit-preset-architecture-governance) |
| Autonomous Run Governance | 加入受權限約束的自主交付，具備與索引綁定的分階段路徑、一般檔案模式與位元組、語意完成、精確 HEAD 證據，以及與雜湊綁定的歷史空白例外。 | 16 個範本、5 個命令、11 個指令碼 | — | [spec-kit-preset-autonomous-run-governance](https://github.com/hindermath/spec-kit-preset-autonomous-run-governance) |
| Canon Core | 調整原始 Spec Kit 工作流程，使其與 Canon 擴充功能協同運作 | 2 個範本、8 個命令 | — | [spec-kit-canon](https://github.com/maximiliamus/spec-kit-canon) |
| Claude AskUserQuestion | 將 Claude Code 上的 `/speckit.clarify` 與 `/speckit.checklist` 從 Markdown 表格提示詞升級為原生的 AskUserQuestion 選擇器，每個問題都附推薦選項與理由 | 2 個命令 | — | [spec-kit-preset-claude-ask-questions](https://github.com/0xrafasec/spec-kit-preset-claude-ask-questions) |
| Closed Vocabulary Check | 為 /speckit.analyze 加入一輪檢查，標記以不同成員多次列舉的封閉值集合，並回報自身的涵蓋範圍。 | 1 個命令 | — | [spec-kit-preset-closed-vocabulary](https://github.com/yunusdim/spec-kit-preset-closed-vocabulary) |
| Command Density | 精簡九個核心 Spec Kit 命令提示詞，同時保留指令碼、交接、佔位符、掛鉤輸出區塊與規則結構 | 9 個命令 | — | [spec-kit-preset-command-density](https://github.com/Xopoko/spec-kit-preset-command-density) |
| Cross-Platform Governance | 加入 Bash/PowerShell 一致性、唯讀檢查、路徑與原生覆寫審查、Unix man 頁面、雙語 PowerShell 說明，以及與服務提供者無關的模型路由。 | 9 個範本、3 個命令 | — | [spec-kit-preset-cross-platform-governance](https://github.com/hindermath/spec-kit-preset-cross-platform-governance) |
| Database Standards | 規格驅動工作的資料庫慣例：命名、資料模型設計、條件約束、資料保護、效能、查詢安全、結構描述審查檢核清單，以及引擎專屬參考。與 ORM 無關。 | 4 個範本、1 個命令 | — | [spec-kit-preset-db-standards](https://github.com/gdakuzak/spec-kit-preset-db-standards) |
| Explicit Task Dependencies | 為 tasks.md 加入明確的 `(depends on T###)` 相依性宣告與執行波次 DAG，以利平行排程 | 1 個範本、1 個命令 | — | [spec-kit-preset-explicit-task-dependencies](https://github.com/Quratulain-bilal/spec-kit-preset-explicit-task-dependencies) |
| Fiction Book Writing | 調整規格驅動開發工作流程以用於說故事，創作 12 種語言的書籍或有聲書（附註解）：功能成為故事元素，規格成為故事簡報，計畫成為故事結構，任務成為逐場景寫作任務。支援單一與多 POV、所有主要情節結構框架，以及兩種風格模式：作者聲音範例或人性化 AI 散文原則。支援腦力激盪、訪談、角色扮演等互動元素，以及統計、封面產生器、插圖產生器與 bio 命令等額外功能。支援以 KDP、D2D 等範本匯出。 | 26 個範本、34 個命令、2 個指令碼 | — | [speckit-preset-fiction-book-writing](https://github.com/adaumann/speckit-preset-fiction-book-writing) |
| Game Narrative Writing | 用於遊戲敘事設計與互動說故事的預設集。調整規格驅動開發工作流程以用於遊戲敘事：功能成為故事機制，規格成為敘事簡報，計畫成為故事地圖，任務成為對話與場景寫作任務。支援分支敘事、玩家能動性系統、狀態機與互動對話樹。 | 37 個範本、34 個命令、5 個指令碼 | — | [speckit-preset-game-narrative-writing](https://github.com/adaumann/speckit-preset-game-narrative-writing) |
| Intake Authoring Governance | 治理可追蹤的 intake CRUD、具語言意識的需求集合、受限的公開 HTTPS 來源，以及經明確核准的單篇或系列撰寫。 | 13 個範本、5 個命令、9 個指令碼 | — | [spec-kit-preset-intake-authoring-governance](https://github.com/hindermath/spec-kit-preset-intake-authoring-governance) |
| Intake Review Governance | 在 Spec Kit 執行前，審查單篇、系列、活動與具語言意識的需求集合。 | 9 個範本、3 個命令、5 個指令碼 | — | [spec-kit-preset-intake-review-governance](https://github.com/hindermath/spec-kit-preset-intake-review-governance) |
| Intake Sequencing Governance | 管理具語言意識的 intake 系列順序、具型別的相依性、生命週期，以及與權威無關的下一候選者選擇。 | 12 個範本、6 個命令、8 個指令碼 | — | [spec-kit-preset-intake-sequencing-governance](https://github.com/hindermath/spec-kit-preset-intake-sequencing-governance) |
| Inventory Alignment | 在寫入前，將每個需求對照即時 ID 的唯讀清單分類，讓改寫的需求被更新而不是重複建立。 | 1 個範本、2 個命令 | speckit-inventory 擴充功能 | [spec-kit-inventory-alignment](https://github.com/Yash-Chindam/spec-kit-inventory-alignment) |
| iSAQB Architecture Governance | 加入 iSAQB/CPSA-F 與 arc42 架構治理，並提供 Spec-Kit 證據，涵蓋目標、觀點、品質情境、ADRs、風險與技術債。 | 14 個範本、3 個命令 | — | [spec-kit-preset-isaqb-architecture-governance](https://github.com/hindermath/spec-kit-preset-isaqb-architecture-governance) |
| Jira Issue Tracking | 覆寫 `speckit.taskstoissues`，透過 Atlassian MCP 工具建立 Jira epics、stories 與 tasks，而不是 GitHub Issues | 1 個命令 | — | [spec-kit-preset-jira](https://github.com/luno/spec-kit-preset-jira) |
| Model Driven Engineering | 專注於精簡命令、應用程式儲存庫支援、跨規格支援，以及具能力意識的專案記憶，服務模型驅動工程工作流程 | 6 個範本、11 個命令 | MDE 擴充功能 | [spec-kit-preset-mde](https://github.com/AI-MDE/spec-kit-preset-mde) |
| Model Routing Governance | 將與服務提供者無關的 Spec Kit 角色對應至經驗證的 harness 本機執行器設定檔，不將模型可用性、憑證或機器專屬選擇存入 Git。 | 4 個範本、2 個命令、2 個指令碼 | — | [spec-kit-preset-model-routing-governance](https://github.com/hindermath/spec-kit-preset-model-routing-governance) |
| Multi-Repo Branching | 在 plan 與 tasks 階段，協調多個 git 儲存庫（獨立儲存庫與子模組）的功能分支建立 | 2 個命令 | — | [spec-kit-preset-multi-repo-branching](https://github.com/sakitA/spec-kit-preset-multi-repo-branching) |
| NIEM Information Exchanges | 為 core、assess 與 bugfix 流程加入以證據為基礎的 NIEM 交換建模，同時保留其命令、產出物與範圍。 | 7 個範本、18 個命令 | assess 擴充功能、bug 擴充功能 | [spec-kit-presets](https://github.com/mnriem/spec-kit-presets) |
| OpenProject Work Packages | 覆寫 speckit.taskstoissues，透過 OpenProject MCP 伺服器建立 OpenProject 工作包（階段、任務、子任務、關聯），而不是 GitHub Issues | 1 個命令 | — | [speckit-openproject](https://github.com/Nachklang-io/speckit-openproject) |
| OpenUP Governance | 將 OpenUP 生命週期治理組入 Spec Kit 自己的憲章、規格、計畫與任務範本，並以受治理的執行合約包裝 /tasks 與 /implement。 | 4 個範本、2 個命令 | openup 擴充功能 | [specup](https://github.com/anvigo12/specup) |
| Parallel Autonomous Run Governance | 協調隔離的自主活動，並可選擇性地以目前活動的 intake 審查作為工作者排程的關卡。 | 10 個範本、5 個命令、2 個指令碼 | autonomous-run-governance >=0.2.2；選用：intake-review-governance >=0.1.0 | [spec-kit-preset-parallel-autonomous-run-governance](https://github.com/hindermath/spec-kit-preset-parallel-autonomous-run-governance) |
| Pirate Speak (Full) | 將所有 Spec Kit 輸出轉換為海盜用語，規格變成「Voyage Manifests」，計畫變成「Battle Plans」，任務變成「Crew Assignments」 | 6 個範本、9 個命令 | — | [spec-kit-presets](https://github.com/mnriem/spec-kit-presets) |
| Project Statistics Governance | 可重現且與 Git 綁定的專案透明度，具備離線測量、明確的寫入權限與選擇性啟用的參考估計；不主張 AI 生產力。 | 4 個範本、3 個命令、2 個指令碼 | — | [spec-kit-preset-project-statistics-governance](https://github.com/hindermath/spec-kit-preset-project-statistics-governance) |
| Screenwriting | 用於編劇／劇本寫作／教學的規格驅動開發：劇情長片、電視（試播集、單集、有限影集）與舞台劇。將 Spec Kit 工作流程調整為劇本工藝，包含 slug lines、action lines、幕間斷點、節拍表與業界標準的提案文件。支援三幕式、Save the Cat、TV 試播集、無線電視單集、有線／串流單集與舞台劇結構框架。匯出至 Fountain、FTX、PDF | 26 個範本、32 個命令、1 個指令碼 | — | [speckit-preset-screenwriting](https://github.com/adaumann/speckit-preset-screenwriting) |
| Secure Development Assurance Governance | 驗證專案持有的安全開發資訊清單、版本、正規化雜湊、檢核清單、審查、風險、結案與映像影響證據，不授予人工核准或認證。 | 2 個範本、2 個命令、2 個指令碼 | — | [spec-kit-preset-secure-development-assurance-governance](https://github.com/hindermath/spec-kit-preset-secure-development-assurance-governance) |
| Security Governance | 為 Spec Kit 加入安全程式設計、記憶體安全語言指引、安全關卡與供應鏈證據，以及範圍限定的 GDPR、NIS2、CRA、EU AI Act 與 DORA 篩查。 | 19 個範本、3 個命令 | — | [spec-kit-preset-security-governance](https://github.com/hindermath/spec-kit-preset-security-governance) |
| SicarioSpec Core | 安全預設的 Spec Kit 治理基準設定檔。 | 5 個範本 | — | [sicario-spec](https://github.com/dfirs1car1o/sicario-spec) |
| Software Humano | 將 Software Humano 宣言的要求編入八個核心 Spec Kit 命令，以及規格、計畫與任務範本中，引用宣言的原文而不是改寫。 | 4 個範本、8 個命令 | — | [software-humano-speckit](https://github.com/dacunao/software-humano-speckit) |
| Spec2Cloud | 為交付至 Azure 調整的規格驅動工作流程：spec → plan → tasks → implement → deploy | 5 個範本、8 個命令 | — | [spec2cloud](https://github.com/Azure-Samples/Spec2Cloud) |
| SpecAssay | 將持久 ID、Carries 與 SpecAssay 詞彙附加至 Spec Kit 規格、任務與憲章範本。 | 3 個範本 | specassay-check 擴充功能 | [specassay](https://github.com/rdryfoos/specassay) |
| Table of Contents Navigation | 為產生的 spec.md、plan.md 與 tasks.md 文件加入可導覽的目錄 | 3 個範本、3 個命令 | — | [spec-kit-preset-toc-navigation](https://github.com/Quratulain-bilal/spec-kit-preset-toc-navigation) |
| Test-First Governance | 以涵蓋完整的 BDD/ATDD Gherkin 情境、明確的套件歸屬、專業的測試報告、可追蹤性與以風險為基礎的品質關卡，治理 TDD。 | 10 個範本、8 個命令 | — | [spec-kit-preset-test-first-governance](https://github.com/ka-zo/spec-kit-preset-test-first-governance) |
| Verified Codebase Context | 產生具證據限定的儲存庫脈絡，並在計畫、任務、分析與實作中運用 | 1 個範本、5 個命令 | — | [spec-kit-preset-codebase-memory-context](https://github.com/philo-x/spec-kit-preset-codebase-memory-context) |
| VS Code Ask Questions | 強化 clarify 命令，使用 `vscode/askQuestions` 進行批次互動提問。 | 1 個命令 | — | [spec-kit-presets](https://github.com/fdcastel/spec-kit-presets) |
| Workflow Preset | 以行為為先的規格、設計產出物與代理原生交接協調，加入需求階段行為草稿、正式 BDD/UIF/行為合約、選用的設計產出物，以及範圍限定的實作交接，具備 Core Agent、Vertical Planner Agent 與 Worker Agent 模式 | 22 個範本、8 個命令 | — | [spec-kit-workflow-preset](https://github.com/bigsmartben/spec-kit-workflow-preset) |

若要建置並發佈自己的預設集，請參閱 [Presets Publishing Guide](https://github.com/github/spec-kit/blob/main/presets/PUBLISHING.md)。
