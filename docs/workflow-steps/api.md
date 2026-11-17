# 工作流程步驟 API 參考

本參考說明內建（嵌入式）工作流程步驟與已安裝自訂步驟類型皆支援的 Python 合約。它們實作相同的 `StepBase` 方法，並使用相同的 `StepContext`、`StepResult` 與 `StepStatus` 類型。工作流程定義與引擎擁有的執行語意仍在[工作流程 API 參考](../workflows/api.md)中。

## 交付路由

內建步驟隨 Specify CLI 出貨，不需要另外安裝 `step.yml` 套件。來源註冊是內部貢獻者的議題，不是步驟實作 API。

已安裝的自訂步驟使用相同的執行合約，另加[開發步驟](developing.md)中記載的套件中繼資料、相符的類型身分與安裝需求。兩種交付途徑都不授權步驟變更引擎的登錄檔或檢查點狀態。

## 步驟 Python API

請從 `specify_cli.workflows.base` 匯入 `StepBase`、`StepContext`、`StepResult` 與 `StepStatus`。

| API | 合約 |
| --- | --- |
| `StepBase.type_key` | 符合 YAML `type`；已安裝的自訂步驟還必須符合其套件身分 |
| `validate(config) -> list[str]` | 驗證錯誤；空清單表示有效 |
| `execute(config, context) -> StepResult` | 無狀態、執行緒安全的執行 |
| `can_resume(state) -> bool` | 回傳 true 的基底方法；目前的引擎不會將它作為繼續執行的關卡來呼叫 |
| `StepContext` | 輸入、先前的結果、預設值、路徑、執行 ID、扇出項目與繼續執行上下文 |
| `StepResult.status` | `pending`、`running`、`completed`、`failed`、`skipped` 或 `paused`；預設為 `completed` |
| `StepResult.output` | 輸出對應，預設為空 |
| `StepResult.next_steps` | 巢狀展開，預設為空 |
| `StepResult.error` | 失敗時的錯誤訊息，否則為 null |

`config` 是步驟的 YAML 對應。基底的 `validate()` 會檢查 `id`；覆寫時應以 `super().validate(config)` 保留該檢查，再加入自己的錯誤。執行時不會自動呼叫驗證器，因此也請在 `execute()` 中防護無效的設定。

### StepContext 欄位

| 欄位 | 類型 | 意義 |
| --- | --- | --- |
| `inputs` | `dict[str, Any]` | 已解析的工作流程輸入 |
| `steps` | `dict[str, dict[str, Any]]` | 先前步驟的結果記錄，依撰寫的步驟 ID 鍵入；輸出位於每筆記錄的 `output` 之下 |
| `item` | `Any` | 目前的扇出項目，否則為 `None` |
| `inside_fan_out` | `bool` | 執行是否位於扇出範本內 |
| `fan_in` | `dict[str, Any]` | 彙總的扇入上下文 |
| `default_integration` | `str \| None` | 工作流程整合預設值 |
| `default_model` | `str \| None` | 工作流程模型預設值 |
| `default_options` | `dict[str, Any]` | 工作流程派送預設值 |
| `project_root` | `str \| None` | 專案目錄 |
| `run_id` | `str \| None` | 目前的執行 ID |
| `is_resume` | `bool` | 此次執行是否為繼續執行的嘗試 |
| `workflow_dir` | `str \| None` | 目前工作流程定義的來源目錄 |
| `default_reasoning_effort` | `str \| None` | 工作流程 `reasoning_effort` 預設值，依撰寫原樣；可以是未求值的運算式 |
| `default_context_size` | `str \| None` | 工作流程 `context_size` 預設值，依撰寫原樣；可以是未求值的運算式 |

對應預設為空字典，布林旗標預設為 false，選用的路徑／識別碼預設為 `None`。路徑是字串，不是 `Path` 物件。請使用 `workflow_dir` 存取相對於工作流程的資源，使用 `project_root` 進行專案本機操作；兩者不一定是同一個目錄。

