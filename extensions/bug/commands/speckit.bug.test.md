---
description: "驗證先前已修復的缺陷確實獲得解決，並記錄驗證報告"
---

# 測試缺陷修復

驗證 `__SPECKIT_COMMAND_BUG_FIX__` 所記錄的修復，是否確實解決了 `__SPECKIT_COMMAND_BUG_ASSESS__` 所描述的缺陷。輸出為位於 `.specify/bugs/<slug>/test.md` 的驗證報告。

## 使用者輸入

```text
$ARGUMENTS
```

使用者輸入應能指明要驗證的缺陷。接受以下任一形式：

- `slug=<bug-slug>`、`--slug <bug-slug>`，或一個單獨的 slug 樣式詞元。
- 含有該 slug 的路徑（例如 `.specify/bugs/login-timeout/`）。
- **空**——改從脈絡推斷（見下文）。

## Slug 解析

依以下順序解析 `BUG_SLUG`，命中第一個符合者即停止：

1. **明確的使用者輸入**——在 `$ARGUMENTS` 中傳入的 slug（上述任一形式）。
2. **對話脈絡**——若目前工作階段剛執行過 `__SPECKIT_COMMAND_BUG_ASSESS__` 或 `__SPECKIT_COMMAND_BUG_FIX__`，它回報的 slug 即為工作 slug。直接重用，不必再次提示。透過檢查 `.specify/bugs/<slug>/fix.md` 是否存在來確認；若不存在，繼續往下。
3. **磁碟上的單一候選**——列出 `.specify/bugs/*/fix.md`。若恰好只有一個缺陷有 `fix.md`，就使用它。
4. **消歧義**：
   - **互動模式**：詢問使用者要驗證哪個缺陷，並列出候選。
   - **自動模式**：停止並回報錯誤，列出候選。不要臆測。

解析完成後，設定 `BUG_SLUG` 與 `BUG_DIR = .specify/bugs/<BUG_SLUG>`，並在回覆中簡短說明所用的解析路徑（明確指定／來自脈絡／單一候選／經詢問）。

## 前置條件

- `BUG_DIR/assessment.md` 必須存在。
- `BUG_DIR/fix.md` 必須存在。若不存在，停止並指示使用者先執行 `__SPECKIT_COMMAND_BUG_FIX__`。
- 若 `BUG_DIR/test.md` 已存在，詢問使用者是否覆寫（互動模式），或拒絕（自動模式）。
- 完整讀取 `assessment.md` 與 `fix.md`，以便掌握：
  - 原始症狀與重現步驟（來自 `assessment.md`）。
  - 實際的程式碼變更與新增的測試（來自 `fix.md`）。

## 執行前檢查

到此 `BUG_SLUG` 與 `BUG_DIR` 已解析完成，因此在此工作階段中執行的 hook 命令可以直接從對話中重用它們；不會有任何東西自動傳遞給它。

