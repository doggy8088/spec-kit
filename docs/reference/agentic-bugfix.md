# 代理式錯誤修復

**bug** 擴充功能新增三步驟的錯誤分流流程，也就是評估、修復與驗證，由程式代理與核心 [代理式 SDD](agentic-sdd.md) 流程並行執行。每個錯誤在 `.specify/bugs/<slug>/` 下各自有獨立目錄，每個階段各有一份 Markdown 報告。

如需引導式範例，請參閱[錯誤修復快速入門](../guides/bugfix.md)。修復錯誤不需先進行 SDD 功能流程。若要評估想法而非修復損壞的行為，請參見[想法評估](agentic-assessment.md)。

> [!NOTE]
> 本頁的命令一律以 `/speckit.bug.*` 形式撰寫。GitHub Copilot 的預設 skills 模式使用 `/speckit-bug-*`；部分其他代理使用 `$speckit-bug-*`（例如 Codex、ZCode）或 `/skill:speckit-bug-*`（例如 Kimi）。請參見[命令呼叫方式](../integrations/cli.md#command-invocation)。

bug 擴充功能是隨附、需主動啟用的擴充功能。使用這些命令前請先安裝：

```bash
specify extension add bug
```

三個命令共用同一個識別值，也就是 **slug**，即 `.specify/bugs/` 下每個錯誤的目錄名稱。以 `slug=<name>` 提供；若省略，`/speckit.bug.assess` 會要求提供一個（或在自動化模式下產生唯一值）。Slug 會正規化為小寫 kebab-case。若某個 slug 已有評估結果，互動式執行會在覆寫前先詢問，而自動化執行則會拒絕並改選新的唯一 slug。

```text
/speckit.bug.assess -> /speckit.bug.fix -> /speckit.bug.test
```

## `/speckit.bug.assess`

將錯誤報告，也就是貼上的文字（例如堆疊追蹤）或 URL（例如 GitHub issue），對照程式碼庫進行分流：判斷報告是否為真正的錯誤、找出疑似的程式碼路徑，並提出修復建議。此命令為**唯讀**：它只寫入 `assessment.md`，絕不修改原始碼。

```text
/speckit.bug.assess "TypeError: cannot read properties of undefined (reading 'token') at /auth/callback"
```

```text
/speckit.bug.assess https://github.com/example/repo/issues/1234 slug=callback-token
```

輸出：`.specify/bugs/<slug>/assessment.md`。

## `/speckit.bug.fix`

套用評估中描述的修復方式，並精確記錄變更內容。這是**唯一**會編輯原始碼的錯誤命令，且會限制在評估所列的檔案範圍內，除非新證據要求擴大範圍（記錄於 **Deviations from Assessment** 之下）。

```text
/speckit.bug.fix slug=callback-token
```

輸出：`.specify/bugs/<slug>/fix.md`。

## `/speckit.bug.test`

透過重新執行重現步驟與新增的測試來驗證修復結果，然後記錄驗證結果，結果為 `verified`、`partial` 或 `failed` 其中之一。如同 `assess`，它對原始碼而言是**唯讀**的。判定絕不誇大：若評估列出了重現步驟但實際未執行，整體結果會降為 `partial`，而不會回報為 `verified`。

```text
/speckit.bug.test slug=callback-token
```

輸出：`.specify/bugs/<slug>/test.md`。

## 擴充功能 hook

每個錯誤命令都向其他擴充功能公開 `before_bug_<command>` 與 `after_bug_<command>` hook。前置 hook 在 slug 解析與前置條件完成後執行；評估會先建立錯誤目錄。後置 hook 在報告寫入後、回報完成前執行。若貼上的報告無法理解，會停止且不寫入評估，也不執行後置 hook；前置 hook 可能已經執行。Hook 是在同一個工作階段中執行的提示詞；它們重用對話中已解析的 `BUG_SLUG` 與 `BUG_DIR`（後置 hook 還會重用已寫入的報告），不會注入任何變數。若未註冊任何 hook，工作流程會照常進行。請參見 [bug 擴充功能的 hook 事件與設定範例](https://github.com/github/spec-kit/blob/main/extensions/bug/README.md#hooks)。
