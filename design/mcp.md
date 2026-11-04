# Specify MCP 命令架構

本文件定義透過 Model Context Protocol（MCP）公開 Specify 操作的架構。它是 [Specify CLI Command Architecture](cli.md) 的 MCP 對應文件。

兩個適配器都會呼叫 [Shared Command Application Architecture](shared.md) 所定義的應用層。本文件掌管 MCP 工具的身分、公開方式、註解、通訊協定對應與本機 stdio 託管。它不重新定義語意驗證、編排、結果、警告、錯誤或副作用。

## 設計目標

MCP 結構應讓「這個工具的行為住在哪裡？」這個問題的答案，如同等價的 CLI 問題一樣可預測。

本設計著重於：

- **單一邏輯操作：** CLI 葉節點與其 MCP 工具，是同一應用行為的兩個適配器。
- **適配器一致性：** CLI 與 MCP 的輸入、結果、警告、錯誤與副作用在語意上保持等價。
- **型別化探索：** 每個可用的 MCP 操作都有命令專屬的輸入與輸出結構描述。
- **明確公開：** 每個 CLI 葉節點都有可審查的 MCP 清單處置；工具絕不透過檔案系統探索來公開。
- **小型工作脈絡：** 變更單一操作通常只需要動到其網域、CLI 適配器、MCP 適配器與對應的測試。
- **副作用可見性：** 專案寫入、執行、網路存取、信任決定與自我修改都會宣告供審查，並保守地投射為標準的 MCP 註解。
- **本機 stdio 邊界：** 通訊協定框架與診斷資訊留在命令行為之外。

## 非目標

本設計不會：

- 讓 MCP 成為人類 CLI 的包裝層。
- 要求每個 CLI 葉節點無論風險或就緒程度都必須可呼叫。
- 把既有的人類輸出轉成 MCP 或 JSON 合約。
- 讓 `--json`、`--non-interactive` 或 MCP 呼叫隱含 `--force`、信任、破壞性同意或網路許可。
- 為第三方呼叫者定義公開的 Python API。受支援的外部介面仍是 CLI、MCP 合約、整合與工作流程步驟。
- 以單一通用的命令引擎或中央服務定位器，取代命令自有的應用行為。
- 要求原本簡單的操作僅為了視覺對稱而拆成額外模組。

## 共用操作相依性

MCP 工具是[共用架構](shared.md)所定義邏輯操作的交付適配器。它把 MCP 輸入對應到共用的型別化請求，並把共用結果對應到 MCP 的結構化內容或工具錯誤。

MCP 適配器掌管：

- 工具名稱、說明、註解與通訊協定結構描述。
- MCP 內容與共用請求／結果型別之間的對應。
- 每個群組的 MCP 註冊與靜態清單。
- 通訊協定診斷與本機 stdio 伺服器託管。

它不掌管語意驗證、應用編排、副作用或命令專屬的網域合約。它不得呼叫 Typer 處理常式、把 `specify` 當作應用派送來啟動、擷取 Rich 輸出，或解析 CLI 的 stderr。

共用的 MCP 基礎設施可以定義通訊協定與註冊原語。它不得變成命令專屬請求模型、結果、驗證或編排的中央型錄。

## 操作身分與 MCP 工具設計

每個邏輯操作都有三個相關身分：

| 介面 | 範例 |
| --- | --- |
| 邏輯操作 ID | `artifact.list` |
| CLI 路徑 | `specify artifact list` |
| MCP 工具名稱 | `specify_artifact_list` |

操作 ID 使用以點分隔的 CLI 路徑片段，不含開頭的 `specify`。MCP 工具名稱使用相同的片段，但以底線連接並加上 `specify_` 前綴。CLI 片段中的連字號會變成底線：

```text
specify extension set-priority
operation: extension.set-priority
tool: specify_extension_set_priority
```

只有為了滿足通訊協定限制或解決已證明的衝突時，才允許明確的覆寫。清單必須記錄該覆寫與原因。

### 一級工具，而非通用執行門面

MCP 介面把每個*符合資格*的 CLI 葉節點公開為一級 MCP 工具。通用的 `specify_run_command` 門面不屬於本架構。

MCP SDK 會依每個已註冊工具的型別化可呼叫物件，為其建立一份 JSON 輸入結構描述。因此一級工具保留了：

