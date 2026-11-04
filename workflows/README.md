# 工作流程

工作流程是以 YAML 定義的多步驟、可續跑的自動化管線。它們能跨整合調度 Spec Kit 命令、評估控制流程，並在人工審查關卡暫停 — 讓端到端的規格驅動開發循環無需逐步手動呼叫即可完成。

## 運作方式

工作流程定義宣告一連串步驟。引擎會依序執行它們，將命令分派給 AI 整合、
執行 shell 命令、評估分支條件，並在關卡暫停等待人工審查。
持久化的執行轉換讓工作流程能在中斷後續跑，無需
重新執行已完成的工作。

```yaml
steps:
  - id: specify
    command: speckit.specify
    input:
      args: "{{ inputs.spec }}"

  - id: review
    type: gate
    message: "Review the spec before planning."
    options: [approve, reject]
    on_reject: abort

  - id: plan
    command: speckit.plan
```

如需詳細的架構與內部運作，請參閱 [ARCHITECTURE.md](ARCHITECTURE.md)。

## 快速入門

```bash
# Search available workflows
specify workflow search

# Install the built-in SDD workflow
specify workflow add speckit

# Or run directly from a local YAML file
specify workflow run ./workflow.yml --input spec="Build a user authentication system with OAuth support"

# Run an installed workflow with inputs
specify workflow run speckit --input spec="Build a user authentication system with OAuth support"

# Check run status
specify workflow status

# Resume after a gate pause
specify workflow resume <run_id>

# Get detailed workflow info
specify workflow info speckit

# Remove a workflow
specify workflow remove speckit
```

## 執行工作流程

### 從已安裝的工作流程執行

```bash
specify workflow add speckit
specify workflow run speckit --input spec="Build a user authentication system with OAuth support"
```

### 從本機 YAML 檔案執行

```bash
specify workflow run ./my-workflow.yml --input spec="Build a user authentication system with OAuth support"
```

### 多個輸入

當工作流程宣告多個輸入時，每個輸入各用一個
`--input` 旗標傳入。例如，一個自訂工作流程以
`scope` 選擇器作為步驟的關卡條件：

```bash
specify workflow run ./my-workflow.yml \
  --input spec="Build a user authentication system with OAuth support" \
  --input scope="backend-only"
```

內建的 `speckit` 工作流程只宣告 `spec`（以及選擇性的
`integration`）；它不接受 `scope` 輸入。

## 步驟類型