**檢查擴充功能 hooks（在缺陷驗證之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_bug_test` 鍵下的條目
- 若 YAML 無法解析或無效，不要默默略過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且未檢查任何 hooks，包括在該處註冊的任何強制（`optional: false`）hooks，然後正常繼續
- 濾除 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個其餘的 hook，**不要**試圖解讀或求值 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null/空，則視該 hook 為可執行
  - 若 hook 定義了非空的 `condition`，略過該 hook，將條件求值留給 HookExecutor 實作
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **強制 hook**（`optional: false`）：
    ```
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to Execution.
    ```
    在輸出上述區塊之後，你必須實際叫用該 hook 並等待其完成，才能繼續。以你自己在此代理／工作階段中執行命令的相同方式執行它（實際叫用方式可能與上方顯示的字面 `{command}` id 不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行它）。僅輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默略過

## 執行

1. **規劃驗證**
   - 決定哪些檢查能證明缺陷已消失：
     - 重新執行評估中的重現步驟（或其自動化等價作法）。
     - 執行修復中新增或更新的測試。
     - 執行任何觸及變更檔案的更廣泛迴歸測試套件。
   - 決定哪些檢查能證明沒有弄壞其他東西：
     - 變更模組的既有測試套件。
     - 若專案有使用，執行 lint／型別檢查。

2. **執行檢查**
   - 執行每一項規劃的檢查。擷取命令、結束狀態，以及相關輸出的簡短摘錄（最後幾行，或失敗的斷言）。
   - 若某項檢查具破壞性、依賴網路或代價高昂，略過它並記錄為 `skipped` 附上原因；未經使用者明確同意，不要執行它。
   - 若某項檢查根本無法執行（缺少工具、未設定測試框架），記錄為 `not-run` 附上原因，不要捏造結果。

3. **判定結果**
   - 將修復標記為：
     - **verified**——所有關鍵檢查皆通過，且原始症狀不再重現。
     - **partial**——原始症狀已消失，但出現無關的迴歸，或部分檢查無法得出結論。
     - **failed**——症狀仍會重現，或迴歸測試套件被修復弄壞。
   - 不要過度宣稱。若實際上並未執行重現（例如該缺陷需要正式環境），明確說明。

4. **撰寫驗證報告**

   使用以下結構寫入 `BUG_DIR/test.md`：

   ```markdown
   # Bug Verification: <short title>

   - **Slug**: <BUG_SLUG>
   - **Tested**: <ISO 8601 date>
   - **Assessment**: ./assessment.md
   - **Fix**: ./fix.md
   - **Result**: verified | partial | failed

   ## Summary

   <One or two sentences: does the bug reproduce, did the fix hold, were any regressions found.>

   ## Checks Performed

   | Check | Command / Action | Result | Notes |
   |-------|------------------|--------|-------|
   | Reproduction (post-fix) | <command or manual steps> | pass / fail / skipped / not-run | <short note> |
   | New / updated tests | `<command>` | pass / fail | <short note> |
   | Regression suite | `<command>` | pass / fail / skipped | <short note> |
   | Lint / type-check | `<command>` | pass / fail / skipped | <short note> |

   ## Output Excerpts

   <Short snippets of relevant output (e.g., final summary line of a test run, the failing assertion). Keep it tight — no full logs.>

   ## Residual Risks

   - <known limitation, environment not covered, etc.>

   ## Recommendation

   <One paragraph. Examples:>
   - "Close the bug — verified end-to-end."
   - "Hold — reproduction inconclusive; needs verification in staging."
   - "Reopen — symptom still reproduces; rerun `__SPECKIT_COMMAND_BUG_ASSESS__`."
   ```

## 強制執行後 Hooks

**在向使用者回報完成之前，你必須完成本節。**

到此 `BUG_SLUG` 與 `BUG_DIR` 已解析完成，且已寫入的報告可供使用，因此在此工作階段中執行的 hook 命令可以直接從對話中重用它們；不會有任何東西自動傳遞給它。

檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若不存在，或 `hooks.after_bug_test` 下未註冊任何 hooks，跳至完成報告。
- 若存在，讀取它並尋找 `hooks.after_bug_test` 鍵下的條目。
- 若 YAML 無法解析或無效，不要默默略過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且未檢查任何 hooks，包括在該處註冊的任何強制（`optional: false`）hooks，然後繼續進行完成報告。
- 濾除 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個其餘的 hook，**不要**試圖解讀或求值 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null/空，則視該 hook 為可執行
  - 若 hook 定義了非空的 `condition`，略過該 hook，將條件求值留給 HookExecutor 實作
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **強制 hook**（`optional: false`）——**你必須為每個強制 hook 輸出 `EXECUTE_COMMAND:`**：
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    在輸出上述區塊之後，你必須實際叫用該 hook 並等待其完成，才能繼續。以你自己在此代理／工作階段中執行命令的相同方式執行它（實際叫用方式可能與上方顯示的字面 `{command}` id 不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行它）。僅輸出區塊並不會執行 hook。
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

## 完成報告

**回報**以下內容：

- slug 與 `BUG_DIR/test.md` 路徑。
- 結果（`verified`、`partial`、`failed`）。
- 若結果為 `failed`，建議以 `test.md` 中擷取的新證據，重新執行 `__SPECKIT_COMMAND_BUG_ASSESS__`。

## 護欄

- 此命令不得修改原始碼。它只執行檢查，並只在 `.specify/bugs/<slug>/` 內寫入。
- 未經確認，絕不覆寫既有的 `test.md`。
- 若原始評估列出的重現步驟你實際上並未執行，絕不只憑測試就將修復標記為 `verified`——降為 `partial` 並說明原因。
