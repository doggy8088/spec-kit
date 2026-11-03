# Spec Kit 擴充功能

[Spec Kit](https://github.com/github/spec-kit) 的擴充功能系統——在不讓核心框架臃腫的前提下加入新功能。

## 擴充功能目錄

Spec Kit 提供兩個用途不同的目錄檔案：

### 你的目錄（`catalog.json`）

- **用途**：Spec Kit CLI 使用的預設上游擴充功能目錄
- **預設狀態**：上游專案刻意保持空白——由你或你的組織在 fork／副本中填入你信任的擴充功能
- **位置（上游）**：GitHub 託管的 spec-kit 儲存庫中的 `extensions/catalog.json`
- **CLI 預設值**：`specify extension` 命令預設使用上游目錄 URL，除非被覆寫
- **組織目錄**：將 `SPECKIT_CATALOG_URL` 指向你組織的 fork 或託管的目錄 JSON，即可改用它而非上游預設值
- **自訂**：把社群目錄中的條目複製到你的組織目錄，或直接加入你自己的擴充功能

**覆寫範例：**
```bash
# Override the default upstream catalog with your organization's catalog
export SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json"
specify extension search  # Now uses your organization's catalog instead of the upstream default
```

### 社群參考目錄（`catalog.community.json`）

> [!NOTE]
> 社群擴充功能由各自的作者獨立建立與維護。維護者只驗證目錄條目是否完整、格式是否正確——他們**不會審查、稽核、背書或支援擴充功能的程式碼本身**。安裝前請先審查擴充功能的原始碼，並自行判斷是否使用。

- **用途**：瀏覽可用的社群貢獻擴充功能
- **狀態**：使用中——包含社群提交的擴充功能
- **位置**：`extensions/catalog.community.json`
- **用法**：用於探索可用擴充功能的參考目錄
- **提交**：透過 [issue 範本](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml)開放社群貢獻

**運作方式：**

## 讓擴充功能可供使用

你可以控制團隊能探索與安裝哪些擴充功能：

### 選項 1：精選目錄（組織推薦）

在你的 `catalog.json` 中填入已核准的擴充功能：

1. **探索**來自各種來源的擴充功能：
   - 瀏覽 `catalog.community.json` 中的社群擴充功能
   - 在你組織的儲存庫中尋找私有／內部擴充功能
   - 從信任的第三方探索擴充功能
2. **審查**擴充功能，挑選你想開放使用的項目
3. **加入**：把這些擴充功能條目加入你自己的 `catalog.json`
4. **團隊成員**現在就能探索並安裝它們：
   - `specify extension search` 會顯示你精選的目錄
   - `specify extension add <name>` 會從你的目錄安裝

**好處**：完全掌控可用的擴充功能、團隊一致性、組織核准工作流程

**範例**：把 `catalog.community.json` 中的一個條目複製到你的 `catalog.json`，你的團隊就能依名稱探索並安裝它。

### 選項 2：直接 URL（臨時使用）

跳過目錄精選——團隊成員直接用 URL 安裝：

```bash
specify extension add <extension-name> --from https://github.com/org/spec-kit-ext/archive/refs/tags/v1.0.0.zip
```

**好處**：適合一次性測試或私有擴充功能，快速方便

**取捨**：以這種方式安裝的擴充功能，不會出現在其他團隊成員的 `specify extension search` 結果中，除非你也把它們加入你的 `catalog.json`。

## 可用的社群擴充功能

> [!NOTE]
> 社群擴充功能由各自的作者獨立建立與維護。維護者只驗證目錄條目是否完整、格式是否正確——他們**不會審查、稽核、背書或支援擴充功能的程式碼本身**。社群擴充功能網站也是第三方資源。安裝前請先審查擴充功能的原始碼，並自行判斷是否使用。

🔍 **在 [Community Extensions 網站](https://speckit-community.github.io/extensions/)瀏覽與搜尋社群擴充功能。**

完整的社群貢獻擴充功能清單，請見 [Community Extensions](https://github.github.io/spec-kit/community/extensions.html) 頁面。

原始目錄資料請見 [`catalog.community.json`](catalog.community.json)。


## 加入你的擴充功能

### 提交流程

若要把你的擴充功能加入社群目錄：

1. **準備你的擴充功能**，遵循 [Extension Development Guide](https://github.github.io/spec-kit/extensions/developing.html)
2. **為你的擴充功能建立 GitHub release**
3. **提出 issue**：使用 [Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml) 範本，附上所有必填的中繼資料
4. **等待審查**——維護者會審查提交內容、更新目錄並關閉該 issue

詳細的逐步說明，請見 [Extension Publishing Guide](https://github.github.com/spec-kit/extensions/publishing.html)。

### 提交檢核清單

提交前，請確認：

- ✅ 有效的 `extension.yml` 清單檔案
- ✅ 完整的 README，含安裝與使用說明
- ✅ 附有 LICENSE 檔案
- ✅ 已建立 GitHub release，並使用語意化版本（例如 v1.0.0）
- ✅ 擴充功能已在真實專案上測試
- ✅ 所有命令都如文件所述運作

## 安裝擴充功能
擴充功能可供使用後（無論是在你的目錄中，或透過直接 URL），即可安裝：

```bash
# From your curated catalog (by name)
specify extension search                  # See what's in your catalog
specify extension add <extension-name>    # Install by name

# Direct from URL (bypasses catalog)
specify extension add <extension-name> --from https://github.com/<org>/<repo>/archive/refs/tags/<version>.zip

# List installed extensions
specify extension list
```

更多資訊，請見 [Extension User Guide](../docs/extensions/overview.md)。
