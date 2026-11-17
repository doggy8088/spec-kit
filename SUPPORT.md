# 支援

## 如何取得協助

在建立新的議題之前，請先搜尋既有的[議題](https://github.com/github/spec-kit/issues)與[討論](https://github.com/github/spec-kit/discussions)，以避免重複。

- 參閱 [README](./README.md) 取得入門說明與疑難排解小提示
- 查看[完整指南](./spec-driven.md)，取得規格驅動開發流程的詳細文件
- 在 [GitHub Discussions](https://github.com/github/spec-kit/discussions) 提問有關使用 Spec Kit 或規格驅動開發方法論的問題
- 開啟 [GitHub 議題](https://github.com/github/spec-kit/issues/new) 回報錯誤與提出功能請求

## 專案狀態

**Spec Kit** 正在積極開發中，由 GitHub 員工與社群共同維護。我們會在時間允許的範圍內，盡力回應支援、功能請求與社群問題。

## Python 版本支援

Python 相容性、CI 覆蓋範圍與迴歸修正，均在維護者時間允許的範圍內盡力維護。本政策不保證相容性、修正，也不保證回應或解決的時程。

Spec Kit 的最低 Python 版本由 [`pyproject.toml`](./pyproject.toml) 中的 `requires-python` 宣告。支援並不表示每次變更都會測試所有受支援的 Python 與作業系統組合：

| Python 版本 | 例行 CI（拉取請求與推送至 `main`） | 每週排程與手動 CI（`workflow_dispatch`） |
| --- | --- | --- |
| 最低支援版本（3.11） | Linux、Windows、macOS | Linux、Windows、macOS |
| 錯誤修正支援的穩定版本（3.14、3.15） | Linux、Windows、macOS | Linux、Windows、macOS |
| 其他受支援的穩定版本 | 不執行 | Linux、Windows、macOS |

這是在 CI 成本與相容性覆蓋之間取得平衡。最低支援版本是我們在三個平台上的基準，錯誤修正支援的穩定版本亦然。完整的 Python 3.11 至 3.15 矩陣每週執行一次，也可在手動觸發時執行。舊版受支援版本上的迴歸問題，會在透過 CI 或使用者回報發現時視需要處理，而不會針對假設性的問題主動修正。實際測試的版本設定於[測試與 Lint Python 工作流程](./.github/workflows/test.yml)中。

[Python 開發者指南版本狀態](https://devguide.python.org/versions/)提供各版本目前的上游生命週期狀態。對於僅處於安全性支援階段的分支，核心 Python 專案不再發佈新的二進位版本，不過仍可能發佈僅含原始碼的安全性版本。這並不表示這些版本不受支援，也不表示第三方發行者無法提供二進位版本。

當最低支援的 Python 版本到達上游生命週期終止時，請將基準與最低需求一併推進至下一個受支援的版本，並從完整矩陣中移除已終止的版本。

## GitHub 支援政策

本專案的支援僅限於上述列出的資源。
