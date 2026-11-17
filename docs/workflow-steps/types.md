# 內建工作流程步驟類型

步驟設定以 `type` 選取可執行行為。省略 `type` 會選取 `command`。步驟 ID 是本機運算式別名，不得包含 `:`，該字元保留給產生的發生 ID。

## 步驟類型

| 類型         | 用途                                          |
| ------------ | ------------------------------------------------ |
| `command`    | 叫用 Spec Kit 命令（例如 `speckit.plan`） |
| `prompt`     | 將任意提示詞傳送給 AI 程式代理  |
| `shell`      | 執行 shell 命令並擷取輸出       |
| `github`     | 為明確的議題或提取請求新增標籤       |
| `init`       | 引導專案（類似 `specify init`）        |
| `slot`       | 具名工作流程槽位；未填入時跳過       |
| `gate`       | 在繼續前暫停，等待人工核准       |
| `if`         | 條件分支（then/else）                |
| `switch`     | 依運算式進行多分支分派           |
| `while`      | 在條件為真時迴圈                   |
| `do-while`   | 至少執行一次，然後依條件迴圈    |
| `fan-out`    | 為清單中的每個項目分派一個步驟          |
| `fan-in`     | 彙總扇出步驟的結果            |
| `workflow`   | 以私有輸入與宣告的輸出呼叫已安裝的工作流程 |

## 命令步驟（預設）

透過整合 CLI 以名稱呼叫已安裝的 Spec Kit 命令：

```yaml
- id: specify
  command: speckit.specify
  input:
    args: "{{ inputs.spec }}"
  integration: claude        # Optional: override workflow default
  model: "claude-sonnet-4-20250514"   # Optional: override model
  reasoning_effort: "high"   # Optional: requires integration support
```

