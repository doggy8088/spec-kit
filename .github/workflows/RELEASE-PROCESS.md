# 發行流程

本文件說明 Spec Kit 的自動化發行流程。

## 概覽

發行流程拆分為三個工作流程：

1. **Release Trigger Workflow**（`release-trigger.yml`）——管理版本編號、建立標籤，並開啟發行 PR
2. **Release Workflow**（`release.yml`）——建立 GitHub Release 與發行說明
3. **Publish to PyPI Workflow**（`publish-pypi.yml`）——從確切的標籤建置並發佈 Python 套件

這樣的拆分確保 git 標籤指向 `pyproject.toml` 中版本正確的提交，
並讓維護者能獨立復原 GitHub 與 PyPI 的發佈步驟。

## 建立發行之前

**重要**：撰寫清楚、具描述性的提交訊息！

### CHANGELOG.md 的運作方式

CHANGELOG 是從你的 git 提交訊息**自動產生**的：

1. **開發期間**：撰寫清楚、具描述性的提交訊息：

   ```bash
   git commit -m "feat: Add new authentication feature"
   git commit -m "fix: Resolve timeout issue in API client (#123)"
   git commit -m "docs: Update installation instructions"
   ```

2. **發行時**：發行觸發工作流程會自動：
   - 找出自上一個發行標籤以來的所有提交
   - 將它們格式化為變更記錄項目
   - 插入 CHANGELOG.md
   - 在建立新標籤之前，先提交更新後的變更記錄

### 提交訊息最佳實務

好的提交訊息造就好的變更記錄：

- **具描述性**：「Add user authentication」，不要寫「Update files」
- **參照 issue／PR**：包含 `(#123)` 以便自動連結
- **使用慣例式提交**（選用）：`feat:`、`fix:`、`docs:`、`chore:`
- **保持精簡**：一行最理想，細節寫在提交內文中

**能成為良好變更記錄項目的提交範例：**

```text
fix: prepend YAML frontmatter to Cursor .mdc files (#1699)
feat: add generic agent support with customizable command directories (#1639)
docs: document dual-catalog system for extensions (#1689)
```

## 建立發行

### 選項 1：自動遞增（修補版本建議使用）

1. 前往 **Actions** → **Release Trigger**
2. 點選 **Run workflow**
3. 版本欄位保持**空白**
4. 點選 **Run workflow**

工作流程將會：

- 自動遞增修補版本（例如 `0.1.10` → `0.1.11`）
- 更新 `pyproject.toml`
- 根據自上一個標籤以來的提交，為此次發行在 `CHANGELOG.md` 中新增一個區段
- 將變更提交到 `chore/release-vX.Y.Z` 分支
- 從該分支建立並推送 git 標籤
- 將發行分支提升為下一個修補開發版本（例如 `1.2.3` → `1.2.4.dev0`）
- 開啟 PR，將版本提升合併回 `main`
- 透過標籤推送自動觸發發行工作流程

### 選項 2：手動指定版本（主要／次要版本提升時使用）

1. 前往 **Actions** → **Release Trigger**
2. 點選 **Run workflow**
3. 輸入想要的版本（例如 `0.2.0` 或 `v0.2.0`）
4. 點選 **Run workflow**

工作流程將會：

- 使用你指定的版本
- 更新 `pyproject.toml`
- 根據自上一個標籤以來的提交，為此次發行在 `CHANGELOG.md` 中新增一個區段
- 將變更提交到 `chore/release-vX.Y.Z` 分支
- 從該分支建立並推送 git 標籤
- 將發行分支提升為下一個修補開發版本（例如 `1.2.3` → `1.2.4.dev0`）
- 開啟 PR，將版本提升合併回 `main`
- 透過標籤推送自動觸發發行工作流程

## 接下來會發生的事

發行觸發流程會推送帶有發行版本提交的 `chore/release-vX.Y.Z` 分支，
然後推送指向該提交的標籤。標籤推送之後，兩條路徑獨立進行：

- **Release Workflow** 會建立帶有自動產生發行說明的 GitHub Release。不會建置或上傳各代理專屬的 ZIP 資產；GitHub 仍會提供其標準的原始碼封存檔。
- **Release Trigger Workflow** 繼續將發行分支提升為下一個修補開發版本，並開啟 PR，將兩個版本提交都合併回 `main`。

GitHub Release 的建立可能在開發版本提升與 PR 建立之前或之後完成。
以同一個標籤手動執行 **Publish to PyPI Workflow**，建置並發佈 wheel 與原始碼散佈檔。

