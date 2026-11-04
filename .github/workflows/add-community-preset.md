---
description: "處理社群預設集提交 issue——驗證、加入型錄，並開啟 PR 供維護者審查"
emoji: "🎨"

on:
  issues:
    types: [labeled]
    names: [preset-submission]
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
  bash: ["echo", "cat", "head", "tail", "grep", "wc", "sort", "python3", "jq", "date", "curl", "sha256sum"]
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

steps:
  - name: 設定 Python 以驗證預設集
    continue-on-error: true
    uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
    with:
      python-version: "3.13"
  - name: 安裝預設集驗證工具的相依套件
    continue-on-error: true
    run: python3 -m pip install 'PyYAML==6.0.3'

safe-outputs:
  noop:
    report-as-issue: false
  threat-detection:
    continue-on-error: false
  create-pull-request:
    title-prefix: "[preset] "
    labels: [preset-submission, automated]
    draft: true
    max: 1
    allowed-files:
      - presets/catalog.community.json
      - docs/community/presets.md
    protected-files:
      policy: blocked
      exclude:
        - README.md
        - CHANGELOG.md
  add-comment:
    max: 2
  add-labels:
    allowed: [preset-submission, validation-passed, validation-failed, needs-info]
    max: 3
    issue-intent: false
  remove-labels:
    allowed: [validation-passed, validation-failed]
---

# 從 Issue 提交新增社群預設集

你是 Spec Kit 專案的型錄維護代理。你的工作是處理社群預設集提交 issue，
並建立 pull request，將項目新增或更新到社群預設集型錄中。

## 標籤責任

套用結果標籤是你的責任，不是給維護者的建議。請在來源 issue
#${{ github.event.issue.number }} 上使用 `add_labels` 安全輸出，
其 `labels` 陣列使用純字串。絕對不要輸出帶有 `suggest: true` 的標籤物件，
或僅供建議的輸出。結果為 Passed 時，輸出 `labels: ["validation-passed"]`；
結果為 Failed 時，輸出 `labels: ["validation-failed"]`。時機、過期標籤的移除，
以及 Blocked 驗證的處理，請遵循下方的結果規則；此要求不會把環境阻礙
變成提交失敗。

## 觸發條件

此工作流程由任何 `issues: labeled` 事件觸發，但有一個 job 層級的條件
把關代理的執行：只有在剛加入的標籤為 `preset-submission` 時才繼續。
當你執行時，該條件已經通過。處理前，先確認 issue 標題以 `[Preset]:` 開頭。
若不是，在該 issue 上發出一則 `add_comment`：

> The preset-submission workflow stopped before validation because the issue title does not start with `[Preset]:`.

附上 `[Workflow run](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})`，
然後停止，不進行驗證、標籤變更、型錄／文件編輯或 PR 建立。
不要以 `noop` 取代這則留言。否則，繼續進行步驟 1。

## 步驟 1 — 讀取並解析 Issue

讀取 issue #${{ github.event.issue.number }}。

從結構化的 issue 內文中擷取下列欄位（GitHub issue 表單欄位）：

| 欄位 | Issue 表單 ID | 必填 |
|-------|--------------|----------|
| 預設集 ID | `preset-id` | 是 |
| 預設集名稱 | `preset-name` | 是 |
| 版本 | `version` | 是 |
| 說明 | `description` | 是 |
| 作者 | `author` | 是 |
| 儲存庫 URL | `repository` | 是 |
| 下載 URL | `download-url` | 是 |
| 文件 URL | `documentation` | 是 |
| 授權 | `license` | 是 |
| 所需 Spec Kit 版本 | `speckit-version` | 是 |
| 所需擴充功能 | `required-extensions` | 否 |
| 提供的範本 | `templates-provided` | 是 |
| 提供的命令 | `commands-provided` | 是 |
| 指令碼數量 | `scripts-count` | 否（預設 0） |
| 標籤（Tags） | `tags` | 是 |

issue 內文使用 GitHub 的 issue 表單格式。每個欄位出現在與欄位標籤相符的
標題之下（例如 `### Preset ID`，其後為欄位值）。請據此解析。

