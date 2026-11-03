---
name: add-community-extension
description: '從 GitHub 議題提交將社群擴充功能加入 Spec Kit 目錄。適用於：處理擴充功能提交議題、驗證目錄項目、更新 catalog.community.json 與 docs/community/extensions.md、建立 PR。不適用於：從零建立新的擴充功能，或第一方擴充功能工作。'
argument-hint: '擴充功能提交的 GitHub 議題 URL 或編號'
---

# 新增社群擴充功能

處理擴充功能提交議題，並在社群目錄中新增或更新該擴充功能。

## 使用時機

- 已提交新的 `[Extension]` 提交議題
- 既有擴充功能提交更新議題（新版本、變更的中繼資料）
- 需要在 `extensions/catalog.community.json` 與 `docs/community/extensions.md` 中新增或更新社群擴充功能

## 流程

### 1. 取得提交議題

閱讀 GitHub 議題以擷取所有中繼資料：
- 擴充功能 ID、名稱、版本、說明、作者
- 儲存庫 URL、下載 URL、首頁、文件、變更紀錄
- 授權、所需的 spec-kit 版本、選用的工具相依性
- 命令與掛鉤的數量
- 標籤

### 2. 對照發佈規則驗證

檢查以下**全部**項目（依 `docs/extensions/publishing.md`）：

| 檢查 | 方法 |
|-------|-----|
| 儲存庫存在且為公開 | 取得儲存庫 URL |
| 有 `extension.yml` 清單 | 在儲存庫檔案清單中確認 |
| 有 README.md | 在儲存庫檔案清單中確認 |
| 有 LICENSE 檔案 | 在儲存庫檔案清單中確認 |
| 有與版本相符的 GitHub 發行版本 | 檢查儲存庫頁面的發行版本 |
| 下載 URL 可存取 | 驗證其符合 `archive/refs/tags/<tag>.zip` 或 `releases/download/<tag>/<asset>.zip` 模式，且發行版本存在 |
| 擴充功能 ID 僅為小寫加連字號 | 正規表達式：`^[a-z][a-z0-9-]*$` |
| 版本遵循 semver | 格式：`X.Y.Z` |
| 提交檢核清單已全部勾選 | 在議題內文中確認 |

### 3. 判斷是新增還是更新

在 `extensions/catalog.community.json` 中搜尋擴充功能 ID。

- **未找到** → 這是**新增**。進行步驟 4。
- **找到** → 這是**更新**。進行步驟 4，但以原地替換取代插入既有項目。

### 4. 新增或更新 `extensions/catalog.community.json`

**新增擴充功能：** 依擴充功能 ID 的**字母順序**插入項目。

**更新：** 原地替換既有項目。只更新有變更的欄位（通常為 `version`、`download_url`、`description`、`provides`、`requires`、`tags`、`updated_at`）。保留既有項目中的 `created_at` 與 `downloads`／`stars`。

使用既有項目作為格式範本。項目格式：

```json
{
  "<id>": {
    "name": "<name>",
    "id": "<id>",
    "description": "<description>",
    "author": "<author>",
    "version": "<version>",
    "download_url": "<download_url>",
    "repository": "<repository>",
    "homepage": "<homepage>",
    "documentation": "<documentation>",
    "changelog": "<changelog>",
    "license": "<license>",
    "category": "<category>",
    "effect": "<effect>",
    "requires": {
      "speckit_version": "<speckit_version>"
    },
    "provides": {
      "commands": <N>,
      "hooks": <N>
    },
    "tags": ["<tag1>", "<tag2>"],
    "verified": false,
    "downloads": 0,
    "stars": 0,
    "created_at": "<today>T00:00:00Z",
    "updated_at": "<today>T00:00:00Z"
  }
}
```

**Category** — 自由格式字串；常見值：`docs`、`code`、`process`、`integration`、`visibility`
**Effect** — 以下其中之一：`read-only`、`read-write`

若擴充功能有選用的工具相依性，在 `"requires"` 內新增 `"tools"` 陣列：

```json
"tools": [{ "name": "<tool>", "required": false }]
```

同時更新目錄頂層的 `"updated_at"` 時間戳記。

編輯後，執行以下指令**驗證 JSON**：

```bash
python3 -c "import json; json.load(open('extensions/catalog.community.json')); print('Valid JSON')"
```

### 5. 新增或更新 `docs/community/extensions.md` 的社群擴充功能表格

**新增擴充功能：** 依擴充功能名稱的**字母順序**，將新的一列插入 `# Community Extensions` 表格。

**更新：** 找到既有列並原地更新說明或其他變更欄位。

依擴充功能的行為判斷類別與效果：

```
| <Name> | <Description> | `<category>` | <Effect> | [<repo-name>](<repository-url>) |
```

**Category** — 自由格式；常見值：`docs`、`code`、`process`、`integration`、`visibility`
**Effect** — 在 `extension.yml` 與 `catalog.community.json` 中寫入標準值 `read-only` 或 `read-write`；僅在文件表格顯示時使用 `Read-only`／`Read+Write`

### 6. 提交、推送並開啟 PR

新增擴充功能時使用 `add-`，更新時使用 `update-`：

```bash
# 新增擴充功能
git checkout -b add-<extension-id>-extension

# 更新
git checkout -b update-<extension-id>-extension
```

```bash
git add extensions/catalog.community.json docs/community/extensions.md

# 新增擴充功能
git commit -m "Add <Name> extension to community catalog

Add <id> extension submitted by @<issue-author> to:
- extensions/catalog.community.json (alphabetical order)
- docs/community/extensions.md community extensions table

Closes #<issue-number>"

# 更新
git commit -m "Update <Name> extension to v<version>

Update <id> extension submitted by @<issue-author>:
- extensions/catalog.community.json (version, download_url, etc.)
- docs/community/extensions.md community extensions table

Closes #<issue-number>"

git push origin <branch-name>
```

然後向上游（`github/spec-kit`）建立 PR，內容包含：
- **標題：** `Add <Name> extension to community catalog`（或 `Update <Name> extension to v<version>`）
- **內文：** 包含驗證摘要、`Closes #<issue-number>` 與 `cc @<issue-author>`
- **Head：** `<fork-owner>:<branch-name>`
- **Base：** `main`

## 常見陷阱

- **字母順序很重要** — JSON 中的項目必須依 ID 排序，文件表格中的項目必須依名稱排序。
- **不要忘記目錄的 `updated_at`** — `catalog.community.json` 的頂層時間戳記必須更新。
- **編輯後驗證 JSON** — 尾隨逗號或缺少大括號都會破壞目錄。
- **使用 `Closes` 而非 `Fixes`** — `Closes #N` 是提交議題的正確關鍵字。
- **比對建議項目但仍要驗證** — 議題可能包含建議的 JSON 區塊，但務必對照實際儲存庫狀態驗證欄位值。
- **更新時保留 `created_at`** — 保留原始的 `created_at` 值；只變更 `updated_at`。
- **更新時保留 `downloads` 與 `stars`** — 這些反映使用指標，不得重設。
