# 核心命令

核心 `specify` 命令處理專案初始化、系統檢查與版本資訊。

## 初始化專案

```bash
specify init [<project_name>]
```

| 選項 | 說明 |
| ------------------------ | ------------------------------------------------------------------------ |
| `--integration <key>`    | 要使用的 AI 程式代理整合（例如 `copilot`、`claude`、`gemini`）。所有可用鍵請參見[整合目錄](../integrations/index.md) |
| `--integration-options`  | 整合的選項（例如 `--integration-options="--commands-dir .myagent/cmds"`） |
| `--script sh\|ps\|py`    | 指令碼類型：`sh`（bash/zsh）、`ps`（PowerShell）或 `py`（Python）       |
| `--here`                 | 在目前目錄初始化，而非建立新目錄        |
| `--force`                | 在既有目錄初始化時強制合併／覆寫         |
| `--allow-symlinks`       | 持續允許已遷移 FileHelper 操作中包含的符號連結；預設為拒絕 |
| `--ignore-agent-tools`   | 略過 AI 程式代理 CLI 工具的檢查                                |
| `--preset <id>`          | 在初始化期間安裝預設集                                   |

建立新的 Spec Kit 專案，包含必要的目錄結構、範本、指令碼與 AI 程式代理整合檔案。

> [!NOTE]
> Git 儲存庫的初始化與分支由 **git 擴充功能**管理，該擴充功能預設未安裝。在 init 後執行 `specify extension add git` 以啟用 git 工作流程。

使用 `<project_name>` 建立新目錄，或使用 `--here`（或 `.`）在目前目錄初始化。若目錄已有檔案，請使用 `--force` 在不經確認的情況下合併。

