# 精簡工作流程

一個最小化的預設集，將 Spec Kit 工作流程精簡到只剩核心要素 — 只有提示詞，只有產出物。

## 適用時機

當你想要結構化的 specify → plan → tasks → implement 流程、但不需要完整範本的繁文縟節時，就使用 Lean。每個命令都會產生一份聚焦的 Markdown 檔案，不必填寫樣板區段。

## 包含的命令

| 命令 | 產出 | 說明 |
|---------|--------|-------------|
| `speckit.specify` | `spec.md` | 依功能描述建立規格 |
| `speckit.plan` | `plan.md` | 依規格建立實作計畫 |
| `speckit.tasks` | `tasks.md` | 依規格與計畫建立依相依性排序的任務 |
| `speckit.implement` | *（程式碼）* | 依序執行所有任務並標記進度 |
| `speckit.constitution` | `constitution.md` | 建立或更新專案憲章 |

## 它取代了什麼

Lean 以自包含的提示詞覆寫五個核心工作流程命令，直接產生各項產出物 — 不涉及額外的範本檔案。成果是一個更短、更直接的工作流程。

## 安裝

```bash
# Lean 是內建預設集 — 無需下載
specify preset add lean
```

## 開發

```bash
# 從本機目錄測試
specify preset add --dev ./presets/lean

# 驗證命令解析結果
specify preset resolve speckit.specify

# 完成後移除
specify preset remove lean
```

## 授權

MIT
