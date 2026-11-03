# 規格驅動開發（SDD）

## 權力結構的翻轉

數十年來，程式碼一直是王。規格是為程式碼服務的——它們是我們搭起又丟棄的鷹架，只為了讓「真正的工作」——寫程式——得以開始。我們寫 PRD 來引導開發、建立設計文件來為實作提供資訊、畫圖表來視覺化架構。但這些永遠都從屬於程式碼本身。程式碼就是真相。其他一切，頂多只是良好的意圖。程式碼是事實來源，而當它向前演進時，規格鮮少能跟上步伐。由於資產（程式碼）與實作是同一件事，想在不從程式碼出發重建的情況下擁有一份平行的實作，並不容易。

規格驅動開發（Spec-Driven Development，SDD）翻轉了這個權力結構。規格不為程式碼服務——程式碼為規格服務。產品需求文件（PRD）不是實作的指南；而是產生實作的來源。技術計畫不是為寫程式提供資訊的文件；而是產出程式碼的精確定義。這不是對我們建構軟體方式的漸進式改良，而是對「什麼在驅動開發」的根本重新思考。

規格與實作之間的落差，自軟體開發誕生以來就一直困擾著它。我們試過用更好的文件、更詳細的需求、更嚴格的流程來彌補。這些方法之所以失敗，是因為它們接受了落差無可避免。它們試著縮小落差，卻從未消除它。SDD 消除落差的方式，是讓規格以及由規格衍生的具體實作計畫變得可執行。當規格與實作計畫能產生程式碼時，就沒有落差——只有轉化。

這個轉化如今之所以可能，是因為 AI 能夠理解並實作複雜的規格，並建立詳細的實作計畫。但沒有結構的原始 AI 生成只會帶來混亂。SDD 透過規格以及隨後的實作計畫提供這個結構，它們精確、完整且毫不含糊，足以產生能運作的系統。規格成為主要的產出物。程式碼成為它在特定語言與框架中的表達（作為一份來自實作計畫的實作）。

在這個新世界裡，維護軟體意味著演進規格。開發團隊的意圖以自然語言（「**意圖驅動開發**」）、設計資產、核心原則與其他指引來表達。開發的**共通語言**提升到更高的層次，而程式碼成為最後一哩路的方法。

