# 社群 Friends

> [!NOTE]
> 此處列出的社群專案由各自作者獨立建立與維護。除非明確標示為 **first-party GitHub project**，否則皆未經 GitHub 審查、背書或支援。安裝前請先檢視其原始碼，並自行斟酌使用。

擴展、視覺化或以 Spec Kit 為基礎的社群專案：

- **[cc-spex](https://github.com/rhuss/cc-spex)** — Claude Code 外掛，在 Spec Kit 之上加入可組合的特性，並提供以 [Superpowers](https://github.com/obra/superpowers) 為基礎的品質關卡、規格／程式碼審查、git worktree 隔離，以及透過代理團隊進行的平行實作。

- **[VS Code Spec Kit Assistant](https://marketplace.visualstudio.com/items?itemName=rfsales.speckit-assistant)** — VS Code 擴充功能，為完整的 SDD 工作流程（constitution → specification → planning → tasks → implementation）提供視覺化協調器，具備階段狀態視覺化、互動式任務檢核清單、DAG 視覺化，並支援 Claude、Gemini、GitHub Copilot 與 OpenAI 後端。需要在 PATH 中提供 `specify` CLI。

- **[SpecKit Assistant](https://www.npmjs.com/package/speckit-assistant)** — 規格驅動開發（SDD）的視覺化協調器。將本機的規格、計畫與任務檢核清單與 AI 代理（Claude、Gemini、GitHub Copilot）連結。無需全域安裝，只要透過 `npx speckit-assistant` 執行即可。

- **[SpecKit Companion](https://marketplace.visualstudio.com/items?itemName=alfredoperez.speckit-companion)** — VS Code 擴充功能，為 Spec Kit 帶來視覺化 GUI。以豐富的 Markdown 檢視器瀏覽規格並可點選檔案參照、以圖片附件建立規格、就地（以 GitHub 風格審查方式）留言與精修每個步驟、透過視覺化階段步進器追蹤 SDD 工作流程進度，並管理憲章與範本等引導文件。

- **[cc-spec-kit](https://github.com/speckit-community/cc-spec-kit)** — 由社群維護的 Claude Code 與 GitHub Copilot CLI 外掛，透過外掛市集安裝 Spec Kit 技能。

- **[spectatui](https://github.com/tinesoft/spectatui)** — Spec Kit 的終端機 UI（TUI）儀表板，可追蹤功能、管理規格、整合、預設集、工作流程與擴充功能，並監控 AI 代理工作流程。可附加至既有的 AI 工作階段，或從終端機啟動新工作階段。支援鍵盤與滑鼠。支援淺色／深色主題。可自訂且注重效能。需要在 PATH 中提供 `specify` CLI。

- **[spec-kit-copilot](https://github.com/github/spec-kit-copilot)** — *First-party GitHub project。* GitHub Copilot **skills 外掛**，將 Spec Kit `specify` CLI 提供給 Copilot CLI 與 GitHub Copilot 應用程式中的 Copilot 代理使用。為每個 `specify` 命令群組提供專屬技能，包含 setup、init、check、extensions、presets、bundles、workflows、workflow steps 與 self-upgrade，讓使用者能以自然語言瀏覽並驅動整個 Spec Kit 生態系，由 Copilot 決定何時以及如何代為執行正確的 `specify` 命令。

- **[Spec Kit Workflow Cockpit](https://github.com/markuswondrak/spec-kit-workflow-cockpit)** — 在本機執行 Spec Kit 工作流程的終端機控制面板。以單一即時檢視取代零散的 CLI 流程：一眼掌握整個工作流程、逐節點追蹤進度、在人工審查關卡直接於終端機內閱讀與編輯功能文件，並從清楚呈現且需確認的選項中做出關卡決策。另提供 `cockpit-run-context` 技能，將互動式程式工作階段直接連結至目前的工作流程執行。

- **[Specstride](https://specstride.ai/)** — 獨立的實作協調器，讀取 Spec Kit 功能的 `tasks.md`，並將其 `spec.md`、`plan.md` 與合約作為唯讀脈絡使用。讓程式代理（Claude Code、Codex 或本機模型）一次執行一個任務階段。每個階段只有在另一個 LLM 審查者依驗收標準與程式碼核准其證據後才會前進。卡住的階段會獲得診斷與範圍縮小的重試。選擇性啟用的迴圈會從執行遙測中學習各階段設定，並還原任何讓情況變差的變更。

- **[Raaghu Spec Kit](https://marketplace.visualstudio.com/items?itemName=Waiin.raaghu-speckit)** — Raaghu Spec Kit 將規格驅動開發帶入 Azure DevOps。PM、BA 與 QA 可產生、審查與管理結構化規格、交付計畫、任務拆解與品質檢核清單，接著建立與精修 Azure Boards 工作項目，全部在專案內引導式的 AI 工作區中完成。支援 Azure DevOps Services 與 Azure DevOps Server（內部部署）。

- **[Entalpa](https://entalpa.com/spec-kit)** — 託管式網頁應用程式，從公開 GitHub 儲存庫讀取 `specs/<feature>/spec.md` 與 `tasks.md`，或從以 zip 或資料夾上傳的私有儲存庫讀取，並將各功能整合為一份目前的待辦清單：使用者故事、連結至故事且狀態取自 `tasks.md` 的 `FR-`／`SC-` 需求，以及以已回答問題形式呈現的釐清事項。後續功能會修訂其變更的故事，而不是新增副本。檢視結果無需帳號；保存或編輯則需要帳號。上傳內容在瀏覽器中讀取，僅傳送這些規格檔案、其路徑以及 zip 或資料夾名稱；無論何種方式，整合時都會將規格傳送給第三方 AI 服務。結果可匯出回 `specs/` 功能。
