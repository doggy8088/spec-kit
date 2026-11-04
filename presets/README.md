# 預設集

預設集是可堆疊、依優先級排序的範本與命令覆寫集合，適用於 Spec Kit。它們讓你能自訂規格驅動開發工作流程所產生的產出物（規格、計畫、任務、檢核清單、憲章），以及引導 LLM 建立這些產出物的命令 — 而無需 fork 或修改核心檔案。

## 運作方式

當 Spec Kit 需要一個範本（例如 `spec-template`）時，它會走訪一個解析堆疊：

1. `.specify/templates/overrides/` — 專案本機的一次性覆寫
2. `.specify/presets/<preset-id>/templates/` — 已安裝的預設集（依優先級排序）
3. `.specify/extensions/<ext-id>/templates/` — 擴充功能提供的範本
4. `.specify/templates/` — Spec Kit 隨附的核心範本

若未安裝任何預設集，就使用核心範本 — 與預設集存在之前的行為完全相同。

範本解析發生在**執行期** — 雖然預設集檔案會在安裝時複製到 `.specify/presets/<id>/`，Spec Kit 會在每次範本查詢時走訪解析堆疊，而不是將範本合併到單一位置。

`constitution-template` 遵循相同的執行期模型。專案初始化會植入
`.specify/memory/constitution.md` 一次，讓下游命令永遠有一份憲章可讀。
在此之後，安裝、移除、啟用、停用或重新排序預設集的優先級，都不會改寫
即時憲章。每次 `/constitution` 執行都會解析目前組成的 `constitution-template`，
再將既有的專案值與修訂套用到該骨架上。

有意讓預設集堆疊變更重新整理一份未經變更之已產生憲章的團隊，可以
安裝內建的 `constitution-sync` 預設集。除了其命令期傳播行為外，它還會還原受保護的安裝期具體化；已撰寫的憲章仍受保護。

如需詳細的解析與命令註冊流程，請參閱 [ARCHITECTURE.md](ARCHITECTURE.md)。

## 命令覆寫

預設集也可以覆寫引導 SDD 工作流程的命令。範本定義會產生*什麼*（規格、計畫、憲章）；命令定義 LLM *如何*產生它們（逐步指示）。

與範本不同，命令覆寫是在**安裝期**套用的。當預設集包含 `type: "command"` 項目時，命令會被註冊到所有偵測到的代理目錄（`.claude/commands/`、`.gemini/commands/` 等），並使用正確格式（Markdown 或帶有適當參數佔位符的 TOML）。當預設集被移除時，已註冊的命令會被清理。

## 快速入門

```bash
# 搜尋可用的預設集
specify preset search

# 從型錄安裝預設集
specify preset add healthcare-compliance

# 從本機目錄安裝（供開發使用）
specify preset add --dev ./my-preset

# 以指定優先級安裝（數字越小 = 優先級越高）
specify preset add healthcare-compliance --priority 5

# 列出已安裝的預設集
specify preset list

# 查看某個名稱解析到哪個範本
specify preset resolve spec-template

# 取得預設集的詳細資訊
specify preset info healthcare-compliance

# 移除預設集
specify preset remove healthcare-compliance
```

## 堆疊預設集

多個預設集可以同時安裝。`--priority` 旗標控制當兩個預設集提供同一個範本時由誰勝出（數字越小 = 優先級越高）：

```bash
specify preset add enterprise-safe --priority 10      # 基礎層
specify preset add healthcare-compliance --priority 5  # 覆寫 enterprise-safe
specify preset add pm-workflow --priority 1            # 覆寫一切
```

預設集**預設是覆寫**，而不是合併。若兩個預設集都以預設的 `replace` 策略提供 `spec-template`，優先級數字最小的那個會完全勝出。不過，預設集可以使用**組成策略**來擴充內容，而不是取代內容。

### 組成策略

預設集可以為每個範本宣告一個 `strategy`，控制內容如何組合。`name` 欄位指出要與優先級堆疊中哪個範本組成，而 `file` 指向實際的內容檔案（可以與慣例路徑 `templates/<name>.md` 不同）：

