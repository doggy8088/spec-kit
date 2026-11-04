# 擴充功能範本

建立 Spec Kit 擴充功能的起始範本。

## 快速開始

1. **複製本範本**：

   ```bash
   cp -r extensions/template my-extension
   cd my-extension
   ```

2. **自訂 `extension.yml`**：
   - 變更擴充功能 ID、名稱與說明
   - 更新作者與儲存庫
   - 定義你的命令

3. **建立命令**：
   - 在 `commands/` 目錄中加入命令檔案
   - 使用帶有 YAML frontmatter 的 Markdown 格式

4. **建立設定範本**：
   - 定義設定選項
   - 記錄所有設定

5. **撰寫文件**：
   - 更新 README.md，加入使用說明
   - 加入範例

6. **在本機測試**：

   ```bash
   cd /path/to/spec-kit-project
   specify extension add --dev /path/to/my-extension
   ```

7. **發佈**（選用）：
   - 建立 GitHub 儲存庫
   - 建立 release
   - 提交至型錄（請參閱[擴充功能發佈指南](https://github.github.com/spec-kit/extensions/publishing.html)）

## 本範本中的檔案

- `extension.yml` - 擴充功能資訊清單（請自訂）
- `config-template.yml` - 設定範本（請自訂）
- `commands/example.md` - 範例命令（請替換）
- `README.md` - 擴充功能文件（請替換）
- `LICENSE` - MIT License（請檢視）
- `CHANGELOG.md` - 版本歷程（請更新）
- `.gitignore` - Git 忽略規則

## 自訂檢核清單

- [ ] 以你的擴充功能詳細資料更新 `extension.yml`
- [ ] 將擴充功能 ID 改為你的擴充功能名稱
- [ ] 更新作者資訊
- [ ] 定義你的命令
- [ ] 在 `commands/` 中建立命令檔案
- [ ] 更新設定範本
- [ ] 撰寫含使用說明的 README
- [ ] 加入範例
- [ ] 如有需要，更新 LICENSE
- [ ] 在本機測試擴充功能
- [ ] 建立 Git 儲存庫
- [ ] 建立第一個 release

## 需要協助？

- **開發指南**：請參閱[擴充功能開發指南](https://github.github.io/spec-kit/extensions/developing.html)
- **API 參考**：請參閱[擴充功能 API 參考](https://github.github.io/spec-kit/extensions/api.html)
- **發佈指南**：請參閱[擴充功能發佈指南](https://github.github.com/spec-kit/extensions/publishing.html)
- **使用者指南**：請參閱[擴充功能使用者指南](https://github.github.io/spec-kit/extensions/overview.html)

## 範本版本

- 版本：1.0.0
- 最後更新：2026-01-28
- 相容於 Spec Kit：>=0.1.0
