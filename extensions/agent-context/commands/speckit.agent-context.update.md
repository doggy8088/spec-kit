---
description: "重新整理程式代理情境檔案中的 Spec Kit 受管理區段"
---

# 更新程式代理情境

重新整理目前程式代理的情境／指示檔案（例如 `CLAUDE.md`、`.github/copilot-instructions.md`、`AGENTS.md`）內受管理的 Spec Kit 區段。

## 行為

指令碼會讀取位於
`.specify/extensions/agent-context/agent-context-config.yml` 的 agent-context 擴充功能設定，以找出：

- `context_file`——要管理的程式代理情境檔案路徑。
- `context_files`——可選的專案相對路徑清單，用於多個程式代理情境檔案。非空白時，指令碼會逐一更新清單中的每個檔案，且清單優先於 `context_file`。
- `context_markers.start`／`.end`——圍繞受管理區段的分隔標記。欄位缺失時，預設為 `<!-- SPECKIT START -->` 與 `<!-- SPECKIT END -->`。

接著，指令碼會建立、取代或附加受管理區塊，讓該區段在可找到最新計畫路徑時指向它（`specs/` 下的任何 `plan.md`，包含 `specs/<scope>/<feature>/plan.md` 這類巢狀範圍版式）。

若 `context_files` 與 `context_file` 皆為空白，本命令會回報無事可做並成功結束。情境檔案路徑必須維持專案相對路徑；絕對路徑、Windows 磁碟路徑、反斜線分隔符與 `..` 路徑段都會被拒絕。

## 執行

- **Bash**：`.specify/extensions/agent-context/scripts/bash/update-agent-context.sh [plan_path]`
- **PowerShell**：`.specify/extensions/agent-context/scripts/powershell/update-agent-context.ps1 [plan_path]`

當省略 `plan_path` 時，指令碼會自動偵測最近修改的 `specs/**/plan.md`（遞迴搜尋，因此能找到巢狀範圍版式）。