- 每個命令的結構描述與說明。
- MCP 使用者端的探索與參數驗證。
- 命令專屬的輸出結構描述與註解。
- 可審查的註冊與副作用中繼資料。
- 可直接對應回 CLI 葉節點與所屬原始碼檔案。

相較之下，通用門面會把通訊協定可見的輸入縮減為一個命令字串，外加不透明或過大的參數聯集。這會削弱結構描述驗證、可探索性、副作用審查與相容性分析。

註冊依命令階層組織，讓命令專屬的合約保持可審查，不被藏在通用工具之後。

### 命令清單

本設計建立時的 CLI 葉節點清單如下：

```text
root: init, check, version, mcp
self: check, upgrade
extension: add, disable, enable, info, list, remove, search, set-priority,
  update
extension.catalog: add, list, remove
integration: install, uninstall, switch, upgrade, list, status, use, search,
  info, scaffold
integration.catalog: add, list, remove
event: run
preset: list, add, remove, update, search, resolve, info, set-priority, enable,
  disable
preset.catalog: add, list, remove
artifact: list, info, lookup
bundle: search, info, list, install, add, update, remove, validate, build, init
bundle.catalog: add, list, remove
workflow: run, resume, status, list, add, remove, update, enable, disable,
  search, info, resolve
workflow.catalog: add, list, remove
workflow.step: list, add, remove, search, info
workflow.step.catalog: add, list, remove
workflow.overlay: add, set-priority, enable, disable, remove, list
```

`mcp` 被排除，因為它會啟動本機 stdio 伺服器。其他每個可用的葉節點，都依上述命名規則對應到一個一級工具。無法使用或被排除的葉節點，仍必須有明確的、由階層擁有的清單紀錄與原因。

這份清單記錄的是命令命名空間；它不是註冊來源。由階層擁有的清單及其一致性測試才是權威依據。

僅含中繼資料的清單或描述工具可以存在，供診斷使用。它們不取代一級操作工具。通用執行工具不屬於本架構。

## 命名與檔案版面

MCP 適配器鏡像 CLI 命令路徑，並與所屬命令及網域程式碼放在一起：

```text
src/specify_cli/extensions/
├── __init__.py
├── _commands.py
├── _mcp.py
├── command_add.py
├── mcp_add.py
├── command_list.py
├── mcp_list.py
└── catalog/
    ├── __init__.py
    ├── _mcp.py
    ├── command_add.py
    ├── mcp_add.py
    ├── command_list.py
    └── mcp_list.py
```

慣例如下：

