# 開發工作流程步驟

自訂步驟類型以 `specify workflow step` 安裝。步驟是由中繼資料與可執行 Python 組成的目錄套件。

## 自訂步驟套件

```text
my-step/
├── step.yml        # required, at the package root
├── __init__.py     # required, at the package root
└── helpers.py      # optional nested modules and data files
```

`step.yml` 宣告步驟的身分。`step.type_key` 必須與命令列傳入的 `<step_id>` 精確相符：ID 永遠不會從套件內容推斷：

```yaml
step:
  type_key: my-step
  name: My Step
  version: 0.1.0
  author: you
  description: What this step does
```

`__init__.py` 必須定義一個 `StepBase` 子類別，其 `type_key` 相符：

```python
from specify_cli.workflows.base import StepBase, StepResult


class MyStep(StepBase):
    type_key = "my-step"

    def execute(self, config, context):
        return StepResult(output={"ok": True})
```

### 套件驗證

每個來源在提交任何內容之前，都會以相同方式驗證：

- `step.yml` 與 `__init__.py` 必須是套件根目錄的一般、非符號連結檔案。
- 套件樹會遞迴複製（支援相對匯入、巢狀輔助模組與資料檔案）。符號連結的套件根目錄、任何子孫符號連結，以及任何不是一般檔案或目錄的檔案系統物件都會被拒絕。
- `.git`、`__pycache__` 與 `.DS_Store` 項目會在不檢查的情況下跳過：它們不會被複製，被排除的目錄不會進入，且不計入任何上限。
- 已安裝套件原則最多允許 **512 個保留項目**（檔案與目錄合計）、最多**32 層**目錄巢狀，以及**50 MiB** 的保留內容。
- 封存檔 URL 在套件驗證之前，還會通過傳輸／解壓縮安全上限：最多 512 個封存檔項目、50 MiB 的下載或解壓縮量，以及每個封存檔成員 10 MiB。型錄檔案的每個回應上限為 50 MiB。
- 安裝會驗證並複製套件，但**不會**匯入或執行 `__init__.py`。已安裝的自訂步驟模組會在 `workflow add`、`workflow run` 與 `workflow resume` 啟動期間載入，在任何特定自訂步驟必然執行之前。

> **安全注意**：載入自訂步驟會以**您**的權限執行其 Python。只安裝並保留來自您信任來源的步驟套件。

## 實作自訂步驟

請遵循 [Python API 參考](api.md)：將 `StepBase` 子類別化，為套件與實作指定相同的 `type_key`，並回傳明確的狀態、輸出與錯誤。請覆寫 `validate()`，並也在 `execute()` 中防護無效的設定：執行時不會自動呼叫驗證器。

在同時扇出期間，步驟執行個體可能從多個執行緒呼叫，因此請保持執行無狀態且執行緒安全；將每次執行的資料儲存在 `config` 與 `context`，而非 `self`。讓引擎擁有檢查點與生命週期轉換。

本機反覆運算請使用 `specify workflow step add my-step --dev ./my-step`，編輯後加上 `--force`。來源驗證與取代失敗行為，請參閱[步驟安裝參考](cli.md#步驟管理)。

## 本機測試

請測試有效與無效的設定、回傳的狀態、輸出與錯誤。透過小型工作流程演練該類型，包含相關的繼續執行、巢狀步驟與同時執行路徑。當套件或工作流程可能產生副作用時，請使用可拋棄的已初始化專案。

## 套件組本機限制

套件組的 `provides.steps` 仍只透過使用中的步驟型錄解析。套件組本機的 `steps/<id>/` 酬載與相對的 `provides.steps[].source` 覆寫，在此版本中**不會**被解析，因此這類步驟無法離線安裝。請參閱[套件組離線限制](../bundles/cli.md#離線限制)。

## 另請參閱

- [步驟總覽](overview.md)
- [Python API 參考](api.md)
- [步驟安裝 CLI](cli.md)
- [發佈步驟](publishing.md)
- [社群步驟提交](../community/workflow-steps.md)
- [工作流程執行與繼續執行](../workflows/api.md#執行模型)
