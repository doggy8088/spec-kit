---
description: "覆寫 myext 擴充功能的 myextcmd 命令"
---

<!-- Preset override for speckit.myext.myextcmd -->

你正在遵循 myext 擴充功能 myextcmd 命令的自訂版本。

執行這個命令時：

1. 從 $ARGUMENTS 讀取使用者的輸入
2. 遵循標準的 myextcmd 工作流程
3. 此外，套用這個預設集的下列自訂設定：
   - 繼續之前先加入合規檢查
   - 在輸出中納入稽核軌跡項目

> CUSTOMIZE：將以上指示換成你自己的內容。
> 這個檔案會覆寫「myext」擴充功能所提供的命令。
> 安裝這個預設集後，所有代理（Claude、Gemini、Copilot 等）
> 都會使用這個版本，而不是擴充功能的原版。
