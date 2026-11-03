---
description: "套用缺陷評估所提出的修復方式，並記錄變更內容"
---

# 修復缺陷

套用 `__SPECKIT_COMMAND_BUG_ASSESS__` 所提出的修復方式，並將變更記錄在位於 `.specify/bugs/<slug>/fix.md` 的修復報告中。此命令**只有**在該 slug 的評估已存在時才有效。

## 使用者輸入

```text
$ARGUMENTS
```

使用者輸入應能指明要修復的缺陷。接受以下任一形式：

- `slug=<bug-slug>`、`--slug <bug-slug>`，或只是一個單獨的 slug 樣式詞元。
- 含有該 slug 的路徑（例如 `.specify/bugs/login-timeout/`）。
- **空**——改從脈絡推斷（見下文）。

## Slug 解析

依以下順序解析 `BUG_SLUG`，命中第一個符合者即停止：

1. **明確的使用者輸入**——在 `$ARGUMENTS` 中傳入的 slug（上述任一形式）。
2. **對話脈絡**——若目前工作階段剛執行過 `__SPECKIT_COMMAND_BUG_ASSESS__`，它回報的 slug 即為工作 slug。直接重用，不必再次提示。透過檢查 `.specify/bugs/<slug>/assessment.md` 是否存在來確認；若不存在，繼續往下。
3. **磁碟上的單一候選**——列出 `.specify/bugs/*/assessment.md`。若恰好只找到一個符合的 `assessment.md`，使用其父目錄的 slug。
4. **消歧義**：
   - **互動模式**：詢問使用者要修復哪個缺陷，並列出候選。
   - **自動模式**：停止並回報錯誤，列出候選。不要臆測。

解析完成後，設定 `BUG_SLUG` 與 `BUG_DIR = .specify/bugs/<BUG_SLUG>`，並在回覆中簡短說明所用的解析路徑（明確指定／來自脈絡／單一候選／經詢問）。

## 前置條件

- `BUG_DIR/assessment.md` 必須存在。若不存在，停止並指示使用者先執行 `__SPECKIT_COMMAND_BUG_ASSESS__`。
- 若 `BUG_DIR/fix.md` 已存在，在繼續之前詢問使用者是否覆寫（互動模式），或拒絕（自動模式）。
- 完整讀取 `BUG_DIR/assessment.md`。將其 **Proposed Remediation**、**Files likely to change**、**Tests to add or update** 與 **Risks & Considerations** 等節，視為此命令的契約。

## 執行前檢查

到此 `BUG_SLUG` 與 `BUG_DIR` 已解析完成，因此在此工作階段中執行的 hook 命令可以直接從對話中重用它們；不會有任何東西自動傳遞給它。

**檢查擴充功能 hooks（在缺陷修復之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_bug_fix` 鍵下的條目
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

1. **確認計畫**
   - 根據評估，用 3–6 個要點重述你即將變更的內容與位置。
   - 若評估的判定為 `invalid`，停止——沒有東西需要修復。告訴使用者並結束。
   - 若判定為 `likely valid, needs reproduction`，且有未解決的 `[NEEDS CLARIFICATION]` 項目，標出它們，並在互動模式下詢問使用者是否繼續，或在自動模式下停止。

2. **套用修復方式**
   - 進行首選修復方式所描述的程式碼變更。將範圍限於評估列出的檔案，除非新發現的證據要求擴大範圍（此時要在報告中明確記錄該擴大）。
   - 新增或更新評估所指出的測試，使該缺陷無法在無聲無息中迴歸。
   - 保持變更最小——不要重構無關的程式碼，不要引入評估未要求的相依性。
   - 若你發現評估有誤（所提修復無效、根本原因在別處），停止修改程式碼，將新發現記錄在修復報告的 **Deviations from Assessment** 之下，並建議重新執行 `__SPECKIT_COMMAND_BUG_ASSESS__`。

3. **執行本機檢查**
   - 若專案有明顯的測試命令（例如 `pytest`、`npm test`、`cargo test`），執行能涵蓋變更路徑的測試。擷取通過／失敗與關鍵輸出。
   - 未經使用者同意，不要執行具破壞性或依賴網路的測試套件。

4. **撰寫修復報告**

   使用以下結構寫入 `BUG_DIR/fix.md`：

   ```markdown
   # Bug Fix: <short title>

   - **Slug**: <BUG_SLUG>
   - **Fixed**: <ISO 8601 date>
   - **Assessment**: ./assessment.md
   - **Status**: applied | partial | not-applied

   ## Summary

   <One or two sentences describing what was changed and why.>

   ## Changes

   | File | Change | Notes |
   |------|--------|-------|
   | `path/to/file.py` | <added / modified / removed> | <short note> |
   | `path/to/test_file.py` | added test | <short note> |

   ## Diff Highlights (optional)

   <Short, illustrative snippets of the most important hunks — not a full diff dump.>

   ## Tests Added or Updated

   - `path/to/test_file.py::test_name` — <what it pins down>

   ## Local Verification

   - Commands run: `<command>` → <result, brief>
   - Manual checks: <what was verified by hand, if anything>

   ## Deviations from Assessment

   <Empty if none. Otherwise, list any places where the actual fix departed from the proposed remediation and why.>

   ## Follow-ups

   - <suggested cleanup, monitoring, doc update, etc.>
   ```

## 強制執行後 Hooks

**在向使用者回報完成之前，你必須完成本節。**

到此 `BUG_SLUG` 與 `BUG_DIR` 已解析完成，且已寫入的報告可供使用，因此在此工作階段中執行的 hook 命令可以直接從對話中重用它們；不會有任何東西自動傳遞給它。

檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若不存在，或 `hooks.after_bug_fix` 下未註冊任何 hooks，跳至完成報告。
- 若存在，讀取它並尋找 `hooks.after_bug_fix` 鍵下的條目。
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

- slug 與 `BUG_DIR/fix.md` 路徑。
- 狀態（`applied`、`partial`、`not-applied`）。
- 建議的下一步：`__SPECKIT_COMMAND_BUG_TEST__ slug=<BUG_SLUG>`。

## 護欄

- 絕不修改專案工作區以外的檔案。
- 絕不編輯 `assessment.md`——它是你據以工作的契約。將不同意見記錄在 `fix.md` 的 **Deviations from Assessment** 之下。
- 除非評估明確要求，絕不刪除檔案。
- 未經確認，絕不覆寫既有的 `fix.md`。
