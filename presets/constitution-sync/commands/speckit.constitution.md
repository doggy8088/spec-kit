---
description: 建立或更新專案憲章，然後將修訂後的指引傳播到相依範本與已安裝的命令檔案（選擇加入的範本同步）。
strategy: wrap
handoffs:
  - label: 建立規格
    agent: speckit.specify
    prompt: 根據更新後的憲章實作功能規格。我想要建立……
---

{CORE_TEMPLATE}

## 憲章範本同步

> **本區段就範本與命令的傳播而言，取代上方的「Scope Guard」。**
> 核心 Scope Guard 指出，相依範本與命令「不在此處修改」—
> 這個預設集有意解除該限制。當安裝這個預設集時，將修訂後的指引傳播到
> 專案自身的相依骨架與已安裝的命令檔案（如下所述）**即在
> 範圍內**。Scope Guard 的其他限制仍然適用：
> 不要實作功能、不要產生應用程式程式碼，也不要碰觸與
> 憲章／範本工作流程無關的產出物。

在你寫入上方更新後的憲章之後，執行一次一致性傳播，
讓相依產出物反映修訂後的原則：

1. 讀取 `.specify/templates/plan-template.md`，確保其中任何「Constitution Check」或規則都與
   更新後的原則一致。只有在你的團隊打算將具體的關卡文字作為已提交內容審查時，
   才在此處寫入具體文字；否則保留執行期指標
   `[Gates determined based on constitution file]`，讓 `/plan` 從即時
   憲章填入。
2. 讀取 `.specify/templates/spec-template.md`，核對範圍／需求的一致性 — 若
   憲章新增／移除了強制區段或限制，就加以更新。
3. 讀取 `.specify/templates/tasks-template.md`，確保任務分類反映新增或
   移除的原則驅動任務類型（例如可觀測性、版本管理、測試紀律）。
4. 讀取你所用代理的每個已安裝 Spec Kit 命令檔案（包括這個檔案）— 名為
   `speckit.*` 或 `speckit-*`（視代理而定，使用點或連字號），或以
   `speckit-<name>/SKILL.md` 形式佈置（適用於以技能為基礎的整合），例如位於 `.github/agents/`、
   `.github/skills/`、`.claude/skills/`，或你的代理對應的命令目錄 — 以確認
   在需要通用指引時，不再殘留過時的參照（僅限 CLAUDE 或其他代理專屬名稱）。**只有在命令檔案是專案本機檔案、且不受
   預設集或擴充功能管理時，才可手動編輯。**由解析堆疊組成的命令檔案（任何
   由預設集／擴充功能提供或包裝者）都必須透過堆疊重新產生 — **絕對不要**
   就地編輯它們，因為對帳（`specify integration use`、`specify integration
   upgrade`，或任何預設集／擴充功能安裝／移除）會覆蓋這些編輯。
5. 讀取任何執行期指引文件（例如 `README.md`、`docs/quickstart.md`，或代理專屬的
   指引檔案（如有）），並更新對已變更原則的參照。

接著，在 `.specify/memory/constitution.md` 頂部的 Sync Impact Report 中補上：

- 需要更新的範本（✅ 已更新／⚠ 待處理）及檔案路徑。

**不要直接編輯有版本、由預設集或擴充功能提供的範本或命令檔案。**這些
產出物由其套件擁有，並會在套件下一次更新或堆疊
對帳時重新組成 — 手動編輯會被覆蓋。將傳播限制在專案自身的
`.specify/templates/` 骨架，以及不受預設集或擴充功能管理的命令檔案。
