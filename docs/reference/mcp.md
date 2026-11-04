# MCP 伺服器

> [!WARNING]
> `specify mcp` 為實驗性功能。其命令清單與工具合約在 MCP 介面宣告穩定前可能變更。

```bash
specify mcp
```

透過 **stdio 專用**方式啟動 Model Context Protocol 伺服器。此命令不提供 HTTP、SSE、daemon／服務管理或傳輸選擇選項。請設定 MCP 主機，將 `specify mcp` 作為本機子行程啟動。

由於 stdout 承載 MCP 通訊協定訊框，伺服器不會在該處列印 Spec Kit 橫幅、Rich 輸出、啟動訊息、警告或記錄。

## 工具

伺服器公開具型別輸入與結果的一級工具。全部皆為唯讀、僅限本機（不存取網路），並拒絕未預期的參數。

| 工具 | 用途 |
| --- | --- |
| `specify_version` | 回傳已安裝的 CLI 版本、執行環境、系統與功能能力。不接受任何參數。 |
| `specify_artifact_list` | 回傳專案成品清單的一個分頁頁面（`command`、`template`、`script`、`hook`） |
| `specify_artifact_info` | 回傳單一成品及其完整的組成堆疊 |
| `specify_workflow_list` | 依登錄順序列出已安裝的工作流程與被跳過項目的警告 |

成品工具接受選用的絕對路徑 `project_directory`；預設為伺服器啟動時所在的目錄。

`specify_artifact_list` 還接受 `limit`（1-1000，預設 100）與 `cursor`。其結果包含 `rows`、`next_cursor` 與 `truncated`；當 `truncated` 為 true 時，將 `next_cursor` 作為 `cursor` 傳入以取得下一頁。

`specify_artifact_info` 接受 `identifier`（裸名稱或 `kind:name`）與選用的 `kind`（`command`、`template`、`script` 或 `hook`）。

`specify artifact lookup` 無法透過 MCP 使用：它尚無共用的具型別操作，因此未註冊 `specify_artifact_lookup` 工具。

另外還註冊了三個通用工具，且僅支援以點號表示的命令 `version`；其他所有命令名稱都會以 `unavailable_command` 工具錯誤拒絕。

| 工具 | 用途 |
| --- | --- |
| `specify_list_commands` | 列出通用工具支援的 CLI 命令 |
| `specify_describe_command` | 描述一個受支援的以點號表示的 CLI 命令 |
| `specify_run_command` | 透過真正的 Specify CLI 執行一個受支援的命令 |

伺服器不公開變更、安裝或更新操作、工作流程執行、確認或存取層級。

## 已安裝工作流程清單

`specify_workflow_list` 接受選用的絕對路徑 `project_directory`（預設：伺服器啟動目錄）與 `limit`（1–1000，預設 100）。它只讀取已安裝的工作流程登錄；絕不載入自訂步驟、取得型錄、修復檔案或執行工作流程。

結果包含依序排列的 `items` 與布林值 `truncated`。工作流程項目包含 `kind: "workflow"`、`id`、`name`、`version`、可為 null 的 `description` 與 `enabled`。格式錯誤的個別登錄項目會產生 `kind: "warning"` 項目，包含 `code: "invalid_registry_entry"`、`workflow_id` 與 `message`，並位於其原始位置。limit 同時計算工作流程與警告。`truncated: true` 明確表示有項目被省略；將 `limit` 調高以取得更多，最多 1000。沒有接續游標。CLI 保留其完整清單。

遺失的登錄檔案會產生空清單。損毀或無法讀取的登錄檔案會產生 `workflow_registry_read_failed`；不安全的儲存會產生 `unsafe_workflow_storage`。其他預期錯誤為 `invalid_project_directory` 與 `not_a_spec_kit_project`。錯誤在 `error` 之下包含 `code`、`message`、`details` 與 `retryable`，並有 `isError: true`。未預期的失敗使用已清理的 `internal_error`；無效的操作結果使用 `invalid_operation_result`。超過 1 MiB 的回應會產生可重試的 `response_too_large` 錯誤，而非部分成功；請以較小的 limit 重試。登錄例外詳細資訊不會透過 MCP 公開。

超出範圍的 `limit` 值會在操作執行前被拒絕，並產生僅含文字的輸入驗證錯誤，無結構化內容；請參見[輸入驗證錯誤](#input-validation-errors)。

工作流程清單透過所選專案的 `FileHelper` 原則擁有者讀取登錄內容，在讀取邊界拒絕 Windows junction 與不支援的 reparse point。一般的工作流程登錄符號連結仍不允許。其他工作流程登錄呼叫者不會被此工具遷移。這些檢查不提供作業系統沙箱或無競爭條件的檔案系統隔離；在套用項目限制前，登錄仍會完整解析。

超出所請求項目限制的操作結果，或聲稱截斷卻未填滿該限制的結果，會以 `invalid_operation_result` 拒絕。輸出結構描述也將 `items` 上限設為 1000。

## 輸入驗證錯誤

一級工具在執行前，會依其輸入結構描述驗證參數。未預期的參數、超出範圍的 `limit`、格式錯誤的 `cursor` 或不支援的 `kind`，會以僅含文字的 MCP 工具錯誤拒絕，無結構化內容，因此使用者端無法從中讀取 `error.code`。

## 版本工具結果與錯誤

`specify_version` 直接回傳結果物件。若操作失敗，它會回傳 MCP 工具錯誤，其結構化內容包含 `error.code`（`invalid_operation_result` 或 `internal_error`）、`error.message` 與 `error.details`。

## 成品結果與錯誤

成品工具以結構化內容回傳其結果。操作失敗為 MCP 工具錯誤，其結構化內容包含 `error.code`、`error.message`、`error.details` 與 `error.retryable`。兩個成品工具都可能回傳 `invalid_project_directory`、`not_a_spec_kit_project`、`artifact_resolution_failed`、`invalid_operation_result` 與 `internal_error`。`specify_artifact_info` 還可能回傳 `invalid_artifact_identifier`、`unknown_artifact`、`unknown_hook` 與 `ambiguous_artifact`。大於 1 MiB 的結果會回傳可重試的 `response_too_large` 錯誤；對於清單工具，請以較小的 `limit` 重試。

## 通用工具結果與錯誤

`specify_run_command` 在隔離的子行程中呼叫下方的標準命令，使用與執行中 CLI 相同的 Python 環境：

```bash
specify version --json
```

成功時，MCP 工具回傳該命令的直接 JSON 物件，包含 `cli_version`、`runtime`、`system` 與 `features`。它不會將結果包裝在通用的 `schema_version`、`ok` 或 `result` 欄位中。

CLI 失敗時，轉接器會取用 stderr 中的結構化 JSON 錯誤，並回傳包含 `error.code`、`error.message` 與 `error.details` 的 MCP 工具錯誤。空的、格式錯誤的、混合的或非 JSON 的子行程輸出會回報為已清理的 `adapter_internal_error`；伺服器絕不以成功形狀的備援結果替代，也絕不公開追蹤資訊。
