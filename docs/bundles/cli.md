# 套件組 CLI 參考

`specify bundle` 命令群組可探索、安裝與撰寫套件組。命令說明請使用 `specify bundle <command> --help`。套件組型錄命令有各自的巢狀說明：`specify bundle catalog --help`。

## 專案需求

| 命令 | 專案需求 |
| --- | --- |
| `search`、`info` | 不需要已初始化的專案即可運作；使用使用者與內建型錄，以及任何適用的專案範圍設定 |
| `install`、`add`、`init` | 視需要初始化專案 |
| `list`、`update`、`remove`、`catalog list/add/remove` | 需要已初始化的專案 |
| `validate`、`build` | 在本機套件組來源上運作，不需要初始化專案 |

`search`、`info` 與 `list` 支援 `--json`；其他套件組命令不支援。各命令下方說明了成功的 JSON 輸出形狀。請勿假設所有套件組失敗都會發出 JSON 信封：一般的 bundler 錯誤會以錯誤形式回報，並以非零結束狀態結束。

## 搜尋可用的套件組

```bash
specify bundle search [query]
```

| 選項 | 說明 |
| --- | --- |
| `--offline` | 不存取網路 |
| `--json` | 將 JSON 輸出到 stdout |

搜尋所有有效的型錄。選用的查詢會比對獲勝項目的 ID、名稱、角色、標籤或描述中的子字串。沒有查詢時，會列出每個可用的套件組。每個 ID 只出現一次，來自其最高優先順序的來源，結果依 ID 排序。

文字輸出顯示版本、角色、來源與信任。JSON 是項目陣列，含有 `id`、`name`、`version`、`role`、`description`、`source`、`install_policy`、`verified` 與 `trust`。信任在標示為已驗證的項目為 `verified`，其他為 `community`；它不會改變安裝政策。

## 檢視套件組

```bash
specify bundle info <bundle_id>
specify bundle info <bundle_id> --versions
```

| 選項 | 說明 |
| --- | --- |
| `--offline` | 不存取網路 |
| `--json` | 將 JSON 輸出到 stdout |
| `--versions` | 列出目前與歷史的型錄版本，不下載資訊清單 |

沒有 `--versions` 時，會下載目前的資訊清單並顯示完整展開的元件集合，包括版本、預設集優先順序與策略、整合、來源政策、信任，以及與已安裝套件組的資訊性重疊。必需的元件可能已安裝；此預覽不保證每個元件都會新加入，也不保證所有安裝閘門皆已通過。`info` 不支援本機套件組路徑。

JSON 包含 `id`、`name`、`version`、`role`、`description`、`author`、`license`、`source`、`install_policy`、`provides`、`requires`、`verified`、`trust`、`integration`、`components` 與 `overlaps`。元件項目含有 `kind`、`id`、`version`，以及任何宣告的 `priority` 或 `strategy`。

對於帶有參照的套件組，JSON 還包含：

- `references`：每個被參照套件組的 `id`、`version`、解析後的 `source`、`install_policy`、`via`、`verified` 與 `trust`。
- 元件的 `source`（若有宣告）；扁平套件組會省略此欄位。
- 元件的 `origin`（若由被參照的套件組貢獻），使用最短的來源鏈。
- 元件的 `overrides`（若取代了宣告）。每個項目含有被取代的 `version`、`origin`，以及任何 `source`、`priority` 或 `strategy`。每個不同的宣告套件組都會出現，使用其最短路徑。被覆寫的父項宣告其來源為空。

文字輸出包含參照摘要、來源鏈、覆寫，以及僅供探索的通知。被參照的套件組保留各自的信任層級；它們不會繼承父項的信任。

`--versions --json` 改為發出含有 `id`、`versions`、`current`、`source` 與 `install_policy` 的物件。版本先列出目前的 release，接著是歷史 release，由新到舊。

若資訊清單無法下載或展開，`info` 會失敗，而不是以型錄元件數量替代經過驗證的展開結果。

## 安裝套件組

```bash
specify bundle install <bundle_id-or-path>
specify bundle add <bundle_id-or-path>
```

`add` 接受與 `install` 相同的引數與選項。

| 選項 | 說明 |
| --- | --- |
| `--integration <id>` | 為初始化選取整合，或在無法確定現用整合時確認一個 |
| `--offline` | 不存取網路 |
| `--refresh` | 從提供的來源重新套用擁有的元件 |
| `--version <version>` | 選取確切的目前或歷史型錄 release |

引數可以是型錄 ID、本機套件組目錄、資訊清單檔案，或根目錄含有 `bundle.yml` 的已建置 ZIP。本機來源會繞過套件組型錄，除非它們宣告套件組參照，而參照會透過型錄堆疊解析。封存檔 URL 不是直接的安裝引數：請先下載、審查，再傳入其本機路徑，或使用允許安裝的型錄。

