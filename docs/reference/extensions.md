# 擴充功能

擴充功能為 Spec Kit 新增功能，包括領域專屬命令、外部工具整合、品質關卡等。它們引入超越內建規格驅動開發工作流程的新命令與範本。

擴充功能可以定義命令或 hook，在功能交付期間或之後對帳 `spec.md`、`plan.md` 與 `tasks.md`。任何這類編輯都遵循擴充功能記載的行為與專案的治理；它們不是由核心 Spec Kit 命令執行，也不加入其職責。團隊的保存模型另外決定成品在交付後如何維護。

## 搜尋可用的擴充功能

```bash
specify extension search [query]
```

| 選項 | 說明 |
| ------------ | ------------------------------------ |
| `--tag`      | 依標籤篩選                        |
| `--author`   | 依作者篩選                     |
| `--verified` | 只顯示已驗證的擴充功能        |

搜尋所有啟用中的目錄，找出符合查詢的擴充功能。沒有查詢時，列出所有可用的擴充功能。

## 安裝擴充功能

```bash
specify extension add <name>
```

| 選項 | 說明 |
| --------------- | -------------------------------------------------------- |
| `--dev`         | 從本機目錄安裝（供開發使用）         |
| `--from <url>`  | 從自訂 URL 安裝，而非目錄         |
| `--version <v>` | 安裝目錄公告的精確版本        |
| `--force`       | 若擴充功能已安裝則覆寫          |
| `--priority <N>`| 解析優先順序（預設：10；數字越小優先程度越高） |

從目錄、URL 或本機目錄安裝擴充功能。擴充功能命令會向啟用中的 AI 程式代理整合註冊。對於 `generic`，呼叫使用設定的 `--commands-dir`：預設為平面命令檔案，或以 `--skills` 使用 `speckit-<name>/SKILL.md`。

若 generic 整合重新整理無法產生每個擴充功能呼叫（例如因為命令或技能被使用者修改，或其來源遺失），它會發出警告並還原該擴充功能先前註冊的成品。其他擴充功能仍可重新整理。

未限定版本的目錄安裝仍會選取公告的目前版本。`--version` 只使用該擴充功能 ID 的勝出目錄來源；當所請求的版本缺席時，它不會退回較低優先順序來源。僅供探索的目錄仍不可安裝。`--version` 不能與 `--dev` 或直接 URL 的 `--from` 選項組合使用。下載封存檔的擴充功能 ID 與版本會在安裝前檢查。

> **注意：**所有擴充功能命令都需要已以 `specify init` 初始化的專案。

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
| `--available` | 顯示可用的（未安裝的）擴充功能            |
| `--all`       | 同時顯示已安裝與可用的擴充功能       |
| `--json`      | 以 JSON 寫入已安裝的擴充功能                 |

列出已安裝的擴充功能，包含其狀態、版本與命令數量。

`--json` 將 JSON 陣列寫入 stdout。每個項目都有鍵 `id`、`name`、`description`、`version`、`author`、`priority`、`enabled`、`source` 與 `provides`。`author` 在缺席時為 `null`；`source` 對於本機、舊版或格式錯誤的來源為 `{"kind":"local"}`，對於有效的目錄來源為 `{"kind":"catalog","catalog":"<catalog-name>"}`。擴充功能的 `provides` 包含 `commands`、`templates`、`scripts` 與 `hooks` 數量。`--available` 與 `--all` 不會將 JSON 輸出擴展到已安裝擴充功能之外。成功時，`--json` 恰好將一個陣列寫入 stdout 並以 0 結束。在選項解析後的執行時期失敗，會恰好將一個 `{"error":"..."}` 物件寫入 stderr 並以 1 結束。若解析引發使用錯誤且原始 `--json` 權杖存在，它會將該 JSON 錯誤物件寫入 stderr 並保留使用結束代碼（通常為 2）。沒有 `--json` 時，包括說明，現有的人類可讀行為不變。

## 擴充功能資訊

```bash
specify extension info <name>
specify extension info <name> --versions
specify extension info <name> --json
```

顯示已安裝或可用擴充功能的詳細資訊，包括其說明、版本、命令與設定。`--versions` 列出勝出目錄來源公告的目前與歷史版本；它會將僅供探索的來源標為不可安裝。等價的 PEP 440 版本拼寫（例如 `v1.0` 與 `1.0`）選取同一個版本；目錄公告的拼寫仍保持可見。

目錄可以將目前版本保留在既有的最上層欄位中，並在 `releases` 對應中新增歷史版本。較舊的單一版本目錄繼續原封不動地運作。每筆歷史版本都需要自己的下載 URL 與 SHA-256 摘要；版本專屬的需求或提供的功能，必須放在該版本的記錄中，而非從目前版本繼承。如同目前版本，摘要可以使用不分大小寫的 `sha256:` 前綴與周圍空白。

