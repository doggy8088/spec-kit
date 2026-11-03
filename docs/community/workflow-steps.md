# 社群工作流程步驟類型

> [!NOTE]
> 社群工作流程步驟類型由其作者獨立建立與維護。維護者會驗證提交中繼資料與套件格式，但不審查、稽核、背書或支援其中可執行的 Python 程式碼。安裝時會驗證並複製套件，不會匯入其 Python 程式碼。後續的 `specify workflow add`、`run` 與 `resume` 命令會載入已安裝的步驟套件，並以使用者的權限執行匯入時期程式碼。安裝前請先檢視原始碼，並自行斟酌使用。

自訂工作流程步驟套件可加入工作流程能使用的 `type:`，擴充內建步驟類型。標準的收件路徑是
[Workflow Step Type Submission](https://github.com/github/spec-kit/issues/new?template=workflow_step_submission.yml)
issue 表單，適用於新項目、版本更新與中繼資料修正。

開啟表單只會套用 `triage-must-have` 判定。維護者在分流時套用 `workflow-step-submission`，以啟動自動化中繼資料驗證。驗證成功後，會在草稿 PR 中提出目錄與文件變更，供維護者審查。自動化流程不會安裝、匯入、執行或審查提交的 Python 程式碼。

經接受的項目發佈於
[`workflows/step-catalog.community.json`](https://github.com/github/spec-kit/blob/main/workflows/step-catalog.community.json)。
內建社群目錄僅供探索。經接受的項目可出現在 `specify workflow step search` 與 `info` 中，但
`specify workflow step add <id>` 不會從該來源安裝可執行程式碼。檢視原始碼後，請直接以 `--from` 安裝提交的具版本編號封存檔，或使用另行設定且明確允許安裝的步驟目錄。

## 可用的步驟類型

| 步驟類型 | 版本 | 說明 |
| --- | --- | --- |
| [Decision](https://github.com/markuswondrak/spec-kit-decision-step) (`decision`) | 0.9.0 | 具型別的有界選擇、評分與 noul 決策，附原生機率與評分圖例，使用 Jev 與 Laya 後端。 |

Decision 由 [Markus Wondrak](https://github.com/markuswondrak) 維護。
與其他社群提交表格相同，作者中繼資料屬於目錄內容，不用來取代維護者歸屬。

Decision 宣告與 Spec Kit `>=0.11.0` 的執行時期相容性；以 `--from` 安裝其
[具版本編號的 release 封存檔](https://github.com/markuswondrak/spec-kit-decision-step/releases/download/v0.9.0/decision-0.9.0.zip)
需要 Spec Kit `>=1.1.0`。目錄的相容性欄位僅供參考，目前的步驟安裝程式不會強制執行。

此套件使用主機的 PyYAML 與 `specify_cli` 套件。Jev 需要
`TYPESAFE_API_KEY`（或已設定的 `api_key_env`），並需能以 HTTPS 對外連線至已設定的後端端點；行程內 Laya 則需要選用的
`laya[onnx]` 套件。設定、輸出、失敗行為與副作用請參閱
[固定版本的說明文件](https://github.com/markuswondrak/spec-kit-decision-step/blob/v0.9.0/README.md)，
release 詳細資訊請參閱
[changelog](https://github.com/markuswondrak/spec-kit-decision-step/blob/v0.9.0/CHANGELOG.md)。
採 MIT 授權的資訊清單將 `spec-kit-decision-step contributors` 列為套件作者。

## 套件合約

一個已安裝套件提供一種工作流程步驟類型：

```text
my-step/
├── step.yml
├── __init__.py
└── helpers.py     # optional; every catalog-downloaded extra file is declared
```

套件必須符合目前的安裝程式與載入程式合約：

- `step.yml` 與 `__init__.py` 是套件根目錄下的一般檔案，且不是符號連結。封存檔可將套件包在恰好一層頂層目錄中。
- `step.type_key`、目錄鍵／ID 與對應的 `StepBase.type_key` 必須完全相同。
- ID 必須是單一安全的路徑元件。安裝程式會拒絕分隔符號、開頭的點、結尾的點或空格、保留名稱、控制字元，以及 Windows 不允許的檔名字元。目錄自動化另要求使用小寫字母、數字與連字號，且以字母開頭。
- `__init__.py` 定義與該單一類型鍵對應的 `StepBase` 子類別。額外的類別不會讓套件提供額外的已註冊步驟類型。此為作者的聲明，不是維護者的程式碼檢查。
- 額外檔案路徑使用正斜線、為相對且非空路徑，不包含空的、`.` 或 `..` 區段，且不以不分大小寫方式與 `step.yml`、`__init__.py`、其他檔案或套件目錄別名衝突。
- 套件須維持在目前安裝程式的限制內：保留項目上限 512 個（檔案與目錄合計）、目錄深度 32 層、保留內容 50 MiB。提交下載另有每檔 10 MiB 的限制。
- `.git`、`__pycache__` 與 `.DS_Store` 會在安裝時排除；提交自動化會拒絕這些元件的不分大小寫別名。

完整的安裝、驗證與執行時期行為，請參閱 [Custom step packages](../reference/workflows.md#custom-step-packages)。

## 提交合約

issue 表單將目前套件／目錄程式碼使用的欄位，與中繼資料審查時使用的來源與揭露欄位分開。

| 提交資料 | 目前合約 |
| --- | --- |
| 步驟類型 ID | 目錄鍵、`step.type_key` 與對應的 `StepBase.type_key` |
| 名稱、版本、說明、作者 | `step.yml` 中繼資料與目錄／已安裝登錄中繼資料 |
| 下載 URL | 用於測試受支援的直接 URL 安裝路徑的具版本編號 release 封存檔 |
| `step.yml`、`__init__.py` 與額外檔案 URL | 從明確允許安裝的目錄安裝時使用的精確 HTTPS 檔案 URL；額外檔案鍵遵循上述套件相對路徑限制 |
| 每檔 SHA-256 對應 | 目錄 `sha256`；鍵必須恰好是安裝程式下載的檔案 |
| 提供的類型名稱／數量 | 載入程式不變條件：每個已安裝套件恰好一個對應的類型鍵 |
| 儲存庫、授權、文件、changelog | 來源出處與中繼資料審查證據；這些不是 `step.yml` 欄位 |
| Spec Kit 相容性 | 必要的收件揭露；以建議性的 `requires.speckit_version` 儲存，安裝程式不強制執行 |
| 執行時期與工具相依性 | 必要的收件揭露；CLI 不會為自訂步驟解析或安裝相依性 |

封存檔請使用具版本編號的 GitHub release URL，與其他社群提交表單一致。版本必須符合 PEP 440，且與資訊清單一致。封存檔的 release 標籤必須標示該版本，可加上 `v` 前綴或範圍前綴，且不得包含斜線。
紀元版本如 `1!2.0` 與本機版本如 `2.0+cpu` 皆受支援。標籤字元必須符合 `^[A-Za-z0-9._~+!-]+$`。
所有目錄檔案 URL 在提交的儲存庫中必須使用 `raw.githubusercontent.com`，並固定至該確切的 release 標籤與套件目錄。必要的每檔 SHA-256 對應可在被參照的標籤日後移動時，偵測位元組變更。請勿提交分支 URL、`releases/latest` URL 或其他浮動目標。

封存檔 URL 路徑必須符合 `^[A-Za-z0-9._~+!/-]+$`。標籤內的套件相對檔案鍵與檔案路徑必須符合 `^[A-Za-z0-9._~/-]+$`。
社群提交自動化不接受空格、百分比轉義（包含資產名稱中的 `%20`）、查詢字串、片段，以及空的、點或穿越形式的檔案路徑區段。請以這些字母集內的名稱發佈封存檔與套件檔案，不要以 URL 編碼未支援的字元。

GitHub 產生的 `archive/refs/tags/<tag>` 封存檔僅支援 `.zip` 與 `.tar.gz`。`.tgz` 封存檔必須是名為 `releases/download/<tag>/<asset>.tgz` 的 release 資產，而不是產生的標籤封存檔。

文件可以是提交的 GitHub 儲存庫中任何固定至標籤的 Markdown 檔案（`.md`，不分大小寫），包含 `docs/deploy.md`；不一定要名為 `README.md`。文件必須說明安裝、設定、相依性、輸出、失敗行為、副作用與工作流程使用範例。

直接以 `--from` 安裝封存檔的安裝程式目前不接受也不驗證封存檔摘要。提交的 Download URL 與 Testing Details 欄位提供具版本編號 release 與安裝測試證據，不構成不可變的內容保證；每檔摘要保護的是另一條目錄安裝路徑。
自動化會在一次傳遞中下載完整宣告的檔案集，以強制執行累計位元組預算。自動化不會執行封存檔或其內容。

授權必須是官方授權清單中恰好一個 SPDX 授權識別字，且與提交的 release 標籤偵測到的儲存庫授權一致。
未知識別字或已知的授權不符會導致驗證失敗。若 release 授權偵測無法取得或結果不明確，驗證會被封鎖並等待維護者釐清，而不是猜測授權。此中繼資料檢查不是法律意見或程式碼稽核。

## 準備提交

1. 建立公開的原始儲存庫，包含完整的套件、授權、文件與適用的 changelog。
2. 測試有效與無效的設定、`StepStatus`、輸出、錯誤，以及任何相關的 resume、巢狀步驟或並行執行行為。
3. 發佈具版本編號的 release 封存檔（`.zip`、`.tar.gz` 或具名的 `.tgz` release 資產），並進行測試：

   ```bash
   specify workflow step add my-step \
     --from https://github.com/your-org/my-step/releases/download/v1.0.0/my-step-1.0.0.zip
   ```

4. 為 `step.yml`、`__init__.py` 與每個額外的套件檔案發佈固定至標籤的原始 GitHub URL。計算每個下載檔案的 SHA-256 摘要。
5. 提出標準的提交 issue，附上確切的 release 中繼資料與測試證據。

## 自動化中繼資料驗證

由維護者觸發的工作流程會檢查完整的中繼資料、一致的資訊清單身分、固定至 release 的檔案 URL、每檔摘要、套件路徑與限制、文件，以及作者的測試聲明。自動化不會審查提交的程式碼，也不會聲稱驗證其執行行為。

已確認的提交缺陷會產生 `validation-failed` 與可據以修正的說明。環境失敗，包含權限、工具無法使用、逾時與暫時性 HTTP 失敗，會被封鎖，而不是視為提交缺陷。只有受保護的結論工作能在成功發佈草稿目錄 PR 後，套用 `validation-passed`。

新版本會保留既有的目錄 release 歷史。相同版本的中繼資料修復必須明確標示，且不能取代檔案 URL 或摘要；套件內容變更時請發佈新版本。
儲存庫持有的驗證器會在編輯前快照預期的目錄，並在建立 PR 前檢查完整產生的目錄，包含先前目前 release 的遷移與歷史保留。既有 release 摘要缺失會封鎖發佈，等待維護者修復。
