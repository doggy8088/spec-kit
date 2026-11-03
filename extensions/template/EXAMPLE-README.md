# 範例：擴充功能 README

這是擴充功能 README 在完成自訂後應呈現的範例。
**刪除本檔案，並將 README.md 換成與此類似的內容。**

---

# My Extension

<!-- CUSTOMIZE: 換成你的擴充功能說明 -->

簡要說明你的擴充功能的功能，以及它為何實用。

## 功能

<!-- CUSTOMIZE: 列出主要功能 -->

- 功能 1：說明
- 功能 2：說明
- 功能 3：說明

## 安裝

```bash
# Install from catalog
specify extension add my-extension

# Or install from local development directory
specify extension add --dev /path/to/my-extension
```

## 設定

1. 建立設定檔：

   ```bash
   cp .specify/extensions/my-extension/config-template.yml \
      .specify/extensions/my-extension/my-extension-config.yml
   ```

2. 編輯設定：

   ```bash
   vim .specify/extensions/my-extension/my-extension-config.yml
   ```

3. 設定必填的值：
   <!-- CUSTOMIZE: 列出必填的設定 -->
   ```yaml
   connection:
     url: "https://api.example.com"
     api_key: "your-api-key"

   project:
     id: "your-project-id"
   ```

## 使用方式

<!-- CUSTOMIZE: 加入使用範例 -->

### 命令：example

說明這個命令的功能。

```bash
# In Claude Code
> /speckit.my-extension.example
```

**前置條件**：

- 前置條件 1
- 前置條件 2

**輸出**：

- 這個命令會產生什麼
- 結果儲存在何處

## 設定參考

<!-- CUSTOMIZE: 記錄所有設定選項 -->

### 連線設定

| 設定 | 類型 | 必填 | 說明 |
|---------|------|----------|-------------|
| `connection.url` | string | 是 | API 端點 URL |
| `connection.api_key` | string | 是 | API 驗證金鑰 |

### 專案設定

| 設定 | 類型 | 必填 | 說明 |
|---------|------|----------|-------------|
| `project.id` | string | 是 | 專案識別碼 |
| `project.workspace` | string | 否 | 工作區或組織 |

## 環境變數

透過環境變數覆寫設定：

```bash
# Override connection settings
export SPECKIT_MY_EXTENSION_CONNECTION_URL="https://custom-api.com"
export SPECKIT_MY_EXTENSION_CONNECTION_API_KEY="custom-key"
```

## 範例

<!-- CUSTOMIZE: 加入實際情境範例 -->

### 範例 1：基本工作流程

```bash
# Step 1: Create specification
> /speckit.spec

# Step 2: Generate tasks
> /speckit.tasks

# Step 3: Use extension
> /speckit.my-extension.example
```

## 疑難排解

<!-- CUSTOMIZE: 加入常見問題 -->

### 問題：找不到設定

**解決方式**：從範本建立設定（見「設定」一節）

### 問題：命令無法使用

**解決方式**：

1. 檢查擴充功能是否已安裝：`specify extension list`
2. 重新啟動 AI 代理
3. 重新安裝擴充功能

## 授權

MIT License - 請參閱 LICENSE 檔案

## 支援

- **Issues**：<https://github.com/your-org/spec-kit-my-extension/issues>
- **Spec Kit Docs**：<https://github.com/statsperform/spec-kit>

## 變更紀錄

版本歷程請參閱 [CHANGELOG.md](CHANGELOG.md)。

---

*Extension Version: 1.0.0*
*Spec Kit: >=0.1.0*
