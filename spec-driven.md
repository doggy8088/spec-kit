# 規格驅動開發（Specification-Driven Development, SDD）

## 權力結構的顛倒

數十年來，程式碼一直是王道。規格只是為程式碼服務——它們是我們搭建後便丟棄的鷹架，一旦「真正的工作」——寫程式——開始後就被拋諸腦後。我們撰寫產品需求文件（PRD）來引導開發，製作設計文件來指導實作，繪製架構圖來視覺化系統結構。但這些始終從屬於程式碼本身。程式碼才是真理，其他一切充其量只是美好的意圖。程式碼是唯一的真相來源，當程式碼持續演進時，規格往往跟不上腳步。由於資產（程式碼）與實作合而為一，若不從程式碼出發，要有平行的實作並不容易。

規格驅動開發（SDD）顛倒了這種權力結構。規格不再為程式碼服務——而是程式碼為規格服務。產品需求文件（PRD）不再只是實作的指引，而是生成實作的來源。技術規劃不再只是用來指導程式設計的文件，而是能產出程式碼的精確定義。這不只是軟體開發方式的漸進式改良，而是對於驅動開發本質的根本性重新思考。

規格與實作之間的鴻溝，自軟體開發誕生以來就困擾著我們。我們嘗試用更好的文件、更細緻的需求、更嚴謹的流程來彌補這個鴻溝。但這些方法失敗了，因為它們將這個鴻溝視為不可避免，只是試圖縮小而無法消除。SDD 透過讓規格及其具體的實作計畫從規格本身即可執行，徹底消除了這個鴻溝。當規格與實作計畫能自動產生程式碼時，鴻溝不復存在——只剩下轉化。

這種轉化如今成為可能，是因為 AI 已能理解並實作複雜的規格，並產生詳細的實作計畫。但如果沒有結構，單純的 AI 生成只會帶來混亂。SDD 透過精確、完整且無歧義的規格與後續實作計畫，提供了這種結構，能夠產生可運作的系統。規格成為主要產物，程式碼則是其在特定語言與框架下的表達（根據實作計畫產生的實作）。

在這個新世界裡，維護軟體就是演進規格。開發團隊的意圖以自然語言（「**意圖驅動開發**」）、設計資產、核心原則及其他指引來表達。開發的**通用語言（lingua franca）**提升到更高層次，程式碼則是最後一哩路的實現。