### 初始化與整合

若專案不存在，安裝會先解析資訊清單與硬性相容閘門，再初始化專案。整合選取依序使用明確的選項、套件組宣告的整合，再使用 CLI 的預設值。

在既有專案中，記錄的現用整合具有權威性。`--integration` 不會切換它，也不會繞過套件組整合不符的情況。當釘選套件組的現用專案整合因 `.specify/integration.json` 遺失或無法讀取而無法確定時，請以 `--integration` 確認目標，或修復專案。

與整合無關的套件組會繼承現用整合。根套件組是整合閘門；被參照套件組中不同或無法確定的整合目標會產生警告。

### 重新安裝與重新整理

一般的安裝會略過相容的已安裝元件，並保留其本機編輯。不同或未知的已安裝版本無法滿足釘選，下方的隨附修補規則除外。獨立安裝的元件絕不會被採用或取代。

一般的重新安裝會拒絕對記錄的套件組版本或擁有元件中繼資料的變更，包括移除擁有的元件，即使本機資訊清單保持相同的套件組版本。重新排序未變更的元件或加入元件不需要重新整理。

若要套用修訂後的本機來源：

```bash
specify bundle install ./new-release/bundle.yml --refresh
```

重新整理會透過元件的基礎構件更新路徑，重新套用套件組擁有的元件，並保留基礎構件層級的覆寫，例如預設集優先順序。它可以修復僅由此套件組擁有的版本漂移。它會移除被省略的擁有元件，除非另一個套件組仍需要它們；獨立安裝的元件保持不動，並回報已重新整理與已移除的數量。

所有需要某個共用元件的套件組，都必須在釘選、來源與相關設定上一致。未釘選的重新整理無法取代另一個套件組以釘選需要的版本；不經重新整理而共用相符的已安裝版本仍被允許。需求比較規則請參閱 API 參考。

套件組紀錄只在安裝成功後才會推進。元件失敗時，新安裝的元件會盡力移除。復原移除的錯誤會被吞掉，因此磁碟上可能殘留部分狀態。在重新整理期間修改或移除的先前已安裝元件不會被還原。初始化也不會被復原。

### 隨附修補相容性

對於隨 Spec Kit 出貨的擴充功能、預設集與工作流程，在未宣告元件 `source` 時，釘選主／次版本內的較新穩定修補版本會在發出警告的情況下被接受。例如，隨附的 `bug` 版本 `1.0.1` 可以滿足套件組的 `1.0.0` 釘選。驗證使用相同的警告。

降級、主／次版本差異，以及不同的預發布版本不在此例外範圍內。明確的來源與型錄解析的 release 仍維持確切釘選的強制執行。修補 release 不保證行為不變。

要求的釘選保留在 `required_components` 與 `contributed_components` 中。已知的實際版本另外記錄在 `installed_versions` 下，並由 `bundle list --json` 顯示。

### 確切的型錄 release

`--version` 會選取獲勝型錄刊登的套件組 release。它不會覆寫該 release 內元件的釘選。它不能為空、不能搭配本機來源使用，也不能與 `--refresh` 併用。

```bash
specify bundle install team-setup --version 1.1.0
```

缺少的版本不會退回優先順序較低的來源。僅供探索的來源仍不可安裝，包括歷史 release。release 歷史需求請參閱型錄參考。

### 離線限制

本機資訊清單、目錄或 ZIP 可以搭配 `--offline` 安裝隨附元件。本機套件組資產不是元件承載內容的來源。透過型錄解析的元件在安裝或重新整理時需要網路存取，即使已安裝且正在重新整理也一樣。

型錄套件組資訊清單與被參照的套件組資訊清單需要透過網路下載。本機根可以識別離線錯誤中第一個未解析的套件組參照；型錄根可能在擷取其型錄或根資訊清單時更早失敗。隨附的型錄快照可供探索，不能用於離線的型錄 ID 安裝。

步驟承載內容僅透過步驟型錄解析。套件組本機的 `steps/<id>/` 目錄與相對步驟 `source` 值不會被解析為承載內容，因此將步驟目錄打包並不會讓它可離線安裝。

## 更新套件組

```bash
specify bundle update <bundle_id>
specify bundle update --all
```

| 選項 | 說明 |
| --- | --- |
| `--all` | 更新每個已安裝的套件組 |
| `--integration <id>` | 僅在無法確定專案的現用整合時確認一個整合 |
| `--offline` | 不存取網路 |

需要已安裝的套件組與允許安裝的來源。它會重新解析父項目前的型錄 release 及其釘選的套件組參照，再以與 `install --refresh` 相同的生命週期與修補相容性規則重新整理擁有的元件。`update` 不會保留歷史的 `install --version` 選取。

