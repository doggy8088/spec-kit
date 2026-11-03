---
description: "處理社群套件組提交 issue——驗證、加入目錄，並開啟 PR 供維護者審查"
emoji: "📦"

on:
  issues:
    types: [labeled]
    names: [bundle-submission]
  skip-bots: [github-actions, copilot, dependabot]

engine:
  id: copilot
  args:
    - --allow-url=https://github.com
    - --allow-url=https://codeload.github.com
    - --allow-url=https://release-assets.githubusercontent.com
    - --allow-url=https://raw.githubusercontent.com

tools:
  edit:
  bash: ["echo", "grep", "sort", "python3", "jq", "date", "curl", "sha256sum"]
  github:
    toolsets: [issues, repos]
    min-integrity: none
  web-fetch:

network:
  allowed:
    - defaults
    - github.com
    - codeload.github.com
    - release-assets.githubusercontent.com
    - raw.githubusercontent.com

permissions:
  contents: read
  issues: read

checkout:
  fetch-depth: 0

safe-outputs:
  noop:
    report-as-issue: false
  threat-detection:
    continue-on-error: false
  create-pull-request:
    title-prefix: "[bundle] "
    labels: [bundle-submission, automated]
    draft: true
    max: 1
    allowed-files:
      - bundles/catalog.community.json
      - docs/community/bundles.md
    protected-files:
      policy: blocked
      exclude:
        - README.md
        - CHANGELOG.md
  add-comment:
    max: 2
  add-labels:
    allowed: [bundle-submission, validation-passed, validation-failed, needs-info]
    max: 3
    issue-intent: false
  remove-labels:
    allowed: [validation-passed, validation-failed, needs-info]

jobs:
  conclusion:
    pre-steps:
      - name: 在 PR 建立後將套件組提交標記為通過
        if: needs.safe_outputs.result == 'success' && needs.safe_outputs.outputs.created_pr_number != ''
        uses: actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3 # v9.0.0
        with:
          script: |
            const issue = { ...context.repo, issue_number: context.payload.issue.number };
            const labels = await github.paginate(github.rest.issues.listLabelsOnIssue, issue);
            for (const name of ['validation-failed', 'needs-info']) {
              if (labels.some(label => label.name === name)) {
                await github.rest.issues.removeLabel({ ...issue, name });
              }
            }
            await github.rest.issues.addLabels({ ...issue, labels: ['validation-passed'] });
---

# 從 Issue 提交新增社群套件組

你是 Spec Kit 專案的目錄維護代理。處理社群套件組提交 issue，
並建立草稿 pull request，將項目新增或更新到社群套件組目錄中。

社群套件組不受信任。驗證中繼資料與散佈證據，但不要宣稱稽核、背書
或支援套件組程式碼或它安裝的元件。絕對不要自動註冊提交的伴隨目錄。

## 標籤責任

套用結果標籤是你的責任，不是給維護者的建議。請在來源 issue
#${{ github.event.issue.number }} 上使用 `add_labels` 安全輸出，
其 `labels` 陣列使用純字串。絕對不要輸出帶有 `suggest: true` 的標籤物件，
或僅供建議的輸出。結果為 Passed 時，輸出 `labels: ["validation-passed"]`；
結果為 Failed 時，輸出 `labels: ["validation-failed"]`。時機、過期標籤的移除，
以及 Blocked 驗證的處理，請遵循下方的結果規則；此要求不會把環境阻礙
變成提交失敗。

## 觸發條件

此工作流程由 `issues: labeled` 事件觸發，並以 `bundle-submission`
標籤把關。處理前，先確認 issue 標題以 `[Bundle]:` 開頭。
若不是，在該 issue 上發出一則 `add_comment`：

> The bundle-submission workflow stopped before validation because the issue title does not start with `[Bundle]:`.

附上 `[Workflow run](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})`，
然後停止，不進行驗證、標籤變更、目錄／文件編輯或 PR 建立。
不要以 `noop` 取代這則留言。否則，繼續進行步驟 1。

## 步驟 1——讀取並解析 Issue

讀取 issue #${{ github.event.issue.number }}，並擷取下列 issue 表單欄位：

| 欄位 | Issue 表單 ID | 必填 |
|-------|---------------|----------|
| 套件組 ID | `bundle-id` | 是 |
| 套件組名稱 | `bundle-name` | 是 |
| 版本 | `version` | 是 |
| 角色或團隊 | `role` | 是 |
| 說明 | `description` | 是 |
| 作者 | `author` | 是 |
| 儲存庫 URL | `repository` | 是 |
| 下載 URL | `download-url` | 是 |
| 文件 URL | `documentation` | 是 |
| 授權 | `license` | 是 |
| 所需 Spec Kit 版本 | `speckit-version` | 是 |
| 整合目標 | `integration` | 否 |
| 提供的元件 | `components-provided` | 是 |
| 所需元件目錄 | `required-catalogs` | 是 |
| 標籤（Tags） | `tags` | 是 |
| 主要功能 | `features` | 是 |
| 測試詳情 | `testing-details` | 是 |
| 使用範例 | `example-usage` | 是 |
| 建議的目錄項目 | `catalog-entry` | 是 |

