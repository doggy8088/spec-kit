# [PROJECT_NAME] 憲章
<!-- 例如：Spec 憲章、TaskFlow 憲章等。 -->

## 核心原則

### [PRINCIPLE_1_NAME]
<!-- 例如：I. 以函式庫為先 (Library-First) -->
[PRINCIPLE_1_DESCRIPTION]
<!-- 例如：每個功能都從獨立的函式庫開始；函式庫必須自包含、可獨立測試、有文件說明；需有明確目的——不得僅為組織結構而存在的函式庫 -->

### [PRINCIPLE_2_NAME]
<!-- 例如：II. 命令列介面 (CLI Interface) -->
[PRINCIPLE_2_DESCRIPTION]
<!-- 例如：每個函式庫都需透過命令列介面 (Command Line Interface) 提供功能；文字輸入/輸出協定：stdin/args → stdout，錯誤 → stderr；支援 JSON 與人類可讀格式 -->

### [PRINCIPLE_3_NAME]
<!-- 例如：III. 測試優先 (Test-First，強制執行) -->
[PRINCIPLE_3_DESCRIPTION]
<!-- 例如：必須採用測試驅動開發（TDD）：先撰寫測試 → 用戶確認 → 測試失敗 → 再實作；嚴格執行 Red-Green-Refactor 循環 -->

### [PRINCIPLE_4_NAME]
<!-- 例如：IV. 整合測試 (Integration Testing) -->
[PRINCIPLE_4_DESCRIPTION]
<!-- 例如：需進行整合測試的重點範疇：新函式庫契約測試、契約變更、服務間通訊、共用資料結構 -->

### [PRINCIPLE_5_NAME]
<!-- 例如：V. 可觀察性 (Observability)、VI. 版本管理與重大變更 (Versioning & Breaking Changes)、VII. 簡單為先 (Simplicity) -->
[PRINCIPLE_5_DESCRIPTION]
<!-- 例如：文字 I/O 保證可除錯性；必須有結構化日誌；或：採用 MAJOR.MINOR.BUILD 版本格式；或：從簡單開始，遵循 YAGNI 原則 -->

## [SECTION_2_NAME]
<!-- 例如：額外限制、安全性需求、效能標準等。 -->

[SECTION_2_CONTENT]
<!-- 例如：技術堆疊要求、合規標準、部署政策等。 -->

## [SECTION_3_NAME]
<!-- 例如：開發流程、審查流程、品質門檻等。 -->

[SECTION_3_CONTENT]
<!-- 例如：程式碼審查要求、測試門檻、部署核准流程等。 -->

## 治理規範
<!-- 例如：本憲章優先於其他所有實踐；修訂需有文件、審核與遷移計畫 -->

[GOVERNANCE_RULES]
<!-- 例如：所有 PR/審查必須驗證是否符合憲章；複雜性必須有合理說明；執行時開發指引請參考 [GUIDANCE_FILE] -->

**版本**: [CONSTITUTION_VERSION] | **通過日期**: [RATIFICATION_DATE] | **最後修訂**: [LAST_AMENDED_DATE]
<!-- 例如：版本：2.1.1 | 通過日期：2025-06-13 | 最後修訂：2025-07-16 -->