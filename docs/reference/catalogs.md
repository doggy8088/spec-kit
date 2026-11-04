# 型錄

型錄是讓 Specify 探索整合、擴充功能、預設集、工作流程、工作流程步驟類型與套件組的索引。Spec Kit 內建型錄，包括可用的社群型錄，也讓專案或使用者新增私人型錄來源。

型錄不是所有元件類型共用的單一登錄。每種元件類型都有自己的型錄結構描述、命令群組、設定與解析堆疊。彙整多種元件類型的組織，通常會為每種類型各發佈一個型錄檔案。

## 探索元件

搜尋會使用該元件類型的所有啟用中型錄：

```bash
specify integration search <query>
specify extension search <query>
specify preset search <query>
specify workflow search <query>
specify workflow step search <query>
specify bundle search <query>
```

使用對應的版本檢視來檢查公告的版本：

```bash
specify integration info <id> --versions
specify extension info <id> --versions
specify preset info <id> --versions
specify workflow info <id> --versions
specify workflow step info <id> --versions
specify bundle info <id> --versions
```

純 `info` 輸出與 `--versions` 顯示的詳細資訊因元件類型而異。版本檢視列出目前與歷史的型錄版本，並在支援時標示勝出來源為可安裝或僅供探索。僅供探索的版本即使出現在版本清單中，仍無法依 ID 安裝。請使用元件的 `catalog list` 命令確認啟用中的來源與安裝原則，不要只依賴純 `info` 輸出。

你也可以瀏覽維護中的社群清單，包括[擴充功能](../community/extensions.md)、[預設集](../community/presets.md)、[套件組](../community/bundles.md) 與[工作流程步驟類型](../community/workflow-steps.md)。

## 檢查與管理型錄來源

在從不熟悉的專案安裝元件前，先列出啟用中的型錄堆疊：

