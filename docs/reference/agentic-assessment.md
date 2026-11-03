# 代理式想法評估

隨附、需主動啟用的 **assess** 擴充功能，透過**受理 → 研究 → 定義 → 塑形 → 決策**來評估想法。這是獨立流程：它可以在已初始化、沒有原始碼的專案中執行，只產生評估成品，不會自動啟動 SDD。如需引導式範例，請參見[想法評估快速入門](../guides/assessment.md)。

從已初始化專案的根目錄安裝：

```bash
specify extension add assess
```

以下命令使用 `/speckit.assess.*` 記法。GitHub Copilot 的預設 skills 模式使用 `/speckit-assess-*`；其他整合可能使用不同的前綴。請參見[命令呼叫方式](../integrations/cli.md#command-invocation)。

## 命令與成品

每個成品都寫入 `.specify/assessments/<slug>/` 之下。

| 命令 | 用途 | 輸出 |
| --- | --- | --- |
| `/speckit.assess.intake` | 從文字、URL、工單或程式碼庫指標擷取想法 | `intake.md` |
| `/speckit.assess.research` | 蒐集支持與反對想法的證據，附來源與信心程度 | `research.md` |
| `/speckit.assess.define` | 定義使用者、問題、目標、非目標、指標與不行動的成本 | `problem.md` |
| `/speckit.assess.shape` | 比較概念層級的選項、意願與取捨 | `concept.md` |
| `/speckit.assess.decide` | 記錄計分卡、判定、理由與選用的 SDD 交接 | `decision.md` |

將初始想法與 slug 傳給 intake，然後重用該 slug：

```text
/speckit.assess.intake "Let users work offline and sync when they reconnect." slug=offline-mode
/speckit.assess.research slug=offline-mode
/speckit.assess.define slug=offline-mode
/speckit.assess.shape slug=offline-mode
/speckit.assess.decide slug=offline-mode
```

## 前置條件與範圍

五個階段的序列是正常路徑，但並非每個階段都是強制性的：

- `define` 可以直接從使用者輸入著手；intake 與 research 對於產生問題定義而言是選用的。
- `shape` 需要 `problem.md`，且停留在概念層級。架構、資料模型、API、任務與實作屬於交付範疇，不屬於評估。
- `decide` 需要 `problem.md`，並讀取所有可用的評估成品。`go` 判定還需要已塑形的概念與充分的證據；跳過 research 不會免除證據要求。

## Slug 與既有成品

Slug 標識單一想法的目錄。使用者提供的 slug 會正規化為小寫 kebab-case，並保留，不附加時間戳記或編號。若未提供 slug，intake 會以互動方式要求提供；自動化執行則會產生唯一 slug。後續階段在目錄存在時，可以從上下文重用 slug。

既有成品不會在未經確認的情況下被覆寫。在自動化模式下，命令會拒絕覆寫它們。對於例行釐清，請精修既有成品，而非重新執行命令。

## 決策與證據

決策計分卡將各項標準評為 `strong`、`adequate`、`weak` 或 `unknown`，並附上取自成品的理由。

| 判定 | 要求或意義 |
| --- | --- |
| `go` | 問題有效性與證據強度至少為 `adequate`，且有推薦的概念選項 |
| `needs-clarification` | 已命名的未知事項阻礙決策；薄弱或未知的證據，或缺少概念，都無法證明 `go` 是合理的 |
| `kill` | 此想法目前不值得追求；決定性的理由會明確記錄 |

研究必須包含反對想法的證據。無來源的主張會保持標記為 `ASSUMPTION`；不要捏造引用，也不要將不確定的證據呈現為事實。有記錄的停止決策是有用的結果。

## 精修評估

在通常的流程中，每個階段執行一次。若要解決釐清標記或 `needs-clarification` 判定，請直接編輯受影響的 Markdown，或在自由形式的對話中請代理納入缺少的事實。保留來源與信心標籤，然後檢視相依的成品，並視需要修訂 `decision.md`。這是成品精修，不是重複執行命令。

重新執行較早的命令只保留給例外情況，例如 slug 錯誤或草稿被捨棄。請參見[引導式釐清範例](../guides/assessment.md#resolve-unknowns-by-refining-the-artifacts)。

## 交接與防護措施

`go` 決策包含一份交接摘要，你可以選擇將它傳給 `/speckit.specify`。沒有任何生命週期 hook 會將評估安裝為 SDD 的前置條件，非軟體想法也完全不需要進入 SDD。

評估命令只在 `.specify/assessments/<slug>/` 內寫入；它們不編輯原始碼。此擴充功能會檢查 slug 與路徑，將取得的內容視為不受信任的資料，並套用其 URL 信任原則。完整的防護措施以及與其他擴充功能的關係，請參閱[擴充功能文件](https://github.com/github/spec-kit/blob/main/extensions/assess/README.md)。
