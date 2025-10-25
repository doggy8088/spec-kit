# Spec-Driven Development 方法論（SDD）

## 權力結構的翻轉

數十年來，程式碼一直是王者。規格說明服務於程式碼——它們像鷹架一樣支撐著開發，等到「真正的工作」——寫程式碼——開始後就被拋棄。我們撰寫 PRD（產品需求文件）來指導開發，創建設計文件來輔助實作，繪製圖表來視覺化架構。但這些始終從屬於程式碼本身。程式碼才是真理。其他一切，充其量只是美好的意圖。程式碼是唯一的真實來源，而當程式碼持續演進時，規格說明往往跟不上腳步。由於資產（程式碼）與實作本身是一體的，想要有平行的實作，除非從程式碼出發，否則並不容易。

Spec-Driven Development（SDD）方法論顛覆了這種權力結構。規格說明不再服務於程式碼——而是程式碼服務於規格說明。PRD（產品需求文件）不再只是實作的指引，而是生成實作的來源。技術規劃不再只是輔助程式設計的文件，而是能產生程式碼的精確定義。這不僅僅是對軟體開發方式的漸進式改進，而是對驅動開發本質的根本性重新思考。

規格說明與實作之間的鴻溝，自軟體開發誕生以來就困擾著我們。我們嘗試用更完善的文件、更詳盡的需求、更嚴格的流程來彌補這個鴻溝。但這些方法之所以失敗，是因為它們認為這個鴻溝是不可避免的。它們試圖縮小鴻溝，卻從未能消除它。SDD 則通過讓規格說明及其具體的實作計畫自規格說明中誕生且可執行，徹底消除了這個鴻溝。當規格說明與實作計畫能夠自動生成程式碼時，鴻溝不復存在——只剩下轉化。

這種轉化如今成為可能，因為 AI 已能理解並實作複雜的規格說明，並產生詳盡的實作計畫。但如果沒有結構，單純的 AI 生成只會帶來混亂。SDD 通過規格說明及其後續的實作計畫，提供了這種結構——這些規格必須精確、完整且無歧義，足以生成可運作的系統。規格說明成為主要產物。程式碼則成為它在特定語言與框架下的表達（依據實作計畫生成的實作）。

在這個新世界裡，維護軟體意味著持續演進規格說明。開發團隊的意圖以自然語言（「**意圖驅動開發**」）、設計產物、核心原則及其他指引來表達。開發的**共通語言（lingua franca）**提升到更高層次，程式碼則成為最後一哩路的表現形式。

