# 如何在既有專案中採用 Spec Kit

你不必先從規格重建既有系統，才能使用 Spec Kit。直接在原地初始化儲存庫，記錄重要的規則，並把工作流程用在下一項有邊界的變更上。

## 1. 從可審查的基線開始

初始化之前，先提交或暫存既有工作，並為這次採用建立分支。這樣每個產生的檔案都能在一般的程式碼審查中看見。

為你使用的程式代理選擇[整合鍵](../integrations/index.md)。接著從儲存庫根目錄執行命令：

```bash
specify init --here --force --integration <key>
```

`--here` 以目前目錄為目標。`--force` 允許在非空目錄中初始化，並可能取代受管理路徑上衝突的檔案，所以請只在建立可審查的基線之後使用。它不會刪除應用程式的其餘部分。

繼續之前，先檢視產生的差異。初始化會加入共用的 `.specify/` 專案檔案，以及你所選整合所需的命令或 skill 檔案。它不會改寫你的應用程式，也不會為既有行為推斷規格。

> [!NOTE]
> Git 初始化與功能分支是選用的，由 **git** 擴充功能管理。若你想要那套工作流程，用 `specify extension add git` 加入它。

## 2. 記錄專案護欄

其餘步驟以一個範圍有限的功能為例，說明如何採用 **SDD**。如果你的第一項任務是修復問題，可以在初始化後改走[錯誤修正快速入門](../guides/bugfix.md)；若要評估提案，則使用[構想評估快速入門](../guides/assessment.md)。這兩種流程都不需要先完成下面的 SDD 步驟。

以下範例使用 GitHub Copilot 的預設 skills 模式（`/speckit-*`）。請在代理的對話中逐一呼叫各項 skill，不要在終端機中執行，並在進入下一步之前先檢閱結果。

使用 `/speckit-constitution`，帶入儲存庫中已經成立、或團隊已明確同意採用的原則：

```text
/speckit-constitution Preserve public API compatibility. Follow the existing
service boundaries. Every database migration must include a rollback plan.
Run the repository's established unit and integration test suites.
```

以儲存庫的 README、架構決策、貢獻指南與 CI 設定作為證據。不要只為了填滿憲章範本就編造標準。憲章會治理後續的計畫與分析，不切實際的規則只會製造雜訊，而不是有用的限制。

## 3. 選擇一項有邊界的第一項變更

從一項可獨立審查的功能或現代化切片開始。不要把「記錄整個既有系統」當成第一項功能，除非那份盤點本身就是預期的交付物。

同時描述要求的成果，以及必須保持完整的相容性邊界：

```text
/speckit-specify Add CSV export to the existing orders page. Preserve current
filters and authorization behavior. Export only the rows visible to the signed-in
user, and do not change the existing JSON API response.
```

程式碼庫仍是實作脈絡。新的 `spec.md` 定義的是你打算做的變更，而不是對每一項既有行為的事後規格。

## 4. 對照儲存庫進行計畫

繼續走一般的工作流程：

1. 執行 `/speckit-clarify`，釐清不確定的行為與相容性需求。
2. 執行 `/speckit-plan`，確認提議的設計重用了既有的架構、相依性與測試慣例。
3. 執行 `/speckit-tasks`，再執行 `/speckit-analyze`，在實作前檢查一致性。
4. 執行 `/speckit-implement`，並一起檢閱程式碼與產出物的變更。
5. 執行 `/speckit-converge` 找出尚存的落差。如果它補上了任務，請重複實作與收斂，直到功能完成。

命令詳情與選用的品質關卡，請見[快速入門指南](../quickstart.md)與[代理式 SDD 參考](../reference/agentic-sdd.md)。

## 5. 決定規格如何演進

完成第一次變更後，先就團隊要保留哪些功能產出物、以及如何維護保留的產出物達成共識。[保存規格](persisting-specs.md)頁面比較了這些選擇，包括在僅保留憲章的模型下退役已完成的功能產出物。交付後續變更時，請使用[演進規格指南](evolving-specs.md)。

## 既有專案範例

[社群導覽](../community/walkthroughs.md)包含跨 .NET、Java 與 Go／React 程式碼庫的棕地範例。用於架構探索與棕地初始化的社群擴充功能，列在[擴充功能型錄](../community/extensions.md)。

## 另請參閱

- [命令呼叫](../integrations/cli.md#命令呼叫方式) — 其他程式代理與整合模式的語法。
