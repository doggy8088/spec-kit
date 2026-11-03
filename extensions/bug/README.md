# 缺陷分診工作流程擴充功能

Spec Kit 的三步驟缺陷分診工作流程：評估、修復與驗證。每個缺陷各自放在 `.specify/bugs/<slug>/` 下的一個目錄中，每個階段各有一份 Markdown 報告。

## 概覽

此擴充功能提供一套有明確主張、可重複執行的缺陷工作流程，任何 AI 程式代理都能驅動：

1. **評估**——閱讀缺陷報告（貼上的文字或 URL），判斷它是否為真正的缺陷，找出疑似相關的程式碼路徑，並提出修復方案。
2. **修復**——套用提出的修復方案，並精確記錄更動了什麼。
3. **測試**——重新執行重現步驟與任何新增的測試，然後記錄驗證結果。

三個階段透過單一缺陷專屬目錄中的三個 Markdown 檔案溝通：

```
.specify/bugs/<slug>/
├── assessment.md   # written by speckit.bug.assess
├── fix.md          # written by speckit.bug.fix
└── test.md         # written by speckit.bug.test
```

## 命令

| 命令 | 說明 | 輸出 |
|---------|-------------|--------|
| `speckit.bug.assess` | 對照程式碼庫分診缺陷報告（貼上的文字或 URL）。 | `.specify/bugs/<slug>/assessment.md` |
| `speckit.bug.fix` | 套用評估所提出的修復方案。 | `.specify/bugs/<slug>/fix.md` |
| `speckit.bug.test` | 驗證修復結果，並記錄驗證報告。 | `.specify/bugs/<slug>/test.md` |

## Slug 慣例

*slug* 是 `.specify/bugs/` 下每個缺陷的目錄名稱，也是三個命令唯一共用的識別代號。

- **使用者提供**：使用者想要的任何形式，標準化為小寫 kebab-case（例如 `login-timeout`、`cve-2026-001`、`oauth-redirect-500`）。標準化後，slug 原樣保留——不會自動附加時間戳記或編號。
- **主動詢問**：在互動式使用情境下，若未提供 slug，`speckit.bug.assess` 會主動詢問，並建議一個依缺陷摘要衍生的 kebab-case 預設值。
- **自動產生**：當沒有人員可以回答時，代理會自行產生 slug。產生的 slug **必須**對應到唯一的目錄——若 `.specify/bugs/<slug>/` 已存在，代理會附加所需的最短消歧義後綴（`-2`、`-3`、……）或簡短日期（`-20260605`）。既有的缺陷目錄絕不會被覆寫。

## 安裝

```bash
# Install the bundled bug extension (no network required)
specify extension add bug
```

## 停用

```bash
# Disable the bug extension
specify extension disable bug

# Re-enable it
specify extension enable bug
```

## 典型流程

```bash
# 1. Triage a bug from a pasted stack trace
/speckit.bug.assess "TypeError: cannot read properties of undefined (reading 'token') at /auth/callback"

# 2. Triage a bug from a GitHub issue URL
/speckit.bug.assess https://github.com/example/repo/issues/1234 slug=callback-token

# 3. Apply the proposed fix
/speckit.bug.fix slug=callback-token

# 4. Validate the fix
/speckit.bug.test slug=callback-token
```

## 防護規則

- `speckit.bug.assess` 與 `speckit.bug.test` **絕不修改原始碼**。它們只讀取儲存庫，且僅在 `.specify/bugs/<slug>/` 內寫入。
- `speckit.bug.fix` 是唯一會編輯原始碼的命令，且只會更動評估中列出的檔案，除非新證據要求擴大範圍（此情況會記錄在 `fix.md` 的 **Deviations from Assessment** 底下）。
- 任何命令都不會在未經明確確認的情況下覆寫既有的報告檔案；在自動模式下，它們會拒絕覆寫，並改選一個新的唯一 slug。
- 判定與驗證結果絕不誇大：未實際執行的重現，會回報為 `partial` 或 `not-run`，而非 `verified`。

## Hooks

此擴充功能不註冊自己的 hooks。這三個命令一律由使用者明確呼叫，但會公開生命週期事件供其他擴充功能使用：

| 命令 | 執行前事件 | 執行後事件 |
|---------|--------------|-------------|
| `speckit.bug.assess` | `before_bug_assess` | `after_bug_assess` |
| `speckit.bug.fix` | `before_bug_fix` | `after_bug_fix` |
| `speckit.bug.test` | `before_bug_test` | `after_bug_test` |

前置 hooks 在 slug 解析與前置條件完成後、正式執行前運行。對評估而言，缺陷目錄在前置 hook 運行前就已存在。後置 hooks 則在 `assessment.md`、`fix.md` 或 `test.md` 寫入後、回報完成前運行。若貼上的報告無法理解，會維持既有的提早停止行為：不產生評估報告、不運行後置 hooks，也不回報完成。前置 hooks 在資料擷取前運行，因此當一份報告被拒絕時，它們可能已經運行過；作為前置條件的缺陷目錄不會被移除。Hooks 是在同一個工作階段中運行的提示詞；它們會重用對話中已解析的 `BUG_SLUG` 與 `BUG_DIR`（後置 hooks 還會重用已寫入的報告），且不會注入任何變數。

舉例來說，已安裝的 intake 擴充功能可以在 `.specify/extensions.yml` 中註冊一個 hook：

```yaml
hooks:
  before_bug_assess:
    - extension: intake
      command: speckit.intake.collect
      enabled: true
      optional: false
      description: Collect evidence in the resolved bug directory
```

強制 hooks 會被呼叫並等待其完成；選用 hooks 則會呈現給使用者決定是否運行。已停用的 hooks，以及帶有非空條件的 hooks，會被命令範本略過。未註冊任何 hooks 時，工作流程照常進行。共用的 hook 契約請參閱[擴充功能 API 參考文件](https://github.github.io/spec-kit/extensions/api.html#hook-events)。
