# 工作流程步驟 CLI 參考

`specify workflow step` 群組管理已初始化 Spec Kit 專案中的自訂步驟套件與其型錄。內建類型隨 CLI 出貨，不需要另外安裝。

## 步驟管理

自訂步驟包含可執行的 Python。請在安裝與使用前審查其原始碼。套件合約請參閱[開發自訂步驟套件](developing.md#自訂步驟套件)。

```bash
specify workflow step list
specify workflow step search [query]
specify workflow step info <step_id>
specify workflow step info <step_id> --versions
```

`list` 顯示已安裝的自訂步驟類型；`search` 搜尋使用中的步驟型錄；`info` 顯示已安裝或型錄的中繼資料與來源。`--versions` 會列出勝出型錄的版本。

### 從本機目錄安裝

```bash
specify workflow step add my-step --dev /path/to/my-step
```

`--dev` 接受的是**目錄**（不是封存檔，也不是裸的 `step.yml`），且該目錄是完整的套件。這不需要型錄、伺服器或網路，因此是受支援的本地撰寫循環：

```bash
specify workflow step add my-step --dev ./my-step
specify workflow step list
specify workflow step info my-step
# edit ./my-step, then replace the installed copy:
specify workflow step add my-step --dev ./my-step --force
specify workflow step remove my-step
```

### 從封存檔 URL 安裝

```bash
specify workflow step add my-step --from https://example.com/my-step.zip
```

`--from` 接受 `.zip`、`.tar.gz` 或 `.tgz` 封存檔（裸的 `step.yml` URL **不是**套件）。封存檔可以將 `step.yml` 與 `__init__.py` 放在其根目錄，或恰好一個頂層目錄之下；無關的頂層同層項目會被拒絕。由於步驟套件包含可執行的 Python，直接 URL 安裝會在任何網路請求之前，顯示預設拒絕的信任確認；拒絕即取消，不發出請求，也不產生錯誤。需要 HTTPS（HTTP 僅允許用於 loopback 主機），重新導向必須保持安全，且下載有大小上限。

### 從型錄安裝

```bash
specify workflow step add my-step
```

型錄安裝會從作用中的步驟型錄解析個別檔案 URL，然後走與 `--dev` 和 `--from` 相同的驗證與提交路徑。僅供探索的型錄無法從中安裝。

若要將自訂步驟類型提交到僅供探索的社群型錄，請遵從
[社群工作流程步驟](../community/workflow-steps.md)。提交使用以標籤釘選的個別檔案 URL 與逐檔案摘要；維護者驗證的是中繼資料與發佈證據，而非提交的程式碼。

型錄歷史與確切版本選取，請參閱[步驟版本](catalogs.md#步驟發行版本)。

### 取代與強制

```bash
specify workflow step add my-step --dev ./my-step --force
specify workflow step add my-step --from https://example.com/my-step.zip --force
```

`--force` 會先暫存並驗證取代內容，然後才觸碰既有的安裝，且可以取代已註冊的安裝與殘留的未註冊目錄。驗證與暫存失敗會讓先前的套件保持不變。若移除舊目錄失敗，取代內容不會發佈。若在舊目錄已移除後，發佈取代內容或更新註冊表失敗，安裝可能處於不完整狀態：請使用原始來源與 `--force` 重新執行命令以重新安裝。不會嘗試自動復原。

### 列出、執行與移除

已安裝的自訂步驟會出現在 `specify workflow step list` 中，並由 `workflow add`、`workflow run` 與 `workflow resume` 自動載入。移除方式：

```bash
specify workflow step remove my-step
```

## 型錄管理

步驟型錄獨立於工作流程型錄。

### 列出型錄

```bash
specify workflow step catalog list
```

顯示所有使用中的步驟型錄來源。

### 新增型錄

```bash
specify workflow step catalog add <url> [--name <name>]
```

| 選項 | 說明 |
| --- | --- |
| `--name <name>` | 型錄的選用名稱 |

將自訂型錄 URL 加入專案的 `.specify/step-catalogs.yml`。
新條目允許安裝，優先順序排在既有條目之後。
只加入審查過的來源。請透過編輯型錄設定來設定僅供探索的來源。

以相同名稱重新加入相同的步驟型錄 URL 會成功，且不會變更設定；不同的名稱會被拒絕。

### 移除型錄

```bash
specify workflow step catalog remove <index>
```

依優先順序排列的 `catalog list` 中的索引移除專案型錄。由 `SPECKIT_STEP_CATALOG_URL` 提供的來源無法以此方式移除；請取消設定該變數以管理專案來源。

## 另請參閱

- [步驟總覽](overview.md)
- [內建步驟類型](types.md)
- [套件開發與驗證](developing.md)
- [Python API 參考](api.md)
- [型錄結構描述與信任](catalogs.md)
- [工作流程執行 CLI](../workflows/cli.md)
