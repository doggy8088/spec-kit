# 發佈工作流程

發佈附版本的工作流程套件，讓其他專案可以安裝相同的定義與附屬檔案。工作流程型錄提交與自訂工作流程步驟提交使用不同的途徑；請勿將兩者混為一談。

## 準備發行版本

分享工作流程之前，請提供：

- 有效的 `workflow.yml`，具備唯一的 ID、描述性名稱，以及以引號括住的 `X.Y.Z` 版本。
- 說明流程、輸入、步驟圖、所需整合、工具、憑證、輸出、失敗行為與副作用的 README。
- 開源授權，以及最好附上變更日誌。
- 在真實專案上執行工作流程的證據，包括相關的拒絕、失敗與續跑途徑。

使用聚焦的步驟、描述性的輸入提示、有意義的審查關卡，以及固定選項的列舉。請說明任何破壞性操作、憑證存取、網路呼叫與提升的權限。宣告的 `requires` 值用於記錄期望；它們不會強制權限或沙箱化執行。

關於套件版面配置與完整的內建範例，請參閱撰寫指南。在發行之前，請先測試本機定義：

```bash
specify workflow run ./workflow.yml --input spec="Build a kanban board"
specify workflow status <run_id>
specify workflow resume <run_id>
```

`run` 會先驗證再執行工作流程。它不是試運行。請在可拋棄的專案中測試可能產生變更的範例。

## 打包與標記

請從與 `workflow.version` 相符的版本標籤發佈：

```bash
git tag v1.0.0
git push origin v1.0.0
```

對於單一檔案的工作流程，釘選標籤的原始 URL 就已足夠：

```text
https://raw.githubusercontent.com/your-org/my-workflow/v1.0.0/workflow.yml
```

若定義需要指令碼或其他資源，請將完整套件發佈為 `.zip`、`.tar.gz` 或 `.tgz`。封存檔必須在根目錄、或單一最上層目錄內包含 `workflow.yml`。原始 YAML 下載不包含儲存庫中的相鄰檔案。請透過 `context.workflow_dir` 或 `SPECKIT_WORKFLOW_DIR` 參照已打包的資源。

請使用釘選的發行版本 URL，而非分支 URL 或 `releases/latest`。請為可下載的內容計算並發佈 SHA-256 摘要，尤其是在宣傳歷史發行版本時。

## 測試已發佈的成品

審查發行版本的原始碼後，請在已初始化的測試專案中安裝完全相同的已發佈成品：

```bash
specify workflow add my-workflow \
  --from https://raw.githubusercontent.com/your-org/my-workflow/v1.0.0/workflow.yml
specify workflow info my-workflow
specify workflow run my-workflow --input spec="Build a kanban board"
```

對於含有隨附檔案的套件，請改用附版本的封存檔 URL。請實際演練關卡與續跑，而不只是安裝。`info` 會顯示中繼資料、輸入與步驟；它不會顯示所有 shell 命令，也無法證明安全性。

## 提交工作流程型錄項目

工作流程項目目前透過編輯 [`workflows/catalog.community.json`](https://github.com/github/spec-kit/blob/main/workflows/catalog.community.json) 的提取請求提交。目前沒有工作流程定義提交用的議題表單。另外的 Workflow Step Type Submission 表單適用於可執行的自訂步驟套件。

請複刻儲存庫，並在 `workflows` 對應之下新增工作流程，依工作流程 ID 的字母順序排序。例如：

```json
{
  "schema_version": "1.0",
  "workflows": {
    "my-workflow": {
      "id": "my-workflow",
      "name": "My Workflow",
      "description": "A repeatable review process",
      "author": "Example Team",
      "version": "1.0.0",
      "url": "https://raw.githubusercontent.com/your-org/my-workflow/v1.0.0/workflow.yml",
      "sha256": "<64 hexadecimal digits for the published artifact>",
      "repository": "https://github.com/your-org/my-workflow",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=1.0.0"
      },
      "tags": ["review", "automation"],
      "created_at": "2026-11-03T00:00:00Z",
      "updated_at": "2026-11-03T00:00:00Z"
    }
  }
}
```

請將範例中繼資料、相容性需求、URL 與摘要，替換為此發行版本的真實值。請保持 `requires` 與定義一致。目前的發行版本保留在最上層；歷史版本請依型錄參考所述使用 `releases`。

請提交一份聚焦的型錄 PR，其中包含：

- 工作流程 ID、名稱、版本、儲存庫與授權。
- 釘選的下載 URL 與摘要。
- README 與步驟圖連結、所需整合與副作用。
- 安裝與端對端測試證據，包括關卡與續跑行為。

維護者只檢查型錄項目的格式與完整性。這**不是**針對工作流程定義、指令碼或相依性的安全性審查。型錄接受並不代表背書、支援承諾，或程式碼已受稽核的證據。使用者必須在安裝與使用之前自行審查原始碼。

社群型錄預設僅供探索。接受後，工作流程可透過 `specify workflow search` 被探索到，但不會依 ID 自動可安裝。在審查發行版本之後，請明確安裝其釘選的 URL，或使用您信任並允許安裝的另外設定的型錄。

## 發行版本更新

1. 更新 `workflow.version`、文件與變更日誌。
2. 測試變更後的定義，包括適用的失敗與續跑途徑。
3. 發佈新的標籤與附版本的成品；測試從該 URL 安裝。
4. 提交型錄 PR，更新目前的 `version`、`url`、摘要與發行版本專屬的需求。保留已宣傳的歷史發行版本。

更新工作流程、自訂步驟、覆疊或參照的指令碼時，請重複進行原始碼審查。套件安裝與摘要驗證只能確定安裝了哪些位元組，無法確定這些位元組是否安全。

## 另請參閱

- [Developing workflows](developing.md)
- [Workflow catalogs](catalogs.md)
- [Installation CLI](cli.md#安裝工作流程)
- [Shell 執行審查](../workflow-steps/types.md#審查-shell-執行)
- [運算式插值與 shell 安全性](expressions.md#插值與-shell-安全性)
- [Community workflows](../community/workflows.md)
- [發佈自訂工作流程步驟](../workflow-steps/publishing.md)
