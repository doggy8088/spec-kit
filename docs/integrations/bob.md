# IBM Bob

設定前請先安裝 [IBM Bob](https://www.ibm.com/products/bob)。整合鍵為 `bob`；不需要另外的 CLI。

## 多重安裝安全性

本整合未宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration bob
```

若是既有的 Spec Kit 專案，請使用 `specify integration install bob`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 預設技能版式

技能會安裝為 `.bob/skills/speckit-<command>/SKILL.md`。Bob 的技能是依意圖啟用的：請要求 Bob 使用 `speckit-specify` 技能，或已安裝 bug 擴充功能的 `speckit-bug-assess`。Spec Kit 會為技能模式的命令分派算繪 `/speckit-<command>` 參照，但這不表示每個技能都是另外註冊的 IDE 斜線命令。

## 舊版命令與遷移

傳入 `--integration-options="--legacy-commands"` 可改為產生已淘汰的 Bob 1.x 版式（`.bob/commands/*.md`）。此旗標將在未來版本中移除。

既有的舊版安裝可以這樣遷移：

```bash
specify integration upgrade bob --integration-options="--skills"
```

這會將安裝轉換為技能版式，並移除舊的命令檔案。若已安裝預設集覆寫，遷移會被拒絕，因為預設集成品尚無法跨版式變更進行協調。請先移除預設集、完成遷移，再重新安裝它們。

`--skills` 與 `--legacy-commands` 互斥。在沒有明確選取器的情況下，若受管理的 Spec Kit 技能不存在，受管理的舊版命令檔案會讓既有安裝保持在舊版模式。僅僅建立一個無關的 `.bob/skills/` 目錄並不會觸發遷移。舊版命令參照保留點記法 `/speckit.<command>` 形式。

## 工作流程權限

工作流程分派另外需要 `bob` CLI，雖然 IDE 設定不需要。它會以位置參數提示詞使用 `bob run --trust --accept-license`，串流輸出時選取 `-f pretty`，擷取輸出時選取 `-f json`。信任與授權旗標適用於這次非互動呼叫。

轉接器不會轉傳工作流程的 `model` 設定；Bob 透過它自己設定中的 `session.model` 選取模型。
