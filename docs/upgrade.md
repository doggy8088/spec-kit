# 升級指南

> 你已安裝 Spec Kit，想升級至最新版本，以取得新功能、錯誤修正或更新的斜線命令。本指南涵蓋升級 CLI 工具與更新專案檔案兩部分。

---

## 快速參考

| 升級對象 | 命令 | 使用時機 |
|----------------|---------|-------------|
| **CLI 工具（建議）** | `specify self upgrade` | 就地升級至最新穩定 release。自動偵測你是透過 `uv tool` 還是 `pipx` 安裝。 |
| **CLI 工具，固定版本** | `specify self upgrade --tag vX.Y.Z[suffix]` | 升級至特定 release 標籤，而不是最新穩定版。後綴限於 dev、alpha/beta/rc 及／或建置中繼資料形式。 |
| **CLI 工具，手動備援** | `uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git@vX.Y.Z` | 當 `specify self upgrade` 無法使用（較舊的安裝）或需要明確控制時使用。 |
| **CLI 工具，手動備援（pipx）** | `pipx install --force git+https://github.com/github/spec-kit.git@vX.Y.Z` | 同上，適用於 pipx 安裝。 |
| **專案檔案** | 執行 `specify integration upgrade <key>`，再執行 `specify extension update` | 重新整理專案中已安裝的整合檔案與擴充功能 |
| **兩者皆升級** | 先升級 CLI，再更新專案 | 建議用於主要版本更新 |

---

## 第 1 部分：升級 CLI 工具

CLI 工具（`specify`）與專案檔案各自獨立。升級 CLI 可取得最新功能與錯誤修正。