> **注意**：GitHub Release 與 PyPI 工作流程彼此不相依。等 GitHub Release 完成後再發佈到 PyPI，會讓發行狀態更容易驗證。發佈後再合併自動開啟的 PR，讓 `main` 保持在下一個開發版本。

## 工作流程詳情

### Release Trigger Workflow

**檔案**：`.github/workflows/release-trigger.yml`

**觸發方式**：手動（`workflow_dispatch`）

**所需權限**：`contents: write`、`pull-requests: write`

**步驟**：

1. 簽出儲存庫
2. 決定版本（手動或自動遞增）
3. 檢查標籤是否已存在（防止重複）
4. 建立 `chore/release-vX.Y.Z` 分支
5. 更新 `pyproject.toml`
6. 根據 git 提交更新 `CHANGELOG.md`
7. 提交變更
8. 推送分支與標籤
9. 將 `pyproject.toml` 提升為下一個修補開發版本並推送分支
10. 開啟 PR，將發行與開發版本提交合併回 `main`

### Release Workflow

**檔案**：`.github/workflows/release.yml`

**觸發方式**：標籤推送（`v*`）

**所需權限**：`contents: write`

**步驟**：

1. 在標籤處簽出儲存庫
2. 從標籤名稱擷取版本
3. 檢查發行是否已存在
4. 根據提交產生發行說明
5. 建立 GitHub Release，不附加額外上傳的資產

### Publish to PyPI Workflow

**檔案**：`.github/workflows/publish-pypi.yml`

**觸發方式**：手動（`workflow_dispatch`），並指定確切的發行標籤

**所需權限**：建置 job 需要 `contents: read`、`actions: write`；發佈 job 需要 `actions: read`、`id-token: write`

**步驟**：

1. 驗證輸入使用嚴格的 `vX.Y.Z` 標籤格式
2. 簽出 `refs/tags/vX.Y.Z`
3. 驗證標籤版本與 `pyproject.toml` 中的版本完全相符
4. 以 `uv build` 建置 wheel 與原始碼散佈檔
5. 將散佈檔作為 GitHub Actions 成品在 job 之間傳遞
6. 以 `uv publish` 與 Trusted Publishing 將它們發佈到 PyPI

## 版本限制

- 標籤必須遵循格式：`v{MAJOR}.{MINOR}.{PATCH}`
- 有效版本範例：`v0.1.11`、`v0.2.0`、`v1.0.0`
- 自動遞增只提升修補版本
- 無法建立重複標籤（工作流程將失敗）

## 這種方式的優點

✅ **版本一致性**：Git 標籤指向 `pyproject.toml` 版本相符的提交

✅ **單一事實來源**：版本只設定一次，處處使用

✅ **防止漂移**：不再需要手動同步版本

✅ **獨立發佈**：GitHub Release 的建立與 PyPI 發佈可分別驗證與復原

✅ **彈性**：同時支援自動遞增與手動指定版本

## 疑難排解

### 自上次發行以來沒有提交

若你在自上一個標籤以來沒有新提交時執行發行觸發工作流程：

- 工作流程仍會成功
- 若是首次發行，CHANGELOG 會顯示「- Initial release」
- 若沒有提交，則會是空白
- 考慮在發行前先加入有意義的提交

**最佳實務**：使用具描述性的提交訊息——它們會成為你的變更記錄！

### 標籤已存在

若你看到「Error: Tag vX.Y.Z already exists!」，在採取行動之前，先檢查既有的標籤、GitHub Release 與 PyPI 版本。不要移動或刪除已發佈到 PyPI 的版本標籤。PyPI 不允許重用已上傳的散佈檔檔名，即使刪除後也一樣。

若既有標籤就是預期的發行，保留它，並依下方指引復原任何缺失的輸出。當要在已使用的版本下發佈不同的發行內容時，選擇新版本。只有在確認該版本未發佈到 PyPI、且沒有使用者依賴它時，才考慮移除錯誤的標籤。

### 復原不完整的發行

分別驗證發行分支／標籤、GitHub Release、wheel（`.whl`）與原始碼散佈檔（`.tar.gz`）。單憑 PyPI 版本頁面無法確認兩個散佈檔都已上傳。