工作流程支援 14 種內建步驟類型，包括用來以私人輸入與宣告輸出呼叫
已安裝工作流程的 `workflow`。請參閱
[工作流程組成與續跑](../docs/reference/workflows.md#workflow-composition)，
了解範圍與執行身分契約。

### 命令步驟（預設）

透過整合 CLI 以名稱呼叫已安裝的 Spec Kit 命令：

```yaml
- id: specify
  command: speckit.specify
  input:
    args: "{{ inputs.spec }}"
  integration: claude        # Optional: override workflow default
  model: "claude-sonnet-4-20250514"   # Optional: override model
```

CLI 整合可以公開逐步的位置參數與具名執行期
選項。例如，Docker Agent 接受一個代理參照，以及經驗證的
`agent` 與 `safety` 選項。模型選擇請使用命令步驟的頂層 `model` 欄位：

```yaml
- id: specify-with-docker-agent
  command: speckit.specify
  integration: docker-agent
  integration_args:
    - "{{ inputs.agent_config }}"
  integration_options:
    agent: root
    safety: balanced
  model: "openai/gpt-5"
  input:
    args: "{{ inputs.spec }}"
```

`integration_args` 必須是字串的有序清單。運算式會逐一
解析每個元素。`integration_options` 必須是鍵為字串的對應；
其值同樣會經運算式解析，並由所選
整合驗證。當整合不支援時，非空的執行期設定會被拒絕。
解析出的值會儲存在工作流程執行狀態中，供稽核
與復原使用。續跑時，完整的分派設定（`integration`、
`model`、`integration_args` 與 `integration_options`）會從
目前的工作流程輸入重新解析；若沒有更新的輸入，就會重現先前的值。

當 Docker Agent 的 `integration_args` 為命令
步驟提供了代理參照時，它的優先級高於 `SPECKIT_INTEGRATION_DOCKER_AGENT_EXTRA_ARGS`；
該步驟會忽略整個舊有的環境值。若沒有逐步的
代理參照，舊有的環境行為維持不變。

### 提示詞步驟

將任意的內嵌提示詞傳送給整合 CLI（不需要命令檔案）：

```yaml
- id: security-review
  type: prompt
  prompt: "Review {{ inputs.file }} for security vulnerabilities"
  integration: claude
```

### 擷取命令與提示詞輸出

命令與提示詞步驟會將 CLI 的輸出串流到終端機，因此它們的
`output.stdout` 與 `output.stderr` 是空的。設定 `capture: true` 可保留
輸出供後續步驟使用：

```yaml
- id: verdict
  type: prompt
  prompt: "Reply with exactly READY or BLOCKED for {{ inputs.spec }}"
  capture: true
  capture_max_bytes: 4096   # Optional: per-stream limit (default 1 MiB, -1 = no limit)
  timeout: 120              # Optional: seconds before the CLI is killed
```

被擷取的步驟在執行時不會印出任何內容。超過上限的輸出會被
丟棄，並回報在 `output.stdout_truncated`／`output.stderr_truncated` 中；
逾時或中斷會使步驟失敗，設定 `output.timed_out` 或
`output.interrupted`，並保留部分輸出。在
解析文字之前，請先檢查這些欄位。

> ⚠️ 擷取的輸出會未經遮蔽地儲存在該次執行的 `state.json` 中，而且它是
> 不受信任的代理文字。請參閱
> [擷取命令與提示詞輸出](../docs/reference/workflows.md#capturing-command-and-prompt-output)，
> 了解完整契約。

### Shell 步驟

執行 shell 命令並擷取輸出：

```yaml
- id: run-tests
  type: shell
  strict: true          # Optional: reject workflow expressions in run
  run: "npm test"       # runs from the project root; no interpolation needed
  timeout: 1800   # Optional: max seconds before the command is killed (default 300)
```

對於動態值，優先使用 `strict: true` 並搭配逐步的 `env` 對應，例如
`env: {RESULT: "{{ steps.plan.output.stdout }}"}`。值必須解析為字串，
並以環境資料的形式傳遞，而不是插入 `run`。請在
被呼叫的程式內部讀取它們；在 POSIX 上，於固定指令碼中使用引號包住的變數展開
也同樣合適。嚴格模式不是沙箱：不要以
`eval` 或巢狀 shell 重新解讀值。省略 `strict`，或將它設為 `false`，會保留
既有的原始插值及其風險。

在安裝或執行不熟悉的工作流程之前，請審查 `run` 與
`env`，包括覆蓋變更與被參照的程式碼。即使使用 `strict: true`，
`PATH` 與 `PYTHONPATH` 等設定仍可能選到不同的可執行檔或模組。
字串驗證與型錄或套件組安裝都不能建立信任。

> ⚠️ **限制 `run` 欄位中的插值。**`run` 欄位是由
> 系統 shell 執行的，而 `{{ ... }}` 運算式會以原始文字被替換，
> 沒有自動加上引號或跳脫。`inputs.*` 的值或前一個步驟的輸出
> （包括 AI 產生的 `prompt` 輸出）會被解析為 shell 語法，並可能
> 改變實際執行的命令。唯一可靠的控制方式是在來源處以 `enum`／允許清單限制這類
> 值，或將你無法限制的值完全排除在 `run` 之外。為替換加上引號有助於受信任的值
> 在分詞後存活，但它**不是**安全邊界 — 沒有
> shell 跳脫過濾器，而含有相符引號的值仍可能
> 突破出來。請參閱
> [插值與 shell 安全](../docs/reference/workflows.md#interpolation-and-shell-safety)。

`timeout` 是命令在被中止且步驟失敗之前，最多可執行的秒數；它必須是正數，未
指定時預設為
`300`（五分鐘）。對於長時間的關卡，例如
完整建置、linter 聚合器或整合測試目標，請提高它。

### GitHub 步驟

內建的 `github` 步驟會在工作流程使用 `type: github` 時，為明確設定的 issue 或 pull request
加上標籤。它不會安裝或呼叫
選擇加入的 GitHub 代理命令擴充功能。請參閱
[GitHub 步驟參考](../docs/reference/workflows.md#github-step)，了解
設定、憑證與重試行為。

### Init 步驟

以與 `specify init` 相同的方式引導專案 — 建立骨架
範本、指令碼、共用基礎設施，以及所選的程式代理
整合。以非互動方式執行（預設為 `--ignore-agent-tools`），
並從步驟設定或工作流程預設值解析整合：

```yaml
- id: bootstrap
  type: init
  here: true                 # or: project: my-project
  integration: copilot       # Optional: defaults to workflow integration
  integration_options: "--skills"  # Optional: extra options for the integration
  script: sh                 # Optional: sh, ps, or py
  force: true                # Optional: required when target directory already exists
  preset: healthcare-compliance   # Optional preset ID
```

### 工作流程插槽

宣告一個具名的工作流程插槽，讓下游專案可以用
工作流程覆蓋層來填入。未填入時插槽會被略過；它的 `id` 是覆蓋層
錨點，`name` 是必填的易讀標籤：

```yaml
- id: post-implement
  type: slot
  name: "Post-implementation checks"
```

使用以 `post-implement` 為錨點的覆蓋層 `replace` 編輯來填入插槽。
當下游運算式或匯入步驟參照它時，請保持相同的 `id`，
並保留它們所取用的任何輸出鍵。插槽步驟在
`fan-out.step` 範本內無效，因為那些在執行期倍增的範本無法被
覆蓋層鎖定。

### 關卡步驟

暫停等待人工審查。當呼叫 `specify workflow resume` 時，工作流程會續跑：

```yaml
- id: review-spec
  type: gate
  message: "Review the generated spec before planning."
  options: [approve, edit, reject]
  on_reject: abort
```

### If／Then／Else 步驟

依運算式進行條件分支：

```yaml
- id: check-scope
  type: if
  condition: "{{ inputs.scope == 'full' }}"
  then:
    - id: full-plan
      command: speckit.plan
  else:
    - id: quick-plan
      command: speckit.plan
      options:
        quick: true
```

### Switch 步驟

依運算式的值進行多分支分派：

```yaml
- id: route
  type: switch
  expression: "{{ steps.review.output.choice }}"
  cases:
    approve:
      - id: plan
        command: speckit.plan
    reject:
      - id: log
        type: shell
        run: "echo 'Rejected'"
  default:
    - id: fallback
      type: gate
      message: "Unexpected choice"
```

### While 迴圈步驟

在條件為真時重複步驟：

```yaml
- id: retry
  type: while
  condition: "{{ steps.run-tests.output.exit_code != 0 }}"
  max_iterations: 5
  steps:
    - id: fix
      command: speckit.implement
```

### Do-While 迴圈步驟

至少執行步驟一次，然後在條件成立時重複：

```yaml
- id: refine
  type: do-while
  condition: "{{ steps.review.output.choice == 'edit' }}"
  max_iterations: 3
  steps:
    - id: revise
      command: speckit.specify
```

### 扇出步驟

為集合中的每個項目分派一個步驟範本（循序執行）：

```yaml
- id: parallel-impl
  type: fan-out
  items: "{{ steps.tasks.output.task_list }}"
  max_concurrency: 3
  step:
    id: impl
    command: speckit.implement
```

### 扇入步驟

彙總扇出步驟的結果：

```yaml
- id: collect
  type: fan-in
  wait_for: [parallel-impl]
  output: {}
```

`wait_for` 參照已宣告的步驟 ID。對於扇出，請使用扇出步驟
自身的 `id`（上例的 `parallel-impl`）；其依序排列的項目結果可透過
`steps.<fan-out-id>.output.results` 取得。產生的項目別名，例如
`fan:template:0`，僅供回報使用，不是有效的 `wait_for` 目標。

## 錯誤處理

預設情況下，任何在執行期回傳 `StepResult(status=StepStatus.FAILED, ...)`
的步驟都會中止整個執行 — 最常見的是 `shell` 或
`command` 步驟以非零狀態結束。在
步驟上設定 `continue_on_error: true`，可記錄其結果並繼續到下一個同層步驟
，而不是中止。當失敗是來自非零結束時，結束代碼
仍可透過 `steps.<id>.output.exit_code` 取得，讓下游的
`if` 或 `switch` 能依此分支（或讓 `gate` 透過 `message` 中的 `{{ }}` 插值將它呈現給
操作者）：

```yaml
- id: heavy-thing
  type: command
  integration: claude
  command: speckit.heavy-thing
  continue_on_error: true

- id: check-result
  type: if
  condition: "{{ steps.heavy-thing.output.exit_code != 0 }}"
  then:
    - id: review
      type: gate
      message: "Step failed (exit {{ steps.heavy-thing.output.exit_code }}). Approve to run the recovery path, or reject to leave the failure recorded and move on."
      on_reject: skip
    - id: recover
      type: if
      condition: "{{ steps.review.output.choice == 'approve' }}"
      then:
        - id: rerun
          command: speckit.recovery
  else:
    - id: next-thing
      command: speckit.next-thing
```

關於這個例子，有幾點值得了解：

- 兩個關卡選項（`approve`、`reject`）都回傳 `StepStatus.COMPLETED`；
  `on_reject: skip` 只控制引擎是否在拒絕時中止
  （使用 `skip` 時不會中止）— 它**不會**自動略過 `then:` 清單中後續的
  同層步驟。下游分支是
  工作流程作者的責任：在後續的 `if`、`switch`
  或運算式中讀取 `{{ steps.<gate-id>.output.choice }}`，如上例的 `recover` 步驟所示。
- `on_reject` 有三個值：`abort`（預設 — 拒絕 → `StepStatus.FAILED`
  並帶有 `output.aborted = True`，中止執行）、`skip`（拒絕 →
  `StepStatus.COMPLETED`，由作者如上所示處理分支），以及 `retry`
  （拒絕 → `StepStatus.PAUSED`，讓下一次 `specify workflow resume` 重新執行
  該關卡）。
- 關卡不會自動重新執行失敗的步驟。要表達
  重試路徑，可以定義自訂關卡選項並在下游依
  選擇分支，或將失敗的步驟包在你自己的迴圈中。

**注意事項：**

- 這個欄位必須是字面布林值（`true`／`false`）；強制轉換的
  字串如 `"true"` 會在驗證時被拒絕。
- **範圍：僅限回傳的失敗。**這個旗標適用於
  `status=StepStatus.FAILED` 的步驟結果。從步驟的
  `execute()` 方法未處理而拋出的例外，會由上一層的 `WorkflowEngine.execute()` 捕捉，
  記錄為 `workflow_failed`，並且不論
  `continue_on_error` 為何都會中止執行。若步驟作者希望這個旗標涵蓋
  例外路徑，該步驟必須在內部捕捉例外，並
  回傳 `StepResult(status=StepStatus.FAILED, ...)`，將失敗編碼在
  `output` 中（例如 `exit_code`、`stderr` 或自訂欄位）。
- 關卡中止（操作者選擇了 `on_reject: abort`）永遠會中止
  執行 — `continue_on_error` 不會覆寫它們。這個旗標是
  用於暫時性／預期中的步驟失敗，而不是用來覆寫操作者深思熟慮的
  決定。
- 結構驗證會預先執行：`specify workflow run` 會在建立執行之前就拒絕
  無效的工作流程定義，因此
  驗證失敗永遠不會走到這條程式路徑。
- 當省略這個旗標時，行為與這個功能出現之前逐位元組相同。

## 運算式

工作流程定義使用 `{{ expression }}` 語法來表示動態值：

```yaml
# Access inputs
args: "{{ inputs.spec }}"

# Access previous step outputs
args: "{{ steps.specify.output.file }}"

# Comparisons
condition: "{{ steps.run-tests.output.exit_code != 0 }}"

# Filters
message: "{{ status | default('pending') }}"
ids: "{{ rows | split(',') | length }}"
```

支援的過濾器：`default`、`join`、`contains`、`map`、`from_json`、`to_json`、`upper`、`lower`、`split`、`length`。

新的過濾器會驗證其輸入類型，並拋出指明
問題的 `ValueError`，而不是強制轉換 — 因此 `upper`／`lower` 只接受字串，`split`
接受一個字串值與一個非空的字串分隔符，`length` 接受
清單與字串但拒絕對應，而 `to_json` 會拒絕它無法
序列化的內容：非有限浮點數（`NaN`、`Infinity`、`-Infinity`），這些值
否則會被序列化為不是有效 JSON 的符記；以及不是字串的對應鍵，
因為 JSON 物件無法承載這類鍵。以錯誤數量
的參數使用過濾器
（`| upper('x')`、`| split(',', 1)`、裸 `| split`）會被回報為已知
過濾器被誤用，這與
完全未知的過濾器名稱不同。較舊的過濾器較為
寬容且維持不變：`join` 會將不支援的值字串化，而
`map`／`contains` 會回傳後備值而不是拋出錯誤。請參閱
[ARCHITECTURE.md](ARCHITECTURE.md#expression-evaluation)，了解完整表格。

### 執行期脈絡

`{{ context.* }}` 公開了引擎為目前執行所管理的執行期中繼資料：

| 變數 | 說明 |
|----------|-------------|
| `context.run_id` | 目前的工作流程執行 ID（與 Spec Kit 在 `workflow run` 結束時印出的 `Run ID:` 相同的值）。自動產生的執行是來自 `uuid4` 的 8 字元十六進位值；操作者提供的 ID 可以是任何由英數字、連字號或底線組成的字串。在執行脈絡之外為空字串。 |
| `context.workflow_dir` | 包含工作流程來源檔案之目錄的已解析絕對路徑。對於從檔案載入的工作流程，這是 YAML 檔案的父目錄；對於依 ID 安裝的工作流程，這是安裝目錄的絕對路徑（例如 `<project>/.specify/workflows/<id>/`）；對於從字串載入的工作流程，這是空字串。續跑時，原始來源目錄會從第一次執行保留下來。 |

```yaml
# Stamp telemetry events with the run id for cross-system join.
- id: emit-event
  type: shell
  run: 'echo "{\"run_id\":\"{{ context.run_id }}\",\"event\":\"started\"}" >> events.jsonl'

# Per-run scratch directory.
- id: prep-scratch
  type: shell
  run: 'mkdir -p /tmp/run-{{ context.run_id }}'

# Pass run id into a command for artifact metadata.
- id: tag-artifact
  command: speckit.specify
  input:
    args: "{{ context.run_id }}"

# Reference a sibling file shipped alongside the workflow definition.
- id: apply-config
  type: shell
  run: 'cp "{{ context.workflow_dir }}/defaults.yml" ./config.yml'
```

## 輸入類型

工作流程輸入會進行類型檢查，並從 CLI 字串值強制轉換：

```yaml
inputs:
  spec:
    type: string
    required: true
    prompt: "Describe what you want to build"
  task_count:
    type: number
    default: 5
  dry_run:
    type: boolean
    default: false
  scope:
    type: string
    default: "full"
    enum: ["full", "backend-only", "frontend-only"]
```

| 類型 | 接受 | 範例 |
|------|---------|---------|
| `string` | 任何字串 | `"user-auth"` |
| `number` | 數字字串 → int/float | `"42"` → `42` |
| `boolean` | `true`/`1`/`yes` → `True`，`false`/`0`/`no` → `False` | `"true"` → `True` |

## 狀態與續跑

每次工作流程執行都會將狀態持久化到 `.specify/workflows/runs/<run_id>/`：

```bash
# List all runs with status
specify workflow status

# Check a specific run
specify workflow status <run_id>

# Resume a paused run (after approving a gate)
specify workflow resume <run_id>

# Resume a failed run (retries from the failed step)
specify workflow resume <run_id>
```

執行狀態：`created` → `running` → `completed` | `paused` | `failed` | `aborted`

## 型錄管理

工作流程是透過型錄被發現的。預設情況下，Spec Kit 使用官方與社群型錄：

> [!NOTE]
> 社群工作流程由其各自的作者獨立建立與維護。GitHub 與 Spec Kit 維護者可能會審查將項目加入社群型錄的 pull request，檢查格式與結構，但他們**不會審查、稽核、背書或支援工作流程定義本身**。安裝前請先審查工作流程來源，並自行斟酌使用。

```bash
# List active catalogs
specify workflow catalog list

# Add a custom catalog
specify workflow catalog add https://example.com/catalog.json --name my-org

# Remove a project catalog by its index in the priority-ordered list
specify workflow catalog remove <index>
```

無法以這種方式移除由環境提供的來源；請取消設定 `SPECKIT_WORKFLOW_CATALOG_URL` 來管理專案來源。

## 建立工作流程

1. 依上方的結構描述建立一個 `workflow.yml`
2. 以 `specify workflow run ./workflow.yml --input key=value` 在本機測試
3. 以 `specify workflow info ./workflow.yml` 驗證
4. 參閱 [PUBLISHING.md](PUBLISHING.md)，將它提交至型錄

## 環境變數

| 變數 | 說明 |
|----------|-------------|
| `SPECKIT_WORKFLOW_CATALOG_URL` | 覆寫型錄 URL（取代所有預設值） |
| `SPECKIT_WORKFLOW_DIR` | 為 shell 步驟自動設定；包含工作流程來源目錄的已解析絕對路徑（與 `{{ context.workflow_dir }}` 相同的值）。當工作流程沒有來源路徑時（從字串載入的工作流程）不會設定。 |

## 設定檔

| 檔案 | 範圍 | 說明 |
|------|-------|-------------|
| `.specify/workflow-catalogs.yml` | 專案 | 這個專案的自訂型錄堆疊 |
| `~/.specify/workflow-catalogs.yml` | 使用者 | 所有專案的自訂型錄堆疊 |

## 儲存庫佈局

```text
workflows/
├── ARCHITECTURE.md                         # Internal architecture documentation
├── PUBLISHING.md                           # Guide for submitting workflows to the catalog
├── README.md                               # This file
├── catalog.json                            # Official workflow catalog
├── catalog.community.json                  # Community workflow catalog
├── speckit/                                # Built-in SDD cycle workflow
│   └── workflow.yml
├── bugfix/                                 # Built-in bug-fixing pipeline
│   └── workflow.yml
└── assess/                                 # Built-in idea-assessment pipeline
    └── workflow.yml
```