省略 `--integration` 時，互動式終端機會提示你選擇整合。非互動式工作階段，例如 CI 或管線執行，預設為 GitHub Copilot；傳入 `--integration <key>` 可明確選擇不同的整合，或設定 `SPECKIT_INTEGRATION_DEFAULT` 變更備援值（請參見[環境變數](#environment-variables)）。

### 已保存的檔案系統原則

只有 `init` 接受 `--allow-symlinks`。它會在 `.specify/init-options.json` 中記錄 `allow_symlinks: true`；省略時記錄 `false`，包括重新初始化時。專案範圍的 CLI 命令在每次呼叫時讀取目前值，因此手動編輯會立即生效。檔案或鍵遺失表示拒絕；值必須是 JSON 布林值，不是字串、數字或 null。無效或無法讀取的設定是錯誤，不是備援。無關的已記錄 init 選項會保留。

設定啟動階層（`.specify` 與 `init-options.json`）在受信任的專案根目錄之下必須永遠不是符號連結，即使在允許模式下也是如此。說明、版本、檢查與無專案的工具／型錄操作不會因此取得專案需求。Init 使用其明確目標，不使用 `SPECIFY_INIT_DIR`。`check` 可以取用已安裝的專案整合：它在載入整合或檢查工具前，會在其選定的 cwd 或 `SPECIFY_INIT_DIR` 邊界驗證任何存在的原則。它在無 `.specify` 或 init 選項的無專案 cwd 中仍可運作。說明與版本不讀取專案原則。

**遷移限制：**原則由 FileHelper 操作強制執行，目前包括 init-options 啟動 I/O。載入原則尚未將所有其他命令的檔案系統操作導向 FileHelper。共用基礎設施、註冊、受管理儲存、指令碼與執行時期操作，在遷移前仍保留其既有行為。邊界與交接合約請參見 [FileHelper 設計](../../design/file-helper.md)。

### 範例

```bash
# Create a new project with an integration
specify init my-project --integration copilot

# Initialize in the current directory
specify init --here --integration copilot

# Force merge into a non-empty directory
specify init --here --force --integration copilot

# Use PowerShell scripts (Windows/cross-platform)
specify init my-project --integration copilot --script ps

# Install a preset during initialization
specify init my-project --integration copilot --preset compliance
```

### 環境變數

| 變數 | 說明 |
| ----------------- | ------------------------------------------------------------------------ |
| `SPECKIT_INTEGRATION_DEFAULT` | 覆寫 `specify init` 在省略 `--integration` 時使用的備援整合（互動提示預設值與非互動備援值）。將它設為任何已註冊的整合鍵（例如 `gemini`、`claude`）。無法辨識的值會被忽略並發出警告，並使用內建預設值（`copilot`）。明確的 `--integration <key>` 永遠優先。 |
| `SPECIFY_INIT_DIR` | 從目錄外（例如 monorepo 根目錄）鎖定成員專案，無需 `cd`，供非互動／CI 使用。將它設為**專案根目錄**，也就是*包含* `.specify/` 的目錄（相對路徑以目前目錄為基準解析）。路徑必須存在且包含 `.specify/`，否則命令會出錯，且**不會**退回目前目錄。它在核心根目錄輔助程式中只解析一次（Bash 中的 `get_repo_root`、PowerShell 中的 `Get-RepoRoot`），因此核心功能指令碼（`/speckit.plan`、`/speckit.tasks` 等）與 Git 擴充功能的功能分支建立都會遵循它，它們會繼承此值。`specify` CLI 對每個專案範圍的子命令（`specify integration …`、`specify extension …`、`specify workflow …`、`specify preset …`，以及其餘操作 `.specify/` 專案的命令）套用**相同**的驗證規則，因此它們也可以鎖定成員專案。未設定時，Bash／PowerShell 輔助程式保持其既有的向上搜尋；`specify` CLI 保持其專案範圍解析器僅限 cwd，除非命令明確定義更廣的偵測（例如套件組命令）。 |
| `SPECIFY_FEATURE_DIRECTORY` | 覆寫啟用中的功能目錄（優先於 `.specify/feature.json`）。相對路徑會連接到專案根目錄，不做包含檢查，因此像 `../shared-feature` 這樣的值仍會解析到其外部；絕對路徑按原樣使用，同樣可能指向專案根目錄之外。專案根目錄仍標識 Spec Kit 專案及其命令／設定上下文，但所選功能目錄本身不需位於其下。與 `SPECIFY_INIT_DIR` 組合使用，可非互動地同時選取專案與功能。 |
| `SPECIFY_FEATURE` | 明確覆寫啟用中的功能**標籤**（例如 `001-photo-albums`），也就是核心輔助程式回報為目前功能／分支的識別碼（Bash 中的 `get_current_branch`、PowerShell 中的 `Get-CurrentBranch`）。這些輔助程式從不檢查 Git：變數已設定時直接原樣回傳，未設定時回傳空字串。基底名稱備援發生在之後，`get_feature_paths`／`Get-FeaturePathsEnv` 會以已解析功能目錄的基底名稱替代，因此回報的標籤仍可使用，所以直接呼叫具名輔助程式**不會**給你該備援。你需自行設定：Bash 與 Python 功能指令碼只會**列印**已註解的 `export SPECIFY_FEATURE=…`／`$env:SPECIFY_FEATURE = …` 提示供你執行，因為子行程無法變更其父行程的環境，而 `/speckit.specify` 會將 `feature_directory` 保存到 `.specify/feature.json`，而非設定此變數。（PowerShell 功能指令碼確實會指派 `$env:SPECIFY_FEATURE`，但只有當指令碼在你目前的 PowerShell 工作階段內執行時才會傳達給你。）它**不會**定位功能目錄：只有 `SPECIFY_FEATURE` 已設定時，`get_feature_paths` 會以 *「Feature directory not found. Set `SPECIFY_FEATURE_DIRECTORY` or run the specify command to create `.specify/feature.json`.」* 失敗。使用 `SPECIFY_FEATURE_DIRECTORY`（見上）或 `.specify/feature.json` 選取目錄。 |
| `SPECIFY_FEATURE_NO_PERSIST` | 設為 `1` 或 `true` 可阻止每個核心指令碼寫入 `.specify/feature.json`，即使它原本會在讀取時保存 `SPECIFY_FEATURE_DIRECTORY`。當多個代理同時對同一個 checkout 執行、各自有自己的 `SPECIFY_FEATURE_DIRECTORY` 時很有用：若無此設定，每次呼叫的保存步驟可能覆寫另一個代理釘選的功能目錄。 |

> **兩個解析軸。** `SPECIFY_INIT_DIR` 選取**專案**（哪個目錄包含 `.specify/`）；`SPECIFY_FEATURE_DIRECTORY`／`.specify/feature.json` 選取**功能**，其預設位置在該專案的 `specs/` 之下，但明確選取的功能目錄不限於位於其內。兩者獨立，先專案，後功能。
>
> **版本控制。** `specify init` 會建立受管理的 `.specify/.gitignore`，排除本機狀態，也就是 `feature.json`（目前功能指標，每次切換功能時重寫）與每台電腦的擴充功能 `extensions/*/local-config.yml` 覆寫，同時讓 `.specify/` 下的其他一切（憲章、範本、指令碼、擴充功能設定）可共用，讓團隊保持一致。如同 `.specify/` 其餘的共用指令碼與範本，此檔案會在共用基礎設施清單中追蹤：你的編輯在重新 init 時會保留，`specify init --here --force` 會還原受管理內容。它會被 `specify integration uninstall` 有意保留原處，該命令只移除被解除安裝代理自己的檔案。
>
> **符號連結的專案根目錄。** 明確建立的專案根目錄別名是受信任的，包括其上方的作業系統祖先。其下的設定階層永遠以拒絕模式檢查：`.specify/` 與 `init-options.json` 不能是符號連結。專案其他位置尚未遷移的操作，保留其既有的符號連結行為。

## 使用輔助指令碼命名功能

直接呼叫隨附的 `create-new-feature` 輔助指令碼時，產生的名稱會在 UTF-8 中保留 Unicode 字母與十進位數字，因此像 `添加用户` 這樣的描述會產生 `001-添加用户`。只由標點組成的描述仍可能產生像 `001-` 這樣的空後綴；發生時指令碼會在 stderr 發出警告，包括試執行時。JSON 輸出仍可解析。

若要選擇不同的名稱，請保留原始描述並提供短名稱：

```bash
bash .specify/scripts/bash/create-new-feature.sh --json --short-name 用户管理 "添加用户"
```

Python 輔助程式也接受 `--short-name`；PowerShell 輔助程式使用 `-ShortName`。提供的短名稱會依相同規則清理，因此必須至少包含一個字母或數字。對於非 ASCII 名稱，Bash 輔助程式需要已安裝的 UTF-8 語系與 Python 3 直譯器進行 Unicode 分類。ASCII 輸入，包括 tab 與換行，不需要這兩者即可清理。若 `LC_ALL` 非空，Bash 會使用該語系，而非另選一個：若所選語系無法用於 UTF-8 名稱，Unicode 名稱會以錯誤失敗。當 `LC_ALL` 未設定或為空時，Bash 會選取已安裝的 UTF-8 語系，即使 `LANG` 或 `LC_CTYPE` 指定了非 UTF-8 語系。ASCII 大寫字母會轉為小寫；非 ASCII 字母的大小寫在各指令碼變體間會保留。

## 檢查已安裝的工具

```bash
specify check
```

檢查以 CLI 為基礎的 AI 程式代理是否可在你的系統上使用。IDE 型代理會被略過，因為它們不需要 CLI 工具。

已安裝的專案整合在可用時會包含在內。在所選專案邊界存在的任何檔案系統原則都必須有效；無專案的 cwd 在無設定時仍受支援。

此命令保持離線。若命令行為像舊版 Spec Kit，或預期的 CLI 功能遺失，請執行 `specify self check` 檢查你的本機 CLI 是否落後於最新版本。

## 版本資訊

```bash
specify version
```

顯示 Spec Kit CLI 版本、Python 版本、平台與架構。

若要在不檢查網路的情況下檢視本機 CLI 功能：

```bash
specify version --features
```

若要以 JSON 列印完整的版本、執行環境、系統與功能資訊，請使用：

```bash
specify version --json
```

組合 `--features` 與 `--json` 會輸出相同的完整 JSON 輸出；在 JSON 模式下，`--features` 不會篩選結果。若 OpenSSL 資訊不可用，`runtime.openssl` 為 `null`。成功的 JSON 輸出只寫入 stdout。失敗時 stdout 保持空白，並將一個已清理的 JSON 錯誤物件寫入 stderr。

快速版本檢查也可透過以下方式取得：

```bash
specify --version
specify -V
```

## 實驗性 MCP 伺服器

```bash
specify mcp
```

啟動實驗性、僅限 stdio 的 MCP 伺服器。初始伺服器只透過通用 list、describe 與 run 工具公開穩定的 `version` JSON 命令。工具名稱、結果合約與目前限制請參見 [MCP 伺服器參考](mcp.md)。
