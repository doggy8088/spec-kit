# 工作流程步驟設計

工作流程步驟類型定義了工作流程 YAML 中 `type:` 的作用。這是工作流程引擎的擴充點，與代理整合不同：整合負責把工作派送給代理；步驟則負責驗證與執行工作流程行為。整體引擎說明見 [Workflow System Architecture](../workflows/ARCHITECTURE.md)；YAML 用法見 [Workflows](../docs/reference/workflows.md)。

## 交付與註冊

| 途徑 | 來源 | 註冊方式 |
|---|---|---|
| 內建 | `src/specify_cli/workflows/step/<package>/__init__.py` | 在 `src/specify_cli/workflows/__init__.py` 中明確匯入並呼叫 `_register_step()` |
| 已安裝 | `.specify/workflows/steps/<id>/` 下的套件，內含 `step.yml` 與 `__init__.py` | `load_custom_steps(project_root)` 在工作流程執行／恢復時載入相符的 `StepBase` 子類別 |

`STEP_REGISTRY` 將每個 `type_key` 對應到單一步驟執行個體。內建鍵會在載入專案步驟之前，先快照到 `BUILTIN_STEP_TYPES`；不要從可變的註冊表推斷是否為內建。已安裝的套件可透過步驟目錄找到，並以 `specify workflow step add <id>` 加入。預設的社群目錄僅供探索，不代表安裝或信任背書。安裝外部步驟程式碼前請先審查：載入套件會匯入並執行其 Python 模組。

## 步驟合約

繼承 `src/specify_cli/workflows/base.py` 的 `StepBase`，將 `type_key` 設為工作流程 YAML 的 `type`，並實作 `execute(config: dict[str, Any], context: StepContext) -> StepResult`。若需步驟專屬的錯誤，可覆寫 `validate(config)`；基底驗證器要求必須有 `id`。YAML 中省略 `type` 時，會選用內建的 `command` 步驟。

`StepContext` 提供輸入、先前步驟的結果、工作流程預設值、執行與專案路徑，以及迭代／恢復脈絡。回傳的 `StepResult` 需包含 `StepStatus`、輸出對應，以及失敗時的錯誤訊息。引擎會記錄結果，供後續 `{{ steps.<id>.output.* }}` 運算式使用，並保存執行狀態。`PAUSED` 會停下等待恢復；`FAILED` 通常會停止執行，除非設定了 `continue_on_error: true`（明確的中止則一律停止）。`next_steps` 提供控制流程用的巢狀步驟。

引擎會在工作流程驗證期間呼叫 `validate()`，但不會自動驗證傳入 `execute()` 的定義。請在 `execute()` 中也防範無效設定，回傳失敗結果，而不是成功的預設值或未處理的例外。

內建的 shell 步驟預設保留原始的 `run` 插值。步驟層級的 `strict: true` 會在驗證與執行期間拒絕 `run` 中的運算式標記。其選用的 `env` 對應會分別求值字串範本，要求結果為不含 NUL 的字串、且能在 POSIX 上編碼為行程環境，並僅覆寫子行程的環境。`SPECKIT_WORKFLOW_DIR` 仍由引擎掌管。這可防止工作流程運算式的值在嚴格模式下變成 shell 原始碼；但這不是沙箱，也不保證撰寫的指令碼能安全處理環境資料。環境繫結與繼承的設定可能刻意影響可執行檔查找、模組載入與執行期啟動。嚴格模式不會過濾這些內容；工作流程原始碼審查必須涵蓋 `run`、`env` 以及所引用的程式碼。

新的執行會保存一棵執行樹。恢復時會把已完成的出現次數重播到其運算式脈絡中，不再呼叫其實現，然後從未完成的出現次數繼續。已選取的分支、自訂展開、迴圈迭代、fan-out 項目與繫結的工作流程定義，因此在恢復過程中保持凍結。這是刻意設計為僅向前推進：新的恢復輸入不會重新詮釋或重複已完成的工作。舊版狀態會透過其保存的頂層索引一次性進入執行樹。

共用的出現次數執行器負責啟動、檢查點、重播與收尾。步驟實現只回傳結果或展開內容；不管理保存的生命週期狀態。內部工作流程呼叫與已註冊步驟的路徑共用同一套受檢查的轉換與檢查點後通知。每個出現次數的活動屬於執行樹，絕不屬於共用的步驟執行個體。

Fan-out 項目各自擁有獨立的運算式脈絡。其內部結果不會進入共用的父脈絡；父層接收的是合格的項目結果，以及 fan-out 步驟有序的 `output.results`。Fan-out 項目別名僅供回報使用；`fan-in` 的 `wait_for` 目標是宣告的步驟 ID（即 fan-out 步驟自身的 `id`），讀取其有序的 `output.results`，絕不使用產生的項目別名。在完成檢查點之前執行的副作用，在中斷後仍可能重複，因此保證的是至少一次（at-least-once），而非恰好一次（exactly-once）。

註冊表為每個類型保存一個共用執行個體。並行的 `fan-out` 可能從多個執行緒呼叫同一個執行個體：請保持執行無狀態且執行緒安全，每次執行的資料放在 `config` 與 `context` 中，不要放在 `self` 上。

## 新增步驟類型

1. 在專屬的 `step/<package>/` 子套件中實作步驟，並以唯一的 `type_key` 明確註冊。若是外部套件，請提供 `step.yml`，其中 `step.type_key` 需相符，且 `__init__.py` 中有相符的子類別；僅靠目錄探索不會註冊程式碼。
2. 測試有效與無效的設定、狀態／輸出／錯誤行為，以及在相關時測試恢復或巢狀／並行執行。註冊表與引擎的測試涵蓋位於 `tests/test_workflows.py`；聚焦的步驟測試套件可放在 `tests/workflows/` 下。
3. 當內建步驟變更了使用者可撰寫的 YAML 時，更新[工作流程參考文件](../docs/reference/workflows.md)。代理專屬的 CLI 派送應保留在整合中，不要在步驟類型裡重複實作。
