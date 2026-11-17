# 工作流程

工作流程透過 YAML 定義，將多步驟的 Spec Kit 流程自動化。它們把代理命令、提示詞、shell 任務、控制流程與人工審查關卡串連成可重複、可續跑的執行。它們不同於您以 `/speckit.*` 命令手動遵循的流程，也不同於 GitHub Actions 工作流程。

## 開始之前

安裝 [Specify CLI](../installation.md)，並以[代理整合](../integrations/index.md)初始化您的專案。代理命令與提示詞步驟需要具備 CLI 執行能力的整合。僅含 shell 的本機 YAML 工作流程可以在已初始化的專案之外執行。

在安裝與使用之前，請先審查工作流程的原始碼，包括隨附指令碼、被呼叫的工作流程、自訂步驟套件與啟用中的覆疊。型錄上架與安裝許可並不是程式碼審查或安全性的證據。

## 執行、審查與繼續

```bash
specify workflow search
specify workflow add speckit
specify workflow run speckit --input spec="Build a kanban board"
```

內建的 SDD 工作流程會依序執行 specify、plan、tasks 與 implement，在規格與計畫之後設有審查關卡。在互動式終端機上，關卡會詢問判定；否則會暫停。請審查輸出，再續跑同一執行：

```bash
specify workflow status <run_id>
specify workflow resume <run_id>
```

若要在沒有互動式終端機的情況下核准已暫停的審查，請在審查輸出後提供對應的判定輸入：

| 工作流程 | 審查關卡 | 判定輸入 |
| --- | --- | --- |
| `speckit` | `review-spec` | `speckit_review_spec_verdict` |
| `speckit` | `review-plan` | `speckit_review_plan_verdict` |
| `bugfix` | `review-assessment` | `bug_review_assessment_verdict` |

```bash
specify workflow resume <sdd_run_id> --input speckit_review_spec_verdict=approve
specify workflow resume <sdd_run_id> --input speckit_review_plan_verdict=approve
specify workflow resume <bugfix_run_id> --input bug_review_assessment_verdict=approve
```

請使用與作用中審查相符的命令。這些字串輸入為選用，預設為 `""`：省略輸入或提供空值時，在互動式終端機上會保留既有的提示，否則會暫停。核准規格並不等於核准計畫審查。

這些輸入適用於 `speckit` 工作流程 1.0.2 版與 `bugfix` 1.0.1 版，需搭配 Specify CLI 0.15.1 或更新版本。請更新已安裝的工作流程並開始新的執行，以使用其新的輸入宣告。既有的執行會保留開始時儲存的工作流程定義；更新已安裝的工作流程不會為這些執行新增輸入。

每次執行都有自己的 ID 與狀態目錄。已完成的發生點會重播到運算式脈絡中，而不會重新執行其實作。未完成的工作會從保存的狀態繼續；在完成檢查點之前被中斷的副作用仍可能重複。

您也可以不經安裝，直接執行本機定義：

```bash
specify workflow run ./workflow.yml --input spec="Build a kanban board"
```

## 隨附的工作流程

| ID | 用途 | 主要輸入 |
| --- | --- | --- |
| `speckit` | 含規格與計畫審查關卡的完整 SDD 交付週期 | `spec` |
| `bugfix` | 錯誤評估、修復與驗證 | `report` |
| `assess` | 構想接收、研究、定義、形塑與決策 | `idea` |

使用 `specify workflow info <id>` 查看中繼資料、輸入與步驟圖。`speckit` 工作流程宣告 `spec`、選用的 `integration`，以及上述兩個選用的判定輸入，而非 `scope` 輸入。使用擴充功能命令的工作流程也需要安裝這些命令；請參閱各內建定義的需求。

## 自訂工作流程

為新的自動化流程撰寫定義、透過 `workflow` 步驟呼叫另一個已安裝的工作流程，或使用覆疊自訂已安裝的工作流程而不編輯其套件。覆疊可以填入具名槽位，或插入、取代與移除步驟；但無法變更基礎輸入結構描述。

## 常見問題

### 我可以多次執行同一個工作流程嗎？

可以。每次執行都有獨立的 ID 與保存的狀態。`specify workflow status` 會列出執行；提供執行 ID 即可顯示其狀態。

### 審查關卡會發生什麼事？

宣告的判定輸入可以在不提示的情況下決定關卡。否則，關卡會在 TTY 上提示，或暫停以待續跑。拒絕可以依其設定中止、跳過，或暫停以待重試。

### 誰維護工作流程？

大多數工作流程由其作者獨立維護。維護者只檢查社群型錄項目的格式與完整性，不檢查工作流程程式碼。他們不會審查、稽核、背書或支援該程式碼。使用者必須在安裝與使用之前自行審查原始碼。

## 另請參閱

- [Workflow CLI](cli.md)
- [Developing workflows](developing.md)
- [工作流程步驟總覽](../workflow-steps/overview.md)
- [Built-in step types](../workflow-steps/types.md)
- [Workflow overlays](overlays.md)
- [型錄與信任](catalogs.md)
- [Publishing workflows](publishing.md)
- [Community workflows](../community/workflows.md)
