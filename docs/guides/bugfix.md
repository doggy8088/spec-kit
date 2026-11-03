# 錯誤修復快速入門

當既有行為出錯，需要有憑有據的診斷、限定範圍的修復，以及對照原始回報的驗證時，就使用這套流程。你不必先跑 SDD 功能工作流程。

隨附的選用 **bug** 擴充功能把工作拆成 **assess → fix → test** 三個階段。每個錯誤都會在 `.specify/bugs/<slug>/` 下建立一個目錄，存放診斷、變更紀錄與測試結果。

## 安裝設定

先[安裝 Spec Kit](../installation.md)，並初始化包含該錯誤的儲存庫。若儲存庫已有程式碼，請依循[在既有專案中採用 Spec Kit](existing-projects.md)。

在已初始化專案根目錄的終端機中，安裝擴充功能：

```bash
specify extension add bug
```

接著在該目錄中啟動你的程式代理。以下範例使用 GitHub Copilot 的預設 skills 模式（`--integration copilot`）。其他代理會以各自的[命令呼叫語法](../integrations/cli.md#command-invocation)提供相同步驟。請在代理的聊天中分別呼叫每個 `/speckit-bug-*` skill，並在繼續之前檢視其輸出。這些是代理 skill，不是終端機命令；上面的終端機命令只是安裝擴充功能。

## 1. 評估錯誤

提供症狀、重現步驟與預期行為。GitHub issue 連結或堆疊追蹤也可以。為該錯誤選一個簡短、可重複使用的名稱：

```text
/speckit-bug-assess "Submitting the login form with an empty password crashes the app instead of showing a validation error." slug=login-crash
```

代理會調查程式碼，並寫入 `.specify/bugs/login-crash/assessment.md`。它不會修改原始碼。在要求修復之前，請檢視診斷與建議的補救方式；若診斷沒有依據，或回報的內容根本不是錯誤，不要繼續。

## 2. 修復已評估的原因

使用相同的 slug：

```text
/speckit-bug-fix slug=login-crash
```

代理會套用已評估的補救方式，並把變更記錄在 `.specify/bugs/login-crash/fix.md`。這是唯一會編輯原始碼的階段。若新證據顯示需要超出已評估範圍的工作，代理必須記錄該偏離，而不是悄悄擴大修復範圍。

## 3. 測試修復

```text
/speckit-bug-test slug=login-crash
```

代理會重新執行重現步驟與相關測試，接著寫入 `.specify/bugs/login-crash/test.md`。這個階段記錄證據；它不會為了讓失敗的測試通過而編輯原始碼。

| 判定 | 意義 | 下一步 |
| --- | --- | --- |
| `verified` | 驗證要求已成功執行 | 在合併前檢視修補與證據 |
| `partial` | 部分驗證無法完成 | 提供缺漏的環境或重現證據，再重新測試 |
| `failed` | 驗證發現仍有問題 | 依該證據重新檢視診斷或修復，再重新測試 |

若原始重現步驟從未實際執行，光是測試套件通過並不夠。請把評估、修復紀錄與測試報告放在一起，讓審查者能從症狀一路追溯到證據。

## 深入了解

- [錯誤命令參考](../reference/agentic-bugfix.md)：引數、slug 處理與輸出契約。
- [SDD 快速入門](../quickstart.md)：當工作是新功能而非修復時使用。
- [構想評估快速入門](assessment.md)：調查一項提議的變更是否值得投入。
