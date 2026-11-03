# 功能規格：[FEATURE NAME]

**功能分支**：`[###-feature-name]`

**建立日期**：[DATE]

**狀態**：Draft

**輸入**：使用者描述：「$ARGUMENTS」

## 使用者情境與測試 *（必填）*

<!--
  重要：使用者故事應依使用者旅程的重要性排序優先順序。
  每個使用者故事／旅程都必須可獨立測試——也就是說，就算只實作其中一個，
  也應該要有一個能交付價值的可行 MVP（Minimum Viable Product）。

  為每個故事指派優先順序（P1、P2、P3 等），其中 P1 最關鍵。
  將每個故事視為一段可獨立存在的完整功能切片，它可以：
  - 獨立開發
  - 獨立測試
  - 獨立部署
  - 獨立展示給使用者
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**為何是這個優先順序**：[Explain the value and why it has this priority level]

**獨立測試**：[Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**驗收情境**：

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**為何是這個優先順序**：[Explain the value and why it has this priority level]

**獨立測試**：[Describe how this can be tested independently]

**驗收情境**：

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**為何是這個優先順序**：[Explain the value and why it has this priority level]

**獨立測試**：[Describe how this can be tested independently]

**驗收情境**：

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### 邊界案例

<!--
  需要處理：這一節的內容是佔位符。
  請填入正確的邊界案例。
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## 需求 *（必填）*

<!--
  需要處理：這一節的內容是佔位符。
  請填入正確的功能需求。
-->

### 功能需求

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*標記不清楚需求的範例：*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### 關鍵實體 *（功能涉及資料時才加入）*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

## 成功準則 *（必填）*

<!--
  需要處理：定義可衡量的成功準則。
  這些準則必須與技術無關，且可衡量。
-->

### 可衡量的成果

- **SC-001**: [Measurable metric, e.g., "Users can complete account creation in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users without degradation"]
- **SC-003**: [User satisfaction metric, e.g., "90% of users successfully complete primary task on first attempt"]
- **SC-004**: [Business metric, e.g., "Reduce support tickets related to [X] by 50%"]

## 假設

<!--
  需要處理：這一節的內容是佔位符。
  當功能描述未指明某些細節時，依合理預設填入正確的假設。
-->

- [Assumption about target users, e.g., "Users have stable internet connectivity"]
- [Assumption about scope boundaries, e.g., "Mobile support is out of scope for v1"]
- [Assumption about data/environment, e.g., "Existing authentication system will be reused"]
- [Dependency on existing system/service, e.g., "Requires access to the existing user profile API"]