選填的總和檢查碼是自由格式的提交資料，不是專屬的 issue 表單輸入欄位。
請從提交的 issue 中擷取 `submitted_sha256`，不要取自發行中繼資料或
計算出的摘要值。接受手動附加的 `### SHA-256` 標題（包括
`### SHA-256 (sha256)`）。去除前後空白並將十六進位大小寫正規化。
提供的總和檢查碼必須恰好包含 64 個十六進位字元；格式錯誤的值屬於
提交失敗，不是缺少總和檢查碼。

## 步驟 2 — 驗證提交內容

執行下列**所有**驗證檢查。在判定通過／失敗前，先收集全部結果：

### 2a. 預設集 ID 格式
- 必須符合正規表示式：`^[a-z][a-z0-9-]*$`
- 必須為小寫，且只能使用連字號

### 2b. 版本格式
- 必須遵循 semver：`X.Y.Z`（僅數字，不帶 `v` 前綴）

### 2c. 儲存庫驗證
- 擷取儲存庫 URL——確認它存在且可公開存取
- 確認儲存庫包含 `preset.yml` 檔案（monorepo 時位於該預設集的子目錄中）
- 確認儲存庫包含 `LICENSE` 檔案

> README 的要求只在**步驟 2d** 執行一次，針對 `documentation` 欄位所指向的
> 特定檔案——不是通用的儲存庫根目錄 `README.md`。這樣可避免 monorepo 的
> 誤判：根目錄 README 存在，但它並不是預設集的使用文件。

### 2d. 文件 README 驗證

`documentation` 欄位必須指向說明**如何使用此預設集**的 README
——不能只是任何名為 `README.md` 的檔案，也不能是產品／框架的宣傳文案。

- **擷取前先將 URL 限制為 GitHub。** `documentation` 的值是使用者提供的
  輸入。只接受託管於 GitHub 的 README URL：
  - `https://github.com/<owner>/<repo>/blob/<ref>/<path>`
  - `https://github.com/<owner>/<repo>/raw/<ref>/<path>`
  - `https://raw.githubusercontent.com/<owner>/<repo>/<ref>/<path>`

  若 URL 指向其他位置（或根本不是 URL），**此檢查失敗**，且不要擷取它。
- **要求 URL 指向 README 檔案。** 去除任何片段／查詢字串（見下文）後，
  URL 路徑必須以 `README.md` 結尾（不區分大小寫）。若它指向其他
  Markdown 檔案，**此檢查失敗**，並請提交者改連結到該預設集的 README。
- 擷取 `documentation` 欄位中的**確切 URL**。先去除任何片段（`#...`）
  或查詢字串（`?...`）——這些在從瀏覽器介面複製時很常見，必須忽略，
  使擷取目標確定。然後解析要擷取的原始內容：
  - 對於 `github.com/<owner>/<repo>/blob/<ref>/<path>` URL，擷取等價的
    `github.com/<owner>/<repo>/raw/<ref>/<path>` URL（僅將 `/blob/` 換成 `/raw/`）。
  - `github.com/.../raw/...` 與 `raw.githubusercontent.com/...` URL 則原樣擷取。

  不要改寫成 `raw.githubusercontent.com/<owner>/<repo>/<ref>/<path>` 形式
  ——該格式無法可靠表示含有斜線的 ref（例如 `feature/foo` 分支）。
  確認擷取到的 URL 能解析為可讀取的 Markdown 檔案。
- **驗證 README 含有有效的 Spec Kit CLI 安裝命令。** 擷取到的
  README 必須至少包含一個 `specify preset add ...` 呼叫。最強的訊號是
  型錄安裝形式，其 URL 與提交的**下載 URL** 相符：
  - `specify preset add --from <download-url>`（首選），或
  - `specify preset add <preset-id>`，或
  - `specify preset add --dev <path>`

  `specify preset add --from <url>` 命令只有在其 `<url>` 與提交的下載 URL
  **完全相符**時才算數。若 README 還包含一個可依標籤範圍或相符的發行資產
  辨識為屬於此預設集的 `--from` 發行 URL，且與下載 URL 不同，即使同時存在
  其他可接受的命令（`specify preset add <preset-id>` 或
  `specify preset add --dev <path>`），仍判為**失敗**。不要把 monorepo 中
  另一個預設集未限定範圍的發行 URL 標記為過期。裸封存標籤只有在下載的
  封存檔包含一個 `preset.yml` 時才進行比較：單憑裸標籤無法在多預設集
  封存檔中辨識它屬於哪個預設集。只有有效 `--dev` 命令的 README
  仍可接受。步驟 2g 的驗證工具會強制執行此比較。

  若**沒有**任何可接受的 `specify preset add ...` 命令，README 會被視為
  通用說明／宣傳文案，而非預設集使用文件——**此檢查失敗**，並告知提交者
  加入有效的安裝命令（理想上是
  `specify preset add --from <download-url>`）。
