# 我的預設集

一個為 Spec Kit 打造的自訂預設集。複製這個目錄並加以修改，即可建立你自己的預設集。

## 包含的範本

| 範本 | 類型 | 說明 |
|----------|------|-------------|
| `spec-template` | template | 自訂功能規格範本（覆寫核心與擴充功能） |
| `myext-template` | template | 覆寫 myext 擴充功能的報告範本 |
| `speckit.specify` | command | 自訂規格命令（覆寫核心） |
| `speckit.myext.myextcmd` | command | 覆寫 myext 擴充功能的 myextcmd 命令 |

## 開發

1. 複製這個目錄：`cp -r presets/scaffold my-preset`
2. 編輯 `preset.yml` — 設定預設集的 ID、名稱、說明與範本
3. 在 `templates/` 中新增或修改範本
4. 本機測試：`specify preset add --dev ./my-preset`
5. 驗證解析結果：`specify preset resolve spec-template`
6. 測試完成後移除：`specify preset remove my-preset`

## 資訊清單參考（`preset.yml`）

必填欄位：
- `schema_version` — 一律為 `"1.0"`
- `preset.id` — 小寫英數字加上連字號
- `preset.name` — 易讀的名稱
- `preset.version` — 語意化版本（例如 `1.0.0`）
- `preset.description` — 簡短說明
- `requires.speckit_version` — 版本條件（例如 `>=0.1.0`）
- `provides.templates` — 範本清單，包含 `type`、`name` 與 `file`

## 範本類型

- **template** — 文件骨架（spec-template.md、plan-template.md、tasks-template.md 等）
- **command** — AI 代理工作流程提示詞（例如 speckit.specify、speckit.plan）
- **script** — 自訂指令碼（保留供未來使用）

## 發佈

詳情請參閱[預設集發佈指南](../PUBLISHING.md)，說明如何提交至目錄。

## 授權

MIT
