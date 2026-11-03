---
description: 依據互動輸入或提供的原則輸入，建立或更新專案憲章。
handoffs:
  - label: 建立規格
    agent: speckit.specify
    prompt: 依據更新後的憲章實作功能規格。我想建立……
scripts:
  sh: scripts/bash/resolve-template.sh constitution-template --json
  ps: scripts/powershell/resolve-template.ps1 constitution-template -Json
  py: scripts/python/resolve_template.py constitution-template --json
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，你**必須**考慮使用者輸入（若非空白）。

## 範圍防護

這個命令本身的工作只限於更新專案憲章本身。相依的範本
與命令會在執行時讀取憲章，不在這裡修改。

- 將使用者輸入的每個部分分類為憲章內容，或獨立的
  非治理意圖。
- 若輸入包含功能實作、程式碼產生、重構、建置或
  部署要求，你**不得**執行它們。改將它們擷取為延後的意圖。
- 你**不得**建立、修改或刪除應用程式原始檔、功能路由、
  元件、測試、部署檔案，或其他與憲章
  工作流程無關的產物。
- 若某項指示是否屬於憲章內容不明確，在
  變更之前先要求釐清。
- 完成憲章更新後，為每個延後的
  意圖加入一節 `Next Actions`。列出原始意圖，並建議適當的後續 Spec Kit 命令，
  例如 `__SPECKIT_COMMAND_SPECIFY__`，但不要呼叫它。
- 若沒有非治理意圖，省略 `Next Actions` 一節。

## 執行前檢查

