# 工作流程運算式

步驟可以使用 `{{ expression }}` 語法參照輸入與先前的步驟輸出：

| 命名空間                      | 說明                          |
| ------------------------------ | ------------------------------------ |
| `inputs.spec`                  | 工作流程輸入值                |
| `steps.specify.output.file`    | 先前步驟的輸出          |
| `item`                         | 扇出迭代中的目前項目  |
| `fan_in`                       | 扇入彙總脈絡 |
| `context.run_id`               | 目前工作流程執行 ID              |
| `context.workflow_dir`         | 工作流程來源目錄的解析後絕對路徑。對於以字串載入的工作流程為空白字串。 |

可用的篩選器：`default`、`join`、`contains`、`map`、`from_json`、`to_json`、`upper`、`lower`、`split`、`length`。

## 自訂篩選器（工作流程函式）

專案可以安裝 Python 可呼叫物件作為管線篩選器。關於套件與 CLI 的詳細資訊，請參閱[工作流程函式](functions.md)。

```yaml
# After installing a package that exports trim:
message: "{{ inputs.message | trim | upper }}"
```

函式會收到被傳入的值，其後接著明確的篩選器引數。資訊清單中的 `min_args` 與 `max_args` 界限會在運算式求值時強制執行。以 `{{ ... }}` 包裹的運算式中的篩選器名稱與引數數量，不會在工作流程驗證期間檢查。不帶括號的形式適用於最小值為零的函式；帶括號的呼叫包含一或多個引數。函式名稱與內建篩選器及其他已安裝套件共用一個扁平命名空間。衝突是錯誤，內建篩選器永遠不會被遮蔽。

函式套件包含可執行的 Python，會在工作流程驗證之前匯入。安裝之前，請先審查套件原始碼。處理常式應為無狀態且執行緒安全，因為扇出可能同時求值篩選器。函式失敗會走一般的運算式錯誤途徑，例外會以函式名稱為前綴；回傳值沿用既有的運算式取用規則，而非另外的函式專屬型別契約。與其他工作流程副作用相同，在續跑檢查點之前發生的中斷可能重複執行處理常式，因此續跑為至少一次。

## 語法

| 形式 | 範例 |
| --- | --- |
| 點路徑查詢 | `{{ inputs.name }}`, `{{ steps.test.output.exit_code }}` |
| 字面值 | 字串、數字、`true`、`false`、`none`／`null`，以及 `[1, 2]` 這類清單 |
| 比較 | `==`, `!=`, `>`, `<`, `>=`, `<=` |
| 布林邏輯 | `and`, `or`, `not` |
| 成員關係 | `in`, `not in` |
| 篩選器 | `{{ inputs.tags \| split(',') \| length }}` |

這是專用的運算式語言，並非完整的 Jinja2 或 Python。

## 篩選器

| 篩選器   | 範例                                    | 行為                                                                                        |
| -------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| `default`| `{{ val \| default('fb') }}`               | `None` 或空白字串時的備援值                                                                  |
| `join`   | `{{ list \| join(', ') }}`                 | 將清單元素連接成字串                                                                   |
| `contains`| `{{ text \| contains('sub') }}`           | 子字串或成員檢查                                                                      |
| `map`    | `{{ list \| map('attr') }}`                | 從每個項目擷取屬性                                                                |
| `from_json`| `{{ out \| from_json }}`                 | 將 JSON 字串解析為具型別的值                                                             |
| `to_json`| `{{ obj \| to_json }}`                     | 將值序列化為 JSON 字串，是 `from_json` 的反操作；對應鍵必須是字串 |
| `upper`  | `{{ text \| upper }}`                      | 將字串轉為大寫                                                                                 |
| `lower`  | `{{ text \| lower }}`                      | 將字串轉為小寫                                                                                 |
| `split`  | `{{ csv \| split(',') }}`                  | 依分隔符號將字串分割為字串清單                                               |
| `length` | `{{ items \| length }}`                    | 清單中的元素數量，或字串中的字元數                                            |

