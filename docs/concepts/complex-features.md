# 處理複雜功能

大型或複雜的功能通常能順利通過 `/speckit.specify`、`/speckit.plan` 與 `/speckit.tasks`，卻在實作階段逐漸失控。在漫長的 `/speckit.implement` 執行過程中，代理可能開始遺失計畫脈絡、忽略任務或產生幻覺——通常就發生在上下文壓縮被觸發之前或之後。

根本原因是上下文視窗耗盡。當單次實作試圖將整個功能都納入上下文時，模型會隨著視窗填滿而退化。解法是為每次執行劃定範圍，讓它始終遠低於上下文上限。

`/speckit.implement` 命令接受自由格式的使用者輸入，代理在繼續之前必須加以考量。這表示你無需變更任何工具，就能為每次執行劃定範圍。

## 選項 1：限制每次呼叫執行的任務數量

不要讓 `/speckit.implement` 一次跑完所有任務，而是讓它提早停止：

```text
/speckit.implement only execute tasks T001-T010, then stop and report progress
```

或依階段劃定範圍：

```text
/speckit.implement only execute the Setup phase, then stop
```

由於已完成的任務會在 `tasks.md` 中標記為 `[X]`，下一次 `/speckit.implement` 呼叫會從你中斷的位置接續。這能讓每次執行都遠低於上下文上限。

## 選項 2：指示代理使用子代理

如果你的程式代理支援子代理（例如 GitHub Copilot CLI 或 VS Code 的 GitHub Copilot 擴充功能），你可以指示 `/speckit.implement` 將個別任務委派出去：

```text
/speckit.implement delegate each parallel [P] task to a sub-agent
```

每個子代理會取得聚焦的上下文——一項任務加上相關的計畫摘錄——而非完整的功能上下文，因此主工作階段永遠不會觸發壓縮。

## 選項 3：兩者並用

對於非常大型的功能，可同時結合範圍劃定與委派：

```text
/speckit.implement execute only the Core phase, delegate [P] tasks to sub-agents
```

## 選項 4：將功能拆解為較小的規格

當單一階段就足以壓垮上下文時，請將功能拆解為可獨立規格化的子功能。每個子功能都有自己的 `spec.md`、`plan.md` 與 `tasks.md`，並走完各自的 specify/plan/tasks/implement 循環。

這就是「規格的規格」作法：第一輪先將龐大的功能拆解為較小、自成一體的規格，每份規格都能在不壓垮模型的前提下實作。此作法的額外成本最高，因此只應保留給以其他方式都難以處理的功能。

完整程序請參閱[規格的規格](spec-of-specs.md)——如何執行路線圖階段、如何組織路線圖成品、如何將子規格連結回路線圖，以及一個實際範例。

## 該選擇哪種作法

| 作法 | 最適用於 |
| --- | --- |
| 限制為 N 項任務或一個階段 | 任何代理；最簡單；無需子代理支援 |
| 子代理委派 | 支援子代理的代理；最大化平行處理 |
| 結合範圍劃定與委派 | 在支援子代理的代理上處理大型功能；兼顧兩者 |
| 拆解為較小的規格 | 當單一階段就足以壓垮上下文時 |

在大多數情況下，限制每次執行的任務範圍是最簡單的解法。當你的代理支援子代理且你想要平行處理時，採用子代理委派；只有當單一階段仍然過大、無法在一次執行中處理時，才拆解為較小的規格。
