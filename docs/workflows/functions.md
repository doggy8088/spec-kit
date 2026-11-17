# 工作流程函式

工作流程函式是專案安裝的 Python 可呼叫物件，以管線篩選器的形式公開於工作流程運算式中。它們安裝於 `.specify/workflows/functions/<id>/` 之下，由一份 `function.yml` 資訊清單與一個 `__init__.py` 模組組成。

## 安裝與管理函式

```bash
specify workflow function add text --dev ./workflow-functions/text
specify workflow function list
specify workflow function list --json
specify workflow function remove text
```

也可以從封存檔 URL 安裝套件：

```bash
specify workflow function add text --from https://example.test/text.zip
```

`--dev` 與 `--from` 恰須擇一指定。`--force` 會取代具有相同套件 ID 的現有套件；它無法取代屬於另一個套件的函式匯出。

安裝遵循與自訂步驟套件相同的規則：檔案會經過驗證，再透過私有的暫存目錄複製；符號連結與不支援的檔案類型會被拒絕，`.git`、`__pycache__` 與 `.DS_Store` 不會被複製；一個套件最多可包含 512 個項目、50 MiB 與 32 層目錄。`--from` 安裝會在發出任何請求之前，先顯示帶有該 URL 的不受信任來源提示，解析 GitHub 發行版本資產 URL，並要求 URL、最終 URL 與 `Content-Type` 在封存檔格式上一致。

`remove` 會在與安裝相同的專案鎖定之下，刪除套件目錄及其登錄項目。沒有登錄項目的目錄會在發出警告後移除；若目錄無法刪除，登錄項目會被還原。

`list` 只讀取已保存的登錄資料。它不會匯入套件程式碼，並會回報每個匯出的通用使用形式。手動複製到 `.specify/workflows/functions/` 的套件會在工作流程執行時載入，但因為沒有登錄項目，所以不會列出。

## 資訊清單

```yaml
id: text
name: Text helpers
version: 1.0.0
description: Small text transformations.
functions:
  - name: trim
    handler: trim
    min_args: 0
    max_args: 0
    description: Remove surrounding whitespace.
```

套件 ID 採用與自訂工作流程步驟相同的安全路徑元件驗證。匯出名稱是小寫識別字（`a-z`、`0-9` 與 `_`），且在套件內必須唯一。`min_args` 與 `max_args` 是整數，須符合 `0 <= min_args <= max_args <= 16`；它們計算被傳入值之後的引數。預設值皆為零。只有當 `min_args` 為零時，才接受不帶括號的篩選器形式。帶括號的呼叫必須包含至少一個引數，且須在宣告的範圍內。

處理常式會以 `handler(value, *args)` 的形式呼叫。例如：

```python

def trim(value):
    return value.strip()


def surround(value, left, right):
    return f"{left}{value}{right}"
```

```yaml
- id: normalize
  type: shell
  strict: true
  env:
    VALUE: "{{ inputs.value | trim }}"
  run: 'printf "%s\\n" "$VALUE"'
```

## 載入與信任

安裝會驗證並複製套件檔案，但不會匯入它們。執行、續跑、新增或更新工作流程時，會在工作流程驗證之前載入已安裝的函式模組。載入會執行 Python 程式碼，因此請審查套件，只從您信任的來源安裝。封存檔下載適用與其他可執行工作流程套件相同的 HTTPS 與 loopback HTTP 限制。

函式名稱與內建篩選器及其他已安裝的篩選器共用一個扁平命名空間。若名稱是內建篩選器，或已由另一個套件提供，安裝會拒絕該名稱——無論該套件是在登錄資料中，還是僅存在於磁碟上（此時錯誤會指出「found on disk, not in the registry」）。若套件是手動複製的，或新的 Spec Kit 版本引入了衝突的內建篩選器，執行期載入也會在發生衝突時失敗，並列出每個衝突的函式與兩個來源。衝突檢查發生在匯入任何套件程式碼之前。內建篩選器永遠不會被取代。若函式目錄本身無法讀取，命令會回報錯誤並以代碼 1 結束（使用 `--json` 時為失敗的酬載）。資訊清單無效或無法讀取、或模組匯入失敗的套件會被跳過，因此其篩選器稍後可能會被回報為未知。

篩選器登錄在工作流程載入期間是行程全域的。重新載入專案會取代前一個專案的自訂篩選器。函式處理常式必須是無狀態且執行緒安全的，因為扇出步驟可能同時求值運算式。與其他工作流程副作用相同，在續跑檢查點之前發生的中斷可能導致操作再次執行；續跑提供至少一次、而非恰好一次的執行保證。

自訂回傳值沿用既有的運算式與步驟輸出處理方式；不會另外套用函式專屬的型別或 JSON 允許清單。處理常式擲出的例外會被正規化為以函式名稱為前綴的 `ValueError` 訊息，而 `BaseException` 的子類別則不會被攔截。
