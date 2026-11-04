# Spec Kit－2026 年 3 月電子報

本期涵蓋 Spec Kit 在 2026 年 3 月的動態。本月發佈了九個版本（v0.2.0 至 v0.4.3），推出可插拔的預設集系統、氣隙部署、自動技能註冊，以及七個新的 AI 代理整合。社群擴充型錄成長至超過 20 個條目，獨立導覽與部落格文章大量出現，產業報導則熱議「vibe coding」是否已死。下表為摘要，其後為詳細內容。

| **Spec Kit 核心（2026 年 3 月）** | **社群與內容** | **SDD 生態系與下一步** |
| --- | --- | --- |
| 發佈了九個版本，帶來重大功能：多型錄擴充功能、可插拔預設集、氣隙部署，以及擴充技能自動註冊。新增了七個代理。儲存庫從約 71k 顆星成長至 **82,616 顆星**。 [\[github.com\]](https://github.com/github/spec-kit/releases) | Tiago Valverde、Alfredo Perez 與 Sergey Golubev 的導覽文章。超過 20 個社群擴充功能。Spec Kit Assistant VS Code 擴充功能獲認定為 Community Friend。Microsoft Learn 訓練模組上線。 | ByteIota 報導 AWS 正推動 SDD 成為新標準。Augment Code 發表了 Spec Kit 與 Intent 的比較。競爭者以編排深度與活規格做出區隔；Spec Kit 則在代理廣度與可攜性上領先。 |

***

## Spec Kit 專案更新

### 版本總覽

**v0.2.0**（3 月 10 日）以**同時支援多個型錄**揭開本月序幕，讓核心與社群擴充型錄能同時啟用。它新增了 **Tabnine CLI** 與 **Kimi Code CLI** 代理、四個社群擴充功能（Understanding、Ralph、Review、Fleet Orchestrator），以及 `.extensionignore` 支援。修補版 **v0.2.1** 修復了失效的快速入門連結，並新增型錄 CLI 說明。 [\[github.com\]](https://github.com/github/spec-kit/releases)

**v0.3.0**（3 月中旬）交付了**可插拔預設集系統**，包含型錄、解析器與技能傳播。預設集讓團隊能以自己的慣例覆寫預設範本，採用以優先順序堆疊的方式。此版本也新增了用於測試擴充功能的 **/selftest.extension**、**Mistral Vibe CLI**，將 **Qwen Code CLI** 從 TOML 遷移至 Markdown，並強化了 bash 指令稿對 shell 注入的防護。新的社群擴充功能包括 DocGuard CDD、Archive & Reconcile、specify-status 與 specify-doctor。 [\[github.com\]](https://github.com/github/spec-kit/releases)

**v0.3.1** 新增了前置／後置 hook 事件、`settings.json` 的 JSONC 深層合併，以及 **Trae IDE** 代理。**v0.3.2** 新增了 **Junie**、**iFlow CLI** 與 **Pi Coding Agent**，以及預設集投稿範本與擴充功能比較指南。社群擴充功能持續加入：verify-tasks、conduct、cognitive-squad、speckit-utils、spec-kit-iterate 與 spec-kit-learn。 [\[github.com\]](https://github.com/github/spec-kit/releases)

**v0.4.0**（3 月下旬）推出了**擴充技能自動註冊**——已安裝擴充功能的命令現在會自動公開為代理技能。它也將核心範本內嵌至 CLI wheel，實現**氣隙／離線部署**，並新增了以時間戳為基礎的分支命名。 [\[github.com\]](https://github.com/github/spec-kit/releases)

三個修補版為本月收尾。**v0.4.1** 修復了規格範本缺少 Assumptions 章節的問題，並改善儲存庫根目錄偵測。**v0.4.2** 將 AIDE、Extensify 與 Presetify 加入社群型錄，把社群擴充功能表格移入主 README，並將 **Spec Kit Assistant VS Code 擴充功能**認定為 Community Friend。**v0.4.3** 統一了技能命名慣例，並恢復了 **PowerShell 5.1 相容性**。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 錯誤修復與安全性強化

最重要的修復是 bash 指令稿的 **shell 注入強化**，處理了未經清理的 git 分支名稱與環境變數可能帶來的弱點。其他修復包括改用**全域分支編號**以確保排序一致、抑制 git checkout 例外與 fetch 標準輸出外洩、正確編碼 JSON 控制字元，以及新增明確的 PowerShell 位置參數繫結。 [\[github.com\]](https://github.com/github/spec-kit/releases)

### 擴充功能生態系

截至 3 月下旬，已有超過 **20 個社群擴充功能**為 Spec Kit 而建。Thulasi Rajasekaran 在 LinkedIn 發表的文章 *「The Feature That Turns Spec Kit Into a Platform」* 點出了幾個亮點：**Conduct**（透過子代理編排 SDD 各階段，避免上下文污染）、**Verify Tasks**（抓出「幽靈完成」——標記為完成卻沒有實際程式碼的任務）、**Understanding**（依 IEEE/ISO 標準以 31 項品質指標對照規格衡量），以及 **Jira 與 Azure DevOps 整合**。 [\[linkedin.com\]](https://www.linkedin.com/pulse/feature-turns-spec-kit-platform-extensions-presets-rajasekaran-3ejgc)

Rajasekaran 認為，預設集真正的意義在於它所開啟的可能性：同一套機制既能把「User Stories」變成海盜語的「Crew Tales」，也能強制合規要求、加入必要的威脅模型章節，或要求在實作任務之前先有測試任務。組織可以透過託管自訂型錄 URL，來策劃可用的擴充功能。 [\[linkedin.com\]](https://www.linkedin.com/pulse/feature-turns-spec-kit-platform-extensions-presets-rajasekaran-3ejgc)

## 社群與內容

### 開發者導覽與部落格文章

3 月出現了一波獨立內容，開發者紛紛在實務中探索 SDD。

**Tiago Valverde** 於 3 月 14 日發表 *「Spec-Driven Development in Practice: A Walkthrough with Spec Kit」*。他記錄了如何使用完整的 Spec Kit 工作流程打造一個 Instagram 風格的照片牆功能，並與先前臨時下提示詞的作法對比：直接向 Claude 下提示詞對小變更有效，但複雜工作會導致範圍蔓延、需求含糊且發現得太晚，而且不留下任何產物。Valverde 建議一開始的提示詞要具體、立即審閱 `spec.md`，並特別指出釐清步驟價值很高。較短的姊妹篇 *「The Shift from Vibe Coding to Spec-Driven Development」* 於 3 月 8 日發表。 [\[tiagovalverde.com\]](https://www.tiagovalverde.com/posts/spec-driven-development-in-practice-a-walkthrough-with-spec-kit)

**Alfredo Perez** 於 3 月 21 日發表 *「Build Your Own SDD Workflow」*，刻意採取唱反調的立場。他原則上肯定 SDD，但認為完整的七步驟工作流程對較小的任務來說儀式感太重。他的解法是精簡的 **4 步驟自訂工作流程**——`specify → plan → tasks → implement`——捨棄憲章、釐清與審查，並接入 **SpecKit Companion** VS Code 擴充功能。文章點出了一個重要的取捨：完整嚴謹與輕量採用之間。Perez 也在 3 月 25 日的 **Angular Community Meetup** 上分享了這套工作流程。 [\[alfredo-perez.dev\]](https://www.alfredo-perez.dev/blog/2026-03-21-build-your-own-sdd-workflow)

prodfeat.ai 的 **Sergey Golubev** 於 3 月 17 日發表 *「20+ SDD Frameworks: A Catalog for AI Development」*。該型錄將 **20 多個框架分為 6 個類別**，並點出 **BMAD-METHOD**（約 41k 顆星，以 AI 角色模擬敏捷團隊）、**QuintCode + FPF**（透過 5 階段 ADI Cycle 保存決策依據），以及 **cc-sdd**（約 2.9k 顆星，為 8 種工具強制執行 SDD 工作流程）。Golubev 提出了三層成熟度模型：*Spec-First*（每項任務一份規格，之後丟棄）、*Spec-Anchored*（活文件），以及 *Spec-as-Source*（規格是唯一的產物）。他的結論是：「SDD 不是一時熱潮……任務定義清楚時，AI 代理能產生好程式碼。沒有規格——你就是在擲骰子。」 [\[prodfeat.ai\]](https://www.prodfeat.ai/en/blog/2026-03-17-sdd-frameworks-catalog)

### 社群工具與文件

**Spec Kit Assistant VS Code 擴充功能**正式獲認定為 Community Friend 並加入 README。README 也重新整理：社群擴充功能表格移入主頁面以提升可發現性，新增社群預設集章節，發佈指南新增了 Category 與 Effect 欄位。新的導覽包括 Java brownfield、Go/React brownfield 儀表板，以及 Spring Boot 海盜語預設集示範。 [\[github.com\]](https://github.com/github/spec-kit/releases)

一個值得注意的社群專案出現了：由 iandeherdt 開發的 **speckit-pipeline**——在 Spec Kit 之上疊加一條管線，包含**設計迴圈**（設計者與評論者代理在瀏覽器中迭代）與**建置迴圈**（開發者與評估者代理依驗收標準驗證）。一個開放中的 issue（#1966）要求內建管線命令，顯示這種模式最終可能進入核心。

公開的 **Microsoft Learn** 訓練模組 *「Implement Spec-Driven Development using the GitHub Spec Kit」*（3 小時、13 個單元），為企業開發者提供了入門路徑。

## SDD 生態系與產業趨勢

### 「Vibe Coding 已死」的敘事

*ByteIota* 於 3 月 20 日發表 *「Spec-Driven Development Kills 'Vibe Coding'」*，報導 AWS 正推動 SDD 成為新標準。關鍵主張包括：早期工具預覽已有超過 100,000 名開發者採用 SDD 作法、AWS 展示用 Kiro IDE 將兩週的功能在兩天內完成，以及 WEF 研究指出 65% 的開發者預期自己在 2026 年的角色會轉向以規格為先的工作流程。 [\[byteiota.com\]](https://byteiota.com/spec-driven-development-kills-vibe-coding-march-2026/)

批評者也獲得同等篇幅。*Marmelab* 稱 SDD 是「Agile 正是為了要解決的那些錯誤」。*Isoform* 的一項受控測試發現，SDD 花了 33 分鐘產生 689 行程式碼，而迭代式下提示詞只需 8 分鐘，且未測得品質提升。新興共識偏向混合作法——一位 Red Hat 開發者精準地說：「用 vibe 來探索。用規格來建置。」其他獨立文章來自 Shimon Ifrah、Raul Proenza（Cox Automotive）、CGI 與 Vishal Mysore。ByteIota 也提出了一個較少被重視的疑慮：如果規格取代了寫程式，初階開發者要如何培養寫出好規格或審查 AI 產生程式碼的判斷力？ [\[byteiota.com\]](https://byteiota.com/spec-driven-development-kills-vibe-coding-march-2026/)

### 競爭格局

**Augment Code** 於 3 月 31 日發表 *「Intent vs GitHub Spec Kit (2026): Platform or Framework?」*。核心取捨在於：Spec Kit 的優勢是跨 22 個以上代理的**可攜性**；Intent 則提供具備自動漂移偵測的**活規格**。這項比較浮現了規格漂移這個關鍵架構疑慮——Spec Kit 的規格在實作後可能過時，雖然社群擴充功能有處理這個問題，但原生的即時漂移偵測尚未進入核心。 [\[augmentcode.com\]](https://www.augmentcode.com/tools/intent-vs-github)

更廣的格局持續演變。OpenSpec 維持約 29.3k 顆星，BMAD-METHOD 成長至約 41k 顆星，Tessl 則持續處於私人 beta。Spec Kit 在 GitHub 人氣與代理廣度上領先，但替代方案各有區隔：編排深度（Intent、BMAD）、強制紀律（cc-sdd）、決策軌跡（QuintCode），以及 spec-as-source 願景（Tessl）。 [\[prodfeat.ai\]](https://www.prodfeat.ai/en/blog/2026-03-17-sdd-frameworks-catalog)

## 藍圖

未來開發中正在討論或進行中的領域：

- **規格生命週期管理**——支援壽命更長、能跨多次迭代演進的規格。Augment Code 的比較與社群評論都指出「規格漂移」是關鍵疑慮。Archive & Reconcile 擴充功能（#1844）是社群邁出的一步；核心解法預期將成為重點領域。 [\[augmentcode.com\]](https://www.augmentcode.com/tools/intent-vs-github) [\[github.com\]](https://github.com/github/spec-kit/releases)
- **CI/CD 整合**——將 Spec Kit 驗證納入 pull request 工作流程，並在規格不一致時讓建置失敗。Jira 與 Azure DevOps 擴充功能（#1764、#1734）是第一步。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **端到端工作流程自動化**——一個開放中的 issue（#1966）提議內建管線命令。由 iandeherdt 打造的社群專案 **speckit-pipeline** 已展示了具備瀏覽器驗證的多代理迴圈。 [\[github.com\]](https://github.com/iandeherdt/speckit-pipeline)
- **持續擴充代理**——光是 3 月就新增了七個代理。與代理無關的設計意味著任何人都能為新興工具新增支援。 [\[byteiota.com\]](https://byteiota.com/spec-driven-development-kills-vibe-coding-march-2026/)
- **體驗簡化**——預設集系統、自訂工作流程與日益豐富的導覽庫降低了學習曲線，但隨著型錄成長，擴充功能的可發現性需要更健全的解法。 [\[github.com\]](https://github.com/github/spec-kit/releases)
- **邁向穩定版本**——一個月發佈九個版本，反映了 1.0 之前的動能。要達到 1.0，需要穩定擴充功能與預設集 API，並確保整個代理與擴充介面的向後相容性。 [\[github.com\]](https://github.com/github/spec-kit/blob/main/newsletters/2026-February.md)