除錯意味著修正那些產生錯誤程式碼的規格與其實作計畫。重構意味著為清晰而重組結構。整個開發工作流程圍繞著規格重新組織——規格是中央的事實來源，實作計畫與程式碼則是持續再生的輸出。為應用程式更新新功能，或因為我們是富創造力的存在而建立一份新的平行實作，意味著重新檢視規格並建立新的實作計畫。因此，這個過程是一個 0 -> 1、(1', ..)、2、3、N 的過程。

開發團隊把心力集中在他們的創造力、實驗與批判性思考上。

## SDD 工作流程的實際樣貌

工作流程從一個想法開始——往往模糊且不完整。透過與 AI 的反覆對話，這個想法成為一份完整的 PRD。AI 提出釐清問題、找出邊界案例，並協助定義精確的驗收標準。在傳統開發中可能需要數天會議與文件工作的事，在這裡只需要數小時專注的規格工作。這改變了傳統的 SDLC——需求與設計成為持續的活動，而不是離散的階段。這支持一種**團隊流程**：由團隊審查的規格被表達並納入版本管理、在分支中建立、再合併。

當產品經理更新驗收標準時，實作計畫會自動標記受影響的技術決策。當架構師發現更好的模式時，PRD 會更新以反映新的可能性。

在整個規格過程中，研究代理會蒐集關鍵的上下文。它們調查程式庫的相容性、效能基準與安全影響。組織的限制會被發現並自動套用——你公司的資料庫標準、驗證要求與部署政策，都會無縫整合到每一份規格中。

AI 從 PRD 產生實作計畫，把需求對應到技術決策。每一個技術選擇都有記錄在案的理由。每一個架構決策都能追溯到具體的需求。在整個過程中，一致性驗證持續提升品質。AI 分析規格中的含糊、矛盾與缺口——不是一次性的關卡，而是持續的改進。

只要規格與其實作計畫夠穩定，程式碼生成就可以開始，它們不必「完整」。早期的生成可能帶有探索性質——測試規格在實務上是否說得通。領域概念成為資料模型。使用者故事成為 API 端點。驗收情境成為測試。這透過規格把開發與測試合而為一——測試情境不是在程式碼之後才寫的，它們是規格的一部分，同時產生實作與測試。

回饋迴圈延伸到初始開發之外。生產環境的指標與事故不只是觸發熱修正——它們會更新規格，供下一次再生使用。效能瓶頸成為新的非功能需求。安全漏洞成為影響所有未來生成的限制。規格、實作與營運現實之間這種反覆的共舞，正是真正理解浮現之處，也是傳統 SDLC 轉化為持續演進之處。

## 為什麼 SDD 在此刻重要

三個趨勢讓 SDD 不只是可能，更是必要：

第一，AI 的能力已經達到一個門檻：自然語言規格能可靠地產生可運作的程式碼。這不是要取代開發人員——而是透過自動化規格到實作之間的機械式轉譯，放大他們的效能。它能放大探索與創造力、輕易支持「從頭再來」，並支持加法、減法與批判性思考。

第二，軟體的複雜度持續指數成長。現代系統整合了數十種服務、框架與相依性。透過人工流程讓所有這些部件與原始意圖保持一致，變得愈來愈困難。SDD 透過規格驅動的生成，提供系統化的一致性。框架可能演進為提供 AI 優先而非人類優先的支援，或圍繞可重用的元件來架構。

第三，變化的步調正在加速。如今需求變化的速度遠比以往任何時候都快。轉向不再是例外——而是預期之中。現代產品開發要求依據使用者回饋、市場狀況與競爭壓力快速迭代。傳統開發把這些變化視為干擾。每一次轉向都需要手動把變更傳播到文件、設計與程式碼中。結果不是緩慢、謹慎、限制速度的更新，就是快速、魯莽、累積技術債的變更。

SDD 能支持假設／模擬實驗：「如果我們需要重新實作或改變這個應用程式，以推動一項賣出更多 T 恤的商業需求，我們會如何實作並為此做實驗？」

SDD 把需求變更從障礙轉變為正常的工作流程。當規格驅動實作時，轉向成為系統化的再生，而不是手動重寫。在 PRD 中改變一項核心需求，受影響的實作計畫會自動更新。修改一個使用者故事，對應的 API 端點會重新生成。這不只是關於初始開發——而是關於在無可避免的變化中維持工程速度。

## 核心原則

**規格即共通語言**：規格成為主要的產出物。程式碼成為它在特定語言與框架中的表達。維護軟體意味著演進規格。

**可執行的規格**：規格必須精確、完整且毫不含糊，足以產生能運作的系統。這消除了意圖與實作之間的落差。

**持續改進**：一致性驗證持續進行，而不是一次性的關卡。AI 持續分析規格中的含糊、矛盾與缺口。

**研究驅動的上下文**：研究代理在整個規格過程中蒐集關鍵上下文，調查技術選項、效能影響與組織限制。

**雙向回饋**：生產現實為規格的演進提供資訊。指標、事故與營運心得成為改進規格的輸入。

**以分支進行探索**：從同一份規格產生多種實作方式，探索不同的最佳化目標——效能、可維護性、使用者體驗、成本。

## 實作方式

今天，實踐 SDD 需要組裝既有工具，並在整個過程中維持紀律。這套方法論可以用以下方式實踐：

- 用於反覆發展規格的 AI 助理
- 用於蒐集技術上下文的研究代理
- 用於把規格轉譯為實作的程式碼生成工具
- 為規格優先工作流程調整過的版本控制系統
- 透過 AI 分析規格文件進行一致性檢查

關鍵在於把規格視為事實來源，程式碼則是為規格服務的生成輸出，而不是反過來。

## 以命令簡化 SDD

SDD 方法論透過三個強大的命令大幅強化，它們自動化了規格 → 規劃 → 任務的工作流程：

### `/speckit.specify` 命令

這個命令把一個簡單的功能描述（使用者提示詞）轉變為一份完整、結構化的規格，並自動管理儲存庫：

1. **自動功能編號**：掃描既有規格，決定下一個功能編號（例如 001、002、003、…、1000——自動擴展到 3 位數以上）
2. **建立分支**：從你的描述產生一個語意化的分支名稱並自動建立它
3. **範本式生成**：複製功能規格範本並依你的需求客製化
4. **目錄結構**：為所有相關文件建立正確的 `specs/[branch-name]/` 結構

### `/speckit.plan` 命令

功能規格存在之後，這個命令建立一份完整的實作計畫：

1. **規格分析**：閱讀並理解功能需求、使用者故事與驗收標準
2. **憲章合規**：確保與專案憲章及架構原則對齊
3. **技術轉譯**：把商業需求轉化為技術架構與實作細節
4. **詳細文件**：為資料模型、API 契約與測試情境產生支援文件
5. **快速入門驗證**：產出一份快速入門指南，收錄關鍵的驗證情境

### `/speckit.tasks` 命令

計畫建立之後，這個命令分析計畫與相關設計文件，產生一份可執行的任務清單：

1. **輸入**：讀取 `plan.md`（必需），以及若存在的 `data-model.md`、`contracts/` 與 `research.md`
2. **任務推導**：把契約、實體與情境轉化為具體任務
3. **平行化**：把獨立任務標記為 `[P]`，並列出安全的平行群組
4. **輸出**：把 `tasks.md` 寫入功能目錄，準備好由任務代理執行

### 範例：打造一個聊天功能

以下說明這些命令如何改變傳統的開發工作流程：

**傳統方式：**

```text
1. Write a PRD in a document (2-3 hours)
2. Create design documents (2-3 hours)
3. Set up project structure manually (30 minutes)
4. Write technical specifications (3-4 hours)
5. Create test plans (2 hours)
Total: ~12 hours of documentation work
```

**使用命令的 SDD 方式：**

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

在 15 分鐘內，你就擁有：

- 一份帶有使用者故事與驗收標準的完整功能規格
- 一份帶有技術選擇與理由的詳細實作計畫
- 準備好供程式碼生成使用的 API 契約與資料模型
- 供自動化與手動測試使用的完整測試情境
- 所有文件都妥善地在功能分支中納入版本管理

### 結構化自動化的力量

這些命令不只是節省時間——它們還強制執行一致性與完整性：

1. **不遺漏任何細節**：範本確保每個面向都被考量，從非功能需求到錯誤處理
2. **決策可追溯**：每個技術選擇都連結回具體的需求
3. **活的文件**：規格與程式碼保持同步，因為程式碼就是由規格產生的
4. **快速迭代**：在幾分鐘內——而不是幾天——變更需求並重新產生計畫

這些命令透過把規格視為可執行的產出物、而非靜態文件，體現了 SDD 的原則。它們把規格過程從不得不做的苦差事，轉變為開發的驅動力。

### 範本驅動的品質：結構如何約束 LLM 以獲得更好的成果

這些命令真正的力量不只在於自動化，還在於範本如何引導 LLM 的行為，產出更高品質的規格。範本扮演著精密提示詞的角色，以富有成效的方式約束 LLM 的輸出：

#### 1. **防止過早的實作細節**

功能規格範本明確指示：

```text
- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
```

這個約束迫使 LLM 維持正確的抽象層級。當 LLM 可能很自然地跳到「使用 React 加 Redux 來實作」時，範本讓它專注在「使用者需要即時更新他們的資料」。這種分離確保了即使實作技術改變，規格依然穩定。

#### 2. **強制明確的不確定性標記**

兩個範本都要求使用 `[NEEDS CLARIFICATION]` 標記：

```text
When creating this spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question]
2. **Don't guess**: If the prompt doesn't specify something, mark it
```

這防止了 LLM 常見的行為：做出看似合理、卻可能不正確的假設。LLM 不會去猜一個「登入系統」使用電子郵件／密碼驗證，而是必須把它標記為 `[NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]`。

#### 3. **透過檢核清單進行結構化思考**

範本包含完整的檢核清單，扮演著規格的「單元測試」：

```markdown
### Requirement Completeness

- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
```

這些檢核清單迫使 LLM 系統化地自我審查其輸出，捕捉那些原本可能溜走的缺口。這就像給了 LLM 一套品質保證框架。

#### 4. **透過關卡實現憲章合規**

實作計畫範本透過階段關卡強制執行架構原則：

```markdown
### Phase -1: Pre-Implementation Gates

#### Simplicity Gate (Article VII)

- [ ] Using ≤3 projects?
- [ ] No future-proofing?

#### Anti-Abstraction Gate (Article VIII)

- [ ] Using framework directly?
- [ ] Single model representation?
```

這些關卡透過要求 LLM 明確為任何複雜度提出理由，來防止過度工程。如果某個關卡沒有通過，LLM 必須在「Complexity Tracking」區段記錄原因，為架構決策建立問責。

#### 5. **階層化的細節管理**

範本強制執行正確的資訊架構：

```text
**IMPORTANT**: This implementation plan should remain high-level and readable.
Any code samples, detailed algorithms, or extensive technical specifications
must be placed in the appropriate `implementation-details/` file
```

這防止了規格變成難以閱讀的程式碼傾瀉這種常見問題。LLM 學會維持適當的細節層級，把複雜度抽取到獨立檔案中，同時讓主文件保持可導覽。

#### 6. **測試優先的思考**

實作範本強制執行測試優先開發：

```text
### File Creation Order
1. Create `contracts/` with API specifications
2. Create test files in order: contract → integration → e2e → unit
3. Create source files to make tests pass
```

這個順序約束確保 LLM 在實作之前先思考可測試性與契約，從而產出更穩健、可驗證的規格。

#### 7. **防止臆測性的功能**

範本明確勸阻臆測：

```text
- [ ] No speculative or "might need" features
- [ ] All phases have clear prerequisites and deliverables
```

這阻止 LLM 加入那些讓實作變複雜的「有也不錯」功能。每個功能都必須能追溯到一個帶有明確驗收標準的具體使用者故事。

### 複合效應

這些約束共同作用，產出的規格具備以下特質：

- **完整**：檢核清單確保沒有任何遺漏
- **毫不含糊**：強制釐清標記突顯出不確定之處
- **可測試**：測試優先的思考已內建在流程中
- **可維護**：正確的抽象層級與資訊階層
- **可實作**：階段明確，交付物具體

範本把 LLM 從一個創意寫手轉變為一位有紀律的規格工程師，引導它的能力，產出始終如一的高品質、可執行的規格，真正驅動開發。

## 憲章基礎：強制執行架構紀律

SDD 的核心是一部憲章——一組不可改變的原則，治理規格如何成為程式碼。這部憲章（`memory/constitution.md`）扮演著系統的架構 DNA，確保每一個產生的實作都維持一致性、簡潔與品質。

### 開發九條

憲章定義了九個條款，塑造開發過程的每個面向：

#### 第一條：程式庫優先原則

每個功能都必須從一個獨立的程式庫開始——沒有例外。這從一開始就強制了模組化設計：

```text
Every feature in Specify MUST begin its existence as a standalone library.
No feature shall be implemented directly within application code without
first being abstracted into a reusable library component.
```

這個原則確保規格產生的是模組化、可重用的程式碼，而不是單體式應用程式。當 LLM 產生實作計畫時，它必須把功能組織為邊界清晰、相依性最小的程式庫。

#### 第二條：CLI 介面強制要求

每個程式庫都必須透過命令列介面公開其功能：

```text
All CLI interfaces MUST:
- Accept text as input (via stdin, arguments, or files)
- Produce text as output (via stdout)
- Support JSON format for structured data exchange
```

這強制了可觀察性與可測試性。LLM 無法把功能藏在不透明的類別裡——一切都必須能透過以文字為基礎的介面存取與驗證。

#### 第三條：測試優先的絕對要求

最具變革性的一條——測試之前不寫程式碼：

```text
This is NON-NEGOTIABLE: All implementation MUST follow strict Test-Driven Development.
No implementation code shall be written before:
1. Unit tests are written
2. Tests are validated and approved by the user
3. Tests are confirmed to FAIL (Red phase)
```

這徹底翻轉了傳統的 AI 程式碼生成。LLM 不是先生成程式碼再祈禱它能運作，而是必須先生成定義行為的完整測試、取得核准，然後才生成實作。

#### 第四、五、六條：由專案定義的治理

第四、五、六條刻意由每個專案的憲章自行定義，而不是由 Spec Kit 規定。憲章範本提供了佔位欄位與範例關注事項，例如整合測試、可觀察性、版本管理與破壞性變更，但各團隊會把這些佔位符替換為符合其系統與組織的原則。

這讓九條的結構保持穩定，同時讓每個專案編入自己不可協商的標準。對某個專案來說，第四條可能治理安全與存取邊界；對另一個專案來說，它可能定義整合測試的要求。`/speckit.analyze` 命令評估專案中具體的憲章，因此這些由專案定義的條款，也和內建範例一樣參與合規檢查。

#### 第七與第八條：簡潔與反抽象

這一對條款對抗過度工程：

```text
Section 7.3: Minimal Project Structure
- Maximum 3 projects for initial implementation
- Additional projects require documented justification

Section 8.1: Framework Trust
- Use framework features directly rather than wrapping them
```

當 LLM 可能很自然地建立繁複的抽象時，這些條款迫使它為每一層複雜度提出理由。實作計畫範本的「Phase -1 Gates」直接強制執行這些原則。

#### 第九條：整合優先測試

把真實世界的測試置於孤立的單元測試之上：

```text
Tests MUST use realistic environments:
- Prefer real databases over mocks
- Use actual service instances over stubs
- Contract tests mandatory before implementation
```

這確保產生的程式碼在實務上能運作，而不只是理論上可行。

### 透過範本執行憲章

實作計畫範本透過具體的檢查點，把這些條款落實為可操作的機制：

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

這些關卡扮演著架構原則的編譯期檢查。LLM 無法繼續推進，除非它通過這些關卡，或在「Complexity Tracking」區段記錄有正當理由的例外。

### 不可變原則的力量

憲章的力量在於它的不可變性。雖然實作細節可以演進，核心原則始終不變。這帶來：

1. **跨時間的一致性**：今天產生的程式碼，遵循與明年產生的程式碼相同的原則
2. **跨 LLM 的一致性**：不同的 AI 模型產出架構上相容的程式碼
3. **架構完整性**：每個功能都強化而非削弱系統設計
4. **品質保證**：測試優先、程式庫優先與簡潔原則，確保程式碼可維護

### 憲章的演進

原則雖然不可變，其應用方式卻可以演進：

```text
Section 4.2: Amendment Process
Modifications to this constitution require:
- Explicit documentation of the rationale for change
- Review and approval by project maintainers
- Backwards compatibility assessment
```

這讓方法論能在維持穩定的同時學習與改進。憲章以附日期的修訂展示自身的演進，示範原則如何能依據真實世界的經驗被精煉。

### 超越規則：一種開發哲學

憲章不只是一本規則手冊——它是一種哲學，塑造 LLM 思考程式碼生成的方式：

- **可觀察性勝於不透明**：一切都必須能透過 CLI 介面檢視
- **簡潔勝於取巧**：從簡單開始，只在證明有必要時才增加複雜度
- **整合勝於孤立**：在真實環境中測試，而不是人為的環境
- **模組化勝於單體**：每個功能都是一個邊界清晰的程式庫

透過把這些原則嵌入規格與規劃過程，SDD 確保產生的程式碼不只是能運作——它可維護、可測試，而且架構健全。憲章把 AI 從一個程式碼產生器，轉變為一位尊重並強化系統設計原則的架構夥伴。

## 轉變

這不是要取代開發人員，也不是要把創造力自動化。而是透過自動化機械式的轉譯，放大人的能力。是在建立一個緊密的回饋迴圈，讓規格、研究與程式碼共同演進，每一次迭代都帶來更深的理解，以及意圖與實作之間更好的對齊。

軟體開發需要更好的工具，來維持意圖與實作之間的一致性。SDD 提供了達成這種一致性的方法論：透過能產生程式碼的可執行規格，而不只是引導程式碼。
