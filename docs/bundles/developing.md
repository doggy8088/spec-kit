# 開發套件組

套件組透過資訊清單與使用文件，散佈既有的元件組合。請先從角色或團隊的成果出發，選取能達成它的元件，並測試它們合併安裝的結果。套件組不能取代擴充功能、預設集、工作流程或步驟的撰寫。

## 建立套件組目錄

請將資訊清單與 README 放在目錄根目錄：

```text
team-setup/
  bundle.yml
  README.md
  LICENSE
```

這個最小範例使用隨附的 bug 擴充功能與工作流程：

```yaml
schema_version: "1.0"
bundle:
  id: team-setup
  name: Team setup
  version: 1.0.0
  role: developer
  description: A bug-fixing setup for the team
  author: Example team
  license: MIT
requires:
  speckit_version: ">=0.9.0"
provides:
  extensions:
    - id: bug
      version: 1.0.2
  workflows:
    - id: bugfix
      version: 1.0.0
tags: [developer, bugfix]
```

請從你已測試過的 release 中選擇釘選版本。相容的較新穩定隨附修補版本可能在發出警告的情況下滿足這些釘選；明確的元件型錄來源仍維持確切釘選的強制執行。

README 應說明預定角色、已安裝的元件、整合需求、使用者需要註冊的型錄、安裝命令，以及如何使用已安裝的設定。若要發布到社群，請附上授權檔案。

## 選取元件及其來源

擴充功能、預設集與工作流程的參照需要確切版本。步驟可以省略版本，此時安裝會選取目前的步驟型錄 release。當再現性重要時，也請釘選步驟版本。

預設集必須宣告至少為 `1` 的整數優先順序與組合策略。擴充功能也可以宣告優先順序；其預設值為 `10`。完整的欄位契約請參閱 API 參考。

選用的元件 `source` 會指名預期獲勝的元件型錄。它不是 URL、目錄，也不是改變型錄優先順序的機制。選取來源之前，請先檢視有效的型錄：

```bash
specify extension catalog list
specify preset catalog list
specify workflow catalog list
specify workflow step catalog list
```

請記載套件組需要的每一個非預設型錄，並附上適當的 `catalog add` 命令。型錄各自獨立：加入套件組型錄並不會加入元件型錄。使用者在授權安裝前必須先審查它們。請使用唯一的元件型錄名稱；與多個有效型錄相符的明確來源會被視為含糊而遭到拒絕。

本機套件組資產會打包以供散佈，但不會自動作為元件承載內容安裝。特別是，將自訂步驟複製到 `steps/<id>/` 之下並不會讓它變得可解析。請透過可存取的步驟型錄發布它，並記載此相依性。

## 組合既有套件組

請使用綱要 `1.1` 與 `provides.bundles` 參照其他套件組的確切 release。例如，在確認該 release 已在你的型錄中提供後：

```yaml
schema_version: "1.1"
bundle:
  id: team-setup
  name: Team setup
  version: 1.0.0
  role: developer
  description: A composed team setup
  author: Example team
  license: MIT
requires:
  speckit_version: ">=0.9.0"
provides:
  bundles:
    - id: bugfix
      version: 1.0.2
      source: default
```

參照會透過有效的套件組型錄解析，包括父項為本機資訊清單時。它們不是本機路徑參照，也不會被 `build` 內嵌。父項自身的元件宣告可以覆寫被參照的宣告；不相容的同層宣告需要父項明確解決。API 參考定義了排序、去重與限制。

第一方套件組型錄目前不保留歷史 release。當型錄推進到下一個 release 時，確切參照可能停止解析。若要長期組合，請使用保留所需歷史紀錄的型錄。

## 驗證與建置

請在含有你的套件組的儲存庫或目錄中執行：

```bash
specify bundle validate --path ./team-setup
specify bundle build --path ./team-setup --output ./dist
```

警告與錯誤都要閱讀。線上驗證會檢查元件解析並展開參照，但不會強制執行執行中 CLI 的 Spec Kit 版本閘門。離線驗證無法確認僅限網路的元件，也無法展開套件組參照。

建置需要一般的 `README.md` 與 `bundle.yml`，並檢查資訊清單結構。它不會確認參照是否解析或安裝是否成功。產生的 ZIP 包含根目錄檔案與本機資產，不含下載的元件承載內容或被參照的套件組。

相同輸入的建置輸出可再現：檔案依其 POSIX 封存路徑排序，時間戳記固定，權限正規化為可執行或不可執行模式。符號連結、`.git`、`__pycache__`、`.DS_Store`、此套件組先前的版本化建置成品，以及巢狀輸出目錄都會被排除。

## 測試安裝與變更

請使用具備預定整合的乾淨專案。註冊任何已審查的相依型錄，再安裝使用者將收到的確切成品：

```bash
specify init --here --integration copilot
specify bundle install /path/to/dist/team-setup-1.0.0.zip
specify bundle list --json
```

請檢查交付的命令，並執行已安裝的工作流程或其他預定能力。重複安裝，確認未變更的元件與本機編輯獲得保留。在獨立元件或其他套件組的元件仍安裝的情況下測試移除。

在本機開發時，一般的重新安裝不是更新操作。請以下列方式套用修訂後的版本、變更的擁有元件設定，或移除的元件：

```bash
specify bundle install /path/to/team-setup/bundle.yml --refresh
```

重新整理可透過元件的更新路徑覆寫擁有的元件，且失敗時不會完整復原。請使用可棄式專案進行此測試。同時測試有效的安裝與相關的拒絕案例，例如無法取得的釘選、整合不符，以及與另一個套件組需求的衝突。

若透過型錄散佈，也請測試從該允許安裝的型錄以 ID 安裝。成功的直接成品安裝無法驗證型錄優先順序、下載中繼資料或歷史 release 選取。

## 另請參閱

- [套件組總覽](overview.md)
- [資訊清單與套件組參照 API](api.md)
- [CLI 參考](cli.md)
- [型錄設定](catalogs.md)
- [發布套件組](publishing.md)
