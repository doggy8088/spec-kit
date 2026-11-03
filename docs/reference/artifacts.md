# 成品

**成品**是 Spec Kit 在專案中公開的任何命令、範本、指令碼或 hook，無論由哪一層貢獻，包括內建資產、已安裝的預設集、已安裝的擴充功能，或 `.specify/templates/overrides/` 中的專案本機覆寫。

`specify artifact` 命令群組是該清單的唯讀檢視介面。`specify preset resolve <name>` 回答「對於這個由預設集管理的名稱，哪個檔案勝出？」；`specify artifact` 回答「到底存在什麼，其背後的完整組成堆疊為何？」，包括沒有預設集觸及的內建成品。

目前所有子命令都需要 `--json`。省略它會以代碼 `2` 結束，並在 stderr 列印使用訊息；不會產生 stdout。文字呈現被刻意延後，因此下方的 JSON 形狀是唯一的合約，日後新增預設文字呈現器仍是非破壞性、附加性的變更。

## 列出成品

```bash
specify artifact list --json
```

| 選項 | 說明 |
| -------- | -------------------------------------------------------- |
| `--json` | 必要。以 JSON 陣列形式將清單輸出到 stdout。  |

列印每個可見成品的完整清單，每個 `(kind, name)` 配對一列，包含其組成 `stack`。具名成品依種類（`command`，然後 `template`，然後 `script`）與名稱排序。Hook 列在其後，依事件排序，然後依第一個宣告的優先順序排序。

```json
[
  {
    "id": "command:speckit.specify",
    "name": "speckit.specify",
    "kind": "command",
    "description": "Create or update the feature specification.",
    "stack": [
      {
        "id": "command:speckit.specify",
        "layer": null,
        "sourceId": null,
        "presetId": null,
        "presetName": null,
        "strategy": "replace",
        "active": true,
        "hidden": false,
        "manifestPath": null,
        "lookupId": null,
        "sourcePath": null
      }
    ]
  },
  {
    "id": "script:setup-plan",
    "name": "setup-plan",
    "kind": "script",
    "description": "Setup implementation plan for a feature.",
    "stack": [
      {
        "id": "script:setup-plan",
        "layer": null,
        "sourceId": null,
        "presetId": null,
        "presetName": null,
        "strategy": "replace",
        "active": true,
        "hidden": false,
        "manifestPath": null,
        "lookupId": null,
        "sourcePath": null
      }
    ]
  }
]
```

| 欄位 | 說明 |
| ------------- | ------------------------------------------------------------------------- |
| `id`          | `{kind}:{name}`，即 `artifact info` 接受作為參數的簡寫    |
| `name`        | 邏輯成品名稱（命令使用 `speckit.<stem>` 命名空間）        |
| `kind`        | `command`、`template`、`script`、`hook` 其中之一                             |
| `description` | 來自宣告它的最高優先層的說明，否則為 `""` |
| `stack`       | 此成品的組成堆疊，使用與 `artifact info` 相同的列形狀 |

內建成品永遠會出現，即使沒有任何東西覆寫它們。說明來自具有說明的最高優先層，隱藏內建命令的預設集或專案覆寫會回報自己的說明，而非被隱藏的內建文字。Skills（`.github/skills/**/SKILL.md`）被排除：它們是整合專屬輸出，不是隨附的資產家族。

## 成品資訊

```bash
specify artifact info <name> --json
```

| 選項 | 說明 |
| ---------------- | ------------------------------------------------------------------- |
| `--json`         | 必要。以 JSON 物件形式將組成堆疊輸出到 stdout。    |
| `--kind <kind>`  | 將查詢限縮為 `command`、`template`、`script` 或 `hook`      |

`<name>` 接受裸名稱（`speckit.specify`）或 `kind:name` 簡寫（`command:speckit.specify`）。當簡寫與 `--kind` 同時提供時，兩者必須一致。

```json
{
  "id": "command:speckit.specify",
  "name": "speckit.specify",
  "kind": "command",
  "description": "Create or update the feature specification.",
  "stack": [
    {
      "id": "command:speckit.specify",
      "layer": "preset",
      "sourceId": "compliance",
      "presetId": "compliance",
      "presetName": "Compliance Preset",
      "strategy": "replace",
      "active": true,
      "hidden": false,
      "manifestPath": ".specify/presets/compliance/preset.yml",
      "lookupId": "preset:compliance:command:speckit.specify",
      "sourcePath": ".github/skills/speckit-specify/SKILL.md"
    },
    {
      "id": "command:speckit.specify",
      "layer": null,
      "sourceId": null,
      "presetId": null,
      "presetName": null,
      "strategy": "replace",
      "active": false,
      "hidden": true,
      "manifestPath": null,
      "lookupId": null,
      "sourcePath": null
    }
  ]
}
```

