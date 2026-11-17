# 開發預設集

預設集會把自訂的文件範本、代理指示與指令碼，打包在一個含有 `preset.yml` 資訊清單的目錄中。只有輸出結構改變時，優先採用範本貢獻；流程本身需要不同的指示時，才覆寫命令。一次性的專案變更，專案本機覆寫可能比可散布的預設集更簡單。

## 從鷹架開始

請把儲存庫的[預設集鷹架](https://github.com/github/spec-kit/tree/main/presets/scaffold)複製到你能掌控的目錄：

```bash
cp -r presets/scaffold my-preset
```

請編輯其 ID、名稱、版本、描述、所需的 Spec Kit 版本與貢獻。移除未使用的範例，包括擴充功能命令覆寫的範例，以免不小心一併發佈。

典型的套件包含：

```text
my-preset/
  preset.yml
  README.md
  LICENSE
  CHANGELOG.md
  .presetignore
  templates/
    spec-addendum.md
  commands/
    speckit.specify.md
  scripts/
    my-helper.sh
```

只納入預設集實際使用的目錄。資訊清單的 `provides.templates` 清單包含全部三種貢獻，不只有文件範本。`file` 欄位可以指向非常規路徑；請用 `name` 來識別正在自訂的邏輯成品。

## 宣告貢獻

例如，在生效的規格範本後方附加一個可追溯性章節：

```yaml
schema_version: "1.0"

preset:
  id: "team-traceability"
  name: "Team Traceability"
  version: "1.0.0"
  description: "Adds team traceability requirements to specifications"
  author: "Example Team"
  repository: "https://github.com/example/team-traceability"
  license: "MIT"

requires:
  speckit_version: ">=0.9.0"

provides:
  templates:
    - type: "template"
      name: "spec-template"
      file: "templates/spec-addendum.md"
      description: "Traceability section"
      strategy: "append"

tags:
  - "traceability"
  - "governance"
```

標題要清楚，佔位符要明確。若命令參照了某個範本章節，請確認生效的範本確實包含該章節。只宣告需要的貢獻，讓預設集能與其他預設集組合。

使用 `wrap` 時，內容檔必須包含範本與命令用的 `{CORE_TEMPLATE}`，或指令碼用的 `$CORE_SCRIPT`。這些佔位符代表解析後的較低優先順序內容，不一定是未經修改的核心內容。附加、前面附加或包裝貢獻需要一個較低層的 `replace` 基礎；新的自成一體命令通常使用 `replace`。

預設集依賴擴充功能能力時，請在 `preset.yml` 中宣告擴充功能相依性。僅憑命名空間並不能建立相依性，也不會抑制註冊。警告行為與選用／版本受限的相依性，請參閱 API 參考文件。

## 用 `.presetignore` 排除開發檔案

請在來源根目錄、與 `preset.yml` 並列的位置，放置一份 UTF-8 編碼的 `.presetignore`，可含或不含位元組順序記號（BOM）：

```gitignore
.git/
.idea/
tests/
```

篩選適用於複製的本機目錄與解開的封存檔，包括經由 `preset update` 安裝的取代版本。沒有這個檔案時，所有來源檔案都會像以前一樣全部複製。安裝篩選不會使用 `.gitignore`，也沒有隱含的開發檔案排除規則。

模式採用 Git 風格的比對與正規化，與 `.extensionignore` 相同：

- 每行一個模式；空白行與 `#` 註解會被忽略。
- `*` 與 `?` 不會跨越目錄邊界；`**` 可以跨越。
- 結尾的 `/` 只比對目錄。開頭的 `/`，或出現在其他位置（結尾除外）的 `/`，會把模式錨定在來源根目錄。沒有這類斜線的模式會比對任意深度的名稱。
- 較後面的 `!` 模式會把符合項目重新納入。已排除的目錄不會被走訪，因此子項目在其父目錄被排除時無法重新納入。
- 空白字元會被修剪，反斜線會正規化為 `/`。非 ASCII 名稱請使用 UTF-8。

若要在 `docs/` 內只保留 `docs/api.md`，請排除其內容而非目錄本身：

```gitignore
docs/*
!docs/api.md
```

使用 `docs/`，再加上 `!docs/` 與 `!docs/api.md`，會把 `docs/` 底下的所有檔案重新納入，除非另有規則排除它們。

只有來源根目錄的 `.presetignore` 會加入規則；巢狀的忽略檔案不會被評估。若根目錄已有忽略檔案，任何深度的 `.presetignore` 檔案都會被排除，即使被否定也一樣。沒有根目錄忽略檔案時，巢狀的 `.presetignore` 檔案會原樣複製。

資訊清單與已宣告的資產檔案並無豁免。請確保 `preset.yml` 與所有必要的貢獻檔案都包含在內；把它們篩掉可能導致安裝不完整或無法使用。

目錄安裝器會在移除既有目的地之前先驗證忽略規則，包括透過 Python 管理器 API 強制取代的情況。無效的 UTF-8 與格式錯誤的模式會引發預設集驗證錯誤。CLI 各自的 `update` 命令仍是先移除、再呼叫 add；它不會預先檢查取代用的忽略檔案。

## 本地測試

請使用已初始化的測試專案，並採用預設集支援的整合與命令／技能模式。從該專案執行：

```bash
specify preset add --dev /path/to/my-preset --priority 5
specify preset info team-traceability
specify preset list
specify preset resolve spec-template
specify artifact info template:spec-template --json
```

請確認貢獻出現在產生的成品中，而不只是安裝目錄裡。對於命令覆寫，請檢查使用中整合所交付的命令或技能，並以該代理呼叫它。請測試相關的格式與模式，不要假設每個整合都使用相同的檔案配置。

請測試不同優先順序與相同優先順序下重疊的預設集、專案本機覆寫、移除／還原，以及缺少相依性或組合基礎的情況。若發佈可執行的指令碼，請測試其預期行為與失敗情形；PowerShell 指令碼必須以 Windows PowerShell 5.1 為目標。不要期待僅靠啟用、停用或優先順序變更，就能重寫已交付的命令或技能檔案。

編輯開發來源後，請安裝一份全新的副本。`--dev` 不會監看或連結來源：

```bash
specify preset remove team-traceability
specify preset add --dev /path/to/my-preset --priority 5
```

`update --dev` 這個替代做法刻意採用先移除、再新增的語義；若新來源無效，可能導致預設集被移除後無法裝回。發佈前也請測試封存檔安裝，特別是打包方式會改變目錄配置時。

## 另請參閱

- [預設集總覽](overview.md)
- [CLI 參考文件](cli.md)
- [資訊清單與組合 API](api.md)
- [型錄](catalogs.md)
- [發布預設集](publishing.md)
