---
description: "建立功能規格（預設集覆寫）"
scripts:
  sh: scripts/bash/create-new-feature.sh "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 "{ARGS}"
---

## 使用者輸入

```text
$ARGUMENTS
```

根據上面的功能描述：

1. **建立功能分支**，執行指令碼：
   - Bash：`{SCRIPT} --json --short-name "<short-name>" "<description>"`
   - JSON 輸出包含 BRANCH_NAME 與 SPEC_FILE 路徑。

2. **讀取 spec-template**，了解你需要填寫的區段。

3. **撰寫規格**到 SPEC_FILE，將每個區段中的佔位符（概覽、需求、驗收標準）換成使用者描述中的細節。
