# Hermes

設定前請先安裝 [Hermes Agent](https://github.com/NousResearch/hermes-agent)。整合鍵為 `hermes`。

## 多重安裝安全性

本整合未宣告為多重安裝安全。它的技能會在同一位使用者的主目錄中跨專案共用。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration hermes
```

若是既有的 Spec Kit 專案，請使用 `specify integration install hermes`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

與專案本機技能整合不同，Hermes 會將技能全域安裝為 `~/.hermes/skills/speckit-<command>/SKILL.md`。在 Hermes 的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

專案本機的空白 `.hermes/skills/` 標記可啟用整合偵測；產生的核心技能檔案本身不會複製到專案中。選用的 `--integration-options="--skills"` 旗標只是重述預設值。

## 全域所有權與移除

設定程序可以取代另一個專案的全域 Spec Kit 技能檔案。

**解除安裝會移除每一個全域 `speckit-*` 技能目錄，即使已被編輯、即使未使用 `--force` 也一樣。** 這些全域檔案不受專案本機清單的已修改檔案檢查保護。解除安裝或切離 Hermes 之前，請先備份你的自訂內容。專案本機的空白標記也會被移除；非 Spec Kit 的全域技能則會保留。

## 工作流程分派

工作流程步驟使用 `hermes chat -Q`。以斜線開頭的提示詞會以 `-s` 選取技能，其餘文字以 `-q` 傳入。其他提示詞則直接使用 `-q`。轉接器會以 `-m` 轉傳已設定的模型，並在要求結構化輸出時傳入 `--json`。