**檢查擴充功能 hooks（憲章更新之前）**：
- 檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.before_constitution` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後照常繼續
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
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

    Wait for the result of the hook command before proceeding to the Outline.
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過

## 大綱

你正在更新位於 `.specify/memory/constitution.md` 的專案憲章。現行的
憲章框架是在命令執行時，透過 Spec Kit
的預設集／範本解析堆疊，從 `constitution-template` 解析而來的。

依照以下執行流程：

1. 從儲存庫根目錄執行 `{SCRIPT}`，並將 `TEMPLATE_CONTENT` 解析為現行範本。
   - 共用解析器會先套用專案覆寫、組合預設集層與擴充功能層，
     最後才退回核心範本。它必須成功，才能繼續。
   - 若失敗，停下來並回報解析錯誤；不要只用單一參與的
     範本層繼續。
   - 若 `.specify/memory/constitution.md` 存在，將它載入為目前專案專屬
     值與修訂的來源。套用新解析出的框架時，保留仍然適用的資訊。
   - 若它不存在，使用解析出的範本作為初始文件。
   - 不要寫回任何有版本的範本層。
   - 找出每一個形式為 `[ALL_CAPS_IDENTIFIER]` 的佔位符記號。
   **重要**：使用者要求的原則數量可能少於或多於範本所用的數量。若有指明數量，尊重該數量——依照一般範本處理。你將據此更新文件。

2. 收集／推導佔位符的值：
   - 若使用者輸入（對話）有提供值，使用該值。
   - 否則從既有的儲存庫背景推斷（README、文件、先前的憲章版本，若有內嵌）。
   - 治理日期：`RATIFICATION_DATE` 是原始採納日期（若未知，詢問或標記 TODO），`LAST_AMENDED_DATE` 若有變更則為今天，否則保留先前的值。
   - `CONSTITUTION_VERSION` 必須依語意化版本規則遞增：
     - MAJOR：向後不相容的治理／原則移除或重新定義。
     - MINOR：新增原則／章節，或大幅擴充指引。
     - PATCH：釐清、措辭、錯字修正、非語意層面的修飾。
   - 若版本遞增類型不明確，在定案前提出理由。

3. 以解析出的範本為必要結構，草擬更新後的憲章內容：
   - 將每個佔位符換成具體文字（不要留下括號記號，除非是專案選擇尚未定義而刻意保留的範本槽位——任何留下的都要明確說明理由）。
   - 保留標題階層；註解在被取代後可以移除，除非它們仍能提供釐清用的指引。
   - 確保每個原則章節都有：簡潔的名稱行、一段文字（或條列清單）寫明不可協商的規則，以及不明顯時的明確理由。
   - 確保治理一節列出修訂程序、版本政策與合規審查期望。

4. 在更新後，於憲章檔案頂端以 HTML 註解的形式產生同步影響報告。
   這份報告是供人工審查修訂用的暫時草稿材料，不是治理
   內容；預期在修訂後的憲章檔案提交之前移除。
   - 版本變更：舊 → 新
   - 修改過的原則清單（若改名，舊標題 → 新標題）
   - 新增的章節
   - 移除的章節
   - 若有刻意延後的佔位符，列出後續 TODO

5. 最終輸出前的驗證：
   - 沒有留下未說明的括號記號。
   - 版本行與報告相符。
   - 日期為 ISO 格式 YYYY-MM-DD。
   - 原則是宣告式、可測試，且沒有含糊語言（適當時將「should」換成附理由的 MUST/SHOULD）。

6. 將完成的憲章寫回 `.specify/memory/constitution.md`（覆寫）。

7. 向使用者輸出最終摘要，包含：
   - 新版本與遞增理由。
   - 任何需要人工後續處理的 TODO 佔位符或延後項目。
   - 建議的提交訊息（例如 `docs: amend constitution to vX.Y.Z (principle additions + governance update)`）。
   - 為任何延後的非治理意圖準備的一節 `Next Actions`。

格式與風格要求：

- 標題的 Markdown 階層與範本完全相同（不要降級／升級）。
- 將較長的理由行折行以保持可讀性（理想上小於 100 字元），但不要用彆扭的斷行硬性執行。
- 章節之間保留一個空白行。
- 避免行尾空白。

若使用者只提供部分更新（例如只修訂一項原則），仍要執行驗證與版本決策步驟。

若關鍵資訊缺失（例如批准日期真的未知），插入 `TODO(<FIELD_NAME>): explanation`，並在同步影響報告的延後項目中列出。

只寫入 `.specify/memory/constitution.md`；不要建立或修改範本來源檔案。

## 執行後檢查

**檢查擴充功能 hooks（憲章更新之後）**：
檢查專案根目錄是否存在 `.specify/extensions.yml`。
- 若存在，讀取它並尋找 `hooks.after_constitution` 鍵底下的項目
- 若 YAML 無法解析或無效，不要默默跳過：告訴使用者 `.specify/extensions.yml` 無法讀取（附上解析器錯誤），且沒有檢查任何 hooks，包括在那裡註冊的任何強制（`optional: false`）hooks，然後照常繼續
- 濾掉 `enabled` 明確為 `false` 的 hooks。沒有 `enabled` 欄位的 hooks 預設視為啟用。
- 對每個剩下的 hook，**不要**嘗試解讀或評估 hook 的 `condition` 運算式：
  - 若 hook 沒有 `condition` 欄位，或其為 null／空白，將該 hook 視為可執行
  - 若 hook 定義了非空白的 `condition`，跳過該 hook，讓 HookExecutor 實作去評估條件
- 對每個可執行的 hook，依其 `optional` 旗標輸出以下內容：
  - **選擇性 hook**（`optional: true`）：
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **強制 hook**（`optional: false`）：
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
    輸出上方區塊之後，你必須真的呼叫該 hook 並等它完成，才能繼續。用你在這個代理／工作階段中執行該命令的相同方式執行它（呼叫方式可能與上方顯示的字面 `{command}` 識別字不同，例如 skills 模式的代理會以 `/skill:speckit-...` 或 `$speckit-...` 執行）。只輸出區塊並不會執行 hook。
- 若沒有註冊任何 hooks，或 `.specify/extensions.yml` 不存在，默默跳過
