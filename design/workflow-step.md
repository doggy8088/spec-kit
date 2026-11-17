# 工作流程步驟設計

工作流程步驟類型定義了工作流程 YAML 中 `type:` 的作用。這是工作流程引擎的擴充點，與代理整合不同：整合會將工作派送給代理；步驟則驗證並執行工作流程行為。關於整體引擎，請見[工作流程 API 與執行模型](https://github.github.io/spec-kit/workflows/api.html)；關於 YAML 用法，請見[工作流程](https://github.github.io/spec-kit/workflows/overview.html)。

## 交付與註冊

| 途徑 | 來源 | 註冊方式 |
|---|---|---|
| 內建 | `src/specify_cli/workflows/step/<package>/__init__.py` | 在 `src/specify_cli/workflows/__init__.py` 中明確匯入並呼叫 `_register_step()` |
| 已安裝 | `.specify/workflows/steps/<id>/` 下的套件，內含 `step.yml` 與 `__init__.py` | `load_custom_steps(project_root)` 在工作流程執行／恢復時載入相符的 `StepBase` 子類別 |

`STEP_REGISTRY` 將每個 `type_key` 對應到單一步驟執行個體。內建鍵會在載入專案步驟之前，先快照到 `BUILTIN_STEP_TYPES`；不要從可變的註冊表推斷是否為內建。已安裝的套件可透過步驟型錄找到，並以 `specify workflow step add <id>` 加入。預設的社群型錄僅供探索，不代表安裝或信任背書。安裝外部步驟程式碼前請先審查：載入套件會匯入並執行其 Python 模組。

## 步驟合約

繼承 `src/specify_cli/workflows/base.py` 的 `StepBase`，將 `type_key` 設為工作流程 YAML 的 `type`，並實作 `execute(config: dict[str, Any], context: StepContext) -> StepResult`。若需步驟專屬的錯誤，可覆寫 `validate(config)`；基底驗證器要求必須有 `id`。YAML 中省略 `type` 時，會選用內建的 `command` 步驟。

`StepContext` 提供輸入、先前步驟的結果、工作流程預設值、執行與專案路徑，以及迭代／恢復脈絡。回傳的 `StepResult` 需包含 `StepStatus`、輸出對應，以及失敗時的錯誤訊息。引擎會記錄結果，供後續 `{{ steps.<id>.output.* }}` 運算式使用，並保存執行狀態。`PAUSED` 會停下等待恢復；`FAILED` 通常會停止執行，除非設定了 `continue_on_error: true`（明確的中止則一律停止）。`next_steps` 提供控制流程用的巢狀步驟。

引擎會在工作流程驗證期間呼叫 `validate()`，但不會自動驗證傳入 `execute()` 的定義。請在 `execute()` 中也防範無效設定，回傳失敗結果，而不是成功的預設值或未處理的例外。

內建的 shell 步驟預設保留原始的 `run` 插值。步驟層級的 `strict: true` 會在驗證與執行期間拒絕 `run` 中的運算式標記。其選用的 `env` 對應會分別求值字串範本，要求結果為不含 NUL 的字串、且能在 POSIX 上編碼為行程環境，並僅覆寫子行程的環境。`SPECKIT_WORKFLOW_DIR` 仍由引擎掌管。這可防止工作流程運算式的值在嚴格模式下變成 shell 原始碼；但這不是沙箱，也不保證撰寫的指令碼能安全處理環境資料。環境繫結與繼承的設定可能刻意影響可執行檔查找、模組載入與執行期啟動。嚴格模式不會過濾這些內容；工作流程原始碼審查必須涵蓋 `run`、`env` 以及所引用的程式碼。

新的執行會保存一棵執行樹。恢復時會把已完成的出現次數重播到其運算式脈絡中，不再呼叫其實現，然後從未完成的出現次數繼續。已選取的分支、自訂展開、迴圈迭代、fan-out 項目與繫結的工作流程定義，因此在恢復過程中保持凍結。這是刻意設計為僅向前推進：新的恢復輸入不會重新詮釋或重複已完成的工作。舊版狀態會透過其保存的頂層索引一次性進入執行樹。

共用的出現次數執行器負責啟動、檢查點、重播與收尾。步驟實現只回傳結果或展開內容；不管理保存的生命週期狀態。內部工作流程呼叫與已註冊步驟的路徑共用同一套受檢查的轉換與檢查點後通知。每個出現次數的活動屬於執行樹，絕不屬於共用的步驟執行個體。

Fan-out 項目各自擁有獨立的運算式脈絡。其內部結果不會進入共用的父脈絡；父層接收的是合格的項目結果，以及 fan-out 步驟有序的 `output.results`。Fan-out 項目別名僅供回報使用；`fan-in` 的 `wait_for` 目標是宣告的步驟 ID（即 fan-out 步驟自身的 `id`），讀取其有序的 `output.results`，絕不使用產生的項目別名。在完成檢查點之前執行的副作用，在中斷後仍可能重複，因此保證的是至少一次（at-least-once），而非恰好一次（exactly-once）。

註冊表為每個類型保存一個共用執行個體。並行的 `fan-out` 可能從多個執行緒呼叫同一個執行個體：請保持執行無狀態且執行緒安全，每次執行的資料放在 `config` 與 `context` 中，不要放在 `self` 上。

## 工作流程函式

工作流程函式是另一個專案安裝的擴充點，用於運算式管線篩選器。位於 `.specify/workflows/functions/<id>/` 之下的套件包含 `function.yml` 與 `__init__.py`；清單會明確選取可呼叫的屬性，並宣告引數界限。函式名稱與不可變的內建篩選器快照及其他已載入套件，共用扁平命名空間。內建與重複的匯出屬於安裝與載入錯誤；內建項目絕不會被變更。

函式載入器會清除先前專案的自訂篩選器註冊，在匯入程式碼之前驗證所有清單與衝突，再以合成套件名稱匯入每個套件，讓相對匯入得以運作。套件的匯出會全有或全無地註冊，失敗的匯入會從 `sys.modules` 中清除。安裝會驗證並暫存檔案而不匯入；執行、恢復、工作流程新增與工作流程更新，會在工作流程驗證前載入函式。載入可執行的 Python 不是沙箱，也不是信任背書。

函式處理常式會在註冊時包裝，將一般的 `Exception` 失敗正規化為以匯出名稱為前綴的 `ValueError`。這是刻意的函式專屬行為；`BaseException` 不會被捕捉，步驟實作也不會獲得新的復原政策。回傳值會繼續通過既有的運算式與持續性邊界，不另設型別白名單。行程全域的篩選器表由並行的 fan-out 工作讀取，因此處理常式必須無狀態且執行緒安全。

## 共用套件安裝

步驟套件與函式套件共用其安裝、註冊表、URL 與移除機制，而不是各自擁有一份副本：

- `workflows/_package_install.py` 擁有路徑與符號連結安全、樹狀走訪與複製（不跟隨、排除、項目／位元組／深度上限）、專案鎖定、發佈並可回滾、移除，以及單一 `install_package` 流程：拒絕衝突、在建立目錄前驗證來源、暫存、重新驗證暫存副本，再於鎖定下、發佈前即刻重新執行每項衝突檢查。它以小型值物件參數化：`InstallRequest`（要安裝的內容）、`PackageSpec`（命名、錯誤型別與上限；目錄、鎖定與暫存名稱由名詞衍生）、`PackageRules`（該類型的尋找／註冊表／驗證／檢查／進入點語意）與 `StagingOps`（複製、發佈、鎖定；預設為 `StagingOps.standard(spec)`）。移除使用 `RemoveRequest` 與 `RemoveHooks`。
- `workflows/_package_registry.py` 提供 `PackageRegistry`，這是以符號連結安全方式、原子寫入的 JSON 註冊表，寫入失敗時會回滾記憶體內狀態。`StepRegistry` 與 `FunctionRegistry` 僅指明其檔案、目錄、記錄鍵與錯誤型別。
- `workflows/_archive_install.py` 是 `--from` 的 CLI 流程：URL 驗證、不受信任來源提示、GitHub 資產解析、下載、封存格式確認、安全解壓與清理。`_commands._print_package_error` 會算繪失敗，包括將建議附註作為警告。

新的套件類型提供 `PackageSpec`、`PackageRules`、註冊表子類別與其清單解析器；不應複製上述任何內容。步驟安裝器保留其既定名稱（`_copy_package_tree`、`_replace_install`、`_step_install_transaction` 等）作為輕量繫結，並在呼叫時從其模組上限建構規格，讓既有的 patch 點與訊息保持穩定。函式專屬的新增內容保留在 `function/` 中：清單解析、對照內建項目的匯出名稱檢查、註冊表、磁碟上的套件目錄與註冊表中繼資料。

## 新增步驟類型

1. 在各自的 `step/<package>/` 子套件中實作步驟，並以唯一的 `type_key` 明確註冊。對於外部套件，請提供具有相符 `step.type_key` 的 `step.yml`，以及 `__init__.py` 中相符的子類別；僅憑型錄探索不會註冊程式碼。
2. 測試有效與無效的設定、狀態／輸出／錯誤行為，以及相關時的恢復或巢狀／並行執行。註冊表與引擎涵蓋位於 `tests/test_workflows.py`；聚焦的步驟套件可置於 `tests/workflows/` 之下。
3. 當內建步驟變更使用者可撰寫的 YAML 時，更新[工作流程步驟參考](https://github.github.io/spec-kit/workflow-steps/types.html)。請將代理專屬的 CLI 派送保留在整合中，而不是在步驟類型中重複。
