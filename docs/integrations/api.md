# 整合 API 參考

本參考說明撰寫內建（嵌入式）整合與外部整合轉接器所用的受支援 Python 契約。它們使用相同的基礎類別、渲染 hook、執行階段分派與檔案擁有權 API。描述檔與型錄綱要記載於[型錄參考](catalog.md)；安裝、信任與復原命令記載於 [CLI 參考](cli.md)。

請使用下方的基礎類別與 hook，不要匯入內部登錄、載入器或交易輔助程式。那些實作細節不屬於受支援的撰寫 API。

## 交付路由

內建整合隨 Specify CLI 一併出貨，不需要獨立的轉接器描述檔或型錄下載。其來源註冊與交付需求遵循儲存庫的[貢獻者指引](https://github.com/github/spec-kit/blob/main/CONTRIBUTING.md#integration-pull-requests)。

外部轉接器是獨立發布的套件。它們實作相同的撰寫 API，但還必須符合下方的套件驗證、專案本機路徑與執行同意需求。交付途徑不會讓私有的實作輔助程式變成公開的。

## 套件契約

本節僅適用於外部轉接器。

請發布一個 ZIP、tar.gz 或 tgz 封存檔，其中在根目錄含有下列檔案：

```text
sample-agent/
├── integration.yml
├── __init__.py
└── helpers.py       # optional package-relative modules
```

接受單一外層封存目錄。根模組必須匯出恰好一個具體的 `IntegrationBase` 子類別，其 `key` 須與描述檔中的 `integration.id` 相符。支援來自轉接器自身套件的相對匯入。請勿透過匯入副作用註冊該類別。

使用主機 API 與 Python 標準程式庫的轉接器，既不需要另外的 pip 安裝，也不需要變更 Spec Kit 的來源登錄。請改寫主機的命令與擴充功能／預設集貢獻；請勿將核心命令範本作為轉接器擁有的清單重新散佈。

## 格式基礎

請從 `specify_cli.integrations.base` 匯入這些類別：

| 基礎類別 | 已安裝的格式 | 典型的命令路徑 |
| --- | --- | --- |
| `MarkdownIntegration` | Markdown 命令 | `commands/speckit.plan.md` |
| `TomlIntegration` | TOML 命令 | `commands/speckit.plan.toml` |
| `YamlIntegration` | YAML 配方 | `recipes/speckit.plan.yaml` |
| `SkillsIntegration` | 代理技能 | `skills/speckit-plan/SKILL.md` |
| `IntegrationBase` | 自訂版式 | 由轉接器定義 |

表格中的路徑是已設定代理資料夾下的範例。格式基礎會渲染主機的範本與選取的指令碼變體。一般的 `IntegrationBase.setup()` 會複製原始範本；除非你自行實作渲染，否則請優先使用格式基礎。

### 最小技能轉接器

```python
from specify_cli.integrations.base import SkillsIntegration


class SampleIntegration(SkillsIntegration):
    key = "sample-agent"
    config = {
        "name": "Sample Agent",
        "folder": ".sample-agent",
        "commands_subdir": "skills",
        "install_url": "https://example.com/sample-agent",
        "requires_cli": False,
    }
    registrar_config = {
        "dir": ".sample-agent/skills",
        "format": "markdown",
        "args": "$ARGUMENTS",
        "extension": "/SKILL.md",
    }
    multi_install_safe = True
```

對於外部套件，請將此模組與一個 `integration.yml` 配對，其 ID 與名稱為 `sample-agent` 與 `Sample Agent`，且 `requires.speckit_version` 須符合你已測試過的主機版本。內建整合使用相同的類別中繼資料，不需要套件描述檔。此範例會為以 IDE 為基礎的代理安裝技能；它不支援非互動式 CLI 分派。

## 類別中繼資料

| 屬性 | 契約 |
| --- | --- |
| `key` | 唯一的整合識別碼；外部轉接器必須與 `integration.id` 相符，且不能取代內建鍵 |
| `config.name` | 顯示名稱；外部轉接器必須與 `integration.name` 相符 |
| `config.folder` | 標準的專案相對代理根目錄 |
| `config.commands_subdir` | 該根目錄下的命令或技能目錄 |
| `config.install_url` | 代理安裝文件 URL |
| `config.requires_cli` | 布林值，表示代理是否需要執行檔 |
| `registrar_config.dir` | 須符合 `config.folder/config.commands_subdir` |
| `registrar_config.format` | 渲染格式：`markdown`、`toml` 或 `yaml` |
| `registrar_config.args` | 代理引數預留位置，例如 `$ARGUMENTS` 或 `{{args}}` |
| `registrar_config.extension` | 一般的帶點檔名後綴，或 Markdown 技能的 `/SKILL.md` |
| `invoke_separator` | 非空的呼叫分隔符；預設為 `.`，`SkillsIntegration` 則為 `-` |
| `dev_no_symlink` | 布林值；要求在開發註冊中使用檔案輸出，而非符號連結 |
| `multi_install_safe` | 布林值，預設為 false；true 要求靜態、不重疊的輸出根目錄，或沒有檔案 |
| `version` | 選用的類別屬性；外部轉接器若有提供，必須與描述檔版本相符 |

選用的 `registrar_config.invoke_separator` 會覆寫註冊用的類別分隔符。若類別或 `registrar_config.dev_no_symlink` 任一要求，開發符號連結會被停用。選用的 `registrar_config.legacy_dir` 會宣告先前的專案相對輸出目錄以供遷移。技能位於使用者主目錄的內建整合會設定 `registrar_config.home_scoped = True`；擴充功能生命週期程式碼隨後會把該目錄視為允許的主目錄技能位置。外部轉接器無法設定它。

對於外部轉接器，輸出根目錄不能是 home 相對路徑、不能進入 `.git` 或 `.specify`、不能含有遍歷，也不能穿越符號連結。主要與舊版目的地不能彼此重疊；多重安裝安全的轉接器也不能與另一個整合的目的地重疊。在所有平台上，比較都不區分大小寫。某些內建整合具有主機管理的 home 範圍或舊版版式；這些不會放寬外部套件契約。

## 安裝時選項與版式

請覆寫類別方法 `options() -> list[IntegrationOption]`，宣告透過 CLI 的 `--integration-options` 接受的旗標。請從 `specify_cli.integrations.base` 匯入 `IntegrationOption`。

| `IntegrationOption` 欄位 | 含義 |
| --- | --- |
| `name` | 旗標寫法，例如 `--skills` |
| `is_flag` | 為 true 時是布林開關；否則接受一個值 |
| `required` | 呼叫者是否必須提供該選項 |
| `default` | 省略時的值；`None` 表示沒有預設值 |
| `help` | 面對使用者的選項描述 |

這些是安裝選項，不是逐步驟的工作流程執行階段選項。加入自己的選項時，請保留繼承的選項。

對於支援多種版式的轉接器，請保持這些 hook 一致：

| Hook | 契約 |
| --- | --- |
| `is_skills_mode(parsed_options=None, project_root=None) -> bool` | 選取技能或命令；`SkillsIntegration` 預設回傳 true |
| `effective_invoke_separator(parsed_options=None, project_root=None) -> str` | 所選安裝選項的呼叫分隔符 |
| `invoke_separator_for_mode(skills_enabled: bool) -> str` | 已解析的已安裝模式的命令參照分隔符 |
| `command_filename(template_name: str) -> str` | 來源範本詞幹的目的地檔名 |
| `build_command_invocation(command_name: str, args: str = "") -> str` | 核心或貢獻命令的原生代理呼叫 |

在既有專案的生命週期操作期間沒有選項時，`project_root` 讓支援模式的轉接器檢視其已安裝的版式，而不是無聲地遷移它。呼叫寫法、檔案命名與渲染必須一致。

## 命令渲染 hook

`process_registered_command(frontmatter, body, *, source_id)` 會在命令渲染前回傳一個 `(frontmatter, body)` 配對。`source_id` 是 `core` 或貢獻的擴充功能／預設集 ID。指令碼路徑已調整過；引數預留位置與命令參照 token 會在之後解析。只有在 `registrar_config.inject_name` 已啟用且沒有非空名稱留下時，才會注入 frontmatter 的 `name`。請勿假設 `frontmatter["name"]` 存在。請回傳新的物件，而不是修改輸入的 frontmatter。

`post_process_command_content(content: str) -> str` 會轉換渲染後的 Markdown、TOML 或 YAML 命令文字；其預設實作會原樣回傳內容。

`SkillsIntegration.post_process_skill_content(content: str) -> str` 會自訂產生的技能內容。繼承的 `SkillsIntegration.setup()` 以及擴充功能與預設集的技能產生 pass，會在產生或重寫技能時呼叫它。基礎實作加入了共用指引，用於將帶點的 hook 命令名稱轉換為代理原生的帶連字號呼叫。覆寫它時請保留該指引，例如呼叫 `super()`。

`process_registered_command()` 與 `post_process_command_content()` 適用於命令註冊期間，包括擴充功能與預設集的貢獻。繼承的 `MarkdownIntegration.setup()`、`TomlIntegration.setup()` 與 `YamlIntegration.setup()` 會安裝核心範本，而不呼叫任一 hook。若核心命令需要額外的代理專屬轉換，請覆寫 `setup()` 並使用[追蹤寫入](#設定與檔案擁有權)，而不是只依賴註冊 hook。

較晚的技能產生 pass 可能略過已存在的 `SKILL.md`，包括由較早的命令註冊 pass 建立的檔案。在略過它的 pass 中，不會對該檔案呼叫 hook；請勿假設較晚的 pass 會重新處理每個已安裝的技能。這些 hook 針對 Spec Kit 產生的輸出，不是代理或使用者提供的無關技能。

請優先使用這些 hook，而不是複製主機的渲染程式碼。產生的 PowerShell 功能必須保持與 Windows PowerShell 5.1 相容。

## 非互動式 CLI 分派

CLI 轉接器會實作此 hook，回傳引數向量而非 shell 命令字串：

```python
def build_exec_args(
    self,
    prompt: str,
    *,
    model=None,
    output_json=True,
    integration_args=None,
    integration_options=None,
    project_root=None,
) -> list[str] | None:
    ...
```

回傳的清單包含執行檔及其引數。不支援分派時請回傳 `None`。明確宣告的主機關鍵字參數必須有預設值；透過 `**kwargs` 接受省略的關鍵字也受支援。僅提示詞的呼叫與完整的主機呼叫都必須有效。

繼承的 CLI 分派因基礎類別而異：

| 基礎類別 | 預設分派 |
| --- | --- |
| `MarkdownIntegration`、`SkillsIntegration` | 當 `config.requires_cli` 為 true 時，使用 `-p <prompt>`，提供時加上 `--model <model>`，且 `output_json` 為 true 時加上 `--output-format json` |
| `TomlIntegration` | 相同的提示詞與 JSON 旗標，但模型旗標為 `-m <model>`；同樣需要 `config.requires_cli` |
| `IntegrationBase`、`YamlIntegration` | 回傳 `None`；沒有預設的 CLI 分派 |

當代理使用不同的旗標或不同的執行檔時，請覆寫 `build_exec_args()`。僅安裝命令檔案本身並不提供非互動式分派支援。

`validate_runtime_config(integration_args=None, integration_options=None)` 會驗證逐步驟的引數清單與選項對應。預設會以 `ValueError` 拒絕非空的執行階段設定。支援這些值的轉接器必須在 `build_exec_args()` 中驗證並轉譯它們，而不是無聲忽略不支援的選項。

對於外部轉接器，描述檔要求的工具會在 `PATH` 上檢查。若 CLI 轉接器未宣告任何工具，工具檢查會探測其執行階段執行檔。版本偵測是代理專屬的；宣告版本約束並不會提供通用的 `--version` 呼叫。

### 逐步驟分派設定

工作流程的 `command` 與 `prompt` 步驟可以為一次 CLI 呼叫要求 [`reasoning_effort` 與 `context_size`](../workflow-steps/types.md#推理強度與上下文大小)。`specify_cli.integrations.base` 中的 `DISPATCH_SETTINGS` 依檢查順序列出它們。值是不透明的字串，其含義屬於代理的 CLI。

上述 `build_exec_args()` 簽章不變，未選擇加入的轉接器永遠不會收到任一關鍵字：要求其中之一的步驟會在 CLI 執行前失敗。提示詞步驟會將要求的設定傳給 `build_exec_args()`。命令步驟會將它們傳給 `dispatch_command()`，其基礎實作會將它們轉傳給 `build_exec_args()`。因此*接收方法*是 `build_exec_args()`，或在整合覆寫時，命令步驟的 `dispatch_command()`。若要選擇加入：

- 在定義接收方法的類別上，宣告 `supported_dispatch_settings`，即整合所轉譯的設定組成的 `frozenset`。覆寫該方法的子類別必須再次宣告支援。在任何其他類別上的宣告，或不是 set 或 frozenset 的宣告，皆不算宣告。
- 在接收方法上，為每個宣告的設定接受 `reasoning_effort=None` 或 `context_size=None` 關鍵字。主機只在步驟設定該設定時才傳入關鍵字，且絕不傳入 `""`。請將該值轉譯為置於 `SPECKIT_INTEGRATION_<KEY>_EXTRA_ARGS` 來源引數之後的 CLI 引數，且不要再傳遞它：`IntegrationBase.build_exec_args()` 與格式基礎建置器兩項設定皆不轉譯，而是引發 `DispatchSettingsError`，而非捨棄該值。
- 視需要覆寫 `validate_dispatch_setting(name, value)`，對 CLI 會忽略或誤讀的值引發 `ValueError`；並覆寫 `dispatch_setting_hint(setting)`，回傳主機會附加到其不支援設定錯誤中的補救文字。

在 CLI 執行前，主機閘門 `check_dispatch_settings()` 會依 `DISPATCH_SETTINGS` 順序檢查每個要求的設定。值必須是 1 至 64 個字母、數字、`.`、`_` 或 `-`，且以字母或數字開頭；整合必須如上宣告該設定；接收方法必須接受該關鍵字或 `**kwargs`。閘門接著呼叫 `validate_dispatch_setting()`。每次失敗都會引發 `DispatchSettingsError`，即 `setting` 屬性指名該設定的 `ValueError`；若接收方法本身必須拒絕某個值，請以 `setting` 引發它。請勿將該值放入任何錯誤訊息：它可能來自擷取到的輸出，而 Spec Kit 不會將其印到終端機或寫入 `log.jsonl`。主機無法偵測接收方法接受後又忽略的已宣告設定（例如透過 `**kwargs`），因此宣告即是承諾轉譯它。

## 設定與檔案擁有權

格式基礎會實作設定與拆解。自訂版式可以覆寫：

| Hook | 契約 |
| --- | --- |
| `preflight_setup(project_root, parsed_options=None, *, script_type=None) -> None` | 在寫入共用檔案前拒絕設定；引發 `ValueError` 或 `OSError` |
| `setup(project_root, manifest, parsed_options=None, **opts) -> list[Path]` | 寫入並記錄代理檔案；回傳建立的路徑 |
| `teardown(project_root, manifest, *, force=False) -> tuple[list[Path], list[Path]]` | 回傳已移除與保留的路徑；繼承的行為會保留已修改的檔案，除非強制 |
| `stale_cleanup_exclusions() -> set[str]` | 升級時不得當作過時刪除的專案相對路徑 |

請在適當處呼叫繼承的行為，並保留主機提供的選項，包括 `script_type`、`events` 與 `force`。請將產生的檔案放在宣告的代理根目錄下；主機擁有共用的 Spec Kit 指令碼與範本。

主機會向設定與拆解提供一個 `IntegrationManifest`。對於自訂寫入，請使用這些受支援的操作：

| 操作 | 契約 |
| --- | --- |
| `manifest.record_file(rel_path, content, *, ownership="whole") -> Path` | 寫入位元組或 UTF-8 文字並記錄擁有權；路徑為專案相對路徑 |
| `manifest.record_existing(rel_path, *, recovered=False, ownership=None) -> None` | 記錄既有的一般檔案；`recovered=True` 標示保留的既有內容 |
| `IntegrationBase.write_file_and_record(content, dest, project_root, manifest) -> Path` | 以 LF 換行寫入 UTF-8 文字並記錄；`dest` 是目的地路徑 |

擁有權在轉接器擁有的檔案為 `whole`，在合併進檔案的項目為 `partial`，在主機共用的成品為 `shared`。請勿對使用者設定或共用分派器主張整檔擁有權。資訊清單路徑必須是標準的、專案本機的，且非符號連結。

請在覆寫既有內容**之前**使用寫入並記錄的操作。單獨使用 `record_existing()` 無法還原已在主機追蹤寫入路徑之外被覆寫的位元組；此類失敗會被回報，產生的檔案會保留以供手動復原。

## 外部轉接器生命週期保證

本節的套件信任與重新授權適用於外部轉接器，不適用於隨 CLI 出貨的內建整合。

安裝需要允許安裝的型錄，以及在下載／匯入可執行 Python 之前的本機信任決定。僅中繼資料的檢視命令是 `specify integration list --catalog`、`specify integration search` 與 `specify integration info`。一般的 `specify integration list` 會載入受信任的已安裝轉接器程式碼；它不是免匯入的檢視命令。

同意與專案、整合 ID 與經驗證的套件內容繫結。複製專案、變更使用者，或變更套件位元組，都需要新的授權。遺失、修改、不相容或無法匯入的套件會明確失敗；請發布新的封存檔並升級，而不是編輯已安裝的程式碼。

失敗的生命週期操作會還原自身追蹤的變更，同時保留無關的檔案、工作流程進度與衝突的外部編輯。復原失敗會回報保留的快照以供手動復原。升級與解除安裝會保留已修改的產生檔案，除非強制；強制復原仍需要本機擁有權證明才能刪除舊檔案，且不會繞過型錄政策或替代套件的信任。

轉接器實例可以處理並行的分派與渲染操作。請將每次呼叫的狀態保持在本機，不要依賴可變的全域註冊或另一個專案的已安裝套件。對於原生事件支援，在擴充 `emit_events()` 或 `remove_events()` 時，請保留主機的事件擁有權；受支援的事件與選項請參閱[執行階段事件](cli.md#執行階段事件)。

## 另請參閱

- [開發與發布整合](contributing.md)
- [描述檔與型錄綱要](catalog.md)
- [整合 CLI 與信任](cli.md)
- [逐步驟工作流程整合設定](../workflow-steps/types.md#每個步驟的整合設定)