- `command_<name>.py` 是真實葉命令唯一的 CLI 適配器。
- `mcp_<name>.py` 是同一邏輯操作唯一的 MCP 適配器。
- `_mcp.py` 掌管某個命令群組明確的 MCP 註冊與清單。
- 巢狀目錄持續對應到真實的 CLI 命名空間或有界的子網域，遵循 [CLI 設計](cli.md#nested-command-groups)。
- 共用的操作與階段模組遵循[共用命名規則](shared.md#naming-and-layout)。
- 測試在 `tests/specify_cli/` 下鏡像這些名稱。

不要在 `mcp_server/commands/` 下建立整個 CLI 樹的頂層 MCP 鏡像。那會把命令合約與其所屬網域分離，讓無關的命令階層相依於一個中央套件。

不要僅為了對稱而新增 `_mcp.py`。只有一個小工具的套件，可以透過既有的聚焦註冊模組來註冊它。當階層需要明確列出多個工具、共用的適配器輔助函式或清單處置時，才建立 `_mcp.py`。

## 註冊與明確清單

註冊在每個命令群組邊界保持明確。

以 `artifact` 這樣的群組為例：

1. `artifacts/_mcp.py` 列出每個 `artifact.*` CLI 葉節點。
2. 每個葉節點恰好有一筆清單紀錄。
3. 可用的紀錄會匯入並註冊其 `mcp_<name>.py` 適配器。
4. 無法使用與被排除的紀錄會述明原因。
5. 根 MCP 組合模組呼叫 `artifacts._mcp.register(...)`。

根 MCP 伺服器可以彙總各階層的註冊函式，但不得擁有其命令專屬的結構描述或派送行為。註冊匯入是明確且順序一致的。檔案系統掃描、`command_*.py` 內省與裝飾器副作用，都不能取代清單。

一筆概念性的清單紀錄包含：

```text
operation_id
cli_path
mcp_tool_name
contract_version
disposition
disposition_reason
capabilities
network_access
```

靜態處置值如下：

- `available`：已實現並註冊為一級工具。
- `unavailable`：邏輯操作已知，但在目前的發行版或平台上無法提供；紀錄會述明具體原因。
- `excluded`：該命令刻意不作為 MCP 操作。

每個 CLI 葉節點都必須恰好出現一次。清單一致性測試會在以下情況失敗：葉節點遺失、邏輯操作重複、工具名稱重複、CLI 路徑過期，或排除沒有說明。

### 永久與條件式排除

`specify mcp` 被永久排除，因為它會啟動本機 stdio 伺服器；一個會啟動另一個 MCP 伺服器的 MCP 工具是遞迴的基礎設施，而不是應用操作。

其他命令不會僅因為會變更狀態就被排除。它們的副作用會被宣告，讓 MCP 主機與使用者端能做出知情的公開與確認決定。例如：

- `self.upgrade` 在其一級工具已實現時，靜態處置為 `available`，並宣告本機讀取、執行與自我修改。
- `event.run`、`workflow.run` 與 `workflow.resume` 是執行操作，也可能保存專案狀態。
- `init`、add/remove/update 命令與設定變更屬於專案寫入操作，當其路徑有需要時，會宣告執行與其他獨立能力。
- `check` 會啟動已安裝的主機工具來檢查其版本，因此即使它不保存變更，也需要執行能力。
- 仍相依於提示、直接透過其 Typer 處理常式寫入，或缺少型別化結果的命令，不得標記為 `available`。

無法使用與排除是可審查的架構決定，不是無聲的遺漏。

## MCP 合約投射

共用的請求、結果、警告、錯誤、驗證與合約版本規則，定義於 [Shared Command Application Architecture](shared.md#typed-request-contract)。MCP 適配器把該合約投射到 MCP 上：

- 其輸入結構描述是命令專屬的，並對應到共用的型別化請求。
- 它執行通訊協定／結構描述驗證，但不做與狀態相關的語意工作。
- 它把操作的副作用與網路中繼資料投射為標準的 MCP 註解，同時由階層擁有的清單保留確切的宣告。
- 它把共用結果與警告對應到命令專屬的結構化內容。
- 它把預期的共用錯誤對應到 MCP 工具錯誤，不新增成功形狀的後備結果。

MCP 通訊協定封套不會強加通用的應用結果封套。命令／網域階層持續擁有語意結果的形狀。由階層擁有的清單會記錄 `contract_version`，供相容性與一致性測試使用，但本機 MCP 通訊協定不會在工具或結果中新增自訂的版本欄位。未預期的例外會變成經過淨化的 `internal_error` 工具失敗，且僅透過 MCP 診斷管道記錄。

## 專案目錄與執行環境

以專案為範圍的 MCP 工具，在其使用情境需要時，接受選用的專案目錄。若省略，專案探索會從伺服器啟動時的工作目錄開始，與一般的 CLI 行為一致。適配器把該明確路徑對應到共用請求中。共用操作會透過 CLI 使用的同一個網域輔助函式解析它，並產生相同的語意錯誤。

適配器與共用操作遵循以下規則：

- 不要為 MCP 請求呼叫 `os.chdir()`。長生命週期的伺服器可能處理來自不同專案脈絡的並行或循序呼叫。
- 明確地透過操作階段傳遞解析後的專案或目標路徑。
- 對發行中繼資料、隨附資產、專案檔案與其他應用行為，使用與 CLI 相同的共用 Python／網域輔助函式。
- 呼叫開始後，不要從無關的伺服器行程狀態推斷專案。

`init` 是特殊的專案建立操作：其請求標明的是目標目錄，而不是既有的專案根目錄。

本機 stdio 以伺服器行程的作業系統權限執行，就像 CLI 以其行程使用者的權限執行一樣。命令架構不聲稱提供逐操作的檔案系統沙箱。需要隔離的主機，會把 MCP 伺服器放在作業系統沙箱、容器或受限帳號中執行。

## 非互動行為

MCP 操作一律為非互動式：

- 絕不讀取 stdin。
- 絕不開啟方向鍵選取器或終端確認。
- 絕不等待未在請求中表示的答案。
- 只有當 CLI 操作使用相同的非互動預設值時，才可套用安全的已記錄預設值。
- 若不存在安全的預設值，回傳結構化的 `input_required` 或 `confirmation_required` 錯誤，說明必須提供哪個欄位。

機器模式不是同意。啟動 MCP、使用 `--json` 或 `--non-interactive`，或收到主機確認，都不隱含：

- `force=true`。
- 信任外部 URL 或下載的可執行內容。
- 覆寫使用者修改檔案的許可。
- 執行呼叫者未明確要求之行為的許可。

呼叫者必須明確呼叫執行操作，提供任何命令專屬的同意欄位，並滿足共用操作的語意驗證。MCP 註解與主機 UI 僅供參考；它們不能取代必要的請求值。

## 能力與網路中繼資料

操作依[共用能力合約](shared.md#capability-declarations)宣告能力。這些是累積的描述，不是最高風險階層。例如：

```text
version       -> {local-read}
check         -> {local-read, execution}
workflow.run  -> {local-read, project-write, execution}
self.upgrade  -> {local-read, execution, self-modifying}
```

`read-only` 是衍生的描述，不是宣告的能力。請求只有在不需要 `project-write`、`execution` 或 `self-modifying` 能力時，才是唯讀的。因此，會啟動二進位檔的操作即使不保存變更，也不是唯讀的。

網路存取是獨立的宣告：`none`、`optional` 或 `required`。唯讀的搜尋可能使用網路，而專案寫入操作可能完全離線。

由階層擁有的清單保留確切的能力集合與網路狀態，供審查與一致性測試使用。標準的 MCP `ToolAnnotations` 是提示，不是無損的能力合約：

- 只有當操作沒有 `project-write`、`execution` 或 `self-modifying` 能力時，`readOnlyHint` 才為 true。
- 當 `readOnlyHint` 為 true 時，省略 `destructiveHint`。否則，當操作可能覆寫、刪除、取代或重新設定既有狀態時為 true，僅在附加式更新時為 false。
- 只有當操作合約保證以相同參數重複呼叫不會產生額外效果時，`idempotentHint` 才為 true。
- 當網路存取為 `optional` 或 `required`，或執行可能與行程、安裝或選定專案之外的外部實體互動時，`openWorldHint` 為 true。

後三個提示取決於完整的操作合約，不能僅從能力集合推導。確切的能力名稱與三態網路宣告，仍是架構與清單的中繼資料，不是通訊協定欄位。本架構不要求自訂的 `_meta` 合約或清單工具。

stdio 伺服器不實現允許／拒絕政策引擎，也不實現逐請求的可用性狀態。MCP 主機或使用者端可以使用標準註解來決定可見性或確認方式，但這些提示不是存取控制邊界。

伺服器仍會強制執行語意上的請求要求，例如 `force`、外部來源信任與命令專屬的確認欄位，因為這些屬於共用操作合約。

`execution` 宣告操作可能啟動子行程。該子行程以 MCP 伺服器行程使用者的權限執行，除非主機在外部對伺服器進行沙箱隔離。把 cwd 設在專案內不是安全邊界，本命令架構也不作此聲稱。

## 信任、確認與網路責任

共用操作擁有「某個動作需要信任或確認」的語意規則。適配器則掌管明確同意如何進入請求。

- 安裝外部 URL 時，若沒有明確的信任欄位，預設拒絕。
- 非空的目標目錄在沒有明確覆寫同意時，仍受保護。
- 目錄探索許可不隱含安裝許可。
- 網路可用不隱含信任任意回傳的內容。
- 重新導向、摘要、來源與相容性驗證仍是網域行為，由兩個適配器共用。
- 傳輸驗證不能取代語意同意。

網路呼叫使用有界的連線／讀取逾時。操作不會無聲地從離線行為切換為線上行為。當請求支援離線行為時，輸入會明確述明，或使用與 CLI 相同且已記錄的預設值。

## 逾時、stdin 與有界輸出

stdio 適配器掌管回應大小的強制執行。

- 子行程與網路呼叫會收到明確的伺服器端逾時。
- 複雜的操作可以定義操作自有的逾時；不存在通用的呼叫脈絡。
- 交易式變更會依其網域合約回滾或回報部分狀態。
- 伺服器強制的逾時在請求仍處於作用中時，會回傳結構化的逾時錯誤，絕不是成功的空結果。
- 沒有操作會讀取 stdin 或繼承互動式子行程的 stdin。
- 擷取的 stdout/stderr 與診斷細節都有大小上限。
- 可能很大的清單會使用命令自有的限制或分頁。
- 截斷是明確的，並包含續接游標或清楚的 `truncated` 標記；絕不無聲截斷。
- MCP 回應大小的強制執行屬於適配器；分頁語意屬於命令階層。

## 本機 stdio 伺服器邊界

`specify_cli/mcp_server/` 掌管伺服器組合與 stdio 通訊協定託管，而不是命令行為。

MCP 伺服器透過 stdio 在本機執行，因為其操作作用於本機專案、Specify 安裝、檔案系統與主機工具：

- Stdout 保留給 MCP 通訊協定框架。
- 記錄與診斷使用 stderr 或 SDK 的記錄管道。
- 啟動橫幅、Rich 算繪與 CLI 警告絕不進入 stdout。
- 伺服器使用啟動行程使用者的本機權限。

示意的基礎設施版面如下：

```text
src/specify_cli/mcp_server/
├── __init__.py
├── server.py
├── registry.py
└── stdio.py
```

只建立由已實現行為所正當化的模組。此版面定義的是架構邊界，不是新增空檔案的要求。

## 測試結構

共用操作、CLI 適配器與一致性涵蓋，遵循[共用測試結構](shared.md#testing-structure)與 [CLI 測試結構](cli.md#test-structure)。MCP 新增以下層次。

### MCP 適配器測試

- 驗證工具名稱、說明、註解與確切的輸入／輸出結構描述。
- 驗證到共用操作請求與結果的對應。
- 驗證結構化警告與工具錯誤。
- 驗證信任失敗、伺服器強制的逾時錯誤與輸出預算失敗。
- 驗證專案目錄對應與不使用 `os.chdir()` 的操作派送。
- 驗證標準工具註解遵循保守的對應方式，且清單保留確切的能力與網路宣告。

### 清單測試

- 走訪實際的 CLI 命令樹，要求每個葉節點都有一筆 MCP 清單處置。
- 拒絕重複的操作 ID 與 MCP 工具名稱。
- 要求每個無法使用或被排除的命令都有原因。
- 驗證可用的工具由所屬階層註冊。
- 驗證清單的能力與網路中繼資料與共用操作描述元相符。
- 在測試移動時保留 pytest 的總收集數，如 CLI 架構所要求。

### 通訊協定測試

- 保留一項記憶體內的 MCP 註冊與派送測試。
- 保留一項真實的 stdio initialize/list/call 測試，且 stdout 保持通訊協定純淨。
- 把格式錯誤的輸入、無法使用的工具、內部失敗淨化與輸出上限，作為負面案例測試。

行為變更遵循[測試確定性行為](../CONTRIBUTING.md#testing-deterministic-behavior)：需要正面與負面證據，錯誤修正需要前後對照的迴歸證據。

## 代表性操作版面

### `version`：簡單、以行程為範圍的讀取

```text
src/specify_cli/
├── _operation_version.py
├── command_version.py
└── mcp_version.py

tests/specify_cli/
├── test_operation_version.py
├── test_command_version.py
└── test_mcp_version.py
```

合約：

```text
operation_id: version
cli_path: specify version
mcp_tool_name: specify_version
capabilities: [local-read]
network_access: none
```

`_operation_version.py` 掌管型別化的版本收集與 `VersionResult`，使用一般的共用版本／網域輔助函式。`command_version.py` 算繪面板、功能文字或既定的 JSON 物件。`mcp_version.py` 把相同的結果欄位以結構化內容回傳。沒有適配器會啟動子行程。

### `artifact list`：以專案為範圍的讀取

```text
src/specify_cli/artifacts/
├── __init__.py
├── _commands.py
├── _mcp.py
├── _operation_list.py
├── command_list.py
└── mcp_list.py

tests/specify_cli/artifacts/
├── test_operation_list.py
├── test_command_list.py
└── test_mcp_list.py
```

合約：

```text
operation_id: artifact.list
cli_path: specify artifact list
mcp_tool_name: specify_artifact_list
capabilities: [local-read]
network_access: none
```

請求包含選用的專案目錄。共用操作會解析並驗證該路徑，使用 `ArtifactCatalog`，並回傳型別化的成品列。CLI 適配器保留其 JSON 串流合約；MCP 適配器透過其輸出結構描述公開這些列，絕不擷取 CLI 的 stdout。大型結果使用明確的操作限制或分頁，而不是無聲截斷。

### `init`：複雜的專案變更

```text
src/specify_cli/
├── command_init.py
├── mcp_init.py
├── _operation_init.py
├── _operation_init_validation.py
├── _operation_init_plan.py
├── _operation_init_apply.py
└── _operation_init_finalize.py

tests/specify_cli/
├── test_command_init.py
├── test_mcp_init.py
├── test_operation_init.py
├── test_operation_init_validation.py
├── test_operation_init_plan.py
├── test_operation_init_apply.py
└── test_operation_init_finalize.py
```

這維持在根層級；`init/` 目錄會錯誤地暗示存在 `specify init ...` 巢狀命令群組。

合約：

```text
operation_id: init
cli_path: specify init
mcp_tool_name: specify_init
capabilities: [local-read, project-write, execution]
network_access: optional
```

請求明確攜帶目標、整合、指令碼類型、選用的預設集／擴充功能、`force`，以及外部 URL 信任決定。MCP 適配器絕不提示，也絕不把其機器脈絡轉成 force 或信任。共用操作會驗證輸入、建立計畫、套用交易式變更，並回傳建立／更新的路徑外加結構化警告。CLI 適配器可以在建構同一個請求之前，先收集互動式選擇。隨附的範本與指令碼使用與 CLI 相同的共用資產輔助函式。

若目標非空且 `force` 為 false，兩個適配器都會收到相同的語意「需要確認」失敗。CLI 可以透過提示並以明確同意重試來回應；MCP 工具則回傳結構化錯誤，並要求以 `force=true` 重新呼叫。

## 反模式

避免：

- MCP 直接呼叫 Typer 處理常式。
- MCP 為一般派送啟動人類 CLI。
- 解析 Rich 輸出、終端文字或 CLI stderr 來還原結果。
- 在 MCP 適配器中重複命令編排。
- 在中央 MCP 型錄中定義命令專屬的請求與結果模型。
- 把行為藏在中央服務定位器或字串式派送器之後。
- 透過單一通用執行工具公開每個操作。
- 強迫每個命令都進入過大的通用執行引擎。
- 把 MCP 工具註解或主機確認當作語意上的 `force`、信任或破壞性同意。
- 把機器模式當作 force、信任、覆寫同意或執行許可。
- 在工具呼叫期間讀取 stdin 或變更整個行程的 cwd。
- 透過掃描檔案或匯入每個 `command_*.py` 來自動註冊工具。
- 建立重複並脫離 CLI／網域階層的 MCP 目錄樹。
- 僅為了對稱而新增操作階段或 `_mcp.py` 檔案。
- 無聲地從 MCP 清單中省略 CLI 葉節點。
- 把部分、截斷或後備資料當作成功的完整結果回傳。
- 讓 stdio 通訊協定考量滲入命令合約。

## 審查檢核清單

對於新增或遷移的 MCP 操作：

- [ ] CLI 葉節點與 MCP 工具對應到同一個邏輯操作 ID。
- [ ] 兩個適配器都派送到同一個型別化的共用實現。
- [ ] MCP 工具是一級工具，且有命令專屬的結構描述。
- [ ] 工具名稱與原始碼版面鏡像 CLI 路徑。
- [ ] 所屬命令階層宣告註冊與清單。
- [ ] 可用性、能力、網路存取與清單合約版本都是明確的。
- [ ] 非互動行為不隱含 force、信任或同意。
- [ ] 專案路徑經過正規化並明確傳遞，不使用 `os.chdir()`。
- [ ] 逾時、stdin 與輸出上限都已處理。
- [ ] 既有的 CLI 人類與 JSON 行為保持相容。
- [ ] 操作、CLI 適配器、MCP 適配器、一致性與通訊協定測試涵蓋正面與負面行為。
- [ ] Stdio 保持通訊協定純淨，命令行為留在伺服器託管之外。
- [ ] 沒有在中央 MCP 基礎設施中新增命令行為。
