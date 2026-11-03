---
description: "示範擴充功能運作方式的範例命令"
# CUSTOMIZE: 列出此命令使用的 MCP 工具
tools:
  - 'example-mcp-server/example_tool'
---

# 範例命令

<!-- CUSTOMIZE: 將整個檔案換成你的命令文件 -->

這是範例命令，示範如何為 Spec Kit 擴充功能建立命令。

## 用途

說明這個命令的功能，以及何時使用它。

## 前置條件

使用本命令前，先列出需求：

1. 前置條件 1（例如「已設定 MCP 伺服器」）
2. 前置條件 2（例如「設定檔已存在」）
3. 前置條件 3（例如「有效的 API 憑證」）

## 使用者輸入

$ARGUMENTS

## 步驟

### 步驟 1：載入設定

<!-- CUSTOMIZE: 換成你的實際步驟 -->

從專案載入擴充功能設定：

``bash
config_file=".specify/extensions/my-extension/my-extension-config.yml"

if [ ! -f "$config_file" ]; then
  echo "❌ Error: Configuration not found at $config_file"
  echo "Run 'specify extension add my-extension' to install and configure"
  exit 1
fi

# Read configuration values

setting_value=$(yq eval '.settings.key' "$config_file")

# Apply environment variable overrides

setting_value="${SPECKIT_MY_EXTENSION_KEY:-$setting_value}"

# Validate configuration

if [ -z "$setting_value" ]; then
  echo "❌ Error: Configuration value not set"
  echo "Edit $config_file and set 'settings.key'"
  exit 1
fi

echo "📋 Configuration loaded: $setting_value"
``

### 步驟 2：執行主要動作

<!-- CUSTOMIZE: 換成你的命令邏輯 -->

說明這個步驟的內容：

``markdown
Use MCP tools to perform the main action:

- Tool: example-mcp-server example_tool
- Parameters: { "key": "$setting_value" }

This calls the MCP server tool to execute the operation.
``

### 步驟 3：處理結果

<!-- CUSTOMIZE: 視需要增加更多步驟 -->

處理結果並提供輸出：

`` bash
echo ""
echo "✅ Command completed successfully!"
echo ""
echo "Results:"
echo "  • Item 1: Value"
echo "  • Item 2: Value"
echo ""
``

### 步驟 4：儲存輸出（選用）

如有需要，將結果儲存到檔案：

``bash
output_file=".specify/my-extension-output.json"

cat > "$output_file" <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "setting": "$setting_value",
  "results": []
}
EOF

echo "💾 Output saved to $output_file"
``

## 設定參考

<!-- CUSTOMIZE: 記錄設定選項 -->

本命令使用 `my-extension-config.yml` 中的下列設定：

- **settings.key**：說明這個設定的用途
  - 類型：string
  - 必填：是
  - 範例：`"example-value"`

- **settings.another_key**：說明另一個設定的用途
  - 類型：boolean
  - 必填：否
  - 預設：`false`
  - 範例：`true`

## 環境變數

<!-- CUSTOMIZE: 記錄環境變數覆寫方式 -->

設定可透過環境變數覆寫：

- `SPECKIT_MY_EXTENSION_KEY` - 覆寫 `settings.key`
- `SPECKIT_MY_EXTENSION_ANOTHER_KEY` - 覆寫 `settings.another_key`

範例：
``bash
export SPECKIT_MY_EXTENSION_KEY="override-value"
``

## 疑難排解

<!-- CUSTOMIZE: 加入常見問題與解決方式 -->

### "Configuration not found"

**解決方式**：安裝擴充功能並建立設定：
``bash
specify extension add my-extension
cp .specify/extensions/my-extension/config-template.yml \
   .specify/extensions/my-extension/my-extension-config.yml
``

### "MCP tool not available"

**解決方式**：確認 MCP 伺服器已在你的 AI 代理設定中完成設定。

### "Permission denied"

**解決方式**：檢查外部服務中的憑證與權限。

## 備註

<!-- CUSTOMIZE: 加入實用的備註與提示 -->

- 本命令需要與外部服務保持連線
- 結果會快取以提升效能
- 重新執行命令即可重新整理資料

## 範例

<!-- CUSTOMIZE: 加入使用範例 -->

### 範例 1：基本用法

``bash

# Run with default configuration
>
> /speckit.my-extension.example
``

### 範例 2：使用環境變數覆寫

``bash

# Override configuration with environment variable

export SPECKIT_MY_EXTENSION_KEY="custom-value"
> /speckit.my-extension.example
``

### 範例 3：在核心命令之後使用

``bash

# Use as part of a workflow
>
> /speckit.tasks
> /speckit.my-extension.example
``

---

*如需更多資訊，請參閱擴充功能的 README，或執行 `specify extension info my-extension`*