`default` 只對 `None` 與空白字串提供備援。其他 falsy 值（`0`、`false`、`[]`、`{}`）會原樣透傳，因此 `{{ count | default(10) }}` 對於零計數仍會產生 `0`。在此，falsy 不等同於空白。

關於較新篩選器的說明：

- **類型會被驗證，而非強制轉換。** `upper` 與 `lower` 只接受字串，`split` 要求字串值與非空白字串分隔符號兩者，`length` 接受清單與字串，但拒絕對應。其他任何情況都會引發指出問題的 `ValueError`。刻意不執行強制轉換：類型不符幾乎總是表示工作流程接到了錯誤的變數，而強制轉換的結果會掩蓋這一點。給予錯誤參數數量的篩選器（`| upper('x')`、沒有分隔符號的 `| split`、`| split(',', 1)`）會被回報為已知篩選器誤用，這與完全未知的篩選器名稱不同：帶有多個參數的呼叫會落入同樣的未支援形式錯誤，而非被求值為單一運算式。較舊的篩選器（`join`、`map`、`contains`）較為寬容且維持不變：`join` 會將不支援的值字串化，`map`／`contains` 會傳回備援值，而非引發錯誤。
- **`from_json` 拒絕非 JSON 的數字常數**。裸 `NaN`、`Infinity` 與 `-Infinity` 會引發指出 `from_json` 的 `ValueError`，包括出現在物件與陣列內部時。帶引號的字串，例如 `"NaN"`，仍是有效的 JSON 字串。
- **`to_json` 輸出是確定性的。**物件鍵會排序，非 ASCII 字元會原樣保留而非逸出，因此相同的值永遠會序列化為相同的位元組。這只帶來可重現性，並**不會**讓結果可以安全地通過 shell，因為[插值不會新增引號或逸出](#插值與-shell-安全性)。不要將不受約束的 JSON 插值到 `run` 欄位中。
- **`to_json` 會拒絕非有限浮點數。** `NaN`、`Infinity` 與 `-Infinity` 會引發指出 `to_json` 的 `ValueError`，而非序列化為裸權杖。三者都不是有效的 JSON，因此輸出它們會給符合標準的下游解析器一個它必須拒絕的字串。
- **`to_json` 要求字串對應鍵。** JSON 物件具有字串鍵，因此帶有任何其他鍵類型的對應（`{1: "a"}`、`{True: "a"}`）會引發指出鍵類型的 `ValueError`。若交給 `json.dumps`，整數鍵會被強制轉換為 `"1"`，並與既有的 `"1"` 鍵衝突，而混合鍵類型會使 `sort_keys` 以排序 `TypeError` 失敗，且只會被回報為「not JSON-serializable」。
- **比較篩選後的計數需要括號。** 篩選器鏈不能作為運算子的運算元，因此未加括號的尾隨比較（例如 `{{ inputs.items | length > 0 }}`）會引發「ambiguous filter precedence」`ValueError`。請將篩選後的運算元加上括號以比較其結果：`{{ (inputs.items | length) > 0 }}`。對於至少為二的閾值：

  ```yaml
  condition: "{{ (inputs.items | length) >= 2 }}"
  ```

  對於空白檢查，請直接使用篩選後計數的真值：

  ```yaml
  condition: "{{ inputs.items | length }}"   # 0 is False, any non-zero count is True
  ```

`and` 與 `or` 會傳回 `true` 或 `false`，且只在左側無法決定結果時才求值右側：左側為假時 `and` 會跳過它，左側為真時 `or` 會跳過它。因此，條件可以防護在空白值上會失敗的篩選器。`{{ inputs.payload != '' and (inputs.payload | from_json | length) }}` 對於空白的可選 `payload` 為假，而非因無效 JSON 使執行失敗。當右側被求值時，其錯誤仍會使執行失敗。

運算子的繫結從最鬆到最緊依序為 `or`、`and`、`not`，然後是比較。所有比較（`==`、`!=`、`>`、`<`、`>=`、`<=`、`in`、`not in`）共用同一個層級，並由左至右求值；沒有任何一個優先於另一個。因此 `{{ a == b > 0 }}` 表示 `{{ (a == b) > 0 }}`。若要組合比較，請使用括號或 `and`／`or`。

每個 `{{ }}` 區塊的主體都必須是有效的運算式。不是運算式的文字，例如散文（`{{ some text }}`）、包含字母、數字、`_` 與 `-` 以外字元的鍵（`{{ inputs.weird:key }}`），或算術（`{{ count + 1 }}`），都會引發指出違規權杖的 `ValueError`。數字可以寫成 `5`、`-5`、`+5`、`1_000`、`0.5`、`.5`、`5.` 或 `1.5e3`。

> **相容性：** 較早的發行版本在鍵存在時，可以解析諸如 `{{ inputs.weird:key }}` 的運算式；此運算式現在會在執行期失敗。請重新命名您控制的鍵（例如將 `weird:key` 改為 `weird_key`），並更新其參照。不支援加引號的鍵查詢。工作流程驗證可能無法在執行前偵測到這些運算式。

範例：

```yaml
condition: "{{ steps.test.output.exit_code == 0 }}"
args: "{{ inputs.spec }}"
message: "{{ status | default('pending') }}"
tag_count: "{{ inputs.tags | split(',') | length }}"
shell_flag: "{{ inputs.branch | upper }}"
```

## 插值與 shell 安全性

運算式透過**純字串取代**解析：`{{ ... }}` 的值會完全原樣拼接進周圍文字，不新增任何引號或逸出。這對於建構 `args` 與 `message` 字串很方便，但對 `shell` 步驟有重要後果：`run` 欄位會交給系統 shell（POSIX 上為 `/bin/sh -c`），因此任何插值的值都會被解譯為 **shell 語法**，而非僅僅是資料。

若插值的值可以包含 `;`、`|`、`&`、`$( )`、反引號或引號等字元，它可以變更或擴充實際執行的命令。當值不完全受工作流程作者控制時，這一點最重要：

- **工作流程 `inputs.*`**：由執行工作流程的人提供。
- **前一步驟的輸出**，例如 `{{ steps.plan.output.stdout }}`——對於 [`capture: true`](../workflow-steps/types.md#擷取命令與提示詞輸出) 的 `command` 或 `prompt` 步驟，這是**由 AI 代理產生的文字**，而代理讀取的檔案、工單或網頁內容又可能影響它。當代理輸出流入 `shell` 步驟時，請將其視為不受信任。

運算式語言中**沒有 shell 逸出篩選器**，`shell` 步驟周圍也**沒有沙箱**。請優先使用帶有 `env` 繫結的 [`strict: true`](../workflow-steps/types.md#shell-步驟)，讓動態值不進入 shell 原始碼。嚴格模式不會清理資料、檢查命令，也不會阻止撰寫的指令碼將資料解譯為程式碼。不要使用 `eval`，不要從變數建構另一個 `sh -c` 命令，也不要透過 `BASH_ENV` 等 shell 啟動變數傳遞不受信任的值。在 Windows 上，`cmd.exe` 對 `%VALUE%` 的展開可能引入 shell 語法；請改在程式內部讀取不受信任的值。在 POSIX 上，請為變數展開加上引號，並在適當時使用目標程式的參數驗證或 `--`，以防止選項注入。

為了相容性，當 `strict` 省略或為 `false` 時，原始插值仍保持啟用。其注入風險維持不變。請將您無法約束的值完全排除在 `run` 欄位之外。請仔細檢查每個插值了您不控制的值的非嚴格 `run` 欄位，至少做到：

- **在來源處以 `enum`／允許清單約束值。** 當 `inputs.*` 餵入非嚴格的 `run` 欄位時，請將其限制為一組固定的已知安全值，讓呼叫者根本無法提供任意的 shell 文字。

  ```yaml
  inputs:
    target:
      type: string
      enum: [staging, production]   # caller cannot inject arbitrary text
  ```

- **將不受約束的值排除在 `run` 之外。** 若某個值無法約束到允許清單（大多數代理／`prompt` 輸出），不要將其插值到 `run` 欄位中。請使用 `if`／`switch` 依固定條件對其分支，或在 `command`／`prompt` 步驟中對其操作，而非用它建構 shell 命令。
- **引號不是安全邊界。** 以引號包圍取代（`'{{ inputs.x }}'`）有助於 shell 將*受信任*的值視為單一參數，並避免空格造成的分詞，但值本身若包含相符的引號字元，仍可突破並注入 shell 語法。對於受約束的值，請為正確性加上引號；永遠不要依賴引號讓*不受約束*的取代變得安全。
- **關卡不會檢查下一個步驟，且 `message` 會逐字列印。** `gate` 步驟只呈現它自己的 `message`／`show_file`：它不會顯示、解析或清理其後的命令，核准也永遠不會中和可注入的插值。**不要**將原始不受信任的資料插值到 `message` 中：它會原樣列印，不去除控制字元，因此代理或呼叫者的輸出可能注入終端機／ANSI 逸出，變更或隱藏核准提示。請將 `message` 保持為受信任、受約束的文字，並改透過 `show_file` 呈現不受信任的材料供審查：其路徑與內容會在顯示前去除控制／ANSI 字元。

`shell` 步驟依設計就是任意命令的基礎建構元素；這些做法可以降低暴露，並讓*哪個*命令執行受作者控制，但它們無法消除插值您不完全控制的值所帶來的風險。

## 執行期脈絡

`{{ context.* }}` 公開了引擎為目前執行所管理的執行期中繼資料：

| 變數 | 說明 |
|----------|-------------|
| `context.run_id` | 目前的工作流程執行 ID（與 Spec Kit 在 `workflow run` 結束時印出的 `Run ID:` 相同的值）。自動產生的執行是來自 `uuid4` 的 8 字元十六進位值；操作者提供的 ID 可以是任何由英數字、連字號或底線組成的字串。在執行脈絡之外為空字串。 |
| `context.workflow_dir` | 包含工作流程來源檔案之目錄的已解析絕對路徑。對於從檔案載入的工作流程，這是 YAML 檔案的父目錄；對於依 ID 安裝的工作流程，這是安裝目錄的絕對路徑（例如 `<project>/.specify/workflows/<id>/`）；對於從字串載入的工作流程，這是空字串。續跑時，原始來源目錄會從第一次執行保留下來。 |

```yaml
# Stamp telemetry events with the run id for cross-system join.
- id: emit-event
  type: shell
  strict: true
  env:
    RUN_ID: "{{ context.run_id }}"
  run: 'printf ''{"run_id":"%s","event":"started"}\n'' "$RUN_ID" >> events.jsonl'

# Per-run scratch directory.
- id: prep-scratch
  type: shell
  strict: true
  env:
    RUN_ID: "{{ context.run_id }}"
  run: 'mkdir -p "/tmp/run-$RUN_ID"'

# Pass run id into a command for artifact metadata.
- id: tag-artifact
  command: speckit.specify
  input:
    args: "{{ context.run_id }}"

# Reference a sibling file shipped alongside the workflow definition.
- id: apply-config
  type: shell
  strict: true
  env:
    SOURCE_DIR: "{{ context.workflow_dir }}"
  run: 'cp "$SOURCE_DIR/defaults.yml" ./config.yml'
```

這些 shell 範例使用 POSIX 語法。對於可攜式指令碼，請在被呼叫的程式內部讀取環境。

## 具型別的值

單一運算式（單獨的 `{{ expr }}`）會直接回傳其值，不經字串轉換。混合範本（`prefix {{ expr }}`）會回傳文字；內嵌的 null 會變成空白文字。當結構化值必須跨越文字邊界時，請使用 `to_json`。

## 另請參閱

- [工作流程步驟參考](../workflow-steps/types.md)
- [Shell 步驟環境變數](../workflow-steps/types.md#shell-步驟環境變數)
- [Input types](api.md#輸入類型)
