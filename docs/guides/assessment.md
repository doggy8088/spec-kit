# 構想評估快速入門

在投入解決方案之前，用這套流程判斷一個構想是否值得投資。它同樣適用於軟體構想與非軟體決策。不需要既有的原始碼。

隨附的選用 **assess** 擴充功能提供五個階段：**intake → research → define → shape → decide**。成果是一份有證據支持的 `go`、`needs-clarification` 或 `kill` 決策，而不是實作。

## 安裝設定

[安裝 Spec Kit 並初始化專案](../installation.md)。一個空專案就足夠；或者當構想與某個儲存庫的程式碼相關時，也可以使用[既有儲存庫](existing-projects.md)。在已初始化專案根目錄的終端機中，安裝擴充功能：

```bash
specify extension add assess
```

接著在該目錄中啟動你的程式代理。以下範例使用 GitHub Copilot 的預設 skills 模式（`--integration copilot`）。其他代理會使用各自的[命令呼叫語法](../integrations/cli.md#command-invocation)。請在代理的聊天中分別呼叫每個 `/speckit-assess-*` skill，在往下走之前先檢視產出物。這些是代理 skill，不是終端機命令；上面的終端機命令只是安裝擴充功能。

## 1. 記錄構想

```text
/speckit-assess-intake "Let users work offline and sync when they reconnect." slug=offline-mode
```

你也可以提供 URL、工單或程式碼庫指標。代理會把輸入記錄在 `.specify/assessments/offline-mode/intake.md`。slug 是五個階段共用的識別代號。

## 2. 研究證據

```text
/speckit-assess-research slug=offline-mode
```

代理會在 `research.md` 中蒐集支持與反對的證據。請檢視來源與信心等級：沒有出處的假設不是既定事實。這個階段應該挑戰構想，而不只是為它找理由。

## 3. 定義問題

```text
/speckit-assess-define slug=offline-mode
```

代理會寫出 `problem.md`，描述受影響的使用者、問題、目標、非目標、成功指標，以及什麼都不做的代價。

## 4. 塑造可能的解決方案

```text
/speckit-assess-shape slug=offline-mode
```

代理會在 `concept.md` 中比較概念層級的選項、限制、胃納量與取捨。詳細架構、實作任務與原始碼變更刻意不在這套流程的範圍內。

## 5. 做出決策

```text
/speckit-assess-decide slug=offline-mode
```

代理會把評分表、理由與判定記錄在 `decision.md`。

| 判定 | 意義 | 下一步 |
| --- | --- | --- |
| `go` | 問題與證據已足夠，且有推薦的概念 | 決定是否採取行動；可選擇把軟體構想交給 SDD |
| `needs-clarification` | 特定的未知事項仍阻礙站得住腳的決策 | 用缺漏的資訊精煉受影響的產出物 |
| `kill` | 這個構想目前不值得追求 | 保留記錄下來的理由；停下來本身就是成功的結果 |

五份產出物都放在 `.specify/assessments/offline-mode/` 下。評估命令都不會修改原始碼。

## 透過精煉產出物來釐清未知事項

一般流程是每個命令各跑一次。當某份產出物含有 `[NEEDS CLARIFICATION: ...]` 時，直接編輯該 Markdown 檔案，或在自由形式的聊天中請代理納入缺漏的資訊：

```text
Update .specify/assessments/offline-mode/problem.md with these confirmed success metrics: <your metrics>. Update any dependent wording and revise decision.md if this resolves the blocker. Preserve source and confidence tags.
```

不要自動重新產生整個階段。請代理檢視新事實是否已解除阻礙，並據此修訂下游的評分表、判定或交接內容。重新執行命令屬於例外情況，例如取代一份已捨棄的草稿，而且未經確認不得覆寫既有產出物。

## 選用的 SDD 交接

評估是獨立的：它不會自動呼叫 SDD，也不會把自己插入規格流程。若你決定以 `go` 判定來打造一個軟體構想，請視需要先建立專案憲章，再把決策的交接摘要交給規格命令：

```text
/speckit-specify Use the handoff summary in .specify/assessments/offline-mode/decision.md to specify the approved offline-mode concept.
```

接著繼續 [SDD 快速入門](../quickstart.md)。關於各階段的前置條件、slug 規則與證據要求，請見[構想評估命令參考](../reference/agentic-assessment.md)。
