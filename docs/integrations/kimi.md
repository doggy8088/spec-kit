# Kimi Code

設定前請先安裝 [Kimi Code](https://code.kimi.com/)。整合鍵為 `kimi`。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration kimi
```

若是既有的 Spec Kit 專案，請使用 `specify integration install kimi`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.kimi-code/skills/speckit-<command>/SKILL.md`。在 Kimi 的聊天中使用技能冒號前綴呼叫它們，例如 `/skill:speckit-specify`，或已安裝 bug 擴充功能的 `/skill:speckit-bug-assess`。

選用的 `--integration-options="--skills"` 旗標只是重述預設值；本整合一律產生技能。

## 舊版遷移

升級舊版安裝時傳入 `--integration-options="--migrate-legacy"`，可將技能從 `.kimi/skills/` 移到 `.kimi-code/skills/`。遷移也會將點記法技能名稱（例如 `speckit.xxx`）轉換為連字號名稱（例如 `speckit-xxx`）：

```bash
specify integration upgrade kimi --integration-options="--migrate-legacy"
```

設定程序會先寫入新技能。舊版目錄只有在其新目標不存在時才會被移動。若目標已經存在，舊目錄只有在兩個 `SKILL.md` 檔案逐位元完全相同、且舊版目錄沒有其他檔案時才會被移除。內容不同的舊版內容與額外的使用者檔案會保留，供手動協調。以符號連結指向的舊版路徑會被略過；以符號連結指向的目的地元件則會被拒絕。

## 解除安裝時的舊版清理

一般由清單追蹤的檔案使用共用的已修改檔案保護。此外，拆卸程序會依產生的 `metadata.author` 與 `metadata.source` 辨識，移除舊版的 `.kimi/skills/speckit-*` 與 `speckit.*` 目錄。該舊版清理不會比對記錄的雜湊，也不需要 `--force`；解除安裝前，請先備份這些目錄內已編輯的舊版技能與額外檔案。

## 工作流程分派

工作流程步驟使用 `kimi -p <prompt>`，並以 `/skill:speckit-<command>` 呼叫方式執行，同時轉傳已設定的 `--model`。結構化輸出要求使用 `--output-format stream-json`（JSONL 事件），而不是不受支援的 `json` 值。