每個元件釘選會從其獲勝型錄選取確切的 release；bundler 不會猜測舊的下載 URL，也不會嘗試優先順序較低的型錄。未刊登版本的舊版擴充功能與預設集項目無法強制執行其釘選或驗證封存檔的版本。請發布具版本的項目，使那些釘選可強制執行。未釘選的步驟會選取目前的型錄 release。

沒有明確的 `source` 時，隨附的擴充功能與預設集優先於型錄 release。不相容的隨附釘選即使存在相符的型錄 release 也會被拒絕。隨附的工作流程在相容時使用隨附版本，或在適當且可連線時使用其型錄 release。

`--all` 會依序處理套件組，失敗時停止；先前成功的更新不會被復原。

## 移除套件組

```bash
specify bundle remove <bundle_id>
```

只會解除安裝其他套件組不再需要的貢獻元件。沒有其餘擁有者的保留元件會轉移給其餘需要它的套件組，以便日後移除時清理。獨立安裝的元件絕不會被採用。

移除不是交易性的。元件失敗可能留下部分解除安裝的專案，而套件組紀錄保持不變；命令會回報失敗與復原上下文。

## 列出已安裝的套件組

```bash
specify bundle list
```

| 選項 | 說明 |
| --- | --- |
| `--json` | 將 JSON 輸出到 stdout |

顯示已安裝的套件組 ID、版本、必需的元件數量，以及原始安裝時間戳記。數量包括獨立提供的元件。JSON 是已安裝紀錄的陣列，使用 API 參考的紀錄形狀，包括選用的 `installed_versions` 與 `bundle_references`。

## 以套件組初始化專案

```bash
specify bundle init [bundle_id]
```

| 選項 | 說明 |
| --- | --- |
| `--integration <id>` | 初始化的整合覆寫 |
| `--offline` | 不存取網路 |

確保專案存在，再視需要安裝套件組。重複不變的安裝會略過既有元件並保留編輯。它遵循一般的安裝規則，而非重新整理規則：記錄的版本或擁有元件變更，請使用 `update` 或 `install <path> --refresh`。

## 驗證套件組

```bash
specify bundle validate --path ./team-setup
```

| 選項 | 說明 |
| --- | --- |
| `--path <path>` | 套件組目錄或資訊清單；預設為目前目錄 |
| `--offline` | 對照隨附／已安裝的元件檢查，不使用網路存取 |

檢查資訊清單結構與元件解析。線上驗證會展開套件組參照，並檢查展開計畫中的循環、版本、來源、衝突與安裝政策。明確的元件來源會對照獲勝的型錄檢查，而不是對照本機元件。

缺少的 release、不符或含糊的來源、僅供探索的來源，以及格式錯誤的型錄中繼資料，都會使驗證失敗。無法驗證的元件參照，包括無法連線的型錄，會產生警告；無法連線的較高優先順序型錄，無法以較低優先順序的相符項目解決。套件組參照擷取失敗會使線上驗證失敗。

離線驗證會對每個宣告的套件組參照警告一次，表示它未被展開。帶有警告的成功結果並不能證明完整圖可安裝。驗證不會對照 `requires.speckit_version` 檢查執行中的 CLI；安裝／更新會強制執行該閘門。

## 建置套件組成品

```bash
specify bundle build --path ./team-setup --output ./dist
```

| 選項 | 說明 |
| --- | --- |
| `--path <directory>` | 套件組目錄；預設為目前目錄 |
| `--output <directory>` | 成品目的地；預設為套件組目錄 |

產生 `<id>-<version>.zip`，其中包含資訊清單、README 與本機資產。需要一般、非符號連結的 `bundle.yml` 與 `README.md` 檔案，以及結構有效的資訊清單。建置不會解析元件或下載被參照的套件組；它不能取代線上驗證。

## 管理型錄來源

```bash
specify bundle catalog list
specify bundle catalog add <url>
specify bundle catalog remove <id-or-url>
```

`list` 會印出使用中的堆疊，含 ID、URL、優先順序、範圍與政策。`add` 與 `remove` 會寫入專案範圍的設定。

| `catalog add` 選項 | 說明 |
| --- | --- |
| `--policy <policy>` | `install-allowed`（預設）或 `discovery-only` |
| `--priority <integer>` | 數字較小者優先順序較高；預設為 `10` |
| `--id <id>` | 明確的來源 ID；否則由 URL 或路徑衍生 |

以相符的設定重新加入相同的來源不會有任何作用；衝突的設定會失敗。內建來源無法刪除。移除內建 ID 的專案覆寫會還原較低範圍的來源。

## 另請參閱

- [套件組總覽](overview.md)
- [資訊清單、展開與紀錄契約](api.md)
- [型錄設定與 release 歷史](catalogs.md)
- [開發套件組](developing.md)
- [發布套件組](publishing.md)