最上層的 `id`、`name`、`kind`、`description` 與 `stack` 欄位，與 `artifact list --json` 上對應的列相符。

### 堆疊語意

對於 command、template 與 script 成品，`stack` 依解析優先順序排列：索引 `0` 是勝出層。Hook 堆疊是附加性的，而非以勝出者為基礎：多個項目可以同時啟用，其宣告順序在 [Hook 成品](#hook-artifacts) 中說明。每一列描述一個貢獻層：

| 欄位 | 說明 |
| -------------- | -------------------------------------------------------------------------------- |
| `id`           | `{kind}:{name}`，與來源無關的來回鍵，在同一個成品堆疊的每一列上都相同 |
| `layer`        | `project`、`preset` 或 `extension`；內建層為 `null`                    |
| `sourceId`     | 解析器使用的已安裝預設集或擴充功能 ID，當該層沒有來源時為 `null` |
| `presetId`     | 預設集套件目錄 id；在內建、`project` 與 `extension` 列上為 `null`       |
| `presetName`   | 當其資訊清單宣告了顯示名稱時為該名稱，否則為套件 id；當 `presetId` 為 `null` 時為 `null` |
| `strategy`     | `replace`、`wrap`、`prepend`、`append` 或 `additive`                              |
| `active`       | 該層是否啟用；對於具名成品，只有在索引 `0` 時為 `true` |
| `hidden`       | 當較低索引的 `replace` 層將此層從組成中切除時為 `true` |
| `manifestPath` | 宣告資訊清單的專案相對路徑，當不適用時為 `null`      |
| `lookupId`     | 確定性的 `{layer}:{sourceId}:{kind}:{name}` 識別碼，內建層為 `null` |
| `sourcePath`   | 支援該層的具體檔案的專案相對 POSIX 路徑，內建／合成層為 `null` |

`active` 與 `hidden` 是獨立標籤，不是相反。對於 command、template 與 script 成品，`active` 標識由既有 Spec Kit 層解析順序選出的最高優先層；它不驗證該層內容是否可讀取或組成。這保留了 `specify preset resolve` 的診斷行為，該命令即使內容組成之後產生警告，也會回報已發現的層鏈。組成策略（`wrap`、`prepend`、`append`）會將較低層保留在組成的輸出中，因此未啟用的層不一定被隱藏：只有第一個 `replace` 層以下的層會被標為 `hidden`。內建列沒有來源：`layer`、`sourceId` 與 `lookupId` 為 `null`，但 `id` 永遠有值，即使在內建列上也是如此。`id` 是來回鍵：`specify artifact info` 接受它作為輸入（例如 `specify artifact info command:speckit.specify --json`），且無論呼叫者傳入裸名稱還是 `id`，它都解析到同一個成品。

此處的**來源**是指單一成品層的起源：提供它的已安裝預設集或擴充功能、宣告它的資訊清單，以及支援它的具體檔案。查詢 ID 使用已安裝的預設集或擴充功能 ID，與既有解析器使用的身分與順序相符。已安裝 ID 是登錄／目錄名稱，可能與資訊清單內宣告的邏輯 `id` 不同。使用已安裝 ID 可讓獨立的已安裝目錄保持區分，即使其資訊清單宣告了相同的邏輯 ID。

專案本機覆寫帶有合成的 `project:_:{kind}:{name}` ID，而內建層沒有 `lookupId`。這些值標識成品堆疊的來源；它們不是成品來回鍵，來回請使用 `id` 搭配 `artifact info`。`manifestPath` 標識宣告資訊清單，`sourcePath` 在存在時標識支援該層的具體檔案。核心、專案覆寫與其他合成列可能回報 `sourcePath: null`。

## 貢獻查詢

```bash
specify artifact lookup <lookupId> --json
```

將資訊清單支援的堆疊 `lookupId` 解析為 Spec Kit 使用的已驗證預設集或擴充功能宣告。回傳的宣告反映正常的資訊清單處理，包括標準的擴充功能命令名稱、注入的預設值（例如空的別名清單）與小寫的預設集策略。它不是撰寫的 YAML 的逐字呈現。

這讓跨參照行為保留在 artifact 命令內：預設集與擴充功能命令、資訊清單與解析器回傳形狀都不變。

回應包含穩定的查詢 ID、提供者座標、資訊清單與來源路徑，以及 `contribution` 下的有效宣告。僅依慣例的貢獻與專案覆寫沒有起源資訊清單宣告，因此查詢會回傳 `{"error": "unknown contribution <lookupId>"}`，結束代碼為 `1`。內建列永遠沒有 `lookupId`。

### Hook 成品

Hook 列從標準預設集與擴充功能解析器包含的擴充功能中，投影 hook 宣告。來回簡寫為：

```text
hook:{encodedEventName}:{encodedTargetCommand}
```

例如，以下兩者選取同一個 hook 成品：

```bash
specify artifact info hook:before_specify:speckit.compliance.pre-check --json
specify artifact info before_specify:speckit.compliance.pre-check --kind hook --json
```

Hook 事件與目標命令元件使用 URL 引用的 UTF-8 百分比編碼：ASCII 字母、數字、`-`、`.`、`_` 與 `~` 保持字面，其餘所有位元組都會編碼。此編碼僅限於成品 `id`、`name` 與 `lookupId` 中的 hook 元件；hook 資訊清單、執行時期繫結、`eventName` 與 `targetCommand` 不變。例如，名為 `custom:after`、目標為 `/skill:speckit-test-ext-hello` 的事件，其成品 ID 為：

```text
hook:custom%3Aafter:%2Fskill%3Aspeckit-test-ext-hello
```

Hook 列新增三個最上層欄位：

| 欄位 | 說明 |
| --------------- | ------------------------------------------------------------------------------ |
| `eventName`     | 觸發宣告的 hook 事件                                       |
| `targetCommand` | hook 宣告呼叫的命令                                        |
| `registered`    | 當至少一個宣告堆疊項目具有已啟用的執行時期繫結時為 `true`  |

每個 hook 堆疊項目還包含宣告正規化後的 `priority` 與 `optional` 值。Hook 項目永遠使用 `strategy: "additive"` 與 `hidden: false`：多個擴充功能可以宣告並註冊相同的事件—命令配對，且每個已啟用的宣告都保持啟用。堆疊項目依 hook 優先順序排序，並以解析器的確定性宣告順序作為同分時的決斷依據。此順序描述宣告清單；它不保證同優先順序的 hook 在執行時期以相同順序執行。

對於 hook，`active` 回報的是來自 `.specify/extensions.yml` 的註冊狀態，不是條件評估。宣告只有在執行時期設定包含具有相同擴充功能 id、事件與命令的已啟用繫結時才啟用。條件在 hook 執行時稍後才評估。因此，遺失、格式錯誤或無法讀取的執行時期設定，會讓宣告以 `registered: false` 與 `active: false` 保持可見。

已宣告但未註冊的 hook，在其擴充功能被正常解析器包含時仍保持可見。在登錄中停用的擴充功能會被完全排除，與其其他貢獻一致。無效的個別擴充功能資訊清單同樣會被既有解析器省略，並可透過擴充功能檢查與驗證命令診斷。

Hook 查詢 ID 使用成品私有的 `{layer}:{sourceId}:hook:{encodedEventName}:{encodedTargetCommand}` 文法，其中 `sourceId` 是已安裝的提供者 ID。Hook 來源限於 `preset` 與 `extension` 層；hook 永遠不會收到內建／核心層。目前的資訊清單 API 公開擴充功能 hook 宣告，因此目前的列使用 `extension` 層。`preset` 層在 hook 識別碼文法中保留給預設集提供的 hook，無需將成品 ID 新增到預設集或擴充功能資訊清單 API。

## JSON 錯誤

失敗時，不會寫入任何內容到 stdout。單鍵 JSON 信封會寫入 stderr，行程以代碼 `1` 結束：

```json
{ "error": "unknown artifact command:nope" }
```

| 訊息 | 原因 |
| --------------------------------------------------- | ---------------------------------------------------------------- |
| `not a Spec Kit project: no .specify/ directory found` | 在已初始化專案外執行                             |
| `unknown artifact <name>`                           | 沒有成品符合所請求的名稱（以及給定時的 kind）     |
| `ambiguous artifact <name>: matches kinds [...]`    | 裸名稱符合多於一種 kind，請以 `--kind` 重新執行   |
| `artifact resolution failed`                        | 無法讀取擴充功能登錄，或有錯誤阻止成品層堆疊被蒐集 |

結束代碼 `2` 保留給使用錯誤，也就是遺失 `--json` 旗標或無效的 `--kind` 值，並在 stderr 發出純文字訊息，而非 JSON 信封。