```yaml
provides:
  templates:
    - type: "template"
      name: "spec-template"
      file: "templates/spec-addendum.md"
      strategy: "append"        # adds content after the core template
```

| 策略 | 說明 |
|----------|-------------|
| `replace`（預設） | 完全取代優先級較低的範本 |
| `prepend` | 將內容放在解析出的較低優先級範本**之前**，以空行分隔 |
| `append` | 將內容放在解析出的較低優先級範本**之後**，以空行分隔 |
| `wrap` | 內容包含 `{CORE_TEMPLATE}` 佔位符（指令碼則為 `$CORE_SCRIPT`），會被較低優先級的內容取代 |

**支援的組合：**

| 類型 | `replace` | `prepend` | `append` | `wrap` |
|------|-----------|-----------|----------|--------|
| **template** | ✓（預設） | ✓ | ✓ | ✓ |
| **command** | ✓（預設） | ✓ | ✓ | ✓ |
| **script** | ✓（預設） | — | — | ✓ |

多個組成中的預設集會遞迴串連。例如，一個使用 `prepend` 的安全性預設集加上一個使用 `append` 的合規預設集，將產生：安全性標頭 + 核心內容 + 合規頁尾。

## 型錄管理

預設集是透過型錄被發現的。預設情況下，Spec Kit 使用官方與社群型錄：

> [!NOTE]
> 社群預設集由其各自的作者獨立建立與維護。維護者只驗證型錄項目是否完整且格式正確 — 他們**不會審查、稽核、背書或支援預設集程式碼本身**。安裝前請先審查預設集原始碼，並自行斟酌使用。

```bash
# 列出使用中的型錄
specify preset catalog list

# 新增自訂型錄
specify preset catalog add https://example.com/catalog.json --name my-org --install-allowed

# 移除型錄
specify preset catalog remove my-org
```

## 建立預設集

請參閱 [scaffold/](scaffold/)，那裡有一份可複製來建立你自己預設集的骨架。

1. 將 `scaffold/` 複製到新目錄
2. 用你預設集的中繼資料編輯 `preset.yml`
3. 在 `templates/` 中新增或取代範本
4. 以 `specify preset add --dev .` 在本機測試
5. 以 `specify preset resolve spec-template` 驗證

## 環境變數

| 變數 | 說明 | 預設值 |
|----------|-------------|---------|
| `SPECKIT_PRESET_CATALOG_URL` | 以單一 URL 覆寫完整的型錄堆疊（取代所有預設值） | 內建預設堆疊 |
| `GH_TOKEN` / `GITHUB_TOKEN` | 用於向 GitHub 託管 URL（`raw.githubusercontent.com`、`github.com`、`api.github.com`、`codeload.github.com`）發出已驗證請求的 GitHub 權杖。當你的型錄 JSON 或預設集 ZIP 託管在私人 GitHub 儲存庫時必填。 | 無 |

### 範例：使用私人 GitHub 託管的型錄

```bash
# 以權杖驗證（gh CLI、PAT，或 CI 中的 GITHUB_TOKEN）
export GITHUB_TOKEN=<redacted>

# 搜尋透過 `specify preset catalog add` 新增的私人型錄
specify preset search my-template

# 從私人型錄安裝
specify preset add my-template
```

權杖會自動附加到以 GitHub 網域為目標的請求。非 GitHub 的型錄 URL 一律在不帶憑證的情況下擷取。

## 設定檔

| 檔案 | 範圍 | 說明 |
|------|-------|-------------|
| `.specify/preset-catalogs.yml` | 專案 | 這個專案的自訂型錄堆疊 |
| `~/.specify/preset-catalogs.yml` | 使用者 | 所有專案的自訂型錄堆疊 |

## 未來考量

下列增強功能正在考量納入未來的版本：

- **結構化合併策略** — 解析 Markdown 區段，達到逐區段的細粒度（例如「只取代 ## Security」）。
- **衝突偵測** — `specify preset lint`／`specify preset doctor`，用於偵測組成衝突。