- **在 monorepo 中優先使用預設集範圍的 README。** 若 `documentation` 在
  monorepo 中解析到通用的儲存庫根目錄 README（預設集位於諸如
  `presets/<id>/` 的子目錄，且該處存在預設集範圍的 README），請在留言中
  **標記**此事，並建議提交者將 `documentation` 指向預設集範圍的 README
  （例如 `presets/<id>/README.md`），讓型錄呈現使用方式而非行銷內容。
  **僅當**根目錄 README 仍包含此預設集的有效 `specify preset add ...`
  命令時，才將此視為標記而非硬性失敗；否則依上方 2d 檢查判為失敗。

### 2e. 發行與下載 URL 驗證
- 下載 URL 必須屬於提交的儲存庫
  （`https://github.com/<owner>/<repo>/...`，其 `<owner>/<repo>` 與
  儲存庫 URL 相同）。拒絕任何其他 GitHub 儲存庫的 URL。
- 下載 URL 必須遵循下列可接受的標籤固定模式之一：
  `https://github.com/<owner>/<repo>/archive/refs/tags/<tag>.zip`
  或
  `https://github.com/<owner>/<repo>/releases/download/<tag>/<asset>.zip`
- 若下載 URL 路徑包含 `releases/latest/`，加以拒絕並說明原因
  ——此 URL 是浮動的，不可接受。將此固定檢查標記為失敗，並略過對此 URL 的
  HTTP 請求，然後繼續其餘驗證。
- URL 中的 `<tag>` 區段必須與提交的版本對應。
  接受 `vX.Y.Z`、`X.Y.Z`，以及版本後綴相符的限定範圍標籤
  （例如版本 `1.0.0` 對應 `aide-v1.0.0`）。拒絕內嵌 semver 與提交版本
  不相等的標籤。
- 只有在所有固定檢查都通過後，才擷取下載 URL 並執行其餘成品檢查：
  - 驗證 URL 回傳 HTTP 200。
  - 若包含 `sha256`，驗證它與下載的封存檔相符。要求每個型錄項目都必須有
    `sha256` 是後續工作；欄位缺失時絕對不可讓此檢查失敗。
  - 驗證該標籤存在對應的 GitHub release。

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
型錄／文件、不建立 PR。絕對不要以計算出的或發行中繼資料的摘要值取代
不相符的提交總和檢查碼。無法執行或無法讀取封存檔的命令屬於 Blocked，
不是成功的比較。
受阻或失敗的下載不得算作通過的檢查；儲存庫／發行中繼資料不能替代
實際擷取封存檔。絕對不要執行下載的內容。

### 2f. 提交檢核清單
- 確認 Testing Checklist 與 Submission Requirements 區段中所有必填的
  核取方塊都已勾選（`[x]`）

### 2g. 可重現的已發佈成品與 README 比較

在固定下載回傳 HTTP 200 且選填的總和檢查碼比較成功之後，使用編輯工具
將擷取到的**確切文件 README** 儲存為 `/tmp/gh-aw/preset-readme.md`。
使用編輯工具將 `/tmp/gh-aw/preset-submission.json` 儲存為 JSON 物件，
其鍵為下列直接從 issue 表單複製（不要從 README 或封存檔推斷）的值：
`preset_id`、`preset_name`、`version`、`description`、`author`、`repository`、
`download_url`、`documentation`、`license`、`speckit_version`、
`required_extensions`（缺失時為空字串）、`templates_provided`、
`commands_provided`、`scripts_count`（缺失時為字串 `"0"`），以及 `tags`。
多行清單值保留為字串。不要將 issue 或 README 文字插入 shell 命令。
原樣執行這條固定命令：

```bash
python3 .github/scripts/validate_community_preset.py submission --issue /tmp/gh-aw/preset-submission.json --archive /tmp/gh-aw/community-archive.zip --readme /tmp/gh-aw/preset-readme.md --catalog presets/catalog.community.json --docs docs/community/presets.md --snapshot /tmp/gh-aw/preset-validation.json
```

