# 功能規格說明： [FEATURE NAME]

**功能分支**：`[###-feature-name]`  
**建立日期**：[DATE]  
**狀態**：草稿  
**輸入**：使用者描述："$ARGUMENTS"

## 執行流程（主流程）
```
1. Parse user description from Input
   → If empty: ERROR "No feature description provided"
2. Extract key concepts from description
   → Identify: actors, actions, data, constraints
3. For each unclear aspect:
   → Mark with [NEEDS CLARIFICATION: specific question]
4. Fill User Scenarios & Testing section
   → If no clear user flow: ERROR "Cannot determine user scenarios"
5. Generate Functional Requirements
   → Each requirement must be testable
   → Mark ambiguous requirements
6. Identify Key Entities (if data involved)
7. Run Review Checklist
   → If any [NEEDS CLARIFICATION]: WARN "Spec has uncertainties"
   → If implementation details found: ERROR "Remove tech details"
8. Return: SUCCESS (spec ready for planning)
```

---

## ⚡ 快速指引
- ✅ 著重於用戶需要「做什麼」以及「為什麼」
- ❌ 避免說明「如何實作」（不涉及技術堆疊、API、程式碼結構）
- 👥 內容撰寫對象為業務相關持份者，而非開發人員

### 各區塊要求
- **必填區塊**：每個功能皆需完整填寫
- **選填區塊**：僅在與該功能相關時納入
- 若某區塊不適用，請直接移除（勿保留為「N/A」）

### 關於 AI 產生規格
當根據用戶提示產生此規格時：
1. **標記所有不明確處**：對於任何需要假設的地方，請使用 [NEEDS CLARIFICATION: 具體問題] 標註
2. **不要猜測**：若提示未明確說明（例如：「登入系統」未指定驗證方式），請標記
3. **以測試人員思維審視**：每個模糊需求都應無法通過「可測試且明確」的檢查項
4. **常見未明確項目**：
   - 用戶類型與權限
   - 資料保存／刪除政策
   - 效能目標與規模
   - 錯誤處理行為
   - 整合需求
   - 資安／合規需求

---

## 用戶情境與測試 *(必填)*

### 主要用戶故事
[以白話描述主要用戶操作流程]

### 驗收情境
1. **Given** [初始狀態]，**When** [動作]，**Then** [預期結果]
2. **Given** [初始狀態]，**When** [動作]，**Then** [預期結果]

### 邊界情境
- 當發生 [邊界條件] 時會怎樣？
- 系統如何處理 [錯誤情境]？

## 需求 *(必填)*

### 功能性需求
- **FR-001**：系統必須 [具體能力，例如：「允許用戶建立帳號」]
- **FR-002**：系統必須 [具體能力，例如：「驗證電子郵件地址」]
- **FR-003**：用戶必須能夠 [關鍵互動，例如：「重設密碼」]
- **FR-004**：系統必須 [資料需求，例如：「保存用戶偏好設定」]
- **FR-005**：系統必須 [行為，例如：「記錄所有安全事件」]

*不明確需求標記範例：*
- **FR-006**：系統必須透過 [NEEDS CLARIFICATION: 未指定驗證方式 - email/password、SSO、OAuth？] 進行用戶驗證
- **FR-007**：系統必須保留用戶資料 [NEEDS CLARIFICATION: 未指定保存期限]

### 主要實體 *(若功能涉及資料時填寫)*
- **[實體 1]**： [代表什麼、主要屬性（不含實作細節）]
- **[實體 2]**： [代表什麼、與其他實體的關聯]

---

## 審查與驗收清單
*GATE：main() 執行期間自動檢查*

### 內容品質
- [ ] 無實作細節（語言、框架、API）
- [ ] 聚焦用戶價值與業務需求
- [ ] 以非技術持份者為對象撰寫
- [ ] 所有必填區塊皆已完成

### 需求完整性
- [ ] 無 [NEEDS CLARIFICATION] 標記殘留
- [ ] 需求可測試且明確
- [ ] 成功標準可量化
- [ ] 範圍界定清楚
- [ ] 已識別依賴與假設

---

## 執行狀態
*由 main() 處理過程中更新*

- [ ] 已解析用戶描述
- [ ] 已萃取關鍵概念
- [ ] 已標記不明確處
- [ ] 已定義用戶情境
- [ ] 已產生需求
- [ ] 已識別實體
- [ ] 已通過審查清單

---