除錯意味著修正產生錯誤程式碼的規格說明及實作計畫。重構則是為了提升清晰度而進行的結構調整。整個開發流程圍繞規格說明作為唯一真實來源來重組，實作計畫與程式碼則成為持續再生的產物。當我們要為應用新增功能或創建新的平行實作（因為我們是有創造力的生物），就要回到規格說明並創建新的實作計畫。這個過程因此是 0 -> 1, (1', ..), 2, 3, N。

開發團隊可以專注於創意、實驗與批判性思考。

## SDD 實務工作流程

這個流程從一個想法開始——往往模糊且不完整。透過與 AI 的反覆對話，這個想法逐步發展成為完整的 PRD。AI 會提出釐清問題、識別邊界情境，並協助定義精確的驗收標準。在傳統開發中，這可能需要數天的會議與文件作業，但在 SDD 下，只需數小時的專注規格說明工作即可完成。這徹底改變了傳統 SDLC——需求與設計變成持續進行的活動，而非離散的階段。這也支持**團隊流程**，團隊審查過的規格說明可以被表達、版本化、在分支中創建並合併。

當產品經理更新驗收標準時，實作計畫會自動標記受影響的技術決策。當架構師發現更好的設計模式時，PRD 也會隨之更新以反映新的可能性。

在整個規格說明過程中，研究代理（Research agents）會收集關鍵上下文。他們會調查函式庫相容性、效能基準、安全性影響等。組織限制也會自動被發現並套用——例如公司資料庫標準、驗證需求、部署政策等，都能無縫整合進每一份規格說明。

從 PRD 開始，AI 會生成將需求對應到技術決策的實作計畫。每一項技術選擇都有文件記錄其理由。每一個架構決策都可追溯到具體需求。整個過程中，一致性驗證持續提升品質。AI 會分析規格說明是否存在歧義、矛盾與缺漏——這不是一次性的檢查，而是持續優化的過程。

當規格說明與其實作計畫穩定到一定程度時，即可開始程式碼生成，但不必等到「完全」完成。早期生成的程式碼可能是探索性的——用來驗證規格說明在實務上是否合理。領域概念會轉化為資料模型。使用者故事會轉化為 API endpoint。驗收情境則成為測試。這種方式將開發與測試通過規格說明合而為一——測試情境不是寫完程式碼後才補上，而是規格說明的一部分，能同時生成實作與測試。

回饋循環不僅止於初始開發。生產環境的指標與事件不只是觸發 hotfix——它們會更新規格說明，以便下次再生。效能瓶頸會成為新的非功能性需求。安全漏洞則成為影響所有未來生成的限制。這種規格說明、實作與營運現實之間的反覆迴圈，才是真正理解的來源，也是傳統 SDLC 轉化為持續演進的關鍵。

## 為什麼 SDD 現在如此重要

有三大趨勢讓 SDD 不僅成為可能，更是必要：

首先，AI 能力已達到一個門檻，能夠從自然語言規格說明可靠地生成可運作的程式碼。這不是要取代開發者——而是通過自動化從規格到實作的機械轉換，放大他們的效能。它能放大探索與創造力，輕鬆支持「重新開始」，並支援增刪與批判性思考。

其次，軟體複雜度持續以指數級增長。現代系統整合了數十種服務、框架與相依性。要靠人工流程讓這些組件都與原始意圖保持一致，越來越困難。SDD 通過規格驅動的生成，提供了系統化的一致性。未來的框架可能會優先支援 AI，而非以人為本，或是圍繞可重用組件進行架構設計。

第三，變革的速度加快。現今需求變動的頻率遠超以往。轉向（pivot）已不再是例外——而是常態。現代產品開發要求根據用戶回饋、市場狀況與競爭壓力快速迭代。傳統開發將這些變動視為干擾。每次轉向都需手動將變更傳遞到文件、設計與程式碼。結果要麼是緩慢、謹慎的更新，限制了開發速度；要麼是快速、魯莽的變更，導致技術債累積。

SDD 能支援「假設/模擬」實驗：「如果我們需要重新實作或變更應用程式，以促進某項業務需求（例如多賣 T-shirt），我們該如何實作並進行實驗？」

SDD 將需求變更從障礙轉化為常態化流程。當規格說明驅動實作時，轉向變成系統化的再生，而非手動重寫。只要在 PRD 中變更核心需求，受影響的實作計畫就會自動更新。修改使用者故事，對應的 API endpoint 也會重新生成。這不僅僅關乎初始開發——而是讓工程速度能在不可避免的變化中持續維持。

## 核心原則

**規格說明作為共通語言**：規格說明成為主要產物。程式碼則成為其在特定語言與框架下的表達。維護軟體即是演進規格說明。

**可執行的規格說明**：規格說明必須精確、完整且無歧義，足以生成可運作的系統。這消除了意圖與實作之間的鴻溝。

**持續優化**：一致性驗證是持續進行的，而非一次性的檢查。AI 持續分析規格說明中的歧義、矛盾與缺漏。

**研究驅動的上下文**：研究代理會在規格說明過程中收集關鍵上下文，調查技術選項、效能影響與組織限制。

**雙向回饋**：生產現實推動規格說明的演進。指標、事件與營運經驗成為規格優化的輸入。

**分支探索**：可從同一份規格說明生成多種實作方案，以探索不同的最佳化目標——效能、可維護性、用戶體驗、成本等。

## 實作方式

目前，實踐 SDD 需要整合現有工具，並在整個流程中保持紀律。這套方法論可以透過以下方式實踐：

- 利用 AI 助手進行反覆的規格說明開發
- 研究代理收集技術上下文
- 程式碼生成工具將規格說明轉換為實作
- 適應規格優先流程的版本控制系統
- 透過 AI 分析規格文件進行一致性檢查

關鍵在於將規格說明視為唯一真實來源，程式碼則是服務於規格說明的生成產物，而非相反。

## 以指令簡化 SDD

SDD 方法論透過三個強大的指令大幅提升自動化，實現規格說明 → 規劃 → 任務分解的工作流程：

### `/speckit.specify` 指令

此指令將簡單的功能描述（用戶提示）轉換為完整、結構化的規格說明，並自動管理 repository：

1. **自動功能編號**：掃描現有規格，決定下一個功能編號（如 001、002、003）
2. **分支建立**：根據你的描述自動生成語意化分支名稱並建立分支
3. **範本生成**：複製並依你的需求自訂功能規格說明範本
4. **目錄結構**：為所有相關文件建立正確的 `specs/[branch-name]/` 結構

### `/speckit.plan` 指令

當功能規格說明已存在時，此指令會建立完整的實作計畫：

1. **規格分析**：閱讀並理解功能需求、使用者故事與驗收標準
2. **憲章遵循**：確保與專案憲章及架構原則一致
3. **技術轉譯**：將商業需求轉換為技術架構與實作細節
4. **詳細文件**：產生資料模型、API 契約與測試情境等輔助文件
5. **快速驗證**：產生快速入門指南，涵蓋關鍵驗證情境

### `/speckit.tasks` 指令

計畫建立後，此指令會分析計畫與相關設計文件，生成可執行的任務清單：

1. **輸入**：讀取 `plan.md`（必需），若有則讀取 `data-model.md`、`contracts/`、`research.md`
2. **任務拆解**：將契約、實體與情境轉換為具體任務
3. **平行化**：標記獨立任務 `[P]`，並劃分安全的平行工作組
4. **輸出**：將 `tasks.md` 寫入功能目錄，供 Task agent 執行

### 範例：建立聊天功能

以下說明這些指令如何改變傳統開發流程：

**傳統方式：**

```text
1. Write a PRD in a document (2-3 hours)
2. Create design documents (2-3 hours)
3. Set up project structure manually (30 minutes)
4. Write technical specifications (3-4 hours)
5. Create test plans (2 hours)
Total: ~12 hours of documentation work
```

**SDD 搭配 Commands 方法：**

```bash
# Step 1: Create the feature specification (5 minutes)
/speckit.specify Real-time chat system with message history and user presence

# This automatically:
# - Creates branch "003-chat-system"
# - Generates specs/003-chat-system/spec.md
# - Populates it with structured requirements

# Step 2: Generate implementation plan (5 minutes)
/speckit.plan WebSocket for real-time messaging, PostgreSQL for history, Redis for presence

# Step 3: Generate executable tasks (5 minutes)
/speckit.tasks

# This automatically creates:
# - specs/003-chat-system/plan.md
# - specs/003-chat-system/research.md (WebSocket library comparisons)
# - specs/003-chat-system/data-model.md (Message and User schemas)
# - specs/003-chat-system/contracts/ (WebSocket events, REST endpoints)
# - specs/003-chat-system/quickstart.md (Key validation scenarios)
# - specs/003-chat-system/tasks.md (Task list derived from the plan)
```

在 15 分鐘內，你將擁有：

- 一份完整的功能規格說明（Feature Specification），包含使用者故事與驗收標準
- 一份詳細的實作計畫，說明技術選擇及其理由
- 已可用於程式碼產生的 API 契約（API contracts）與資料模型
- 涵蓋自動化與手動測試的完整測試情境
- 所有文件皆已於功能分支（Feature Branch）中正確進行版本控管

### 結構化自動化的力量

這些指令不僅節省時間，更能強制執行一致性與完整性：

1. **不遺漏任何細節**：範本確保每個面向都被考慮，從非功能性需求到錯誤處理
2. **決策可追溯**：每個技術選擇都能回溯到特定需求
3. **活文件**：規格說明與程式碼保持同步，因為它們會產生程式碼
4. **快速迭代**：只需幾分鐘即可變更需求並重新產生計畫，而非數天

這些指令體現了 SDD 原則，將規格說明視為可執行產物，而非靜態文件。它們將規格制定流程，從「不得不做的苦差事」轉變為驅動開發的核心力量。

### 範本驅動品質：如何用結構約束大型語言模型 (LLM) 以獲得更好成果

這些指令的真正威力，不僅在於自動化，更在於範本如何引導大型語言模型 (LLM) 產生更高品質的規格說明。範本就像高階提示詞（prompt），以有建設性的方式約束 LLM 的輸出：

#### 1. **防止過早進入實作細節**

功能規格說明範本（feature specification template）會明確指示：

```text
- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
```

這項限制強制大型語言模型 (LLM) 維持適當的抽象層級。當 LLM 可能會自然地跳到「用 React 搭配 Redux 實作」時，範本則讓它專注於「使用者需要即時更新他們的資料」。這種分離確保了規格說明即使在實作技術變動時也能保持穩定。

#### 2. **強制標註明確的不確定性**

兩種範本都要求使用 `[NEEDS CLARIFICATION]` 標記：

```text
When creating this spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question]
2. **Don't guess**: If the prompt doesn't specify something, mark it
```

這可以防止大型語言模型 (LLM) 常見的行為——做出看似合理但可能不正確的假設。LLM 不會猜測「登入系統」是使用 email/password 驗證，而是必須將其標記為 `[NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]`。

#### 3. **透過檢查清單進行結構化思考**

這些範本包含了完整的檢查清單，作為規格說明的「單元測試」：

```markdown
### Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
```

這些檢查清單強制大型語言模型 (LLM) 系統性地自我審查其輸出，能夠捕捉到原本可能被忽略的缺漏。這就像是為大型語言模型 (LLM) 提供一套品質保證框架。

#### 4. **透過階段性檢查點 (Gates) 確保專案憲章遵循**

實作計畫範本會透過階段性檢查點來強制執行架構原則：

```markdown
### Phase -1: Pre-Implementation Gates
#### Simplicity Gate (Article VII)
- [ ] Using ≤3 projects?
- [ ] No future-proofing?
#### Anti-Abstraction Gate (Article VIII)
- [ ] Using framework directly?
- [ ] Single model representation?
```

這些 gate（閘門）透過要求大型語言模型 (LLM) 明確說明任何複雜性的理由，防止過度設計。如果某個 gate 未通過，LLM 必須在「複雜度追蹤（Complexity Tracking）」區段中記錄原因，為架構決策創造問責機制。

#### 5. **階層式細節管理（Hierarchical Detail Management）**

這些範本強制執行正確的資訊架構：

```text
**IMPORTANT**: This implementation plan should remain high-level and readable.
Any code samples, detailed algorithms, or extensive technical specifications
must be placed in the appropriate `implementation-details/` file
```

這可以避免規格說明變成難以閱讀的程式碼傾倒（code dump）這一常見問題。大型語言模型 (LLM) 會學習維持適當的細節層級，將複雜度抽離到其他檔案，同時讓主文件保持易於瀏覽。

#### 6. **測試優先（Test-First）思維**

實作計畫範本強制執行測試優先（Test-First）開發：

```text
### File Creation Order
1. Create `contracts/` with API specifications
2. Create test files in order: contract → integration → e2e → unit
3. Create source files to make tests pass
```

這項排序約束確保大型語言模型 (LLM) 在實作之前，會先考慮可測試性與契約（contracts），從而產生更健全且可驗證的規格說明。

#### 7. **防止推測性功能**

範本會明確地避免推測性設計：

```text
- [ ] No speculative or "might need" features
- [ ] All phases have clear prerequisites and deliverables
```

這能防止大型語言模型 (LLM) 添加那些「可有可無」但會讓實作變複雜的功能。每一項功能都必須能追溯到具體的使用者故事，並有明確的驗收標準。

### 複合效應

這些限制條件共同作用，產生以下特性的規格說明：

- **完整**：檢查清單確保沒有遺漏任何事項
- **無歧義**：強制釐清標記突顯不確定之處
- **可測試**：測試優先思維融入整個流程
- **可維護**：正確的抽象層級與資訊階層
- **可實作**：明確分階段，具體交付項

這些模板將大型語言模型 (LLM) 從一位創意寫作者轉變為嚴謹的規格工程師，將其能力導向產出持續高品質、可執行、真正推動開發的規格說明。

## 憲章基礎：強化架構紀律

SDD 的核心是一份憲章——一組不可變更的原則，規範規格如何轉化為程式碼。這份憲章（`memory/constitution.md`）就像系統的架構 DNA，確保每一次產生的實作都能維持一致性、簡潔性與品質。

### 開發的九大條款

憲章定義了九大條款，形塑開發流程的每一個面向：

#### 條款一：以函式庫為先 (Library-First) 原則

每一項功能都必須從獨立函式庫開始——沒有例外。這強制從一開始就採用模組化設計：

```text
Every feature in Specify MUST begin its existence as a standalone library.
No feature shall be implemented directly within application code without
first being abstracted into a reusable library component.
```

此原則確保規格說明所產生的是模組化、可重複使用的程式碼，而非單一龐大的應用程式。當大型語言模型 (LLM) 產生實作計畫時，必須將各項功能結構化為具有明確界線且相依性 (dependency) 最小的函式庫。

#### 第二條：命令列介面 (CLI Interface) 強制規定

每個函式庫都必須透過命令列介面 (Command Line Interface) 對外提供其功能：

```text
All CLI interfaces MUST:
- Accept text as input (via stdin, arguments, or files)
- Produce text as output (via stdout)
- Support JSON format for structured data exchange
```

這強制實現了可觀測性與可測試性。大型語言模型 (LLM) 不得將功能隱藏在不透明的類別中——一切都必須能夠透過文字介面存取與驗證。

#### 第三條：測試優先 (Test-First) 原則

這是最具變革性的條文——在測試完成前不得撰寫任何程式碼：

```text
This is NON-NEGOTIABLE: All implementation MUST follow strict Test-Driven Development.
No implementation code shall be written before:
1. Unit tests are written
2. Tests are validated and approved by the user
3. Tests are confirmed to FAIL (Red phase)
```

這完全顛覆了傳統的 AI 程式碼生成方式。大型語言模型 (LLM) 不再是先產生程式碼再期待它能運作，而是必須先產生定義行為的完整測試，經過審核通過後，才進行實作。

#### 第七條與第八條：簡單性與反抽象

這兩條原則旨在對抗過度工程化：

```text
Section 7.3: Minimal Project Structure
- Maximum 3 projects for initial implementation
- Additional projects require documented justification

Section 8.1: Framework Trust
- Use framework features directly rather than wrapping them
```

當大型語言模型 (LLM) 可能會自然產生過度抽象時，這些文章會強制要求其為每一層複雜度提供合理依據。實作計畫範本中的「Phase -1 Gates」直接落實這些原則。

#### 條款九：以整合為優先的測試 (Integration-First Testing)

優先考慮真實世界的測試，而非孤立的單元測試：

```text
Tests MUST use realistic environments:
- Prefer real databases over mocks
- Use actual service instances over stubs
- Contract tests mandatory before implementation
```

這可確保產生的程式碼在實務上可運作，而不僅僅只是理論上可行。

### 透過範本進行專案憲章的強制執行

實作計畫範本會透過具體的檢查點，將這些條款落實於實際操作中：

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

這些 gates（檢查點）在編譯階段對架構原則進行檢查。大型語言模型 (LLM) 必須通過這些 gates，或在「複雜度追蹤」區段中記錄有正當理由的例外，否則無法繼續執行。

### 不可變原則的力量

專案憲章的力量在於其不可變性。雖然實作細節可以隨著時間演進，但核心原則始終保持不變。這帶來以下好處：

1. **跨時一致性**：今天產生的程式碼與明年產生的程式碼遵循相同原則
2. **跨 LLM 一致性**：不同 AI 模型產生的程式碼在架構上相容
3. **架構完整性**：每個功能都強化而非削弱系統設計
4. **品質保證**：測試優先（Test-First）、以函式庫為先（Library-First）、以及簡單原則確保程式碼易於維護

### 憲章的演進

雖然原則不可變，但其應用方式可以隨著時間演進：

```text
Section 4.2: Amendment Process
Modifications to this constitution require:
- Explicit documentation of the rationale for change
- Review and approval by project maintainers
- Backwards compatibility assessment
```

這讓該方法論能在維持穩定性的同時持續學習與改進。專案憲章會透過帶有日期的修正案展現其自身的演進，說明原則如何根據實際經驗被持續精煉。

### 超越規則：一種開發哲學

專案憲章不僅僅是一本規則手冊——它是一種塑造大型語言模型 (LLM) 如何思考程式碼生成的哲學：

- **可觀察性優於不透明性**：所有內容都必須能透過命令列介面 (Command Line Interface, CLI) 進行檢查
- **簡單優於聰明**：從簡單開始，只有在確實需要時才增加複雜度
- **整合優於孤立**：在真實環境中測試，而非人為構建的環境
- **模組化優於巨石式架構**：每個功能都是具有明確邊界的函式庫

藉由將這些原則嵌入規格說明與規劃流程，SDD 確保所產生的程式碼不僅僅是可運作的——更是可維護、可測試且具備良好架構的。專案憲章讓 AI 從單純的程式碼生成器，轉變為能夠尊重並強化系統設計原則的架構夥伴。

## 轉變

這並不是要取代開發者或自動化創造力。而是透過自動化機械式轉譯來放大人類的能力。這是要建立一個緊密的回饋循環，讓規格說明、研究與程式碼能夠共同演進，每一次迭代都帶來更深的理解，以及讓意圖與實作之間的契合度更高。

軟體開發需要更好的工具來維持意圖與實作的一致性。SDD 提供了一套方法論，透過可執行的規格說明來產生程式碼，而不僅僅是指導程式碼撰寫，從而實現這種一致性。
