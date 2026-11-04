# 工作流程發佈指南

本指南說明如何將你的工作流程發佈到 Spec Kit 工作流程型錄，讓它能被 `specify workflow search` 發現。

## 目錄

1. [先決條件](#先決條件)
2. [準備你的工作流程](#準備你的工作流程)
3. [提交至型錄](#提交至型錄)
4. [驗證流程](#驗證流程)
5. [發行工作流程](#發行工作流程)
6. [最佳實務](#最佳實務)

---

## 先決條件

發佈工作流程之前，請確保你具備：

1. **有效的工作流程**：一個可運作、能通過 `specify workflow run` 驗證的 `workflow.yml`
2. **Git 儲存庫**：工作流程託管在 GitHub（或其他公開的 git 託管服務）
3. **文件**：README.md，包含說明、輸入與步驟圖
4. **授權**：開放原始碼授權檔案（MIT、Apache 2.0 等）
5. **版本管理**：在 `workflow.version` 欄位中使用語意化版本
6. **測試**：工作流程已在真實專案上測試

---

## 準備你的工作流程

### 1. 工作流程結構

將你的工作流程託管在具有以下結構的儲存庫中：

```text
your-workflow/
├── workflow.yml               # Required: Workflow definition
├── README.md                  # Required: Documentation
├── LICENSE                    # Required: License file
└── CHANGELOG.md               # Recommended: Version history
```

### 2. workflow.yml 驗證

驗證你的定義是否有效：

```yaml
schema_version: "1.0"

workflow:
  id: "your-workflow"              # Unique lowercase-hyphenated ID
  name: "Your Workflow Name"       # Human-readable name
  version: "1.0.0"                 # Semantic version
  author: "Your Name or Organization"
  description: "Brief description (one sentence)"
  integration: claude              # Default integration (optional)
  model: "claude-sonnet-4-20250514"         # Default model (optional)

requires:
  speckit_version: ">=0.6.1"
  integrations:
    any: ["claude", "gemini"]      # At least one required

inputs:
  spec:
    type: string
    required: true
    prompt: "Describe what you want to build"
  scope:
    type: string
    default: "full"
    enum: ["full", "backend-only", "frontend-only"]

steps:
  - id: specify
    command: speckit.specify
    input:
      args: "{{ inputs.spec }}"

  - id: review
    type: gate
    message: "Review the output."
    options: [approve, reject]
    on_reject: abort
```

**驗證檢核清單**：

- ✅ `id` 為小寫英數字加上連字號（允許單字元 ID）
- ✅ `version` 遵循語意化版本（X.Y.Z）
- ✅ `description` 簡潔
- ✅ 所有步驟 ID 都不重複
- ✅ 步驟類型有效：`command`、`prompt`、`shell`、`init`、`slot`、`gate`、`if`、`switch`、`while`、`do-while`、`fan-out`、`fan-in`、`workflow`
- ✅ 每種步驟類型都有必填欄位（例如 `if` 的 `condition`、`switch` 的 `expression`）
- ✅ 輸入類型有效：`string`、`number`、`boolean`
- ✅ 步驟 ID 不包含 `:`（保留給引擎產生的巢狀 ID，如 `parentId:childId`）

### 3. 本機測試

```bash
# Run with required inputs
specify workflow run ./workflow.yml --input spec="Build a user authentication system with OAuth support"

# Check validation
specify workflow info ./workflow.yml

# Resume after a gate pause
specify workflow resume <run_id>

# Check run status
specify workflow status <run_id>
```

### 4. 建立 GitHub 發行版

為你的工作流程版本建立 GitHub 發行版：

```bash
git tag v1.0.0
git push origin v1.0.0
```

原始 YAML 的 URL 會是：

```text
https://raw.githubusercontent.com/your-org/spec-kit-workflow-your-workflow/v1.0.0/workflow.yml
```

### 5. 從 URL 測試安裝

```bash
specify workflow add your-workflow
# (once published to catalog)
```

---

## 提交至型錄

### 了解型錄

Spec Kit 使用雙型錄系統：

- **`catalog.json`** — 官方、已驗證的工作流程（預設允許安裝）
- **`catalog.community.json`** — 社群貢獻的工作流程（預設僅供發現）

所有社群工作流程都應提交到 `catalog.community.json`。

### 1. Fork spec-kit 儲存庫

```bash
git clone https://github.com/YOUR-USERNAME/spec-kit.git
cd spec-kit
```

### 2. 將工作流程加入社群型錄

編輯 `workflows/catalog.community.json` 並加入你的工作流程。

> **⚠️ 項目必須依工作流程 ID 的字母順序排序**。將你的工作流程插入 `"workflows"` 物件中的正確位置。

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-04-10T00:00:00Z",
  "catalog_url": "https://raw.githubusercontent.com/github/spec-kit/main/workflows/catalog.community.json",
  "workflows": {
    "your-workflow": {
      "id": "your-workflow",
      "name": "Your Workflow Name",
      "description": "Brief description of what your workflow automates",
      "author": "Your Name",
      "version": "1.0.0",
      "url": "https://raw.githubusercontent.com/your-org/spec-kit-workflow-your-workflow/v1.0.0/workflow.yml",
      "repository": "https://github.com/your-org/spec-kit-workflow-your-workflow",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.15.0"
      },
      "tags": [
        "category",
        "automation"
      ],
      "created_at": "2026-04-10T00:00:00Z",
      "updated_at": "2026-04-10T00:00:00Z"
    }
  }
}
```

### 3. 提交 Pull Request

```bash
git checkout -b add-your-workflow
git add workflows/catalog.community.json
git commit -m "Add your-workflow to community catalog

- Workflow ID: your-workflow
- Version: 1.0.0
- Author: Your Name
- Description: Brief description
"
git push origin add-your-workflow
```

**Pull Request 檢核清單**：

```markdown
## Workflow Submission

**Workflow Name**: Your Workflow Name
**Workflow ID**: your-workflow
**Version**: 1.0.0
**Repository**: https://github.com/your-org/spec-kit-workflow-your-workflow

### Checklist
- [ ] Valid workflow.yml (passes `specify workflow info`)
- [ ] README.md with description, inputs, and step graph
- [ ] LICENSE file included
- [ ] GitHub release created with raw YAML URL
- [ ] Workflow tested end-to-end with `specify workflow run`
- [ ] All gate steps have clear review messages
- [ ] Input prompts are descriptive
- [ ] Added to workflows/catalog.community.json (alphabetical order)
```

---

## 驗證流程

維護者會檢查：

1. **定義驗證** — 有效的 `workflow.yml`、正確的結構描述
2. **步驟正確性** — 所有步驟類型都正確使用，沒有懸空的參照
3. **輸入設計** — 提示詞清晰，預設值與列舉合理
4. **文件** — README 清楚說明工作流程的功能與適用時機

這是對提交內容的**形式與完整性**的檢查，而不是安全審查 — 若某份提交的 `shell` 步驟內容在這次檢查中看起來明顯危險，維護者可能會拒絕它，但他們不會系統性地稽核、背書或支援工作流程的程式碼。請將每個工作流程，包括列在型錄中的，都視為不受信任，直到你審查過它的來源，包括 shell 的 `run` 與 `env` 欄位（參閱[安全性：shell 步驟會執行任意程式碼](#安全性shell-步驟會執行任意程式碼)）。

這些檢查通過後，工作流程便會出現在 `specify workflow search` 中。

---

## 發行工作流程

發行新版本時：

1. 更新 `workflow.yml` 中的 `version`
2. 更新 CHANGELOG.md
3. 標記並推送：`git tag v1.1.0 && git push origin v1.1.0`
4. 提交 PR，更新 `workflows/catalog.community.json` 中的 `version` 與 `url`

---

## 最佳實務

### 步驟設計

- **在決策點使用關卡** — 在每個主要產出之後放置 `gate` 步驟，讓使用者能在繼續之前審查
- **讓步驟保持聚焦** — 每個步驟應該只做一件事；寧可多用幾個步驟，也不要用複雜的單一步驟
- **提供清晰的關卡訊息** — 說明要審查什麼，以及核准／拒絕各代表什麼

### 輸入

- **使用具描述性的提示詞** — 執行工作流程時，`prompt` 欄位會顯示給使用者
- **設定合理的預設值** — 選擇性的輸入應該有適用於常見情況的預設值
- **以列舉加以限制** — 當有效值是一組固定的集合時，使用 `enum` 進行驗證
- **選用合適的類型** — 計數用 `number`，旗標用 `boolean`，名稱用 `string`

### Shell 步驟

- **Shell 以使用者的權限執行** — `shell` 步驟會直接執行本機命令；沒有能力沙箱。`requires` 是建議性的先決條件區塊（可辨識的鍵：`speckit_version`、`integrations`），**不是**執行期權限關卡 — 沒有 `requires.permissions` 這種東西。敏感命令請以 `gate` 步驟明確把關。
- **避免破壞性命令** — 不要在沒有透過關卡取得明確確認的情況下刪除檔案或目錄
- **為變數加上引號** — 在 shell 命令中使用正確的引號來處理空白
- **檢查結束代碼** — shell 步驟失敗會停止工作流程；請確保命令穩健

#### 安全性：shell 步驟會執行任意程式碼

工作流程的 `shell` 步驟會透過 `/bin/sh`（POSIX）或平台 shell 執行其 `run` 欄位。步驟與使用者的機器之間沒有沙箱：惡意或有缺陷的 `run` 區塊可以讀取環境變數、修改專案之外的檔案、外洩資料，或提升權限。

列在型錄中的工作流程在提交時會接受形式與完整性的檢查（參閱[驗證流程](#驗證流程)）；維護者可能會拒絕他們碰巧注意到的明顯危險提交，但這不是安全稽核 — 你應該將每次安裝都視為來自不受信任來源的程式碼執行，直到你讀過 `workflow.yml` 為止：

- **在安裝工作流程之前**，先擷取原始 YAML 並稽核每個 `shell` 步驟的 `run` 與 `env` 欄位，包括巢狀分支與扇出範本，以及它們參照的任何指令碼或資源。`specify workflow info <name>` 只顯示中繼資料（名稱、版本、輸入、步驟 ID／類型）；`specify workflow resolve <name>` 顯示層級／步驟的歸屬。兩者都不會顯示將會執行的完整命令與環境綁定。
- **稽核控制執行的環境值，即使是嚴格步驟也要**。`PATH` 可以選到不同的可執行檔；`PYTHONPATH`、`BASH_ENV`、`NODE_OPTIONS` 以及平台專屬的載入器設定，可以在不將任何內容插值到 `run` 的情況下選到程式碼或改變啟動行為。若步驟呼叫 Specify，像 `SPECKIT_WORKFLOW_CATALOG_URL` 這樣的型錄覆寫可以重新導向元件的發現或安裝。這些只是例子，不是完整清單。請讓這類值保持由作者審核過，或限制在已核准的受信任路徑／選項，而不是接受不受限制的輸入或代理輸出。嚴格模式不會過濾這些設定，也不會清除繼承的環境。
- **也要審查貢獻來源** — 在執行之前，納入被呼叫的工作流程、自訂步驟套件，以及使用中的覆蓋層 YAML。安裝套件組並不能取代對其工作流程元件的審核。在覆蓋層與被參照程式碼更新或變更後，請重複審查。
- **對取用動態資料的 shell 步驟，優先使用 `strict: true` 搭配 `env` 綁定**。嚴格模式會拒絕 `run` 中的工作流程運算式；`env` 值會被分開評估，且必須解析為字串。請在程式內部讀取它們，或在固定指令碼中使用加了引號的 POSIX 變數展開。不要將它們餵入 `eval`、另一個 shell 命令字串，或 shell 啟動變數。Windows `cmd.exe` 的 `%VAR%` 展開也可能引入 shell 語法；請改在程式內部讀取不受信任的值。嚴格模式是選擇加入的，而且不是沙箱；既有的非嚴格插值維持不變。
- **限制插值的值，而不只是為它們加上引號**（在 `run` 區塊中）：運算式會以原始文字被拼接進去，沒有自動跳脫，也沒有 shell 跳脫過濾器，因此加上引號不是安全邊界。請以 `enum`／允許清單將 `{{ inputs.something }}` 的替換限制在一組固定的值，讓惡意輸入無法注入 shell 語法；加上引號只應作為對已受限制值的正確性處理。
- **也要將前一個步驟的輸出視為不受信任** — 來自 `prompt` 步驟的 `{{ steps.*.output.* }}` 是 AI 產生的文字，上游內容可能影響它。當你無法限制代理輸出時，完全不要將它插值到 `run` 欄位；改以 `if`／`switch` 依它分支，或在非 shell 步驟中對它採取行動。
- **限制權限**：shell 步驟會繼承使用者的環境。需要提升存取權限（sudo、密鑰、GitHub 權杖）的工作流程，應該在 README 中明確指出，讓審查者能注意到這項要求。
- **作者**：若你的工作流程有在脈絡之外看起來有風險的 shell 步驟（刪除、網路呼叫、讀取憑證），請在你的 README 中記錄理由。維護者可能會拒絕 shell 步驟看起來明顯危險且不合理的提交，但這種抽查不是安全稽核 — 不要把型錄的接受當作安全訊號。

### 整合彈性

- **在工作流程層級設定 `integration`** — 使用 `workflow.integration` 欄位作為預設值
- **允許逐步覆寫** — 讓個別步驟在需要時指定不同的整合
- **記錄必要的整合** — 列出在 `requires.integrations` 中必須安裝哪些整合

### 運算式參照

- **只參照先前的步驟** — 像 `{{ steps.plan.output.file }}` 這樣的運算式，只有在 `plan` 在目前步驟之前執行過時才有效
- **使用 `default` 過濾器** — `{{ val | default('fallback') }}` 可避免因值遺失而失敗
- **讓運算式保持簡單** — 複雜的邏輯應該放在 shell 步驟中，而不是運算式中
