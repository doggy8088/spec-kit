# 規格的規格

當某個功能過於龐大，無法在單一 `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement` 循環中完成而不讓模型在實作中途失去脈絡時，你可以將它拆解為一份**路線圖**，由較小、可獨立規格化的子功能組成。這就是「規格的規格」作法：先進行一輪拆解，將龐大的功能分解為自成一體的規格，每份規格再各自走完 specify/plan/tasks/implement 循環。

> **何時該採用此作法。** 拆解是[處理複雜功能](complex-features.md)中額外成本最高的策略。**僅在該頁較輕量的選項不足時**才使用——先嘗試限制每次 `/speckit.implement` 呼叫執行的任務數量，再嘗試子代理委派，然後兩者並用。只有當單一階段都過大、無法在一次執行中處理時，才採用規格的規格。

本頁其餘部分說明*如何*用你已有的工具做到這一點。不需要任何新命令或擴充功能。

## 路線圖階段

在撰寫任何子規格之前，先進行一輪拆解，產出一份路線圖。將此視為與代理的輕量規劃對話，而不是完整的規格：

1. **陳述整個功能。** 用一兩句話描述大型功能（即「epic」），讓代理一開始就掌握全貌。
2. **找出獨立切片。** 請代理提出一組少量的子功能，每個子功能都能交付 epic 的一個連貫部分，且能獨立規格化。目標是能獨立測試的切片——只實作其中一個，就應該留下可展示的成果。
3. **劃清邊界。** 為每個切片寫一行意圖與明確的範圍邊界（哪些納入、哪些延後到同層級切片）。清晰的邊界正是讓每份子規格小到能納入上下文的關鍵。
4. **依相依性排序。** 註明哪些切片相依於其他切片，並排序讓前置條件先行。彼此無相依關係的切片可以任意順序建置。若要平行建置獨立切片，請使用獨立的 worktree，讓每次執行都有隔離的使用中功能狀態。
5. **將結果記錄為路線圖。** 將切片記錄在持久的路線圖檔案中（見下文），讓後續每份子規格都能指向它。

路線圖刻意保持淺層：它命名並排序子功能，但**不**設計它們。設計會在每個切片走完自己的 `/speckit.specify` 時才發生。

## 路線圖成品

路線圖是你撰寫並納入版本控制的普通 Markdown 檔案——背後沒有特殊工具。將它放在子規格能找到的位置：

- 以功能為範疇的 epic：`specs/<epic-slug>/roadmap.md`。
- 較大型、橫切性的 epic：頂層的 `ROADMAP.md`。

每筆路線圖條目都包含穩定的 id（稍後用於連結）、名稱、意圖、範圍邊界、相依性、狀態，以及——子規格存在後——指向它的連結。最小範本如下：

```markdown
# Roadmap: <epic name>

<One or two sentences: what the epic is and why it is being decomposed.>

**Status legend**: planned · in-progress · done

| ID | Sub-feature | Intent | Scope boundary | Depends on | Status | Sub-spec |
|----|-------------|--------|----------------|-----------|--------|----------|
| R1 | <name>      | <one line> | <in / deferred> | —      | planned | — |
| R2 | <name>      | <one line> | <in / deferred> | R1     | planned | — |
| R3 | <name>      | <one line> | <in / deferred> | R1     | planned | — |
```

一旦子規格引用了 `ID` 欄位，就保持它不可變——它是可追溯性的錨點。當你建立每個子功能的規格目錄時，在 `Sub-spec` 欄位填入其路徑，並隨著工作進展更新 `Status`。

## 為每個子功能撰寫規格

有了路線圖後，使用正常的 Spec Kit 流程逐一處理條目——無需學習新東西：

1. 挑選下一個相依性已 `done`（或沒有相依性）的路線圖條目。
2. 只針對該切片執行 `/speckit.specify`，僅描述路線圖條目中的意圖與範圍。由於切片有明確邊界，其規格、計畫與任務都能遠低於上下文視窗上限。
3. 照常為該切片執行 `/speckit.plan`、`/speckit.tasks` 與 `/speckit.implement`。
4. 將路線圖條目標記為 `done`，再移到下一個。

