---
description: "偵測 Git 遠端 URL，供 GitHub 整合使用"
---

# 偵測 Git 遠端 URL

偵測 Git 遠端 URL，以便與 GitHub 服務整合（例如建立 issue）。

## 前置條件

- 執行 `git rev-parse --is-inside-work-tree 2>/dev/null`，檢查 Git 是否可用
- 若 Git 不可用，輸出警告並回傳空白：
  ```
  [specify] Warning: Git repository not detected; cannot determine remote URL
  ```

## 執行

執行下列命令取得遠端 URL：

```bash
git config --get remote.origin.url
```

## 輸出

解析遠端 URL 並判斷：

1. **儲存庫擁有者**：從 URL 擷取（例如從 `https://github.com/github/spec-kit.git` 擷取 `github`）
2. **儲存庫名稱**：從 URL 擷取（例如從 `https://github.com/github/spec-kit.git` 擷取 `spec-kit`）
3. **是否為 GitHub**：遠端是否指向 GitHub 儲存庫

支援的 URL 格式：
- HTTPS：`https://github.com/<owner>/<repo>.git`
- SSH：`git@github.com:<owner>/<repo>.git`

> [!CAUTION]
> 只有當遠端 URL 確實指向 github.com 時，才回報為 GitHub 儲存庫。
> 若 URL 格式不符，不要假設遠端是 GitHub。

## 優雅降級

若 Git 未安裝、目錄不是 Git 儲存庫，或未設定遠端：
- 回傳空白結果
- 不要出錯——其他工作流程應在沒有 Git 遠端資訊的情況下繼續
