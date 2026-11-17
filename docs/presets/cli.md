# 預設集 CLI 參考

所有 `specify preset` 命令都需要以 `specify init` 初始化過的專案。請在該專案內執行，或將 `SPECIFY_INIT_DIR` 設為專案根目錄。使用 `specify preset --help` 或子命令的 `--help` 查看用法。

## 搜尋可用的預設集

```bash
specify preset search [query]
```

| 選項 | 說明 |
| --- | --- |
| `--tag <tag>` | 依標籤篩選 |
| `--author <author>` | 依作者篩選 |

搜尋使用中的型錄。若未提供查詢，會列出所有可用的預設集。僅供探索的結果可見，但無法依 ID 安裝。

## 安裝預設集

```bash
specify preset add <preset_id>
specify preset add <preset_id> --version <version>
specify preset add --dev <path>
specify preset add --from <archive-url>
```

| 選項 | 說明 |
| --- | --- |
| `--dev <path>` | 複製本機來源目錄 |
| `--from <url>` | 下載 `.zip`、`.tar.gz` 或 `.tgz` 封存檔 |
| `--version <version>` | 從勝出的型錄中選取確切的發行版本；僅限依 ID 安裝 |
| `--priority <N>` | 解析優先順序，為正整數；預設為 `10`，數字越小越優先 |

請選擇一種來源形式。若未指定 `--version`，依 ID 安裝時會先使用本機隨附的預設集（如有），否則使用型錄公告的目前發行版本。直接 URL 安裝不會查閱型錄。已安裝的預設集必須先移除或更新，才能重新安裝；`add` 沒有 `--force` 選項。

`--version` 需要預設集 ID，且不能與 `--from` 或 `--dev` 併用。勝出的型錄中若無所要求的發行版本，即為錯誤；優先順序較低的型錄無法提供該版本。僅供探索的型錄無法安裝任何發行版本。針對特定版本的型錄安裝會先驗證封存檔的 `preset.yml` ID 與版本，再修改已安裝的預設集。歷史發行版本需要 SHA-256 摘要，並於下載時驗證；舊版目前發行版本可省略摘要。沒有下載 URL 的隨附發行版本，僅能在已安裝的 Spec Kit 套件中含有相符 ID 與版本時選取。

