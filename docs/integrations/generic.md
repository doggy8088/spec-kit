# Generic：自備代理

將 `generic` 整合用於未被內建整合涵蓋的 AI 程式代理。透過 `--commands-dir` 提供專案本機的輸出目錄。本整合不要求 Spec Kit 使用特定的代理 CLI。

## 多重安裝安全性

本整合未宣告為多重安裝安全，因為它使用動態輸出路徑。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration generic --integration-options="--commands-dir .myagent/cmds"
```

若是既有的 Spec Kit 專案：

```bash
specify integration install generic --integration-options="--commands-dir .myagent/cmds"
```

啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 輸出選項與呼叫方式

| 選項 | 說明 |
| --- | --- |
| `--commands-dir <path>` | 必填。命令或技能的專案本機輸出目錄。 |
| `--skills` | 改寫入 `speckit-<command>/SKILL.md` 目錄，而不是平面的 `speckit.<command>.md` 檔案。 |

預設的命令參照使用 `/speckit.specify` 與 `/speckit.bug.assess`。技能模式會將命令參照與後續步驟指引改為 `/speckit-specify` 與 `/speckit-bug-assess`：

```bash
specify integration install generic --integration-options="--commands-dir .myagent/skills --skills"
```

你的代理必須支援所選的檔案版式與呼叫風格；Spec Kit 不會為代理加上原生命令探索能力。

## 擴充功能

當 `generic` 是使用中的整合時，`specify extension add` 會將擴充功能命令註冊到它設定的 `--commands-dir` 中，依 `--skills` 而定，形式為命令檔案或技能。`specify extension remove` 會移除未變更的擴充功能所屬成品，同時保持核心命令、使用者檔案與已編輯的擴充功能檔案完整無缺。

## 工作流程限制

generic 整合不支援工作流程命令或提示詞步驟的 CLI 分派。選取輸出目錄並不會設定執行檔，也不會教會 Spec Kit 如何呼叫任意的代理 CLI。
