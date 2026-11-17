# 工作流程 CLI 參考

`specify workflow` 群組管理著工作流程套件與執行狀態。大多數命令需要已初始化的 Spec Kit 專案；本地 YAML 執行是例外。選項是依命令而定：`--json` 不是群組通用的旗標。

## 執行工作流程

```bash
specify workflow run <source>
```

| 選項              | 說明                                              |
| ------------------- | -------------------------------------------------------- |
| `-i` / `--input`    | 以 `key=value` 傳入輸入值（可重複使用）            |
| `--json`            | 以單一 JSON 物件輸出執行結果             |

執行已安裝且已啟用的工作流程 ID，或本地 YAML 檔案。依 ID 執行前，請先以 `specify workflow add` 安裝型錄工作流程或 URL。工作流程宣告的輸入可以透過 `--input` 提供，或在互動模式下提示輸入。

範例：

```bash
specify workflow run speckit -i spec="Build a kanban board with drag-and-drop task management"
```

輸入值遵循[輸入類型合約](api.md#輸入類型)。

搭配 `--json` 時，會列印單一機器可讀的物件，而非格式化文字（省略此旗標時，預設輸出不變）：

```bash
specify workflow run my-pipeline.yml --json
```

```json
{
  "run_id": "662bf791",
  "workflow_id": "build-and-review",
  "status": "paused",
  "current_step_id": "review",
  "current_step_index": 0
}
```

`workflow_id` 是 YAML 內部宣告的 `workflow.id`，而非檔案名稱。物件會完全依照所示方式列印：以兩個空格縮排美化列印，輸出到純文字的標準輸出，不含 Rich 標記，因此永遠可以解析。在 `--json` 模式下執行工作流程時，步驟原本會列印的任何進度（例如關卡提示，或提示詞步驟 CLI 子行程的輸出）都會重新導向到標準錯誤，因此標準輸出只承載 JSON 物件。請從標準輸出讀取物件；讓標準錯誤保持連接到終端機，或另行擷取。

對於 `failed` 與 `aborted` 的執行，酬載會包含 `error` 欄位，承載終止步驟的錯誤訊息：

```json
{
  "run_id": "662bf791",
  "workflow_id": "build-and-review",
  "status": "failed",
  "current_step_id": "boom",
  "current_step_index": 0,
  "error": "Command exited with code 3"
}
```

`completed` 與 `paused` 的執行會省略 `error` 欄位。錯誤會保存於該次執行的 `state.json` 中，因此事後 `specify workflow status <run_id> --json` 也會呈現相同的訊息。

在建立或載入執行狀態之前發生的配接器載入失敗，會使用執行前失敗封套：新的執行沒有執行 ID，而繼續執行則保留所提供的執行 ID，但沒有工作流程或步驟內容。執行狀態存在之後，來自逐步驟重新載入或已驗證延遲匯入的配接器失敗，會保留實際的執行、工作流程與目前步驟欄位，就如同執行 I/O 失敗一樣。若儲存狀態失敗，磁碟上的狀態可能仍反映最後一次成功儲存的結果，而非回報的 I/O 失敗。

> **注意：** 大多數工作流程命令都需要已使用 `specify init` 初始化的專案。例外是 `specify workflow run <local-file.{yml,yaml}>`，可以在專案外執行；此時，執行狀態會儲存在目前目錄的 `.specify/workflows/runs/<run_id>/` 下。
>
## 繼續工作流程

```bash
specify workflow resume <run_id>
```

| 選項              | 說明                                              |
| ------------------- | -------------------------------------------------------- |
| `-i` / `--input`    | 以 `key=value` 提供更新的輸入值（可重複使用）         |
| `--json`            | 以單一 JSON 物件輸出繼續結果          |

從保存的執行狀態繼續已暫停或失敗的工作流程執行。`running` 狀態的執行不可繼續。繼續時會將已完成的工作重播到其運算式內容中，而不再次執行步驟實作，然後在未完成的發生點繼續。這讓執行可以在暫停後取得新資訊時繼續，或在失敗後以修正的值繼續。

所提供的 `--input` 值會合併覆蓋該次執行已儲存的根輸入，並針對工作流程的輸入類型重新驗證。未知的根輸入名稱會被忽略。更新的值只影響未完成的工作；已完成的步驟與呼叫不會重新解譯或重複執行：

```bash
specify workflow resume <run_id> --input cmd="exit 0"
```

## 工作流程狀態

```bash
specify workflow status [<run_id>]
```

| 選項              | 說明                                              |
| ------------------- | -------------------------------------------------------- |
| `--json`            | 以 JSON 物件輸出執行狀態（或執行清單）      |

顯示特定執行的狀態，若未提供 ID 則列出所有執行。執行狀態包括：`created`、`running`、`completed`、`paused`、`failed`、`aborted`。

## 工作流程定義

```bash
specify workflow definition <run_id> --json
```

| 選項   | 說明                                                      |
| -------- | ---------------------------------------------------------------- |
| `--json` | 必填。以 JSON 物件輸出該次執行的工作流程定義    |

傳回某次執行**啟動時**所用的工作流程定義，讓整合可以在不偏離引擎實際執行內容的情況下呈現某次執行（例如它宣告的關卡及其訊息）。它只讀取該次執行自身保存的資料，永遠不讀取已安裝的工作流程：編輯或移除已安裝的工作流程不會變更輸出。執行期進度與作用中的關卡來自 [`specify workflow status --json`](#工作流程狀態)。

省略 `--json` 會以代碼 `2` 結束，並在標準錯誤上列印使用訊息；不會產生標準輸出。文字呈現器已延後，因此下方的 JSON 形狀是唯一的合約。

```json
{
  "run_id": "662bf791",
  "definition": {
    "schema_version": "1.0",
    "workflow": { "id": "spec-review", "name": "Spec review", "version": "1.0.0" },
    "steps": [
      { "id": "draft", "type": "command", "command": "speckit.specify" },
      { "id": "approve", "type": "gate", "message": "Review the specification." }
    ]
  },
  "workflow_scopes": []
}
```

- **`definition`** 是為該次執行保存的工作流程，逐字呈現且已套用覆疊，因此反映實際執行的步驟。每個鍵都會透傳（包括 `requires`、`outputs` 與未知鍵）。不會新增、重新命名或補入任何內容：省略的欄位（例如關卡的 `options`）表示執行時套用引擎預設值。運算式（`{{ ... }}`）不會被求值。結構遵從[工作流程 YAML 結構描述](api.md#工作流程-yaml-結構描述)，因此 `schema_version` 是此介面的版本，結構描述變更即視為介面變更；由於 `definition` 依撰寫原樣輸出，省略的 `schema_version` 預設為 `"1.0"`，且引擎會比較 `str(schema_version)`（因此 YAML 中未加引號的 `schema_version: 1.0` 會以 JSON 數字 `1.0` 呈現）。未來版本可能會在頂層回應封套（`run_id`、`definition`、`workflow_scopes`）中新增鍵，但既有的封套鍵永遠不會被移除或重新命名。
- **純 JSON。** JSON 無法表示的 YAML 原生值（例如未加引號的日期）會以字串呈現。二進位值（`!!binary`）不會輸出：每個都會以 `"<binary: N bytes>"` 佔位符呈現，其值本身則保留在該次執行的快照中。集合（`!!set`）會以依其 JSON 形式排序的清單呈現，因此輸出不依賴雜湊隨機化。非字串對應鍵與非有限數字也會字串化。兩個對應鍵若收合為同一個 JSON 屬性名稱（例如 `1` 與 `"1"`），命令會失敗，而非輸出有損的 JSON。JSON 無法共用參照，因此重複使用的 YAML 別名（錨點）會被複製；遞迴別名，或展開後超過固定節點或輸出大小預算的非遞迴別名圖，會失敗，而非消耗無上限的 CPU、記憶體與標準輸出。預算會分別套用到每個定義（根定義與 `workflow_scopes` 中的每個項目），因此含有許多已繫結工作流程呼叫的執行，不會因其總大小而被拒絕。另一個大得多的上限（32 MiB）會限制整個回應，因此重複大型定義的迴圈或扇出會失敗，而非將其倍增。字串化後長度超過 256 個字元的非字串對應鍵，也會基於相同理由被拒絕。
- **`workflow_scopes`**（一律存在）保存已到達的每個[工作流程呼叫](../workflow-steps/types.md#工作流程組合)的凍結定義，依執行順序排列。每個項目為 `{ "scope_path", "workflow_id", "definition" }`，其中 `scope_path` 與 `workflow_id` 與 `status --json` 中的值相同。`definition` 內的呼叫步驟保持撰寫原樣；被呼叫者永遠不會就地展開。尚未到達的呼叫，或其目標無法解析的呼叫，沒有對應項目，且其定義永遠不會從已安裝的工作流程讀取。清單會隨著呼叫被到達而增長，迴圈或扇出內的呼叫，每次迭代或每個項目各有一個項目。
- **不包含：動態產生的步驟。** 輸出包含撰寫的根定義，以及已繫結工作流程呼叫的凍結定義。透過 `StepResult.next_steps` 在執行期由自訂步驟類型產生的步驟，會保存於該次執行的執行狀態中，但不會匯出，因此以該方式建立的關卡在此輸出中沒有定義。內建的 `if`、`switch`、`while`、`do-while` 與 `fan-out` 步驟，其步驟來自撰寫的定義，已涵蓋在內。
- **`scope_path`** 是從根開始的字串清單：每個外層步驟的撰寫 `id`（沒有 `id` 的步驟為 `step-<index>`）。`if`、`switch`、迴圈與扇出等容器都是元素；每次迴圈迭代與每個扇出項目都會新增其索引作為字串，包括第一次（`["loop", "0", "call"]`）。`workflow_scopes` 在此一律存在，而 `status --json` 只有在該次執行含有工作流程呼叫時才包含它。

### 將關卡與其定義對應

`status --json` 會將作用中的關卡回報為 `gate.step_id` 與 `gate.scope_path`。若要尋找該關卡的定義：

1. 當 `gate.scope_path` 缺失時，將其讀作 `[]`：對於直接位於根工作流程中的關卡，`status --json` 會省略它。然後取 `workflow_scopes` 中 `scope_path` 為 `gate.scope_path` 前綴且最長的那個項目。若沒有，則使用根 `definition`。不要要求精確相符：`gate.scope_path` 會列出每個外層步驟，包括 `if`、`switch`、迴圈與扇出容器，而項目的 `scope_path` 止於呼叫步驟。在名為 `route` 的 `if` 內、由 `call` 呼叫的工作流程中，名為 `wrap` 的 `if` 內的關卡，會回報 `["route", "call", "wrap"]`，而其項目為 `["route", "call"]`。
2. 在該定義中，尋找 `id` 等於撰寫步驟 ID 的步驟。在後續迴圈迭代與扇出項目中，`step_id` 會限定為 `<container>:<id>:<n>`（例如 `fan:g:0`）；撰寫 ID 是以 `:` 分隔的倒數第二個區段，因為撰寫的步驟 ID 不允許包含 `:`。步驟 ID 在定義內唯一，扇出範本除外，範本有自己的 ID 命名空間：根步驟與扇出範本步驟可以共用同一個 ID。若 `gate.scope_path` 經過扇出步驟，只在該步驟的 `step` 範本內尋找；否則忽略扇出範本。例如，根 shell `g` 與扇出 `fan` 範本中的關卡 `g` 同時存在，而帶有 `scope_path` `["fan", "0"]` 的 `fan:g:0` 是範本的關卡，而非根 shell。

由自訂步驟在執行期產生的關卡沒有可對應的定義；參閱上方關於動態產生步驟的說明。

`status --json` 不會回報被呼叫工作流程內部步驟的逐步驟狀態。

### 錯誤

失敗時會將單一 `{"error": "<message>"}` 物件寫入標準錯誤，讓標準輸出保持空白，並以代碼 `1` 結束：不是 Spec Kit 專案、無效的 `SPECIFY_INIT_DIR`、不安全（包括符號連結的）工作流程儲存空間、無效或未知的執行 ID、無法讀取或巢狀過深的執行狀態、沒有保存定義的執行（例如在保存定義功能之前建立的執行）、損毀的定義或執行狀態、對應鍵收合為同一個 JSON 屬性名稱的定義，以及含有遞迴或過大而無法展開的 YAML 別名的定義。搭配 `--json` 的使用錯誤也使用此 JSON 錯誤合約，並以代碼 `2` 結束。

## 列出已安裝的工作流程

```bash
specify workflow list
```

列出目前專案中已安裝的工作流程。

## 安裝工作流程

```bash
specify workflow add <source>
```

| 選項          | 說明                                            |
| --------------- | ------------------------------------------------------ |
| `--dev`         | 從本地 YAML 檔案、套件目錄或封存檔安裝 |
| `--from <url>`  | 從自訂 URL 安裝（`<source>` 命名預期的工作流程 ID） |
| `--version <version>` | 安裝精確的已宣傳型錄發行版本（`<source>` 必須是工作流程 ID） |

從型錄、HTTPS URL、本地 YAML 檔案、包含 `workflow.yml` 的
目錄，或 `.zip`、`.tar.gz`、`.tgz`
封存檔安裝工作流程。封存檔可以在根目錄或單一
頂層目錄內包含 `workflow.yml`。

目錄與封存檔安裝會保留完整的工作流程套件，
包括指令碼與其他附屬檔案。ZIP、`.tar.gz` 與 `.tgz`
封存檔遵循相同的驗證與安裝行為。

關於精確版本型錄選取及其摘要要求，請參閱[型錄發行版本](catalogs.md#工作流程發行版本)。

## 工作流程函式

```bash
specify workflow function add <id> --dev <directory>
specify workflow function add <id> --from <archive-url>
specify workflow function list [--json]
specify workflow function remove <id>
```

`add` 必須恰好指定一個來源選項。函式套件是 Python 程式碼，會在工作流程驗證之前載入；只安裝你已審查過的套件。`list --json` 會回報登錄中繼資料與一般匯出使用情形，而不匯入套件程式碼。

## 更新工作流程

```bash
specify workflow update [workflow_id]
```

將一個已安裝的型錄工作流程（或未提供 ID 時的全部工作流程）更新到最新的型錄版本。會提示確認，若下載或驗證失敗，則保留已安裝的副本。

## 啟用或停用工作流程

```bash
specify workflow enable <workflow_id>
specify workflow disable <workflow_id>
```

已停用的工作流程會保持已安裝並列出（標記為 `[disabled]`），但在重新啟用前拒絕執行。

## 移除工作流程

```bash
specify workflow remove <workflow_id>
```

從專案中移除已安裝的工作流程。

## 搜尋可用的工作流程

```bash
specify workflow search [query]
```

| 選項     | 說明       |
| ---------- | ----------------- |
| `--tag`    | 依標籤篩選     |
| `--author` | 依作者篩選  |

在所有作用中的型錄中搜尋符合查詢的工作流程。

## 工作流程資訊

```bash
specify workflow info <workflow_id>
specify workflow info <workflow_id> --versions
```

顯示工作流程的詳細資訊，包括其步驟、輸入與要求。
`--versions` 會列出目前型錄版本，接著是已宣傳的歷史
版本，並指出勝出的型錄是允許安裝還是
僅供探索（不可安裝）。當本地安裝的是不同版本時，它也能運作。

## 解析工作流程

```bash
specify workflow resolve <workflow-id>
```

顯示基礎／覆疊堆疊與步驟來源歸屬。它不會顯示完整的 shell 命令或環境繫結；執行前請先審查提供內容的原始檔案。

## 覆蓋層管理

### 新增專案覆疊

```bash
specify workflow overlay add <path-to-overlay.yml> --priority <n>
```

驗證覆疊檔案，並將其複製到 `.specify/workflows/overlays/<extends>/<id>.yml`。`--priority` 預設為 `10`，並覆寫檔案中的 `priority` 欄位。

### 列出覆蓋層

```bash
specify workflow overlay list <workflow-id>
```

顯示該工作流程的所有覆疊，依解析器優先順序排列。已停用的覆疊會在清單中標記為已停用，並在工作流程解析期間被忽略。

### 變更優先順序

```bash
specify workflow overlay set-priority <workflow-id> <overlay-id> <n>
```

### 啟用或停用

```bash
specify workflow overlay disable <workflow-id> <overlay-id>
specify workflow overlay enable <workflow-id> <overlay-id>
```

### 移除

```bash
specify workflow overlay remove <workflow-id> <overlay-id>
```

移除專案覆疊檔案。

## 型錄管理

### 列出型錄

```bash
specify workflow catalog list
```

顯示所有作用中的型錄來源。

### 新增型錄

```bash
specify workflow catalog add <url> [--name <name>]
```

| 選項          | 說明                      |
| --------------- | -------------------------------- |
| `--name <name>` | 型錄的可選名稱    |

將自訂型錄 URL 新增到專案的 `.specify/workflow-catalogs.yml`。
新項目允許安裝，並取得排在既有項目之後的優先順序。只新增已審查的來源。請編輯型錄設定，以設定僅供探索的來源。

以相同的名稱重新新增相同的工作流程型錄 URL 會成功且不變更設定；不同的名稱會被拒絕。

### 移除型錄

```bash
specify workflow catalog remove <index>
```

依其在對應優先順序 `catalog list` 中的索引，移除專案型錄。
由 `SPECKIT_WORKFLOW_CATALOG_URL` 提供的來源無法以此方式移除；請取消設定該變數來管理專案來源。

## 另請參閱

- [Workflow overview](overview.md)
- [Workflow API](api.md)
- [步驟管理 CLI](../workflow-steps/cli.md)
- [Built-in step types](../workflow-steps/types.md)
- [Overlay format](overlays.md)
- [型錄結構描述與信任](catalogs.md)