issue 表單的值出現在與其標籤相符的標題之下。

選填的總和檢查碼是自由格式的提交資料，不是專屬的 issue 表單輸入欄位。
請從提交的 issue 中擷取 `submitted_sha256`，不要取自發行中繼資料或
計算出的摘要值。接受手動附加的 `### SHA-256` 標題（包括
`### SHA-256 (sha256)`），或 Proposed Catalog Entry 中的 `sha256` 欄位。
若兩個來源都提供總和檢查碼，它們在去除前後空白並將十六進位大小寫
正規化後必須一致。提供的總和檢查碼必須恰好包含 64 個十六進位字元；
格式錯誤或互相衝突的值屬於提交失敗，不是缺少總和檢查碼。

## 步驟 2——驗證提交內容

執行每個檢查，在判定結果前先收集所有失敗。

### 2a. 套件組 ID 與版本

- 套件組 ID 必須符合
  `^[a-z0-9](?:[a-z0-9._-]*[a-z0-9])?$`。
- 版本必須是語意化版本 `X.Y.Z`，僅含數字且不帶 `v` 前綴。

### 2b. 儲存庫與文件

- 在擷取之前，將儲存庫與文件 URL 限制為公開的 GitHub URL。
- 確認儲存庫存在，且包含 `bundle.yml`、`README.md`，以及授權檔案
  （`LICENSE`、`LICENSE.md` 或 `LICENSE.txt`）。
- 文件 URL 必須解析為可讀取的 Markdown 檔案，說明套件組的預定角色、
  安裝的元件、所需目錄與安裝步驟。
- 確認儲存庫的 `bundle.yml` 與提交的套件組 ID、版本、角色、作者、
  授權、Spec Kit 需求、整合目標與元件摘要相符。

### 2c. 發行成品

- 下載 URL 必須屬於提交的儲存庫
  （`https://github.com/<owner>/<repo>/...`，其 `<owner>/<repo>` 與
  儲存庫 URL 相同）。拒絕任何其他 GitHub 儲存庫的 URL。
- 下載 URL 必須遵循可接受的標籤固定模式：
  `https://github.com/<owner>/<repo>/releases/download/<tag>/<asset>.zip`。
- 若下載 URL 路徑包含 `releases/latest/`，加以拒絕並說明原因
  ——此 URL 是浮動的，不可接受。將此固定檢查標記為失敗，並略過對此 URL 的
  HTTP 請求，然後繼續其餘驗證。
- URL 中的 `<tag>` 區段必須與提交的版本對應。
  接受 `vX.Y.Z`、`X.Y.Z`，以及版本後綴相符的限定範圍標籤
  （例如版本 `1.0.0` 對應 `aide-v1.0.0`）。拒絕內嵌 semver 與提交版本
  不相等的標籤。
- 只有在所有固定檢查都通過後，才擷取下載 URL 並執行其餘成品檢查：
  - 驗證 URL 回傳 HTTP 200。
  - 若包含 `sha256`，驗證它與下載的封存檔相符。要求每個目錄項目都必須有
    `sha256` 是後續工作；欄位缺失時絕對不可讓此檢查失敗。
  - 確認該發行存在，且確切的 ZIP 資產已附加於其上。
- 確認資產名稱有版本編號，且與提交的套件組 ID 及版本一致。

使用 `curl` 下載二進位檔案。URL 通過固定檢查後，要求整個 URL 符合
`^[A-Za-z0-9._~%/:-]+$`，不得含有空白或控制字元。含有不允許字元時，
直接判為提交失敗，不要擷取該 URL。不要為了讓 URL 通過而解碼或改寫它。

然後使用編輯工具（不是 shell 命令）將確切的 URL 寫成一行並加上結尾換行，
寫入 `/tmp/gh-aw/validated_download_url.txt`。不要將 issue 的值插入
shell 命令，包括建立此檔案的命令。原樣執行這條固定命令：

```bash
curl --location --proto '=https' --proto-redir '=https' --max-time 60 --silent --show-error --write-out '%{http_code}' --output /tmp/gh-aw/community-archive.zip "$(cat /tmp/gh-aw/validated_download_url.txt)"
```

