# Specify CLI 命令架構

本文件定義 Specify 命令的 CLI 配接器結構。它說明 Typer 處理常式、CLI 基礎設施、CLI 專屬階段、巢狀命令群組及其測試應置於何處。

每個具有其他交付配接器的 CLI 葉節點，都會呼叫由[共用命令應用架構](shared.md)定義的共用應用操作。本文件擁有 CLI 介面；它不重新定義語意驗證、協調、結果、警告、錯誤或副作用。

[巢狀命令群組](#巢狀命令群組)之下的擴充功能命令階層，提供了本文件使用的參考形狀。獨立的[擴充功能架構](extension.md)定義擴充功能領域的行為與邊界。不要僅為了讓小型命令在視覺上符合規範，就建立額外模組。

## 設計目標

CLI 結構應讓「這個命令位於何處？」的答案能從命令列本身預測。

本設計的優化方向為：

- **直接導覽**：命令對應到明顯的來源檔案與測試。
- **小型工作內容**：變更一個命令不應需要將整個命令群組載入記憶體。
- **平行開發**：不相關的命令很少需要編輯同一個檔案。
- **明確擁有權**：共用基礎設施與命令專屬行為不應混雜。
- **配接器紀律**：CLI 模組呼叫共用操作，而不是成為應用實作。
- **穩定行為**：結構重構必須保留註冊、輸出、錯誤處理、相容性路徑與測試。
- **代理開發**：程式代理應能從 CLI 介面推斷相關檔案，而不需要大範圍搜尋儲存庫。

## 命名與擁有權

### 已註冊的命令模組

每個真實的 CLI 命令使用：

```text
command_<name>.py
```

例如：

```text
specify extension add           -> extensions/command_add.py
specify extension set-priority  -> extensions/command_set_priority.py
specify extension update        -> extensions/command_update.py
```

只有表示實際 CLI 命令的模組才使用不帶底線的 `command_*.py` 前綴。命令模組擁有：

- 以 Typer 裝飾的處理常式。
- 面向使用者的引數與選項。
- 將解析後的值對應到共用操作請求。
- CLI 提示、進度、呈現、JSON 串流與結束代碼對應。
- 僅供該命令使用的小型輔助工具。

語意驗證、應用協調、型別結果、警告、預期錯誤與副作用，依[共用設計](shared.md)的定義，位於配接器之下。僅供 CLI 使用的命令可將小型行為保留在其命令模組中，但另一個配接器需要的行為，必須先移至共用操作或領域模組。

命令函式的 docstring 面向使用者，因為 Typer 可能將其顯示為說明文字。模組 docstring 則為內部用途，應標明命令、註冊路徑與任何相鄰的私有實作模組。

### 命令專屬實作模組

當 CLI 配接器具有內聚、*CLI 專屬*且可獨立理解或測試的階段時，使用：

```text
_command_<name>_<phase>.py
```

例如：

```text
command_init.py
_command_init_prompting.py
_command_init_rendering.py
```

開頭的底線將模組標記為私有實作。`command_init` 部分使其在搜尋與檔案列表中與已註冊的處理常式歸為一組。階段後綴傳達其擁有權。

私有階段模組不得註冊額外的 CLI 命令。公開的 `command_<name>.py` 模組仍是唯一的 CLI 配接器。

在以下情況下拆分命令的某個階段：

- 專屬於 CLI 呼叫或呈現。
- 具有不同的不變條件或失敗行為。
- 可作為有意義的邊界進行測試。
- 具有足夠的實作細節，會分散對 CLI 處理常式的注意力。
- 可能獨立於其他階段而變更。

若該階段執行語意驗證、規劃、變更、回滾，或另一個配接器需要的其他行為，則改用 `_operation_<name>_<phase>.py`，遵循[共用設計](shared.md#命名與版面)。

不要僅因命令超過任意行數就拆分它。過度碎片化會使控制流程更難追蹤，並增加代理必須檢查的檔案數量。

### 命令群組基礎設施

對於多命令群組，`_commands.py` 擁有：

- 命令群組的 Typer 應用程式。
- 群組命令模組的註冊。
- 確實由多個命令或外部 CLI 流程共用的 CLI 基礎設施。
- 為保留既定匯入或 monkeypatch 路徑所需的精簡相容性轉發器。

`_commands.py` 不得包含已裝飾的命令處理常式。僅供單一命令使用的輔助工具，應屬於該命令的模組或其某個私有階段模組。

相容性轉發器不會將擁有權轉回 `_commands.py`。它們應保持精簡，並委派給擁有該行為的模組。避免將 `_commands.py` 變成新程式碼的服務定位器。

### 套件 `__init__.py`

套件的 `__init__.py` 擁有套件的領域 API 與套件層級行為。它應提供 CLI 模組的簡短對照，但不是命令處理常式的所在地。

將命令處理常式移出 `__init__.py`，可使匯入領域套件與理解或修改其 CLI 介面分開。

## 巢狀命令群組

巢狀 CLI 群組使用與命令介面相符的目錄：

```text
specify extension catalog add
                          list
                          remove
```

對應到：

```text
extensions/
├── catalog/
│   ├── __init__.py
│   ├── _helpers.py
│   ├── command_add.py
│   ├── command_list.py
│   └── command_remove.py
├── command_add.py
├── command_list.py
└── ...
```

巢狀套件的 `__init__.py` 擁有其 Typer 應用程式與註冊。該巢狀介面的共用輔助工具可置於 `_helpers.py`。

當巢狀 CLI 階層的概念依賴父領域，但擁有父命令未涵蓋的獨特資源與生命週期時，它也可以是有界子領域的根。在這種情況下，將子領域的非命令模組與其 `command_*.py` 配接器一起保留在巢狀套件中。專屬於該資源的儲存、驗證、組合或散發行為，是該命名空間為領域根而非僅是 CLI 群組的訊號。

僅為了將命令分組而建立巢狀 CLI 套件，不會將同名的父領域行為轉移到該套件中。若既有領域模組只是與新的巢狀命令命名空間同名衝突，請將實作保留在父領域套件（或該處的聚焦領域模組）中。必要時，透過巢狀套件的精簡相容性匯出，保留既定的匯入路徑。

不要僅為了對稱而新增巢狀 `_commands.py`。只有當巢狀群組發展出龐大的共用命令基礎設施，無法再整齊地置於 `__init__.py` 與 `_helpers.py` 時，才建立它。

### 單數命令群組

即使面向使用者的 CLI 命名空間是單數，也使用儲存庫的複數命令套件慣例。因此 `specify self` 群組位於 `specify_cli/selfs/`，而既定的 `specify_cli._version` 模組仍是版本領域 API 與 monkeypatch 介面。命令配接器在執行時解析由 patch 擁有的 `_version` 屬性，`_version` 則為相容性重新匯出命令符號。

不要為不是 CLI 子命令的實作階段建立巢狀目錄。例如，`update/` 目錄會錯誤地暗示存在 `extension update ...` 子命令群組。CLI 專屬階段使用 `_command_update_<phase>.py`，語意驗證、規劃、變更、回滾或與另一個配接器共用的其他行為，則使用 `_operation_update_<phase>.py`。

## 註冊

命令註冊仍集中在命令群組邊界。

對於擴充功能群組：

1. `src/specify_cli/extensions/_commands.py` 擁有 `extension_app`。
2. `_commands.register()` 註冊巢狀的 catalog 群組。
3. 它匯入每個 `command_*.py` 模組，使其裝飾器註冊處理常式。
4. 它將 `extension_app` 附加到根應用程式。

巢狀的 catalog 群組透過 `catalog.register()` 遵循相同模式。

註冊匯入應明確且順序一致。不要依賴檔案系統探索來匯入任意模組，因為命令的公開方式應能在一處審查。

## 共用操作呼叫

CLI 配接器將解析後的引數與選項對應到共用的型別請求，呼叫操作，並呈現其結果。

對於專案範圍的命令，配接器提供明確的專案或目標目錄。當使用者省略它時，CLI 使用呼叫開始時擷取的 cwd。共用操作驗證並解析該路徑；兩層都不變更全行程 cwd。

CLI 以呼叫使用者的一般作業系統權限執行。它不建構共用政策或檔案系統執行階段。提示仍是 CLI 專屬的：

- `--json`、`--non-interactive` 與本機呼叫不表示 `force`。
- 外部來源信任與覆寫同意仍為明確的請求值。
- 提示可在建構或重試請求前收集同意，但配接器不會靜默新增同意。
- 網路與自我修改行為仍為操作與 CLI 合約所定義者。

## 測試結構

以命令為焦點的測試，對應 `tests/specify_cli/` 之下的來源命令介面。

例如：

```text
src/specify_cli/extensions/command_add.py
tests/specify_cli/extensions/test_command_add.py

src/specify_cli/extensions/catalog/command_add.py
tests/specify_cli/extensions/catalog/test_command_add.py
```

CLI 專屬階段使用：

```text
src/specify_cli/_command_init_prompting.py
tests/specify_cli/test_command_init_prompting.py
```

主要的 `test_command_<name>.py` 套件驗證公開的命令介面。階段專屬套件驗證詳細的不變條件，而不掩蓋主要的命令行為。

CLI 配接器測試驗證啟動目錄之外的明確目標，以及機器模式不新增 force、信任或破壞性同意的規則。

共用操作與階段測試使用 `test_operation_<name>.py` 與 `test_operation_<name>_<phase>.py`，如[共用測試結構](shared.md#測試結構)所定義。它們不會僅因 CLI 是其中一個呼叫端，就移至 `test_command_*.py` 之下。

領域來源保留在父套件的 `__init__.py` 或不帶 `command_` 前綴的聚焦領域模組中。其對應測試使用領域主體名稱，例如：

```text
src/specify_cli/integrations/__init__.py      # catalog domain API
tests/specify_cli/integrations/test_catalog.py

src/specify_cli/integrations/command_search.py
tests/specify_cli/integrations/test_command_search.py
```

不要僅因領域與該 CLI 命名空間同名，就將 `test_<domain>.py` 置於巢狀命令目錄之下。巢狀目錄保留給行使其實際子命令的 `test_command_<name>.py` 套件。

當領域實作拆分為私有模組時，在其測試中對應這些邊界，去掉來源模組開頭的底線：

| 預設集實作 | `tests/specify_cli/presets/` 之下的對應測試 |
| --- | --- |
| `_manifest.py` | `test_manifest.py` |
| `_registry.py` | `test_registry.py` |
| `_catalog.py` | `test_catalog.py` |
| `_resolver.py` | `test_resolver.py` |
| `_manager.py` | `test_manager.py` |
| `_manager_commands.py` | `test_manager_commands.py` |
| `_manager_skills.py` | `test_manager_skills.py` |

`test_manager_commands.py` 行使的是領域命令構件行為，而不是已註冊的 CLI 處理常式。`test_command_*.py` 套件繼續涵蓋 CLI 介面。`test_catalog.py` 屬於父層預設集套件層級；`catalog/test_command_*.py` 涵蓋巢狀的 catalog CLI。套件匯出相容性另外由 `test_domain_exports.py` 涵蓋。

並非每個測試都是命令測試，即使它屬於對應的套件樹：

- 領域模型、註冊表、管理員與型錄行為屬於父套件層級，而不是巢狀命令命名空間之下，也不在 `test_command_*.py` 中。既有的整合領域套件，例如 `tests/test_extensions.py`，可保留原位，直到另外重新組織。
- 跨領域 CLI 合約保留在更廣泛的整合測試中。
- 共用固定資料屬於能服務其所有消費者的最窄 `conftest.py`。
- 當命令與領域測試都依賴相同行為時，測試輔助工具應共用而非複製。

移動測試必須保留涵蓋範圍，而不是重複它。同時執行新的以命令為焦點的套件，以及測試被移出的舊套件。對於領域拆分，也執行所有新的領域套件與舊檔案中任何剩餘的跨領域測試。比較移動前後的完整套件收集結果：數量不得減少，且每個既有的參數化測試案例都必須仍有對應。僅總數相符並不能證明已保留。

## 參考版面

使用共用應用邊界的擴充功能命令群組形狀如下：

```text
src/specify_cli/extensions/
├── __init__.py
├── _commands.py
├── command_add.py
├── command_disable.py
├── command_enable.py
├── command_info.py
├── command_list.py
├── command_remove.py
├── command_search.py
├── command_set_priority.py
├── command_update.py
├── _operation_update.py
├── _operation_update_discovery.py
├── _operation_update_artifacts.py
├── _operation_update_transaction.py
└── catalog/
    ├── __init__.py
    ├── _helpers.py
    ├── command_add.py
    ├── command_list.py
    └── command_remove.py
```

更新命令說明了這個區別：

- `command_update.py` 是已註冊的 CLI 配接器。
- `_operation_update.py` 是共用應用進入點。
- `_operation_update_discovery.py` 決定可用的更新。
- `_operation_update_artifacts.py` 準備並驗證更新封存檔。
- `_operation_update_transaction.py` 擁有每個配接器的備份、安裝、回滾與清理行為。

## 決策指南

在決定程式碼應置於何處時：

| 問題 | 位置 |
|---|---|
| 它定義了真實的 CLI 命令嗎？ | `command_<name>.py` |
| 它是小型且僅供 CLI 使用的對應或呈現輔助工具嗎？ | 該命令模組 |
| 它是內聚且僅供 CLI 使用的階段嗎？ | `_command_<name>_<phase>.py` |
| 它定義了操作的語意驗證或協調嗎？ | 既有領域模組或 `_operation_<name>.py` |
| 它是內聚的共用操作階段嗎？ | `_operation_<name>_<phase>.py` |
| 它是由多個命令配接器共用的 CLI 基礎設施嗎？ | `_commands.py` 或聚焦的 CLI 輔助工具 |
| 它定義了巢狀 CLI 命名空間嗎？ | 與該命名空間相符的目錄 |
| 它僅由巢狀命名空間中的命令共用嗎？ | 巢狀套件的 `_helpers.py` |
| 它是獨立於 CLI 的領域行為嗎？ | 套件領域模組，而非命令模組 |

## 反模式

避免：

- 將已裝飾的處理常式加回 `_commands.py` 或套件 `__init__.py`。
- 將私有實作模組命名為 `command_*.py`。
- 建立與 CLI 命名空間不對應的巢狀目錄。
- 僅為了視覺對稱而建立 `_commands.py` 檔案。
- 當另一個配接器公開相同的邏輯操作時，將語意驗證、協調或副作用保留在 CLI 配接器中。
- 呼叫或解析另一個交付配接器，而不是呼叫共用操作。
- 過早將命令專屬輔助工具移入共用基礎設施。
- 複製固定資料或輔助工具，讓測試看起來更對應。
- 在沒有內聚階段邊界的情況下，將線性函式拆成許多檔案。
- 在未移轉其消費者或未保留精簡相容性轉發器的情況下，變更既定的 monkeypatch 或匯入路徑。

## 審查檢核清單

對於新增或重構的命令：

- [ ] CLI 路徑可預測地對應到 `command_<name>.py` 模組。
- [ ] 只有真實的命令模組註冊處理常式。
- [ ] 擁有階層為該 CLI 葉節點記錄恰好一個 MCP 清單處置，包括它無法使用或被排除的情況。
- [ ] 若另一個配接器公開該操作，CLI 配接器對應到 `design/shared.md` 定義的共用操作。
- [ ] 對於多配接器操作，語意驗證、協調與副作用位於 CLI 配接器之下。
- [ ] 當共用請求存在時，專案與目標目錄明確對應到其中。
- [ ] CLI 專屬階段模組使用 `_command_<name>_<phase>.py`；共用階段使用 `_operation_<name>_<phase>.py`。
- [ ] `_commands.py` 僅包含群組基礎設施與確實共用的 CLI 行為。
- [ ] 巢狀目錄對應真實的 CLI 命名空間。
- [ ] 命令測試對應來源結構。
- [ ] 領域與跨領域測試保留在其適當的套件中。
- [ ] 相容性路徑與面向使用者的說明維持不變，除非變更明確要求否則。
- [ ] 焦點測試、相關舊套件、程式碼檢查與完整測試套件皆通過。
