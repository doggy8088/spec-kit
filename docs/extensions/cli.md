# 擴充功能 CLI 參考

使用 `specify extension` 管理擴充功能的完整參考。所有擴充功能命令都需要先以 `specify init` 初始化專案。

## 搜尋可用的擴充功能

```bash
specify extension search [query]
```

| 選項 | 說明 |
| ------------ | ------------------------------------ |
| `--tag`      | 依標籤篩選                        |
| `--author`   | 依作者篩選                     |
| `--verified` | 只顯示已驗證的擴充功能        |

搜尋所有啟用中的型錄，找出符合查詢的擴充功能。沒有查詢時，列出所有可用的擴充功能。

## 安裝擴充功能

```bash
specify extension add <name>
specify extension add --from <url>
specify extension add --dev <path>
```

| 選項 | 說明 |
| --------------- | -------------------------------------------------------- |
| `--dev`         | 從本機目錄安裝（供開發使用）         |
| `--from <url>`  | 從自訂 URL 安裝，而非型錄         |
| `--version <v>` | 安裝型錄公告的精確版本        |
| `--force`       | 若擴充功能已安裝則覆寫，並覆寫已修改或非擁有的[技能資源](developing.md#skill-resources)副本（對於 `generic`，只會取代先前已記錄的資源） |
| `--priority <N>`| 解析優先順序（預設：10；數字越小優先程度越高） |

從型錄、URL 或本機目錄安裝擴充功能。擴充功能命令會向啟用中的 AI 程式代理整合註冊。對於 `generic`，呼叫使用設定的 `--commands-dir`：預設為平面命令檔案，或以 `--skills` 使用 `speckit-<name>/SKILL.md`；`extension add --force` 會取代未變更的自有呼叫與先前已記錄的技能資源，但拒絕取代 `--commands-dir` 中已編輯的呼叫或非擁有檔案。

型錄安裝時位置名稱為必填，`--dev` 需要本機路徑。使用 `--from` 時可以省略位置名稱；下載的資訊清單會提供已安裝的擴充功能 ID。

若 generic 整合重新整理無法產生每個擴充功能呼叫（例如因為命令或技能被使用者修改，或其來源遺失），它會發出警告並還原該擴充功能先前註冊的成品。其他擴充功能仍可重新整理。

未指定版本的型錄安裝仍會選取所宣傳的目前版本。`--version` 只使用該擴充功能 ID 的勝出型錄來源；當請求的版本不存在時，不會退回較低優先順序的來源。僅供探索的型錄仍不可安裝。`--version` 不能與 `--dev` 或直接 URL 的 `--from` 選項併用。對於 `--version` 型錄安裝，安裝前會將下載封存檔的擴充功能 ID 與版本與請求的型錄 ID 與版本進行比對。未指定版本的型錄安裝與直接 `--from` 安裝會驗證資訊清單，但不會將其 ID 或版本與預期的型錄值比對。

## 移除擴充功能

```bash
specify extension remove <name>
```

| 選項 | 說明 |
| --------------- | ---------------------------------------------- |
| `--keep-config` | 移除期間保留設定檔案    |
| `--force`       | 略過確認提示                       |

移除已安裝的擴充功能。設定檔案預設會備份；使用 `--keep-config` 將它們保留原處，或使用 `--force` 略過確認。

## 列出已安裝的擴充功能

```bash
specify extension list
specify extension list --json
```

| 選項 | 說明 |
| ------------- | -------------------------------------------------- |
| `--available` | 顯示已安裝的擴充功能與安裝提示；不會查詢型錄 |
| `--all`       | 與 `--available` 目前的行為相同              |
| `--json`      | 以 JSON 寫入已安裝的擴充功能                 |

列出已安裝的擴充功能，包含其狀態、版本與命令數量。

請使用 `specify extension search` 來探索啟用型錄中的擴充功能。

`--json` 將 JSON 陣列寫入 stdout。每個項目都有鍵 `id`、`name`、`description`、`version`、`author`、`priority`、`enabled`、`source` 與 `provides`。`author` 在缺席時為 `null`；`source` 對於本機、舊版或格式錯誤的來源為 `{"kind":"local"}`，對於有效的型錄來源為 `{"kind":"catalog","catalog":"<catalog-name>"}`。擴充功能的 `provides` 包含 `commands`、`templates`、`scripts` 與 `hooks` 數量。`--available` 與 `--all` 不會將 JSON 輸出擴展到已安裝擴充功能之外。成功時，`--json` 恰好將一個陣列寫入 stdout 並以 0 結束。在選項解析後的執行時期失敗，會恰好將一個 `{"error":"..."}` 物件寫入 stderr 並以 1 結束。若解析引發使用錯誤且原始 `--json` 權杖存在，它會將該 JSON 錯誤物件寫入 stderr 並保留使用結束代碼（通常為 2）。沒有 `--json` 時，包括說明，現有的人類可讀行為不變。

## 擴充功能資訊

```bash
specify extension info <name>
specify extension info <name> --versions
specify extension info <name> --json
```

顯示已安裝或可用擴充功能的詳細資訊，包括其說明、版本、命令與設定。`--versions` 列出勝出型錄來源公告的目前與歷史版本；它會將僅供探索的來源標為不可安裝。等價的 PEP 440 版本拼寫（例如 `v1.0` 與 `1.0`）選取同一個版本；型錄公告的拼寫仍保持可見。

宣傳舊版本所用的型錄格式與套件組釘選行為，請參閱[歷史版本](catalogs.md#歷史發行版本)。

`--json` 描述一個已安裝的擴充功能，並將單一 JSON 物件寫入 stdout。`<name>` 的比對方式與沒有 `--json` 時相同：先是擴充功能 ID，然後是唯一的顯示名稱，不分大小寫。此物件具有與對應的 `specify extension list --json` 項目相同的 `id`、`name`、`description`、`version`、`author`、`priority`、`enabled` 與 `source` 鍵。它以 `commands`、`templates`、`scripts` 與 `hooks` 陣列取代 `provides` 數量。Command、template 與 script 項目有 `name`、`description`（缺席時為 `""`）、`source`（`{"layer": "extension", "extensionId": "<id>"}`，即提供它的擴充功能；最上層的 `source` 是它安裝的來源）與 `sourcePath`（資訊清單的 `file`，相對於擴充功能目錄）；script 項目在資訊清單宣告時還會有 `runtimes`。擴充功能項目不帶 `strategy`，因為擴充功能提供的檔案永遠取代。每個 hook 項目有 `trigger`（hook 事件，例如 `after_tasks`）、`targetCommand`、`optional`（預設 `true`）與 `priority`（預設 `10`）。當某個事件多次宣告相同命令時，最後一個宣告勝出，如同 hook 被註冊時一樣。`--json` 不能與 `--versions` 組合（使用錯誤，結束代碼 2）。未安裝的擴充功能、含糊的名稱或遺失的專案，會將一個 `{"error":"..."}` 物件寫入 stderr 並以 1 結束；使用錯誤保留其結束代碼（通常為 2），與 `list --json` 相同。

## 更新擴充功能

```bash
specify extension update [<name>]
```

更新特定擴充功能，或在未給定名稱時更新所有已安裝的擴充功能。

隨附的擴充功能（例如 `agent-context` 與 `git`）沒有下載 URL；它們的更新從執行中的 spec-kit 版本隨附的副本安裝。當型錄公告的版本比你的 spec-kit 版本隨附的更新時，更新會被回報為需要先升級 spec-kit。

對於 `generic`，失敗的更新會從先前設定的 `--commands-dir` 位置以及目前位置，還原依雜湊擁有的呼叫，即使另一個整合現在已啟用也一樣。

## 啟用／停用擴充功能

```bash
specify extension enable <name>
specify extension disable <name>
```

停用擴充功能而不移除它。已停用的擴充功能會排除在登錄檔驅動的成品解析與未來的整合註冊之外，其宣告式掛鉤會在 `.specify/extensions.yml` 中標記為停用。這些狀態變更後，會盡力重新整理原生執行時期事件設定。若重新整理失敗，命令會發出警告，但過時的原生掛鉤可能仍保持啟用並可執行。請以 `specify integration upgrade <key>` 重試受影響整合的重新整理。

非通用整合可以保留仍可呼叫的已產生命令或技能檔案，直到整合切換、解除安裝或協調將它們移除為止。停用並非通用的執行阻擋。僅有掛鉤的擴充功能即使在通用命令輸出設定缺少或無效的情況下，仍可安裝、啟用與停用；有命令的擴充功能仍需要有效的設定。請以 `enable` 重新啟用。

對於 `generic`，停用會移除依雜湊擁有的呼叫，即使輸出目錄已移動也一樣，但會保留新目錄中無關的同名檔案。

## 設定擴充功能優先順序

```bash
specify extension set-priority <name> <priority>
```

變更擴充功能的成品解析優先順序。對於貢獻的成品（例如範本與指令稿），較小的數字優先；相同時依擴充功能 ID 排序。安裝時會拒絕與已安裝擴充功能完全相同的命令名稱或別名衝突，以及與核心命令正規化輸出名稱的衝突。優先順序不允許安裝重複的命令名稱。

## 型錄管理

擴充功能型錄決定 `search` 與 `add` 搜尋擴充功能的位置。型錄會依優先順序檢查（數字越小，優先順序越高）。

僅供探索的型錄可以搜尋，但無法從中安裝。只有你擁有並審查過的來源，才啟用安裝。在安裝第三方擴充功能之前，請參閱[型錄信任模型](catalogs.md#信任模型僅供探索與安裝來源)。

### 列出型錄

```bash
specify extension catalog list
```

顯示堆疊中所有啟用中的型錄，包含其優先順序與安裝權限。

### 新增型錄

```bash
specify extension catalog add <url>
```

| 選項 | 說明 |
| ------------------------------------ | -------------------------------------------------- |
| `--name <name>`                      | 必要。型錄的唯一名稱              |
| `--priority <N>`                     | 優先順序（預設：10；數字越小優先程度越高）  |
| `--install-allowed / --no-install-allowed` | 將型錄標為受信任的安裝來源。只對你擁有並審查的型錄啟用；對於僅供探索的來源保持關閉（預設）。絕不對未經審查的公開型錄啟用。 |
| `--description <text>`               | 選用的說明                               |

將型錄新增到專案的 `.specify/extension-catalogs.yml`。

以相同設定重新新增同名型錄會成功，且不變更設定；不同的設定會被拒絕。

### 移除型錄

```bash
specify extension catalog remove <name>
```

從專案設定中移除型錄。

## 另請參閱

- [擴充功能使用者指南](overview.md)
- [擴充功能型錄](catalogs.md)
- [擴充功能 API 參考](api.md)
- [開發擴充功能](developing.md)
- [發佈擴充功能](publishing.md)
- [社群擴充功能](../community/extensions.md)