| 狀態 | 復原方式 |
|---|---|
| 發行分支存在，標籤缺失 | 檢查失敗的執行，確認預期的發行提交其套件版本為 `X.Y.Z`。只有在本地 `vX.Y.Z` 標籤指向該提交時，才建立或重用它，然後推送。不要為後續的 `.dev0` 提交加上標籤。依下方說明完成任何缺失的開發版本提升或 PR。 |
| 標籤存在，發行分支的開發版本提升或 PR 未完成 | 保持標籤不變。檢查 `chore/release-vX.Y.Z` 與任何既有 PR；若分支缺失，從發行提交還原它，如有需要套用下一個修補開發版本提升，並開啟或重用合併回 `main` 的 PR。發佈完成後再合併。不要針對既有標籤重新執行 Release Trigger。 |
| 標籤存在，GitHub Release 缺失 | 確認標籤指向預期的發行提交，然後從該既有標籤建立 GitHub Release，使用與 `release.yml` 相同的說明格式。 |
| 有效標籤存在，wheel 與 sdist 都未發佈到 PyPI | 以確切的發行標籤手動執行 **Publish to PyPI**，與 GitHub Release 的建立相互獨立。 |
| PyPI 版本存在，GitHub Release 缺失 | 保持既有標籤不變，並從它建立 GitHub Release。 |
| Wheel 已發佈，sdist 缺失 | 復原原始建置成品，並依下方程序發佈缺失的 sdist；驗證既有的 wheel 完全相符。 |
| Sdist 已發佈，wheel 缺失 | 復原原始建置成品，並依下方程序發佈缺失的 wheel；驗證既有的 sdist 完全相符。 |

對於 PyPI 部分上傳，使用不依賴失敗 job 重跑來保留原始建置存取的復原程序：

1. 檢查原始的 **Publish to PyPI** 執行與已經在 PyPI 上的檔案。若原始 `dist` 成品仍可存取，在任何重跑之前先下載並保存它，並確認該次執行使用的是預期的發行標籤。
2. 將 wheel 與 sdist 解壓到乾淨的 `dist/` 目錄。將檔名已在 PyPI 上的檔案之 SHA-256 雜湊與 PyPI 公佈的雜湊比較；兩者必須完全相符。
3. 請具備 PyPI 發佈權限的維護者，使用已授權的 PyPI 權杖，對該目錄執行 `uv publish`。目前的工作流程只接受標籤，無法以保存的成品作為輸入；其 Trusted Publishing 身分不會授予本機 shell 認證。對於 PyPI，[重複執行 `uv publish` 會略過既有且相同的檔案](https://docs.astral.sh/uv/guides/package/#publishing-your-package)，並上傳缺失的檔案。事後確認 wheel 與 sdist 兩者都存在。

若原始成品無法取得，從未變更的發行標籤重新建置，並在發佈前執行相同的雜湊比較。同一個標籤本身不保證建置輸出相同。若任何已發佈的檔案不同，停止並調查；不要取代已發佈的檔案，也不要移動標籤。先前使用過的散佈檔檔名無法被取代，也無法以不同內容重用，即使刪除後也一樣。

重跑整個工作流程也會重跑 `uv build`，並直接進入發佈，沒有獨立的手動比較步驟。部分上傳之後，不要以它取代上方的驗證。若驗證過的成品沒有可用的已授權發佈路徑，請 PyPI 專案擁有者安排復原。

### Release Workflow 沒有觸發

檢查：

- 發行觸發工作流程是否成功完成
- 標籤是否已推送（查看儲存庫標籤）
- 發行工作流程是否已在 Actions 設定中啟用

### 版本不符

發行 PR 合併後，`main` 上的 `pyproject.toml` 與最新發行標籤不同是預期的。標籤 `vX.Y.Z` 指向套件版本恰好為 `X.Y.Z` 的提交；發行分支隨後會提升為下一個修補開發版本（例如 `1.2.3` → `1.2.4.dev0`）。不要將 `main` 同步回已發行的版本。

**Publish to PyPI** 工作流程會簽出發行標籤，並驗證其版本（不含 `v` 前綴）與該提交處的 `pyproject.toml` 完全相符。在已標記的提交處不符是錯誤；`main` 上的下一個開發版本則是預期的。

若該檢查失敗，在選擇復原路徑之前，先檢查標籤、GitHub Release 與 PyPI 發佈狀態（見上方的**標籤已存在**與**復原不完整的發行**）。不要移動或重建已發佈的標籤。

## 舊有行為（v0.1.10 之前）

在此變更之前，發行工作流程會：

- 在 main 分支推送時自動建立標籤
- 在建立標籤**之後**才更新 `pyproject.toml`
- 導致標籤指向版本過時的提交

此問題已在 v0.1.10+ 修正。
