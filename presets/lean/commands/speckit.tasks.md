---
description: 建立實作所需的任務並將其儲存在 tasks.md。
---

## 使用者輸入

```text
$ARGUMENTS
```

## 大綱

1. 讀取 `.specify/feature.json` 以取得功能目錄路徑。

2. **載入脈絡**：`.specify/memory/constitution.md`、`<feature_directory>/spec.md` 與 `<feature_directory>/plan.md`。

3. 建立依相依性排序的實作任務，並將其儲存在 `<feature_directory>/tasks.md`。
   - 每個任務都使用檢核清單格式：`- [ ] [TaskID] Description with file path`
   - 依階段組織：設定、基礎建設、依優先順序排列的使用者故事、潤飾
