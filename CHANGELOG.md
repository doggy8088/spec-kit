# 變更記錄

<!-- 在此註解下方插入新的變更記錄 -->

## [1.2.6] - 2026-11-02

### 變更

- feat(droid)：新增 --no-model-invocation 整合選項 (#5116)
- fix(extensions)：讓 extension add 的名稱在搭配 --from 時可省略 (#5197)
- fix(extensions)：略過非 UTF-8 的型錄回應 (#5196)
- feat：新增 `specify workflow definition`，支援執行範圍限定的定義 (#4912)
- fix(integrations)：在 init --force 與切換復原後重新整理資訊清單雜湊 (#5193)
- fix(workflows)：停止將 "None" 作為命令步驟參數派送 (#5016)
- feat(workflows)：新增可選擇啟用的嚴格 shell 執行模式 (#5181)
- chore(deps)：升級 DavidAnson/markdownlint-cli2-action (#5191)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#5189)
- fix：拒絕以符號連結建立的整合狀態 (#5176)
- fix：拒絕擴充功能 ID 尾端帶有換行字元 (#5186)
- fix：拒絕預設集 ID 尾端帶有換行字元 (#5188)
- fix(templates)：讓 spec.md 從組合後的 spec-template 開始產生 (#5187)
- docs：將擴充功能 API 參考移入文件 (#5174)
- 將 iSAQB Architecture Governance 預設集更新至 v0.2.5 (#5183)
- fix：拒絕不安全的自我升級安裝程式路徑 (#5172)
- fix(bundles)：當 bundle.yml 或 README.md 為符號連結時拒絕建置 (#5169)
- docs(assess)：釐清 README 的呼叫指引 (#5068)
- fix(integrations)：在切換與使用時於預設集註冊後重新整理資訊清單雜湊 (#5145)
- chore：發行 1.2.5，開始 1.2.6.dev0 開發 (#5167)

## [1.2.5] - 2026-10-28

### 變更

- docs：在文件站發佈擴充功能開發指南 (#5166)
- docs：在文件站發佈擴充功能總覽與導覽 (#5165)
- fix(extensions)：從 extension.yml 載入頂層預設值 (#5164)
- fix(bundles)：拒絕缺少 id 的整合對應 (#5161)
- docs：在文件站發佈擴充功能發佈指南 (#5163)
- feat(workflows)：透過 MCP 公開已安裝工作流程清單 (#5115)
- fix(extensions)：拒絕非字串的 hook 命令 (#5146)
- fix(workflows)：在封存更新中接受等價的版本寫法 (#5155)
- 將 Domain Spec Maintenance 擴充功能加入社群型錄 (#5162)
- 將 Architecture Governance 預設集更新至 v0.6.5 (#5153)
- 將 Quality Gates (Enforcement Layer) 擴充功能更新至 v0.5.0 (#5151)
- 將 SFSpeckit — Salesforce Spec-Driven Development 更新至 v2.0.1 (#5154)
- docs(workflows)：修正篩選後筆數比對的指引 (#5148)
- fix：驗證收集到的擴充功能事件 (#5133)
- test(workflows)：固定尚未測試的工作流程運算式行為 (#5130)
- fix(presets)：將非對應型別的命令 frontmatter 視為空 (#5125)
- fix(workflows)：將無法解碼的 shell 輸出視為步驟失敗處理 (#5064)
- fix(vibe)：保留跟在受管理 hook 區塊後面的使用者留言 (#5109)
- [extension] 將 Shared Knowledge 擴充功能加入社群型錄 (#5140)
- chore：發行 1.2.4，開始 1.2.5.dev0 開發 (#5142)

## [1.2.4] - 2026-10-27

### 變更

- 將 Secure Development Assurance Governance 預設集更新至 v0.1.8 (#5139)
- feat(bundles)：允許套件組參照其他套件組 (#5067)
- fix：當 .extensionignore 或 .presetignore 不是一般檔案時，回報為驗證錯誤 (#5131)
- fix(presets)：正確歸屬帶有 overrides 前綴名稱的核心範本 (#5129)
- ci：自動選取 pytest 工作行程數量 (#5132)
- feat(vibe)：新增 --no-model-invocation 整合選項 (#5119)
- refactor(workflows)：將運算式求值器拆分為套件 (#5114)
- fix：讓套件組步驟的重新整理復原具備交易性 (#4827)
- 將 Security Governance 預設集更新至 v0.7.4 (#5128)
- 將 Quality Gates (Enforcement Layer) 擴充功能更新至 v0.4.2 (#5127)
- 將 Product Spec Extension 更新至 v2.1.0 (#5126)
- 修正大寫 .ZIP 封存檔的本機套件組安裝 (#5106)
- fix：重新初始化時保留功能編號 (#5101)
- fix：當覆寫未指定 events 時保留事件 hooks (#5102)
- feat(auth)：支援 GitHub CLI 憑證 (#4960)
- fix(integrations)：透過 --task 傳遞 Junie 派送提示詞 (#5065)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#5066)
- 將 CSDD — Controlled Spec-Driven Development 擴充功能加入社群型錄 (#5062)
- 將 Entalpa 加入 Community Friends (#4993)
- chore：發行 1.2.3，開始 1.2.4.dev0 開發 (#5063)

## [1.2.3] - 2026-10-22

### 變更

- Feat/4913 workflow mcp inventory (#5054)
- docs：修正內建工作流程步驟的來源路徑 (#5059)
- fix(events)：清理時保留派送器的所有權 (#5055)
- feat：新增 .presetignore 支援 (#5020)
- fix(scripts)：將 Python 輔助程式的 --json 輸出寫為 ASCII (#5048)
- 將 Linear Weave 擴充功能更新至 v1.0.2 (#5049)
- fix(events)：保留無主的 Vibe hooks 檔案 (#4646)
- ci：以兩個工作行程與更快的 fixture 關閉縮短測試執行時間 (#5051)
- fix(powershell)：將帶括號的功能路徑視為常值處理 (#4970)
- fix(cli)：讓整合指引與可用輸出一致 (#5041)
- fix(integrations)：將 Pi 的 JSON 派送對應至 --mode json (#5043)
- docs：整理各代理專屬的整合文件 (#5034)
- feat(integration)：新增 none 選項，僅提供共用鷹架 (#5030)
- fix(extensions)：移除前先拒絕格式錯誤的型錄條目 (#5033)
- fix(integrations)：將 Kimi Code 的 JSON 派送對應至 --output-format stream-json (#5031)
- docs：精簡 README 上手與流程指南 (#5029)
- docs：區分擴充功能事件與 hooks (#5026)
- fix(workflows)：讓整數型數字輸入保持精確，不再四捨五入 (#5027)
- docs：說明在 specify init 前如何取代舊版安裝 (#5004)
- chore：發行 1.2.2，開始 1.2.3.dev0 開發 (#5024)

## [1.2.2] - 2026-10-19

### 變更

- 將 SpecKit Grill Me 擴充功能更新至 v1.0.2 (#5023)
- fix(workflows)：在 --json 模式下回報因步驟錯誤而失敗的執行 (#5015)
- docs：將升級指南的 Copilot 檢查指向 .github/skills (#5010)
- fix(events)：當沒有任何自有項目時，不更動 JSON hook 設定 (#5017)
- fix(extensions)：擴充功能更新時為新設定範本建立鷹架 (#5011)
- fix(integrations)：從 ZCode 派送中移除不支援的 --model 旗標 (#5009)
- fix(bundles)：在驗證時拒絕非正數的預設集與擴充功能優先順序 (#5012)
- fix(integrations)：在切換解除安裝前先驗證必要選項 (#5008)
- fix(presets)：移除前先拒絕格式錯誤的型錄條目 (#4992)
- 說明已實作的擴充功能架構 (#4978)
- fix(bundles)：重複執行 bundle init 時不重新整理已安裝元件 (#4963)
- chore(deps)：將 actions/download-artifact 從 8.0.1 升級至 8.0.2 (#4989)
- chore(deps)：將 actions/setup-node 從 7.0.0 升級至 7.1.0 (#4987)
- 將 Applied Epistemic Engineering 擴充功能更新至 v1.5.2 (#5000)
- 將 DocGuard — CDD Enforcement 更新至 v0.45.1 (#5001)
- 將 Evaluator Contract 擴充功能更新至 v1.1.2 (#4999)
- 將 Applied Epistemic Engineering 擴充功能更新至 v1.5.1 (#4995)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#4985)
- docs：定義共用型錄合約 (#4977)
- chore：發行 1.2.1，開始 1.2.2.dev0 開發 (#4996)

## [1.2.1] - 2026-10-16

### 變更

- docs：新增型錄參考文件 (#4976)
- 將 Applied Epistemic Engineering 擴充功能更新至 v1.5.0 (#4982)
- 將 Evaluator Contract 擴充功能更新至 v1.1.1 (#4980)
- test(integrations)：描繪交付邊界特徵 (#4975)
- fix(extensions)：依使用中代理註冊的方式列出命令 (#4964)
- feat(workflows)：為命令與提示詞步驟新增可選擇啟用的輸出擷取 (#4957)
- docs：在 README 新增能力對照表 (#4974)
- docs：以 Windows PowerShell 5.1 為目標 (#4973)
- docs(mcp)：記錄第一級版本與成品工具 (#4969)
- fix(workflows)：更新前先載入自訂步驟 (#4768)
- 將 gh-address-cr 擴充功能加入社群型錄 (#4971)
- [bug-fix] 修正 missing-plan-template：拒絕空的計畫設定 (#4962)
- fix(powershell)：在常值功能路徑中保留計畫 (#4956)
- fix(extensions)：移除最後一個條目時刪除型錄設定 (#4909)
- fix(integrations)：解除安裝整合時一併移動擴充功能成品 (#4911)
- fix(integrations)：為 docker-agent 與 junie 顯示帶連字號的命令名稱 (#4910)
- 將 Reconcile Extension 更新至 v1.3.1 (#4950)
- docs：新增韓文（한국어）README (#4939)
- docs：區分擴充功能調和與核心 SDD (#4948)
- chore：發行 1.2.0，開始 1.2.1.dev0 開發 (#4949)

## [1.2.0] - 2026-10-13

### 變更

- fix：說明社群投稿標題不一致的情形 (#4946)
- fix(workflows)：限制工作流程與步驟型錄快取的寫入範圍 (#4931)
- docs：釐清交付與交付後規格持久化的差異 (#4945)
- fix(bundles)：允許較新的封裝修補版本並給予警告 (#4942)
- 將 Applied Epistemic Engineering 擴充功能更新至 v1.4.0 (#4941)
- 將 Applied Epistemic Engineering 擴充功能更新至 v1.3.0 (#4936)
- 在命令邊界持久化專案符號連結政策 (#4934)
- [extension] 將 DocGuard — CDD Enforcement 擴充功能更新至 v0.44.3 (#4927)
- fix(workflows)：當左側已決定結果時，略過 and/or 的右側 (#4923)
- 將 OpenProject 預設集更新至 v1.0.3 (#4928)
- fix：將 get_speckit_version() 的例外範圍從 Exception 縮小為特定型別 (#3917)
- 將 adrkit 擴充功能更新至 v0.1.5 (#4932)
- 將 OpenProject Integration 擴充功能更新至 v0.2.0 (#4929)
- feat(claude)：新增 --no-model-invocation 整合選項 (#4919)
- 新增內建 GitHub 工作流程步驟 (#4905)
- 新增具範圍限定的 FileHelper 基礎，作為檔案系統政策依據 (#4908)
- feat：新增由維護者觸發的 PR 說明評估 (#4902)
- 將 Architecture Governance 預設集更新至 v0.6.2 (#4907)
- 將 Security Governance 預設集更新至 v0.7.1 (#4903)
- chore：發行 1.1.3，開始 1.1.4.dev0 開發 (#4904)


## [1.1.3] - 2026-10-09

### 變更

- 將 Intake Sequencing Governance 預設集更新至 v0.2.8 (#4900)
- feat(bundles)：調和精確的元件釘選與版本衝突 (#4844)
- feat(workflows)：以統一執行樹組合工作流程 (#4764)
- [extension] 將 Applied Epistemic Engineering 擴充功能更新至 v1.2.0 (#4895)
- 將 Intake Review Governance 預設集更新至 v0.2.4 (#4894)
- 將 Epic 擴充功能加入社群型錄 (#4896)
- feat：自動化社群工作流程步驟投稿 (#4873)
- 將 OpenProject Integration 擴充功能加入社群型錄 (#4893)
- 將 OpenProject Work Packages 預設集加入社群型錄 (#4897)
- 將 Verified Codebase Context 預設集更新至 v1.1.0 (#4898)
- feat：支援透過型錄安裝的外部代理配接器 (#4862)
- feat(mcp)：新增成品資訊配接器 (#4885)
- 為 bug 工作流程新增生命週期 hooks (#4878)
- refactor(artifact)：抽出 info 作業 (#4882)
- 棄用核心 taskstoissues 命令 (#4879)
- [extension] 將 Quality Gates (Enforcement Layer) 擴充功能更新至 v0.4.1 (#4880)
- docs：定義整合交付與設計審查邊界 (#4881)
- fix(workflows)：讓非 ASCII 文字在執行成品中保持可讀 (#4877)
- community：新增 decision v0.9.0 工作流程步驟型錄條目 (#4872)
- chore：發行 1.1.2，開始 1.1.3.dev0 開發 (#4871)

## [1.1.2] - 2026-10-07

### 變更

- feat(mcp)：新增第一級成品清單工具 (#4867)
- fix(workflows)：移除在所列索引處顯示的型錄來源 (#4870)
- fix(bundler)：比照標準讀取器解析使用中的整合 (#4541)
- fix(workflows)：中斷的 gate 提示不得核准該 gate (#4529)
- [preset] 將 Intake Authoring Governance 預設集更新至 v0.3.7 (#4838)
- fix(workflows)：在 'workflow resolve' 輸出中說明同優先順序時的平局裁決方式 (#4542)
- feat：為 preset info 與 extension info 新增 --json (#4833)
- feat(bundles)：選取精確的套件組型錄發行版本 (#4849)
- fix(bundler)：將明確為 null 的型錄欄位視為空，而非 "None" (#4532)
- refactor(artifact)：抽出 list 作業 (#4866)
- fix(bundler)：回報含換行字元的版本條件，而不是當機 (#4538)
- feat(mcp)：新增第一級版本工具 (#4864)
- refactor(version)：抽出共用作業 (#4863)
- feat(workflows)：新增工作流程步驟投稿受理 (#4861)
- docs：定義共用的 CLI 與 MCP 命令架構 (#4847)
- 將 AttackTree 擴充功能加入社群型錄 (#4859)
- 將 SpecKit Companion 擴充功能更新至 v0.24.0 (#4858)
- 自動為套件組投稿排定優先順序 (#4856)
- 將 SpecAssay 預設集更新至 v0.5.6 (#4854)
- chore：發行 1.1.1，開始 1.1.2.dev0 開發 (#4860)

## [1.1.1] - 2026-10-06

### 變更

- 將 SpecAssay 套件組更新至 v0.5.6 (#4855)
- 將 SpecAssay Check 擴充功能更新至 v0.5.6 (#4853)
- chore(triage)：為預設集投稿排定優先順序 (#4848)
- 自動為擴充功能投稿排定優先順序 (#4845)
- fix(bundles)：透過精確發行選取安裝釘選的型錄發行版本 (#4753)
- feat(integrations)：公開帶版本的型錄中繼資料 (#4841)
- fix(workflows)：init 步驟不得以 "SystemExit: 1" 取代 init 本身的錯誤 (#4530)
- feat(workflows)：選取精確的步驟型錄發行版本 (#4840)
- feat(presets)：選取精確的型錄發行版本 (#4823)
- fix(bundler)：讓 'catalog remove' 能刪除覆寫內建來源的專案來源 (#4533)
- 將 Quality Gates (Enforcement Layer) 擴充功能更新至 v0.3.6 (#4837)
- fix(bundles)：拒絕 SemVer 識別字中的非 ASCII 數字 (#4835)
- 將臨時專案更新至租戶 URL (#4828)
- feat(workflows)：新增 upper、lower、split、length 與 to_json 運算式篩選器 (#4766)
- 還原社群投稿受理與結果回報的變更 (#4831)
- fix：辨識社群投稿類型並回報工作流程結果 (#4829)
- feat(mcp)：新增實驗性的僅版本 stdio 伺服器 (#4822)
- fix：套用必要的代理工作流程標籤 (#4824)
- feat(version)：以 JSON 印出完整的版本資訊 (#4821)
- chore：發行 1.1.0，開始 1.1.1.dev0 開發 (#4820)

## [1.1.0] - 2026-10-02

### 變更

- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#4809)
- 在開啟型錄 PR 前先驗證社群預設集投稿 (#4787)
- fix：對工作流程型錄的 HTTP 回應使用有界讀取 (#3766)
- [extension] 將 Archive Extension 更新至 v1.4.0 (#4818)
- [bug-fix] 修正 non-latin-feature-names：保留 Unicode 功能名稱 (#4780)
- [extension] 將 Conformidad Software Humano 擴充功能加入社群型錄 (#4812)
- 將 Software Humano 預設集加入社群型錄 (#4816)
- [extension] 將 Log Intake (logreduce) 擴充功能加入社群型錄 (#4813)
- 將 Quality Gates 擴充功能更新至 v0.3.5 (#4814)
- feat(workflows)：從本機目錄與封存檔安裝自訂步驟類型 (#4769)
- fix(integrations)：停止將工作流程步驟派送給 SHAI (#4791)
- 新增 2026 年 9 月電子報 (#4811)
- fix(workflows)：在任意空白字元處拆分運算式運算子 (#4801)
- fix(authentication)：支援 GHE.com 發行成品下載 (#4807)
- feat(extensions)：選取精確的型錄發行版本 (#4726)
- 為一般整合註冊擴充功能命令與技能 (#4785)
- feat(workflows)：選取精確的工作流程型錄發行版本 (#4788)
- fix(bundles)：驗證獨立安裝元件的釘選 (#4789)
- 將 Intake Authoring Governance 更新至 v0.3.5 (#4779)
- chore：發行 1.0.13，開始 1.0.14.dev0 開發 (#4790)

## [1.0.13] - 2026-09-29

### 變更

- community：將 Raaghu Spec Kit Azure DevOps 擴充功能加入 friends (#4782)
- feat(extensions)：新增隨附的 `github` 擴充功能，用於 taskstoissues (#4488)
- fix(integrations)：從 Vibe 派送中移除無效的 --model/--output-format 旗標 (#4784)
- 將 Superpowers Implementation Bridge 擴充功能更新至 v1.3.0 (#4783)
- fix(workflows)：求值帶括號的運算式 (#4417)
- fix(workflows)：在運算式中解析負數清單索引 (#4416)
- docs：說明 Spec Kit 如何使用代理式 SDLC (#4774)
- fix(copilot)：在 Windows 上偵測 copilot.exe，而非假設為 copilot.cmd (#4758)
- fix：讓非 ASCII 文字在合併後的 JSON 設定檔中保持可讀 (#4773)
- 新增 openspec 擴充功能 (#4765)
- feat(integrations)：新增 MiniMax Code (mcode) 整合 (#4644) (#4645)
- docs(community)：將 Specstride 加入 Community Friends (#4762)
- docs：釐清功能目錄可以位於專案根目錄之外 (#4739)
- fix(scripts)：在解析預設集資訊清單時遵循 SPECKIT_PYTHON 覆寫 (#4445)
- chore：釐清過期 issue 與 PR 的指引 (#4772)
- 將 OWASP LLM Threat Model 擴充功能更新至 v2.1.2 (#4771)
- docs：修正工作流程發佈安全性審查的說法，並新增型錄審查注意事項 (#4736)
- [preset] 將 Intake Sequencing Governance 預設集更新至 v0.2.6 (#4761)
- [extension] 將 Test Validation 擴充功能加入社群型錄 (#4760)
- chore：發行 1.0.12，開始 1.0.13.dev0 開發 (#4759)

## [1.0.12] - 2026-09-25

### 變更

- fix(workflows)：在運算式中拒絕多參數的篩選器呼叫 (#3893)
- feat(auth)：新增 Bitbucket 驗證提供者 (#4629)
- 將 Agentstandards 套件組加入社群型錄 (#4751)
- docs：整合設計指引與貢獻指南 (#4752)
- 將 Agentstandards Task Gate 預設集加入社群型錄 (#4749)
- fix(alquimia)：為僅支援技能的 Alquimia 代理呈現 `/speckit-<name>` 呼叫方式 (#4137)
- [preset] 將 Intake Review Governance 預設集更新至 v0.2.3 (#4748)
- refactor(presets)：將領域內部實作拆入私有模組 (#4747)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#4742)
- 將 Agentstandards Architecture Council 擴充功能加入社群型錄 (#4730)
- fix(ci)：讓 markdownlint 工作再次對檔案執行 lint (#4526) (#4584)
- 將 SpecAssay 社群套件組更新至 v0.5.2 (#4737)
- 將 SpecAssay Check 擴充功能更新至 v0.5.2 (#4735)
- [preset] 將 SpecAssay 預設集更新至 v0.5.2 (#4717)
- fix：升級時在預設集重新註冊後同步整合資訊清單雜湊 (#4697)
- [extension] 將 OKF Knowledge Bundle Generator 更新至 v0.9.2 (#4700)
- 將 Intake Authoring Governance 預設集更新至 v0.3.4 (#4716)
- fix：消除 catalog_fetch() 對 file:// 與裸路徑 URL 的 TOCTOU 競態 (#3910)
- fix：為 _build_opencode_plugin 的 timeout 新增 ValueError 防護 (#3973)
- chore：發行 1.0.11，開始 1.0.12.dev0 開發 (#4723)

## [1.0.11] - 2026-09-24

### 變更

- feat：讓 catalog add 在所有型錄家族中具備冪等性 (#4505) (#4543)
- [extension] 將 SpecAssay Check 擴充功能更新至 v0.5.1 (#4703)
- 將 Spec Kit Design System 擴充功能加入社群型錄 (#4707)
- [extension] 將 Applied Epistemic Engineering 擴充功能更新至 v1.0.1 (#4699)
- fix(integrations)：移除重複的 Forge 派送覆寫 (#4714)
- fix(deps)：移除從未被匯入的 platformdirs (#4675)
- [preset] 將 SpecAssay 預設集更新至 v0.5.1 (#4706)
- docs：新增日文（日本語）README (#4560)
- fix(integrations)：從 Forge 派送中移除無效的 --model/--output-format 旗標 (#4667)
- fix：確保 CommandRegistrar 中專案相對路徑改寫具備冪等性 (#4553)
- feat(scripts)：新增 SPECIFY_FEATURE_NO_PERSIST 環境變數，可抑制 feature.json 寫入 (#4128) (#4129)
- 將 Project Statistics Governance 預設集加入社群型錄 (#4704)
- [extension] 將 ThreatSpec 擴充功能加入社群型錄 (#4701)
- fix(integrations)：Forge 派送僅透過 prompt 旗標 (#4668)
- [preset] 將 Database Standards 預設集加入社群型錄 (#4702)
- 將 NIEM Information Exchanges 預設集加入社群型錄 (#4698)
- docs：將 Spec Kit Workflow Cockpit 加入社群 friends (#4606) (#4630)
- fix：還原社群封存驗證，並比對投稿的總和檢查碼 (#4689)
- chore：重構根命令配接器 (#4687)
- chore：發行 1.0.10，開始 1.0.11.dev0 開發 (#4686)

## [1.0.10] - 2026-09-22

### 變更

- fix(workflows)：修正清單常值後接索引的運算式會靜默損壞資料的問題 (#4572)
- chore：重構 self 命令領域 (#4685)
- fix(integrations)：修正 frontmatter 注入在缺少結尾換行時黏連的問題 (#4570)
- chore：重構事件領域版面配置 (#4683)
- 修正 #4345（2/4）：為漂移的隨附擴充功能版本做修補升級並同步型錄 (#4394)
- fix(workflows)：驗證持久化的步驟結果形狀 (#4399)
- chore：整理驗證領域 (#4678)
- feat：在 `specify version` 中回報 OpenSSL 執行環境 (#4556)
- fix(agy)：強化 Antigravity CLI 相容性與執行旗標 (#4612)
- refactor：整理工作流程 CLI 命令 (#4673)
- docs：新增星標歷史圖表 (#4672)
- refactor：整理成品 CLI 命令 (#4671)
- fix(workflows)：拒絕會覆寫其他 overlay 的 `overlay add` (#4141)
- refactor：重組套件組 CLI 命令 (#4663)
- refactor：整理整合 CLI 命令 (#4662)
- refactor：整理預設集 CLI 命令 (#4657)
- fix(integrations)：宣告 OpencodeIntegration 為 multi_install_safe (#4620) (#4625)
- [preset] 將 Autonomous Run Governance 預設集更新至 v0.4.4 (#4586)
- 新增 `preset update` 便利包裝命令 (#4599)
- chore：發行 1.0.9，開始 1.0.10.dev0 開發 (#4658)

## [1.0.9] - 2026-09-21

### 變更

- fix(integrations)：透過 execute 模式派送 Amp (#4581)
- feat(bundles)：第一方 bugfix 與 assess 套件組，隨附工作流程 (#4504)
- fix(workflows)：在 RunState 恢復時拒絕非整數或超出範圍的 current_step_index (#4325)
- fix(extensions)：忽略 extension.yml 中非對應型別的 `config` 區段 (#4323)
- fix(workflows)：當同一個 overlay 也在該錨點插入時，保留其 `replace` (#4140)
- 重構擴充功能 CLI 命令結構 (#4641)
- fix(workflows)：讓 bug-fix 豁免 PR 數量確認 (#4636)
- fix：允許社群投稿封存驗證 (#4622)
- fix：釐清 converge 對完成主張的評估 (#4621)
- fix(workflows)：讓型錄自動化豁免 PR 數量確認 (#4607)
- 將 Ralph Loop 擴充功能更新至 v1.5.0 (#4593)
- [extension] 將 AgentPay Pre-Pay Audit 擴充功能加入社群型錄 (#4611)
- 將 Keel Connect 擴充功能更新至 v2.3.1 (#4632)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#4623)
- 將 DocGuard 擴充功能更新至 v0.41.6 (#4633)
- fix：當沒有內容可合併時，略過 codex config.toml 改寫 (#4564)
- fix(agy)：支援 --model、--add-dir 工作區與提示前額外參數 (#4481)
- 移除 common.sh 中無效的 case 模式（SC2221/SC2222）(#4605)
- fix：支援一般整合的 SKILL.md 呈現 (#4562)
- chore：發行 1.0.8，開始 1.0.9.dev0 開發 (#4619)

## [1.0.8] - 2026-09-17

### 變更

- [extension] 將 Verify Tasks 擴充功能更新至 v1.2.0 (#4617)
- docs：說明元件介面的合約驅動開發 (#4609) (#4616)
- chore：將社群工作流程升級至 gh-aw v0.88.7 (#4615)
- 提高 bug-fix 工作流程的點數上限，並從 PATH 執行 pytest (#4508)
- 將 Applied Epistemic Engineering 擴充功能加入社群型錄 (#4595)
- fix(extensions)：拒絕會遮蔽核心命令的別名 (#4558)
- fix：在命令模式下從擴充功能命令 frontmatter 移除 `scripts:` (#4559)
- docs：在 AI 揭露中要求註明代理、模型與設定 (#4512)
- docs：更新發行流程指南 (#4502)
- [extension] 將 Status Report 擴充功能更新至 v1.4.2 (#4585)
- fix：當功能名稱後綴為空時發出警告 (#4575)
- chore：將 bug-fix 與 bug-test 升級至 gh-aw v0.88.7 (#4604)
- fix(workflows)：add 前先載入自訂步驟 (#4473)
- fix(github-http)：驗證發行成品中繼資料 URL (#4438)
- 將 OpenUP Governance 預設集加入社群型錄 (#4596)
- 將 OpenUP Governed Lifecycle 擴充功能加入社群型錄 (#4598)
- 將 Azure Cosmos DB 擴充功能更新至 v0.2.0 (#4602)
- 將 adrkit 擴充功能更新至 v0.1.4 (#4600)
- chore：將 feature-assess 升級至 gh-aw v0.88.7 (#4546)
- chore：發行 1.0.7，開始 1.0.8.dev0 開發 (#4592)

## [1.0.7] - 2026-09-15

### 變更

- fix(integrations)：透過 `bob run` 派送 bob 命令 (#4492)
- 將 speckit.clarify 的規劃延後限定於實作細節 (#4507)
- docs：圍繞三個流程精簡 README (#4591)
- chore(deps)：將 actions/deploy-pages 從 5.0.0 升級至 5.0.1 (#4517)
- feat：新增由成品擁有的貢獻查詢 (#4550)
- feat：透過 specify artifact 公開 hook 貢獻 (#4348)
- 將 DocGuard — CDD Enforcement 擴充功能更新至 v0.34.9 (#4545)
- [extension] 將 MAQA — Multi-Agent & Quality Assurance 擴充功能更新至 v0.3.1 (#4544)
- feat：新增 `specify artifact` 內省功能 (#4305)
- fix：套件組資訊清單變更時要求明確重新整理 (#4477)
- fix(workflows)：強化社群投稿工作流程 (#4510)
- [extension] 將 GitHub Issue Triage 擴充功能加入社群型錄 (#4539)
- 修正 catalog-latest-url-bypass：要求型錄下載 URL 必須釘選標籤 (#4194)
- refactor(workflows)：讓求值器自行回報其葉節點 (#4274) (#4460)
- [preset] 新增 Secure Development Assurance Governance 預設集 (#4513)
- 將 Product Definition as Code (PDaC) 擴充功能加入社群型錄 (#4514)
- feat：為預設集與擴充功能清單新增 JSON 輸出 (#4218)
- docs：讓儲存庫維護工作流程豁免 PR 節流 (#4499)
- chore：以 gh-aw v0.88.7 重新整理 bug-assess 工作流程 (#4497)
- chore：發行 1.0.6，開始 1.0.7.dev0 開發 (#4511)

## [1.0.6] - 2026-09-10

### 變更

- fix(events)：在產生的派送器中（而非僅 CLI 命令）限制 stdin 上限 (#4337)
- docs(core)：SPECIFY_FEATURE 設定的是功能標籤，而非功能目錄 (#3786)
- chore：將過期時程縮短為 60 天標記過期、30 天後關閉 (#4503)
- [extension] 將 Spec Kit Schedule 擴充功能更新至 v0.7.4 (#4498)
- [preset] 將 Inventory Alignment 預設集更新至 v0.1.1 (#4494)
- 將 Spec Inventory 擴充功能更新至 v0.1.1 (#4496)
- docs：記錄貢獻證據關卡與標籤分類 (#4478)
- feat(workflows)：新增每步驟的整合設定 (#4425)
- fix：產生技能時保留擴充功能作者 (#4459)
- 將 ProductShape PRODUCT 工作流程擴充功能加入社群型錄 (#4485)
- 將 AgentPay x402 擴充功能更新至 v1.1.0 (#4482)
- 將 Figma Starter 擴充功能更新至 v1.1.0 (#4490)
- 修正 #4345（3/4）：新增 CI 防護，要求隨附擴充功能變更時必須升級版本 (#4395)
- fix(templates)：當 extensions.yml 無法讀取時回報，而不是靜默略過 hooks (#4456)
- 新增精簡的程式碼審查技能 (#4471)
- docs(templates)：釐清 /constitution 的 Sync Impact Report 屬暫時性、僅供審查的材料 (#4431) (#4432)
- fix(bundler)：復原失敗的步驟重新整理時，重新讀取步驟註冊表 (#4139)
- 修正 8 月電子報審查發現 (#4444)
- docs：透過就地編輯成品來解決 assess 的釐清事項 (#4402)
- chore：發行 1.0.5，開始 1.0.6.dev0 開發 (#4479)

## [1.0.5] - 2026-09-08

### 變更

- 將 OKF Knowledge Bundle Generator 更新至 v0.5.0 (#4475)
- 將 BrownKit 擴充功能更新至 v1.2.0 (#4474)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#4436)
- fix(tasks)：要求產生的任務納入 data-model.md 的欄位限制 (#4430)
- fix(workflows)：在 step add 時拒絕為假值的非對應 step.yml (#4321)
- fix(cline)：避免不相關的散文抑制 hook 命令註記 (#4150)
- 新增 2026 年 8 月電子報 (#4442)
- 將 Linear Integration 擴充功能更新至 v0.8.0 (#4428)
- fix(presets)：拒絕為假值的非對應型錄設定形狀 (#4320)
- docs(workflows)：讓參考副本與隨附工作流程同步 (#4424)
- fix(scripts)：將 setup-plan 的功能目錄鍵命名為 FEATURE_DIR (#4397)
- fix(workflows)：要求 while 與 do-while 迴圈必須有 'steps' 主體 (#4149)
- 將 Evaluator Contract 擴充功能加入社群型錄 (#4420)
- fix：從隨附的 speckit 工作流程移除未使用的 scope 輸入 (#4401)
- feat(integrations)：新增 Muse Code (muse) 代理整合 (#4413)
- feat(workflows)：新增工作流程插槽 (#4352)
- fix(scripts)：讓 bash 分支名稱清理與 Python、PowerShell 版本一致 (#4286)
- 允許命令參照權杖名稱使用連字號 (#4356)
- [extension] 將 Axi Extension 加入社群型錄 (#4412)
- chore：發行 1.0.4，開始 1.0.5.dev0 開發 (#4411)

## [1.0.4] - 2026-09-02

### 變更

- fix(scripts)：修正 wrap 組合在核心內容出現權杖時無限迴圈的問題 (#4396)
- [extension] 將 Charter 擴充功能更新至 v0.6.1 (#4409)
- fix(workflows)：讓非 ASCII 文字在寫入的 overlay 檔案中保持可讀 (#4148)
- fix(workflows)：依宣告順序回報 overlay 作業鍵 (#4146)
- fix：在 list_runs() 中略過損壞的 state.json，而非中止 (#3904)
- fix(rovodev)：合併 prompts.yml 時防護非字串的提示名稱 (#4145)
- fix：縮小預設集命令調和中裸 except Exception 的範圍 (#3842)
- fix(workflows)：拒絕篩選器與比較運算子混用，而非靜默錯誤綁定 (#3894)
- fix：在工作流程錯誤輸出中逸出 Rich 標記 (#3837)
- fix：為驗證設定載入器新增 JSON 錯誤處理 (#3836)
- fix：在擴充功能 ZIP 清理中使用 missing_ok=True (#3870)
- feat(presets)：允許預設集宣告必要的擴充功能 (#4250)
- fix(bundler)：拒絕不支援的型錄酬載版本 (#4090)
- fix(extensions)：從本機套件安裝隨附擴充功能的更新 (#4351)
- docs：釐清自主 PR 的處理方式 (#4392)
- fix(workflows)：add 時拒絕格式錯誤的步驟設定 (#4087)
- fix(powershell)：修正 create-new-feature 在非拉丁文說明時當機的問題 (#4138)
- fix(bundler)：將明確為 null 的 records 欄位視為缺失，而非 "None" (#4136)
- 新增 DeepSeek Harness (DSH) 整合 (#4336)
- chore：發行 1.0.3，開始 1.0.4.dev0 開發 (#4391)

## [1.0.3] - 2026-09-01

### 變更

- fix(workflows)：remove 時拒絕格式錯誤的步驟設定 (#4095)
- fix(workflows)：remove 時拒絕格式錯誤的工作流程設定 (#4096)
- fix(events)：略過無法讀取的擴充功能資訊清單 (#4089)
- docs(extensions)：修正私有型錄 FAQ 命令 (#4373)
- [extension] 將 Vurnix Honest Gate 擴充功能加入社群型錄 (#4388)
- fix(presets)：來源無法讀取時採封閉式失敗 (#4092)
- docs：說明 Spec Kit 如何自我試用 (#4381)
- 為 check-prerequisites 新增 --require-spec (#4367)
- fix(ci)：強化 PyPI 發行標籤處理 (#4386)
- fix(github-http)：拒絕格式錯誤的明確 URL 連接埠 (#4372)
- fix：透過 bundler 安裝時為擴充功能設定建立鷹架 (#4285)
- fix：拒絕未知的 setup-plan 參數 (#4371)
- feat(docker-agent)：新增 Docker Agent 整合 (#4302)
- fix(workflows)：拒絕被拼接進文字、而非被求值的條件 (#4292)
- fix(bundler)：從套件組安裝傳遞明確的 workflow_add 選項 (#4284)
- test(bundle)：在建置輸出路徑斷言中跨越 wrap 點連接 (#4280)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#4357)
- [extension] 將 Spec Kit Figma 擴充功能更新至 v3.1.1 (#4377)
- fix(presets)：拒絕為假值的非對應型錄根節點 (#4088)
- chore：發行 1.0.2，開始 1.0.3.dev0 開發 (#4379)

## [1.0.2] - 2026-08-31

### 變更

- [extension] 將 Jira Mirror 擴充功能加入社群型錄 (#4376)
- [extension] 將 AgentDocx SpecKit V2 擴充功能加入社群型錄 (#4369)
- fix(bundler)：拒絕非字串的型錄條目標籤成員 (#4318)
- fix(auth)：在憑證比對前先拒絕格式錯誤的 URL 連接埠 (#4362)
- fix：在 Windows PowerShell 中將 feature.json 以 UTF-8 解碼 (#4359)
- fix(events)：當沒有啟動器時，不再退回假的 "pwsh" argv (#4340)
- 將 Pre-Spec Cards 擴充功能加入社群型錄 (#4365)
- docs(workflows)：記錄 Python init 指令稿支援 (#4331)
- fix(presets)：驗證型錄 URL 的連接埠，而非僅主機名稱 (#4341)
- 將 Verified Codebase Context 預設集加入社群型錄 (#4344)
- fix(events)：修正 `event run` 對每個管道輸入的 stdin 酬載都當機的問題 (#4326)
- 將 Taco Review 擴充功能加入社群型錄 (#4322)
- 將 SpecKit Grill Me 擴充功能更新至 v1.0.1 (#4317)
- [extension] 將 BDD 擴充功能更新至 v1.0.3 (#4299)
- 將 Parallel Autonomous Run Governance 預設集更新至 v0.2.6 (#4304)
- 將 SpecAssay 套件組更新至 v0.4.12 (#4257)
- 將 SpecAssay 預設集更新至 v0.4.12 (#4256)
- 將 Archive Extension 更新至 v1.3.0 (#4298)
- 將 Reconcile 擴充功能更新至 v1.2.1 (#4297)
- chore：發行 1.0.1，開始 1.0.2.dev0 開發 (#4266)

## [1.0.1] - 2026-08-21

### 變更

- docs：攤平專案歷史導覽 (#4265)
- docs：在文件站使用 Spec Kit 品牌 (#4264)
- docs：新增既有專案採用指南 (#4263)
- docs：新增專案歷史頁面 (#4262)
- docs：標誌 Spec Kit 一週年 (#4260)
- docs：新增工作流程快速入門 (#4258)
- chore(deps)：將 astral-sh/setup-uv 從 9.0.0 升級至 10.0.1 (#4244)
- 將 SpecAssay Check 擴充功能更新至 v0.4.12 (#4254)
- fix(workflows)：要求 switch 步驟必須有 'cases' 區塊 (#4144)
- fix(workflows)：比對 switch 案例前，先去除解析值的首尾空白 (#4143)
- fix(bundler)：拒絕非字串的資訊清單清單成員 (#4091)
- fix(presets)：拒絕非對應型別的型錄變更 (#4094)
- fix(workflows)：不再提供會反轉條件的修正建議 (#4230)
- fix：對整合與預設集資訊清單雜湊使用分塊讀取 (#3843)
- docs：為 1.0.0 更新首頁統計 (#4251)
- 將 Azure Cosmos DB 擴充功能加入社群型錄 (#4247)
- chore(deps)：將 actions/checkout 從 6.0.3 升級至 7.0.1 (#4243)
- chore(deps)：將 actions/setup-node 從 6.4.0 升級至 7.0.0 (#4242)
- chore(deps)：升級 codeql-action 群組，共 2 項更新 (#4241)
- chore：發行 1.0.0，開始 1.0.1.dev0 開發 (#4246)

## [1.0.0] - 2026-08-21

### 變更

- [extension] 將 Security Review 擴充功能更新至 v2.0.0 (#4223)
- fix(presets)：拒絕重複的 provides.templates 名稱+型別條目 (#4191)
- fix(bundler)：將下載的（非 zip）套件組資訊清單以 UTF-8 解碼 (#4190)
- 將 Intake Sequencing Governance 預設集更新至 v0.2.3 (#4235)
- 將 MAQA — Multi-Agent & Quality Assurance 擴充功能更新至 v0.1.6 (#4234)
- [bug-fix] 修正 qodercli-skills-migration：將 QodercliIntegration 遷移至 SkillsIntegration (#4205)
- [preset] 將 Inventory Alignment 預設集加入社群型錄 (#4229)
- [extension] 將 Spec Inventory 擴充功能加入社群型錄 (#4228)
- [extension] 將 Architecture Guard 擴充功能更新至 v2.3.6 (#4224)
- 將 SpecKit Companion 擴充功能更新至 v0.20.2 (#4225)
- fix(workflows)：拒絕沒有 {{ }} 區塊的條件 (#4182)
- fix：提高功能評估的點數預算 (#4222)
- [extension] 將 AgentDocx 擴充功能加入社群型錄 (#4184)
- fix(integrations)：將為假值的非對應整合描述子回報為形狀錯誤 (#4187)
- 將 Autonomous Run Governance 預設集更新至 v0.4.1 (#4203)
- fix(workflows)：驗證派送預設值 (#4181)
- 在社群型錄中更新 Atlas 擴充功能的顯示名稱 (#4202)
- 將 Closed Vocabulary Check 預設集加入社群型錄 (#4201)
- fix(utils)：縮小 merge_json_files 中裸 except Exception 的範圍 (#4189)
- chore：發行 0.16.5，開始 0.16.6.dev0 開發 (#4206)

## [0.16.5] - 2026-08-19

### 變更

- fix(powershell)：修正 Out-Null 吞掉 setup-tasks 的 AVAILABLE_DOCS 行 (#4188)
- fix：在 feature-assess 主機設定步驟中佈建 Spec Kit CLI 與 assess 擴充功能 (#4195)
- fix：為 feature-assess 工作流程佈建 uv 與 Python (#4193)
- feat：新增 feature-assess 代理工作流程，會安裝並執行 Spec Kit (#4186)
- [extension] 將 Superpowers Implementation Bridge 更新至 v1.2.0 (#4183)
- fix(init)：修正 specify init 在代理 harness 中於方向鍵選取器上卡住的問題 (#4178)
- [extension] 將 DUBSAR Memory 擴充功能加入社群型錄 (#4170)
- 將 AgentPay x402 擴充功能加入社群型錄 (#4174)
- 將 Keel Discovery 擴充功能更新至 v0.2.0 (#4172)
- fix：將事件 hook 指令稿路徑限制在專案樹內 (#4133)
- 在文件、說明與訊息中釐清擴充功能型錄的信任模型 (#4177)
- 新增 pay-x402 社群擴充功能，並修正型錄加入時間戳記 (#4175)
- 將 ASCII Diagram Renderer 擴充功能加入社群型錄 (#4173)
- 將 Intake Review Governance 預設集更新至 v0.2.1 (#4169)
- test(presets)：在 resolve 輸出斷言中正規化空白，避免終端換行造成失敗 (#4166)
- fix(workflows)：中斷或 typer.Exit 時清理下載的暫存檔 (#4134)
- fix(workflows)：將為假值的非對應 overlay 資訊清單回報為形狀錯誤 (#3884)
- fix(bundler)：檢查套件組元件參照時解析內建步驟類型 (#3885)
- 將 SpecAssay 套件組加入社群型錄 (#4125)
- chore：發行 0.16.4，開始 0.16.5.dev0 開發 (#4124)

## [0.16.4] - 2026-08-14

### 變更

- 將 SpecAssay 預設集加入社群型錄 (#4123)
- 將 Intake Authoring Governance 預設集更新至 v0.3.1 (#4121)
- 將 Superspec 擴充功能更新至 v1.0.2 (#4120)
- fix(taskstoissues)：放寬任務 ID 正規表示式，以符合超過 3 位數的 ID (#4101)
- 將 Architecture Governance 擴充功能加入社群型錄 (#4122)
- fix(workflows)：驗證非字串的步驟類型 (#4111)
- 強化社群投稿工作流程的輸出許可清單 (#4103)
- chore(deps)：將 github/codeql-action（init + analyze）從 4.37.5 升級至 4.37.6 (#4114)
- 將 SpecAssay Check 擴充功能加入社群型錄 (#4113)
- fix(integrations)：透過 `goose run` 派送 goose 命令 (#2416) (#3781)
- fix(powershell)：修正 Out-Null 吞掉 AVAILABLE_DOCS 狀態行 (#3891)
- fix：移除 RunState.load 中的 TOCTOU 競態 (#3839)
- fix：解析前先將壓縮的資訊清單以 UTF-8 解碼 (#3958)
- 將 Agent Parity Governance 預設集更新至 v0.4.2 (#4110)
- fix：記錄進度追蹤器重新整理錯誤，而非靜默吞掉 (#3975)
- [extension] 將 SpecJudge 擴充功能加入社群型錄 (#4079)
- fix(bundler)：讀取具權威性的 `default_integration` 欄位，而非僅其舊版別名 (#3880)
- fix(auth)：將精確主機模式視為常值 (#4108)
- feat：新增 Mistral Vibe 整合，並與 Claude 對等 (#4075)
- [extension] 將 spec-kit-atlas 擴充功能加入社群型錄 (#4105)
- chore：發行 0.16.3，開始 0.16.4.dev0 開發 (#4107)

## [0.16.3] - 2026-08-13

### 變更

- fix：縮小 VS Code 設定合併中裸 except Exception 的範圍 (#3844)
- feat(presets)：依解析／優先順序列出預設集 (#4086) (#4104)
- 修正：為具命名空間的預設集命令建立自包含鷹架 (#4076) (#4082)
- 將 Cross-Platform Governance 預設集更新至 v0.2.2 (#4080)
- fix(bundler)：在 FR-019 中將空白的使用中整合視為未定 (#3886)
- 整合 Junie，採用點轉連字號行為與命令格式 (#4073)
- 將 A11Y Governance 預設集更新至 v0.4.3 (#4074)
- 修正摺疊說明後 Alquimia 的參數提示 (#4063)
- fix：對套件組下載的 HTTP 回應使用有界讀取 (#3764)
- 將 iSAQB Architecture Governance 預設集更新至 v0.2.2 (#4056)
- fix(claude)：讓參數提示注入能感知長說明的摺疊 (#4045)
- 將 SpecKit Grill Me 擴充功能加入社群型錄 (#4052)
- 將 Architecture Governance 預設集更新至 v0.5.2 (#4050)
- 從型錄投稿工作流程移除自動指派 (#4054)
- docs：釐清範例規格指引 (#4048)
- 釐清自訂檢核清單的所有權與生命週期 (#4028)
- 將 Archive Extension 更新至 v1.2.2 (#4053)
- 將 Security Governance 預設集更新至 v0.6.2 (#4040)
- docs：釐清維護者在分流時套用投稿標籤 (#4041)
- chore：發行 0.16.2，開始 0.16.3.dev0 開發 (#4038)

## [0.16.2] - 2026-08-10

### 變更

- 將 Command Code 整合加入 spec-kit (#4019)
- fix(workflows)：在真／假檢查前先去除已解析條件的首尾空白 (#3883)
- fix(workflows)：防護非字串的 overlay 編輯 'operation' (#3881)
- fix：限制整合型錄擷取的回應讀取 (#3818)
- 修正 bug-test 的 Python 相依佈建 (#4030)
- fix(bundle)：在 bundle CLI 錯誤與狀態輸出中逸出 Rich 標記 (#4023)
- fix(presets)：在 `preset remove` 中略過無法讀取的還原來源 (#4020)
- 將 Keel Discovery 擴充功能加入社群型錄 (#4035)
- fix：在預設集型錄設定讀取失敗時顯示錯誤詳情 (#3840)
- 將 Reconcile Extension 更新至 v1.1.0 (#4034)
- 將 Model Routing Governance 預設集加入社群型錄 (#4033)
- fix：在整合 JSON 移除中使用 missing_ok=True (#3846)
- fix：在擴充功能快取清除中使用 missing_ok=True (#3845)
- fix(extensions)：拒絕重複的 provides.templates/scripts 名稱 (#4016)
- feat(presets)：在命令執行時解析憲章範本 (#3984)
- [bug-fix] 修正 preset-wrap-drops-argument-hint：從核心範本繼承 argument-hint (#3996)
- docs：記錄如何從自訂套件索引安裝 specify-cli (#4032)
- feat(extensions)：在資訊清單中接受 provides.templates 與 provides.scripts (#4012)
- fix(presets)：將無法讀取的核心範本視為缺失 (#3961)
- chore：發行 0.16.1，開始 0.16.2.dev0 開發 (#4014)

## [0.16.1] - 2026-08-07

### 變更

- fix(integrations)：包裝非 UTF-8 的型錄回應 (#4011)
- fix(events)：略過無法讀取的命令範本 (#3956)
- fix(bundle)：包裝本機 .zip 套件組資訊清單中格式錯誤的 YAML (#4013)
- chore(deps)：將 github/codeql-action/analyze 從 4.37.3 升級至 4.37.5 (#4005)
- chore(deps)：升級 DavidAnson/markdownlint-cli2-action (#4006)
- fix(agent-context)：在 Python mtime 備援中遞迴處理巢狀計畫 (#3757)
- fix：為擴充功能與預設集註冊表檔案 I/O 新增 utf-8 編碼 (#3834)
- fix(init)：在 `specify init` 輸出中逸出使用者提供的值 (#3787)
- fix：限制整合型錄擷取的回應讀取 (#3812)
- fix：暫存檔清理使用 missing_ok，避免遮蔽錯誤 (#3803)
- fix(workflows)：在 `workflow status` 中處理無法讀取的執行狀態 (#3999)
- feat(init)：為受管理的 .specify/.gitignore 建立鷹架 (#4000)
- fix(scripts)：修正 check-prerequisites 文字模式在舊版 stdout 字碼頁上當機的問題 (#3890)
- fix(presets)：resolve_content 對無法讀取的層級傳回 None (#3959)
- fix(extensions)：擴充功能註冊表為非 UTF-8 時重新開始 (#3998)
- 修正 init-force-preset-desync：在 init --here --force 時重新套用預設集／擴充功能 (#3995)
- fix(skills)：將逐行錨定的分隔符掃描套用到 hermes 與 kimi (#3739)
- fix(archives)：包裝截斷的 tar.gz 所拋出的裸 EOFError (#3938)
- test(integrations)：防護 SKILL.md frontmatter 多行／控制字元逸出 (#3392)
- fix(scripts)：修正 setup-tasks 文字模式在舊版字碼頁上當機的問題 (#3892)
- chore：發行 0.16.0，開始 0.16.1.dev0 開發 (#3992)

## [0.16.0] - 2026-08-05

### 變更

- fix：讓較長的 frontmatter 值保持在單行 (#3989)
- fix：在 list_runs 中略過損壞的執行狀態檔 (#3817)
- fix：在 list_runs 中略過損壞的執行狀態檔 (#3814)
- 新增 2026 年 7 月電子報 (#3987)
- fix(presets)：預設集註冊表為非 UTF-8 時重新開始 (#3955)
- docs：釐清代理 PR 審查的優先順序 (#3985)
- fix(events)：在 hook 安裝／拆卸時保留非 UTF-8 的 config.toml (#3963)
- fix(extensions)：將無法讀取的暫存備份視為衝突 (#3962)
- fix(manifests)：拒絕非字串的 requires.speckit_version (#3980)
- fix(extensions)：當保留的設定無法讀取時拒絕重新安裝 (#3960)
- [extension] 將 Charter 擴充功能更新至 v0.5.1 (#3983)
- fix(events)：指令稿命令無法解析時傳回 None (#3957)
- feat(events)：為 opencode 與 JSON 信封代理 hooks 新增上下文注入 (#3934)
- 將 TDD Extension 加入社群型錄 (#3982)
- 將 Archive Extension 更新至 v1.1.0 (#3981)
- feat(copilot)：整合預設改為 skills (#3976)
- fix(events)：忽略非 UTF-8 的事件覆寫 (#3897)
- fix：將 stdin 讀取上限設為 1 MiB 以防止 DoS (#3857)
- fix(workflows)：拒絕 ID 不一致的執行狀態 (#3899)
- chore：發行 0.15.2，開始 0.15.3.dev0 開發 (#3953)

## [0.15.2] - 2026-08-03

### 變更

- fix(presets)：preset remove 時還原核心技能，而非刪除 (#3929)
- fix(manifests)：拒絕非字串的中繼資料，而非因此當機 (#3943)
- fix：縮小 invoke 分隔符解析中裸 except Exception 的範圍 (#3856)
- fix(workflows)：當明確指定 null 時，保留 init 步驟文件記載的 ignore_agent_tools 預設值 (#3889)
- fix(kimi)：保留非 UTF-8 的使用者技能 (#3895)
- fix(presets)：容忍非 UTF-8 的舊版命令 (#3896)
- feat：允許透過 SPECKIT_INTEGRATION_DEFAULT 覆寫預設的 init 整合 (#3952)
- 將 adrkit 擴充功能加入社群型錄 (#3947)
- feat(extensions)：在 extension add/enable 時為設定範本建立鷹架 (#2000)
- fix(events)：略過非 UTF-8 的擴充功能資訊清單 (#3900)
- fix(workflows)：當 gate 的 on_reject 不是 abort/skip/retry 時讓其失敗 (#3888)
- fix(presets)：驗證必要的資訊清單對應 (#3898)
- fix：消除 zip 打包中的 TOCTOU 競態 (#3855)
- fix(workflows)：當 fan-in 步驟的輸出不是對應時讓其失敗 (#3887)
- fix(workflows)：重新擷取非 UTF-8 的型錄快取 (#3901)
- fix(bundler)：包裝本機型錄解碼失敗 (#3902)
- 為 `specify init` 新增 `--extension` 旗標，可在 init 時選擇加入擴充功能 (#3914)
- fix：限制擴充功能型錄與下載的回應讀取 (#3775)
- fix(workflows)：拒絕其 verdict 列舉禁止重設值的重試 gate (#3912)
- chore：發行 0.15.1，開始 0.15.2.dev0 開發 (#3913)

## [0.15.1] - 2026-07-31

### 變更

- fix：在 `workflow resolve` 輸出中逸出 Rich 標記 (#3879)
- chore(deps)：將 actions/stale 從 10.4.0 升級至 11.0.0 (#3877)
- chore(deps)：將 actions/setup-python 從 6.3.0 升級至 7.0.0 (#3876)
- feat：安裝時支援 tar 封存檔 (#3874)
- fix：消除檔案取消連結呼叫中的 TOCTOU 競態 (#3819)
- fix(scripts)：容忍 Python 輔助程式中無法使用的 integration.json (#3785)
- fix(catalogs)：在共用型錄 URL 驗證器中驗證連接埠，比照其鏡像實作 (#3804)
- feat(presets)：新增可選擇啟用的 constitution-sync 預設集 (#3873)
- fix：拒絕非物件的工作流程快取 (#3860)
- 強化擴充功能 URL 下載快取，防範符號連結與 junction 競態 (#3869)
- fix：逸出工作流程步驟中繼資料 (#3863)
- [bug-fix] 修正 bundle-update-force-mislead：為 DefaultPrimitiveInstaller 新增 refresh() (#3452)
- fix：對擴充功能資訊清單雜湊使用分塊讀取 (#3841)
- fix：保留無法讀取的事件設定檔 (#3861)
- fix(scripts)：在 PowerShell init 目錄解析器中使用與 .NET Framework 相容的裁切方式 (#3872)
- 將 ContextForge MCP 擴充功能加入社群型錄 (#3487)
- fix：正規化非 UTF-8 的整合資訊清單 (#3862)
- feat：透過 verdict_input 將 gate 判定綁定至工作流程輸入 (#3725)
- docs：在 README 中使用絕對圖片 URL，以利 PyPI 呈現 (#3867)
- chore：發行 0.15.0，開始 0.15.1.dev0 開發 (#3871)

## [0.15.0] - 2026-07-30

### 變更

- 將 yolo 加入社群工作流程型錄 (#3864)
- fix(workflows)：防護 shell 步驟逾時檢查的 OverflowError (#3865)
- 將 Intent Reconciliation 擴充功能加入社群型錄 (#3858)
- fix(workflows)：比照 shell 步驟驗證提示步驟的 'timeout' (#3847)
- fix：為註冊表檔案開啟呼叫新增 utf-8 編碼 (#3816)
- fix：消除檔案取消連結呼叫中的 TOCTOU 競態 (#3815)
- test(workflows)：依真正的邊界命名條件拒絕測試 (#3808)
- fix：消除檔案取消連結呼叫中的 TOCTOU 競態 (#3811)
- fix(presets)：在 add/remove 輸出中逸出使用者提供的型錄名稱／URL (#3806)
- fix：為註冊表檔案開啟呼叫補上缺少的 utf-8 編碼 (#3810)
- [bug-fix] 修正 upgrade-overwrites-copilot-skills：升級後向擴充功能技能重新註冊傳遞 force=True (#3853)
- fix(integrations)：資訊清單無法刪除時不中止解除安裝 (#3805)
- test(extensions)：更新過期的資訊清單驗證訊息斷言 (#3859)
- fix(agents)：在 TOML 命令呈現中將非字串說明強制轉型 (#3799)
- fix(workflows)：讓安全性需求同步具備確定性 (#3832)
- fix(cli)：在 --tag 說明與拒絕訊息中呈現常值 [suffix] (#3800)
- fix(integrations)：保留非 UTF-8 的 VS Code 設定 (#3833)
- fix(bundler)：將明確為 null 的資訊清單欄位視為缺失，而非文字 "None" (#3798)
- feat：為整合提供第一級的代理原生執行環境 hooks (#3704)
- fix(extensions)：防護必要的資訊清單區段，讓單一不良擴充功能不致弄壞 `extension list` (#3797)
- fix(presets)：在 Rich 輸出中逸出已安裝預設集的中繼資料 (#3826)
- fix(workflows)：透過已解析的可執行檔派送提示步驟 (#3793)
- chore：發行 0.14.4，開始 0.14.5.dev0 開發 (#3850)

## [0.14.4] - 2026-07-29

### 變更

- fix(bundler)：將非 UTF-8 的設定讀取降級為 BundlerError (#3784)
- fix(workflows)：逸出步驟進度行，讓步驟 ID 能正確呈現（且 `/` 不再讓執行失敗）(#3783)
- 將 Agent Parity Governance 預設集更新至 v0.4.1 (#3830)
- fix(integrations)：在一般 raw_options 中拒絕空的 --commands-dir (#3714)
- fix(presets)：在 PresetManifest 中防護非清單／非對應的 provides.templates (#3712)
- fix(auth)：透過 shutil.which 解析 az，讓 azure-cli 權杖在 Windows 上可用 (#3709)
- fix(workflows)：拒絕為假值的非對應 workflow-catalogs.yml 頂層 (#3707)
- fix(integrations)：為 Droid（永遠斜線代理）呈現帶連字號的 /speckit-<name> (#3688)
- [preset] 將 A11Y Governance 預設集更新至 v0.4.2 (#3828)
- [preset] 將 Parallel Autonomous Run Governance 更新至 v0.2.4 (#3825)
- fix：修正 _resolved_dir 參數的 Optional 型別註記 (#3801)
- fix：為提示步驟的子行程執行新增逾時 (#3768)
- fix：處理 GitHub 發行成品 URL 解析中含 / 的標籤 (#3767)
- fix(presets)：在探索輸出中逸出型錄中繼資料 (#3773)
- 將 Autonomous Run Governance 預設集更新至 v0.3.3 (#3823)
- fix：對整合型錄 HTTP 回應使用有界讀取 (#3763)
- docs：新增 README 的簡體中文翻譯 (#3740)
- 將 Intake Sequencing Governance 預設集更新至 v0.2.2 (#3809)
- fix(workflows)：在 if/while/do-while 步驟中拒絕非字串／非布林的 'condition' (#3706)
- fix(bundle)：在探索輸出中逸出型錄中繼資料 (#3774)
- fix(workflows,extensions)：在搜尋／資訊顯示中容忍非清單的型錄標籤 (#3770)
- fix：修正可為 null 的已解析目錄註記 (#3771)
- fix(presets)：在 preset search/info 中容忍非字串與非清單的型錄欄位 (#3769)
- fix(integrations)：在探索輸出中逸出型錄中繼資料 (#3772)
- 將 Verify Review Ship 擴充功能更新至 v0.4.2 (#3792)
- fix(integrations)：保留原生技能呼叫前綴 (#3663)
- 將 Intake Review Governance 預設集更新至 v0.2.0 (#3796)
- fix(constitution)：停止將指引傳播進範本 (#3737) (#3790)
- chore：發行 0.14.3，開始 0.14.4.dev0 開發 (#3795)

## [0.14.3] - 2026-07-28

### 變更

- 將 Intake Authoring Governance 預設集更新至 v0.3.0 (#3788)
- fix(copilot)：遵循預設集命令範本覆寫 (#3592)
- clarify：要求真正的疑問句，禁止主題標籤式問題 (#3745)
- feat：新增 Alquimia AI 整合 (#2734)
- harden：保護擴充功能與預設集封存下載的安全 (#3141)
- fix：修正 context_note 參數的 Optional 型別註記 (#3765)
- 更新 AGENTS.md (#2626)
- fix(extensions)：在顯示名稱查詢中容忍非字串的型錄名稱 (#3747)
- fix(presets)：連接前先將非字串的型錄標籤強制轉型 (#3743)
- fix：僅為使用中的整合註冊擴充功能 (#3459)
- fix(extensions)：在型錄搜尋中容忍非字串標籤 (#3746)
- fix(extensions)：在 'extension info' 清單中將命令名稱連字號化 (#3744)
- fix(workflows)：在 `workflow info` 中逸出其餘不受信任的欄位 (#3731)
- fix(extensions)：在搜尋／資訊呈現中防護非數字的型錄下載次數 (#3710)
- fix(agent-context)：當設定標記為空白時套用預設標記（bash）(#3736)
- fix：在型錄清單輸出中逸出 Rich 標記 (#3738)
- fix(workflows)：在 WorkflowDefinition 中防護非對應的 'workflow:' 區塊 (#3694)
- fix(bundler)：在 _merge_config 中拒絕不支援的 schema_version（讓各讀取器一致）(#3711)
- 將 Linear Weave 擴充功能更新至 v1.0.1 (#3762)
- 將 Intake Sequencing Governance 預設集加入社群型錄 (#3761)
- 將 Quality Gates (Enforcement Layer) 擴充功能更新至 v0.3.3 (#3760)
- 將 Verify Review Ship 擴充功能更新至 v0.4.1 (#3759)
- fix(agent-context)：在 Python 移植版 mtime 備援中探索巢狀計畫 (#3734)
- fix(extensions)：安裝後讓隨附指令稿可執行 (#3723)
- docs(assess)：釐清管線可在空專案上運作 (#3732)
- chore：發行 0.14.2，開始 0.14.3.dev0 開發 (#3730)

## [0.14.2] - 2026-07-24

### 變更

- 將 Intake Review Governance 預設集更新至 v0.1.1 (#3729)
- 將 Verify Review Ship 擴充功能更新至 v0.3.0 (#3728)
- 將 Architecture Guard 擴充功能更新至 v1.13.1 (#3724)
- docs(upgrade)：Claude Code 檔案位於 .claude/skills，而非 .claude/commands (#3708)
- fix(kilocode)：將命令安裝於 .kilo/commands 之下 (#3672)
- fix(auth)：在儲存時正規化驗證設定環境變數／ID 參照中的空白 (#3691)
- fix(workflows)：在 engine._resolve_inputs 中防護非對應的 'inputs:' 區塊 (#3696)
- 將 Intake Authoring Governance 預設集更新至 v0.2.0 (#3721)
- docs：釐清 shell 步驟插值的安全性 (#3719)
- [extension] 將 Blueprint Index — Living Architecture Map 擴充功能加入社群型錄 (#3718)
- fix(github-http)：resolve_github_release_asset_api_url 在主機格式錯誤時傳回 None (#3715)
- fix(integrations)：宣告 PiIntegration 為 multi_install_safe (#3652)
- harden：從 run_command() 移除 shell 參數 (#3716)
- chore(deps)：將 github/codeql-action/init 從 4.37.1 升級至 4.37.3 (#3699)
- fix：自動修正衝突的功能前綴 (#1829)
- chore(deps)：將 actions/checkout 從 6.0.3 升級至 7.0.1 (#3703)
- chore(deps)：升級 DavidAnson/markdownlint-cli2-action (#3702)
- chore(deps)：將 actions/setup-node 從 6.4.0 升級至 7.0.0 (#3701)
- chore(deps)：將 astral-sh/setup-uv 從 8.3.2 升級至 9.0.0 (#3700)
- chore：發行 0.14.1，開始 0.14.2.dev0 開發 (#3698)

## [0.14.1] - 2026-07-23

### 變更

- 將 Agent Parity Governance 預設集更新至 v0.4.0 (#3697)
- fix(bundler)：InstallResult.changed 將解除安裝計為一項變更 (#3692)
- [preset] 將 Cross-Platform Governance 預設集更新至 v0.2.1 (#3695)
- 將 A11Y Governance 預設集更新至 v0.4.1 (#3693)
- fix(workflows)：在 `workflow info` 中逸出步驟圖的括號，讓類型能顯示 (#3690)
- fix(workflows)：篩選器解析器拒絕尾隨權杖（使用 fullmatch 而非 match）(#3689)
- 將 iSAQB Architecture Governance 預設集更新至 v0.2.1 (#3687)
- fix(extensions)：移除時依 --- 分隔行解析 SKILL.md (#3634)
- fix(cli)：在 extension/preset add --from 中防護惰性 .hostname 的 ValueError (#3651)
- 將 Architecture Governance 預設集更新至 v0.5.1 (#3686)
- fix(bundler)：在 _merge_config 中拒絕頂層非對應的 bundle-catalogs.yml (#3659)
- 將 Security Governance 預設集更新至 v0.6.1 (#3685)
- fix(integrations)：宣告 OmpIntegration 為 multi_install_safe (#3650)
- feat(git-extension)：新增可設定的 Conventional Commit 支援 (#3390) (#3413)
- fix(extensions)：在 Forge 安裝後清單中將命令名稱連字號化 (#3669)
- fix(bundler)：在 CatalogEntry.from_dict 中拒絕為假值的非對應 requires/provides (#3667)
- fix(bundler)：在記錄中拒絕為假值的非清單 bundles/contributed_components (#3666)
- 將 Intake Authoring Governance 預設集更新至 v0.1.1 (#3678)
- docs(extensions)：釐清 agent-context README 並新增設定範例 (#3389)
- chore：發行 0.14.0，開始 0.14.1.dev0 開發 (#3677)

## [0.14.0] - 2026-07-23

### 變更

- docs：將 spec-kit-copilot 加入社群 friends (#3675)
- fix(integrations)：從保留的 parsed_options 重新計算 invoke_separator (#3664)
- fix(workflows)：多個 insert_after 編輯時保留同一 overlay 內的順序 (#3662)
- fix(bundler)：在資訊清單 from_dict 中拒絕為假值的非對應 requires/provides (#3661)
- fix(bundler)：dump_yaml 寫出常值 UTF-8（allow_unicode=True）(#3660)
- fix(integrations)：宣告 kiro-cli 為多重安裝安全 (#3477)
- fix(git-extension)：去除提交訊息引號前先裁切尾隨空白 (#3673)
- fix(bundler)：依標準 POSIX arcname 排序套件組成員（可重現建置）(#3658)
- fix(integrations)：Cline 覆寫 post_process_command_content（正確的 hook 名稱）(#3657)
- docs(workflows)：gate 步驟 docstring 列出 'retry' 的 on_reject 行為 (#3656)
- fix：強化有界讀取與重新導向驗證 (#3671)
- fix(packaging)：將 scripts/python 打包進 wheel 的 core_pack (#3665) (#3670)
- fix：將 scripts/python 打包進 wheel，讓 --script py 可用 (#3665) (#3668)
- docs(workflows)：init 步驟 docstring 列出 'py' 指令稿類型 (#3655)
- fix(integrations)：宣告 LingmaIntegration 為 multi_install_safe (#3654)
- fix：防護 constitution 命令，避免在功能上執行 (#3646)
- 修正 specify 命令中重複的步驟編號 (#3647)
- docs(scripts)：記錄 'py' 指令稿類型與 sh/ps 遷移計畫 (#3284) (#3653)
- harden：限制 HTTP 讀取並強制嚴格重新導向 (#3140)
- chore：發行 0.13.4，開始 0.13.5.dev0 開發 (#3649)

## [0.13.4] - 2026-07-22

### 變更

- docs(concepts)：記錄 spec-of-specs 的功能拆解方法 (#3648)
- fix(scripts)：git-ext PowerShell 產生 '# To persist' SPECIFY_FEATURE 提示（與其他實作一致）(#3632)
- fix(integrations)：傳回快取型錄前先驗證其形狀 (#3627)
- fix(bundler)：以清楚的錯誤拒絕 bundle-catalogs.yml 中非清單的 'catalogs' (#3623)
- fix(bundler)：在 catalog add_source 中防護惰性 .hostname 的 ValueError (#3644)
- 將 Intake Authoring Governance 預設集加入社群型錄 (#3643)
- feat：新增 Factory Droid CLI 整合 (#822) (#3587)
- docs(installation)：記錄 'py'（Python）指令稿類型 (#3640)
- fix(init)：在 Forge 專案的 Next Steps 中顯示帶連字號的 /speckit-<name> (#3642)
- fix(extensions)：為 Forge 專案呈現帶連字號的 hook 呼叫 (#3641)
- fix(workflows)：workflow add 以不分大小寫方式偵測本機 YAML 檔案 (#3633)
- fix(workflows)：清單常值運算式忽略尾隨／空的逗號 (#3631)
- fix(workflows)：StepRegistry.add 容忍損壞的非 dict 既有條目 (#3630)
- fix(bundler)：拒絕套件組資訊清單中非對應的 'integration' (#3629)
- fix(workflows)：命令／提示步驟在整合為非字串時乾淨地失敗 (#3626)
- docs(core)：在 init 選項表中記錄 'py'（Python）--script 類型 (#3625)
- fix(workflows)：gate 提示使用 isdecimal()，避免上標數字造成當機 (#3624)
- fix(integrations)：Cline 派送帶連字號的 /speckit-<cmd> 呼叫 (#3622)
- docs(upgrade)：記錄以整合升級／擴充功能更新作為專案檔案升級路徑 (#3326)
- chore：發行 0.13.3，開始 0.13.4.dev0 開發 (#3645)

## [0.13.3] - 2026-07-22

### 變更

- fix(integrations)：在 --integration-options 錯誤訊息中逸出 Rich 標記 (#3458)
- docs：記錄 __SPECKIT_COMMAND_ 權杖，用於可攜的跨命令參照 (#3503)
- [preset] 將 Parallel Autonomous Run Governance 預設集加入社群型錄 (#3614)
- docs(workflows)：修正過期的 FanOutStep docstring，誤稱僅能循序執行 (#3639)
- [bundle] 將 SicarioSpec Security & Governance Bundle 加入社群型錄 (#3636)
- [preset] 將 Autonomous Run Governance 預設集更新至 v0.3.2 (#3615)
- fix(workflows)：擷取工作流程／步驟型錄時驗證每個重新導向跳點 (#3637)
- 將 pipeline 工作流程加入社群型錄 (#3338)
- [extension] 將 Linear Weave 擴充功能加入社群型錄 (#3609)
- docs：釐清 hook 優先順序驗證語義 (#3594)
- fix(workflows)：拒絕命令與提示步驟中非字串的 'integration'/'model' (#3597)
- ci：新增相依性稽核工作流程 (#3138)
- 將 Intake Review Governance 預設集加入社群型錄 (#3613)
- fix(workflows)：拒絕非清單的輸入 'enum'，而非當機 (#3601)
- chore：發行 0.13.2，開始 0.13.3.dev0 開發 (#3617)

## [0.13.2] - 2026-07-21

### 變更

- fix(workflows)：拒絕 command-step 中非字串的 'command' (#3596)
- fix(workflows)：gate 步驟在 'options' 格式錯誤時大聲失敗 (#3595)
- fix(extensions)：重新導向後重新驗證型錄 URL（HTTPS 一致性／安全性）(#3524)
- 新增社群套件組投稿自動化 (#3553)
- fix(presets)：重新導向後重新驗證型錄 URL（HTTPS 一致性／安全性）(#3523)
- feat(scripts)：將 create-new-feature、setup-plan 與 setup-tasks 移植至 Python (#3386)
- fix(agents)：依 --- 分隔行解析 frontmatter，而非任意 --- 子字串 (#3590)
- [bug-fix] 修正 reinstall-overwrites-kept-config：在 --keep-config 後的一般重新安裝時保留設定 (#3449)
- feat：將 Bob 整合更新為 Bob 2.0 的技能式版面配置 (#3415)
- 將 OKF Knowledge Bundle Generator 更新至 v0.3.0 (#3608)
- 將 Test Coverage Drift Control 擴充功能加入社群型錄 (#3607)
- chore：對齊 ruff lint 範圍 (#3139)
- feat(workflows)：獨立的 WorkflowResolver（PR 1）(#3557)
- fix(extensions,presets)：下載 URL 格式錯誤時呈現清楚的錯誤 (#3577)
- chore：發行 0.13.1，開始 0.13.2.dev0 開發 (#3610)

## [0.13.1] - 2026-07-21

### 變更

- fix(integrations)：在 add/remove 中捕捉 `priority: .inf` 的 OverflowError (#3589)
- fix(workflows)：在工作流程與步驟型錄載入器中拒絕布林／.inf 型錄優先順序 (#3526)
- fix(catalogs)：'priority: .inf' 產生清楚的驗證錯誤，而非當機 (#3525)
- docs(integrations)：記錄 'integration list --catalog' 旗標 (#3530)
- fix(workflows)：fan-in 在 wait_for 條目為非字串時大聲失敗 (#3579)
- fix(workflows)：fan-out 在步驟範本為真值的非對應時大聲失敗 (#3537)
- fix(workflows)：在 prompt-step validate() 中拒絕非字串提示 (#3582)
- fix(workflows)：將 'workflow status --json' 的錯誤導向 stderr (#3520)
- fix(integrations)：Forge 派送帶連字號的 /speckit-<cmd> 呼叫 (#3529)
- chore：發行 0.13.0，開始 0.13.1.dev0 開發 (#3588)

## [0.13.0] - 2026-07-17

### 變更

- fix(auth)：Azure DevOps az-CLI 權杖取得在輸出無法解碼時傳回 None (#3527)
- feat(extensions)：新增 assess 想法評估管線擴充功能 (#3568)
- fix(bundle)：套件組下載 URL 格式錯誤時呈現清楚的 BundlerError (#3586)
- 將 OKF Knowledge Bundle Generator 擴充功能加入社群型錄 (#3585)
- 將 Autonomous Run Governance 預設集更新至 v0.2.2 (#3584)
- docs：更新擴充功能指南的 PyPI 升級指引 (#3578)
- fix(presets)：型錄 URL 格式錯誤時拋出 PresetValidationError，而非原始 ValueError (#3576)
- chore(deps)：將 github/codeql-action/init 從 4.36.2 升級至 4.37.1 (#3571)
- docs：讓 README 主視覺標語與副標題與 docs/index.md 一致 (#3581)
- chore：發行 0.12.18，開始 0.12.19.dev0 開發 (#3583)

## [0.12.18] - 2026-07-17

### 變更

- chore(deps)：將 actions/setup-dotnet 從 5.4.0 升級至 6.0.0 (#3574)
- chore(deps)：將 actions/stale 從 10.3.0 升級至 10.4.0 (#3572)
- chore(deps)：將 actions/setup-node 從 6.4.0 升級至 7.0.0 (#3570)
- docs：將 harness/SDLC 框架融入首頁 (#3567)
- docs：重新框架 SDD 定位、現代化安裝說明，並去除走查重複內容 (#3565)
- docs：記錄 extensions.yml 的 hook 設定 (#3563)
- docs：更新首頁生態系統計 (#3561)
- [extension] 將 Dotdog 擴充功能加入社群型錄 (#3558)
- 將 DocGuard — CDD Enforcement 更新至 v0.33.0 (#3559)
- chore：發行 0.12.17，開始 0.12.18.dev0 開發 (#3560)

## [0.12.17] - 2026-07-16

### 變更

- fix(extensions)：在自動註冊的技能中解析 __SPECKIT_COMMAND 權杖 (#3544)
- fix(workflows)：if/switch 步驟在分支為非清單時失敗，而非當機 (#3515)
- feat(integrations)：新增 Grok Build 技能式整合 (#3535)
- fix(extensions/git)：在 create-new-feature-branch.ps1 中拒絕負數的 -Number (#3538)
- test：透過 init CLI 涵蓋預設集憲章種入測試 (#3297)
- fix(integration)：在技能模式 Copilot 的 `use` 中保留 ai_skills (#3550) (#3551)
- [extension] 將 Figma Starter 擴充功能加入社群型錄 (#3547)
- [extension] 將 Spec-Kit BDD 擴充功能加入社群型錄 (#3548)
- [extension] 將 Quality Gates (Enforcement Layer) 擴充功能更新至 v0.3.2 (#3542)
- chore：發行 0.12.16，開始 0.12.17.dev0 開發 (#3549)

## [0.12.16] - 2026-07-15

### 變更

- fix(workflows)：對非字串篩選器參數拋出清楚的錯誤，而非隱晦的當機 (#3522)
- feat(workflows)：將工作流程來源目錄公開給步驟 (#3469)
- fix(workflows)：fan-out 的 max_concurrency 為 .inf 時退回循序執行，而非當機 (#3521)
- 將 Coding Standards Drift Control 擴充功能更新至 v0.4.0 (#3540)
- fix(presets)：從預設集的 constitution-template 種入憲章 (#3272) (#3276)
- docs：新增 PyPI 作為第二條受支援的安裝路徑 (#3425) (#3516)
- fix(workflows)：while/do-while 步驟在 steps 為非清單時失敗，而非當機 (#3519)
- 將 PatchWarden Evidence Pack 擴充功能加入社群型錄 (#3514)
- feat(extensions)：將 git 擴充功能指令稿移植至 Python (#3400)
- chore：發行 0.12.15，開始 0.12.16.dev0 開發 (#3513)

## [0.12.15] - 2026-07-14

### 變更

- 將 Autonomous Run Governance 預設集更新至 v0.1.4 (#3511)
- fix(workflows)：型錄 URL 格式錯誤時拋出型錄錯誤，而非原始 ValueError (#3484)
- fix(workflows)：在右運算元不可迭代時安全地求值 'in'/'not in' (#3447) (#3468)
- fix：為 init-options.json 輸出補上結尾換行 (#3509)
- feat(workflows)：讓工作流程 CLI 與擴充功能命令介面一致 (#3419)
- fix(extensions)：避免環境變數設定跨越前綴碰撞的擴充功能 ID 洩漏 (#3497)
- fix(integrations)：在 goose recipe YAML 呈現器中逸出控制字元 (#3384)
- [extension] 將 DocGuard — CDD Enforcement 擴充功能更新至 v0.32.0 (#3489)
- [extension] 將 Multi-Repo Branch Sync 擴充功能加入社群型錄 (#3411)
- chore：發行 0.12.14，開始 0.12.15.dev0 開發 (#3506)

## [0.12.14] - 2026-07-13

### 變更

- [extension] 將 Spec Kit Memory 擴充功能加入社群型錄 (#3455)
- 將 Test-First Governance 預設集加入社群型錄 (#3504)
- 將 Autonomous Run Governance 預設集加入社群型錄 (#3501)
- fix(workflows)：驗證命令步驟的 input/options 為對應 (#3262)
- fix(presets)：resolve() 對已安裝預設集遵循資訊清單宣告的 file: (#3351)
- fix(init)：無 TTY 時 'init --here' 不再卡在確認步驟 (#3236)
- [extension] 將 Quality Gates (Enforcement Layer) 擴充功能加入社群型錄 (#3431)
- fix(integrations)：--integration-options 中引號不平衡時乾淨地結束 (#3457) (#3466)
- fix(integrations)：宣告 kiro-cli 為多重安裝安全 (#3471) (#3485)
- fix(workflows)：fan-in 步驟在 wait_for 為非清單時失敗，而非當機 (#3482)
- chore：發行 0.12.13，開始 0.12.14.dev0 開發 (#3498)

## [0.12.13] - 2026-07-13

### 變更

- fix(workflows)：switch 步驟在 cases 為非對應時失敗，而非當機 (#3481)
- 清理 agent-file-template.md (#2579)
- fix：將 Kiro 整合標記為多重安裝安全 (#3472)
- fix：改寫產生命令主體中相對於擴充功能的子目錄路徑 (#3444)
- fix(templates)：讓憲章同步檢核清單指向已安裝的命令檔案 (#3418)
- feat(workflows)：讓 shell 步驟逾時可設定 (#3327) (#3328)
- docs：釐清發行標籤保留開頭的 v 前綴 (#3463)
- fix(workflows)：對不可迭代對象做成員測試時不再當機 (#3448)
- fix(workflows)：if 步驟驗證接受為假值的非清單 else (#3264)
- chore：發行 0.12.12，開始 0.12.13.dev0 開發 (#3490)

## [0.12.12] - 2026-07-13

### 變更

- fix(extensions)：set-priority 修復損壞的布林優先順序 (#3268)
- fix(presets)：set-priority 修復損壞的布林優先順序 (#3269)
- fix(workflows)：引擎迴圈上限忽略布林型 max_iterations (#3270)
- docs(bundles)：記錄 'bundle update' 的 --integration (#3271)
- fix(workflows)：強化 catalog.py，防範形狀錯誤的註冊表與非字串欄位 (#3375)
- 將 Verify Review Ship 擴充功能加入社群型錄 (#3450)
- fix(bundle)：拒絕 file://／本機 download_url——型錄 URL 僅限 HTTPS (#3344)
- fix(extensions)：在 _get_env_config 中處理前綴碰撞的環境變數 (#3350)
- docs：記錄 Copilot 技能模式（--skills）與 markdown 棄用 (#3313)
- chore：發行 0.12.11，開始 0.12.12.dev0 開發 (#3460)

## [0.12.11] - 2026-07-10

### 變更

- fix(agent-context)：在範圍化版面配置中探索巢狀的 plan.md (#3024) (#3301)
- fix(auth)：URL 格式錯誤時傳回無符合項目，而非原始 ValueError (#3437)
- fix(catalogs)：URL 格式錯誤時拋出型錄錯誤，而非原始 ValueError (#3435)
- fix(bundler)：URL 格式錯誤時拋出 BundlerError，而非原始 ValueError (#3433)
- chore：新增 pre-commit 設定，並修正尾隨空白／檔尾 (#3430)
- 將 EARS Requirements Syntax 擴充功能加入社群型錄 (#3407)
- 將 Spec Kit Figma 擴充功能加入社群型錄 (#3408)
- fix(workflows)：workflow.yml 純量為非字串時回報驗證錯誤，而非當機 (#3421)
- fix(templates)：移除 plan-template.md 註記中自我參照的路徑 (#3417)
- chore：發行 0.12.10，開始 0.12.11.dev0 開發 (#3453)

## [0.12.10] - 2026-07-10

### 變更

- chore(deps)：將 astral-sh/setup-uv 從 8.2.0 升級至 8.3.2 (#3439)
- chore(deps)：升級 DavidAnson/markdownlint-cli2-action (#3438)
- fix(templates)：修正 plan.md 中的階段編號 (#3416)
- fix(git-ext)：在 PowerShell 分支建立中遵循明確的 -Number 0 (#3412)
- docs：在 friends.md 新增 'spectatui' 條目 (#3362)
- test：釘選解譯器探測，讓 py-template 呈現測試在 Windows 上通過 (#3428)
- feat(workflows)：讓 shell 步驟逾時可設定 (#3404)
- fix：在巢狀規格目錄中尋找計畫 (#3405)
- feat(templates)：在命令範本的 scripts frontmatter 中新增 py: 行 (#3403)
- chore：發行 0.12.9，開始 0.12.10.dev0 開發 (#3426)

## [0.12.9] - 2026-07-09

### 變更

- fix(integrations)：在 resolve_python_interpreter 中略過 Windows Store 的 python3 別名 stub (#3385)
- fix(integrations)：在 SKILL.md frontmatter 中逸出控制字元 (#3399)
- fix(workflows)：由左至右套用鏈結的運算式篩選器 (#3339)
- fix(scripts)：依解析成功與否決定 invoke_separator，而非 python3 是否可用 (#3304) (#3320)
- fix(shared-infra)：refresh_shared_templates 保留還原的使用者檔案 (#3378)
- fix(agents)：在 Goose（yaml）命令輸出中解析技能佔位符 (#3374)
- fix(bundler)：對隨附預設集／擴充功能安裝強制版本釘選 (#3377)
- 將 Golden Demo 擴充功能更新至 v0.3.0 (#3394)
- test：隔離整合測試的家目錄 (#3144)
- chore：發行 0.12.8，開始 0.12.9.dev0 開發 (#3410)

## [0.12.8] - 2026-07-08

### 變更

- [extension] 將 LLM Wiki 擴充功能加入社群型錄 (#3361)
- Docs：記錄缺少的 CLI 旗標與整合 (#3182)
- Docs：從 README 的 CLI 檢查清單移除 Cursor (#3184)
- feat(extensions)：將 update-agent-context 移植至 Python (#3387)
- fix(scripts)：feature.json 解析器在 python3 為損壞的 stub 時退回 grep/sed (#3312)
- fix(toml)：逸出控制字元，讓產生的命令檔案可被解析 (#3341)
- fix(cli)：在 `extension`/`preset`/`workflow add` 中遇到格式錯誤的 IPv6 URL 時乾淨地結束 (#3369)
- fix(github-http)：GHES 連接埠格式錯誤時傳回 None，而非拋出例外 (#3379)
- fix(integrations)：防護 _sha256 處理無法讀取的受管理檔案 (#3376)
- chore：發行 0.12.7，開始 0.12.8.dev0 開發 (#3398)

## [0.12.7] - 2026-07-07

### 變更

- fix(bundler)：bundle update 解除安裝新版本已移除的元件 (#3353)
- fix(workflows)：--json 模式下將 run/resume 錯誤導向 stderr (#3352)
- fix(workflows)：fan-in 的 validate() 拒絕非對應輸出 (#3349)
- fix(workflows)：shell 步驟的 validate() 拒絕非字串 run (#3348)
- fix(integrations)：agy 遵循 SPECKIT_INTEGRATION_AGY_EXTRA_ARGS (#3347)
- 將 Orchestration Task Context Management 擴充功能加入社群型錄 (#3372)
- 將 DocGuard — CDD Enforcement 擴充功能更新至 v0.30.0 (#3371)
- 將 Ripple 擴充功能更新至 v1.1.0 (#3370)
- feat(integrations)：將後處理推廣至所有格式類型 (#3311)
- chore：發行 0.12.6，開始 0.12.7.dev0 開發 (#3393)

## [0.12.6] - 2026-07-07

### 變更

- fix(bundler)：在 `catalog add` 中驗證型錄 URL（僅限 HTTPS、必須有主機）(#3367)
- 將 Ralph Loop 擴充功能更新至 v1.2.1 (#3365)
- 修正擴充功能本機指令稿路徑改寫 (#3364)
- 將 Charter 擴充功能加入社群型錄 (#3363)
- feat(scripts)：新增 Python check-prerequisites 概念驗證 (#3302)
- test：減少註冊表資訊清單測試的重複 (#3146)
- fix(integrations)：hermes 遵循 SPECKIT_INTEGRATION_HERMES_EXTRA_ARGS (#3346)
- fix(extensions)：在 ConfigManager 中將非對應的 YAML 設定根節點強制轉為 {} (#3345)
- fix(yaml)：釘選 goose recipe 提示的區塊純量縮排 (#3343)
- chore：發行 0.12.5，開始 0.12.6.dev0 開發 (#3381)

## [0.12.5] - 2026-07-06

### 變更

- fix(workflows)：gate 拒絕選項比對不分大小寫 (#3335)
- fix(bundler)：在配接器中拒絕無主機的型錄 URL（使用 hostname 而非 netloc）(#3333)
- fix(bundler)：先在最高優先順序來源解析型錄搜尋，再進行篩選 (#3331)
- fix(workflows)：以字典序比較非數字字串，而非傳回 False (#3323)
- fix(workflows)：具引號感知的插值，避免篩選器參數中的常值 }} 破壞多運算式範本 (#3307)
- 支援具命名空間的 git 功能分支範本 (#3293)
- chore(deps)：將 actions/setup-dotnet 從 5.3.0 升級至 5.4.0 (#3315)
- fix(integrations)：cursor-agent 遵循可執行檔／額外參數的環境覆寫 (#3265)
- docs：移除過期的 kimi KIMI.md->AGENTS.md 遷移註記 (#3291)
- chore：發行 0.12.4，開始 0.12.5.dev0 開發 (#3305)

## [0.12.4] - 2026-07-02

### 變更

- feat(cli)：新增 `py` 指令稿類型與 Python 解譯器解析 (#3278) (#3285)
- fix：解析私有儲存庫套件組下載的 GitHub 發行成品 API URL (#3136)
- [extension] 將 Analytics 擴充功能加入社群型錄 (#3296)
- fix：插值多運算式範本，而非傳回 None (#3208) (#3228)
- feat(cli)：在 specify CLI 專案解析器中遵循 SPECIFY_INIT_DIR (#3186)
- fix(extensions)：透過 _assets 輔助程式解析核心命令目錄 (#3274) (#3287)
- fix：CURRENT_BRANCH 為空時退回功能目錄的基底名稱 (#3026) (#3229)
- feat(bug-fix)：新增標籤驅動的 bug-fix 代理工作流程 (#3258)
- feat(workflows)：新增標籤驅動的 bug-test 工作流程 (#3239) (#3257)
- chore：發行 0.12.3，開始 0.12.4.dev0 開發 (#3295)

## [0.12.3] - 2026-07-01

### 變更

- feat(copilot)：skills 預設推出前先發出警告 (#3256)
- 新增 2026 年 6 月電子報 (#3289)
- docs(toc)：將 Bundles 與 Authentication 加入 Reference 導覽 (#3267)
- fix(integrations)：將 zed 加入探索 catalog.json (#3266)
- fix(integrations)：cline hook 註記在 EOF 處與指令黏連 (#3263)
- refactor：將工作流程命令處理常式移至 workflows/_commands.py（PR-8/8）(#3159)
- chore：淘汰 Roo Code 整合——該擴充功能已關閉 (#3167) (#3212)
- fix(bundle)：允許以加入時相同的相對路徑執行 'catalog remove' (#3242)
- fix(workflows)：在 while/do-while 驗證中拒絕布林型 max_iterations (#3237)
- fix：允許相容性檢查接受預發行版的 spec-kit 版本 (#2695)
- chore：發行 0.12.2，開始 0.12.3.dev0 開發 (#3259)

## [0.12.2] - 2026-06-30

### 變更

- fix(scripts)：分支名稱縮寫保留的可攜式大寫處理（bash 3.2）(#3192)
- chore：淘汰 Windsurf 整合——已被 Cognition Devin 吸收 (#3168) (#3213)
- [extension] 將 Intake 擴充功能更新至 v0.1.3 (#3254)
- feat(workflows)：fan-out 透過有界執行緒集區遵循 max_concurrency (#3224)
- 將 Architecture Workflow 擴充功能更新至 v1.2.2 (#3255)
- 將 Repository Governance 擴充功能加入社群型錄 (#3252)
- 將 Workflow Preset 更新至 v1.3.11 (#3251)
- chore：淘汰 iflow 整合——產品已停產 (#3166) (#3211)
- docs(codebuddy)：修正失效的安裝連結與 CodeBuddy 大小寫 (#3172) (#3216)
- fix：在基底與預設集驗證器中拒絕無主機的型錄 URL (#3209) (#3227)
- chore：發行 0.12.1，開始 0.12.2.dev0 開發 (#3253)

## [0.12.1] - 2026-06-30

### 變更

- chore：讓 CI Python 矩陣與 devguide 生命週期一致，並修正 bash 3.2 可攜性 (#3244)
- fix：避免 check-prerequisites --paths-only 寫入 feature.json (#3025) (#3190)
- docs：記錄整合型錄子命令 (#3206)
- fix(scripts)：在 initialize-repo.sh 中使用 ASCII [OK] 標記（與 PowerShell 版本一致）(#3231)
- docs：記錄整合的 `search`/`info`/`scaffold` 子命令 (#3174) (#3194)
- docs：從 `specify check` 代理清單移除 Cursor (#3178) (#3193)
- fix(goose)：將 install_url 與文件改指向 goose-docs.ai (#3171) (#3215)
- fix(scripts)：在 setup-plan.ps1 中依 --json 路由 'Plan template not found'（與 bash 一致）(#3241)
- fix(bundle)：將命令錯誤送至 stderr，讓 --json 的 stdout 保持可解析 (#3235)
- chore：發行 0.12.0，開始 0.12.1.dev0 開發 (#3243)

## [0.12.0] - 2026-06-29

### 變更

- feat：讓 agent-context 擴充功能成為完整的選擇加入功能 (#3097)
- docs(workflows)：將內建 'init' 步驟類型加入 Step Types 表格 (#3234)
- fix(workflows)：gate 的 validate() 在選項為非字串時不得當機 (#3233)
- fix(workflows)：讓運算式中的管道篩選器偵測具引號感知 (#3232)
- fix(workflows)：在驗證時拒絕指向未知步驟的 fan-in wait_for (#3225)
- fix(scripts)：在 create-new-feature.ps1 中當規格範本缺失時發出警告（與 bash 一致）(#3230)
- fix(scripts)：在 PowerShell 中將僅含子目錄的目錄計為非空（與 bash 一致）(#3137)
- fix(scripts)：從 PowerShell git 擴充功能輸出移除 HAS_GIT（與 bash 一致）(#3195)
- 將 Product Spec Extension 更新至 v1.0.1 (#3226)
- chore：發行 0.11.10，開始 0.11.11.dev0 開發 (#3240)

## [0.11.10] - 2026-06-29

### 變更

- fix(extensions)：為 `extension add --from` 套用 GHES 驗證並解析發行成品 (#3217)
- fix(pi)：將 install_url 改指向 @earendil-works/pi-coding-agent (#3169) (#3214)
- fix(catalogs)：在基底與預設集驗證器中拒絕無主機的型錄 URL (#3210)
- fix：更新 CodeBuddy 安裝文件 URL (#3187)
- fix(workflows)：拒絕無限的數字輸入預設值，而非拋出 OverflowError (#3199)
- fix(scripts)：在 setup-plan.ps1 中產生 'Copied plan template' 狀態（與 bash 一致）(#3198)
- fix(workflows)：讓運算式運算子／常值解析具引號感知 (#3197)
- fix(scripts)：在 PowerShell create-new-feature 中遵循明確的 -Number 0（與 bash 一致）(#3196)
- 新增社群套件組投稿路徑 (#3162)
- Docs：記錄 /speckit.converge 命令 (#3181)
- chore：發行 0.11.9，開始 0.11.10.dev0 開發 (#3189)

## [0.11.9] - 2026-06-26

### 變更

- Docs：將 cline 與 zcode 加入多重安裝安全表格 (#3180)
- Docs：記錄缺少的旗標 --force 與 --refresh-shared-infra (#3179)
- fix(claude)：停止分叉 /speckit-analyze，避免長工作階段凍結 (#3188)
- fix：從 feature.json 推導 update-agent-context 的計畫路徑 (#3069)
- fix(catalog)：companion → README 文件、釘選版本的下載 URL、v0.11.0、更新標籤 (#2954)
- chore(deps)：將 actions/setup-python 從 6.2.0 升級至 6.3.0 (#3173)
- 將 SicarioSpec Core 預設集更新至 v0.5.1 (#3165)
- fix(extensions,presets,workflows)：透過 /api/v3 解析私有 GHES 發行成品 (#3157)
- 更新預設集組合策略參考 (#3143)
- fix(scripts)：PowerShell 分支名稱縮寫比對保持大小寫敏感（與 bash 一致）(#3129)
- fix(extensions)：告訴代理執行強制 hooks，而非僅產生指令 (#2901)
- 將 sicario-core 文件指向預設集 README (#3120)
- chore：發行 0.11.8，開始 0.11.9.dev0 開發 (#3156)

## [0.11.8] - 2026-06-24

### 變更

- docs：將 SpecKit Assistant npm 套件加入 Community Friends (#3142)
- 預設集投稿要求附上使用 Spec Kit CLI 語法的預設集使用 README (#3104)
- [extension] 將 Jira Integration (Sync Engine) 擴充功能更新至 v0.4.0 (#3152)
- 將 Spec Roadmap 擴充功能加入社群型錄 (#3153)
- feat(integration)：為 Kimi Code CLI 更新 Kimi 整合 (#2979)
- [extension] 將 Golden Demo 擴充功能加入社群型錄 (#3151)
- docs：在快速入門中於 /speckit.plan 後執行 /speckit.checklist (#3108)
- fix(workflows)：保留引號內清單常值元素的逗號 (#3134)
- ci：將 actions 釘選至 commit SHA 並新增 shellcheck (#3126)
- chore：發行 0.11.7，開始 0.11.8.dev0 開發 (#3154)

## [0.11.7] - 2026-06-24

### 變更

- feat(extensions)：安裝前驗證型錄封存檔的 sha256 (#3080)
- fix(workflows)：驗證 requires 鍵並拒絕幻影 permissions gate (#3079)
- fix(scripts)：PS 分支名稱的縮寫保留使用大小寫敏感比對 (#3130)
- feat(integrations)：新增 omp 支援 (#3107)
- fix：當命令主體含反斜線時呈現有效的 TOML (#3135)
- harden：拒絕 run_command 中的 shell=True (#3132)
- docs：新增 monorepo 指南 (#3084)
- fix(scripts)：將 check-prerequisites.ps1 的錯誤送至 stderr (#3123)
- fix：將 Codex 開發技能寫為檔案 (#2988)
- chore：發行 0.11.6，開始 0.11.7.dev0 開發 (#3121)

## [0.11.6] - 2026-06-23

### 變更

- [extension] 將 Spec Kit Preview 擴充功能更新至 v1.1.0，並同步 Firebender 代理清單 (#3116)
- 將 Spec Kit Discovery Extension 加入社群型錄 (#3119)
- 將 Architecture Workflow 擴充功能更新至 v1.2.1 (#3118)
- docs：釐清專案自訂的憲章條文 (#2994)
- 將 Intake 擴充功能加入社群型錄 (#3117)
- feat：新增 Firebender 整合（Android Studio / IntelliJ）(#3077)
- 將 DocGuard — CDD Enforcement 擴充功能更新至 v0.28.0 (#3115)
- chore：同步 issue 範本的代理清單 (#3052)
- fix(shared-infra)：移除核心不再隨附的過期受管理指令稿 (#3076) (#3098)
- chore：發行 0.11.5，開始 0.11.6.dev0 開發 (#3105)

## [0.11.5] - 2026-06-22

### 變更

- fix：在整合 use/upgrade 時為代理註冊已啟用的擴充功能 (#2949)
- 將 SicarioSpec Core 預設集加入社群型錄 (#3102)
- 將 Game Narrative Writing 預設集更新至 v1.1.0 (#3099)
- feat：新增 PyPI 發佈工作流程與 readme 中繼資料 (#2915)
- refactor：將擴充功能命令處理常式移至 extensions/_commands.py（PR-7/8）(#3014)
- feat：新增 ZCode (Z.AI) 整合 (#3063)
- fix(agent-context)：安全地支援多個上下文檔案 (#2969)
- 將 DocGuard — CDD Enforcement 擴充功能更新至 v0.27.0 (#3094)
- fix(presets)：隨附核心的原始碼檢出備援使用 _repo_root() (#3086) (#3091)
- chore：發行 0.11.4，開始 0.11.5.dev0 開發 (#3092)

## [0.11.4] - 2026-06-22

### 變更

- [extension] 將 Tasks to GitHub Project 擴充功能加入社群型錄 (#3090)
- 將 Linear Integration 擴充功能更新至 v0.7.0 (#3089)
- fix：未知的運算式篩選器出現時大聲失敗 (#3074)
- fix：在 .gitignore 中將 lib/ 與 lib64/ 模式錨定至儲存庫根目錄 (#3083)
- fix(build)：在建置的發行版中納入 specify_cli.bundler.lib (#3085)
- 強化命令註冊路徑處理 (#3088)
- fix(presets)：在預設集 SKILL.md 產生中保留 argument-hint (#2978)
- feat：在工作流程 run/resume 的 --json 酬載中呈現 gate 詳情 (#2965)
- feat：新增 `specify bundle` 命令 (#3070)
- chore：發行 0.11.3，開始 0.11.4.dev0 開發 (#3072)

## [0.11.3] - 2026-06-19

### 變更

- docs：強化代理揭露，涵蓋提交與每輪留言 (#3071)
- fix：隔離個別擴充功能的失敗，讓單一不良擴充功能不致拖累其餘 (#2951)
- fix(taskstoissues)：略過已有 GitHub issue 的任務 (#2992)
- feat(scripts)：新增 SPECIFY_INIT_DIR，可從儲存庫根目錄指定成員專案 (#2892)
- 將 Multi-Model Review 擴充功能更新至 v0.1.2 (#3066)
- chore(deps)：將 actions/checkout 從 6.0.3 升級至 7.0.0 (#3064)
- feat(claude)：在分叉的子代理中執行 /analyze (#2511)
- fix：在 git 擴充功能編號中計入 worktree 分支 (#3054)
- 將 Token Economy 擴充功能加入社群型錄 (#3049)
- chore：發行 0.11.2，開始 0.11.3.dev0 開發 (#3059)

## [0.11.2] - 2026-06-18

### 變更

- 將 Linear Integration 擴充功能更新至 v0.6.0 (#3047)
- fix：讓社群投稿工作流程與 bug-assess 標籤觸發一致 (#3046)
- fix(bug-assess)：重新編譯鎖檔，讓 github guard repos 為 'all' (#3036)
- fix(bug-assess)：設定 min-integrity: none，允許讀取外部使用者 issue (#3030)
- feat：新增 bug-assess 代理工作流程 (#3023)
- feat：新增 /speckit.converge 命令 (#3001)
- fix：在整合升級時保留 .vscode/settings.json 與指令稿的 +x 位元 (#3020)
- feat(workflows)：新增 from_json 運算式篩選器 (#2961)
- 新增 `init` 工作流程步驟，比照 `specify init` 啟動專案 (#2838)
- chore：發行 0.11.1，開始 0.11.2.dev0 開發 (#3022)

## [0.11.1] - 2026-06-17

### 變更

- chore：在 .gitignore 中忽略 Copilot 試用鷹架 (#3019)
- docs：釐清 Taskify 的 specify 命令 (#3016)
- docs：記錄在既有專案中演進規格的方法 (#2902)
- feat(workflows)：可選擇啟用的 output_format: json，將解析後的 shell stdout 公開為 output.data (#2963)
- fix：工作流程執行以失敗或中止結束時傳回非零結束碼 (#2959)
- fix(skills)：在技能 frontmatter 中保留非 ASCII 字元 (#2917)
- fix：避免擴充功能自我安裝時刪除來源目錄 (#2990) (#2991)
- fix：在 Windows 上停用 Rich Live 暫態模式，避免 PS 5.1 卡住 (#2938)
- 將 a11y-governance 預設集更新至 v0.4.0 (#2981)
- chore：發行 0.11.0，開始 0.11.1.dev0 開發 (#3012)

## [0.11.0] - 2026-06-16

### 變更

- 新增工作流程步驟型錄——可由社群安裝的步驟類型 (#2394)
- feat(dev)：新增整合鷹架工具 (#2685)
- 將 Command Density 預設集加入社群型錄 (#3006)
- fix(tests)：不透過 WSL-interop 的 powershell.exe 執行 PowerShell 測試 (#2971)
- 新增 Zed 整合 (#2780)
- 將 architecture-governance 預設集更新至 v0.5.0 (#2929)
- 將 Superpowers Implementation Bridge 擴充功能更新至 v1.1.0 (#3011)
- 將 isaqb-architecture-governance 預設集更新至 v0.2.0 (#2984)
- 將 security-governance 預設集更新至 v0.6.0 (#2932)
- chore：將 CITATION.cff 更新至 v0.10.2（2026-06-11）(#2966)
- chore：發行 0.10.4，開始 0.10.5.dev0 開發 (#3010)

## [0.10.4] - 2026-06-16

### 變更

- fix：當 fan-out 的 'items' 運算式未解析為清單時大聲失敗 (#2957)
- refactor：將預設集命令處理常式移至 presets/_commands.py（PR-6/8）(#2826)
- 將 agent-parity-governance 預設集更新至 v0.3.0 (#2982)
- 將 cross-platform-governance 預設集更新至 v0.2.0 (#2983)
- 將 Data Model Diagram 擴充功能加入社群型錄 (#2922)
- 將 Spec Kit TLDR 擴充功能加入社群型錄 (#3007)
- docs：新增處理複雜功能的指南 (#3004)
- 將 Loop Engineering 擴充功能加入社群型錄 (#3002)
- 將 MemoryLint 擴充功能更新至 v1.5.1 (#3000)
- chore：發行 0.10.3，開始 0.10.4.dev0 開發 (#2999)

## [0.10.3] - 2026-06-16

### 變更

- 將 Superpowers Bridge 擴充功能更新至 v1.6.0 (#2998)
- 將 Improve Extension 加入社群型錄 (#2997)
- 將 Product Forge 擴充功能更新至 v1.7.0 (#2996)
- 將 Linear Integration 擴充功能更新至 v0.5.0 (#2995)
- 將 Superpowers Implementation Bridge 擴充功能更新至 v1.0.3 (#2993)
- 將 Ralph 社群擴充功能更新至 v1.1.1 (#2861)
- 將 Linear Integration 擴充功能更新至 v0.4.0 (#2942)
- 將 DocGuard — CDD Enforcement 更新至 v0.26.0 (#2941)
- 將 SpecKit Companion 擴充功能加入社群型錄 (#2937)
- chore：發行 0.10.2，開始 0.10.3.dev0 開發 (#2936)

## [0.10.2] - 2026-06-11

### 變更

- 將 Research Harness 擴充功能加入社群型錄 (#2935)
- 將 Coding Standards Drift Control 擴充功能加入社群型錄 (#2934)
- 將 Spec Trace 擴充功能加入社群型錄 (#2527)
- fix(extensions)：在擴充功能的 Claude SKILL.md 中保留 argument-hint (#2916)
- fix(presets)：強化預設集 URL 安裝，防範不安全的重新導向 (#2911)
- fix：在 refresh_managed 覆寫檢查時略過還原的檔案 (#2918) (#2919)
- 將 multi-model-review 擴充功能更新至 v0.1.1 (#2900)
- feat：在擴充功能結構描述中將 category 與 effect 新增為第一級欄位 (#2899)
- chore(catalog)：新增 Jira Integration (Sync Engine) 擴充功能 (#2895)
- chore：發行 0.10.1，開始 0.10.2.dev0 開發 (#2910)

## [0.10.1] - 2026-06-09

### 變更

- 將 DocGuard — CDD Enforcement 擴充功能更新至 v0.25.1 (#2909)
- 將 a11y-governance 預設集更新至 v0.3.0 (#2867)
- docs：記錄規格持久化模型 (#2856)
- chore(catalog)：將 Linear Integration 升級至 v0.3.0（儲存庫更名為 spec-kit-linear-sync）(#2893)
- chore：將 DocGuard 擴充功能更新至 v0.25.0 (#2707)
- chore：從 _github_http.py 移除未使用的 open_github_url/_StripAuthOnRedirect (#2883)
- fix(catalogs)：驗證擴充功能與預設集型錄酬載的形狀 (#2621)
- feat(integration)：新增狀態回報 (#2674)
- chore：發行 0.10.0，開始 0.10.1.dev0 開發 (#2904)

## [0.10.0] - 2026-06-09

### 變更

- feat：讓 git 擴充功能改為選擇加入，並在 v0.10.0 移除 --no-git (#2873)
- [Preset] 更新 Fiction book writing 至 v1.9.0——支援插圖 (#2821)
- test(workflows)：涵蓋可執行檔覆寫備援的預檢 (#2843)
- 在 readme 中新增 GitHub Copilot CLI 指引 (#2891)
- 將 Security Review 擴充功能更新至 v1.5.3 (#2898)
- 將 Architecture Guard 擴充功能更新至 v1.8.17 (#2897)
- feat(extensions)：每事件的 hook 清單，具優先順序排序 (#2798)
- feat!：移除舊版 --ai、--ai-commands-dir 與 --ai-skills 旗標（0.10.0）(#2872)
- chore：發行 0.9.5，開始 0.9.6.dev0 開發 (#2875)

## [0.9.5] - 2026-06-05

### 變更

- feat(extensions)：新增隨附的錯誤分流工作流程擴充功能 (#2871)
- fix：解析私有儲存庫預設集與工作流程下載的 GitHub 發行成品 API URL (#2855)
- chore(deps)：將 github/gh-aw-actions 從 0.77.0 升級至 0.78.1 (#2860)
- chore(deps)：將 actions/checkout 從 6.0.2 升級至 6.0.3 (#2859)
- chore(deps)：將 astral-sh/setup-uv 從 8.1.0 升級至 8.2.0 (#2858)
- chore(deps)：將 github/codeql-action 從 4.36.0 升級至 4.36.2 (#2857)
- fix(workflows)：在互動提示中呈現 gate 的 show_file 內容 (#2810)
- feat：新增 rovodev 支援 (#2539)
- chore：發行 0.9.4，開始 0.9.5.dev0 開發 (#2853)

## [0.9.4] - 2026-06-04

### 變更

- feat(workflows)：為 workflow run resume 與 status 新增 JSON 輸出 (#2814)
- 將 workflow-preset 社群型錄更新至 v1.3.2 (#2841)
- fix：還原擴充功能使用中的技能註冊 (#2803)
- fix(cursor-agent)：端到端啟用無頭 CLI 派送（-p --trust --approve-mcps --force + Windows .cmd shim 解析）(#2631)
- 將 Superpowers Implementation Bridge 擴充功能更新至 v1.0.2 (#2852)
- docs(agents)：在 AGENTS.md 新增 PR 審查回應指引 (#2850)
- 允許 `specify workflow run` 在無專案時執行 YAML 檔案 (#2825)
- feat(extensions)：為 extension add 新增 --force 旗標，可覆寫重新安裝 (#2530)
- chore：發行 0.9.3，開始 0.9.4.dev0 開發 (#2836)

## [0.9.3] - 2026-06-03

### 變更

- fix：以使用中代理的分隔符呈現指令稿命令提示 (#2649)
- chore(tests)：修正 tests/ 中的 ruff lint 違規 (#2827)
- fix(workflows)：在 RunState.load 接觸檔案前先驗證 run_id… (#2813)
- feat(cli)：實作 specify self upgrade (#2475)
- feat(workflows)：允許 resume 接受更新後的工作流程輸入 (#2815)
- catalog：將 "superpowers-bridge" 更名為 "superspec"（v1.0.1）(#2772)
- fix(cli)：在 Windows 上強制 stdout/stderr 使用 UTF-8，避免 UnicodeEncodeError (#2817)
- fix(plan)：釐清 quickstart 驗證指南的範圍 (#2805)
- chore：發行 0.9.2，開始 0.9.3.dev0 開發 (#2823)

## [0.9.2] - 2026-06-02

### 變更

- 更新 agent parity governance 預設集型錄條目 (#2777)
- fix：解析私有儲存庫擴充功能下載的 GitHub 發行成品 API URL (#2792)
- fix：從 Copilot 技能模式移除不支援的 mode: frontmatter（修正 #2799）(#2819)
- refactor(integrations)：將整合命令集中放在 integrations/ 領域目錄（PR-5/8）(#2720)
- 將 Product Forge 擴充功能更新至 v1.6.0 (#2820)
- feat(workflows)：新增 continue_on_error 步驟欄位，用於不中斷的失敗 (#2663)
- chore：新增 .editorconfig，統一程式碼格式 (#2366)
- fix(shared-infra)：在 speckit.manifest.json 中記錄略過的檔案 (#2483)
- chore：發行 0.9.1，開始 0.9.2.dev0 開發 (#2818)

## [0.9.1] - 2026-06-02

### 變更

- fix(cli)：在 init-options 與 .extensionignore I/O 上釘選 UTF-8 編碼 (#2686)
- docs：在受支援整合表格中列出 Hermes (#2768)
- fix(copilot)：解析使用中的規格範本 (#2765)
- fix：為 Cline 的 _expected_files 補上缺少的 agent-context 擴充功能條目 (#2797)
- 將 spec-kit-linear 擴充功能加入社群型錄 (#2795)
- feat：新增原生 Cline 整合 (#2508)
- 更新 workflow-preset 社群型錄條目 (#2756)
- chore：發行 0.9.0，開始 0.9.1.dev0 開發 (#2794)
- 將 RAG Azure Builder 擴充功能加入社群型錄 (#2793)

## [0.9.0] - 2026-06-01

### 變更

- chore：重新編譯工作流程鎖檔 (#2774)
- 將 Multi-Sites Spec Kit 擴充功能加入社群型錄 (#2791)
- 將 Product Spec Extension 更新至 v0.8.3 (#2790)
- 發佈 2026 年 5 月電子報 (#2787)
- fix：將 URL 安裝確認提示移到進度旋轉圖示之前 (#2783) (#2784)
- 將 Reqnroll BDD 擴充功能更新至 v1.1.0 (#2775)
- 將代理上下文更新抽出為隨附的 agent-context 擴充功能 (#2546)
- chore(deps)：將 actions/setup-dotnet 從 5.2.0 升級至 5.3.0 (#2755)
- chore：發行 0.8.18，開始 0.8.19.dev0 開發 (#2766)

## [0.8.18] - 2026-05-29

### 變更

- 新增 SPECKIT_WORKFLOW_RUN_ID 覆寫支援 (#2742)
- feat：支援 SPECKIT_INTEGRATION_<KEY>_EXECUTABLE 環境變數 (#2743)
- chore(deps)：將 github/gh-aw-actions 從 0.74.8 升級至 0.77.0 (#2754)
- chore(deps)：將 github/codeql-action 從 4.35.5 升級至 4.36.0 (#2753)
- fix：停用型錄投稿工作流程的無操作 issue 回報 (#2748)
- 為基於 URL 的擴充功能安裝新增確認提示 (#2745)
- fix：將社群投稿工作流程限制為僅標籤事件 (#2741)
- feat(integrations)：支援 SPECIFY_<KEY>_EXTRA_ARGS 環境變數，用於代理子行程旗標 (#2596)
- chore：發行 0.8.17，開始 0.8.18.dev0 開發 (#2737)

## [0.8.17] - 2026-05-28

### 變更

- docs：整合 README 中的 Community 區段 (#2736)
- 修正整合分隔符共用指令稿的命令提示 (#2627)
- docs：將 security-governance 預設集更新至 v0.4.0 (#2703)
- feat(agy)：強化 Google Antigravity CLI 整合 (#2689)
- 修正 --dev 擴充功能代理符號連結 (#2554)
- 共用技能 hook 註記的後處理 (#2679)
- feat：新增 Hermes Agent 整合（含審查修正）(#2651)
- 將 Superpowers Implementation Bridge 更新至 v0.7.0 (#2732)
- chore：發行 0.8.16，開始 0.8.17.dev0 開發 (#2729)

## [0.8.16] - 2026-05-27

### 變更

- docs：更新首頁統計與分支命名慣例 (#2727)
- feat(workflows)：公開 {{ context.run_id }} 範本變數 (#2664)
- fix：在預設集技能呈現中解析 __SPECKIT_COMMAND_*__ 參照 (#2717) (#2718)
- 將 Workflow Preset 加入社群型錄 (#2725)
- fix：paths-only 略過分支驗證，setup-plan 保留既有計畫 (#2672)
- docs：修正失效的 pipx 首頁 URL，改指向 pipx.pypa.io (#2670)
- 將 Architecture Guard 擴充功能更新至 v1.8.9 (#2723)
- clarify 更新規格後，重新驗證規格品質檢核清單 (#2715)
- chore：發行 0.8.15，開始 0.8.16.dev0 開發 (#2722)

## [0.8.15] - 2026-05-27

### 變更

- 將 Fiction Book Writing 預設集更新至 v1.8.1 (#2714)
- chore：將 memorylint 與 superb 更新至 1.4.0 (#2690)
- fix：將執行後 hook 派送提升為 H2 並使用指令式語氣 (#2713)
- 將 Token Budget 擴充功能加入社群型錄 (#2712)
- fix：擴充功能／預設集安裝時依需求建立技能目錄 (#2711)
- fix：PS 5.1 相容——取代隨附 PowerShell 指令稿中的非 ASCII 字元 (#2709)
- docs：將 security-governance 預設集更新至 v0.3.0 (#2676)
- 更新 README.md (#2675)
- chore：發行 0.8.14，開始 0.8.15.dev0 開發 (#2706)

## [0.8.14] - 2026-05-26

### 變更

- 新增 Windows 子行程工具 (#2598)
- refactor：建立 commands/ 套件並移入 init 處理常式（PR-4/8）(#2615)
- 將 Product Spec Extension 加入社群型錄 (#2705)
- 修正 init-options 的 speckit 版本重新整理 (#2647)
- chore(deps)：將 github/gh-aw-actions 從 0.74.8 升級至 0.74.9 (#2658)
- docs：在 AGENTS.md 與 CONTRIBUTING.md 新增分支命名慣例 (#2678)
- chore(deps)：將 actions/stale 從 10.2.0 升級至 10.3.0 (#2657)
- chore(deps)：將 github/codeql-action 從 4.35.4 升級至 4.35.5 (#2656)
- chore：發行 0.8.13，開始 0.8.14.dev0 開發 (#2669)

## [0.8.13] - 2026-05-21

### 變更

- fix：while/do-while 迴圈條件讀取過期的第 0 次迭代步驟輸出 (#2662)
- docs：修正 README 範例中的目錄階層 (#2639)
- fix(catalogs)：在擴充功能與預設集型錄讀取器中拒絕布林型優先順序 (#2589)
- 將 Agent Governance 擴充功能更新至 v1.2.0 (#2659)
- 為社群型錄投稿新增代理工作流程 (#2655)
- feat：在 check 輸出中新增自我檢查提示 (#2574)
- fix(cli)：釐清例外診斷 (#2602)
- ci：新增 diff 空白檢查 (#2572)
- chore：發行 0.8.12，開始 0.8.13.dev0 開發 (#2648)

## [0.8.12] - 2026-05-20

### 變更

- fix(codex)：在 Codex 技能中注入點轉連字號的 hook 命令註記 (#2503)
- 將 Squad Bridge 擴充功能更新至 v1.3.0 (#2645)
- 將 Superpowers Implementation Bridge 擴充功能更新至 v0.5.0 (#2644)
- 將 Team Assign 擴充功能加入社群型錄 (#2642)
- refactor：將擴充功能型錄堆疊解析遷移至共用基底 (#2576)
- 將 Architecture Workflow 擴充功能更新至 v1.1.0 (#2588)
- fix(workflow)：支援 integration: auto，遵循專案已初始化的 AI (#2421)
- 將 Superpowers Implementation Bridge 擴充功能加入社群型錄 (#2586)
- 將 Interactive HTML Preview 擴充功能加入社群型錄 (#2585)
- chore：發行 0.8.11，開始 0.8.12.dev0 開發 (#2584)
- 將 Agent Governance 擴充功能更新至 v1.1.0 (#2583)

## [0.8.11] - 2026-05-15

### 變更

- refactor：從 __init__.py 抽出 _version.py（PR-3/8）(#2550)
- 將 Time Machine 擴充功能加入社群型錄 (#2580)
- fix(powershell)：確保 UTF-8 範本寫入時不帶 BOM (#2280)
- docs：記錄高保證規格工作流程 (#2518)
- docs：修正目錄樹範例中的指令稿名稱 (#2555)
- 修正預設集技能說明的優先順序 (#2538)
- fix(integration)：釐清多重安裝指引 (#2549)
- feat：新增版本功能回報 (#2548)
- 將 Architecture Workflow 擴充功能加入社群型錄 (#2565)
- chore：發行 0.8.10，開始 0.8.11.dev0 開發 (#2562)

## [0.8.10] - 2026-05-14

### 變更

- docs：精簡安裝區段並新增社群總覽 (#2561)
- 將社群擴充功能表格從 README 移至文件站 (#2560)
- 將 Agent Governance 擴充功能加入社群型錄 (#2559)
- 將 Reqnroll BDD 擴充功能加入社群型錄 (#2545)
- fix(cli)：強化擴充功能註冊與探索工作流程 (#2499)
- refactor：從 __init__.py 抽出 _assets.py 與 _utils.py（PR-2/8）(#2543)
- fix(opencode)：使用 commands/ 目錄（複數），與 OpenCode 文件一致 (#2453)
- refactor：從 __init__.py 抽出 _console.py（PR-1/8）(#2474)
- 修正 README 中的憲章參照 (#2491)
- chore：發行 0.8.9，開始 0.8.10.dev0 開發 (#2532)

## [0.8.9] - 2026-05-12

### 變更

- docs：以四支柱卡片版面改版首頁 (#2531)
- feat(extensions)：將治理生態系統擴充功能更新至最新版本 (#2514)
- 新增 changelog 擴充功能 (#2177)
- 在 docfx.json 檔案參照中新增安裝目錄 (#2522)
- feat(catalog)：新增 BrownKit (brownkit) 社群擴充功能 (#2510) (#2520)
- fix(kiro-cli)：以散文備援取代常值 $ARGUMENTS (#2482)
- Preset：將 game-narrative-writing 預設集加入社群型錄 (#2454)
- docs：釐清 CLI 升級探索 (#2519)
- fix：讓範本中繼資料的換行符合 markdownlint 規範 (#2505)
- refactor(catalogs)：抽出整合型錄設定載入 (#2497)
- test(presets)：在自我測試組合中靜默預期的 UserWarnings… (#2373)
- chore：發行 0.8.8，開始 0.8.9.dev0 開發 (#2516)

## [0.8.8] - 2026-05-11

### 變更

- chore(deps)：將 actions/checkout 從 4.3.1 升級至 6.0.2 (#2486)
- feat(catalog)：新增 Spec Kit Schedule (schedule) 社群擴充功能 (#2473)
- fix(integration)：在 `integration switch` 時重新整理共用基礎架構 (#2375)
- 將 MDE 預設集加入社群型錄 (#2513)
- 將 MDE 擴充功能加入社群型錄 (#2512)
- chore：以最新擴充功能版本更新社群型錄 (#2490)
- chore(deps)：將 actions/setup-dotnet 從 4.3.1 升級至 5.2.0 (#2489)
- chore(deps)：將 actions/github-script 從 7 升級至 9 (#2488)
- chore(deps)：升級 DavidAnson/markdownlint-cli2-action (#2487)
- chore(deps)：將 github/codeql-action 從 4.35.3 升級至 4.35.4 (#2485)
- feat(catalog)：新增 API Evolve (api-evolve) 社群擴充功能 (#2479)
- feat：設定驅動、可選擇加入的驗證註冊表，支援多平台 (#2393)
- chore：發行 0.8.7，開始 0.8.8.dev0 開發 (#2480)

## [0.8.7] - 2026-05-07

### 變更

- feat：將 agent-orchestrator 加入社群擴充功能型錄 (#2236)
- chore：更新社群型錄中的擴充功能版本 (#2468)
- fix(goose)：在產生的 recipe 中宣告 args 參數 (#2402)
- feat：新增 lingma 支援 (#2348)
- docs：新增 uv 安裝指南與行內提示框 (#2465)
- 將 fx-to-dotnet 加入社群擴充功能型錄 (#2471)
- fix：非互動 init 預設使用 copilot 整合 (#2414)
- fix(forge)：在 Forge 整合中對命令參照使用連字號表示法 (#2462)
- feat(catalog)：新增 Cost Tracker (cost) 社群擴充功能 (#2448)
- chore：發行 0.8.6，開始 0.8.7.dev0 開發 (#2463)

## [0.8.6] - 2026-05-06

### 變更

- 在 `/speckit.implement` 中載入憲章上下文，在實作期間強制治理 (#2460)
- feat：改善型錄投稿範本與 CODEOWNERS (#2401)
- fix：在 build_github_request 中驗證 URL 格式 (#2449)
- 將 Architecture Guard 加入社群型錄 (#2430)
- 將 multi-model-review 擴充功能加入社群型錄 (#2446)
- 將 Ralph Loop 更新至 v1.0.2 (#2435)
- 依 SHA 釘選 GitHub Actions (#2441)
- fix(workflows)：catalog list 要求必須有專案 (#2436)
- 將 agent-parity-governance 加入社群型錄 (#2382)
- chore：發行 0.8.5，開始 0.8.6.dev0 開發 (#2447)

## [0.8.5] - 2026-05-04

### 變更

- feat(presets)：新增 Spec2Cloud 預設集，用於 Azure 部署工作流程 (#2413)
- 將 security-review 與 memory-md 擴充功能更新至最新版本 (#2445)
- fix：遵循 tasks-template 的範本覆寫 (#2278) (#2292)
- 將 token-analyzer 加入社群型錄 (#2433)
- docs：新增 2026 年 4 月電子報 (#2434)
- feat：為 git 擴充功能預設變更發出 init 階段通知 (#2165) (#2432)
- 更新 DyanGalih（Memory Hub 與 Security Review）社群擴充功能 (#2429)
- 支援安全的 AI 代理整合的受控多重安裝 (#2389)
- chore(integrations)：清理文件與專案防護 (#2428)
- chore：發行 0.8.4，開始 0.8.5.dev0 開發 (#2431)

## [0.8.4] - 2026-05-01

### 變更

- fix(specify)：修正驗證流程中自我參照的步驟編號 (#2152)
- chore(deps)：升級 DavidAnson/markdownlint-cli2-action (#2425)
- 將 security-governance 加入社群型錄 (#2386)
- 將 cross-platform-governance 加入社群型錄 (#2384)
- 將 architecture-governance 加入社群型錄 (#2383)
- 將 a11y-governance 加入社群型錄 (#2381)
- feat(extensions)：新增 Spec2Cloud 擴充功能，用於 Azure 部署工作流程 (#2412)
- fix：在整合切換時遷移擴充功能命令 (#2404)
- feat：將 Squad Bridge 擴充功能加入社群型錄 (#2417)
- chore：發行 0.8.3，開始 0.8.4.dev0 開發 (#2418)

## [0.8.3] - 2026-04-29

### 變更

- 將 Work IQ 擴充功能加入社群型錄 (#2415)
- feat(integrations)：新增 Devin for Terminal 技能式整合 (#2364)
- fix：在升級提示中納入 --from git+...，避免 PyPI 搶註套件 (#2411)
- fix：透過 run 派送 opencode 命令 (#2410)
- feat：新增型錄探索 CLI 命令 (#2360)
- 將 security review 擴充功能型錄更新至 v1.3.0 (#2374)
- chore(catalog)：將 v-model 擴充功能升級至 v0.6.0 (#2399)
- feat：將 threatmodel 擴充功能加入社群型錄 (#2369)
- 將 isaqb-architecture-governance 加入社群型錄 (#2385)
- chore：發行 0.8.2，開始 0.8.3.dev0 開發 (#2397)

## [0.8.2] - 2026-04-28

### 變更

- 將 MarkItDown Document Converter 擴充功能加入社群型錄 (#2390)
- feat：Speckit preset fiction book v1.7——支援 RAG（Chroma DB）離線語義搜尋 (#2367)
- fix(extensions)：讀取資訊清單 YAML 時使用明確的 UTF-8 編碼 (#2370)
- catalog：新增 m365 社群擴充功能
- docs：在所有文件中以 --integration 取代已棄用的 --ai 旗標 (#2359)
- feat(extensions,presets)：以 GITHUB_TOKEN/GH_TOKEN 驗證託管於 GitHub 的型錄與下載請求 (#2331)
- 在社群型錄中將 extensify 更新至 v1.1.0 (#2337)
- feat(init)：棄用 --no-git 旗標，棄用事項於 v0.10.0 生效 (#2357)
- 將 Spec Orchestrator 擴充功能加入社群型錄 (#2350)
- chore：發行 0.8.1，開始 0.8.2.dev0 開發 (#2356)

## [0.8.1] - 2026-04-24

### 變更

- fix(plan)：使用 .specify/feature.json，讓 /speckit.plan 可在自訂 git 分支上運作 (#2305) (#2349)
- feat(vibe)：從舊的提示式 MarkdownIntegration 遷移至 SkillsIntegration (#2336)
- docs：將社群預設集表格移至文件站，並補上缺少的條目 (#2341)
- docs(presets)：新增精簡的預設集 README 並豐富型錄中繼資料 (#2340)
- fix：依整合類型解析命令參照（點號與連字號）(#2354)
- 在社群型錄中將 product-forge 更新至 v1.5.1 (#2352)
- chore(deps)：將 astral-sh/setup-uv 從 8.0.0 升級至 8.1.0 (#2345)
- fix：以 sed 取代 xargs trim，處理說明中的引號 (#2351)
- feat：在社群型錄中註冊 jira 預設集 (#2224)
- feat：Preset screenwriting (#2332)
- chore：發行 0.8.0，開始 0.8.1.dev0 開發 (#2333)

## [0.8.0] - 2026-04-23

### 變更

- feat(presets)：範本、命令與指令稿的組合策略（prepend、append、wrap）(#2133)
- feat(copilot)：支援 `--integration-options="--skills"`，用於技能式鷹架 (#2324)
- docs(install)：新增 pipx 作為替代安裝方式 (#2288)
- 新增 Memory MD 社群擴充功能 (#2327)
- 將 version-guard 更新至 v1.2.0 (#2321)
- fix：`--force` 現在會在 init 與 upgrade 時覆寫共用基礎架構檔案 (#2320)
- chore：發行 0.7.5，開始 0.7.6.dev0 開發 (#2322)

## [0.7.5] - 2026-04-22

### 變更

- fix：為所有 SKILL.md 代理解析技能佔位符，而非僅 codex/kimi (#2313)
- feat(cli)：新增 specify self check 與 self upgrade stub (#2316)
- 將 version-guard 更新至 v1.1.0 (#2318)
- docs：將社群預設集從 README 移至 docs/community (#2314)
- catalog：新增 wireframe 擴充功能（v0.1.1）(#2262)
- 將社群走查從 README 移至 docs/community (#2312)
- docs(readme)：在 community-extensions 表格中列出 red-team (#2311)
- feat(catalog)：將 red-team 擴充功能加入社群型錄 (#2306)
- 新增 superpowers-bridge 社群擴充功能 (#2309)
- feat：實作預設集 wrap 策略 (#2189)
- fix(agents)：阻擋命令寫入路徑中的目錄遍歷 (#2229) (#2296)
- chore：發行 0.7.4，開始 0.7.5.dev0 開發 (#2299)

## [0.7.4] - 2026-04-21

### 變更

- fix(copilot)：在非互動模式下使用 --yolo 授予所有權限 (#2298)
- feat：新增 CITATION.cff 與 .zenodo.json，支援學術引用 (#2291)
- 將 spec-validate 加入社群型錄 (#2274)
- feat：在社群型錄中註冊 Ripple (#2272)
- 將 version-guard 加入社群型錄 (#2286)
- 將 spec-reference-loader 加入社群型錄 (#2285)
- 將 memory-loader 加入社群型錄 (#2284)
- fix(integrations)：讀取代理上下文檔案時去除 UTF-8 BOM (#2283)
- Preset fiction book writing1.6 (#2270)
- fix(integrations)：將 Antigravity (agy) 版面遷移至 .agents/ 並棄用 --skills (#2276)
- chore：發行 0.7.3，開始 0.7.4.dev0 開發 (#2263)

## [0.7.3] - 2026-04-17

### 變更

- fix：以標記式 upsert 取代基於 shell 的上下文更新 (#2259)
- 在文件站新增 Community Friends 頁面 (#2261)
- 將 Spec Scope 擴充功能加入社群型錄 (#2172)
- docs：在 README 新增社群維護的 Claude Code 與 GitHub Copilot CLI 外掛，透過外掛市集安裝 Spec Kit 技能 (#2250)
- fix：在 auto-commit.ps1 中抑制 CRLF 警告 (#2258)
- feat：在社群型錄中註冊 Blueprint (#2252)
- preset：將 preset-fiction-book-writing 更新至社群型錄 -> v1.5.0 (#2256)
- chore(deps)：將 actions/upload-pages-artifact 從 3 升級至 5 (#2251)
- fix：將 reference/*.md 加入 docfx 內容 glob (#2248)
- chore：發行 0.7.2，開始 0.7.3.dev0 開發 (#2247)

## [0.7.2] - 2026-04-16

### 變更

- docs：新增核心命令參考並精簡 README 的 CLI 區段 (#2245)
- docs：新增工作流程參考、重組至 docs/reference/，並新增 --version 旗標 (#2244)
- docs：新增預設集參考頁面，並將 pack_id 更名為 preset_id (#2243)
- docs：新增擴充功能參考頁面與整合 FAQ (#2242)
- docs：將整合文件整合至 docs/integrations.md (#2241)
- feat：將 memorylint 與 superpowers-bridge 版本更新至 1.3.0，並提供新的下載 URL (#2240)
- feat：整合型錄——探索、版本與社群散佈 (#2130)
- 將 Catalog CI 擴充功能加入社群型錄 (#2239)
- 新增 issues 擴充功能 (#2194)
- chore：發行 0.7.1，開始 0.7.2.dev0 開發 (#2235)

## [0.7.1] - 2026-04-15

### 變更

- ci：將 windows-latest 加入測試矩陣 (#2233)
- docs：從本機開發指南移除已棄用的 --skip-tls 參照 (#2231)
- fix：允許 Claude 為 hook 執行鏈結技能 (#2227)
- docs：將 TESTING.md 合併進 CONTRIBUTING.md，並移除 TESTING.md (#2228)
- 將 agent-assign 擴充功能加入社群型錄 (#2030)
- fix：非官方 PyPI 警告 (#1982) 與舊版擴充功能命令名稱自動修正 (#2017) (#2027)
- feat：在社群型錄中註冊 architect-preview (#2214)
- chore：在 specify init 上以 --integration 取代並棄用 --ai 旗標 (#2218)
- chore：發行 0.7.0，開始 0.7.1.dev0 開發 (#2217)

## [0.7.0] - 2026-04-14

### 變更

- 新增具型錄系統的工作流程引擎 (#2158)
- docs(catalog)：將 claude-ask-questions 加入社群預設集型錄 (#2191)
- 新增 SFSpeckit — Salesforce SDD Extension (#2208)
- feat(scripts)：gitflow 可選的單段分支前綴 (#2202)
- chore：發行 0.6.2，開始 0.6.3.dev0 開發 (#2205)
- 將 Worktrees 擴充功能加入社群型錄 (#2207)
- feat：更新 preset-fiction-book-writing 的 catalog.community.json (#2199)

## [0.6.2] - 2026-04-13

### 變更

- feat：註冊 "What-if Analysis" 社群擴充功能 (#2182)
- feat：將 GitHub Issues Integration 加入社群型錄 (#2188)
- feat(agents)：新增 Goose AI 代理支援 (#2015)
- 在社群型錄中將 ralph 擴充功能更新至 v1.0.1 (#2192)
- fix：在 fork 上略過文件部署工作流程 (#2171)
- chore：發行 0.6.1，開始 0.6.2.dev0 開發 (#2162)

## [0.6.1] - 2026-04-10

### 變更

- feat：新增隨附的精簡預設集，含最少的工作流程命令 (#2161)
- 將 Brownfield Bootstrap 擴充功能加入社群型錄 (#2145)
- 將 CI Guard 擴充功能加入社群型錄 (#2157)
- 將 SpecTest 擴充功能加入社群型錄 (#2159)
- fix：隨附擴充功能不應有下載 URL (#2155)
- 將 PR Bridge 擴充功能加入社群型錄 (#2148)
- feat(cursor-agent)：從 .cursor/commands 遷移至 .cursor/skills (#2156)
- 將 TinySpec 擴充功能加入社群型錄 (#2147)
- chore：將 spec-kit-verify 升級至 1.0.3、spec-kit-review 升級至 1.0.1 (#2146)
- 將 Status Report 擴充功能加入社群型錄 (#2123)
- chore：發行 0.6.0，開始 0.6.1.dev0 開發 (#2144)

## [0.6.0] - 2026-04-09

### 變更

- 將 Bugfix Workflow 社群擴充功能加入型錄與 README (#2135)
- 將 Worktree Isolation 擴充功能加入社群型錄 (#2143)
- 將 multi-repo-branching 預設集加入社群型錄 (#2139)
- README 釐清 (#2013)
- 為整合架構重寫 AGENTS.md (#2119)
- docs：在 Community Friends 區段新增 SpecKit Companion (#2140)
- feat：將 memorylint 擴充功能加入社群型錄 (#2138)
- chore：發行 0.5.1，開始 0.5.2.dev0 開發 (#2137)

## [0.5.1] - 2026-04-08

### 變更

- fix：釘選 typer>=0.24.0 與 click>=8.2.1，修正匯入當機 (#2136)
- feat：將 fleet 擴充功能更新至 v1.1.0 (#2029)
- fix(forge)：在 frontmatter 的 name 欄位使用連字號表示法 (#2075)
- fix(bash)：update-agent-context.sh 中的 sed 取代逸出、BSD 可攜性與無效清理 (#2090)
- 將 Spec Diagram 社群擴充功能加入型錄與 README (#2129)
- feat：Git 擴充功能第 2 階段——GIT_BRANCH_NAME 覆寫、既有目錄的 --force、自動安裝測試 (#1940) (#2117)
- fix(git)：呈現既有分支的 checkout 錯誤 (#2122)
- 將 Branch Convention 社群擴充功能加入型錄與 README (#2128)
- docs：精簡 2026 年 3 月電子報，提升可讀性 (#2127)
- fix：還原社群擴充功能的別名相容性 (#2110) (#2125)
- 新增 2026 年 3 月電子報 (#2124)
- 將 Spec Refine 社群擴充功能加入型錄與 README (#2118)
- 將 explicit-task-dependencies 社群預設集加入型錄與 README (#2091)
- 將 toc-navigation 社群預設集加入型錄與 README (#2080)
- fix：避免主體以 `\"` 結尾時 TOML 結束引號產生歧義 (#2113) (#2115)
- 修正 trae 的 speckit 問題 (#2112)
- feat：Git 擴充功能第 1 階段——隨附的 `extensions/git`，在所有核心命令上設有 hooks (#1941)
- 將 confluence 擴充功能升級至 v.1.1.1 (#2109)
- 將 V-Model Extension Pack 更新至 v0.5.0 (#2108)
- 新增 canon 擴充功能與 canon-core 預設集。(#2022)
- [stage2] fix：在舊版 TOML 呈現器中序列化多行說明 (#2097)
- [stage1] fix：從 TOML 整合提示中去除 YAML frontmatter (#2096)
- 新增 Confluence 擴充功能 (#2028)
- fix：在測試與文件中接受 4 位數以上的規格編號 (#2094)
- fix(scripts)：改善 git 分支建立的錯誤處理 (#2089)
- 將 optimize 擴充功能加入社群型錄 (#2088)
- feat：新增 "VS Code Ask Questions" 預設集 (#2086)
- 將 security-review v1.1.1 加入社群擴充功能型錄 (#2073)
- 新增 `specify integration` 子命令，用於 init 後的整合管理 (#2083)
- 從 CLI 移除範本版本資訊、修正 Claude user-invocable、清理無效程式碼 (#2081)
- fix：在技能 frontmatter 中新增 user-invocable: true (#2077)
- fix：為 stale 工作流程新增 actions:write 權限 (#2079)
- feat：為 Claude Code 命令新增 argument-hint frontmatter (#1951) (#2059)
- 將 conduct 擴充功能更新至 v1.0.1 (#2078)
- chore(deps)：將 astral-sh/setup-uv 從 7.6.0 升級至 8.0.0 (#2072)
- chore(deps)：將 actions/configure-pages 從 5 升級至 6 (#2071)
- feat：將 spec-kit-fixit 擴充功能加入社群型錄 (#2024)
- chore：發行 0.5.0，開始 0.5.1.dev0 開發 (#2070)
- feat：新增 Forgecode 代理支援 (#2034)

## [0.5.0] - 2026-04-02

### 變更

- 引入 DEVELOPMENT.md (#2069)
- 在 Community Friends 中將 cc-sdd 參照更新為 cc-spex (#2007)
- chore：發行 0.4.5，開始 0.4.6.dev0 開發 (#2064)

## [0.4.5] - 2026-04-02

### 變更

- 第 6 階段：完成遷移——移除舊版鷹架路徑 (#1924) (#2063)
- 將 Claude Code 安裝為原生技能，並對齊預設集／整合流程 (#2051)
- 新增 repoindex 0402 (#2062)
- 第 5 階段：Skills、Generic 與 Option-Driven 整合 (#1924) (#2052)
- feat(scripts)：為 create-new-feature 新增 --dry-run 旗標 (#1998)
- fix：支援 4 位數以上的功能分支編號 (#2040)
- 新增社群內容免責聲明 (#2058)
- docs：在 README 與擴充功能文件中新增社群擴充功能網站連結 (#2014)
- docs：移除失效的 Cognitive Squad 與 Understanding 擴充功能連結，並從 extensions/catalog.community.json 移除 (#2057)
- 將 fix-findings 擴充功能加入社群型錄 (#2039)
- 第 4 階段：TOML 整合——gemini 與 tabnine 遷移至外掛架構 (#2050)
- feat：將 5 個生命週期擴充功能加入社群型錄 (#2049)
- 第 3 階段：標準 markdown 整合——19 個代理遷移至外掛架構 (#2038)
- chore：發行 0.4.4，開始 0.4.5.dev0 開發 (#2048)

## [0.4.4] - 2026-04-01

### 變更

- 第 2 階段：Copilot 整合——以共用範本基元做概念驗證 (#2035)
- docs：讓 AGENTS.md 與 AGENT_CONFIG 同步，補上缺少的代理 (#2025)
- docs：確保手動測試使用本機 specify (#2020)
- 第 1 階段：整合基礎——基底類別、資訊清單系統與註冊表 (#1925)
- fix：強化 GitHub Actions 工作流程 (#2021)
- chore：發行後在 main 上使用 PEP 440 的 .dev0 版本 (#2032)
- feat：將 superpowers bridge 擴充功能加入社群型錄 (#2023)
- feat：將 product-forge 擴充功能加入社群型錄 (#2012)
- feat(scripts)：為 create-new-feature 新增 --allow-existing-branch 旗標 (#1999)
- fix(scripts)：為 copilot-instructions.md 新增正確路徑 (#1997)
- 更新 README.md (#1995)
- fix：避免擴充功能命令被遮蔽 (#1994)
- 修正 npm 本機安裝的 Claude Code CLI 偵測 (#1978)
- fix(scripts)：遵循 PowerShell 代理與指令稿篩選器 (#1969)
- feat：將 MAQA 擴充功能套件（7 個擴充功能）加入社群型錄 (#1981)
- feat：將 spec-kit-onboard 擴充功能加入社群型錄 (#1991)
- 將 plan-review-gate 加入社群型錄 (#1993)
- chore(deps)：將 actions/deploy-pages 從 4 升級至 5 (#1990)
- chore(deps)：將 DavidAnson/markdownlint-cli2-action 從 19 升級至 23 (#1989)
- chore：將版本升級至 0.4.3 (#1986)

## [0.4.3] - 2026-03-26

### 變更

- 統一 Kimi/Codex 技能命名，並遷移舊版帶點的 Kimi 目錄 (#1971)
- fix(ps1)：以相容 PowerShell 5.1 的方式取代 null 條件運算子 (#1975)
- chore：將版本升級至 0.4.2 (#1973)

## [0.4.2] - 2026-03-25

### 變更

- feat：在適用時自動為擴充功能註冊 ai-skills (#1840)
- docs：新增斜線命令驗證的手動測試指南 (#1955)
- 將 AIDE、Extensify 與 Presetify 加入社群擴充功能 (#1961)
- docs：在主 README 新增社群預設集區段 (#1960)
- docs：將社群擴充功能表格移至主 README，提升可發現性 (#1959)
- docs(readme)：整合 Community Friends 區段並修正 ToC 錨點 (#1958)
- fix(commands)：在 analyze 與 clarify 中將 NFR 參照更名為成功標準 (#1935)
- 在 README 新增 Community Friends 區段 (#1956)
- docs：新增 Community Friends 區段，含 Spec Kit Assistant VS Code 擴充功能 (#1944)

## [0.4.1] - 2026-03-24

### 變更

- 新增 checkpoint 擴充功能 (#1947)
- fix(scripts)：儲存庫根目錄偵測優先 .specify 而非 git (#1933)
- docs：在社群專案中新增 AIDE 擴充功能展示 (#1943)
- fix(templates)：為規格範本補上缺少的 Assumptions 區段 (#1939)

## [0.4.0] - 2026-03-23

### 變更

- fix(cli)：為 YAML I/O 新增 allow_unicode=True 與 encoding="utf-8" (#1936)
- fix(codex)：原生技能備援重新整理 + 舊版提示抑制 (#1930)
- feat(cli)：將核心套件嵌入 wheel，支援離線／氣隙部署 (#1803)
- ci：將 stale 工作流程的 operations-per-run 提高至 250 (#1922)
- docs：更新發佈指南，新增 Category 與 Effect 欄位 (#1913)
- fix：讓原生技能 frontmatter 與 install_ai_skills 一致 (#1920)
- feat：為 `specify init` 新增基於時間戳記的分支命名選項 (#1911)
- docs：新增社群擴充功能的 Extension Comparison Guide (#1897)
- docs：更新 SUPPORT.md、修正 issue 範本、新增預設集投稿範本 (#1910)
- 新增 Junie 支援 (#1831)
- feat：將 Codex/agy init 遷移至原生技能工作流程 (#1906)

## [0.3.2] - 2026-03-19

### 變更

- 將 conduct 擴充功能加入社群型錄 (#1908)
- feat(extensions)：將 verify-tasks 擴充功能加入社群型錄 (#1871)
- feat(presets)：新增啟用／停用切換與更新語義 (#1891)
- feat：新增 iFlow CLI 支援 (#1875)
- feat(commands)：將 before/after hook 事件接入 specify 與 plan 範本 (#1886)
- docs(catalog)：將 speckit-utils 加入社群型錄 (#1896)
- docs：在 README 新增 Extensions & Presets 區段 (#1898)
- chore：將 DocGuard 擴充功能更新至 v0.9.11 (#1899)
- 更新 cognitive-squad 型錄條目——Triadic Model、完整生命週期 (#1884)
- feat：註冊 spec-kit-iterate 擴充功能 (#1887)
- fix(scripts)：為 PowerShell create-new-feature 參數新增明確的位置綁定 (#1885)
- fix(scripts)：將殘留的 JSON 控制字元編碼為 \uXXXX，而非去除 (#1872)
- chore：將 DocGuard 擴充功能更新至 v0.9.10 (#1890)
- Feature/spec kit add pi coding agent pullrequest (#1853)
- feat：註冊 spec-kit-learn 擴充功能 (#1883)

## [0.3.1] - 2026-03-17

### 變更

- docs：在 README 新增 greenfield Spring Boot 海盜語預設集展示 (#1878)
- fix(ai-skills)：從技能中排除非 speckit 的 copilot 代理 markdown (#1867)
- feat：新增 Trae IDE 支援，作為新代理 (#1817)
- feat(cli)：對 settings.json 採寬容的深層合併，並支援 JSONC (#1874)
- feat(extensions,presets)：新增基於優先順序的解析排序 (#1855)
- fix(scripts)：在 create-new-feature.sh 中抑制 git fetch 的 stdout (#1876)
- fix(scripts)：強化 bash 指令稿——逸出、相容性與錯誤處理 (#1869)
- 將 cognitive-squad 加入社群擴充功能型錄 (#1870)
- docs：在社群走查中新增 Go / React brownfield 走查 (#1868)
- chore：將 DocGuard 擴充功能更新至 v0.9.8 (#1859)
- Feature：新增 specify status 命令 (#1837)
- fix(extensions)：在清單輸出中顯示擴充功能 ID (#1843)
- feat(extensions)：將 Archive 與 Reconcile 擴充功能加入社群型錄 (#1844)
- feat：將 DocGuard CDD enforcement 擴充功能加入社群型錄 (#1838)

## [0.3.0] - 2026-03-13

### 變更

- feat(presets)：可插拔的預設集系統，含型錄、解析器與技能傳播 (#1787)
- fix：比對 'Last updated' 時間戳記時不論有無粗體標記 (#1836)
- 新增 specify doctor 命令，用於專案健康診斷 (#1828)
- fix：強化 bash 指令稿，防範 shell 注入並提升穩健性 (#1809)
- fix：清理命令範本（specify、analyze）(#1810)
- fix：將 Qwen Code CLI 從 TOML 遷移至 Markdown 格式 (#1589) (#1730)
- fix(cli)：棄用 agy 的明確命令支援 (#1798) (#1808)
- 新增 /selftest.extension 核心擴充功能，用於測試其他擴充功能 (#1758)
- feat(extensions)：為符合 RFC 的型錄整合提供生活品質改善 (#1776)
- 在社群走查中新增 Java brownfield 走查 (#1820)

## [0.2.1] - 2026-03-11

### 變更

- 新增 2026 年 2 月電子報 (#1812)
- feat：新增 Kimi Code CLI 代理支援 (#1790)
- docs：修正快速入門指南中的失效連結 (#1759) (#1797)
- docs：新增 catalog cli 說明文件 (#1793) (#1794)
- fix：使用安靜的 checkout，避免 git checkout 拋出例外 (#1792)
- feat(extensions)：支援 .extensionignore，可在安裝時排除檔案 (#1781)
- feat：為擴充功能命令註冊新增 Codex 支援 (#1767)

## [0.2.0] - 2026-03-09

### 變更

- fix：讓代理清單註解與實際支援的代理同步 (#1785)
- feat(extensions)：同時支援多個使用中的型錄 (#1720)
- Pavel/add tabnine cli support (#1503)
- 將 Understanding 擴充功能加入社群型錄 (#1778)
- 將 ralph 擴充功能加入社群型錄 (#1780)
- 以專案初始化說明更新 README (#1772)
- feat：將 review 擴充功能加入社群型錄 (#1775)
- 將 fleet 擴充功能加入社群型錄 (#1771)
- 將 Mistral vibe 支援整合進 speckit (#1725)
- fix：移除 specify.md 中重複的選項 (#1765)
- fix：使用全域分支編號，而非依短名稱偵測 (#1757)
- 在 README 新增 Community Walkthroughs 區段 (#1766)
- feat(extensions)：將 Jira Integration 加入社群型錄 (#1764)
- 將 Azure DevOps Integration 擴充功能加入社群型錄 (#1734)
- 修正文件：更新 Antigravity 連結並新增初始化範例 (#1748)
- fix：將 after_tasks 與 after_implement hook 事件接入命令範本 (#1702)
- 讓 c 的忽略規則與 c++ 一致 (#1747)

## [0.1.13] - 2026-03-03

### 變更

- feat：新增 kiro-cli 與 AGENT_CONFIG 一致性涵蓋 (#1690)
- feat：將 verify 擴充功能加入社群型錄 (#1726)
- 在社群型錄 README 表格中新增 Retrospective Extension (#1741)
- fix(scripts)：新增空說明驗證與分支 checkout 錯誤處理 (#1559)
- fix：修正 Copilot 擴充功能命令註冊 (#1724)
- fix(implement)：從 C 忽略模式中移除 Makefile (#1558)
- 將 sync 擴充功能加入社群型錄 (#1728)
- fix(checklist)：釐清 append 與 create 的檔案處理行為 (#1556)
- fix(clarify)：將衝突的問題上限從 10 修正為 5 (#1557)

## [0.1.12] - 2026-03-02

### 變更

- fix：使用 RELEASE_PAT，讓標籤推送觸發發行工作流程 (#1736)

## [0.1.11] - 2026-03-02

### 變更

- fix：release-trigger 改用發行分支 + PR，而非直接推送至 main (#1733)
- fix：拆分發行流程，讓 pyproject.toml 版本與 git 標籤同步 (#1732)

## [0.1.10] - 2026-02-27

### 變更

- fix：為 Cursor .mdc 檔案前置 YAML frontmatter (#1699)

## [0.1.9] - 2026-02-28

### 變更

- chore(deps)：將 astral-sh/setup-uv 從 6 升級至 7 (#1709)

## [0.1.8] - 2026-02-28

### 變更

- chore(deps)：將 actions/setup-python 從 5 升級至 6 (#1710)

## [0.1.7] - 2026-02-27

### 變更

- chore：更新過期的 GitHub Actions 版本 (#1706)
- docs：記錄擴充功能的雙型錄系統 (#1689)
- 修正文件中的版本命令 (#1685)
- 在 README 新增 Cleanup Extension (#1678)
- 將 retrospective 擴充功能加入社群型錄 (#1681)

## [0.1.6] - 2026-02-23

### 變更

- 將 Cleanup Extension 加入型錄 (#1617)
- 修正 CLI 中的參數順序問題 (#1669)
- 將 V-Model Extension Pack 更新至 v0.4.0 (#1665)
- docs：修正文件缺少的步驟 (#1496)
- 將 V-Model Extension Pack 更新至 v0.3.0 (#1661)

## [0.1.5] - 2026-02-21

### 變更

- 修正 #1658：新增 commands_subdir 欄位，支援非標準的代理目錄結構 (#1660)
- feat：新增 GitHub issue 範本 (#1655)
- 在社群型錄中將 V-Model Extension Pack 更新至 v0.2.0 (#1656)
- 將 V-Model Extension Pack 加入型錄 (#1640)
- refactor：從範本移除 OpenAPI/GraphQL 偏向 (#1652)

## [0.1.4] - 2026-02-20

### 變更

- fix：將 Qoder 的 AGENT_CONFIG 鍵從 'qoder' 更名為 'qodercli'，與實際 CLI 可執行檔一致 (#1651)

## [0.1.3] - 2026-02-20

### 變更

- 新增一般代理支援，可自訂命令目錄 (#1639)

## [0.1.2] - 2026-02-20

### 變更

- fix：釘選 click>=8.1，避免 Python 3.14/Homebrew 環境隔離當機 (#1648)

## [0.0.102] - 2026-02-20

### 變更

- fix：在發行工作流程觸發條件中納入 'src/**' 路徑 (#1646)

## [0.0.101] - 2026-02-19

### 變更

- chore(deps)：將 github/codeql-action 從 3 升級至 4 (#1635)

## [0.0.100] - 2026-02-19

### 變更

- 將 pytest 與 Python lint（ruff）加入 CI (#1637)
- feat：新增 pull request 範本，改善貢獻指南 (#1634)

## [0.0.99] - 2026-02-19

### 變更

- Feat/ai skills (#1632)

## [0.0.98] - 2026-02-19

### 變更

- chore(deps)：將 actions/stale 從 9 升級至 10 (#1623)
- feat：新增 dependabot 設定，用於 pip 與 GitHub Actions 更新 (#1622)

## [0.0.97] - 2026-02-18

### 變更

- 從 README.md 移除 Maintainers 區段 (#1618)

## [0.0.96] - 2026-02-17

### 變更

- fix：plan-template.md 中的錯字 (#1446)

## [0.0.95] - 2026-02-12

### 變更

- Feat：新增代理：Google Anti Gravity (#1220)

## [0.0.94] - 2026-02-11

### 變更

- 新增 stale 工作流程，處理 180 天未活動的 issue 與 PR (#1594)

## [0.0.93] - 2026-02-10

### 變更

- 新增模組化擴充功能系統 (#1551)

## [0.0.92] - 2026-02-10

### 變更

- 修正 #1586——.specify.specify 路徑錯誤 (#1588)

## [0.0.91] - 2026-02-09

### 變更

- fix：重新初始化時保留 constitution.md (#1541) (#1553)
- fix：修正整份文件的 markdownlint 錯誤 (#1571)

## [0.0.90] - 2025-12-04

### 變更

- 更新 Markdown 格式
- 更新 Markdown 格式
- docs：在快速入門中新增既有專案初始化

## [0.0.89] - 2025-12-02

### 變更

- 更新 scripts/bash/create-new-feature.sh
- fix(scripts)：避免功能編號解析被解讀為八進位
- fix：從分支編號函式移除未使用的 short_name 參數
- 更新 scripts/powershell/create-new-feature.ps1
- 更新 scripts/bash/create-new-feature.sh
- fix：分支編號使用全域最大值，避免碰撞

## [0.0.88] - 2025-12-01

### 變更

- 修正不正確的 task-template 檔案路徑

## [0.0.87] - 2025-12-01

### 變更

- 將寬高限制為 200px，與小尺寸標誌相符
- docs：將 readme 標誌改為 logo_large.webp
- fix:merge
- fix
- fix
- feat:qoder agent
- docs：以提示框與範例強化快速入門指南
- docs：在快速入門指南中新增 constitution 步驟（修正 #906）
- 更新 README.md 中受支援的 AI 代理
- cancel:test
- test
- fix:literal bug
- fix:test
- test
- fix:qoder url
- fix:download owner
- test
- feat:support Qoder CLI

## [0.0.86] - 2025-11-26

### 變更

- feat：在新的 update-agent-context.ps1 中新增 bob，並讓註解保持一致
- feat：新增 IBM Bob IDE 支援

## [0.0.85] - 2025-11-14

### 變更

- 取得 SCRIPT_DIR 時取消設定 CDPATH

## [0.0.84] - 2025-11-14

### 變更

- docs：修正失效連結並改善代理參照
- docs：重組升級文件結構
- docs：從升級指南移除相關文件區段
- fix：移除指向既有專案指南的失效連結
- docs：新增 Spec Kit 完整升級指南
- 重構 implement.md 中的 ESLint 設定檢查，處理棄用問題

## [0.0.83] - 2025-11-14

### 變更

- feat：新增 OVHcloud SHAI AI Agent

## [0.0.82] - 2025-11-14

### 變更

- fix：以 AGENTS 或 SCRIPTS 子集建立發行套件的邏輯不正確

## [0.0.81] - 2025-11-14

### 變更

- 修正 tasktoissues.md，改用 'github/github-mcp-server/issue_write' 工具

## [0.0.80] - 2025-11-14

### 變更

- 重構功能指令稿邏輯並更新代理上下文指令稿
- 更新 templates/commands/taskstoissues.md
- 更新 CHANGELOG.md
- 更新代理設定
- 更新 scripts/powershell/create-new-feature.ps1
- 更新 src/specify_cli/__init__.py
- 建立 create-release-packages.ps1
- 指令稿變更
- 更新 taskstoissues.md
- 建立 taskstoissues.md
- 更新 src/specify_cli/__init__.py
- 更新 CONTRIBUTING.md
- 程式碼掃描警示第 3 號的潛在修正：工作流程未包含權限
- 更新 src/specify_cli/__init__.py
- 更新 CHANGELOG.md
- 修正 #970
- 修正 #975
- 支援 version 命令
- 排除產生的發行版
- Lint 修正
- 提示詞更新
- 帶提示詞的交接
- Chatmodes 再次流行
- 改用正規的提示詞
- 更新提示詞
- 以提示詞更新
- 測試交接
- 使用 VS Code 交接

## [0.0.79] - 2025-10-23

### 變更

- docs：還原 specify 命令中關於 JSON 輸出的重要註記
- fix：改善分支編號偵測，檢查所有來源
- feat：檢查遠端分支，避免分支編號重複

## [0.0.78] - 2025-10-21

### 變更

- 更新 CONTRIBUTING.md
- docs：新增在本機測試範本與命令變更的步驟
- 更新 specify，讓 create-new-feature.sh 的 "short-name" 參數位於正確位置

## [0.0.77] - 2025-10-21

### 變更

- fix：在 `GitHub Release` 內文中納入最新變更記錄

## [0.0.76] - 2025-10-21

### 變更

- 修正 update-agent-context.sh，處理缺少 Active Technologies/Recent Changes 區段的檔案

## [0.0.75] - 2025-10-21

### 變更

- 修正縮排。
- 為 Amp 代理 CLI 指令稿新增正確的 `install_url`。
- 新增 Amp code 代理支援。

## [0.0.74] - 2025-10-21

### 變更

- feat(ci)：新增 markdownlint-cli2，統一 markdown 格式

## [0.0.73] - 2025-10-21

### 變更

- 還原 vscode 自動移除多餘空白
- fix：修正 implement.md 中的命令參照
- 依 copilot 建議修正
- fix：修正 speckit.analyze.md 中的命令參照
- 依技術別的 Common Patterns 支援更多語言／Devops
- chore：在 `devcontainer` 中以 `node/npm` 取代 `bun`（許多 CLI 型代理實際上需要 `node` 執行環境）
- chore：在 devcontainer 設定中新增 Claude Code 擴充功能
- chore：在 `devcontainer` 中新增 `codebuddy` CLI 的安裝
- chore：修正 vscode 設定中 powershell 指令稿的路徑
- fix：修正 `run_command` 的結束行為並改善 `post-create.sh` 中 Amazon Q 的安裝說明 + 修正 `CONTRIBUTING.md` 的錯字
- chore：將 `specify` 的 github copilot chat 設定加入 `devcontainer`
- chore：新增 `devcontainer` 支援，方便設定開發者工作站

## [0.0.72] - 2025-10-18

### 變更

- fix：修正 create-new-feature.sh 指令稿的參數解析

## [0.0.71] - 2025-10-18

### 變更

- fix：在 check 命令中略過 IDE 型代理的 CLI 檢查
- 修改迴圈條件，納入最後一個參數

## [0.0.70] - 2025-10-18

### 變更

- fix：損壞的媒體檔案
- 更新 README.md
- 函式參數缺少型別提示。建議新增型別註記，提升程式碼清晰度與 IDE 支援。
- - **VS Code 設定的智慧 JSON 合併**：`.vscode/settings.json` 現在會智慧合併，而非在 `specify init --here` 或 `specify init .` 時被覆寫   - 既有設定會保留   - 新增 Spec Kit 設定   - 巢狀物件遞迴合併   - 避免自訂 VS Code 工作區設定意外遺失
- 修正：代理上下文檔案中不正確的命令格式，重修 #895

## [0.0.69] - 2025-10-15

### 變更

- 更新 scripts/bash/create-new-feature.sh
- 更新 create-new-feature.sh
- 更新檔案
- 更新檔案
- 建立 .gitattributes
- 更新措辭
- 更新參數邏輯
- 更新指令稿邏輯

## [0.0.68] - 2025-10-15

### 變更

- 依 copilot 建議格式化內容
- Ruby、PHP、Rust、Kotlin、C、C++

## [0.0.67] - 2025-10-15

### 變更

- 使用數字前綴尋找正確的規格

## [0.0.66] - 2025-10-15

### 變更

- 將 CodeBuddy 代理名稱更新為 'CodeBuddy CLI'
- 在更新指令稿中將 CodeBuddy 更名為 CodeBuddy CLI
- 更新安裝指南中的 AI 程式代理參照
- 在 AGENTS.md 中將 CodeBuddy 更名為 CodeBuddy CLI
- 更新 README.md
- 更新 README.md 中的 CodeBuddy 連結
- 更新 codebuddyCli

## [0.0.65] - 2025-10-15

### 變更

- 修正：代理上下文檔案中不正確的命令格式
- docs：修正標題大小寫，保持一致
- 更新 README.md

## [0.0.64] - 2025-10-14

### 變更

- 更新 tasks.md
- 更新 README.md

## [0.0.63] - 2025-10-14

### 變更

- fix：更新代理上下文指令稿中的 CODEBUDDY 檔案路徑
- docs(readme)：新增 /speckit.tasks 步驟並重新編號走查

## [0.0.62] - 2025-10-11

### 變更

- 依程式碼審查再更新幾處
- fix：統一 Cursor 代理命名，使用 'cursor-agent'

## [0.0.61] - 2025-10-10

### 變更

- 更新 clarify.md
- 新增如何升級 specify 安裝的說明

## [0.0.60] - 2025-10-10

### 變更

- 更新 vscode-settings.json
- 更新說明與錯誤修正

## [0.0.59] - 2025-10-10

### 變更

- 更新 __init__.py
- 整合 Cursor 命名
- 更新 CHANGELOG.md
- Git 錯誤現在會醒目顯示。
- 更新 __init__.py
- 重構代理設定
- 更新 src/specify_cli/__init__.py
- 更新 scripts/powershell/update-agent-context.ps1
- 更新 AGENTS.md
- 更新 templates/commands/implement.md
- 更新 templates/commands/implement.md
- 更新 CHANGELOG.md
- 更新 changelog
- 更新 plan.md
- 為 /speckit.implement 命令新增忽略檔案驗證步驟
- 在 TOML 輸出中逸出反斜線
- 將 CodeBuddy 更新為國際站
- feat：支援 codebuddy ai
- feat：支援 codebuddy ai

## [0.0.58] - 2025-10-08

### 變更

- 在命令範本中新增逸出指引
- 更新 README.md
- 更新 README.md

## [0.0.57] - 2025-10-06

### 變更

- 更新 CHANGELOG.md
- 更新命令參照
- 打包 Copilot 的 VS Code 設定
- 更新 tasks-template.md
- 更新 templates/tasks-template.md
- 清理
- 更新 CLI 變更
- 更新範本與文件
- 更新 checklist.md
- 更新範本
- 清理冗餘
- 更新 checklist.md
- Codex CLI 現已完整支援
- 更新 specify.md
- 提示詞更新
- 更新提示前綴
- 更新 .github/workflows/scripts/create-release-packages.sh
- 命令一致性更新
- 更新命令。
- 更新記錄
- 範本清理與重組
- 移除 Codex 具名參數限制警告
- 從 README.md 移除 Codex 具名參數限制

## [0.0.56] - 2025-10-02

### 變更

- docs(readme)：連結 Amazon Q 斜線命令限制的 issue
- docs：釐清 Amazon Q 限制並更新 init docstring
- feat(agent)：新增 Amazon Q Developer CLI 整合

## [0.0.55] - 2025-09-30

### 變更

- 更新文件中 Contributing 與 Support Guides 的 URL
- fix：為 update-agent-context.ps1 的檔案讀寫新增 UTF-8 編碼
- 更新 __init__.py
- 更新 src/specify_cli/__init__.py
- docs：修正產生檔案的路徑（已移至 `.specify/` 資料夾下）
- 更新 src/specify_cli/__init__.py
- feat：支援 'specify init .' 初始化目前目錄
- feat：新增 emacs 風格的上下鍵

## [0.0.54] - 2025-09-25

### 變更

- 更新 CONTRIBUTING.md
- 精煉 `plan-template.md`：改善專案類型偵測、釐清結構決策流程，並強化研究任務指引。
- 更新 __init__.py

## [0.0.53] - 2025-09-24

### 變更

- 更新規格檔案建立的範本路徑
- 更新規格檔案建立的範本路徑
- docs：從 README 移除 constitution_update_checklist

## [0.0.52] - 2025-09-22

### 變更

- 更新 analyze.md
- 更新 templates/commands/analyze.md
- 更新 templates/commands/clarify.md
- 更新 templates/commands/plan.md
- 以額外命令更新
- 以 --force 旗標更新
- feat：在 README 新增 uv tool 安裝說明

## [0.0.51] - 2025-09-21

### 變更

- 加入 Roo Code 支援後更新

## [0.0.50] - 2025-09-21

### 變更

- 更新 generate-release-notes.sh
- 更新錯誤訊息
- Auggie 資料夾修正

## [0.0.49] - 2025-09-21

### 變更

- 更新 scripts/powershell/update-agent-context.ps1
- 更新 templates/commands/implement.md
- 清理 check 命令
- 新增 Auggie 支援
- 更新 AGENTS.md
- 加入 Kilo Code 支援後更新
- 更新 README.md
- 更新 templates/commands/constitution.md
- 更新 templates/commands/implement.md
- 更新 templates/commands/plan.md
- 更新 templates/commands/specify.md
- 更新 templates/commands/tasks.md
- 更新 README.md
- 不再將警告拆成多行
- 依 #419 更新範本
- docs：在 check 命令中以 codex 更新 README

## [0.0.48] - 2025-09-21

### 變更

- 更新 scripts/powershell/check-prerequisites.ps1
- 更新 CHANGELOG.md
- 更新 CHANGELOG.md
- 更新 changelog
- 更新 scripts/bash/update-agent-context.sh
- 修正指令稿設定
- 更新 scripts/bash/common.sh
- 更新 scripts/powershell/update-agent-context.ps1
- 更新 scripts/powershell/update-agent-context.ps1
- 釐清
- 更新提示詞
- 更新 update-agent-context.ps1
- 更新 CONTRIBUTING.md
- 更新 CONTRIBUTING.md
- 更新 CONTRIBUTING.md
- 更新 CONTRIBUTING.md
- 更新 CONTRIBUTING.md
- 更新貢獻指南。
- 根目錄偵測邏輯
- 更新 templates/plan-template.md
- 更新 scripts/bash/update-agent-context.sh
- 更新 scripts/powershell/create-new-feature.ps1
- 精簡
- 指令稿與範本微調
- 更新設定
- 更新 scripts/powershell/check-prerequisites.ps1
- 更新 scripts/bash/check-prerequisites.sh
- 修正指令稿路徑
- 指令稿清理
- 更新 scripts/bash/check-prerequisites.sh
- 更新 scripts/powershell/check-prerequisites.ps1
- 更新 GitHub Action 的指令稿委派
- 清理產生套件的設定
- 使用正確的行尾
- 整合指令稿

## [0.0.47] - 2025-09-20

### 變更

- 更新代理上下文檔案

## [0.0.46] - 2025-09-20

### 變更

- 更新 update-agent-context.ps1
- 更新套件發行
- 更新設定
- 更新 __init__.py
- 更新 __init__.py
- 移除初始化指令稿中 Codex 專屬邏輯
- 更新版本修訂
- 更新 __init__.py
- 強化 Codex 支援：自動同步提示檔案、允許無 git 時產生規格，並記錄更清楚的 /specify 用法。
- 一致性微調
- 步驟著色一致
- 更新 __init__.py
- 更新 __init__.py
- 快速 UI 微調
- 更新套件發行
- 將工作區命令種入限制於 Codex init，並據此更新 Codex 文件。
- 釐清 Codex 專屬 README 註記及其不同工作流程的理由。
- 升級至 0.0.7 並記錄 Codex 支援
- 將 Codex 命令範本正規化為基於指令稿的結構描述，並自動升級產生的命令。
- 修正 __init__.py 中殘留的合併衝突標記
- 新增 Codex CLI 支援，含 AGENTS.md 與 commands 啟動

## [0.0.45] - 2025-09-19

### 變更

- 加入 Windsurf 支援後更新
- 透過 cli --github-token 以參數方式公開權杖
- 若已設定 GITHUB_TOKEN/GH_TOKEN，新增 github 驗證標頭

## [0.0.44] - 2025-09-18

### 變更

- 更新 specify.md
- 更新 __init__.py

## [0.0.43] - 2025-09-18

### 變更

- 加入 /implement 支援後更新

## [0.0.42] - 2025-09-18

### 變更

- 更新 constitution.md

## [0.0.41] - 2025-09-18

### 變更

- 更新 constitution.md

## [0.0.40] - 2025-09-18

### 變更

- 更新 constitution 命令

## [0.0.39] - 2025-09-18

### 變更

- 清理
- fix：qwen 的命令格式

## [0.0.38] - 2025-09-18

### 變更

- 修正 update-agent-context.sh 中的範本路徑
- docs：修正 markdown 檔案中的文法錯誤

## [0.0.37] - 2025-09-17

### 變更

- fix：為發行工作流程與代理指令稿補上缺少的 Qwen 支援

## [0.0.36] - 2025-09-17

### 變更

- feat：新增 opencode ai 代理
- 修正 --no-git 參數解析。

## [0.0.35] - 2025-09-17

### 變更

- chore(release)：將版本升級至 0.0.5 並更新變更記錄
- chore：處理審查回饋——移除註解並修正編號
- feat：為 Spec Kit 新增 Qwen Code 支援

## [0.0.34] - 2025-09-15

### 變更

- 更新範本。

## [0.0.33] - 2025-09-15

### 變更

- 更新指令稿

## [0.0.32] - 2025-09-15

### 變更

- 更新範本路徑

## [0.0.31] - 2025-09-15

### 變更

- 針對 Cursor 規則與指令稿路徑更新
- 更新 Specify 定義
- 更新 README.md
- 加入影片標頭後更新
- fix(docs)：移除多餘空白

## [0.0.30] - 2025-09-12

### 變更

- 更新 update-agent-context.ps1

## [0.0.29] - 2025-09-12

### 變更

- 更新 create-release-packages.sh
- 加入 check 變更後更新

## [0.0.28] - 2025-09-12

### 變更

- 更新措辭
- 更新 release.yml

## [0.0.27] - 2025-09-12

### 變更

- 支援 Cursor

## [0.0.26] - 2025-09-12

### 變更

- 以更合理的方式處理指令稿

## [0.0.25] - 2025-09-12

### 變更

- 更新打包

## [0.0.24] - 2025-09-12

### 變更

- 修正套件邏輯

## [0.0.23] - 2025-09-12

### 變更

- 更新設定
- 更新 __init__.py
- 以平台專屬限制重構
- 更新 README.md
- 更新 CLI 參考
- 更新 __init__.py
- refactor：將 Claude 本機路徑抽出為常數，提升可維護性
- fix：支援透過 migrate-installer 安裝的 Claude CLI

## [0.0.22] - 2025-09-11

### 變更

- 更新 release.yml
- 更新 create-release-packages.sh
- 更新 create-release-packages.sh
- 更新發行檔案

## [0.0.21] - 2025-09-11

### 變更

- 整合指令稿建立
- 更新 Copilot 提示詞的建立方式
- 更新 local-development.md
- 本機開發指南與指令稿更新
- 更新 CONTRIBUTING.md
- 強化 HTTP 使用者端初始化，支援可選的 SSL 驗證，並將版本升級至 0.0.3
- 完成 Gemini CLI 命令說明
- 重構 HTTP 使用者端使用方式，改用 truststore 處理 SSL 上下文
- docs：更新 Commands 區段命名，與實作一致
- docs：修正 README.md 的格式問題，保持一致
- 更新文件與發行

## [0.0.20] - 2025-09-08

### 變更

- 更新 docs/quickstart.md
- 文件設定

## [0.0.19] - 2025-09-08

### 變更

- 更新 README.md

## [0.0.18] - 2025-09-08

### 變更

- 更新 README.md

## [0.0.17] - 2025-09-08

### 變更

- 移除 tasks.md 範本的尾隨空白

## [0.0.16] - 2025-09-07

### 變更

- 修正發行工作流程，使其符合儲存庫規則

## [0.0.15] - 2025-09-07

### 變更

- shebang 改用 `/usr/bin/env bash` 而非 `/bin/bash`

## [0.0.14] - 2025-09-04

### 變更

- fix：修正 spec-driven.md 中的錯字

## [0.0.13] - 2025-09-04

### 變更

- 修正使用說明的格式

## [0.0.12] - 2025-09-04

### 變更

- 修正 plan 命令文件中的範本路徑

## [0.0.11] - 2025-09-04

### 變更

- fix：範例中不正確的樹狀結構

## [0.0.10] - 2025-09-04

### 變更

- 修正 Article I 中的小錯字

## [0.0.9] - 2025-09-03

### 變更

- 將 CLI 命令從 '/spec' 更新為 '/specify'

## [0.0.8] - 2025-09-02

### 變更

- 為指令稿新增可執行權限，讓程式代理啟動時能執行

## [0.0.7] - 2025-09-02

### 變更

- doco(spec-driven)：修正文件中的小錯字

## [0.0.6] - 2025-08-25

### 變更

- 更新 README.md

## [0.0.5] - 2025-08-25

### 變更

- 更新 .github/workflows/release.yml
- 修正發行工作流程，使其符合儲存庫規則

## [0.0.4] - 2025-08-25

### 變更

- 新增 John Lam 為貢獻者並加上發行徽章

## [0.0.3] - 2025-08-22

### 變更

- 更新需求

## [0.0.2] - 2025-08-22

### 變更

- 更新 README.md

## [0.0.1] - 2025-08-22

### 變更

- 更新 release.yml