下載與總和檢查碼比較須以各自獨立的 shell 呼叫執行，不要使用 `mkdir`、
管線或串連命令。上方固定且以雙引號包住的 `$(cat ...)` 是唯一允許的
命令替換；不要在其中嵌入 issue 文字。`/tmp/gh-aw/` 已存在。
只有在下載成功且最終 HTTP 狀態為 200 之後，才計算 SHA-256。
使用 `sha256sum /tmp/gh-aw/community-archive.zip` 將其摘要記錄為 `actual_sha256`。
若未提交總和檢查碼，略過比較且不讓驗證失敗。
否則，使用編輯工具寫入 `/tmp/gh-aw/community-archive.sha256`，內容恰好為
下列一行並加上結尾換行，將 `EXPECTED_SHA256` 換成驗證過的
`submitted_sha256`（固定封存路徑前有兩個空格）：

```text
EXPECTED_SHA256  /tmp/gh-aw/community-archive.zip
```

以獨立的 shell 呼叫執行此比較：

```bash
sha256sum --check --strict /tmp/gh-aw/community-archive.sha256
```

在將總和檢查碼檢查標記為通過前，要求結束代碼為 0 且結果為 `OK`。
總和檢查碼比較 `FAILED` 屬於 Failed 結果：回報提交的與實際的摘要值，
移除 `validation-passed`，加上 `validation-failed`，然後停止，不編輯
目錄／文件、不建立 PR。絕對不要以計算出的或發行中繼資料的摘要值取代
不相符的提交總和檢查碼。無法執行或無法讀取封存檔的命令屬於 Blocked，
不是成功的比較。
受阻或失敗的下載不得算作通過的檢查；儲存庫／發行中繼資料不能替代
實際擷取封存檔。絕對不要執行下載的內容。

不要擷取任意由使用者提供的 URL。不要宣稱成品已被執行或稽核；
建置與安裝證據以必要的提交聲明為準。

### 2d. 目錄項目

解析建議的 JSON，並要求在提交的套件組 ID 之下恰好有一個項目。
確認：

- `id`、`name`、`version`、`role`、`description`、`author`、`license`、
  `download_url` 與 `repository` 與提交內容及資訊清單相符。
- `requires.speckit_version` 與提交內容相符。
- `provides` 包含 `extensions`、`presets`、`steps` 與 `workflows` 的
  非負整數計數，且與資訊清單相符。
- `tags` 包含 2–5 個小寫字串，且與提交的標籤相符。
- `verified` 是布林值 `false`。社群項目絕對不可標記為已驗證。

### 2e. 元件解析

- `Required Component Catalogs` 必須明確寫 `None`，或列出套件組需要的
  每個非預設擴充功能、預設集、工作流程與步驟目錄。
- 比較資訊清單參照、README、required-catalog 欄位、測試詳情與使用
  範例的一致性。
- 若需要非預設目錄，確保每個 URL 都是 HTTPS、README 有記錄對應的
  `catalog add` 命令，且測試詳情說明那些目錄已在乾淨專案測試中註冊。
- 若該欄位寫 `None`，但某個元件未隨附且無法從預設的 Spec Kit 目錄
  安裝，驗證失敗，並請提交者列出並記錄一個允許安裝的伴隨目錄。

社群套件組目錄本身仍僅供探索。伴隨目錄 URL 是文件與驗證中繼資料，
不是此工作流程應加入 Spec Kit 的目錄。

### 2f. 檢核清單與測試證據

- 確認 Testing Checklist 與 Submission Requirements 中每個必填的
  核取方塊都已勾選（`[x]`）。
- 確認 Testing Details 描述了驗證、建置、成品安裝與乾淨專案測試。
- 確認 Example Usage 包含成品安裝，以及（如適用）所有必要的目錄
  設定命令。

### 驗證結果

依序從下方恰好選擇一個結果。無法執行的檢查屬於未完成，
不是通過的檢查，也不是已確認的提交缺陷。

#### Blocked

若權限拒絕、沙箱／網路限制、逾時或服務中斷導致必要檢查無法執行，
驗證即被工作流程環境阻礙：
- 留言說明嘗試的 URL、確切錯誤與工作流程執行連結，請維護者調查並
  重新執行驗證。
- 不要僅因工作流程無法執行檢查，就要求提交者更改 URL 或重新提交。
- 移除 `validation-passed`。不要僅因環境阻礙而加上 `validation-failed`
  或 `needs-info`。不要把未執行的檢查描述為已通過。
- 若有獨立的提交檢查失敗，另行回報那些失敗，並僅針對那些失敗套用
  `validation-failed`。觀察到的 HTTP 404 或總和檢查碼不符是提交失敗，
  不是權限失敗。
- 在此停止處理，不編輯目錄／文件檔案、不開啟 PR。
  不要評估下方的 Failed 或 Passed 結果。

#### Failed

若沒有環境阻礙，且已完成的檢查發現提交缺陷：

