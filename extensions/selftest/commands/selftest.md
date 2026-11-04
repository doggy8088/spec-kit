---
description: "驗證型錄中某個擴充功能的生命週期。"
---

# 擴充功能自我測試：`$ARGUMENTS`

本命令執行自我測試，模擬開發者使用 `$ARGUMENTS` 擴充功能的體驗。

## 目標

驗證該擴充功能的端對端生命週期（探索、安裝、註冊）：`$ARGUMENTS`。
若 `$ARGUMENTS` 為空白，你必須告知使用者提供擴充功能名稱，例如：`/speckit.selftest.extension linear`。

## 步驟

### 步驟 1：驗證型錄探索

檢查該擴充功能是否存在於 Spec Kit 型錄中。
執行這個命令，並確認它成功完成，且回傳的擴充功能 ID 與 `$ARGUMENTS` 完全相符。若命令失敗，或 ID 與 `$ARGUMENTS` 不符，則測試失敗。

```bash
specify extension info "$ARGUMENTS"
```

### 步驟 2：模擬安裝

先嘗試直接將擴充功能加入目前工作區設定。若型錄將該擴充功能標示為 `install_allowed: false`（僅供探索），此步驟*預期*會失敗。

```bash
specify extension add "$ARGUMENTS"
```

接著，從型錄下載 URL 安裝該擴充功能以模擬加入流程，這應能繞過該限制。
從型錄詮釋資料取得擴充功能的 `download_url`（例如透過型錄資訊命令或 UI），然後執行：

```bash
specify extension add "$ARGUMENTS" --from "<download_url>"
```

### 步驟 3：驗證註冊

`add` 命令完成後，檢查專案設定以驗證安裝結果。
使用終端機工具（例如 `cat`）確認下列檔案包含 `$ARGUMENTS` 的記錄。

```bash
cat .specify/extensions/.registry/$ARGUMENTS.json
```

### 步驟 4：驗證報告

分析這三個步驟的標準輸出。
產生終端機風格的測試輸出格式，詳述探索、安裝與註冊的結果。直接將結果回傳給使用者。

輸出格式範例：
```text
============================= test session starts ==============================
collected 3 items

test_selftest_discovery.py::test_catalog_search [PASS/FAIL]
  Details: [Provide execution result of specify extension search]

test_selftest_installation.py::test_extension_add [PASS/FAIL]
  Details: [Provide execution result of specify extension add]

test_selftest_registration.py::test_config_verification [PASS/FAIL]
  Details: [Provide execution result of registry record verification]

============================== [X] passed in ... ==============================
```