若你是從 PyPI 安裝並想維持該安裝途徑，請依循
[PyPI 升級說明](install/pypi.md#upgrade)。重複執行
`uv tool install specify-cli` 不會升級既有安裝。

### 建議方式：`specify self upgrade`

CLI 隨附兩個自我管理命令，可自動處理常見情況：

```bash
# Check whether a newer release is available (read-only — does not modify anything)
specify self check

# Preview what would run, without actually upgrading
specify self upgrade --dry-run

# Upgrade in place to the latest stable release (auto-detects uv tool vs pipx install)
specify self upgrade

# Or pin a specific release tag (replace vX.Y.Z[suffix] with the tag you want)
specify self upgrade --tag vX.Y.Z[suffix]
```

直接執行 `specify self upgrade` 會立即執行，與 `pip install -U`、`npm update` 等命令的免提示行為一致。CLI 會將你的執行環境分類為以下之一：`uv tool`、`pipx`、`uvx (ephemeral)`、原始碼簽出或不受支援。只有 `uv tool` 與 `pipx` 會自動升級；對於 `uv tool` 安裝，底層會執行 `uv tool install specify-cli --force --from <git ref>`，以便固定的 release 標籤也能運作。其他路徑會印出路徑專屬的指引並以 0 結束，不更動任何內容。

固定的標籤必須以 `vMAJOR.MINOR.PATCH` 開頭。選用的後綴限於 dev、alpha/beta/rc 及／或建置中繼資料形式，例如 `v1.0.0-rc1`、`v0.8.0.dev0`、`v0.8.0+build.42`，或組合形式 `v1.0.0-rc1+build.42`；分支名稱、雜湊參照、`latest` 與不含 `v` 的裸版本會被拒絕。

設定 `SPECIFY_UPGRADE_TIMEOUT_SECS` 可限制安裝程式子行程的最長執行時間（預設：無逾時，如有需要以 `Ctrl+C` 中斷）。若該內部逾時觸發，`specify self upgrade` 會以 124 結束，並回報在等待安裝程式子行程時逾時，包含已設定的逾時與手動重試命令。真正的安裝程式結束碼 124 會以 `Upgrade failed. Installer exit code: 124.` 傳遞，因此指令碼應將結束碼 124 視為不確定，並在需要區分兩種情況時檢視訊息。

若你安裝的 CLI 比引入 `specify self upgrade` 的 release 更舊，請使用下方的手動等效命令。這些命令在你需要明確控制安裝程式命令時也很有用。

### 若你是使用 `uv tool install` 安裝

升級至特定 release（最新標籤請查閱 [Releases](https://github.com/github/spec-kit/releases)）：

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git@vX.Y.Z
```

### 若你使用一次性的 `uvx` 命令

指定想要的 release 標籤：

```bash
uvx --from git+https://github.com/github/spec-kit.git@vX.Y.Z specify init --here --integration copilot
```

`uvx` 會為該單一命令執行 Spec Kit 的暫時副本。它不會更新以 `uv tool install`、`pipx` 或其他工具管理器安裝的持久 `specify`。若某個較新的功能透過 `uvx` 可以運作，但本機的 `specify` 仍回報較舊版本，請以符合你安裝方式的命令升級持久的 CLI。

### 若你是使用 `pipx` 安裝

升級至特定 release：

```bash
pipx install --force git+https://github.com/github/spec-kit.git@vX.Y.Z
```

### 驗證升級

```bash
# Confirms the CLI is working and shows installed tools
specify check

# Confirms the installed version against the latest GitHub release
specify self check
```

`specify check` 顯示周邊工具環境；`specify self check` 為唯讀，會告訴你目前是否已在最新 release（`Up to date: X.Y.Z`），或在 release 之間是否有更新的版本可用。

---

## 第 2 部分：更新專案檔案

當 Spec Kit 發佈新功能（例如新的斜線命令、更新的範本或擴充功能變更）時，你需要重新整理已安裝至專案中的 Spec Kit 檔案。

### 會更新哪些內容？

對於既有的 Spec Kit 專案，請先使用具資訊清單意識的升級路徑：

- ✅ **整合命令／技能檔案**（`.claude/skills/`、`.github/skills/`、`.agents/skills/` 等）
- ✅ **受管理的共用指令碼與範本**（`.specify/scripts/`、`.specify/templates/`），前提是它們與先前受管理的副本相比未變更
- ✅ **已安裝的擴充功能**，當你執行 `specify extension update` 時

整合升級命令會使用安裝資訊清單偵測本機編輯。若受管理的整合檔案在安裝後被修改，命令會停止，並要求你檢視變更或以 `--force` 重新執行。

### 哪些內容保持安全？

以下檔案**絕不會**被具資訊清單意識的整合／擴充功能升級路徑觸碰：

- ✅ **你的規格**（`specs/001-my-feature/spec.md` 等）- **確認安全**
- ✅ **你的實作計畫**（`specs/001-my-feature/plan.md`、`tasks.md` 等）- **確認安全**
- ✅ **你的憲章**（`.specify/memory/constitution.md`），當使用 `specify integration upgrade` 時
- ✅ **你的原始碼** - **確認安全**
- ✅ **你的 git 歷史** - **確認安全**

`specs/` 目錄完全排除在範本套件之外，升級時絕不會被修改。

### 1. 檢查已安裝的整合

在專案目錄中執行：

```bash
specify integration status
```

此命令會回報預設整合、所有已安裝的整合，以及任何已修改或遺失的受管理檔案。你也可以檢視 `.specify/integration.json`；已安裝的整合列於 `installed_integrations` 之下。

### 2. 升級每個已安裝的整合

在專案目錄中執行：

```bash
specify integration upgrade <key>
```

將 `<key>` 換成已安裝的整合鍵，例如 `copilot`、`claude` 或 `codex`。在安裝多個整合的專案中，每個已安裝的鍵各執行一次命令。

**範例：**

```bash
specify integration upgrade claude
specify integration upgrade codex
```

`--script`、`--integration-options` 與 `--force` 等選項請參閱[整合參考](integrations/cli.md#upgrade-an-integration)。

### 3. 更新已安裝的擴充功能

執行：

```bash
specify extension update
```

不帶擴充功能參數時，此命令會更新所有已安裝的擴充功能。使用 `specify extension update <extension-id-or-name>` 可只更新一個擴充功能。詳細資訊請參閱[擴充功能參考](reference/extensions.md#update-extensions)。

### 備援方式：重新執行 init

若專案早於資訊清單機制、缺少整合中繼資料，或需要更廣泛的復原，你仍可重新執行 init：

```bash
specify init --here --force --integration <your-agent>
```

請將此作為逃生途徑，而不是預設的專案檔案升級路徑。它會重新整理選定的整合與共用專案鷹架，但在覆寫檔案前，不會執行與各整合資訊清單相同的檢查。

## ⚠️ 重要警告

### 1. 憲章檔案與記憶自訂

`specify integration upgrade <key>` 不會更新 `.specify/memory/constitution.md`。

備援的 `specify init --here --force --integration <your-agent>` 路徑同樣會保留既有的 `.specify/memory/constitution.md`；若檔案遺失，init 會從目前的憲章範本建立它。對於具資訊清單意識的升級路徑，你不需要備份／還原憲章的步驟。

與任何廣泛的備援重新整理一樣，在使用 `init --here --force` 之前，請先提交或備份本機自訂，以便檢視產生的差異。

### 2. 自訂的整合、指令碼或範本修改

當資訊清單追蹤的整合檔案在本機被修改時，`specify integration upgrade <key>` 會封鎖，除非你傳入 `--force`。

共用指令碼與範本在仍與先前記錄的受管理副本相符時會被重新整理。本機自訂會被保留，除非你明確使用會覆寫它們的 force／refresh 選項。若你自訂了 `.specify/scripts/` 或 `.specify/templates/` 中的檔案，請先提交或備份：

```bash
# Back up custom templates and scripts
cp -r .specify/templates .specify/templates-backup
cp -r .specify/scripts .specify/scripts-backup

# After upgrade, merge your changes back manually
```

### 3. 重複的斜線命令（IDE 型代理）

部分 IDE 型代理（如 Kilo Code、Cline）在升級後可能會顯示**重複的斜線命令**，新舊版本同時出現。

**解決方式：** 手動刪除代理資料夾中的舊命令檔案。

**Kilo Code 範例：**

```bash
# List current and legacy Kilo command folders
ls -la .kilo/commands/
ls -la .kilocode/workflows/

# Delete old versions (example filenames - yours may differ)
rm .kilocode/workflows/speckit.specify-old.md
rm .kilocode/workflows/speckit.plan-v1.md
```

重新啟動 IDE 以重新整理命令清單。

---

## 行為變更：`/constitution` 不再傳播至範本

`/constitution` 命令（[#3790](https://github.com/github/spec-kit/pull/3790)）現在僅限於
其自身的產出物。它會更新
`.specify/memory/constitution.md` 並寫入 Sync Impact Report，且**不再編輯**
`plan-template.md`、`spec-template.md`、`tasks-template.md`、已安裝的命令檔案或指引文件。

### 原因

Spec Kit 使用**執行時期解析**：`plan`、`tasks` 與 `analyze` 在每次執行時即時讀取
`.specify/memory/constitution.md`，而 `analyze` 是專屬的漂移檢查器。受治理的範本攜帶的是指標，而不是副本，`plan-template.md` 隨附
`[Gates determined based on constitution file]`，`/plan` 在每次執行時從即時憲章填入該區段。傳播會複製單一事實來源，並與預設集／覆寫組合系統衝突（`replace` 預設集會遮蔽已編輯的核心範本）。

更廣泛而言，預設集與擴充功能，而不是就地編輯檔案，現在是 Spec Kit 治理共用資產的方式。透過解析堆疊組合政策，可讓政策集中持有、具版本管理，並可跨儲存庫稽核，而不是凍結在核心團隊看不見的各儲存庫副本中。

### 這對既有專案是破壞性變更嗎？

**不是，你的工作流程仍可照常運作。** 只有當你仰賴
`/constitution` 就地編輯這些檔案時，才會注意到差異。範本是鷹架，不是權威來源。當你執行 `/plan` 時，它會將範本複製為各功能的 `plan.md`，並從即時憲章重新推導 Constitution Check；`/analyze` 會對照它驗證。即使先前的
`/constitution` 執行曾將具體的關卡文字實體化至 `.specify/templates/plan-template.md`，
即時憲章在執行時期仍是事實來源。

在**非強制升級**時，已實體化的範本會被*保留*（其雜湊與記錄的受管理副本不同，因此重新整理會將其視為自訂而不覆寫）。
不會有任何退化。

### 選用的清理，回到執行時期指標

凍結且預先填好的 Constitution Check 是稍微具誤導性的鷹架，可能影響第一次
`/plan` 的執行。若要完全回到執行時期解析，請將
`.specify/templates/plan-template.md` 中的區段內文重設為指標：

```text
## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]
```

檔案其餘部分保持不變。這是清理，不是必要的遷移。

### 保留舊行為（選擇性啟用）

若你的團隊將已實體化的範本視為**經審查且已提交的產出物**，並希望
`/constitution` 繼續傳播，請安裝隨附的 **`constitution-sync`** 預設集：

```bash
specify preset add constitution-sync
```

它包裝核心的 `/constitution` 命令，並重新加入傳播步驟。它**不會**編輯具版本管理的預設集或擴充功能提供的範本或命令檔案（這些由其套件持有，並在對帳時重新組合）。請注意，這種就地編輯傳播模型，與其餘 SDD 命令在受預設集／擴充功能管理時使用的組合模型衝突，取捨與何時應優先採用預設行為，請參閱
`presets/constitution-sync/README.md` 中的「Interaction with the resolution stack」區段。

---

## 常見情境

### 情境 1：「我只想要新的斜線命令」

```bash
# Upgrade CLI (auto-detects uv tool vs pipx install)
specify self upgrade

# Inspect installed integrations
specify integration status

# Update project files to get new commands
specify integration upgrade <key>
specify extension update
```

### 情境 2：「我自訂了範本與憲章」

```bash
# 1. Commit or back up customizations
git status
cp -r .specify/templates /tmp/templates-backup

# 2. Upgrade CLI
specify self upgrade

# 3. Use the manifest-aware project update first
specify integration upgrade <key>
specify extension update

# 4. If the upgrade reports modified managed files, inspect the diff before using --force
```

### 情境 3：「我在 IDE 中看到重複的斜線命令」

這種情況發生於 IDE 型代理（Kilo Code、Cline 等）。

```bash
# For Kilo Code, inspect both current and legacy command folders
ls -la .kilo/commands/
ls -la .kilocode/workflows/

# Delete old command files
rm .kilocode/workflows/speckit.old-command-name.md

# Restart your IDE
```

### 情境 4：「我不想要 git 擴充功能」

git 擴充功能現在改為選擇性啟用，因此升級不會安裝它，除非你明確加入。

```bash
# Upgrade CLI
specify self upgrade

# Refresh integration files and installed extensions
specify integration upgrade <key>
specify extension update

# The git extension is not added unless you run `specify extension add git`
```

若你日後決定需要 git 擴充功能的命令與掛鉤，請明確安裝：

```bash
specify extension add git
```

不使用 Git 的專案仍可使用 Spec Kit，方法是在規劃命令前，將 `SPECIFY_FEATURE_DIRECTORY` 設定為功能目錄路徑：

```bash
# Bash/Zsh
export SPECIFY_FEATURE_DIRECTORY="specs/001-my-feature"

# PowerShell
$env:SPECIFY_FEATURE_DIRECTORY = "specs/001-my-feature"
```

或者，執行 `/speckit.specify` 命令，它會自動建立 `.specify/feature.json`。

---

## 疑難排解

### 「升級後斜線命令沒有出現」

**原因：** 代理未重新載入命令檔案。

**修正方式：**

1. **完全重新啟動 IDE／編輯器**（不只是重新載入視窗）
2. **對於 CLI 型代理**，確認檔案存在：

   ```bash
   ls -la .claude/skills/        # Claude Code
   ls -la .gemini/commands/      # Gemini
   ls -la .cursor/skills/      # Cursor
   ls -la .pi/prompts/           # Pi Coding Agent
   ls -la .omp/commands/         # Oh My Pi
   ```

3. **檢查代理專屬設定：**
   - Codex 需要 `CODEX_HOME` 環境變數
   - 部分代理需要重新啟動工作區或清除快取

### 「init 會覆寫我的憲章自訂嗎？」

目前的 `specify init --here --force` 會保留既有的 `.specify/memory/constitution.md`；只有在檔案遺失時，才會從範本建立該檔案。

若你先前透過較舊的工作流程或手動取代遺失了憲章變更，請從 git 或備份還原：

```bash
# If you committed the customized constitution
git restore .specify/memory/constitution.md

# If you backed up manually
cp /tmp/constitution-backup.md .specify/memory/constitution.md
```

**預防方式：** 日常專案檔案更新請使用 `specify integration upgrade <key>`。若需要備援的 `specify init --here --force` 路徑，請先提交，以便事後檢視完整差異。

### 「警告：目前目錄不是空的」

**完整警告訊息：**

```text
Warning: Current directory is not empty (25 items)
Template files will be merged with existing content and may overwrite existing files
Do you want to continue? [y/N]
```

**這代表什麼：**

當你在已有檔案的目錄中執行 `specify init --here`（或 `specify init .`）時，會出現此警告。它在告訴你：

1. **目錄已有既有內容**，在此範例中為 25 個檔案／資料夾
2. **檔案將被合併**，新的範本檔案會加入既有檔案旁
3. **部分檔案可能被覆寫**，若你已有 Spec Kit 檔案（`.claude/`、`.specify/` 等），它們會被新版本取代

**會被覆寫的內容：**

僅限 Spec Kit 基礎設施檔案：

- 代理命令／技能檔案（`.claude/skills/`、`.github/skills/` 等）
- `.specify/scripts/` 中的指令碼
- `.specify/templates/` 中的範本
- 遺失的記憶檔案如 `.specify/memory/constitution.md` 可能從範本建立；既有的憲章會被保留

**保持不變的內容：**

- 你的 `specs/` 目錄（規格、計畫、任務）
- 你的原始碼檔案
- 你的 `.git/` 目錄與 git 歷史
- 其他不屬於 Spec Kit 範本的檔案

**如何回應：**

- **輸入 `y` 並按 Enter**，在使用備援 init 路徑時繼續合併
- **輸入 `n` 並按 Enter**，取消操作
- **使用 `--force` 旗標**，完全略過此確認：

  ```bash
  specify init --here --force --integration copilot
  ```

**何時會看到此警告：**

- ✅ **預期中**，當在既有 Spec Kit 專案中使用備援 init 路徑時
- ✅ **預期中**，當為既有程式碼庫加入 Spec Kit 時
- ⚠️ **非預期**，若你以為是在空目錄中建立新專案

**預防提示：** 使用備援 init 路徑前，請先提交目前的工作，讓任何重新整理的檔案都容易檢視或還原。

### 「CLI 升級似乎沒有效果」

若某個命令的行為像較舊的 Spec Kit 版本，請先詢問 CLI 本身：

```bash
# Read-only — prints "Up to date: X.Y.Z" or "Update available: X.Y.Z → vY.Z.W"
specify self check

# Preview the install method, current version, and target tag the upgrade would use
specify self upgrade --dry-run
```

`specify check` 是離線環境掃描；`specify self check` 是 CLI 版本查詢。

若 `self check` 顯示錯誤的版本，請驗證安裝：

```bash
# Check installed tools
uv tool list

# Should show specify-cli

# Verify path
which specify

# Should point to the uv tool installation directory
```

若找不到，請重新安裝：

```bash
uv tool uninstall specify-cli
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

### 「每次開啟專案都要執行 specify 嗎？」

**簡短回答：** 不用，你只需在每個專案執行一次 `specify init`，或日後作為備援復原路徑時執行。

**說明：**

`specify` CLI 工具用於：

- **初始設定：** `specify init`，在專案中啟動 Spec Kit
- **日常專案檔案升級：** `specify integration upgrade <key>` 與 `specify extension update`
- **備援復原：** `specify init --here --force`，當整合中繼資料遺失或無法使用具資訊清單意識的路徑時
- **診斷：** `specify check`，驗證工具安裝

執行 `specify init` 後，斜線命令（如 `/speckit.specify`、`/speckit.plan` 等）會**永久安裝**在專案的代理資料夾中（`.claude/`、`.github/skills/`、`.pi/prompts/`、`.omp/commands/` 等）。你的 AI 程式代理會直接讀取這些命令檔案，無需再次執行 `specify`。

**若你的代理無法辨識斜線命令：**

1. **確認命令檔案存在：**

   ```bash
   # For GitHub Copilot (default skills layout)
   ls -la .github/skills/

   # For GitHub Copilot with the commands layout (--integration-options="--commands",
   # or a project created before skills became the default and upgraded since)
   ls -la .github/agents/ .github/prompts/

   # For Claude
   ls -la .claude/skills/

   # For Pi
   ls -la .pi/prompts/

   # For Oh My Pi
   ls -la .omp/commands/
   ```

2. **完全重新啟動 IDE／編輯器**（不只是重新載入視窗）

3. **檢查你是否位於正確目錄**，也就是執行 `specify init` 的目錄

4. **對於部分代理**，你可能需要重新載入工作區或清除快取

**相關問題：** 若 Copilot 無法開啟本機檔案或意外使用 PowerShell 命令，這通常是 IDE 脈絡問題，與 `specify` 無關。請嘗試：

- 重新啟動 VS Code
- 檢查檔案權限
- 確認工作區資料夾已正確開啟

---

## 版本相容性

Spec Kit 的主要 release 遵循語意化版本。主要版本內，CLI 與專案檔案設計為彼此相容。

**最佳實務：** 在主要版本變更時，同時升級 CLI 與專案檔案，讓兩者保持同步。

---

## 後續步驟

升級後：

- **測試新的斜線命令：** 執行 `/speckit.constitution` 或其他命令，確認一切正常運作
- **檢視 release 說明：** 查閱 [GitHub Releases](https://github.com/github/spec-kit/releases) 了解新功能與破壞性變更
- **更新工作流程：** 若加入了新命令，請更新團隊的開發工作流程
- **查閱文件：** 前往 [github.io/spec-kit](https://github.github.io/spec-kit/) 查看更新的指南