驗證工具會從下載的 ZIP 中讀取 `preset.yml`，包括 monorepo 中預設集範圍的
路徑；它解析 YAML 時不會執行封存檔內容。它會對照 issue 檢查已發佈的
ID、版本、Spec Kit 需求、所需擴充功能 ID、發行標籤與 README 安裝參照，
然後記錄驗證過的值、提交驗證當下的目前 UTC 日期，以及供產生檔案檢查
使用的既有 `created_at`。結束代碼 1（`FAILED`）表示已確認的提交不一致：
在 issue 上以 Failed 回報，不建立 PR。結束代碼 2（`BLOCKED`）表示
驗證工具無法讀取封存檔或其他必要輸入（包括缺少 Python 相依套件）：
在 Blocked 區回報確切錯誤與執行連結。兩種結束代碼都不要視為通過。

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
- 在此停止處理，不編輯型錄／文件檔案、不開啟 PR。
  不要評估下方的 Failed 或 Passed 結果。

#### Failed

若沒有環境阻礙，且已完成的檢查發現提交缺陷：
1. 在 issue 上留言，逐項列出每個失敗的檢查，清楚說明問題所在與修正方法
2. 移除 `validation-passed`
3. 加上 `validation-failed` 標籤
4. **停止——不要再繼續**

#### Passed

若沒有環境阻礙，且每個必要檢查都已完成並通過：
1. 移除先前執行遺留的過期 `validation-passed` 與 `validation-failed` 標籤。
2. 繼續進行步驟 3。**先不要加上 `validation-passed`**：產生的型錄與文件
   必須先通過步驟 5 的驗證工具，成功才會被記錄。

## 步驟 3 — 判定新增或更新

在 `presets/catalog.community.json` 中搜尋預設集 ID。

- **找不到** → 這是**新增**
- **找到** → 這是**更新**——原地取代既有項目；
  保留既有項目的 `created_at`

## 步驟 4 — 更新 `presets/catalog.community.json`

編輯 `presets/catalog.community.json`，新增或更新預設集項目。

無論新增或更新，都只有在每個必要驗證通過後，才將 `sha256` 設定為
從下載封存檔取得的 `actual_sha256`。即使未提交總和檢查碼也要這樣做。
取代先前型錄中的任何摘要值；不要重用舊封存檔的摘要值。提交的不符
必須在此步驟之前就讓驗證失敗；絕對不可用寫入計算出的摘要值來繞過
該失敗。

### 新增預設集

將項目插入 `"presets"` 物件中**依預設集 ID 的字母順序**排列的位置。
使用下列結構：

```json
{
  "<id>": {
    "name": "<name>",
    "id": "<id>",
    "version": "<version>",
    "description": "<description>",
    "author": "<author>",
    "repository": "<repository>",
    "download_url": "<download_url>",
    "sha256": "<actual_sha256>",
    "homepage": "<submitted repository URL>",
    "documentation": "<documentation URL — the validated preset-usage README>",
    "license": "<license>",
    "requires": {
      "speckit_version": "<speckit_version>"
    },
    "provides": {
      "templates": <N>,
      "commands": <N>
    },
    "tags": ["<tag1>", "<tag2>"],
    "created_at": "<validated UTC date>T00:00:00Z",
    "updated_at": "<validated UTC date>T00:00:00Z"
  }
}
```

若預設集有所需的擴充功能，在 `"requires"` 中加入 `"extensions"` 陣列：

```json
"requires": {
  "speckit_version": "<speckit_version>",
  "extensions": ["<extension-id>"]
}
```

若預設集提供指令碼，在 `"provides"` 中加入 `"scripts": <N>`。

### 更新

只取代有變更的欄位（通常是 `version`、`download_url`、
`description`、`homepage`、`provides`、`requires`、`tags`、`updated_at`）。
將 `homepage` 設定為提交的儲存庫 URL；表單沒有獨立的首頁欄位。**保留**
既有項目的 `created_at`。`updated_at` 使用驗證工具快照中驗證過的 UTC
日期，即使執行期間 UTC 日期改變也一樣。

### 計算範本與命令的數量

解析「Templates Provided」與「Commands Provided」issue 欄位：
- 計算清單項目的數量（以 `-` 開頭的行）
- 若欄位內容為「None」，數量為 0

### 編輯之後

將型錄最上層的 `"updated_at"` 時間戳更新為驗證工具快照的 UTC 日期，
格式為 ISO 8601。

