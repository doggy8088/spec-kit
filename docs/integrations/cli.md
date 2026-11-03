# 整合 CLI 參考

本參考文件記載共用的 `specify integration` 命令、目錄管理與生命週期行為。代理專屬的設定、安裝路徑、選項與限制，請從[整合指南](index.md)開始。

請在已以 `specify init` 初始化的專案內執行這些命令。若是新專案，請使用 `specify init <project> --integration <key>`。

## 支援的 AI 程式代理

[整合目錄](index.md#choose-an-integration)列出了受支援的代理及其確切鍵值，每個整合都有一份專屬指南。執行 `specify integration list` 可查看本機可用性。

## 命令呼叫方式

請在你的程式代理內呼叫 Spec Kit 的流程步驟，不要在終端機中呼叫。在 GitHub Copilot 的預設模式中，這些是你在代理聊天中呼叫的技能。CLI 的安裝與設定命令則是另外的終端機操作。這些步驟在各整合間相同，但其寫法取決於代理及其安裝模式：

| 整合或模式 | SDD 範例 | 擴充功能範例 |
| --- | --- | --- |
| GitHub Copilot，預設技能模式 | `/speckit-specify` | `/speckit-bug-assess` |
| 參考文件中使用的點記法斜線命令 | `/speckit.specify` | `/speckit.bug.assess` |
| Codex、Command Code、ZCode 技能 | `$speckit-specify` | `$speckit-bug-assess` |
| Kimi 技能 | `/skill:speckit-specify` | `/skill:speckit-bug-assess` |

請使用你的代理所公開的形式。GitHub Copilot 的技能與命令版式請參閱 [GitHub Copilot 指南](copilot.md)，或從[整合目錄](index.md)選擇另一個代理。

## 列出可用的整合

```bash
specify integration list
```

| 選項 | 說明 |
| ----------- | ----------------------------------------------------------------------------------------------------------------------- |
| `--catalog` | 一併瀏覽目錄，包括未安裝在本專案中的外部整合。 |

顯示內建與受信任的已安裝外部整合、它們的設定要求，以及它們的多重安裝安全宣告。已安裝的整合與預設整合會分開標示。`CLI Required` 欄位回報的是 `config.requires_cli` 所宣告的代理 CLI 要求，而不是該整合是否僅限 IDE 使用。外部轉接器可以另外透過其描述檔的 `requires.tools` 要求執行檔；即使 `CLI Required` 是 `no`，安裝與 `specify check` 也會驗證那些工具要求。

## 搜尋可用的整合

```bash
specify integration search [query]
```

| 選項 | 說明 |
| ---------- | ------------------ |
| `--tag`    | 依標籤篩選 |
| `--author` | 依作者篩選 |

搜尋使用中的目錄堆疊。若未提供查詢，則列出所有可用的整合。

## 整合資訊

```bash
specify integration info <integration_id>
specify integration info <integration_id> --versions
```

顯示某個整合的目錄中繼資料、來源目錄，以及它是否為使用中。`--versions` 會列出獲勝目錄所公布的目前與歷來版本，目前版本在前，較舊的版本依版本遞減排列。僅供探索的來源會標示為僅供探索。

## 安裝整合

```bash
specify integration install <key>
```

| 選項 | 說明 |
| ------------------------ | ------------------------------------------------------------------------ |
| `--script sh\|ps\|py`    | 指令稿類型：`sh`（bash/zsh）、`ps`（PowerShell）或 `py`（Python） |
| `--force`                | 選擇與未宣告為多重安裝安全的整合一併安裝 |
| `--integration-options`  | 整合專屬選項（例如 `--integration-options="--commands-dir .myagent/cmds"`） |
| `--trust-integration` | 在審查程式碼後，預先授權外部轉接器執行 Python，跳過互動式信任提示 |

將整合安裝到目前的專案中。只有當所有涉及的整合都宣告為安全時，多重安裝才會自動進行。否則，請使用 `switch` 取代預設整合，或以 `--force` 選擇多重安裝。設定失敗會觸發復原。

**目錄歷程只是中繼資料。** `integration install` 仍會直接解析已註冊的內建實作，或從允許安裝的目錄取得目前的外部轉接器版本，而不是歷來目錄紀錄。沒有 `integration install --version`。預設的社群目錄仍僅供探索。

安裝額外的整合不會變更預設整合。使用 `specify integration use <key>` 可變更預設值。

擴充功能與預設集只跟隨預設整合。使用 `use <key>` 或 `switch <key>` 可啟用另一個整合，並為它註冊它們的命令。

### 透過目錄安裝的外部轉接器

在已初始化的專案中註冊一個經過審查的目錄，然後安裝它的轉接器：

```bash
specify integration catalog add https://example.com/catalog.json --name samples
specify integration install sample-agent
specify integration use sample-agent
```

安裝會在下載／匯入 Python **之前**提示信任。對於自動化，請明確授權你已審查的程式碼：

```bash
specify integration install sample-agent --trust-integration
specify integration upgrade sample-agent --trust-integration
```

來源必須具有 `install_allowed: true`。預設的社群目錄僅供探索；`--force` 與信任旗標都無法繞過該政策。目錄的列表／搜尋／資訊不會匯入目錄程式碼。必要的中繼資料與受支援的封存檔 URL 請參閱[目錄綱要](catalog.md#catalog-schema)。搜尋會為允許安裝的來源公布 `specify integration install <id>`；僅供探索的結果不會公布安裝方式。

`specify check` 會探查外部轉接器所要求的描述檔工具，而不是其目錄 ID。若未宣告任何必要工具，CLI 轉接器會以其執行階段執行檔進行檢查；選用工具不會產生缺少工具的錯誤。這些檢查不會執行該執行檔，也不會呼叫一般的版本探查。

已安裝的轉接器程式碼與產生的代理檔案分開保存。新的 CLI 行程會載入受信任的套件，不諮詢目錄。程式碼遺失、被修改或不相容都是錯誤，而不是無聲備援。升級會取得目錄的目前版本；解除安裝會移除套件，並預設保留已修改的產生檔案。僅中繼資料的 `workflow status` 與 `workflow info` 在不載入轉接器程式碼的情況下仍可使用，包括已安裝的轉接器受損時。工作流程的執行與繼續仍會明確回報轉接器載入失敗。

執行同意是使用者本機的，並與專案、整合以及經驗證的套件內容綁定。複製專案中繼資料不會轉移同意。複製專案或變更使用者後，請審查轉接器，並從允許安裝的目錄重新授權：

```bash
specify integration upgrade sample-agent --force --trust-integration
```

當套件程式碼不受信任或其整個目錄遺失時，強制解除安裝也能運作；它不會匯入該程式碼。

在初始化時，專案／使用者目錄或 `SPECKIT_INTEGRATION_CATALOG_URL` 可以提供外部轉接器：

```bash
specify init my-project --integration sample-agent --trust-integration
```

發佈套件之前，請先檢視[外部轉接器 API](https://github.com/github/spec-kit/blob/main/design/integration.md#external-adapter-package-contract)。使用主機 API 與標準函式庫的轉接器，不需要 pip 安裝，也不需要編輯原始碼登錄。

若你的 CLI 拒絕多重安裝，請檢查 `specify version` 並遵循[升級指南](../upgrade.md)。一次性的 `uvx` 呼叫不會更新你 `PATH` 上持續存在的 `specify` 執行檔。

## 解除安裝整合

```bash
specify integration uninstall [<key>]
```

| 選項 | 說明 |
| --------- | --------------------------------------------------- |
| `--force` | 即使檔案已被修改也將其移除 |

移除指定的整合；若未提供鍵值，則移除預設整合。由清單追蹤的產生檔案會使用內容雜湊進行清理：

- **未修改的檔案**會自動移除。
- **已修改的檔案**（你曾手動編輯的檔案）會被保留，讓你的自訂內容不會遺失。
- 使用 `--force` 也可移除已修改的追蹤檔案。

以上是由清單追蹤的產生檔案的規則。整合專屬的清理方式可能不同：[Hermes 全域技能](hermes.md#global-ownership-and-removal)與 [Kimi 舊版技能](kimi.md#legacy-cleanup-on-uninstall)可以在沒有已修改檔案保護的情況下被移除。解除安裝或切離之前，請先查看代理指南。

解除安裝也會移除該整合已註冊的擴充功能與預設集成品；擴充功能與預設集本身仍保持安裝。移除預設整合會選取一個其餘的整合，並為它註冊已啟用的貢獻。移除最後一個整合不會自動安裝 `none`。

## 切換到不同的整合

```bash
specify integration switch <key>
```

| 選項 | 說明 |
| ------------------------ | ------------------------------------------------------------------------ |
| `--script sh\|ps\|py`    | 指令稿類型：`sh`（bash/zsh）、`ps`（PowerShell）或 `py`（Python） |
| `--force`                | 在解除安裝期間強制移除已修改的檔案；當目標已安裝時，在變更預設值的同時覆寫受管理的共用範本 |
| `--refresh-shared-infra` | 即使你已自訂，也一併覆寫共用基礎設施檔案（否則自訂內容會被保留） |
| `--integration-options`  | 當目標尚未安裝時，提供給目標整合的選項 |
| `--trust-integration` | 授權下載並執行經過審查的外部轉接器，跳過互動式信任提示 |

- **目標未安裝：** 移除目前的預設整合，安裝目標，並將它設為預設。其他已安裝的整合會保留。
- **目標已安裝：** 在不移除任何整合的情況下變更預設值，如同 `use`。若要變更它的設定選項，請先執行 `upgrade <key> --integration-options ...`，再執行 `use <key>`；`switch` 會拒絕已安裝目標的設定選項。

兩條路徑都會為新的預設整合註冊已啟用的擴充功能與預設集。`--force` 的不同含義請參閱選項表。

切換到必須下載並安裝的外部轉接器時，只有在審查其程式碼後才使用 `--trust-integration`：

```bash
specify integration switch sample-agent --trust-integration
```

切換到已安裝的轉接器仍會驗證其既有的信任。此旗標不會繞過該驗證，也不會繞過目錄的僅供探索政策。信任要求請參閱[透過目錄安裝的外部轉接器](#catalog-installed-external-adapters)。

## 使用已安裝的整合

```bash
specify integration use <key>
```

| 選項 | 說明 |
| --------- | --------------------------------------------------- |
| `--force` | 在變更預設值的同時覆寫受管理的共用範本 |

將預設整合設定為指定的整合，不解除安裝任何其他已安裝的整合。這也會重新整理受管理的共用範本，讓命令參照與新預設整合的呼叫風格相符。已修改或未追蹤的共用範本會被保留，除非使用 `--force`。

它也會為新的預設整合註冊已啟用的擴充功能與預設集命令或技能，包括在另一個整合使用期間安裝的貢獻。

## 升級整合

```bash
specify integration upgrade [<key>]
```

| 選項 | 說明 |
| ------------------------ | ------------------------------------------------------------------------ |
| `--force`                | 即使檔案已被修改也將其覆寫 |
| `--script sh\|ps\|py`    | 指令稿類型：`sh`（bash/zsh）、`ps`（PowerShell）或 `py`（Python） |
| `--integration-options`  | 提供給整合的選項 |
| `--trust-integration`    | 授權下載／匯入經過審查的替代外部轉接器 |

以更新後的範本與命令重新安裝已安裝的整合（例如在升級 Spec Kit 之後）。預設對象是預設整合；若提供鍵值，它必須是已安裝的整合之一。它會偵測本機修改過的檔案，並阻止升級，除非使用 `--force`。先前安裝中不再需要的過期檔案會自動移除。即使升級的是非預設整合，共用範本仍與預設整合保持一致。

只有在升級目前使用中（預設）的整合時，已啟用的擴充功能與預設集才會重新註冊。非預設整合的升級仍會重新整理該整合的核心命令，但不會重新註冊它的擴充功能或預設集層——事後請對該整合執行 `use`/`switch`，重新建立它們的骨架。

若產生的檔案清單遺失，升級會回報沒有可升級的內容，並讓已安裝的轉接器套件、產生的檔案與本機復原所有權保持不變，包括使用 `--force` 時也一樣。替代程式碼只有在升級成功重新產生受管理的檔案之後才會保存。

若某次升級會在已為某整合註冊預設集成品的情況下，將它在命令與技能版式之間變更，該升級會在變更檔案之前被拒絕。請先移除受影響的預設集，執行變更版式的升級，再重新安裝它們。

對於外部轉接器，強制升級或解除安裝可以使用使用者本機的所有權紀錄，復原受損或無法載入的套件。若沒有該證明，僅屬於舊版的產生檔案會被保留，並附上手動清理警告。復原程序會保留共用的事件分派器與部分擁有的設定；在 `upgrade --force` 下，受信任的替代品仍可覆寫它宣告的目的地。復原不會繞過目錄政策或替代套件的信任。

失敗的操作會復原它們自己的變更，而不是無關的使用者檔案或工作流程進度。衝突的並行編輯會被回報，並保留復原快照。轉接器作者應遵循[儲存、載入與生命週期合約](https://github.com/github/spec-kit/blob/main/design/integration.md#storage-loading-and-lifecycle)中的所有權、記錄與復原要求。

## 回報整合狀態

```bash
specify integration status
specify integration status --json
```

在不變更檔案的情況下回報目前專案的整合狀態。狀態報告包括預設整合、已安裝的整合、多重安裝安全性、遺失的受管理檔案、已修改的受管理檔案、無效的清單路徑、共用 Spec Kit 基礎設施的健康狀態、未檢查的清單，以及對預設值敏感的共用範本的目標整合。JSON 形式供需要穩定、可由機器讀取的狀態資料的 CI 與程式代理使用；當狀態修復的啟發式判斷與記錄的檔案不同時，它也會回報原始記錄的整合與已檢查的整合清單。當報告狀態為 `ok` 或 `warning` 時，命令以 0 結束；只有當報告狀態為 `error` 時才以 1 結束。在 JSON 輸出中，當沒有可評估的已安裝整合集合時（例如整合狀態遺失、無法讀取、缺少有效的已記錄整合清單，或未記錄任何已安裝的整合），`multi_install_safe` 為 `null`。

## 目錄管理

整合目錄控制探索命令（`search` 與 `info`）尋找整合的位置。目錄會依優先順序檢查。

目錄管理、`integration list --catalog` 與 `integration info` 不會執行轉接器程式碼。一般的整合列表、設定、選取、狀態、註冊與工作流程分派，則會載入受信任的已安裝實作。

### 列出目錄

```bash
specify integration catalog list
```

顯示使用中的目錄來源。專案層級的來源（有設定時）可以依索引移除；否則使用中的來源會顯示為不可移除。

### 加入目錄

```bash
specify integration catalog add <url>
```

| 選項 | 說明 |
| --------------- | ----------------------------- |
| `--name <name>` | 目錄的選用名稱 |

將自訂目錄 URL 加入專案的 `.specify/integration-catalogs.yml`。URL 必須使用 HTTPS（供本機測試的 `http://localhost`、`http://127.0.0.1` 或 `http://[::1]` 除外）。

以相同名稱重新加入相同的 URL 會成功，且不會變更設定；不同的名稱則會被拒絕。

### 移除目錄

```bash
specify integration catalog remove <index>
```

依其在 `catalog list` 中以 0 為起點的索引，移除一個專案目錄來源。

### 目錄解析順序

第一個設定的層級會取代較低的層級。在該層級內，數字較小的優先順序勝出：

1. **環境變數**——`SPECKIT_INTEGRATION_CATALOG_URL` 覆寫所有目錄
2. **專案設定**——`.specify/integration-catalogs.yml`
3. **使用者設定**——`~/.specify/integration-catalogs.yml`
4. **內建預設值**——官方目錄 + 社群目錄

### 歷來整合中繼資料

整合項目可以保留其所公布的目前版本的既有最上層欄位，並加入歷來版本到中繼資料的 `releases` 對應。單一版本的項目在沒有 `releases` 鍵的情況下仍然有效。例如：

```json
{
  "id": "my-agent",
  "name": "My Agent",
  "version": "2.0.0",
  "description": "Current release",
  "releases": {
    "1.0.0": {
      "description": "Historical release",
      "repository": "https://example.com/my-agent/v1",
      "requires": {"speckit_version": ">=0.7"}
    }
  }
}
```

最上層欄位對較舊的 client，以及未指定版本的 `search`、`info`、`list --catalog` 與 `install` 命令，保留其原始含義。歷來紀錄可以包含 `name`、`description`、`author`、`repository`、`license`、`tags`（字串清單）與 `requires`（對應）。共用的身分、名稱、作者與來源政策會被保留；僅屬於目前版本的中繼資料，例如說明、儲存庫、標籤與要求，**不會**被較舊版本繼承，除非在其紀錄中明確提供。版本紀錄不能覆寫 `id`、`version`、`releases` 或來源政策，也不能公布下載 URL 或封存檔。

對於程式化的中繼資料查詢，`IntegrationCatalog.get_integration_info(id, version="1.0.0")` 會從獲勝來源中選出確切的歷來紀錄，若該版本不存在則回傳 `None`。`get_integration_versions(id)` 會回傳同一個來源所公布的版本。與 PEP 440 等價的寫法（例如 `v1.0` 與 `1.0.0`）會對應到同一個版本，同時保留其目錄寫法。目前版本不得在 `releases` 中重複；格式錯誤的紀錄與重複的等價版本會被拒絕。不存在的版本永遠不會穿透到優先順序較低的來源，也不會無聲地選取目前版本。這些查詢不會安裝整合。

## 整合專屬選項

透過 `--integration-options` 傳入代理專屬的設定選項。它們的語義、範例與遷移注意事項記載於相關的代理指南中：

| 整合 | 指南 |
| --- | --- |
| Generic | [輸出目錄與技能模式](generic.md#output-options-and-invocation) |
| GitHub Copilot | [技能與命令版式](copilot.md#commands-layout) |
| IBM Bob | [舊版命令與遷移](bob.md#legacy-commands-and-migration) |
| Kimi Code | [舊版遷移](kimi.md#legacy-migration) |

其他代理專屬的細節列於[整合目錄](index.md)中。

## 執行階段事件

支援事件的整合透過設定用的 `--integration-options` 字串接受 `--events true|false`；預設為啟用。處理常式的定義來自整合預設值、已安裝的擴充功能，以及 `.specify/integration-events.yml`。啟用事件並不會在未設定處理常式的地方建立處理常式，而且整合只會發出它支援的原生事件。

若要設定專案覆寫，請建立 `.specify/integration-events.yml`。將 `<key>` 換成你的整合鍵，並將範例命令換成已安裝、以指令稿為基礎的 Spec Kit 命令：

```yaml
integrations:
  <key>:
    events:
      post_tool_use:
        - command: speckit.my-extension.check
          matcher: "*"
          timeout: 60
```

每個事件接受一個處理常式對應，或一組處理常式清單。處理常式必須有非空的 `command` 字串；`matcher` 是選用的原生篩選字串，`timeout` 是選用的正整數，單位為秒。

整合預設值與擴充功能處理常式會累加。有效的專案覆寫會**取代該整合的整個事件對應表**，而不只是覆寫中列出的事件。在整合鍵之下設定 `events: {}` 可停用它的所有處理常式。若覆寫無法讀取或解析，或某個事件未通過驗證，Spec Kit 會發出警告，並保留預設值與擴充功能處理常式。`--events false` 的優先順序高於所有這些來源。

啟用事件時，請使用 `specify integration upgrade <key>` 套用設定變更。

對於支援事件的整合，在升級期間停用 Spec Kit 事件處理常式：

```bash
specify integration upgrade <key> --integration-options="--events false"
```

提供 `--integration-options` 會取代已儲存的設定選項，因此請重複列出你想保留的其他選項。已停用的事件集合會移除先前安裝的 Spec Kit hook，而不是僅僅停止產生新的 hook。代理專屬的指南會指出原生事件的設定路徑與限制。這些執行階段事件與擴充功能命令 hook 不同。

## 工作流程 CLI 分派

代理指南會區分 IDE 設定與工作流程 CLI 支援。某些 IDE 整合在其另外的 CLI 可用時可以分派工作流程步驟；其他整合則明確不支援命令／提示詞分派。轉接器支援表示 Spec Kit 可以建構呼叫方式，而不是每個廠商的每個 CLI 版本都曾實際對它測試過。

支援 CLI 的轉接器支援以 `SPECKIT_INTEGRATION_<KEY>_EXECUTABLE` 選取執行檔，並以 `SPECKIT_INTEGRATION_<KEY>_EXTRA_ARGS` 提供額外的 CLI 參數，其中 `<KEY>` 為大寫，連字號換成底線。額外參數使用 POSIX shell 引號規則解析。參數的放置位置與重複旗標行為因轉接器而異；請參閱代理指南，特別是 Docker Agent 與 Goose。

設定用的 `--integration-options` 與工作流程的 [`integration_args` 與 `integration_options`](../reference/workflows.md#per-step-integration-configuration)不同。轉接器會拒絕非空的逐步設定，除非它有實作該功能；Docker Agent 目前公開了結構化的代理／安全設定。無頭核准旗標、模型轉傳與結構化輸出支援同樣因轉接器而異，不是普遍保證。

## 常見問題

### 我可以在同一個專案中安裝多個整合嗎？

可以，但它的用途是團隊可攜性，而不是預設設定。只有當已安裝的整合與新整合都被 Spec Kit 宣告為多重安裝安全時，才會自動允許多重安裝。對於其他組合，請傳入 `--force`，表示你了解多個代理可能會看到無關的代理專屬指示或命令。

Spec Kit 在 `.specify/integration.json` 中追蹤一個預設整合（`default_integration`）、所有已安裝的整合（`installed_integrations`）、每個整合的執行階段設定（`integration_settings`），以及供未來狀態遷移使用的專用 `integration_state_schema`。舊版的 `integration` 欄位仍保留，作為預設整合的別名。

### 哪些整合是多重安裝安全的？

對於會產生代理檔案的整合，安全性要求靜態且唯一的輸出路徑、穩定的命令呼叫設定，以及一份獨立的清單，其受管理的檔案不與另一個安全的整合重疊。登錄測試會強制執行這些不變條件。共用的 Spec Kit 範本仍與單一預設整合保持一致。

執行 `specify integration list` 可查看每個整合的宣告。每個整合的指南都會記載其安全狀態與已安裝的命令目錄。

與另一個整合共用命令目錄、需要動態安裝路徑（例如 `--commands-dir`），或合併共用工具設定的整合，預設不會宣告為安全。它們仍可以透過 `--force` 與另一個整合一併安裝。

### 當我解除安裝或切換時，我的變更會如何？

你修改過的、由清單追蹤的檔案會自動被保留。只有未修改的追蹤檔案（與其原始 SHA-256 雜湊相符）會被移除。使用 `--force` 可覆寫此行為。整合專屬的清理例外請參閱[解除安裝](#uninstall-an-integration)。

### 我要如何知道該使用哪個鍵？

執行 `specify integration list` 可查看所有可用的整合及其鍵值，或查看[整合目錄](index.md#choose-an-integration)。

### 使用整合是否需要安裝 AI 程式代理？

以 CLI 為基礎的整合需要安裝該工具。以 IDE 為基礎的整合透過 IDE 本身運作，設定時可能不需要另外的 CLI。工作流程分派可能有額外的 CLI 要求；請參閱你所用整合的指南。`specify integration list` 會顯示每個整合的設定要求。

若某個整合沒有命令範本，`specify init` 會保留專案目錄指引，並顯示如何以 `specify integration list` 選擇整合，以及如何以 `specify integration switch <key>` 切換到它，而不是推薦無法使用的代理命令。

### 我應該在何時使用 `upgrade`，何時使用 `switch`？

當你已升級 Spec Kit，並想重新整理已安裝整合的受管理檔案時，請使用 `upgrade`。當你想以另一個整合取代目前的預設整合時，請使用 `switch`；若目標已安裝，`switch` 的行為如同 `use`。

### 我安裝的擴充功能與預設集會套用到每個已安裝的整合嗎？

不會。擴充功能（`specify extension add`）與預設集（`specify preset add`）只會為目前使用中（預設）的整合註冊它們的命令覆寫，即使已安裝了其他整合也一樣。非預設整合在成為預設之前不會收到那些成品：`specify integration use <key>`（或 `switch <key>`）會為新啟用的整合重新建立每個已啟用擴充功能與預設集的骨架。`specify integration upgrade` 也遵循相同規則——它只有在升級使用中的整合時才會重新註冊擴充功能與預設集。
