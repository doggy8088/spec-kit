# 工作流程覆蓋層

工作流程覆疊讓專案可以在不編輯已安裝 `workflow.yml` 的情況下，擴充或覆寫已安裝的工作流程。這讓本地自訂在 `specify bundle update` 或 `specify workflow add` 升級時能安全保留。

當 `specify workflow run <workflow-id>` 載入工作流程時，引擎會將基礎工作流程與該工作流程 ID 的所有已啟用覆疊組合。結果會如同任何其他工作流程定義一樣進行驗證。

## 覆疊如何運作

覆疊是一個 YAML 檔案，宣告一組針對基礎工作流程步驟清單的編輯操作。覆疊使用數值小者勝出的優先順序：優先級數字較大的先套用，數字較小的最後套用。優先級相同的覆疊會依 ID 的字母順序套用，最後一個 ID 在衝突時勝出。

專案覆疊檔案位於：

| 位置 | 用途 |
| --- | --- |
| `.specify/workflows/overlays/<id>/*.yml` | 專案本地自訂 |

## 覆疊檔案格式

建議的編輯格式使用操作名稱作為鍵，錨點步驟 ID 作為值：

```yaml
id: "my-overlay"
extends: "speckit"
priority: 10
enabled: true
edits:
  - insert_after: implement
    step:
      id: run-lint
      type: shell
      run: "ruff check src/"

  - replace: review-spec
    step:
      id: review-spec
      type: gate
      message: "Review the generated spec (overlay override)."
      options: [approve, reject]
      on_reject: abort
```

也支援明確形式：

```yaml
edits:
  - operation: insert_after
    anchor: implement
    step:
      id: run-lint
      type: shell
      run: "ruff check src/"
```

### 欄位

| 欄位 | 必填 | 說明 |
| --- | --- | --- |
| `id` | 是 | 此覆疊的識別碼。用於 `specify workflow overlay *` 命令。只能包含小寫字母、數字與連字號；不得包含點、底線、路徑分隔符號或 `overlays`。 |
| `extends` | 是 | 此覆疊適用的工作流程 ID。使用與 `id` 相同的安全 ID 格式；`overlays`、`runs` 與 `steps` 為保留字。 |
| `priority` | 否 | 整數；預設為 `10`。數值越小，優先級越高，衝突時勝出。缺失或無效的值會退回 `10`。 |
| `enabled` | 否 | 布林值。預設為 `true`。已停用的覆疊會被忽略。 |
| `edits` | 是 | 非空的編輯操作清單。 |

### 編輯操作

| 操作 | 需要 `step` | 效果 |
| --- | --- | --- |
| `insert_after` | 是 | 在錨點步驟之後立即插入 `step`。 |
| `insert_before` | 是 | 在錨點步驟之前立即插入 `step`。 |
| `replace` | 是 | 以 `step` 取代錨點步驟。 |
| `remove` | 否 | 從清單中移除錨點步驟。 |

`anchor` 是基礎工作流程中某個步驟的 `id`。錨點會在 `then`、`else`、`steps`、`cases.*` 與 `default` 區塊內遞迴解析，因此巢狀的基礎步驟也可以作為目標。扇出範本（`fan-out` 步驟內的 `step`）**不是**有效的錨點。

步驟 ID 不得包含 `:`：該字元保留給引擎產生的巢狀 ID。

## 管理覆蓋層

使用[覆疊 CLI 命令](cli.md#覆蓋層管理)新增、列出、設定優先順序、啟用、停用與移除覆疊，或使用 `specify workflow resolve <workflow-id>` 檢查組合結果。

## 範例：實作後新增自動化 Lint

以內建的 `speckit` 工作流程為例，建立 `project-overlay.yml`：

```yaml
id: "add-lint"
extends: "speckit"
priority: 10
edits:
  - insert_after: implement
    step:
      id: run-lint
      type: shell
      run: "ruff check src/"
```

安裝它：

```bash
specify workflow overlay add project-overlay.yml --priority 10
```

執行工作流程：

```bash
specify workflow run speckit -i spec="Build a kanban board"
```

組合後的工作流程現在會執行完整的 SDD 循環，並在 `implement` 步驟後自動執行 `ruff check src/`。

## 範例：取代關卡

```yaml
id: "skip-plan-review"
extends: "speckit"
priority: 5
edits:
  - replace: review-plan
    step:
      id: review-plan
      type: command
      command: speckit.plan
      input:
        args: "{{ inputs.spec }}"
```

優先級數值越小，優先順序越高。此覆疊的 `priority: 5` 會在與優先級 10 的覆疊發生衝突時勝出。它會以另一個計畫命令取代 `review-plan` 關卡，因此既有的計畫命令仍會執行。

## 工作流程槽位（上游擴充點）

工作流程作者可以使用 `type: slot` 宣告具名、無操作的工作流程槽位：

```yaml
- id: post-implement
  type: slot
  name: "Post-implementation checks"
```

步驟 `id` 是唯一的覆疊錨點；`name` 是必填、不可空白、
僅供人類閱讀的標籤。未填入的槽位會以 `skipped` 步驟完成，
並帶有 `output: {slot: <name>}`，因此後續步驟可以正常繼續。

使用結構描述有效的覆疊 `replace` 編輯填入槽位，錨點是步驟
`id`，而非其 `name`：

```yaml
id: fill-post-implement
extends: my-workflow
edits:
  - replace: post-implement
    step:
      id: post-implement
      type: shell
      run: "echo Run project-specific checks"
```

當後續運算式或 `fan-in.wait_for` 參照槽位時，請重複使用槽位的 `id`。
取代內容還必須保留後續步驟取用的每個輸出鍵：
未填入的工作流程槽位只提供 `steps.<id>.output.slot`。槽位步驟
不支援在 `fan-out.step` 範本內使用，因為執行期倍增的
範本無法作為覆疊錨點。

## 與套件組及更新的互動

`specify workflow add <local-directory>` 會將完整的本地工作流程
套件安裝到 `.specify/workflows/<id>/`。封存檔安裝會保留相同的
套件內容。

當已安裝的工作流程被重新整理或重新安裝時，`.specify/workflows/overlays/<id>/` 中的專案覆疊會被保留，因為它們位於已安裝工作流程目錄之外。

## 限制

- 覆疊只對步驟清單操作。它們無法變更工作流程中繼資料、輸入、輸出、`requires` 或工作流程層級預設值。若要變更步驟中的運算式，請取代該步驟。
- 扇出範本無法作為錨點。
- 若覆疊的目標步驟 ID 在基礎工作流程中不存在，解析工作流程時會引發驗證錯誤。
- 覆疊無法以其他覆疊新增的步驟為目標。
- 覆疊無法新增輸入，也無法變更基礎工作流程的輸入結構描述。

## 另請參閱

- [Workflow CLI](cli.md#覆蓋層管理)
- [Step types](../workflow-steps/types.md)
