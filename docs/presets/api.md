# 預設集 API 參考

本參考定義預設集資訊清單、組合與交付規則，以及已安裝狀態。CLI 參考說明終端機命令；開發指南逐步介紹如何建立套件。

## 資訊清單

每個預設集都有一個 UTF-8 編碼的 `preset.yml`，其根節點為 YAML 對應。

| 欄位 | 必要 | 契約 |
| --- | --- | --- |
| `schema_version` | 是 | 字串 `"1.0"` |
| `preset` | 是 | 中繼資料對應 |
| `preset.id` | 是 | 符合 `[a-z0-9-]+` 的字串 |
| `preset.name` | 是 | 人類可讀的字串 |
| `preset.version` | 是 | Python `packaging.version.Version` 接受的引號字串 |
| `preset.description` | 是 | 說明字串 |
| `preset.author` | 否 | 作者中繼資料 |
| `preset.repository` | 否 | 儲存庫 URL 中繼資料 |
| `preset.license` | 否 | 授權中繼資料 |
| `requires` | 是 | 需求對應 |
| `requires.speckit_version` | 是 | 非空字串；安裝期間以 PEP 440 規格字串檢查 |
| `requires.extensions` | 否 | 擴充功能 ID 或相依性對應的清單 |
| `provides` | 是 | 貢獻對應 |
| `provides.templates` | 是 | 非空的貢獻對應清單，包含命令與指令碼 |
| `tags` | 否 | 探索標籤；使用小寫字串清單 |

已發布的預設集請使用描述性、以字母開頭、小寫連字號形式的 ID，以及 `X.Y.Z` 版本。社群提交契約比執行階段資訊清單驗證器更嚴格：它要求 ID 符合 `[a-z][a-z0-9-]*`、數字形式的 `X.Y.Z` 版本，以及儲存庫、文件、授權與發行資訊。僅憑執行階段的中繼資料驗證，不足以證明預設集符合型錄提交需求。

版本與約束請加上引號：例如 `version: 1.0` 這類 YAML 值是數字，而非版本字串。不相容的 Spec Kit 版本或無效的 Spec Kit 規格字串會導致安裝失敗。

### 貢獻欄位

`provides.templates` 中的每個項目都使用以下結構：

```yaml
provides:
  templates:
    - type: "template"
      name: "spec-template"
      file: "templates/spec-addendum.md"
      description: "Adds team requirements"
      strategy: "append"
```

| 欄位 | 必要 | 契約 |
| --- | --- | --- |
| `type` | 是 | `template`、`command` 或 `script` |
| `name` | 是 | 邏輯產出物名稱，而非來源檔案名稱 |
| `file` | 是 | 預設集內的相對路徑，不得含父層遍歷 |
| `description` | 否 | 貢獻說明 |
| `strategy` | 否 | 預設為 `replace`；接受的字串會正規化為小寫 |

範本與指令碼名稱使用小寫字母、數字與連字號。命令名稱還可使用點號；例如 `speckit.specify` 或 `speckit.myext.report`。重複的 `(name, type)` 配對會被拒絕，但不同類型可以共用同一個名稱。

產出物一經宣告，資訊清單中的 `file` 即為權威依據。宣告的路徑若缺失或不是檔案，不會退回使用同一預設集內的其他慣用檔案。請確保所有宣告的檔案都存在：資訊清單的結構驗證並非完整的套件內容檢查。當資訊清單缺失或未宣告所要求的名稱時，舊版查閱可使用慣用路徑。

### 擴充功能相依性

```yaml
requires:
  speckit_version: ">=0.9.0"
  extensions:
    - "companion-extension"
    - id: "other-extension"
      version: ">=1.2.0,<2"
      required: false
```

僅寫 ID 表示必要且無版本約束。對應形式的項目必須有符合 `[a-z0-9-]+` 的 `id`；選填的 `version` 必須是有效的非空 PEP 440 規格字串，`required` 必須是布林值，預設為 `true`。精確釘選、排除條件與上限皆為有效寫法。

相依性僅供建議，不會自動安裝。安裝完成後，CLI 會針對必要的擴充功能發出警告，若其缺失、登錄項目損毀、檔案缺失、已停用，或可比較的版本不符合約束。缺失或已停用的功能仍無法使用。版本不符並不會停用擴充功能；它仍可執行，但行為可能與預期不同。

選填相依性一律不會發出警告。無法解析或缺失的已記錄版本屬於無法比較，不會回報為不符。解析器接納的擴充功能目錄即使沒有登錄項目，也視為可用，但沒有可供比較的已記錄版本。擴充功能登錄檔無法讀取時，便無法進行這項安裝後的相依性檢查；沒有警告並不代表相依性已通過驗證。

相依性請宣告在資訊清單中，而不只是型錄項目：`--dev` 與 `--from` 不會查閱型錄。即使是自成一體、具命名空間的取代命令，仍會在沒有同名擴充功能的情況下交付。

## 檔案解析

每個 `(name, type)` 皆獨立評估：

```mermaid
flowchart TD
    A["Requested artifact"] --> B["Project-local override"]
    B --> C["Enabled presets: priority, then ID"]
    C --> D["Enabled extensions: priority, then ID"]
    D --> E["Core defaults"]
```

在預設集與擴充功能層級中，優先順序數字越小越優先，其次以字母順序的 ID 打破平手。已停用的項目會被排除。安全的未登錄擴充功能目錄以隱含優先順序 `10` 參與；已停用、損毀或缺失的已登錄擴充功能，不會再以未登錄貢獻的形式重新納入。

