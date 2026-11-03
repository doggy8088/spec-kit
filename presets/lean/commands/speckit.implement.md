---
description: 透過處理 tasks.md 中的所有任務來執行實作計畫。
---

## 使用者輸入

```text
$ARGUMENTS
```

## 大綱

1. 讀取 `.specify/feature.json` 以取得功能目錄路徑。

2. **載入脈絡**：`.specify/memory/constitution.md`、`<feature_directory>/spec.md`、`<feature_directory>/plan.md` 與 `<feature_directory>/tasks.md`。

3. **依序執行任務**：
   - 完成每個任務後再進行下一個
   - 在 `<feature_directory>/tasks.md` 中將已完成的任務由 `- [ ]` 改為 `- [x]` 來標記
   - 失敗時中止並回報問題

4. **驗證**：確認所有任務都已完成，且實作成果符合規格。
