# opencode

設定前請先安裝 [opencode](https://opencode.ai/)。整合鍵為 `opencode`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#我可以在同一個專案中安裝多個整合嗎)。

## 設定

```bash
specify init my-project --integration opencode
```

若是既有的 Spec Kit 專案，請使用 `specify integration install opencode`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 命令會安裝在 `.opencode/commands/` 之下。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

當正規目錄不存在時，舊版的 `.opencode/command/` 安裝仍作為註冊的備援途徑。

## 執行階段事件與工作流程分派

原生事件使用 `.opencode/plugin/speckit-events.ts`，而不是 JSON hook 對應表；Spec Kit 會將其外掛程式參照合併到 `opencode.json` 中。`--integration-options="--events false"` 可停用 Spec Kit 事件處理常式。請參閱[執行階段事件](cli.md#執行階段事件)。

工作流程步驟使用 `opencode run`。以斜線開頭的提示詞會變成 `--command <name>`，其餘文字作為訊息；其他提示詞則以訊息文字傳入。轉接器會以 `-m` 轉傳已設定的模型，並在要求結構化輸出時傳入 `--format json`。

## 隱藏的 Spec Kit 檔案

在 darwin arm64 上，opencode 1.18.31 與 1.19.3 以 glob 工具探索檔案，該工具呼叫 ripgrep 時未加 `--hidden`。在一個暫時的 Spec Kit 樹狀結構中，`opencode debug rg files --glob '.specify/**/*'`（與 glob 工具所做的 `Ripgrep.glob` 呼叫相同，不涉及模型）未回傳任何路徑。同一指令下的 `**/*.md` 只回傳了一個可見的 `README.md`，漏掉了 `.specify/memory/constitution.md`、`.specify/templates/spec-template.md`、`.specify/templates/plan-template.md` 與 `.specify/scripts/bash/check-prerequisites.sh`。在專案根目錄的 `.ignore` 包含以下內容後：

```text
!.specify/
!.specify/**
```

這些模式回傳了憲章、兩個範本與該指令碼。萬用 `**/*` 在例外加入前就已列出 `.specify` 檔案。僅有 `!.specify/**` 仍回傳不到任何 `.specify/**/*` 相符項目；在此 ripgrep 路徑上，目錄規則才是重新納入隱藏目錄的關鍵。雲端模型備援提示詞與 opencode 2.x 不在此次檢查範圍內。

請在安裝或升級時選擇加入：

```bash
specify init my-project --integration opencode --integration-options="--configure-ignore-file"
specify integration upgrade opencode --integration-options="--configure-ignore-file"
```

此旗標會把這兩條規則中尚未成為確切行者附加進去，置於根目錄 `.ignore` 的末尾，其後接著 `.specify/**/local-config.yml`、`.specify/**/*-config.local.yml` 與 `.specify/workflows/runs/`，除非這些確切行已出現在最後一個 `!` 行之後。ripgrep 將 `.ignore` 的優先順序排在 `.gitignore` 之上，因此這些行可讓每台機器的擴充功能覆寫（可能含有憑證）不被未傳入相符 glob 的 ripgrep 搜尋納入，不論深度，包括擴充功能移除時保留在 `.specify/extensions/.backup/` 下的副本。`.specify/workflows/runs/` 這行對工作流程執行狀態（`state.json`、`inputs.json`、`log.jsonl`，內含已解析的輸入與擷取到的命令輸出）亦有相同作用。這些行不會讓這些檔案躲過 opencode 的 glob 工具：ripgrep 允許與檔案相符的 `--glob` 模式覆寫所有 ignore 檔案，因此在 ripgrep 15.2.0 下，一旦例外就定位，`rg --files --glob '.specify/**/*'` 與 `rg --files --glob '**/*.yml'` 會列出 `.specify` 下的 `local-config.yml` 與 `*-config.local.yml` 檔案，而不帶 glob 的 `rg --files` 則會略過它們。在例外加入前，`**/*` 就已列出它們。請勿將憑證放在 `.specify` 下的檔案中（改用 `SPECKIT_{EXTENSION}_*` 環境變數），以免 opencode 看到其路徑。之後排除 `local-config.yml` 或 `*-config.local.yml` 檔案、`.specify/extensions/.backup/`，或 `.specify/workflows/runs/` 下的任何內容，都是允許的。之後排除 `.specify`、`.specify/memory` 這類父目錄，或其下的檔案（包括 init 尚未建立的範本或指令碼，例如 `.specify/templates/plan-template.md`）的行則會被拒絕；請把 `!.specify/` 與 `!.specify/**` 移到該行下方再重新執行。根目錄的 `.rgignore`，或 `.specify` 下任何位置的 `.ignore` 或 `.rgignore`（例如 `.specify/memory/.ignore`）中排除上述任一路徑的行，也會以同樣方式被拒絕，因為 ripgrep 將 `.rgignore` 的優先順序排在 `.ignore` 之上，且較近的 ignore 檔案優先於根目錄檔案；請移除該行再重新執行。任何這類檔案中重新納入私人設定或工作流程執行狀態的 `!` 行（例如根目錄 `.rgignore` 中的 `!.specify/**/local-config.yml`，或 `.specify/extensions/jira/.ignore` 中的 `!local-config.yml`）也會被拒絕，因為它會覆寫附加的排除規則；請移除該行再重新執行。隨附指令碼只會檢查正在安裝的 `--script` 變體，以及 `.specify/scripts` 下已有的任何指令碼。`specify integration install`、`switch` 與 `upgrade` 會在寫入共用範本或指令碼之前執行此檢查，因此被拒絕的 `.ignore` 會讓專案保持不變，即使搭配 `--force` 也一樣。子目錄的例外無法在父目錄仍被排除時揭開檔案。檔案中已有的位元組會保留為前綴，包括 UTF-8 非 ASCII 文字、CRLF 與缺少的結尾換行。非 UTF-8 內容會在寫入命令檔案前被拒絕；請將檔案轉換為 UTF-8 再重新執行，因為 ripgrep 會在第一個無效位元組處停止。預設安裝不會動到 `.ignore`。此檔案以部分擁有權記錄，因此 `specify integration uninstall` 與 `specify integration uninstall --force` 都會將其原地保留，包括例外行。升級仍會比對其雜湊值：加入使用者規則會阻擋一般的 `specify integration upgrade opencode`，直到該變更獲得解決或使用 `--force`；而 `--force` 也會覆寫編輯過的命令檔案。刪除這兩行並非持久的退出方式，因為只要儲存的旗標仍在，下次升級就會還原它們。請先以 `specify integration upgrade opencode --integration-options=""` 清除儲存的旗標，再移除這些行。

`.ignore` 是共用的 ignore 檔案。opencode 的 glob 工具會看到這些規則，因為它以 ripgrep 搜尋；其他讀取 `.ignore` 的工具（包括 fd）也可能開始顯示 `.specify`。`specify integration upgrade opencode` 會重播儲存的旗標。傳入 `--integration-options` 會取代整組已儲存的設定（請將 `--configure-ignore-file` 與任何其他旗標一併重複列出，例如 `--events false`）；`--integration-options=""` 會清除它們。
