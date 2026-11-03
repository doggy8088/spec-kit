# 程式代理情境擴充功能

這個內附的擴充功能負責管理目前整合所使用的**程式代理情境／指示檔案**（例如 `CLAUDE.md`、`.github/copilot-instructions.md`、`AGENTS.md`、`GEMINI.md` 等）。

它掌管受管理區段的生命週期，該區段由可自訂的起訖標記界定（預設為 `<!-- SPECKIT START -->`／`<!-- SPECKIT END -->`）。對於 `.mdc` 檔案，它也會確保 YAML frontmatter（檔案頂端的詮釋資料區塊）包含 `alwaysApply: true`。除此之外，受管理區段以外的所有內容都不會被更動。

> NOTE: Spec Kit 本身絕不會更動你的代理情境檔案。唯一會這麼做的只有本擴充功能，而且採主動選用：想讓該區塊保持同步就安裝它；想自己管理該檔案就不必安裝。

## 為什麼做成擴充功能？

並非每位 Spec Kit 使用者都希望 Spec Kit 寫入程式代理的情境檔案。將此行為放在專屬的**主動選用**擴充功能中，使用者可以：

- **自行決定是否安裝**——`specify init` **不會**安裝它。當你想讓 Spec Kit 管理代理情境檔案時，再明確將它加入；未安裝時，該檔案永遠不會被修改；停用時，其自動 hooks 也不會執行。
- **自訂標記**：編輯 `.specify/extensions/agent-context/agent-context-config.yml`（本儲存庫中的 [agent-context-config.yml](./agent-context-config.yml)）——內附指令碼會遵循 `context_markers` 的值。
- **同步多個代理錨點**：當專案刻意使用多個程式代理情境檔案（例如 `AGENTS.md` 與 `CLAUDE.md`）時，設定 `context_files` 即可。
- **依需求重新整理**：在你的代理中執行 `speckit.agent-context.update` 命令，或透過 [extension.yml](./extension.yml) 中宣告的 hooks（`after_specify`、`after_plan`）自動執行。

## 安裝

若要安裝本擴充功能，請在已初始化的 Spec Kit 專案根目錄執行：

```bash
specify extension add agent-context
```

## 停用

```bash
specify extension disable agent-context

# Re-enable it
specify extension enable agent-context
```

當本擴充功能停用（或未安裝）時，Spec Kit 中的任何功能都不會建立、更新或移除受管理區塊——範本中的 `__CONTEXT_FILE__` 佔位符會原樣保留，且絕不會讀取擴充功能自身的設定。

## 命令

| 命令                        | 說明                                                                       |
| ------------------------------ | --------------------------------------------------------------------------------- |
| `speckit.agent-context.update` | 以目前的計畫路徑重新整理代理情境檔案中的受管理區段。 |

> NOTE: 上方的命令 ID 為標準形式。請依你的整合方式使用對應語法呼叫：點命令整合使用 `/speckit.agent-context.update`；連字號／skills 整合（包含 Forge 與 Cline）使用 `/speckit-agent-context-update`；Codex 或 ZCode 的 skills 模式使用 `$speckit-agent-context-update`；Kimi 則使用 `/skill:speckit-agent-context-update`。

## 設定

所有設定都透過擴充功能自身的設定檔進行，位置在 `.specify/extensions/agent-context/agent-context-config.yml`（儲存庫中的 [agent-context-config.yml](./agent-context-config.yml)）。

## 需求

內附的更新指令碼需要 **Python 3** 與 **PyYAML** 來處理 YAML／upsert（PowerShell 在可用時也可使用 `ConvertFrom-Yaml`）。

PyYAML 隨 `specify` CLI 附帶，通常可透過同一個 `python3` 直譯器取得。若 hook 回報 _"PyYAML is required … not available in the current Python environment"_，表示系統的 `python3` 與安裝 Spec Kit 所用的直譯器不同。若要解決，請執行：

```bash
pip install pyyaml
# or target the specific interpreter Spec Kit uses:
/path/to/speckit-python -m pip install pyyaml
```

## Issues

如有其他問題，請在 [GitHub 官方儲存庫](https://github.com/github/spec-kit/issues)建立 issue。
