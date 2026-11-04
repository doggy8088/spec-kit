# 預設集發佈指南

本指南說明如何將你的預設集發佈到 Spec Kit 預設集型錄，讓它能被 `specify preset search` 發現。

## 目錄

1. [先決條件](#先決條件)
2. [準備你的預設集](#準備你的預設集)
3. [提交至型錄](#提交至型錄)
4. [驗證流程](#驗證流程)
5. [發行工作流程](#發行工作流程)
6. [最佳實務](#最佳實務)

---

## 先決條件

發佈預設集之前，請確保你具備：

1. **有效的預設集**：一個可運作的預設集，附有有效的 `preset.yml` 資訊清單
2. **Git 儲存庫**：預設集託管在 GitHub（或其他公開的 git 託管服務）
3. **文件**：一份限定於該預設集的 README.md，說明如何使用**這個預設集**，並包含一條有效的 `specify preset add ...` 安裝命令（參閱[使用 README 要求](#使用-readme-要求)）
4. **授權**：開放原始碼授權檔案（MIT、Apache 2.0 等）
5. **版本管理**：語意化版本（例如 1.0.0）
6. **測試**：預設集已在真實專案上以 `specify preset add --dev` 測試

---

## 準備你的預設集

### 1. 預設集結構

確保你的預設集遵循標準結構：

```text
your-preset/
├── preset.yml                 # Required: Preset manifest
├── README.md                  # Required: Documentation
├── LICENSE                    # Required: License file
├── CHANGELOG.md               # Recommended: Version history
│
├── templates/                 # Template overrides
│   ├── spec-template.md
│   ├── plan-template.md
│   └── ...
│
└── commands/                  # Command overrides (optional)
    └── speckit.specify.md
```

若要建立新的預設集，請從 [scaffold](scaffold/) 開始。

### 2. preset.yml 驗證

驗證你的資訊清單是否有效：

```yaml
schema_version: "1.0"

preset:
  id: "your-preset"               # Unique lowercase-hyphenated ID
  name: "Your Preset Name"        # Human-readable name
  version: "1.0.0"                # Semantic version
  description: "Brief description (one sentence)"
  author: "Your Name or Organization"
  repository: "https://github.com/your-org/spec-kit-preset-your-preset"
  license: "MIT"

requires:
  speckit_version: ">=0.1.0"      # Required spec-kit version
  extensions:                      # Optional: extensions this preset needs
    - "companion-extension"

provides:
  templates:
    - type: "template"
      name: "spec-template"
      file: "templates/spec-template.md"
      description: "Custom spec template"
      replaces: "spec-template"

tags:                              # 2-5 relevant tags
  - "category"
  - "workflow"
```

**驗證檢核清單**：

- ✅ `id` 為小寫且只用連字號（沒有底線、空白或特殊字元）
- ✅ `version` 遵循語意化版本（X.Y.Z）
- ✅ `description` 簡潔（200 字元以內）
- ✅ `repository` URL 有效且公開
- ✅ 所有範本與命令檔案都存在於預設集目錄中
- ✅ 範本名稱為小寫且只用連字號
- ✅ 命令名稱使用點記法（例如 `speckit.specify`）
- ✅ 標籤為小寫且具描述性

#### 宣告擴充功能相依性

若你的預設集覆寫的命令會呼叫某個擴充功能，請在
`requires.extensions` 中宣告它。沒有該擴充功能時，預設集仍會安裝，而
覆寫會落回核心工作流程，所以不會出錯 — 只是該功能
會默默地比使用者預期的少做一些事。宣告相依性能讓
`specify preset add` 明確指出這一點，並說明如何解決。

使用裸 ID，或在需要版本條件或選擇性
相依性時使用對應形式：

```yaml
requires:
  speckit_version: ">=0.9.0"
  extensions:
    - "companion-extension"              # required, any version
    - id: "other-extension"
      version: ">=1.2.0,<2"              # optional PEP 440 specifier
      required: false                    # optional, defaults to true
```

`version` 接受任何 PEP 440 指定詞，不只是下限 — 上限
（`<2`）、精確釘選（`==1.2.0`）與排除（`!=1.3.0`）都可以使用。

注意事項：

- 這個欄位是選擇性的。什麼都不宣告的預設集，行為與以往完全相同。
- 缺失、過舊、已停用或版本不符的相依性會產生**警告，而不是失敗** — 安裝仍會成功。
- 已停用的擴充功能視為未滿足；其檔案被移除後註冊表項目仍殘留的擴充功能也是如此。解析會兩者都略過，因此預設集就如同擴充功能不存在時一樣不起作用。
- 警告會針對缺失、過舊與已停用的情況指出確切的命令。對於版本不符，它會說明需要滿足的條件，而不是指出命令，因為 `specify extension update` 只能向前移到型錄發行版，無法滿足上限、釘選或降級。
- 無法解析的已記錄版本會被視為不可比較，而不是不符，因此註冊表版本顯示為 `unknown` 的擴充功能，不會被回報為未通過一個它從未被評估過的條件。
- 存在於磁碟上但不在註冊表中的擴充功能視為已滿足。解析會接納未註冊的目錄，因此預設集可以運作，為它發出警告會是誤報 — 不過由於沒有已記錄的版本，無法以 `version` 條件對它進行檢查。
- `required: false` 表示這是增強功能但選擇性的擴充功能，永遠不會被警告。
- 請在 `preset.yml` 中宣告它，而不只是寫在型錄項目裡。型錄在 `--dev` 與 `--from <url>` 安裝時不會被查詢，因此資訊清單是每條安裝路徑上都存在的唯一副本。

### 3. 本機測試

```bash
# Install from local directory
specify preset add --dev /path/to/your-preset

# Verify templates resolve from your preset
specify preset resolve spec-template

# Verify preset info
specify preset info your-preset

# List installed presets
specify preset list

# Remove when done testing
specify preset remove your-preset
```

若你的預設集包含命令覆寫，請確認它們出現在代理目錄中：

```bash
# Check Claude commands (if using Claude)
ls .claude/commands/speckit.*.md

# Check Copilot commands (if using Copilot)
ls .github/agents/speckit.*.agent.md

# Check Gemini commands (if using Gemini)
ls .gemini/commands/speckit.*.toml
```

### 4. 建立 GitHub 發行版

為你的預設集版本建立 GitHub 發行版：

```bash
# Tag the release
git tag v1.0.0
git push origin v1.0.0
```

發行封存檔的 URL 會是：

```text
https://github.com/your-org/spec-kit-preset-your-preset/archive/refs/tags/v1.0.0.zip
```

### 5. 從封存檔測試安裝

```bash
specify preset add --from https://github.com/your-org/spec-kit-preset-your-preset/archive/refs/tags/v1.0.0.zip
```

### 使用 README 要求

型錄的 `documentation` 欄位必須指向一份說明如何使用
**這個預設集**的 README — 而不是為更廣泛的框架或獨立 CLI 做的產品推銷。

提交工作流程會**機械式地強制執行**：所連結的 README 必須是託管在 GitHub 的
URL，其路徑以 `README.md` 結尾、能解析到可讀的檔案，且包含至少一條
有效的 `specify preset add ...` 命令。其餘項目（在 monorepo 中優先使用限定於預設集的 README、
涵蓋最低限度的結構）是人工審查者會檢查的期望 —
請遵循它們，以免你的提交被退回修改。

- **將 `documentation` 指向限定於預設集的 README。**在預設集
  位於子目錄（例如 `presets/<id>/`）的 monorepo 中，請連結該目錄內的 README
  （`presets/<id>/README.md`），而不是儲存庫根目錄的 README。根目錄 README
  通常是行銷／概覽頁面；型錄應該呈現的是預設集的用法。關鍵
  要求是這份 README 能在 `documentation` URL 取得，讓使用者能在下載發行成品*之前*先
  閱讀它 — 同一個檔案也可以同時隨附在
  發行 ZIP 裡面，這沒有問題。
- **包含一條有效的 Spec Kit CLI 安裝命令** *（強制執行）*。所連結的 README 必須
  包含至少一條 `specify preset add ...` 呼叫。最好使用
  型錄安裝形式，其 URL 與你的下載 URL 相符：

  ```bash
  # <download-url> is the same URL you submit as the catalog Download URL —
  # either the tag archive or a release asset, e.g.:
  specify preset add --from https://github.com/<org>/<repo>/archive/refs/tags/vX.Y.Z.zip
  specify preset add --from https://github.com/<org>/<repo>/releases/download/vX.Y.Z/<id>-X.Y.Z.zip
  ```

  `specify preset add <id>` 與 `specify preset add --dev <path>` 也被接受，但
  `--from <download-url>` 形式是最能清楚表明這份 README 記錄的正是這個
  預設集發行版的訊號。
- **涵蓋最低限度的結構**，讓讀者能判斷這個預設集是否適合：
  - 這個預設集的功能／它提供什麼
  - 使用 Spec Kit CLI 語法的安裝命令（見上）
  - 適用時機／不適用時機

若提交所連結的 README 缺少有效的 `specify preset add ...` 命令，將**無法通過
驗證**（工作流程檢查 2d），在修正之前不會被加入。

---

## 提交至型錄

### 了解型錄

Spec Kit 使用雙型錄系統：

- **`catalog.json`** — 官方、已驗證的預設集（預設允許安裝）
- **`catalog.community.json`** — 社群貢獻的預設集（預設僅供發現）

所有社群預設集都應提交到 `catalog.community.json`。

### 1. Fork spec-kit 儲存庫

```bash
git clone https://github.com/YOUR-USERNAME/spec-kit.git
cd spec-kit
```

### 2. 將預設集加入社群型錄

編輯 `presets/catalog.community.json` 並加入你的預設集。

> **⚠️ 項目必須依預設集 ID 的字母順序排序。**將你的預設集插入 `"presets"` 物件中的正確位置。

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-03-10T00:00:00Z",
  "catalog_url": "https://raw.githubusercontent.com/github/spec-kit/main/presets/catalog.community.json",
  "presets": {
    "your-preset": {
      "name": "Your Preset Name",
      "id": "your-preset",
      "description": "Brief description of what your preset provides",
      "author": "Your Name",
      "version": "1.0.0",
      "download_url": "https://github.com/your-org/spec-kit-preset-your-preset/archive/refs/tags/v1.0.0.zip",
      "sha256": "OPTIONAL: SHA-256 hex digest of the archive above; verified before install",
      "repository": "https://github.com/your-org/spec-kit-preset-your-preset",
      "documentation": "https://github.com/your-org/spec-kit-preset-your-preset/blob/main/README.md",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "provides": {
        "templates": 3,
        "commands": 1
      },
      "tags": [
        "category",
        "workflow"
      ],
      "created_at": "2026-03-10T00:00:00Z",
      "updated_at": "2026-03-10T00:00:00Z"
    }
  }
}
```

### 3. 更新社群預設集表格

將你的預設集加入文件站 `docs/community/presets.md` 的社群預設集表格：

```markdown
| Your Preset Name | Brief description of what your preset does | N templates, M commands[, P scripts] | — | [repo-name](https://github.com/your-org/spec-kit-preset-your-preset) |
```

依預設集**名稱**（表格的第一欄）的字母順序插入你那一列。

### 4. 提交 Pull Request

```bash
git checkout -b add-your-preset
git add presets/catalog.community.json docs/community/presets.md
git commit -m "Add your-preset to community catalog

- Preset ID: your-preset
- Version: 1.0.0
- Author: Your Name
- Description: Brief description
"
git push origin add-your-preset
```

**Pull Request 檢核清單**：

```markdown
## Preset Submission

**Preset Name**: Your Preset Name
**Preset ID**: your-preset
**Version**: 1.0.0
**Repository**: https://github.com/your-org/spec-kit-preset-your-preset

### Checklist
- [ ] Valid preset.yml manifest
- [ ] Usage README with a valid `specify preset add ...` command, linked from `documentation` (preset-scoped README recommended for monorepos)
- [ ] LICENSE file included
- [ ] GitHub release created
- [ ] Preset tested with `specify preset add --dev`
- [ ] Templates resolve correctly (`specify preset resolve`)
- [ ] Commands register to agent directories (if applicable)
- [ ] Commands match template sections (command + template are coherent)
- [ ] Added to presets/catalog.community.json
- [ ] Added row to docs/community/presets.md table
```

---

## 驗證流程

### 提交後會發生什麼

1. 當 issue 是透過預設集提交表單開啟時，GitHub 會套用 `triage-must-have` 判定。這個接收自動化專屬於預設集提交，不會改變其他 issue 的人工分類準則。
2. 維護者在 issue 分類時審查該 issue，並套用獨立的 `preset-submission` 標籤，這會啟動自動化的型錄驗證。在這個公開儲存庫中，貢獻者無法自行套用該標籤，因此沒有什麼需要標記或重新請求的 — issue 只需在分類中等待。
3. 自動化工作流程會驗證提交，並在驗證通過時，於一份草稿 pull request 中更新 `presets/catalog.community.json` 與 `docs/community/presets.md`
4. 維護者審查產生的 pull request，並在核准時合併
5. 你的預設集變得可透過 `specify preset search` 被發現

### 維護者檢查什麼

1. **資訊清單驗證** — 有效的 `preset.yml`，所有檔案都存在
2. **範本品質** — 範本有用且結構良好
3. **命令一致性** — 命令參照的區段確實存在於範本中
4. **安全性** — 沒有惡意內容，檔案操作安全
5. **文件** — 從 `documentation` 連結的 README 說明如何使用*這個*預設集，並包含一條有效的 `specify preset add ...` 命令

> **審查者註記：**工作流程可以機械式地檢查*結構*（所連結的 README
> 能解析，且包含有效的 `specify preset add ...` 片段；當該片段使用
> `--from <url>` 形式時，其 URL 必須與提交的下載 URL 完全相符 — 其他被接受的
> 形式如 `specify preset add <id>` 根本不會參照下載 URL）。至於
> README 是否真的記錄了*這個*預設集，部分屬於內容判斷，因此人工審查者
> 在核准前仍應確認所連結的文件不只是一個導向獨立產品或 CLI 的漏斗。

驗證完成後，會設定 `verified: true`，預設集便會出現在 `specify preset search` 中。

---

## 發行工作流程

發行新版本時：

1. 更新 `preset.yml` 中的 `version`
2. 更新 CHANGELOG.md
3. 標記並推送：`git tag v1.1.0 && git push origin v1.1.0`
4. 提交 PR，更新 `presets/catalog.community.json` 中的 `version` 與 `download_url`

---

## 最佳實務

### 範本設計

- **保持區段清晰** — 使用 LLM 可以取代的標題與佔位文字
- **讓命令與範本相符** — 若你的預設集覆寫了命令，請確保它參照你範本中的區段
- **記錄自訂點** — 使用 HTML 註解引導使用者該改什麼

### 命名

- 預設集 ID 應具描述性：`healthcare-compliance`、`enterprise-safe`、`startup-lean`
- 避免通用名稱：`my-preset`、`custom`、`test`

### 堆疊

- 設計預設集時，讓它能與其他預設集良好堆疊
- 只覆寫你需要變更的範本
- 記錄你的預設集修改了哪些範本與命令

### 命令覆寫

- 只有在工作流程需要改變時才覆寫命令，而不只是輸出格式不同
- 若你只需要不同的範本區段，範本覆寫就足夠了
- 以多個代理測試命令覆寫（Claude、Gemini、Copilot）
