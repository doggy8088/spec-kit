---
description: 建立規格並將其儲存在 spec.md。
---

## 使用者輸入

```text
$ARGUMENTS
```

## 大綱

1. **詢問使用者**功能目錄路徑（例如 `specs/my-feature`）。在取得之前不要繼續。

2. 建立目錄並寫入 `.specify/feature.json`：
   ```json
   { "feature_directory": "<feature_directory>" }
   ```

3. 依使用者輸入建立規格，並將其儲存在 `<feature_directory>/spec.md`。
   - 概覽、功能需求、使用者情境、成功標準
   - 每項需求都必須可測試
   - 對未指定的細節採用合理的預設值
