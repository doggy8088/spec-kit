---
description: "驗證目前分支是否符合功能分支命名慣例"
---

# 驗證功能分支

驗證目前的 Git 分支是否符合預期的功能分支命名慣例。

## 前置條件

- 執行 `git rev-parse --is-inside-work-tree 2>/dev/null`，檢查 Git 是否可用
- 若 Git 不可用，輸出警告並略過驗證：
  ```
  [specify] Warning: Git repository not detected; skipped branch validation
  ```

## 驗證規則

取得目前的分支名稱：

```bash
git rev-parse --abbrev-ref HEAD
```

分支名稱的最後一個路徑段必須以下列任一功能標記開頭：

1. **循序**：`[0-9]{3,}-`（例如 `001-feature-name`、`042-fix-bug`、`1000-big-feature`、`jdoe/web/008-guided-tour`）
2. **時間戳記**：`[0-9]{8}-[0-9]{6}-`（例如 `20260319-143022-feature-name`、`jdoe/web/20260319-143022-feature-name`）

## 執行

若位於功能分支（符合任一模式）：
- 輸出：`✓ On feature branch: <branch-name>`
- 檢查 `specs/` 下是否存在對應的規格目錄：
  - 循序分支：尋找 `specs/<prefix>-*`，其中 prefix 對應數字部分，不受分支命名空間前綴影響
  - 時間戳記分支：尋找 `specs/<prefix>-*`，其中 prefix 對應 `YYYYMMDD-HHMMSS` 部分，不受分支命名空間前綴影響
- 若規格目錄存在：`✓ Spec directory found: <path>`
- 若規格目錄不存在：`⚠ No spec directory found for prefix <prefix>`

若不在功能分支：
- 輸出：`✗ Not on a feature branch. Current branch: <branch-name>`
- 輸出：`Feature branches should be named like: 001-feature-name, 20260319-143022-feature-name, or <namespace>/001-feature-name`

## 優雅降級

若 Git 未安裝，或目錄不是 Git 儲存庫：
- 改檢查 `SPECIFY_FEATURE` 環境變數作為備援
- 若已設定，以命名模式驗證該值
- 若未設定，略過驗證並顯示警告