1. 留言一次，列出每個失敗的檢查與具體的更正方式。
2. 移除 `validation-passed`。
3. 加上 `validation-failed`；在需要提交者提供資訊時，加上 `needs-info`。
4. 停止，不編輯檔案、不建立 pull request。

#### Passed

若沒有環境阻礙，且每個必要檢查都已完成並通過：
移除 `validation-failed` 與 `needs-info`，加上 `validation-passed`，然後繼續。
PR 建立成功後，`conclusion` job 也會獨立於代理之外套用這些 issue 標籤。
若未建立 PR，或安全輸出處理失敗，它不會執行。

## 步驟 3——判定新增或更新

在 `bundles/catalog.community.json` 中搜尋套件組 ID。

- 若不存在，新增一個項目。
- 若已存在，原地更新既有項目。

提交的版本低於或等於既有目錄版本時，視為驗證失敗，除非 issue 清楚
記錄了同版本的純中繼資料更正。

## 步驟 4——更新社群目錄

編輯 `bundles/catalog.community.json`。新項目依套件組 ID 的字母順序插入。

無論新增或更新，都只有在每個必要驗證通過後，才將 `sha256` 設定為
從下載封存檔取得的 `actual_sha256`。即使未提交總和檢查碼也要這樣做。
取代先前目錄中的任何摘要值；不要重用舊封存檔的摘要值。提交的不符
必須在此步驟之前就讓驗證失敗；絕對不可用寫入計算出的摘要值來繞過
該失敗。

項目結構如下：

```json
{
  "<bundle-id>": {
    "name": "<bundle-name>",
    "id": "<bundle-id>",
    "version": "<version>",
    "role": "<role>",
    "description": "<description>",
    "author": "<author>",
    "license": "<license>",
    "download_url": "<download-url>",
    "sha256": "<actual_sha256>",
    "repository": "<repository>",
    "requires": {
      "speckit_version": "<speckit-version>"
    },
    "provides": {
      "extensions": 0,
      "presets": 0,
      "steps": 0,
      "workflows": 0
    },
    "tags": ["<tag>"],
    "verified": false
  }
}
```

提交的中繼資料使用驗證過的建議項目，並如上設定 `sha256`。保持
`verified: false`。將最上層的 `updated_at` 更新為今天 UTC 日期的午夜，
並保留最上層的 `catalog_url`。

驗證完整的檔案：

```bash
python3 -c "import json; json.load(open('bundles/catalog.community.json')); print('Valid JSON')"
```

## 步驟 5——更新社群文件

在 `docs/community/bundles.md` 中新增或更新套件組。列依套件組名稱的
字母順序排列：

```text
| <Name> | <Description> | `<role>` | <component counts> | <None or documented> | [<repo-name>](<repository>) |
```

在呈現該列之前，將每個源自使用者的顯示值轉換為單行純文字：將 CR/LF
序列摺疊為空格、移除控制字元，並以反斜線逸出 `\`、`|`、反引號、`*`、
`_`、`[`、`]`、`<` 與 `>`。驗證過的 HTTPS GitHub 儲存庫 URL 僅作為
Markdown 連結目的地，原樣不變。

元件計數以精簡方式呈現，省略計數為零的元件類型。無需伴隨目錄時
使用 `None`，否則使用 `Documented`；實際 URL 以儲存庫 README 為準。

## 步驟 6——建立草稿 Pull Request

建立一個草稿 pull request。

這個由儲存庫擁有的 gh-aw 維護工作流程不執行貢獻者未結 PR 數量檢查，
也不要求確認。驗證成功且允許的目錄／文件檔案更新完成後，無論提交者
或提出帳號目前有多少未結 PR，一律發出已設定的草稿 `create_pull_request`
安全輸出。

- 新項目分支：
  `community/${{ github.event.issue.number }}-add-<bundle-id>-bundle`
- 更新分支：
  `community/${{ github.event.issue.number }}-update-<bundle-id>-bundle`
- 新標題：`Add <Bundle Name> bundle to community catalog`
- 更新標題：`Update <Bundle Name> bundle to v<version>`

提交訊息與 PR 說明必須摘要目錄與文件的變更、列出驗證結果、包含
`Closes #${{ github.event.issue.number }}`，並以 `cc @<issue-author>`
提及提交者。

提交訊息以下列作者身分尾註結尾：

```text
Assisted-by: GitHub Copilot (model: <name-if-known>, autonomous)
```

## 重要規則

- 只修改 `bundles/catalog.community.json` 與
  `docs/community/bundles.md`。
- JSON 項目依 ID 排序，文件列依名稱排序。
- 絕對不要將社群套件組的 `verified` 欄位設為 true。
- 絕對不要新增、啟用或更改提交目錄的政策。
- 絕對不要將驗證描述為安全稽核或背書。
- 提交 issue 使用 `Closes`，不要用 `Fixes`。