請將輸入與先前的結果記錄視為上下文，而非改寫執行狀態的途徑。請透過 `StepResult` 回傳輸出。扇出項目有各自獨立的結果上下文；工作流程呼叫有自己的輸入與預設值。

### 結果與失敗

請使用 `StepStatus` 的值，而非任意的狀態字串。正常的成功步驟會回傳 `COMPLETED`；`SKIPPED` 記錄已跳過的步驟，`PAUSED` 請求暫停，`FAILED` 記錄錯誤。列舉中也有 `PENDING` 與 `RUNNING`，但回傳任一者並不會讓該次發生保持待處理或執行中：引擎會將它視為已完成。請回傳 `PAUSED` 以便日後繼續執行時停止，而非作為進度狀態。

請回傳可序列化的輸出值，因為引擎會持久化輸出，並將它們暴露給後續的 `{{ steps.<id>.output.* }}` 運算式。`next_steps` 是控制流程展開用的巢狀步驟定義對應清單，不是步驟執行個體的清單。

對於預期的失敗，請回傳 `StepResult(status=StepStatus.FAILED, error=...)`，並將相關診斷放在 `output` 中。
這讓引擎可以套用 `continue_on_error`。未處理的例外無論該旗標為何都會停止執行；
請勿將無效的設定或失敗的操作變成成功的預設值。

```python
from specify_cli.workflows.base import StepBase, StepContext, StepResult, StepStatus


class GreetingStep(StepBase):
    type_key = "greeting"

    def validate(self, config: dict) -> list[str]:
        errors = super().validate(config)
        if not isinstance(config.get("name"), str) or not config["name"].strip():
            errors.append("'name' must be a non-empty string.")
        return errors

    def execute(self, config: dict, context: StepContext) -> StepResult:
        errors = self.validate(config)
        if errors:
            return StepResult(
                status=StepStatus.FAILED,
                error="; ".join(errors),
            )
        return StepResult(output={"message": f"Hello, {config['name']}!"})
```

## 執行與繼續執行合約

步驟執行個體可能會被同時呼叫。請保持執行無狀態且執行緒安全：從 `config` 與 `context` 衍生每次執行的值，而非 `self` 上的可變屬性。

引擎擁有檢查點與生命週期轉換。已完成的發生會在繼續執行時重播，而不會再次呼叫其實作。選取的分支與巢狀展開維持固定；未完成的發生會依[工作流程繼續執行規則](../workflows/api.md#執行身分與繼續)繼續。請勿將 `can_resume()` 用作授權或安全檢查；它不是受強制執行的引擎關卡。

在完成檢查點之前執行的副作用，可能在中斷後重複。請讓外部操作具冪等性或可安全重試；執行並非恰好一次的保證。工作流程快照會凍結定義，而非步驟套件程式碼或外部資源。

## 已安裝類型探索

每個已安裝的步驟只記錄其來源的*種類*——`catalog`（可附型錄名稱）、`local` 或 `url`。本機路徑與來源 URL 永不持久化。請使用 `specify workflow step list` 與 `specify workflow step info <id>` 探索已安裝的類型與來源；請勿變更主機內部的 Python 登錄檔。

## 狀態與設定位置

| 元件 | 位置 | 格式 | 用途 |
| --- | --- | --- | --- |
| 自訂步驟 | `.specify/workflows/steps/{id}/` | 套件 | 已安裝的步驟資訊清單與 Python |
| 步驟登錄檔 | `.specify/workflows/steps/step-registry.json` | JSON | 已安裝的步驟中繼資料 |
| 步驟型錄快取 | `.specify/workflows/steps/.cache/*.json` | JSON | 快取的步驟型錄條目 |
| 專案步驟型錄 | `.specify/step-catalogs.yml` | YAML | 專案層級的步驟來源 |
| 使用者步驟型錄 | `~/.specify/step-catalogs.yml` | YAML | 使用者層級的步驟來源 |

## 另請參閱

- [開發自訂步驟](developing.md)
- [內建步驟設定](types.md)
- [步驟 CLI](cli.md)
- [步驟型錄](catalogs.md)
- [工作流程 YAML 與執行語意](../workflows/api.md)
