# 擴充功能發佈指南

本指南說明如何將你的擴充功能發佈到 Spec Kit 擴充功能目錄，讓它能透過 `specify extension search` 被發現。

## 目錄

1. [必要條件](#必要條件)
2. [準備你的擴充功能](#準備你的擴充功能)
3. [提交到目錄](#提交到目錄)
4. [發行工作流程](#發行工作流程)
5. [最佳實務](#最佳實務)

---

## 必要條件

發佈擴充功能之前，請確認你已具備：

1. **有效的擴充功能**：可運作的擴充功能，附有效的 `extension.yml` 資訊清單
2. **Git 儲存庫**：擴充功能託管在 GitHub（或其他公開 git 託管服務）
3. **文件**：README.md，附安裝與使用說明
4. **授權**：開放原始碼授權檔案（MIT、Apache 2.0 等）
5. **版本管理**：語意化版本（例如 1.0.0）
6. **測試**：擴充功能已在真實專案上測試

---

## 準備你的擴充功能

### 1. 擴充功能結構

確保你的擴充功能遵循標準結構：

```text
your-extension/
├── extension.yml              # Required: Extension manifest
├── README.md                  # Required: Documentation
├── LICENSE                    # Required: License file
├── CHANGELOG.md               # Recommended: Version history
├── .gitignore                 # Recommended: Git ignore rules
│
├── commands/                  # Extension commands
│   ├── command1.md
│   └── command2.md
│
├── config-template.yml        # Config template (if needed)
│
└── docs/                      # Additional documentation
    ├── usage.md
    └── examples/
```

### 2. extension.yml 驗證

確認你的資訊清單有效：

```yaml
schema_version: "1.0"

extension:
  id: "your-extension"           # Unique lowercase-hyphenated ID
  name: "Your Extension Name"     # Human-readable name
  version: "1.0.0"                # Semantic version
  description: "Brief description (one sentence)"
  author: "Your Name or Organization"
  repository: "https://github.com/your-org/spec-kit-your-extension"
  license: "MIT"
  homepage: "https://github.com/your-org/spec-kit-your-extension"

requires:
  speckit_version: ">=0.1.0"    # Required spec-kit version

provides:
  commands:                       # List all commands
    - name: "speckit.your-extension.command"
      file: "commands/command.md"
      description: "Command description"

tags:                             # 2-5 relevant tags
  - "category"
  - "tool-name"
```

**驗證檢核清單**：

- ✅ `id` 為小寫加連字號（無底線、空格或特殊字元）
- ✅ `version` 遵循語意化版本（X.Y.Z）
- ✅ `description` 簡潔（少於 100 個字元）
- ✅ `repository` URL 有效且公開
- ✅ 所有命令檔案都存在於擴充功能目錄中
- ✅ 標籤為小寫且具描述性

### 3. 建立 GitHub 發行版本

為你的擴充功能版本建立 GitHub 發行版本：

```bash
# Tag the release
git tag v1.0.0
git push origin v1.0.0

# Create release on GitHub
# Go to: https://github.com/your-org/spec-kit-your-extension/releases/new
# - Tag: v1.0.0
# - Title: v1.0.0 - Release Name
# - Description: Changelog/release notes
```

發行封存檔 URL 將為：

```text
https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.0.0.zip
```

### 4. 測試安裝

測試使用者能從你的發行版本安裝：

```bash
# Test dev installation
specify extension add --dev /path/to/your-extension

# Test from GitHub archive
specify extension add <extension-name> --from https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.0.0.zip
```

---

## 提交到目錄

### 了解目錄

Spec Kit 使用雙目錄系統。目錄運作方式的詳細說明，請參閱主要的 [Extensions README](https://github.com/github/spec-kit/blob/main/extensions/README.md#extension-catalogs)。

**關於擴充功能發佈**：所有社群擴充功能都列在 `extensions/catalog.community.json` 中。使用者瀏覽此目錄，並將信任的擴充功能複製到自己的 `catalog.json`。

### 如何提交

若要將擴充功能提交到社群目錄，請使用 **[Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml)** 範本建立新 issue。該範本會收集所有必要的後設資料，包括：

- 擴充功能 ID、名稱與版本
- 說明、作者與授權
- 儲存庫、下載 URL 與文件連結
- 所需的 Spec Kit 版本與任何工具相依性
- 命令與 hook 的數量
- 標籤與主要功能
- 測試確認

> [!IMPORTANT]
> 請**不要**直接開啟 pull request 來編輯 `extensions/catalog.community.json`。所有社群擴充功能提交都必須透過 issue 範本。未使用 issue 範本的提交將被關閉，並要求你改用範本重新提交。

### 提交後會發生什麼

1. 透過 Extension Submission 表單開啟 issue 時，GitHub 會套用 `triage-must-have` 判定。此進件自動化專屬於擴充功能提交，不會改變其他 issue 的手動分類標準。
2. 維護者在 issue 分類期間審查該 issue，並套用獨立的 `extension-submission` 標籤，這會啟動自動化目錄驗證。在此公開儲存庫中，貢獻者無法自行套用該標籤，因此無需標記或重新請求——issue 只需在分類中等待。
3. 自動化工作流程驗證提交內容，驗證通過時，會在 draft pull request 中更新 `extensions/catalog.community.json` 與 `docs/community/extensions.md`
4. 維護者審查產生的 pull request，核准後合併
5. 你的擴充功能即可透過 `specify extension search` 被發現

### 維護者檢查什麼

- 目錄條目欄位完整且格式正確
- 下載 URL 可存取
- 儲存庫存在且包含 `extension.yml` 資訊清單

> [!NOTE]
> 維護者**不會**審查、稽核或測試擴充功能程式碼本身。

### 一般審查時程

- **審查**：3～7 個工作天

### 更新既有擴充功能

若要更新已在目錄中的擴充功能（例如新版本），請使用 **[Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml)** 範本建立新 issue，填入更新後的版本、下載 URL 與其他變更欄位。並在 issue 中註明這是既有條目的更新。

---

## 發行工作流程

### 發佈新版本

發行新版本時：

1. **更新版本**（在 `extension.yml` 中）：

   ```yaml
   extension:
     version: "1.1.0"  # Updated version
   ```

2. **更新 CHANGELOG.md**：

   ```markdown
   ## [1.1.0] - 2026-02-15

   ### Added
   - New feature X

   ### Fixed
   - Bug fix Y
   ```

3. **建立 GitHub 發行版本**：

   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   # Create release on GitHub
   ```

4. **提交更新**：使用 [Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml) 範本，填入新版本與下載 URL。並在 issue 中註明這是既有條目的更新。

---

## 最佳實務

### 擴充功能設計

1. **單一職責**：每個擴充功能應專注於一個工具／整合
2. **清晰命名**：使用具描述性、無歧義的名稱
3. **最小相依性**：避免不必要的相依性
4. **向後相容**：嚴格遵循語意化版本

### 文件

1. **README.md 結構**：
   - 概覽與功能
   - 安裝說明
   - 設定指南
   - 使用範例
   - 疑難排解
   - 貢獻指南

2. **命令文件**：
   - 清晰的說明
   - 列出必要條件
   - 逐步說明
   - 錯誤處理指引
   - 範例

3. **設定**：
   - 提供範本檔案
   - 記錄所有選項
   - 包含範例
   - 說明預設值

### 安全性

1. **輸入驗證**：驗證所有使用者輸入
2. **不硬編碼機密**：絕不包含憑證
3. **安全的相依性**：僅使用受信任的相依性
4. **定期稽核**：檢查弱點

### 維護

1. **回應 Issue**：在 1～2 週內處理 issue
2. **定期更新**：保持相依性為最新
3. **變更紀錄**：維護詳細的變更紀錄
4. **棄用**：為破壞性變更提前通知

### 社群

1. **授權**：使用寬鬆的開放原始碼授權（MIT、Apache 2.0）
2. **貢獻**：歡迎貢獻
3. **行為準則**：尊重且包容
4. **支援**：提供取得協助的方式（issue、討論、電子郵件）

---

## 常見問題

### Q：我可以發佈私有／專有擴充功能嗎？

A：主目錄僅供公開擴充功能。私有擴充功能請：

- 自行託管 catalog.json 檔案
- 在 Spec Kit 專案中，使用者加入你的目錄：`specify extension catalog add https://your-domain.com/catalog.json --name private-catalog`

### Q：審查需要多久？

A：一般為 3～7 個工作天。既有擴充功能的更新通常較快。

### Q：如果我的擴充功能被拒絕怎麼辦？

A：你會收到需要修正之處的回饋。修正後重新提交即可。

### Q：我可以隨時更新擴充功能嗎？

A：可以，使用 [Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml) 範本建立新 issue，填入更新後的版本與下載 URL。並註明這是既有條目的更新。

### Q：我需要通過驗證才能進入目錄嗎？

A：不需要。所有社群擴充功能在提交審查並接受後，都會列入目錄。

### Q：擴充功能可以有付費功能嗎？

A：擴充功能應免費且開放原始碼。允許商業支援／服務，但核心功能必須免費。

---

## 支援

- **目錄 Issue**：<https://github.com/statsperform/spec-kit/issues>
- **擴充功能範本**：<https://github.com/statsperform/spec-kit-extension-template>（即將推出）
- **開發指南**：參閱[開發擴充功能](developing.md)
- **社群**：討論與問答

---

## 附錄：目錄結構描述

### 完整目錄條目結構描述

```json
{
  "name": "string (required)",
  "id": "string (required, unique)",
  "description": "string (required, <200 chars)",
  "author": "string (required)",
  "version": "string (required, semver)",
  "download_url": "string (required, valid URL)",
  "sha256": "string (optional, SHA-256 hex digest of the archive at download_url; verified before install)",
  "repository": "string (required, valid URL)",
  "homepage": "string (optional, valid URL)",
  "documentation": "string (optional, valid URL)",
  "changelog": "string (optional, valid URL)",
  "license": "string (required)",
  "requires": {
    "speckit_version": "string (required, version specifier)",
    "tools": [
      {
        "name": "string (required)",
        "version": "string (optional, version specifier)",
        "required": "boolean (default: false)"
      }
    ]
  },
  "provides": {
    "commands": "integer (optional)",
    "hooks": "integer (optional)"
  },
  "tags": ["array of strings (2-10 tags)"],
  "verified": "boolean (default: false, set by maintainers)",
  "downloads": "integer (auto-updated)",
  "stars": "integer (auto-updated)",
  "created_at": "string (ISO 8601 datetime)",
  "updated_at": "string (ISO 8601 datetime)"
}
```

### 有效標籤

建議的標籤類別：

- **整合**：jira、linear、github、gitlab、azure-devops
- **類別**：issue-tracking、vcs、ci-cd、documentation、testing
- **平台**：atlassian、microsoft、google
- **功能**：automation、reporting、deployment、monitoring

使用 2～5 個最能描述你擴充功能的標籤。

---

*最後更新：2026-01-28*
*目錄格式版本：1.0*