| 元件類型 | 列出啟用中的型錄 | 詳細參考 |
| --- | --- | --- |
| 整合 | `specify integration catalog list` | [整合](../integrations/cli.md#catalog-management) |
| 擴充功能 | `specify extension catalog list` | [擴充功能](extensions.md#catalog-management) |
| 預設集 | `specify preset catalog list` | [預設集](presets.md#catalog-management) |
| 工作流程 | `specify workflow catalog list` | [工作流程](workflows.md#catalog-management) |
| 工作流程步驟 | `specify workflow step catalog list` | [工作流程](workflows.md#catalog-management) |
| 套件組 | `specify bundle catalog list` | [套件組](bundles.md#manage-catalog-sources) |

每個命令群組也提供 `catalog add` 與 `catalog remove`。選項、識別碼、安裝原則與設定檔名因元件類型而異，因此變更型錄堆疊前請先查閱連結的參考文件。

型錄範圍與優先順序使用兩種模型：

- **整合、擴充功能、預設集、工作流程與工作流程步驟**選擇單一設定層。環境變數覆寫會取代一切；否則專案型錄檔案會取代使用者與內建層，使用者檔案會取代內建層，內建型錄只在未設定更高層時使用。在所選層內，項目依數字優先順序排列。因此，新增第一個專案型錄會將內建來源從啟用堆疊中移除，除非你也在專案檔案中列出那些來源。
- **套件組**依來源 ID 合併內建、使用者與專案來源。較高範圍的定義會取代同 ID 的較低範圍來源，然後所有其餘來源依數字優先順序排序。專案來源不會自動凌駕於名稱不同的內建來源。

在成功載入的型錄中，提供某識別碼的較高優先順序項目勝出。部分元件讀取器會跳過一般的取得失敗，繼續處理其餘來源，因此無法連線的較高優先順序來源，可能讓較低優先順序來源解析同一個識別碼。不要將來源優先順序視為失效即關閉的安全控制。

## 探索與信任

型錄清單不是稽核或背書。型錄可以是：

- **允許安裝**：你信任可依元件 ID 安裝的來源。
- **僅供探索**：可搜尋以供評估，但透過該型錄依 ID 安裝會被阻擋。

僅供探索原則不會阻擋另行要求的直接來源安裝，例如受支援的 `--from` URL 或 `--dev` 路徑。使用直接安裝途徑前，請獨立檢視該來源。

社群型錄是探索介面，應保持僅供探索。使用元件前，請檢視其來源與發行成品。若要讓已檢視的元件可在團隊間重用，請將其經審查的項目複製到你的組織所控制的型錄中，而非將未經審查的公開型錄改為允許安裝。

專案型錄設定也是不受信任的輸入。儲存庫可以在 `.specify/` 下新增或排定型錄來源的優先順序，但該設定的存在不代表其來源或元件已獲核准。在從不熟悉的專案安裝或執行元件前，請執行對應的 `catalog list` 命令，並檢查每個允許安裝的來源。

## 代管私人型錄

1. 在註冊允許安裝的來源前，先檢視並核准項目與發行成品。
2. 選擇元件類型，並遵循其型錄結構描述或發佈指南。
3. 將型錄 JSON 發佈在目標使用者可連線的 HTTPS URL。
4. 使用元件的 `catalog add` 命令新增該 URL。
5. 以 `catalog list` 確認產生的來源、優先順序與安裝原則。

`catalog add` 的信任預設值因元件類型而異：

| 元件類型 | 新增時的預設值 |
| --- | --- |
| 整合 | 允許安裝 |
| 擴充功能 | 僅供探索；需要 `--install-allowed` 才能啟用安裝 |
| 預設集 | 僅供探索；需要 `--install-allowed` 才能啟用安裝 |
| 工作流程 | 允許安裝 |
| 工作流程步驟 | 允許安裝 |
| 套件組 | 允許安裝；使用 `--policy discovery-only` 加以限制 |

由於整合、工作流程、工作流程步驟與套件組的新增可能立即允許安裝，不要註冊未經檢視的來源並打算稍後再核准。

撰寫型錄項目時，請使用元件專屬的發佈指引：

| 元件類型 | 發佈指引 |
| --- | --- |
| 整合 | [整合型錄貢獻](../integrations/contributing.md) |
| 擴充功能 | [擴充功能發佈指南](../extensions/publishing.md) |
| 預設集 | [預設集發佈指南](https://github.com/github/spec-kit/blob/main/presets/PUBLISHING.md) |
| 工作流程 | [工作流程發佈指南](https://github.com/github/spec-kit/blob/main/workflows/PUBLISHING.md) |
| 工作流程步驟 | [社群工作流程步驟類型](../community/workflow-steps.md) |
| 套件組 | [社群套件組](../community/bundles.md) |

例如，已檢視的擴充功能型錄可以這樣註冊：

```bash
specify extension catalog add https://catalog.example.com/extensions.json \
  --name approved-extensions \
  --priority 5 \
  --install-allowed
```

預設集、整合、工作流程、工作流程步驟與套件組請使用各自獨立的型錄檔案與命令。它們的詳細參考文件記載了受支援的選項與預期的項目格式。

## 私人與離線環境

若型錄或其元件下載需要憑證，請設定[型錄與下載驗證](authentication.md)。驗證是主動啟用的，且範圍限於明確設定的主機。

在防火牆後方，請將型錄與成品代管在核准的內部 HTTPS 端點，並將那些端點新增到適當的型錄堆疊。在完全斷線的環境中，透過核准的流程傳輸 CLI 與已檢視的元件成品；內建資產在無網路存取時仍可使用。離線安裝 CLI 請參見[企業／氣隙安裝](../install/air-gapped.md)。

外部整合轉接器沒有直接或本機安裝途徑。安裝這類轉接器，需要允許安裝的整合型錄與其參照的封存檔都保持可連線。請參見[透過型錄安裝的外部轉接器](../integrations/cli.md#catalog-installed-external-adapters)。

僅有型錄中繼資料不足以離線安裝：每個所選的發行成品與任何套件組提供的相依項目，也必須可連線或已傳輸到該環境中。