每個切片都是完整、獨立的 Spec Kit 功能，擁有自己的 `spec.md`/`plan.md`/`tasks.md`。路線圖就是將它們串連起來的東西。

## 將子規格連結到路線圖

為了避免範圍與意圖在不同執行之間偏離，每份子規格都引用其路線圖條目，路線圖也反向連結——這是一種簡單、可搜尋、雙向的慣例：

- **子規格 → 路線圖。** 在子功能的 `spec.md` 中，在 `Input`／摘要行註明父路線圖與條目 id，例如：

  ```markdown
  **Input**: Parent roadmap: `specs/<epic>/roadmap.md` → entry **R3**. <feature description>
  ```

- **路線圖 → 子規格。** 在路線圖表格中，將條目的 `Sub-spec` 欄位設為子功能的目錄，例如 `specs/<epic>-part-3/`。

由於兩個方向都是純文字，你可以快速搜尋將任何子規格追溯回它在 epic 中的位置（並找到其同層級切片）——無需工具、無需中繼資料結構描述。

## 保持路線圖與子規格同步

路線圖是活文件。隨著你了解得更多，請保持它與子規格一致：

- **先改路線圖，再調和。** 當範圍變動時，先更新路線圖條目，再更新受影響的子規格。路線圖是 epic 如何拆分的真實來源。
- **尊重相依性與順序。** 如果某個切片相依於另一個切片，請先建置前置項目，並在相依的子規格中交叉引用，讓關係從兩邊都能看見。
- **當切片仍然過大時遞迴拆解。** 如果某個子功能大到無法在一個循環中規格化，就為它建立自己的路線圖並進一步拆解——同樣的作法可再往下一層。遞迴會增加額外成本，因此只深入到上下文問題實際需要的程度。

## 實際範例

假設 epic 是「**新增自助帳單入口網站」**——遠大到無法用單一循環完成。路線圖階段將它拆解為三個可獨立規格化的切片。

`specs/billing-portal/roadmap.md`：

```markdown
# Roadmap: Self-service billing portal

Let customers view invoices, manage payment methods, and change plans without
contacting support. Too large for one cycle, so it is split into independent slices.

**Status legend**: planned · in-progress · done

| ID | Sub-feature        | Intent                                   | Scope boundary                              | Depends on | Status  | Sub-spec |
|----|--------------------|------------------------------------------|---------------------------------------------|-----------|---------|----------|
| R1 | Invoice history    | Customers view and download past invoices | Read-only; no payment actions               | —         | done    | specs/billing-invoices/ |
| R2 | Payment methods    | Add, remove, and set a default card       | No plan changes; assumes invoices exist     | R1        | in-progress | specs/billing-payment-methods/ |
| R3 | Plan changes       | Upgrade/downgrade the subscription plan   | Uses R2's default payment method            | R1, R2    | planned | — |
```

然後逐一切片撰寫規格。例如，**R2** 子功能的 `spec.md` 開頭有反向引用：

```markdown
# Feature Specification: Billing — payment methods

**Input**: Parent roadmap: `specs/billing-portal/roadmap.md` → entry **R2**.
Let customers add, remove, and set a default payment method in the billing portal.
```

從這裡，讀者可以將 **R2** 追溯回路線圖，看出它相依於 **R1**（發票歷史，已 `done`），並看出 **R3**（方案變更）正在等待它。依序建置 R1、R2、R3，能讓每次執行保持小規模，同時路線圖保留了整個 epic 的形貌。

## 自動化（選用）

如果你希望自動化路線圖的擷取與一致性檢查，而非手動維護檔案，社群維護的 [Spec Roadmap 擴充功能](https://github.com/srobroek/speckit-roadmap)探索了這個方向。它是第三方擴充功能，並非必要——上述手動慣例本身就已足夠。