```json
{
  "extensions": {
    "my-extension": {
      "name": "My Extension",
      "version": "0.5.1",
      "download_url": "https://example.com/my-extension-0.5.1.zip",
      "sha256": "<64-character SHA-256 for 0.5.1>",
      "releases": {
        "0.4.12": {
          "download_url": "https://example.com/my-extension-0.4.12.zip",
          "sha256": "<64-character SHA-256 for 0.4.12>"
        }
      }
    }
  }
}
```

此範例為了簡潔省略了其他目錄中繼資料。目前版本不得在 `releases` 中重複；格式錯誤或重複的版本記錄會被拒絕。套件組釘選仍使用目前的目錄解析路徑，直到 [#4719](https://github.com/github/spec-kit/issues/4719) 中描述的獨立套件組工作新增精確版本的元件查詢為止。

`--json` 描述一個已安裝的擴充功能，並將單一 JSON 物件寫入 stdout。`<name>` 的比對方式與沒有 `--json` 時相同：先是擴充功能 ID，然後是唯一的顯示名稱，不分大小寫。此物件具有與對應的 `specify extension list --json` 項目相同的 `id`、`name`、`description`、`version`、`author`、`priority`、`enabled` 與 `source` 鍵。它以 `commands`、`templates`、`scripts` 與 `hooks` 陣列取代 `provides` 數量。Command、template 與 script 項目有 `name`、`description`（缺席時為 `""`）、`source`（`{"layer": "extension", "extensionId": "<id>"}`，即提供它的擴充功能；最上層的 `source` 是它安裝的來源）與 `sourcePath`（資訊清單的 `file`，相對於擴充功能目錄）；script 項目在資訊清單宣告時還會有 `runtimes`。擴充功能項目不帶 `strategy`，因為擴充功能提供的檔案永遠取代。每個 hook 項目有 `trigger`（hook 事件，例如 `after_tasks`）、`targetCommand`、`optional`（預設 `true`）與 `priority`（預設 `10`）。當某個事件多次宣告相同命令時，最後一個宣告勝出，如同 hook 被註冊時一樣。`--json` 不能與 `--versions` 組合（使用錯誤，結束代碼 2）。未安裝的擴充功能、含糊的名稱或遺失的專案，會將一個 `{"error":"..."}` 物件寫入 stderr 並以 1 結束；使用錯誤保留其結束代碼（通常為 2），與 `list --json` 相同。

## 更新擴充功能

```bash
specify extension update [<name>]
```

更新特定擴充功能，或在未給定名稱時更新所有已安裝的擴充功能。

隨附的擴充功能（例如 `agent-context` 與 `git`）沒有下載 URL；它們的更新從執行中的 spec-kit 版本隨附的副本安裝。當目錄公告的版本比你的 spec-kit 版本隨附的更新時，更新會被回報為需要先升級 spec-kit。

對於 `generic`，失敗的更新會從先前設定的 `--commands-dir` 位置以及目前位置，還原依雜湊擁有的呼叫，即使另一個整合現在已啟用也一樣。

## 啟用／停用擴充功能

```bash
specify extension enable <name>
specify extension disable <name>
```

停用擴充功能而不移除它。停用的擴充功能不會被載入，其命令也無法使用。僅有 hook 的擴充功能即使 generic 命令輸出設定遺失或無效，也可以安裝、啟用與停用；有命令的擴充功能仍需要有效設定。以 `enable` 重新啟用。

對於 `generic`，停用會移除依雜湊擁有的呼叫，即使輸出目錄已移動也一樣，但會保留新目錄中無關的同名檔案。

## 設定擴充功能優先順序

```bash
specify extension set-priority <name> <priority>
```

變更擴充功能的解析優先順序。當多個擴充功能提供同名命令時，優先順序數字最小的擴充功能優先。

## 目錄管理

擴充功能目錄控制 `search` 與 `add` 尋找擴充功能的位置。目錄依優先順序檢查（數字越小優先程度越高）。

### 信任模型：僅供探索 vs. 安裝來源

目錄有兩種，區別是**安全邊界**，不是限制：

- **安裝來源**（`install_allowed: true`）——你信任可從中安裝的目錄。內建的 `default`（官方）目錄是其中之一，你自己撰寫並審查的任何目錄也是。
- **僅供探索**目錄（`install_allowed: false`）——用於*尋找*擴充功能的可搜尋介面，但不可安裝。內建的 `community` 目錄是僅供探索的，且開箱即可用於 `search`；你不需新增它。

`community` 被刻意設為僅供探索，因為它是開放、未經審查的清單。讓其中一切都能一鍵安裝，意味著在沒有審查的情況下引入任意第三方程式碼。

> **不要將僅供探索的目錄翻轉為 `install_allowed`。**那會完全違背將探索與安裝分開的目的。從 `community` 找到的東西，有兩種正確的安裝方式：
>
> 1. **直接安裝單一經審查的擴充功能**，使用 `--from`（不需撰寫目錄）。從 `specify extension info <name>` 取得候選封存檔 URL，對於僅供探索的項目，它會列印「Candidate archive」URL。檢視該版本封存檔，然後安裝它：
>
>    ```bash
>    specify extension info <name>          # shows the candidate archive URL
>    specify extension add <name> --from <archive-url>
>    ```
>
>    在你審查前，將 URL 視為不受信任，它來自未經審查的目錄。
> 2. **彙整你自己的目錄**，由你控制與審查，並將*該*目錄標為 `install_allowed: true`，適用於你想要受治理、可重用的安裝來源時（例如供組織使用）。

### 列出目錄

```bash
specify extension catalog list
```

顯示堆疊中所有啟用中的目錄，包含其優先順序與安裝權限。

### 新增目錄

```bash
specify extension catalog add <url>
```

| 選項 | 說明 |
| ------------------------------------ | -------------------------------------------------- |
| `--name <name>`                      | 必要。目錄的唯一名稱              |
| `--priority <N>`                     | 優先順序（預設：10；數字越小優先程度越高）  |
| `--install-allowed / --no-install-allowed` | 將目錄標為受信任的安裝來源。只對你擁有並審查的目錄啟用；對於僅供探索的來源保持關閉（預設）。絕不對未經審查的公開目錄啟用。 |
| `--description <text>`               | 選用的說明                               |

將目錄新增到專案的 `.specify/extension-catalogs.yml`。

以相同設定重新新增同名目錄會成功，且不變更設定；不同的設定會被拒絕。

### 移除目錄

```bash
specify extension catalog remove <name>
```

從專案設定中移除目錄。

### 目錄解析順序

目錄依此順序解析（第一個符合者勝出）：

1. **環境變數**——`SPECKIT_CATALOG_URL` 覆寫所有目錄
2. **專案設定**——`.specify/extension-catalogs.yml`
3. **使用者設定**——`~/.specify/extension-catalogs.yml`
4. **內建預設值**——官方 `default` 目錄（允許安裝）+ `community` 目錄（僅供探索）

你擁有並審查的目錄的 `.specify/extension-catalogs.yml` 範例：

```yaml
catalogs:
  - name: "my-org-catalog"
    url: "https://example.com/catalog.json"
    priority: 5
    install_allowed: true
    description: "Our approved extensions"
```

## 擴充功能設定

大多數擴充功能在其安裝目錄中包含設定檔案：

```text
.specify/extensions/<ext>/
├── <ext>-config.yml           # Project config (version controlled)
├── <ext>-config.local.yml     # Local overrides (gitignored)
└── <ext>-config.template.yml  # Template reference
```

設定依此順序合併（優先順序最高者最後）：

1. **擴充功能預設值**（來自 `extension.yml`）
2. **專案設定**（`<ext>-config.yml`）
3. **本機覆寫**（`<ext>-config.local.yml`）
4. **環境變數**（`SPECKIT_<EXT>_*`）

若要為新安裝的擴充功能設定組態，請複製範本：

```bash
cp .specify/extensions/<ext>/<ext>-config.template.yml \
   .specify/extensions/<ext>/<ext>-config.yml
```

## 擴充功能執行時期事件

擴充功能可以透過在 `extension.yml` 中宣告最上層的 `events` 對應，來回應程式代理的生命週期事件：

```yaml
events:
  session_start:
    command: speckit.my-extension.initialize
  pre_tool_use:
    command: speckit.my-extension.validate
```

事件宣告與整合無關。Spec Kit 會重新整理每個已安裝且具事件功能的整合，每個整合會將標準事件名稱轉譯為其程式代理的原生事件設定。受支援的標準事件為 `session_start`、`pre_tool_use`、`post_tool_use`、`user_prompt_submit`、`stop` 與 `session_end`；每個整合可能只支援子集。

執行時期事件與擴充功能 hook 不同。事件回應程式代理的生命週期，並直接執行被參照命令範本的 `scripts` 項目。因此，被參照的命令必須提供可執行的指令碼；其 Markdown 指示不會傳送給程式代理。Hook 則是在 Spec Kit 命令（例如 `plan`、`tasks` 與 `implement`）之前或之後呈現擴充功能命令。

## 專案擴充功能與 Hook 設定

Spec Kit 將專案層級的擴充功能註冊與 hook 設定儲存在：

```text
.specify/extensions.yml
```

此檔案包含已安裝的擴充功能、全域設定，以及在 Spec Kit 命令之前或之後呈現的 hook。

```yaml
installed:
  - git
  - my-extension

settings:
  auto_execute_hooks: true

hooks:
  before_implement:
    - extension: git
      command: speckit.git.commit
      enabled: true
      optional: true
      priority: 10
      prompt: "Commit outstanding changes before implementation?"
      description: "Auto-commit before implementation"

  after_implement:
    - extension: my-extension
      command: speckit.my-extension.verify
      enabled: true
      optional: false
      priority: 5
      description: "Run verification after implementation"
```

### 設定欄位

最上層的 `installed` 清單記錄專案中安裝的擴充功能。`settings` 對應儲存專案全域的擴充功能設定，`hooks` 依事件分組 hook 註冊。

`auto_execute_hooks` 預設為 `true`，但目前保留不用，在 hook 被呈現或呼叫時不會被查詢。

每個 hook 項目支援以下欄位：

| 欄位 | 說明 |
| --- | --- |
| `extension` | 註冊 hook 的擴充功能 ID。 |
| `command` | 與 hook 關聯的擴充功能命令。 |
| `enabled` | Hook 是否啟用。`enabled: false` 的 hook 會被略過。 |
| `optional` | Hook 是否為選用。若為 `true`，hook 會連同其 `prompt` 一起呈現，且可略過；若為 `false`，hook 會作為自動 hook 發出（包含 `EXECUTE_COMMAND` 標記）。 |
| `priority` | Hook 的優先順序中繼資料。已註冊的 hook 項目使用 >= 1 的整數值；從資訊清單安裝的項目在未宣告優先順序時預設為 `10`。目前的命令範本依其設定的 YAML 順序呈現 hook，不依 `priority` 排序。 |
| `prompt` | 詢問是否執行選用 hook 時顯示的訊息。 |
| `description` | Hook 功能的人類可讀說明。 |
| `condition` | 由 `HookExecutor` 評估的選用運算式（使用 `config.<path>` 或 `env.<VAR>`，搭配 `is set`、`==` 或 `!=`）。目前的命令範本不評估條件，並略過具有非空條件的 hook。 |

Hook 事件名稱標識 hook 被呼叫的時機。它們通常使用 `before_<command>` 或 `after_<command>`，例如 `before_implement`、`after_implement`、`before_tasks` 與 `after_tasks`。

擴充功能資訊清單會在安裝期間拒絕無效的 hook 優先順序。對於既有的 `.specify/extensions.yml` 項目，`HookExecutor.get_hooks_for_event()` 以 `normalize_priority()` 排序：遺失的值、布林值、被 `int()` 拒絕的非數字值，以及小於 `1` 的值會退回 `10`；數字字串與有限浮點數會以 `int()` 強制轉換，而非有限浮點數不受支援，可能失敗而非退回。

`HookExecutor.get_hooks_for_event()` 依 `priority` 回傳 hook，較小的值在前。然而，目前的命令範本直接讀取 hook 清單，並依其設定的 YAML 順序呈現它們，而非使用優先順序排序。

## 常見問題

### 為什麼我用 `search` 找不到擴充功能？

檢查擴充功能名稱的拼寫。該擴充功能可能尚未發佈，或位於你尚未新增的目錄中。使用 `specify extension catalog list` 查看哪些目錄處於啟用狀態。

### 為什麼擴充功能命令沒有出現在我的 AI 程式代理中？

以 `specify extension list` 確認擴充功能已安裝且已啟用。若顯示已安裝，請重新啟動你的 AI 程式代理，它可能需要重新載入才能生效。

### 如何設定擴充功能組態？

複製擴充功能隨附的設定範本：

```bash
cp .specify/extensions/<ext>/<ext>-config.template.yml \
   .specify/extensions/<ext>/<ext>-config.yml
```

設定層級與覆寫的詳細資訊請參見[擴充功能設定](#extension-configuration)。

### 如何解決不相容的版本錯誤？

將 Spec Kit 更新到擴充功能所需的版本。

### 誰維護擴充功能？

大多數擴充功能由其各自的作者獨立建立與維護。Spec Kit 維護者不檢視、稽核、背書或支援擴充功能程式碼。安裝前請檢視擴充功能的原始碼，並自行斟酌使用。若特定擴充功能有問題，請聯絡其作者或在擴充功能的儲存庫提出 issue。