| 類型 | 專案本機覆寫 | 慣用預設集子目錄 |
| --- | --- | --- |
| 範本 | `.specify/templates/overrides/<name>.md` | `templates/`，含舊版根目錄查閱 |
| 命令 | `.specify/templates/overrides/<name>.md` | `commands/` |
| 指令碼 | `.specify/templates/overrides/scripts/<name>.<ext>` | `scripts/` |

核心查閱包含專案預設值與封裝的核心資產；對於可編輯／原始碼安裝，則為儲存庫資產。命令查閱可將 `speckit.<stem>` 對應到核心的 `<stem>.md` 檔案名稱。如此一來，即使專案沒有 `.specify/templates/commands/` 的副本，也能針對核心命令進行組合。

### 組合策略

| 類型 | `replace` | `prepend` | `append` | `wrap` |
| --- | --- | --- | --- | --- |
| 範本 | 預設 | 支援 | 支援 | `{CORE_TEMPLATE}` |
| 命令 | 預設 | 支援 | 支援 | `{CORE_TEMPLATE}` |
| 指令碼 | 預設 | 不支援 | 不支援 | `$CORE_SCRIPT` |

優先順序最高的 `replace` 層會完全勝出。否則，解析會找到最近的下層 `replace` 基準，再由下而上僅套用其上方的層級。前置與附加會以空白行分隔兩段內容。包裝佔位符會由實際的下層內容取代，而該內容可能已包含其他預設集的客製化。

若無 `replace` 基準，組合便無法產出內容。命令註冊會發出警告並跳過無法組合的命令，而不是僅憑其命名空間就要求提供擴充功能。包裝缺少必要的佔位符時，會在組合期間引發預設集驗證錯誤。

組合後的命令主體不會內嵌每一層的 YAML frontmatter。解析會使用優先順序最高的可用 frontmatter，並在缺少時從基準繼承 `scripts`、`agent_scripts` 與 `argument-hint`。內部的 `strategy` 鍵會從組合輸出中移除。接著由使用中的整合以其支援的命令或技能格式算繪結果。

## 命令與技能生命週期

安裝會將預設集檔案複製到 `.specify/presets/<id>/`，並在組合其命令之前記錄該預設集。初始註冊與安裝後的協調會具體化實際的堆疊，因此安裝順序不會決定最終勝出的命令。

對於已初始化的專案，交付僅針對已記錄的使用中整合。技能模式會為命令式整合發出技能，而非第二種命令表示法；原生技能整合則使用其原生格式。通用整合不會註冊預設集覆寫。使用 `specify integration use <key>` 或 `switch <key>` 切換時，會為新啟用的整合重新搭建已啟用的預設集。

沒有 `init-options.json` 的舊版專案仍保留偵測式命令註冊。已存在但損毀或格式錯誤的選項檔案，不會觸發該全代理備援機制。

移除會清理已記錄的輸出，並協調存留的預設集、擴充功能、覆寫或核心貢獻。它也能還原受影響的命令或技能輸出，範圍包括被移除預設集所記錄的先前使用中整合目錄，以及目前的整合。啟用、停用與優先順序變更會更新解析狀態，但本身不會重新搭建已交付的命令或技能。

憲章生命週期與代理命令交付不同。預設情況下，憲章由憲章命令解析，而非在每次堆疊變更時重寫。啟用 `constitution-sync` 時，受保護的協調會利用產生內容的來源資訊，避免覆寫人工撰寫的憲章。

## 已安裝狀態

| 位置 | 角色 |
| --- | --- |
| `.specify/presets/<id>/preset.yml` | 已安裝的資訊清單 |
| `.specify/presets/<id>/` | 已複製的套件檔案 |
| `.specify/presets/.registry` | 含有 `schema_version: "1.0"` 與 `presets` 對應的 JSON 登錄檔 |
| `.specify/presets/.cache/` | 型錄快取與下載工作檔案 |
| `.specify/memory/.constitution-template.json` | 具體化時產生的憲章來源資訊 |

登錄中繼資料記錄版本、資訊清單雜湊、啟用狀態、優先順序、安裝時間戳記、來源，以及已登錄的命令／技能輸出。新版輸出追蹤會將整合鍵對應到名稱清單；舊版技能追蹤可能是扁平清單。請將其視為 CLI 管理的狀態，而非套件資訊清單或穩定的 JSON 檢查 API。

型錄安裝會記錄 `{"kind":"catalog","catalog":"<name>"}` 來源資訊。本機目錄、直接 URL 與本機隨附安裝會記錄為本機，而非可重複使用的下載 URL。登錄更新會保留現有的 `installed_at`；先移除再新增的取代方式會建立新的時間戳記。

## 指令碼範本解析

各自 `common` 指令碼中的 Bash `resolve_template`／`resolve_template_content` 與 PowerShell `Resolve-Template`／`Resolve-TemplateContent`，可讓殼層取用者使用範本解析。代理命令與技能的具體化由 Spec Kit 處理，而非由各代理自行處理。

## 另請參閱

- [預設集概覽](overview.md)
- [CLI 參考與 JSON 輸出](cli.md)
- [開發預設集](developing.md)
- [型錄結構描述與設定](catalogs.md)
- [發布預設集](publishing.md)
- [產出物清單與組合堆疊](../overview/artifacts.md)
- [整合管理](../integrations/cli.md)
