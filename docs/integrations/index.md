# 整合

整合透過命令、技能或配方，將 Spec Kit 連接到你的 AI 程式代理。若只需要共用骨架而不需要代理，請使用 [none](none.md)。在下方選擇一個整合，查看其先決條件、設定、呼叫語法，以及整合專屬的選項或限制。

## 設定你的代理

CLI 的先決條件與安裝方式請參閱[安裝指南](../installation.md)，你的第一個流程請參閱 [SDD 快速入門](../quickstart.md)。

若是新專案：

```bash
specify init my-project --integration <key>
```

請在你的程式代理內呼叫流程命令，不要在終端機中呼叫。文件通常使用 `/speckit.*` 記法，但你的代理可能使用連字號技能、`$` 技能或其他原生形式。請參閱你所用整合的頁面與[命令呼叫方式比較](cli.md#command-invocation)。

## 加入另一個代理

在已初始化的專案中，使用 [`specify integration install <key>`](cli.md#install-an-integration)。請查看該代理指南中的多重安裝安全性狀態，並遵循[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

安裝另一個整合不會變更預設值。使用 [`specify integration use <key>`](cli.md#use-an-installed-integration) 將它啟用。

## 移除代理

使用 [`specify integration uninstall <key>`](cli.md#uninstall-an-integration) 移除某個代理的 Spec Kit 整合，而不是代理應用程式本身。已修改檔案的處理方式與清理例外請參閱解除安裝參考。

若要改為取代某個整合，請使用 [`specify integration switch <key>`](cli.md#switch-to-a-different-integration)。

## 在團隊中工作

使用混合代理的團隊可以從不綁定代理的專案開始：

```bash
specify init my-project --integration none
```

每位開發者都在自己的本機簽出中切換到所選的代理：

```bash
specify integration switch <key>
```

開發完成後，在將提交放入暫存區之前切換回來：

```bash
specify integration switch none
```

> [!IMPORTANT]
> 不要手動編輯 Spec Kit 產生的代理命令或技能。請將自訂內容維護在經過審查的[預設集](../reference/presets.md)或[專案本機覆寫](../guides/customization.md#project-local-overrides-and-resolution)中。提交之前，請使用 [`specify integration status`](cli.md#report-integration-status) 驗證 `none` 是唯一已安裝且為預設的整合。請檢視 Git 差異與任何保留的代理檔案。

團隊可以為已提交的基線加入 CI 檢查，也可以選擇性地為暫存檔案加入預先提交檢查。

## 選擇整合

以 `--integration <key>` 使用下方顯示的確切鍵值。以 CLI 為基礎的整合需要安裝代理的 CLI；以 IDE 為基礎的整合則透過代理在你 IDE 中的聊天視窗執行。每個頁面都連結到該代理的安裝文件。

| 整合 | 鍵 |
| --- | --- |
| [Alquimia AI](alquimia.md) | `alquimia` |
| [Amp](amp.md) | `amp` |
| [Antigravity](agy.md) | `agy` |
| [Auggie CLI](auggie.md) | `auggie` |
| [Claude Code](claude.md) | `claude` |
| [Cline](cline.md) | `cline` |
| [CodeBuddy CLI](codebuddy.md) | `codebuddy` |
| [Codex CLI](codex.md) | `codex` |
| [Command Code](command-code.md) | `command-code` |
| [Cursor](cursor-agent.md) | `cursor-agent` |
| [DeepSeek Harness](dsh.md) | `dsh` |
| [Devin for Terminal](devin.md) | `devin` |
| [Docker Agent](docker-agent.md) | `docker-agent` |
| [Factory Droid](droid.md) | `droid` |
| [Firebender](firebender.md) | `firebender` |
| [Forge](forge.md) | `forge` |
| [Gemini CLI](gemini.md) | `gemini` |
| [GitHub Copilot](copilot.md) | `copilot` |
| [Goose](goose.md) | `goose` |
| [Grok Build](grok.md) | `grok` |
| [Hermes](hermes.md) | `hermes` |
| [IBM Bob](bob.md) | `bob` |
| [Junie](junie.md) | `junie` |
| [Kilo Code](kilocode.md) | `kilocode` |
| [Kimi Code](kimi.md) | `kimi` |
| [Kiro CLI](kiro-cli.md) | `kiro-cli` |
| [Lingma](lingma.md) | `lingma` |
| [MiniMax Code](mcode.md) | `mcode` |
| [Mistral Vibe](vibe.md) | `vibe` |
| [Muse Code](muse.md) | `muse` |
| [None：僅共用骨架](none.md) | `none` |
| [Oh My Pi](omp.md) | `omp` |
| [opencode](opencode.md) | `opencode` |
| [Pi Coding Agent](pi.md) | `pi` |
| [Qoder CLI](qodercli.md) | `qodercli` |
| [Qwen Code](qwen.md) | `qwen` |
| [RovoDev](rovodev.md) | `rovodev` |
| [SHAI (OVHcloud)](shai.md) | `shai` |
| [Tabnine CLI](tabnine.md) | `tabnine` |
| [Trae](trae.md) | `trae` |
| [ZCode](zcode.md) | `zcode` |
| [Zed](zed.md) | `zed` |
| [Generic：自備代理](generic.md) | `generic` |

## 共用管理與外部整合

[整合 CLI 參考](cli.md)記載了共用的安裝、升級、移除、狀態、型錄與預設選取行為。這些規則跨整合適用，不會在每個頁面上重複。各指南也會指出是否支援工作流程 CLI 分派；不需要 CLI 的 IDE 設定，並不表示工作流程步驟可以在沒有 CLI 的情況下執行。

對於此處未列出的代理，請使用 [generic 整合](generic.md)或[探索外部轉接器](cli.md#search-available-integrations)。授權執行外部轉接器程式碼之前，請先審查它。型錄探索不是安全背書；預設的社群型錄僅供探索。信任與安裝要求請參閱[透過型錄安裝的外部轉接器](cli.md#catalog-installed-external-adapters)。

[型錄參考](catalog.md)說明了描述檔與型錄中繼資料。開發內建整合或發佈外部轉接器，請參閱[貢獻整合](contributing.md)。
