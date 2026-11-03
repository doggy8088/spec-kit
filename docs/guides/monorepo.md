# 在 Monorepo 中使用 Spec Kit

Spec Kit 專案是**以目錄為範圍**的：專案就是包含 `.specify/` 的那個目錄。一個 monorepo 可以在單一儲存庫根目錄下放多個獨立的 Spec Kit 專案，每個專案都有自己的 `.specify/`、`specs/`、憲章與功能編號。

根目錄解析本來就優先採用**最近的** `.specify/`，而不是 Git 頂層目錄，所以從成員專案內部執行的命令會解析到該專案，而不是儲存庫根目錄。

儲存庫版面與介面設計是兩回事。當專案彼此互動時，使用[契約驅動開發](contract-driven-development.md)來定義它們之間的協議，每份契約由單一權威擁有者負責。同一儲存庫中的專案可以直接參照該契約；不同儲存庫中的專案則可以使用有版本的產出物或同步副本。

## 版面

```text
my-monorepo/
├── .git/                     # one Git repository at the root
├── apps/
│   ├── web/
│   │   └── .specify/         # Spec Kit project "web"
│   │       └── memory/constitution.md
│   └── api/
│       └── .specify/         # Spec Kit project "api"
│           └── memory/constitution.md
└── packages/
    └── ui/
        └── .specify/         # Spec Kit project "ui"
```

獨立初始化每個成員專案：

```bash
specify init apps/web --integration claude
specify init apps/api --integration claude
```

每個專案都保留自己的 `specs/` 目錄，並獨立編號功能（`apps/web/specs/001-…`、`apps/api/specs/001-…`）。

## 在成員專案內部工作

預設工作流程不變：切換到專案目錄，再執行 slash 命令。根目錄解析會找到最近的 `.specify/`。

```bash
cd apps/web
# then run /speckit.specify, /speckit.plan, … in your agent
```

## 從儲存庫根目錄指定成員專案

對於不想 `cd` 的非互動或 CI 執行，把 **`SPECIFY_INIT_DIR`** 設定為成員專案根目錄（即*包含* `.specify/` 的目錄）。相對路徑會以目前目錄為基準解析。

```bash
# operate on apps/web from the monorepo root (no cd required)
export SPECIFY_INIT_DIR=apps/web
```

該路徑必須存在且包含 `.specify/`。若不符合，命令**會出錯，且不會回退**到目前目錄或 Git 頂層目錄。這是刻意的：打錯字永遠不會把規格寫進錯誤的專案。不存在的路徑會照你輸入的樣子回報；存在但不是 Spec Kit 專案的路徑，則會以其解析後的絕對路徑回報：

```text
# SPECIFY_INIT_DIR=apps/wbe  (typo: no such directory)
ERROR: SPECIFY_INIT_DIR does not point to an existing directory: apps/wbe

# SPECIFY_INIT_DIR=apps  (exists, but has no .specify/ of its own)
ERROR: SPECIFY_INIT_DIR is not a Spec Kit project (no .specify/ directory): /home/you/my-monorepo/apps
```

`SPECIFY_INIT_DIR` 選的是**專案**；`SPECIFY_FEATURE_DIRECTORY` 選的是**功能**。相對的功能路徑會接到該專案根目錄上，不做包含檢查，所以像 `../shared-feature` 這樣的值仍會解析到專案之外；絕對路徑則照原樣使用，同樣可能指向專案根目錄之外。無論哪種情況，所選的功能目錄都不必位於專案之內——專案根目錄識別的是 Spec Kit 專案及其命令／設定脈絡，而不是功能文件的包含邊界。兩者可以組合：同時設定兩者，就能以非互動方式選定專案與功能。完整的契約與雙軸模型，請見 [`SPECIFY_INIT_DIR` 參考](../reference/core.md#environment-variables)。

`specify` CLI 的專案範圍子命令也遵循同一個變數，所以它們同樣能從根目錄指定成員專案，不需要 `cd`：

```bash
export SPECIFY_INIT_DIR=apps/web
specify workflow list          # lists apps/web's workflows
specify integration status     # reports apps/web's integration
```

驗證規則相同：路徑必須存在且包含 `.specify/`，且不會回退到目前目錄。

## `SPECIFY_INIT_DIR` 如何傳到你的代理

`SPECIFY_INIT_DIR` 由 slash 命令呼叫的 shell script 讀取（Bash 中的 `get_repo_root`、PowerShell 中的 `Get-RepoRoot`）。只有當它出現在執行那些 script 的 shell 環境中時才生效。

- **Script 化／CI 執行：**在驅動命令的同一個 shell 中匯出它；在那裡它是可靠的。
- **互動式代理：**匯出的變數是否能傳到代理使用的 shell 工具，取決於代理。請在啟動代理*之前*匯出 `SPECIFY_INIT_DIR`，並驗證一次（例如執行 `/speckit.specify`，確認新功能落在預期專案的 `specs/` 下）。

## Monorepo 中的 Git

> [!NOTE]
> Spec Kit 專案檔案以**解析後的專案根目錄**為範圍，但 Git 操作仍在包含它的 Git 工作樹中執行。在根目錄只有單一 Git 儲存庫、專案位於子目錄的 monorepo 中，建立功能分支會在共用的根儲存庫中建立或切換分支。規格目錄仍位於所選的成員專案下，而 Git 分支命名空間則由整個 monorepo 共用。請在儲存庫根目錄管理分支與提交，或為每個成員專案各自初始化 Git，以取得隔離的專案專屬分支命名空間。

## 憲章

每個成員專案都有自己的 `.specify/memory/constitution.md`，而 `/speckit.constitution` 編輯的是本地專案的檔案。Spec Kit 沒有內建的基礎／繼承機制；若你想讓一份憲章參照 monorepo 其他位置的共用規則，需要自行維護那套接線。否則，就為每個專案複製或同步共用的工程規則。