除錯意味著修正產生錯誤程式碼的規格及其實作計畫。重構則是為了讓結構更清晰。整個開發流程圍繞規格這個核心真相來源重組，實作計畫與程式碼則是持續再生的產出。當我們要為應用程式新增功能或創建新的平行實作（因為我們是有創造力的生物），就是回頭檢視規格並產生新的實作計畫。這個過程因此是 0 -> 1, (1', ..), 2, 3, N。

開發團隊能專注於創造力、實驗精神與批判性思考。

## SDD 實務工作流程

這個流程從一個想法開始——通常模糊且不完整。透過與 AI 的反覆對話，這個想法逐步轉化為完整的 PRD。AI 會提出釐清問題、找出邊界案例，並協助定義精確的驗收標準。在傳統開發中，這些可能需要數天會議與文件作業，但在 SDD 下，只需數小時的專注規格工作即可完成。這徹底改變了傳統的軟體開發生命週期（SDLC）——需求與設計成為持續進行的活動，而非離散階段。這也支持**團隊流程**，團隊審查過的規格可以分支、版本化並合併。

當產品經理更新驗收標準時，實作計畫會自動標記受影響的技術決策。當架構師發現更好的模式時，PRD 也會更新以反映新的可能性。

在規格流程中，研究代理會收集關鍵背景資訊。他們會調查函式庫相容性、效能基準、安全性影響。組織限制也會自動發現並套用——例如公司資料庫標準、認證需求、部署政策等，無縫整合進每一份規格。

從 PRD 出發，AI 會產生將需求對應到技術決策的實作計畫。每個技術選擇都有文件記錄其理由。每個架構決策都可追溯到具體需求。整個過程中，一致性驗證持續提升品質。AI 持續分析規格中的歧義、矛盾與缺漏——這不是一次性的檢查，而是持續精煉的過程。

只要規格與實作計畫穩定到一定程度，就可以開始產生程式碼，但它們不必「完整」。早期產出的程式碼可能是探索性的——用來驗證規格在實務上的合理性。領域概念轉化為資料模型。使用者故事轉化為 API 端點。驗收情境轉化為測試。這種方式將開發與測試合而為一——測試情境不是在程式碼完成後才撰寫，而是作為規格的一部分，同時產生實作與測試。

回饋循環延伸到初始開發之外。生產環境的指標與事件不僅觸發 hotfix——它們還會更新規格，供下次再生產用。效能瓶頸成為新的非功能性需求。安全漏洞則成為影響所有未來產出的限制。這種規格、實作與運維現實間的反覆交互，才是真正理解的來源，也是傳統 SDLC 轉化為持續演進的關鍵。

## 為何 SDD 現在至關重要

三大趨勢讓 SDD 不只是可能，更是必要：

首先，AI 能力已達到門檻，自然語言規格能可靠地產生可運作的程式碼。這不是要取代開發者——而是透過自動化從規格到實作的機械轉譯，放大開發者的效能。它能強化探索與創造力，讓「重新開始」變得容易，並支持增刪與批判性思考。

其次，軟體複雜度持續呈指數成長。現代系統整合了數十種服務、框架與相依元件。要靠人工流程來維持所有這些元件與原始意圖一致，越來越困難。SDD 透過規格驅動的產生流程，系統性地維持一致。未來的框架可能會優先支援 AI，而非以人為主，或是圍繞可重用元件來設計。

第三，變革速度加快。今日需求變動的頻率遠超以往。轉向（pivot）不再是例外，而是常態。現代產品開發要求根據用戶回饋、市場狀況與競爭壓力快速迭代。傳統開發將這些變動視為干擾。每次轉向都需要手動將變更傳遞到文件、設計與程式碼。結果不是緩慢、謹慎的更新限制了速度，就是快速、魯莽的變更累積了技術債。

SDD 能支援假設/模擬實驗：「如果我們需要重新實作或更改應用程式，以促進業務需求（例如多賣 T-shirt），我們該如何實作與實驗？」

SDD 將需求變更從障礙轉化為日常流程。當規格驅動實作時，轉向變成系統化的再生產，而非人工重寫。只要在 PRD 中變更核心需求，受影響的實作計畫就會自動更新。修改使用者故事，對應的 API 端點也會再生產。這不僅僅是初始開發——而是讓工程速度在不可避免的變動中持續維持。

## 核心原則

**規格作為通用語言（Lingua Franca）**：規格成為主要產物，程式碼則是其在特定語言與框架下的表達。維護軟體即是演進規格。

**可執行規格**：規格必須足夠精確、完整且無歧義，才能產生可運作的系統。這消除了意圖與實作之間的鴻溝。

**持續精煉**：一致性驗證是持續進行的，而非一次性的檢查。AI 持續分析規格中的歧義、矛盾與缺漏。

**研究驅動的背景資訊**：研究代理在規格流程中收集關鍵背景，調查技術選項、效能影響與組織限制。

**雙向回饋**：生產環境的現實推動規格演進。指標、事件與運維經驗成為規格精煉的輸入。

**分支探索**：可從同一份規格產生多種實作方案，以探索不同的最佳化目標——效能、可維護性、用戶體驗、成本等。

## 實作方式

目前，實踐 SDD 需組合現有工具並在流程中保持紀律。此方法論可透過以下方式實踐：

- 利用 AI 助理進行反覆的規格開發
- 研究代理收集技術背景資訊
- 程式碼生成工具將規格轉譯為實作
- 適應規格優先流程的版本控制系統
- 透過 AI 分析規格文件進行一致性檢查

關鍵在於將規格視為真相來源，程式碼則是服務於規格的產出，而非反過來。

## 以指令簡化 SDD

SDD 方法論透過三個強大的指令大幅自動化「規格 → 規劃 → 任務」的工作流程：

### `/specify` 指令

此指令將簡單的功能描述（使用者提示）轉換為完整、結構化的規格，並自動管理儲存庫：

1. **自動功能編號**：掃描現有規格，決定下一個功能編號（如 001、002、003）
2. **分支建立**：根據你的描述產生語意化分支名稱並自動建立
3. **模板化產生**：複製並依需求自訂功能規格模板
4. **目錄結構**：為所有相關文件建立正確的 `specs/[branch-name]/` 結構

### `/plan` 指令

當功能規格已存在時，此指令會產生完整的實作計畫：

1. **規格分析**：閱讀並理解功能需求、使用者故事與驗收標準
2. **憲章遵循**：確保與專案憲章及架構原則一致
3. **技術轉譯**：將商業需求轉換為技術架構與實作細節
4. **詳細文件**：產生資料模型、API 合約與測試情境的支援文件
5. **快速驗證指南**：產生涵蓋關鍵驗證情境的快速入門指南

### `/tasks` 指令

計畫產生後，此指令會分析計畫及相關設計文件，產生可執行的任務清單：

1. **輸入**：讀取 `plan.md`（必填），如有則讀取 `data-model.md`、`contracts/`、`research.md`
2. **任務推導**：將合約、實體與情境轉換為具體任務
3. **平行化**：標記獨立任務 `[P]`，並規劃安全的平行群組
4. **輸出**：在功能目錄下寫入 `tasks.md`，供 Task agent 執行

### 範例：建立聊天功能

以下說明這些指令如何轉化傳統開發流程：

**傳統方式：**

```text
1. Write a PRD in a document (2-3 hours)
2. Create design documents (2-3 hours)
3. Set up project structure manually (30 minutes)
4. Write technical specifications (3-4 hours)
5. Create test plans (2 hours)
Total: ~12 hours of documentation work
```

**採用 Commands 方法的 SDD：**

```bash
# Step 1: Create the feature specification (5 minutes)
/specify Real-time chat system with message history and user presence

# This automatically:
# - Creates branch "003-chat-system"
# - Generates specs/003-chat-system/spec.md
# - Populates it with structured requirements

# Step 2: Generate implementation plan (5 minutes)
/plan WebSocket for real-time messaging, PostgreSQL for history, Redis for presence

# Step 3: Generate executable tasks (5 minutes)
/tasks

# This automatically creates:
# - specs/003-chat-system/plan.md
# - specs/003-chat-system/research.md (WebSocket library comparisons)
# - specs/003-chat-system/data-model.md (Message and User schemas)
# - specs/003-chat-system/contracts/ (WebSocket events, REST endpoints)
# - specs/003-chat-system/quickstart.md (Key validation scenarios)
# - specs/003-chat-system/tasks.md (Task list derived from the plan)
```

在 15 分鐘內，你將完成：

- 一份完整的功能規格說明，包含使用者故事與驗收標準
- 一份詳細的實作計畫，說明技術選擇及其理由
- 已可用於程式碼產生的 API 合約與資料模型
- 針對自動化與手動測試的全面測試情境
- 所有文件皆已於功能分支中正確進行版本控管

### 結構化自動化的力量

這些指令不僅僅節省時間——它們還強制執行一致性與完整性：

1. **不遺漏任何細節**：範本確保每個面向都被考慮，從非功能性需求到錯誤處理
2. **決策可追溯**：每一項技術選擇都能回溯到特定需求
3. **活文件（Living Documentation）**：規格與程式碼保持同步，因為規格會自動產生程式碼
4. **快速迭代**：需求變更與計畫重生僅需數分鐘，而非數天

這些指令體現了 SDD 原則，將規格視為可執行產物，而非靜態文件。它們將規格制定流程，從一項不得不做的苦差事，轉變為開發的驅動力。

### 範本驅動的品質：結構如何約束大型語言模型 (LLM) 以提升成果

這些指令的真正威力，不僅在於自動化，更在於範本如何引導大型語言模型 (LLM) 產生更高品質的規格。這些範本就像精密的提示，能以有效方式約束 LLM 的輸出：

#### 1. **防止過早涉及實作細節**

功能規格範本會明確指示：

```text
- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
```

此限制強制大型語言模型 (LLM) 維持適當的抽象層級。當 LLM 可能會自然地跳到「使用 React 搭配 Redux 實作」時，這個範本則讓它專注於「使用者需要即時更新他們的資料」。這種區隔確保了規格在實作技術變動時依然能保持穩定。

#### 2. **強制標示明確的不確定性標記**

兩個範本都要求使用 `[NEEDS CLARIFICATION]` 標記：

```text
When creating this spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question]
2. **Don't guess**: If the prompt doesn't specify something, mark it
```

這可以防止大型語言模型 (LLM) 常見的行為——做出看似合理但可能不正確的假設。LLM 不會猜測「登入系統」是採用 email/password 驗證，而是必須標記為 `[NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]`。

#### 3. **透過檢查清單進行結構化思考**

這些範本包含完整的檢查清單，作為規格的「單元測試」：

```markdown
### Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
```

這些檢查清單強制大型語言模型 (LLM) 系統性地自我檢查其輸出，能夠捕捉到那些可能會被忽略的疏漏。這就像是為 LLM 提供一個品質保證的框架。

#### 4. **透過階段閘門確保合憲性**

實作計畫範本會透過階段閘門（phase gates）來強制執行架構原則：

```markdown
### Phase -1: Pre-Implementation Gates
#### Simplicity Gate (Article VII)
- [ ] Using ≤3 projects?
- [ ] No future-proofing?
#### Anti-Abstraction Gate (Article VIII)
- [ ] Using framework directly?
- [ ] Single model representation?
```

這些 gate（閘門）可防止過度設計，因為它們要求大型語言模型 (LLM) 必須明確說明任何複雜性的理由。如果某個 gate 未通過，LLM 必須在「複雜性追蹤」區段中記錄原因，為架構決策創造問責機制。

#### 5. **階層式細節管理**

這些範本強制執行正確的資訊架構：

```text
**IMPORTANT**: This implementation plan should remain high-level and readable.
Any code samples, detailed algorithms, or extensive technical specifications
must be placed in the appropriate `implementation-details/` file
```

這樣可以避免規格文件淪為難以閱讀的程式碼傾倒（code dump）這一常見問題。大型語言模型 (LLM) 會學習維持適當的細節層級，將複雜度抽離到其他檔案，同時讓主文件保持易於瀏覽。

#### 6. **測試優先思維（Test-First Thinking）**

實作範本強制執行測試優先（test-first）開發：

```text
### File Creation Order
1. Create `contracts/` with API specifications
2. Create test files in order: contract → integration → e2e → unit
3. Create source files to make tests pass
```

這種排序約束確保大型語言模型 (LLM) 在實作之前，會先考慮可測試性與契約，從而產生更健全且可驗證的規格。

#### 7. **防止推測性功能**

範本會明確地避免推測性設計：

```text
- [ ] No speculative or "might need" features
- [ ] All phases have clear prerequisites and deliverables
```

這能防止大型語言模型 (LLM) 添加那些「可有可無」卻會讓實作變複雜的功能。每一項功能都必須能追溯到具體的使用者故事，並擁有明確的驗收標準。

### 複合效應

這些約束條件相互配合，產生出具備以下特性的規格：

- **完整性**：檢查清單確保沒有遺漏任何事項
- **無歧義性**：強制澄清標記突顯所有不確定之處
- **可測試性**：測試優先的思維深植於流程之中
- **可維護性**：適當的抽象層級與資訊層次結構
- **可實作性**：明確的階段與具體的交付成果

這些範本將 LLM 從一位創意寫作者轉變為一名嚴謹的規格工程師，將其能力導向產出持續高品質、可執行、真正推動開發的規格文件。

## 憲法基礎：強化架構紀律

SDD 的核心是一部憲法——一套不可變更的原則，規範規格如何轉化為程式碼。這部憲法（`memory/constitution.md`）就像系統的架構 DNA，確保每一次產生的實作都能維持一致性、簡潔性與品質。

### 開發的九大條款

這部憲法定義了九大條款，影響開發流程的每一個層面：

#### 條款一：Library-First 原則

每一項功能都必須從獨立的 library 開始——沒有例外。這強制從一開始就採用模組化設計：

```text
Every feature in Specify MUST begin its existence as a standalone library.
No feature shall be implemented directly within application code without
first being abstracted into a reusable library component.
```

此原則確保規格能夠產生模組化、可重複使用的程式碼，而非單一龐大的應用程式。當大型語言模型 (LLM) 生成實作計劃時，必須將功能結構化為具有明確邊界且相依性最小的函式庫。

#### 第二條：CLI 介面強制規定

每個函式庫都必須透過命令列介面 (Command Line Interface) 對外公開其功能：

```text
All CLI interfaces MUST:
- Accept text as input (via stdin, arguments, or files)
- Produce text as output (via stdout)
- Support JSON format for structured data exchange
```

這強制要求可觀測性與可測試性。大型語言模型 (LLM) 不能將功能隱藏在不透明的類別中——所有內容都必須能透過文字介面存取並驗證。

#### 第三條：測試優先原則

這是最具變革性的條款——在有測試之前不得撰寫程式碼：

```text
This is NON-NEGOTIABLE: All implementation MUST follow strict Test-Driven Development.
No implementation code shall be written before:
1. Unit tests are written
2. Tests are validated and approved by the user
3. Tests are confirmed to FAIL (Red phase)
```

這種方式完全顛覆了傳統的 AI 程式碼生成流程。大型語言模型 (LLM) 不再是直接生成程式碼並期待其能正常運作，而是必須先生成定義行為的完整測試，經過審核通過後，才開始撰寫實作。

#### 第七與第八條：簡單性與反抽象

這兩條原則旨在對抗過度工程化：

```text
Section 7.3: Minimal Project Structure
- Maximum 3 projects for initial implementation
- Additional projects require documented justification

Section 8.1: Framework Trust
- Use framework features directly rather than wrapping them
```

當大型語言模型 (LLM) 可能自然地產生過於繁複的抽象時，這些文章則強制要求其為每一層複雜性提供正當理由。實作計畫範本中的「Phase -1 Gates」直接落實了這些原則。

#### 第九條：以整合為優先的測試（Integration-First Testing）

優先考慮真實世界的測試，而非孤立的單元測試：

```text
Tests MUST use realistic environments:
- Prefer real databases over mocks
- Use actual service instances over stubs
- Contract tests mandatory before implementation
```

這可確保產生的程式碼在實務上可行，而不僅僅是在理論上。

### 透過範本進行憲法式強制執行

實作計畫範本透過具體的檢查點，將這些條款落實於實際操作中：

```markdown
### Phase -1: Pre-Implementation Gates
#### Simplicity Gate (Article VII)
- [ ] Using ≤3 projects?
- [ ] No future-proofing?

#### Anti-Abstraction Gate (Article VIII)
- [ ] Using framework directly?
- [ ] Single model representation?

#### Integration-First Gate (Article IX)
- [ ] Contracts defined?
- [ ] Contract tests written?
```

這些 gate（閘門）在編譯階段對架構原則進行檢查。大型語言模型 (LLM) 必須通過這些 gate，否則必須在 "Complexity Tracking"（複雜度追蹤）區段中記錄有正當理由的例外，否則無法繼續執行。

### 不可變原則的力量

憲法的力量在於其不可變性。雖然實作細節可以演進，但核心原則始終保持不變。這帶來以下優勢：

1. **跨時間的一致性**：今天產生的程式碼與明年產生的程式碼遵循相同的原則
2. **跨大型語言模型 (LLM) 的一致性**：不同的 AI 模型產生的程式碼在架構上能夠相容
3. **架構完整性**：每個功能都能強化而非削弱系統設計
4. **品質保證**：先測試、優先使用函式庫，以及簡單性原則確保程式碼易於維護

### 憲法的演進

雖然原則不可變，但其應用方式可以隨著時間演進：

```text
Section 4.2: Amendment Process
Modifications to this constitution require:
- Explicit documentation of the rationale for change
- Review and approval by project maintainers
- Backwards compatibility assessment
```

這種方法論能夠在維持穩定性的同時，持續學習與改進。憲章本身會隨著時間記錄修訂，展現其演進過程，並說明原則如何根據實際經驗加以精煉。

### 超越規則：一種開發哲學

這份憲章不僅僅是一本規則手冊——它是一種塑造大型語言模型 (LLM) 如何思考程式碼生成的哲學：

- **可觀察性優於不透明性**：一切都必須能透過命令列介面 (Command Line Interface) 進行檢查
- **簡單優於巧妙**：從簡單出發，僅在確實必要時才增加複雜性
- **整合優於孤立**：在真實環境中測試，而非人工環境
- **模組化優於巨石式架構**：每個功能都是具備明確邊界的函式庫

透過將這些原則嵌入規格與規劃流程，SDD（規格驅動開發）確保產生的程式碼不僅僅是可運作的——更是易於維護、可測試且具備良好架構。這份憲章讓 AI 從單純的程式碼產生器，轉變為尊重並強化系統設計原則的架構夥伴。

## 轉變

這並不是要取代開發者或自動化創造力，而是透過自動化機械式的轉譯來強化人類能力。這是要建立一個緊密的回饋循環，讓規格、研究與程式碼共同演進，每一次迭代都帶來更深的理解，以及更好地對齊意圖與實作。

軟體開發需要更好的工具來維持意圖與實作的一致性。SDD 提供了一套方法論，透過可執行的規格來產生程式碼，而不僅僅是指引程式碼的撰寫，從而實現這種一致性。
