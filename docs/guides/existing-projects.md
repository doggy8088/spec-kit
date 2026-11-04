# 在既有專案中採用 Spec Kit

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

後續步驟示範為一項有邊界的功能採用 **SDD**。若你的第一項任務是修復，初始化後可以改依[錯誤修復快速入門](bugfix.md)；若要評估一項提議，則使用[構想評估快速入門](assessment.md)。這兩套流程都不需要先完成下面的 SDD 步驟。

用對儲存庫而言已經成立、或團隊已明確同意採用的原則，執行 `/speckit.constitution`：

```text
/speckit.constitution Preserve public API compatibility. Follow the existing
service boundaries. Every database migration must include a rollback plan.
Run the repository's established unit and integration test suites.
```

以儲存庫的 README、架構決策、貢獻指南與 CI 設定作為證據。不要只為了填滿憲章範本就編造標準。憲章會治理後續的計畫與分析，不切實際的規則只會製造雜訊，而不是有用的限制。

## 3. 選擇一項有邊界的第一項變更

從一項可獨立審查的功能或現代化切片開始。不要把「記錄整個既有系統」當成第一項功能，除非那份盤點本身就是預期的交付物。

同時描述要求的成果，以及必須保持完整的相容性邊界：

```text
/speckit.specify Add CSV export to the existing orders page. Preserve current
filters and authorization behavior. Export only the rows visible to the signed-in
user, and do not change the existing JSON API response.
```

程式碼庫仍是實作脈絡。新的 `spec.md` 定義的是你打算做的變更，而不是對每一項既有行為的事後規格。

## 4. 對照儲存庫進行計畫

繼續走一般的工作流程：

1. 執行 `/speckit.clarify`，釐清不確定的行為與相容性要求。
2. 執行 `/speckit.plan`，並驗證建議的設計有重複使用既有架構、相依性與測試慣例。
3. 執行 `/speckit.tasks`，再執行 `/speckit.analyze`，在實作前檢查一致性。
4. 執行 `/speckit.implement`，並一起檢視程式碼與產出物的變更。
5. 執行 `/speckit.converge`，找出剩餘缺口。若它加入了任務，就重複實作與收斂，直到功能完成。

命令詳情與選用的品質關卡，請見[快速入門指南](../quickstart.md)與[代理式 SDD 參考](../reference/agentic-sdd.md)。

## 5. 決定規格如何演進

第一項變更之後，商定團隊將如何維護已完成的功能產出物：

- 把每個功能目錄保留為不可變的歷史紀錄。
- 把 `spec.md` 維護為活的契約，並重新產生下游產出物。
- 允許發現從程式碼、任務或計畫回流，再對帳整套產出物。

[規格持久化模型](../concepts/spec-persistence.md)頁面比較了這些選擇。[演進規格指南](evolving-specs.md)提供每個模型的維護循環。

## 既有專案範例

[社群導覽](../community/walkthroughs.md)包含跨 .NET、Java 與 Go／React 程式碼庫的棕地範例。用於架構探索與棕地初始化的社群擴充功能，列在[擴充功能型錄](../community/extensions.md)。