步驟 5 的產生檔案驗證工具會解析並檢查 JSON。修正它回報的任何型錄錯誤，
並在繼續之前重新執行。

## 步驟 5 — 更新 `docs/community/presets.md`

編輯 `docs/community/presets.md`，在 Community Presets 表格中新增或更新一列。

### 新增預設集

將新列插入**依預設集名稱的字母順序**排列的位置：

```
| <Name> | <Description> | <N> templates, <N> commands | <Requires> | [<repo-name>](<repository-url>) |
```

Requires 欄位：
- 若不需要任何擴充功能，使用 `—`
- 若有，列出所需的擴充功能 ID（例如 `aide extension`），以逗號分隔
- 在 Provides 中省略數量為零的種類，數量為一時使用單數名詞

若預設集提供指令碼，一併列入：`<N> templates, <N> commands, <N> scripts`

### 更新

找到既有的列，原地更新任何有變更的欄位。

### 驗證產生的檔案

在標記成功或要求建立 PR 之前，原樣執行這條固定命令：

```bash
python3 .github/scripts/validate_community_preset.py generated --issue /tmp/gh-aw/preset-submission.json --archive /tmp/gh-aw/community-archive.zip --readme /tmp/gh-aw/preset-readme.md --catalog presets/catalog.community.json --docs docs/community/presets.md --snapshot /tmp/gh-aw/preset-validation.json
```

驗證工具會檢查 JSON 解析、驗證過的型錄中繼資料（包括 `homepage` 設定為
提交的儲存庫 URL）與摘要值、最上層與項目 `updated_at` 時間戳是否符合
記錄的 UTC 日期（新增項目還包括 `created_at`）、ID 的字母順序、
文件列的名稱、用途、數量、擴充功能需求與儲存庫連結、名稱的字母順序，
以及更新時 `created_at` 的保留。結束代碼 3（`REPAIR`）是代理產生的
型錄或文件錯誤，**不是**提交者的缺陷：修正檔案並重新執行此命令，
直到結束代碼為 0。不要因為產生檔案的錯誤而標記 `validation-failed`。
結束代碼 2（`BLOCKED`）表示某個輸入或工具無法使用：向維護者回報確切
錯誤與工作流程執行連結，移除 `validation-passed`，並停止，不建立 PR。
若產生檔案的錯誤無法修正，移除 `validation-passed`，停止且不建立 PR，
並回報問題供維護者調查。

## 步驟 6 — 建立 Pull Request

只有在產生檔案驗證工具以結束代碼 0 結束後，才加上 `validation-passed`
標籤，並要求建立已設定的草稿 pull request 來提交變更。使用下列分支
命名慣例：

這個由儲存庫擁有的 gh-aw 維護工作流程不執行貢獻者未結 PR 數量檢查，
也不要求確認。驗證成功且允許的型錄／文件檔案更新完成後，無論提交者
或提出帳號目前有多少未結 PR，一律發出已設定的草稿 `create_pull_request`
安全輸出。

- **新增預設集：** `add-<preset-id>-preset`
- **更新：** `update-<preset-id>-preset`

### 提交訊息

新增預設集：
```
Add <Name> preset to community catalog

Add <id> preset submitted by @<issue-author> to:
- presets/catalog.community.json (alphabetical order)
- docs/community/presets.md community presets table

Closes #<issue-number>
```

更新：
```
Update <Name> preset to v<version>

Update <id> preset submitted by @<issue-author>:
- presets/catalog.community.json (version, download_url, etc.)
- docs/community/presets.md community presets table

Closes #<issue-number>
```

### PR 說明

包含：
- 變更內容摘要
- 驗證結果（所有檢查皆通過）
- `Closes #${{ github.event.issue.number }}`
- `cc @<issue-author>`——提及提交者

## 重要規則

- **字母順序很重要**——項目在 JSON 中必須依 ID 排序，
  在文件表格中必須依名稱排序
- **編輯後務必驗證 JSON**——多餘的逗號或缺少的大括號都會損壞型錄
- **使用 `Closes` 而非 `Fixes`**——`Closes #N` 是提交 issue 的正確關鍵字
- **更新時保留 `created_at`**——保留原始值；只更新 `updated_at`
- **不要修改任何其他檔案**——僅限 `presets/catalog.community.json`
  與 `docs/community/presets.md`