位置參數與具名的執行期選項，請參閱[每個步驟的整合設定](#每個步驟的整合設定)。
關於 `reasoning_effort` 與 `context_size`，請參閱[推理強度與上下文大小](#推理強度與上下文大小)。

## 提示步驟

將任意的內嵌提示詞傳送給整合 CLI（不需要命令檔案）：

```yaml
- id: security-review
  type: prompt
  prompt: "Review {{ inputs.file }} for security vulnerabilities"
  integration: claude
```

## 擷取命令與提示詞輸出

`command` 與 `prompt` 步驟會將整合 CLI 的輸出串流到終端機，因此 `steps.<id>.output.stdout` 與 `steps.<id>.output.stderr` 是空白字串。設定 `capture: true` 可改將該輸出保留在步驟結果中，供後續步驟讀取：

```yaml
- id: verdict
  type: prompt
  prompt: "Reply with exactly READY or BLOCKED for {{ inputs.spec }}"
  capture: true
  capture_max_bytes: 4096   # Optional: per-stream limit (default 1048576)
  timeout: 120              # Optional: seconds before the CLI is killed

- id: branch
  type: if
  condition: "{{ steps.verdict.output.stdout | contains('READY') }}"
  then:
    - id: plan
      command: speckit.plan
```

| 欄位               | 適用於          | 意義                                                                                             |
| ------------------- | ------------------- | --------------------------------------------------------------------------------------------------- |
| `capture`           | `command`, `prompt` | `true` 會擷取標準輸出與標準錯誤，而非串流它們。必須是字面布林值；預設為 `false`。 |
| `capture_max_bytes` | `command`, `prompt` | 每個擷取串流的上限：正整數，或 `-1` 表示無上限。預設為 `1048576`（1 MiB）。需要 `capture: true`。 |
| `timeout`           | `command`, `prompt` | CLI 被終止前的秒數；搭配 `capture: true` 時，其行程群組（POSIX）或作業物件（Windows）會被終止，其中包括它啟動的行程，除非它們已與其分離，如常駐輔助程式可以做到的。對於 `command`，它只在搭配 `capture: true` 時套用（預設 `600`）；串流的 `command` 步驟沒有逾時。對於 `prompt`，它一律套用（預設 `300`）。 |

被擷取的步驟在執行時不會列印任何內容。其輸出會新增這些欄位：

| 輸出欄位       | 意義                                                                    |
| ------------------ | -------------------------------------------------------------------------- |
| `stdout`, `stderr` | 擷取的文字。                                                         |
| `stdout_truncated` | 當標準輸出超過 `capture_max_bytes` 且其餘被捨棄時為 `true`。 |
| `stderr_truncated` | 標準錯誤同理。                                                       |
| `timed_out`        | 當 CLI 及其行程在 `timeout` 時被終止時為 `true`；`exit_code` 為 `-1`。 |
| `interrupted`      | 當執行被中斷（Ctrl+C）時為 `true`；`exit_code` 為 `130`。        |

**文字內容。** 擷取要求的是整合 CLI 的一般文字輸出，也就是串流步驟列印的相同輸出。它不是結構化格式：它可以包含進度或工具使用行以及最終答案，在不同整合之間有所差異，且只有在代理只列印 JSON 時才是有效的 JSON。

**上限與編碼。** `capture_max_bytes` 在解碼前計算每個串流的原始位元組。超過上限的位元組會被讀取並捨棄，因此 CLI 永遠不會被阻塞，且對應的 `*_truncated` 欄位會被設定。輸出以 UTF-8 解碼：無效的位元組會變成 U+FFFD，而被上限、逾時或中斷切開的字元會被捨棄，而非被取代。行尾會正規化為 `\n`。

搭配 `capture_max_bytes: -1` 時，不會捨棄任何內容，且兩個 `*_truncated` 欄位都保持 `false`。整個輸出隨後會保存在記憶體中，並寫入執行狀態，因此列印大量內容的代理會讓兩者無上限增長。只在您確定輸出很小時使用它。

**在使用輸出前檢查完整性。** 諸如 `from_json` 的篩選器不會查看這些欄位；它們會解析其中的任何文字。當 `stdout_truncated` 為 `true` 時，輸出不完整，當 `timed_out` 或 `interrupted` 為 `true` 時也是：被停止的 CLI 即使沒有大小上限，也會留下部分輸出。請防護其使用：

```yaml
- id: parse
  type: if
  condition: "{{ steps.verdict.output.exit_code == 0 and not steps.verdict.output.stdout_truncated }}"
  then:
    - id: use
      type: shell
      run: "echo parsed"
```

**失敗。** 非零結束、逾時或中斷會使步驟失敗，並將擷取的內容保留在 `output.stdout` 與 `output.stderr` 中。步驟的錯誤是簡短摘要（`Command exited with code 2`、
`Prompt timed out after 120 seconds.`），永遠不是擷取的文字。失敗的步驟會停止執行，因此當後續步驟需要檢查失敗時，請在擷取步驟上設定 `continue_on_error: true`：

```yaml
- id: verdict
  type: prompt
  prompt: "Reply with exactly READY or BLOCKED"
  capture: true
  timeout: 120
  continue_on_error: true

- id: on-timeout
  type: if
  condition: "{{ steps.verdict.output.timed_out }}"
  then:
    - id: review
      type: gate
      message: "The verdict step timed out. Approve to continue without it."
```

> ⚠️ **擷取的輸出以純文字儲存，且不會遮罩。** 它會
> 寫入該次執行的 `state.json`，以便 `specify workflow resume` 可以重播
> 它，且在執行後仍保留在那裡。代理列印的任何內容，包括
> 它從檔案或環境讀取的秘密，都會被保存。擷取的文字
> 不會列印到終端機，也不會寫入 `log.jsonl`。除非執行
> 目錄受到相應保護，否則不要在輸出可能包含憑證的步驟上啟用
> 擷取。

擷取的文字是代理輸出，因此不受信任；
在 `shell` 步驟中使用之前，請先參閱[內插與 shell 安全性](../workflows/expressions.md#插值與-shell-安全性)。

## 每個步驟的整合設定

命令步驟可以將結構化的執行期設定傳遞給支援它的整合：

```yaml
- id: implement-with-docker-agent
  type: command
  command: speckit.implement
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

`integration_args` 是有序的字串清單。`integration_options` 是以字串為鍵的對應。兩個欄位中的值都會透過工作流程運算式機制解析，並由所選整合驗證；不支援、未知或格式錯誤的值會以可操作的錯誤失敗。Docker Agent 使用其唯一的 positional 參數作為代理設定參照，並接受 `agent` 與 `safety` 作為具名整合選項。請透過命令步驟的頂層 `model` 欄位設定其模型。

當 Docker Agent `integration_args` 為命令步驟提供代理參照時，它優先於 `SPECKIT_INTEGRATION_DOCKER_AGENT_EXTRA_ARGS`；該步驟會完全忽略整個舊環境值。沒有逐步驟代理參照時，舊環境行為不變。

解析後的執行期設定會記錄在工作流程執行狀態中。當失敗或暫停的命令被繼續時，完整的分派設定會從目前輸入重新解析，因此以 `workflow resume --input` 提供的值會一致地生效。沒有更新輸入的繼續會重現相同的值。

命令步驟的 `options` 對應會與 `workflow.options` 合併，並記錄為 `steps.<id>.output.options`，
但不會傳給整合 CLI。若要變更呼叫，請使用 `integration_args`、`integration_options`、`model`，
或[`reasoning_effort` 與 `context_size`](#推理強度與上下文大小)。

## 推理強度與上下文大小

`command` 與 `prompt` 步驟可以為它們呼叫的整合 CLI 設定 `reasoning_effort` 與 `context_size`。`workflow.reasoning_effort` 與 `workflow.context_size` 會為兩種步驟類型設定預設值：

```yaml
workflow:
  id: plan-and-review
  name: Plan and review
  reasoning_effort: "medium"   # Default for command and prompt steps

inputs:
  review_effort:
    type: string
    default: ""                # Empty: the review step sends no effort

steps:
  - id: plan
    command: speckit.plan
    integration: codex         # Codex takes context_size as a token count
    reasoning_effort: "high"   # Overrides the workflow default
    context_size: "200000"     # Quoted: values are strings

  - id: review
    type: prompt
    prompt: "Review the plan for gaps"
    reasoning_effort: "{{ inputs.review_effort }}"
```

**解析**。每個設定解析時如同 `model`：先取步驟的值，再取工作流程預設值，再取未設定。步驟值與預設值都可以是運算式。缺少、`null` 或 `""` 的步驟值會繼承預設值。解析為 `""` 或 null 的運算式會取消該步驟的設定，不會退回預設值；這就是步驟退出預設值的方式。在範例中，`review` 除非執行時提供 `--input review_effort=<value>`，否則不會傳送推理強度。

**值**。值是字串。請將 YAML 讀為布林值的數字與單字加上引號，例如 `on`、`off`、`yes` 與 `no`：寫 `context_size: "200000"`，而非 `context_size: 200000`。運算式也必須解析為字串，因此請從以 `type: string`（而非 `type: number`）宣告的輸入讀取數字。值必須是 1 到 64 個字母、數字、`.`、`_` 或 `-`，以字母或數字開頭。字面值會在工作流程驗證時檢查，運算式結果則在步驟執行時檢查。關於格式錯誤值的錯誤只會回報其類型與長度，不會回報其文字。Spec Kit 會將值原樣傳給整合。其意義與可接受的值由整合的 CLI 定義，整合可以在 CLI 執行前拒絕某個值。

**支援**。整合只有在宣告支援某個設定時才會翻譯它。否則步驟會在 CLI 執行前失敗，錯誤會指明該設定、其來源（步驟或工作流程預設值），以及支援它的整合。工作流程預設值並無豁免：預設值會讓每個繼承它的步驟失敗，若其整合不支援該設定。以下內建整合支援這些設定：

| 整合 | `reasoning_effort` | `context_size` |
| --- | --- | --- |
| [GitHub Copilot](../integrations/copilot.md#工作流程分派設定) | 是 | 是 |
| [Codex CLI](../integrations/codex.md#工作流程分派設定) | 是 | 是 |
| [Claude Code](../integrations/claude.md#工作流程分派設定) | 是 | 否 |

其他內建整合兩個設定都不支援。各整合的指南說明其 CLI 參數與可接受的值；整合如何選擇加入，請參閱[工作流程 CLI 派送](../integrations/cli.md#工作流程-cli-分派)。

**CLI 拒絕**。當 CLI 拒絕某個值並以非零代碼結束時，步驟會像其他 CLI 失敗一樣失敗。
步驟錯誤會回報結束代碼，CLI 的訊息會出現在終端機上，或在 `output.stderr` 中，搭配 [`capture: true`](#擷取命令與提示詞輸出)。

**記錄與繼續執行**。解析後的值會記錄在 `steps.<id>.output.reasoning_effort` 與 `steps.<id>.output.context_size`，
未設定時為 `null`。當 `specify workflow resume` 重新執行步驟時，會從目前的輸入再次解析兩者，
因此以 `--input` 提供的值會生效。

**額外參數**。支援這些設定的整合會在 `SPECKIT_INTEGRATION_<KEY>_EXTRA_ARGS` 的參數之後加上它們的旗標。若兩者設定相同的 CLI 旗標，由 CLI 決定哪個值勝出，因此每個旗標只在一個地方設定。

**相容性**。沒有此功能的 Spec Kit 版本會忽略這些欄位，
包含工作流程預設值，並在沒有它們的情況下執行步驟。
`requires.speckit_version` 無法阻止這一點：它僅供參考，不會被強制執行。

## Shell 步驟

`type: shell` 會透過平台 shell 執行 `run`，保留對管線、重新導向與多個命令的支援。設定 `strict: true` 可拒絕 `run` 中任何位置的 `{{` 運算式標記，包括引號內部。這會在驗證期間與執行前立即檢查。`strict` 必須是布林值；省略或 `false` 會保留既有的原始插值行為。

使用 `env` 對應將動態值繫結，而不將其插入 shell 原始碼。例如，在 POSIX 上：

```yaml
- id: display-result
  type: shell
  strict: true
  env:
    RESULT: "{{ steps.plan.output.stdout }}"
  run: 'printf "%s\n" "$RESULT"'
```

對於跨平台指令稿，請在程式本身讀取環境，例如 Python 中的 `os.environ["RESULT"]`。請參閱
[Shell 步驟環境變數](#shell-步驟環境變數)，了解繫結合約，以及
[內插與 shell 安全性](../workflows/expressions.md#插值與-shell-安全性)，了解其餘的信任邊界。

> **安全注意：** `shell` 步驟會以**您**的權限執行本地命令。沒有能力沙箱：`requires` 是建議性的前置條件區塊（spec-kit 版本、整合），而非執行期關卡，因此它**不會**限制步驟可以做什麼。特別是，不存在 `requires.permissions` 能力關卡：它會在驗證時被拒絕，正是因為它會暗示一個不存在的沙箱。在執行任何型錄或下載的工作流程之前，請先審查它，並使用 `gate` 步驟，在敏感或破壞性的 shell 命令之前要求明確核准。

Shell `timeout` 必須是正數，預設為 `300` 秒。逾時會終止命令並讓步驟失敗。Shell 輸出會被擷取以供後續運算式使用。

設定 `output_format: json` 可將 stdout 解析為具類型的 `output.data`。無效的 JSON（包含裸寫的 `NaN`、`Infinity` 與 `-Infinity` 常數）會讓步驟失敗，同時保留 `stdout`、`stderr` 與 `exit_code`。加引號的字串（例如 `"NaN"`）仍為有效。若無 `output_format`，stdout 仍為原始文字，且沒有 `data` 欄位。

## Shell 步驟環境變數

Shell 步驟會自動接收以下環境變數：

| 變數 | 說明 |
| -------- | ----------- |
| `SPECKIT_WORKFLOW_DIR` | 工作流程來源目錄的解析後絕對路徑（與 `{{ context.workflow_dir }}` 相同的值）。當工作流程沒有來源路徑時不會設定。 |

在嚴格與非嚴格模式下，都可以使用可選的逐步驟 `env` 對應。名稱必須符合 `[A-Za-z_][A-Za-z0-9_]*`；名稱是字面的，不是運算式。值必須是字串，且可以包含工作流程運算式。每個值只會求值一次，且必須解析為不含 NUL 字元的字串。在 POSIX 上，該字串還必須能使用檔案系統編碼及其錯誤處理常式，為行程環境編碼。無效的繫結會在啟動行程之前使步驟失敗。

單一運算式繫結會保留運算式的結果類型：`COUNT: "{{ inputs.count }}"` 會拒絕數字、布林值、null、清單或對應，而非將其轉換為文字。混合範本使用標準運算式插值：`COUNT: "n={{ inputs.count }}"` 對於整數 `42` 會產生 `n=42`；嵌入的 null 會變成空白文字，其他值則使用其字串表示。若要明確序列化結構化資料，請使用 `to_json`。

繫結只會覆寫該子行程的繼承環境值；它們不會修改父行程或後續步驟。空白字串是有效的。`SPECKIT_WORKFLOW_DIR` 是保留字（不區分大小寫），無法被覆寫。請讓環境名稱與可執行檔載入設定受工作流程作者控制：環境繫結是資料通道，不是沙箱。

### 審查 shell 執行

在安裝或執行不熟悉的工作流程之前，請稽核每個 shell 步驟的 `run` **與** `env`，包括巢狀分支與扇出範本。請審查參照的指令碼與資源、被呼叫的工作流程，以及可以取代或插入步驟的作用中覆疊 YAML。請將同樣的審查套用到套件組的工作流程元件，並在定義、覆疊或參照的程式碼變更時重複審查。自訂步驟套件需要其自身的原始碼審查，因為載入它們會執行 Python 程式碼。

環境值可以控制執行，而非僅僅提供資料。例如，`PATH` 會選取可執行檔，`PYTHONPATH` 會影響 Python 匯入，`BASH_ENV` 可以選取 Bash 啟動程式碼，`NODE_OPTIONS` 可以變更 Node.js 啟動行為。原生載入器與其他程式有其自身的設定；這些範例並非詳盡清單。因此，即使使用 `strict: true` 且沒有 `eval`，固定的 `run` 仍可能執行不同的程式碼。嚴格模式既不會篩選控制執行的繫結，也不會清理繼承的環境。請讓那些設定保持字面且經作者審查，或將動態值約束到一組已核准的受信任路徑／選項。只將不受約束的輸入或代理輸出用於其取用者會將其視為資料的應用程式資料變數。

當 shell 步驟呼叫 Specify 本身時，`SPECKIT_WORKFLOW_CATALOG_URL` 等型錄覆寫也可能改變子命令探索或安裝元件的位置。請一併審查這些繫結與[使用中的型錄來源](../overview/catalogs.md#探索與信任)。

工作流程驗證檢查的是設定，而非環境設定或命令是否安全。`specify workflow info` 會顯示中繼資料與步驟身分；`specify workflow resolve` 會顯示圖層與步驟歸屬。兩者都不會顯示完整的 `run`／`env` 設定，也無法取代閱讀貢獻來源檔案。型錄安裝權限、套件組安裝與嚴格模式都不是安全背書。

## GitHub 步驟

`type: github` 使用已安裝的 `gh` CLI 及其作用中的驗證。請將 GitHub 儲存庫指定為 `owner/repo`；不需要 Git 遠端或原始碼檢出。請求會傳送到該儲存庫的 GitHub `api.github.com` REST 端點。作用中的權杖需要具備讀取議題或提取請求，以及寫入其標籤的權限（例如在 Actions 中使用 `GITHUB_TOKEN` 時，議題需要 `issues: write`，提取請求需要 `pull-requests: write`）。此步驟只使用既有的權杖：它不會要求或提升權限。它不會檢查議題內容以尋找指示，也不會做出維護者決策。

```yaml
- id: mark-ready
  type: github
  operation: add-label
  repository: owner/repo
  target: issue
  number: "{{ inputs.issue_number }}"
  label: ready-for-review
```

`target` 為 `issue` 或 `pull_request`；`number` 必須解析為正整數。`label` 是一個明確的標籤名稱（最多 50 個字元），且必須已存在於儲存庫中。`repository`、`number` 與 `label` 可以使用工作流程運算式。儲存庫必須解析為單一的 `owner/repo` 名稱，而非 URL 或 Git 遠端。此步驟會檢查目標類型與其既有標籤，當標籤已存在時跳過寫入，並在新增後驗證 GitHub 的回應。
輸出包含 `repository`、`target`、`number`、`label` 與 `added`（只有在新增標籤時才為 `true`）。重複執行與扇出項目可以安全重試：已存在的標籤會保持不變。此第一版不會張貼留言、還原成品、檢出提取請求，也不會推斷維護者會選擇哪個標籤。

## 初始化步驟

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

## 工作流程插槽

宣告一個具名的工作流程插槽，讓下游專案可以用
工作流程覆蓋層來填入。未填入時插槽會被略過；它的 `id` 是覆蓋層
錨點，`name` 是必填的易讀標籤：

```yaml
- id: post-implement
  type: slot
  name: "Post-implementation checks"
```

請參閱[工作流程位置](../workflows/overlays.md#工作流程槽位上游擴充點)，
了解填補位置、保留其輸出與扇出限制。

## 關卡步驟

在互動式終端機上提示人工審查，或暫停以便日後以 `specify workflow resume` 繼續。判定輸入可以在不提示的情況下決定：

```yaml
- id: review-spec
  type: gate
  message: "Review the generated spec before planning."
  options: [approve, edit, reject]
  on_reject: abort
```

## 關卡判定輸入

`verdict_input` 會將關卡的判定繫結到具名的工作流程輸入。該輸入必須在工作流程的 `inputs` 區塊中宣告；`add` 或 `run` 期間的工作流程驗證會回報未宣告的參照。

不支援在 `fan-out` 範本內使用 `verdict_input`。扇出項目共用工作流程輸入，而工作流程狀態只能表示一個已暫停的關卡。請將關卡放在扇出之前以核准整個批次，或放在扇入之後以審查彙總結果。

**輸入值語意：**

| 值 | 行為 |
|---|---|
| 非空白字串，與選項相符（不區分大小寫） | 關卡自動決策；`output.choice` 會設定為設定的選項拼寫 |
| 非空白字串，無相符 | 關卡立即失敗 |
| 非字串 | 關卡立即失敗 |
| 缺失或空白 | 關卡在 TTY 上提示；否則暫停 |

**預設值語意：** 非空白的 `default` 會在第一次執行時被取用為判定：與選項相符會自動決策關卡，不相符則立即使其失敗。

```yaml
inputs:
  spec_verdict:
    type: string
    default: ""
steps:
  - id: review-spec
    type: gate
    message: "Approve the specification?"
    options: [approve, reject]
    on_reject: retry
    verdict_input: spec_verdict
```

繼續時提供判定：

```bash
specify workflow resume <run_id> --input spec_verdict=approve
```

對於 `on_reject: retry`，已繫結的拒絕判定會在關卡暫停之前被取用：具名的已儲存輸入會重設為 `""`。因此，後續的繼續會再次提示或暫停，直到提供另一個判定為止。核准、中止與跳過結果會讓輸入保持不變。

由於該重設，使用 `on_reject: retry` 的判定輸入必須接受 `""`。若它宣告了 `enum`，請包含空白字串，否則重設值會違反輸入自身的 `enum`，且該次執行再也無法以任何輸入繼續。`specify workflow add` 會將此回報為驗證錯誤。

```yaml
inputs:
  spec_verdict:
    type: string
    enum: ["", approve, reject]
    default: ""
```

## If/Then/Else 步驟

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

## 切換步驟

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

## While 迴圈步驟

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

## Do-While 迴圈步驟

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

## 扇出步驟

為集合中的每個項目派送步驟範本。預設的 `max_concurrency: 1` 為循序執行；較高的值會同時執行項目，具備獨立的項目上下文與有序的結果：

```yaml
- id: parallel-impl
  type: fan-out
  items: "{{ steps.tasks.output.task_list }}"
  max_concurrency: 3
  step:
    id: impl
    command: speckit.implement
```

## 扇入步驟

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

## 工作流程組合

`workflow` 步驟會在目前專案中，以同一次執行的私有範圍，執行已安裝、已啟用的工作流程。目標可以是字面 ID 或運算式；解析後的字串必須與 ID 精確相符，包括大小寫與空白。

```yaml
inputs:
  target: {type: string, required: true}
  report: {type: string, required: true}
steps:
  - id: investigate
    type: workflow
    workflow: "{{ inputs.target }}"
    input:
      report: "{{ inputs.report }}"
```

被包含的工作流程只能看到透過 `input` 傳入的宣告輸入，以及其自身的步驟結果。它不會繼承呼叫者的 `inputs`、步驟結果、扇出 `item`／`fan_in` 值，或工作流程預設值。未知的輸入名稱、缺失的必填值，以及無效的類型／列舉都會使呼叫失敗。既有的子預設值與 `integration: auto` 解析會套用。值只能透過明確宣告傳回：

```yaml
outputs:
  report:
    value: "{{ steps.analyze.output.stdout }}"
```

呼叫者讀取 `{{ steps.investigate.output.report }}`。輸出包含
`workflow` 與 `status`；失敗在失敗操作有回報時包含 `error`，中止則包含 `aborted: true`。這些名稱，以及
`integration`、`model`、`options` 與 `input` 都是保留字。傳回的值
必須是 JSON 安全的。私有輸入、步驟記錄與日誌不屬於
傳回值的一部分。不會建立獨立的子執行。

工作流程呼叫上的 `continue_on_error: true` 會處理傳回的子失敗
與呼叫邊界合約失敗，例如目標不可用、無效的
對應輸入、循環、深度限制，或無效的宣告輸出。它不會攔截
步驟例外、運算式錯誤（包括 `input:` 或
`outputs:` 中的 `from_json` 錯誤）、中斷或檢查點失敗；這些會如同在根層級一樣精確傳播。不可用的步驟實作在步驟發生處即為終止；在工作流程呼叫處則是回報的子失敗，無論是在繫結目標時偵測到，還是之後才偵測到。暫停與明確中止一律停止執行。

允許巢狀組合，但在作用中呼叫路徑上重複的工作流程 ID 屬於循環。菱形結構是允許的。包含的最大深度為 16，根位於深度零。

## 呼叫子關卡

只有根宣告的輸入可以提供給 `workflow resume --input`。當子關卡將根輸入用作
`verdict_input` 時，請透過每個工作流程邊界對應該根輸入：

```yaml
# Parent workflow
inputs:
  approval:
    type: string
    default: ""
steps:
  - id: review-release
    type: workflow
    workflow: release-notes
    input:
      approval: "{{ inputs.approval }}"
```

```yaml
# Installed release-notes workflow
inputs:
  approval:
    type: string
    default: ""
steps:
  - id: review
    type: gate
    message: "Approve the release notes?"
    options: [approve, reject]
    verdict_input: approval
```

若 `approval` 為空，初始執行會暫停。其結構化狀態會以 `gate.scope_path` 識別巢狀關卡及其外層呼叫。請繼續根執行，而非子執行，以繼續它：

```bash
specify workflow status <run-id> --json
specify workflow resume <run-id> --input approval=approve
```

不支援在扇出項目內使用帶有 `verdict_input` 的關卡，包括透過一或多個工作流程呼叫的情況。`inside_fan_out` 執行期條件會跨工作流程邊界保留。

## 呼叫邊界的預設值與錯誤

父層的 `integration`、`model`、`options`、`reasoning_effort` 與 `context_size` 預設值僅適用於父層工作流程中的步驟。子層使用自己的預設值或自動解析。若要讓某個值為兩者共用，請將它宣告為子層輸入並明確對應。呼叫結果刻意具有空的 `input` 欄位，不會暴露子層的私人輸入、步驟記錄或日誌。

初始繫結或輸出定案的合約失敗可以使用
`continue_on_error` 處理。在
`workflow resume --input` 期間重新繫結未完成呼叫時的失敗則不同：它會傳播。對於先前已繫結的呼叫，繼續會捨棄先前的 `result`、`outcome` 與 `error`，同時保留其繫結與子樹，以便以修正的根輸入重試。初始繫結失敗的呼叫會回到 `ready`，並重試目標解析與繫結。

## 另請參閱

- [工作流程步驟總覽](overview.md)
- [工作流程 YAML 與執行語意](../workflows/api.md)
- [運算式](../workflows/expressions.md)
- [覆蓋層與工作流程位置](../workflows/overlays.md)
- [開發自訂步驟套件](developing.md#自訂步驟套件)
- [步驟管理 CLI](cli.md#步驟管理)
