# 預設集

預設集是可堆疊、依優先順序排列的 Spec Kit 範本、命令與指令碼自訂組合。用預設集來落實組織標準、讓 Spec Kit 流程配合你的方法論，或調整術語，而不必分叉核心檔案。擴充功能是增加能力；預設集改變的是既有能力的運作方式。

> [!IMPORTANT]
> 安裝第三方預設集之前，請先審查其原始碼。社群型錄只是探索管道，不是安全性背書。維護者只檢查型錄項目的完整性與格式，不會審查、稽核、背書或支援社群預設集的程式碼。

## 快速入門

請在已用 `specify init` 初始化的專案內執行預設集命令：

```bash
# Discover presets without installing them
specify preset search
specify preset info lean

# Install a bundled preset
specify preset add lean

# Inspect installed presets and template resolution
specify preset list
specify preset resolve spec-template

# Remove it and restore the surviving layers
specify preset remove lean
```

若是你自行撰寫或已審查過的預設集，請用 `specify preset add --dev ./my-preset` 安裝本機副本，或用 `specify preset add --from <archive-url>` 安裝固定版本的發布封存檔。本機安裝會複製原始碼，不是連結到開發目錄的即時連結。社群搜尋結果本身並不允許以 ID 安裝。

## 預設集如何生效

範本決定產出內容，例如規格或計畫。命令包含程式代理遵循的指示，用來產出這些內容。指令碼提供可執行的行為，安裝時須以審查其他程式碼的同等標準看待。

每個邏輯檔名都會透過以下各層獨立解析：

| 優先順序 | 層級 |
| --- | --- |
| 最高 | `.specify/templates/overrides/` 中的專案本機覆寫 |
| 其次 | 已啟用的預設集，依優先順序、再依預設集 ID 排序 |
| 其次 | 已啟用的擴充功能貢獻，依優先順序、再依擴充功能 ID 排序 |
| 最低 | Spec Kit 核心預設值 |

數字較小的優先順序優先。預設集與擴充功能的優先順序只在各自的層內排序；擴充功能無法靠選一個較小的數字就凌駕於預設集層之上。

範本與指令碼會在需要時解析。命令則是在安裝與協調期間，具體化為使用中整合的命令檔或技能；代理不會在每次呼叫時重新解析整個堆疊。切換預設整合會為該整合重新搭建已啟用的預設集。通用整合不會註冊預設集的命令或技能覆寫。

未安裝任何預設集時，專案覆寫、擴充功能貢獻與核心預設值仍會繼續生效。

## 堆疊與組合

請以不同的優先順序安裝多個已審查的預設集：

```bash
specify preset add --dev ./team-base --priority 10
specify preset add --dev ./compliance --priority 5
specify preset set-priority compliance 3
```

若兩個預設集都以預設的 `replace` 策略提供 `spec-template`，`compliance` 會完全勝出。只有 `team-base` 提供的檔案仍會使用該預設集。優先順序相同時，依預設集 ID 的字母順序解析。

預設集可以擴增較低層的內容，而不必取代它們：

| 策略 | 效果 |
| --- | --- |
| `replace` | 完全使用這一層；忽略較低層 |
| `prepend` | 把這一層放在較低優先順序內容之前 |
| `append` | 把這一層放在較低優先順序內容之後 |
| `wrap` | 在這一層的佔位符處插入較低優先順序的內容 |

範本與命令支援全部四種策略。指令碼只支援 `replace` 與 `wrap`。組合需要一個較低層的 `replace` 基礎；包裝層必須包含適當的佔位符。API 參考文件定義了確切的規則。

## 憲章生命週期

初始化時會以解析後的 `constitution-template` 將 `.specify/memory/constitution.md` 植入一次，並保留既有的憲章。之後執行 `/speckit.constitution` 時，會解析目前組合後的範本，並以即時憲章作為專案專屬值與修訂的依據。

預設情況下，安裝、移除、啟用、停用或調整預設集優先順序時，不會重寫即時憲章。內建的 `constitution-sync` 預設集選擇加入了有防護的安裝期具體化與命令期傳播功能。啟用期間，堆疊變更可能會刷新未經更動的已產生憲章，但自行撰寫或手動編輯的憲章會受到保護。安裝此預設集也可以植入缺少的憲章。

## 常見問題

### 如何查看正在使用哪個檔案？

範本請用 `specify preset resolve spec-template`，命令請用 `specify preset resolve speckit.specify`。組合後的輸出可能由多個貢獻檔案組成，而非只有一個最終來源路徑。如需完整的成品堆疊（含隱藏層），請用 `specify artifact info <name> --json`。

### 停用與移除相同嗎？

不同。停用會將預設集排除於後續解析之外，但先前已註冊的命令與技能會留在原處。若需要清理那些已交付的覆寫並還原存續的各層，請使用移除。

### 由誰支援預設集？

請透過預設集作者的儲存庫聯絡作者。納入社群型錄並不會把維護或支援責任轉移給 Spec Kit 維護者。

## 另請參閱

- [CLI 參考文件](cli.md)
- [開發預設集](developing.md)
- [API 參考文件](api.md)
- [型錄](catalogs.md)
- [發布預設集](publishing.md)
- [社群預設集](../community/presets.md)
- [選擇自訂建構元件](../how-to/customization.md)