來源會複製到 `.specify/presets/<id>/`，並遵守 [`.presetignore`](developing.md#用-presetignore-排除開發檔案)。預設集的命令貢獻會為使用中的整合，以其選定的命令或技能格式註冊。通用整合不會註冊預設集覆寫。未滿足的必要擴充功能相依性會產生警告，而非安裝失敗或自動安裝相依性。

下載 URL 必須使用具備主機名稱的 HTTPS；HTTP 僅允許用於 `localhost`、`127.0.0.1` 或 `::1`。封存檔必須在根目錄，或在單一頂層目錄內含有 `preset.yml`。

## 更新預設集

```bash
specify preset update <preset_id> [--from <url>] [--dev <path>] [--priority <N>]
```

以執行正常的 `remove` 操作，再執行正常的 `add` 操作，來取代已安裝的預設集。若未明確指定來源，add 會使用其慣用的隨附與型錄查閱方式。這不是版本比較，也不是就地修補。`update` 不接受 `--version`。

> [!WARNING]
> 更新具有破壞性。若移除成功但取代安裝失敗，先前的預設集已被移除。沒有來源預檢、暫存、復原、自動修復或復原交易。

在移除任何內容之前，此命令會拒絕合併使用 `--from` 與 `--dev`、空白的來源引數、低於 `1` 的優先順序，以及未安裝的 ID。除上述檢查外，它不會預先檢查取代來源。使用 `--from` 或 `--dev` 時，取代資訊清單的 ID 不會在移除前與所要求的 ID 核對，因此可能會改為安裝不同的預設集。

若 add 失敗，此命令會回報可直接複製貼上的 `specify preset add` 重試命令，其中包含取代來源與優先順序。在 Windows 上，該命令會以 PowerShell 格式呈現。

更新成功後會重新啟用預設集、重新建立 `installed_at`，並移除已安裝預設集目錄內的本機修改。取代的優先順序預設為 `10`；請傳遞 `--priority` 選擇其他值。明確指定 `--from` 或 `--dev` 屬於刻意的來源變更，而非重複使用已記錄的型錄來源資訊。

若啟用憲章同步，正常的 remove 與 add 協調流程都會執行。取代失敗時，產生的憲章可能會在未含被移除預設集的情況下已完成與堆疊的協調。產生檔案的保護機制仍會保護手動編輯過的憲章。沒有專為更新設計的最佳化，可在最終內容不變時抑制重寫。

## 移除預設集

```bash
specify preset remove <preset_id>
```

刪除已安裝的預設集及其登錄項目，清理已記錄的命令與技能輸出，並針對存留的堆疊協調受影響的名稱。移除也可以還原先前使用中整合目錄中的輸出（以該預設集記錄者為限），不限於刪除目前整合中的檔案。

## 列出已安裝的預設集

```bash
specify preset list
specify preset list --json
```

列出已安裝的預設集，包含版本、說明、貢獻數量、優先順序與啟用狀態。輸出包含已停用的預設集，並依優先順序排序：優先順序數字最小者優先，其次依預設集 ID 字母順序。

`--json` 會將恰好一個 JSON 陣列寫入 stdout，成功時結束代碼為 `0`。每個項目都有以下鍵：

| 鍵 | 值 |
| --- | --- |
| `id`、`name`、`description`、`version` | 預設集身分與中繼資料 |
| `author` | 作者；缺失時為 `null` |
| `priority` | 解析優先順序 |
| `enabled` | 預設集是否參與解析 |
| `source` | `{"kind":"local"}` 或 `{"kind":"catalog","catalog":"<catalog-name>"}` |
| `provides` | 名為 `commands`、`templates` 與 `scripts` 的計數 |

本機、舊版與格式錯誤的來源資訊皆回報為 `{"kind":"local"}`。`source` 物件說明預設集的安裝來源，而非貢獻在解析堆疊中的位置。

選項解析後的執行階段失敗會將恰好一個 `{"error":"..."}` 物件寫入 stderr，並以 `1` 結束，不產生成功輸出。含有原始 `--json` 權杖的用法錯誤也會在 stderr 使用該 JSON 錯誤格式，並保留其用法結束代碼，通常為 `2`。若未使用 `--json`（包含求助說明），人類可讀的行為不變。

## 預設集資訊

```bash
specify preset info <preset_id>
specify preset info <preset_id> --versions
specify preset info <preset_id> --json
```

人類可讀的輸出會先描述已安裝的預設集，否則描述可用的型錄項目，包含可用的中繼資料、標籤與貢獻。

`--versions` 會查閱型錄，而非已安裝的預設集。它會先列出公告的目前版本，再依版本降冪列出歷史版本，即使是僅供探索的項目也不例外。列出版本並不會使其可安裝。

`--json` 會描述一個依 ID 比對的已安裝預設集，並將一個 JSON 物件寫入 stdout。它與 `list --json` 有相同的 `id`、`name`、`description`、`version`、`author`、`priority`、`enabled` 與 `source` 鍵。不同於 `provides` 計數，它有 `commands`、`templates` 與 `scripts` 陣列。每個陣列保留資訊清單的宣告順序，並包含：

| 鍵 | 值 |
| --- | --- |
| `name` | 邏輯貢獻名稱 |
| `description` | 說明；缺失或為空時為 `""` |
| `source` | 識別貢獻預設集的 `{"layer":"preset","presetId":"<id>"}` |
| `sourcePath` | 資訊清單的 `file` 路徑，相對於已安裝的預設集 |
| `strategy` | `replace`、`prepend`、`append` 或 `wrap`；省略時為 `replace` |

`--json` 不能與 `--versions` 併用（用法錯誤，結束代碼 `2`）。未安裝的預設集（包含僅存在於型錄中的預設集）或缺失的專案，會在 stderr 產生一個 JSON 錯誤物件，並以 `1` 結束。用法錯誤會如 `list --json` 一樣保留其用法結束代碼。

## 解析檔案

```bash
specify preset resolve spec-template
specify preset resolve speckit.specify
```

接受無副檔名的範本名稱或以點號分隔的命令名稱。名稱使用小寫字母、數字與連字號；命令區段不得為空。此命令不提供指令碼類型選擇器。

顯示優先順序最高的層級之路徑與來源。若輸出經過組合，也會顯示促成組合的組合鏈，從其實際基準開始。顯示的路徑並非含有最終組合輸出內容的檔案。無效的組合會產生警告；找不到名稱時會回報為未找到。如需所有產出物種類與隱藏層級，請使用另外的[產出物參考](../overview/artifacts.md)。

## 啟用或停用預設集

```bash
specify preset enable <preset_id>
specify preset disable <preset_id>
```

變更已安裝的預設集是否參與後續解析。重複設定為目前狀態時會成功，且不改變任何內容。

先前已註冊的命令與技能會保留在原處。停用有助於比較範本與指令碼的行為，但不會撤回已交付給代理的覆寫。若需讓這些輸出停止生效，請使用移除。啟用 `constitution-sync` 時會執行憲章協調。

## 設定預設集優先順序

```bash
specify preset set-priority <preset_id> <priority>
```

變更已安裝預設集的解析優先順序。該值必須是正整數；數字越小越優先，平手時依 ID 字母順序排序。此操作會更新登錄檔與已加入的憲章協調；本身不會重新搭建命令與技能輸出。

## 型錄管理

```bash
specify preset catalog list
specify preset catalog add <url> --name <name>
specify preset catalog remove <name>
```

`list` 會顯示使用中的來源、優先順序與安裝權限。`add` 會寫入專案的 `.specify/preset-catalogs.yml`；`remove` 會從該專案設定中移除具名項目。

| `catalog add` 選項 | 說明 |
| --- | --- |
| `--name <name>` | 必要的型錄名稱 |
| `--priority <N>` | 預設為 `10`；數字越小越先檢查 |
| `--install-allowed / --no-install-allowed` | 允許依 ID 安裝；預設僅供探索 |
| `--description <text>` | 選填說明 |

以相同設定重新加入同名的型錄時會成功，且不會重寫設定。以不同設定加入同名型錄時會被拒絕；請先移除該項目，或選擇其他名稱。

> [!IMPORTANT]
> 專案的 `.specify/preset-catalogs.yml` 可能會選取你未選擇的允許安裝型錄。請在不熟悉的專案中檢查 `catalog list`。僅對你擁有或已審查過的型錄啟用安裝；切勿將 `install_allowed` 視為預設集程式碼已通過審查的證據。

## 另請參閱

- [預設集概覽](overview.md)
- [開發預設集](developing.md)
- [API 參考](api.md)
- [型錄設定、結構描述與信任](catalogs.md)
- [發布預設集](publishing.md)
