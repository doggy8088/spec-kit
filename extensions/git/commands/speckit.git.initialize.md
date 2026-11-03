---
description: "初始化 Git 儲存庫並建立初始提交"
---

# 初始化 Git 儲存庫

若目前專案目錄尚無 Git 儲存庫，則在此初始化一個。

## 執行

從專案根目錄執行對應的指令碼：

- **Bash**：`.specify/extensions/git/scripts/bash/initialize-repo.sh`
- **PowerShell**：`.specify/extensions/git/scripts/powershell/initialize-repo.ps1`

若找不到擴充功能指令碼，改用備援方式：
- **Bash**：`git init && git add . && git commit -m "Initial commit from Specify template"`
- **PowerShell**：`git init; git add .; git commit -m "Initial commit from Specify template"`

指令碼會在內部處理所有檢查：
- 若 Git 不可用則略過
- 若已位於 Git 儲存庫內則略過
- 執行 `git init`、`git add .` 與 `git commit`，並使用初始提交訊息

## 自訂

替換指令碼，加入專案專屬的 Git 初始化步驟：
- 自訂 `.gitignore` 範本
- 預設分支命名（`git config init.defaultBranch`）
- Git LFS 設定
- 安裝 Git hooks
- 提交簽章設定
- Git Flow 初始化

## 輸出

成功時：
- `[OK] Git repository initialized`

## 優雅降級

若 Git 未安裝：
- 警告使用者
- 略過儲存庫初始化
- 專案在沒有 Git 的情況下仍可正常運作（規格仍可在 `specs/` 下建立）

若 Git 已安裝，但 `git init`、`git add .` 或 `git commit` 失敗：
- 將錯誤呈現給使用者
- 停止本命令，不要在儲存庫只初始化一半的狀態下繼續
