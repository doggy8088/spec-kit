# AGENTS.md

## 關於 Spec Kit 與 Specify

**GitHub Spec Kit** 是一套完整的工具組，用於實作規格驅動開發（Spec-Driven Development，SDD）——這是一種在實作之前先建立清晰規格的方法論。這套工具組包含範本、指令碼與工作流程，引導開發團隊以結構化的方式建構軟體。

**Specify CLI** 是用來以 Spec Kit 框架啟動專案的命令列介面。它會建立必要的目錄結構、範本與 AI 代理整合，以支援規格驅動開發工作流程。

這套工具組支援多種 AI 程式助理，讓團隊能使用自己偏好的工具，同時維持一致的專案結構與開發實務。

## 新增或更新 CLI 命令

在新增、更新或重新組織 Specify CLI 命令之前，請先閱讀
[Shared Command Application Architecture](design/shared.md) 與
[Specify CLI Command Architecture](design/cli.md)。這兩份文件定義了共用
操作的邊界、命令模組的命名方式、私有階段、巢狀命令
群組、註冊的歸屬權，以及對應的測試。

## 新增或更新 MCP 命令

在為 Specify 命令新增或變更 MCP 工具之前，請先閱讀
[Shared Command Application Architecture](design/shared.md) 與
[Specify MCP Command Architecture](design/mcp.md)。這兩份文件定義了共用
操作的邊界、型別化契約、明確的清單、副作用中繼資料、
本機 stdio 協定的邊界，以及對應的測試。

## 新增或更新代理整合

在新增或變更 AI 代理整合之前，請先閱讀
[Agent Integration Design](design/integration.md)。該文件涵蓋
交付途徑、輸出格式、註冊，以及安裝／解除安裝的歸屬權。

## 新增或更新工作流程步驟

在新增或變更工作流程步驟類型之前，請先閱讀
[Workflow Step Design](design/workflow-step.md)。該文件涵蓋註冊、
驗證、執行、恢復，以及已安裝的步驟套件。

## 測試可執行行為

在變更不經 LLM 就能執行或控制執行的程式碼或設定之前，請先閱讀
[Testing deterministic behavior](CONTRIBUTING.md#testing-deterministic-behavior)。
行為變更需要正向與負向的涵蓋範圍；錯誤修正需要修正前後的迴歸證據。

## PowerShell 相容性

儲存庫中的所有 PowerShell 指令碼，以及所有產生的 PowerShell
功能，都必須以 Windows 隨附的 Windows PowerShell 5.1 為目標。新增或變更 PowerShell 程式碼時，只能使用 Windows PowerShell 5.1 提供
的語法、cmdlet、參數與 .NET API。請考量
編碼與其他執行環境差異，保留與 Bash 和 Python 實作之間必要的行為
一致性，並為行為變更提供 Windows PowerShell
5.1 的驗證證據。

## 分支與代理貢獻

建立分支時，請遵循 [分支命名](CONTRIBUTING.md#branch-naming)。
在撰寫提交、開啟 PR 或發表審查意見之前，請先閱讀
[由代理撰寫的 Git 與審查活動](CONTRIBUTING.md#agent-authored-git-and-review-activity)。
由代理撰寫的提交，以及 AI 產生的 PR 與留言，各自都需要
揭露；僅在 PR 內文揭露並不足以涵蓋後續活動。

## 其他貢獻指引

對於上述未涵蓋的貢獻或儲存庫工作流程問題，或當
適用的指引不明確時，請先閱讀 [CONTRIBUTING.md](CONTRIBUTING.md)
再行動。

## 常見陷阱

- **在錯誤的環境中執行測試：** 請在這個
  worktree 自己的虛擬環境中執行測試套件（先 `uv sync --extra test`，再
  `.venv/bin/python -m pytest`）。直接執行 `uv run pytest` 可能會挑到
  另一個 worktree 的可編輯安裝，導致無法匯入新的子套件。
