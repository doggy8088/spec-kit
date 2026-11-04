# 驗證

Specify CLI 對型錄來源、擴充功能下載與版本檢查的 HTTP 請求，使用**主動啟用的驗證**。除非你明確設定，否則不會傳送任何憑證。

## 設定

建立 `~/.specify/auth.json` 以啟用驗證：

```json
{
  "providers": [
    {
      "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    }
  ]
}
```

> **安全性：**將檔案限制為僅擁有者可存取：
>
> ```bash
> chmod 600 ~/.specify/auth.json
> ```

沒有此檔案時，所有 HTTP 請求皆未經驗證。

## 欄位

`providers` 陣列中的每個項目都有以下欄位：

| 欄位 | 必要 | 說明 |
|---|---|---|
| `hosts` | 是 | 此項目適用的主機名稱陣列。支援精確主機名稱，或以 `*.` 開頭的萬用字元（僅限子網域，例如 `*.visualstudio.com`）。`*.visualstudio.com` 符合 `foo.visualstudio.com`，但不符合 `visualstudio.com`。不支援其他 glob 模式，例如 `*github.com` 或 `gith?b.com`。 |
| `provider` | 是 | 內建提供者鍵：`github`、`azure-devops` 或 `bitbucket`。 |
| `auth` | 是 | 驗證方案（見下）。 |
| `token` | 否 | 權杖值（內嵌）。盡量改用 `token_env`。 |
| `token_env` | 否 | 讀取權杖的環境變數名稱。 |
| `username` | `basic` 時必要 | Basic 憑證的使用者名稱部分，對於 Bitbucket API 權杖，即 Atlassian 帳號電子郵件。不得包含 `:`。 |

對於 `azure-ad` 驗證，還需要額外欄位：

| 欄位 | 必要 | 說明 |
|---|---|---|
| `tenant_id` | 是 | Azure AD 租戶 ID。 |
| `client_id` | 是 | 服務主體使用者端 ID。 |
| `client_secret_env` | 是 | 包含使用者端密碼的環境變數。 |

對於 `bearer`、`basic-pat` 與 `basic` 方案，必須設定 `token` 或 `token_env` 其中之一。

## 提供者與驗證方案

### GitHub（`github`）

| 方案 | 標頭 | 適用於 |
|---|---|---|
| `bearer` | `Authorization: Bearer <token>` | PAT、細粒度 PAT、OAuth 權杖、GitHub App 權杖 |
| `github-cli` | `Authorization: Bearer <token>` | 透過 `gh auth token` 依需求取得的憑證 |

**範例——透過環境變數使用 PAT：**

```json
{
  "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
  "provider": "github",
  "auth": "bearer",
  "token_env": "GH_TOKEN"
}
```

**範例——GitHub CLI：**

```json
{
  "providers": [
    {
      "hosts": [
        "github.com",
        "api.github.com",
        "raw.githubusercontent.com",
        "codeload.github.com"
      ],
      "provider": "github",
      "auth": "github-cli"
    }
  ]
}
```

使用此模式前，請安裝 [GitHub CLI](https://cli.github.com/) 並執行 `gh auth login`。Specify 會在不使用 shell 的情況下執行固定命令 `gh auth token --hostname github.com`，將結果快取在目前行程的記憶體中，絕不將權杖寫入磁碟。周圍的空白會被修剪；包含非 ASCII 字元、內嵌歸位字元或換行的權杖會被拒絕，且錯誤中不會包含權杖。憑證取得失敗會讓受影響的請求失敗，不會嘗試其他憑證或未經驗證的請求。它們使用既有的 URL 錯誤類別，因此呼叫者保留其正常的錯誤處理（例如警告並略過無法使用的型錄）。版本檢查與升級會保留驗證診斷，而非回報為網路中斷。線上套件組型錄取得與參照驗證會將驗證失敗視為錯誤，而不是可用性備援，退回封裝快照或未檢查的參照。

僅對於 `github-cli`，**`hosts` 中的第一個主機名稱**會傳給 `gh auth token --hostname`。請將 `github.com` 或你的企業執行個體的 GitHub CLI 登入主機名稱放在第一位。它必須是精確主機名稱，不是萬用字元。所有列出的主機仍是獲授權接收該憑證的請求比對目的地；後續項目可以使用受支援的萬用字元。Specify 不會從服務前綴或所請求的 URL 推斷憑證主機名稱。記憶體快取以第一個主機名稱為鍵。對於需要不同憑證的主機，請使用獨立的提供者項目。主機順序對既有的驗證模式沒有影響。

### GitHub Enterprise Server（GHES）

若要使用代管在 GitHub Enterprise Server 執行個體上的私人型錄或擴充功能，請新增列出你的 GHES 主機的 `github` 項目。同一個項目同時驗證型錄 JSON 取得**以及**私人版本資產下載，Specify 會將列出的主機辨識為 GitHub Enterprise，並透過 GHES REST API（`/api/v3`）解析版本下載。

```json
{
  "providers": [
    {
      "hosts": ["ghes.example.com", "raw.ghes.example.com", "codeload.ghes.example.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_ENTERPRISE_TOKEN"
    }
  ]
}
```

列出**裸**網站主機（例如 `ghes.example.com`），版本下載 URL 位於該處。若你的執行個體使用子網域隔離，也請列出你的型錄／擴充功能 URL 使用的 `raw.` 與 `codeload.` 子網域。`*.ghes.example.com` 萬用字元符合子網域，但**不**符合裸主機，因此永遠要明確包含裸主機。

使用 `auth: "github-cli"` 時，將你的企業執行個體的 GitHub CLI 登入主機名稱列在第一位，後面接著應接收相同憑證的任何請求主機或萬用字元模式：

```json
{
  "hosts": [
    "ghes.example.com",
    "raw.ghes.example.com",
    "codeload.ghes.example.com"
  ],
  "provider": "github",
  "auth": "github-cli"
}
```

Specify 會執行 `gh auth token --hostname ghes.example.com`，完全依設定使用第一個主機名稱。不同的 GitHub 執行個體請使用獨立的提供者項目。所選主機必須已在 GitHub CLI 中驗證；失敗時會建議 `gh auth login --hostname <host>`，且不包含 GitHub CLI 命令輸出。

### 具資料落地功能的 GitHub Enterprise Cloud（GHE.com）

GHE.com 租戶使用獨立的網站與 REST API 主機名稱。將兩個主機都列出，讓 Specify 能驗證版本中繼資料查詢與資產下載：

```json
{
  "providers": [
    {
      "hosts": ["tenant.ghe.com", "api.tenant.ghe.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_ENTERPRISE_TOKEN"
    }
  ]
}
```

對於 `tenant.ghe.com` 上的版本 URL，Specify 透過 `api.tenant.ghe.com` 解析中繼資料與版本資產。回傳的資產必須標識相同的擁有者與儲存庫，並使用精確的數字 `/repos/.../releases/assets/...` 端點。像 `*.tenant.ghe.com` 這樣的萬用字元符合 API 主機名稱，但不符合裸租戶網站主機名稱，因此請明確列出網站主機名稱。

### Azure DevOps（`azure-devops`）

| 方案 | 標頭 | 適用於 |
|---|---|---|
| `basic-pat` | `Authorization: Basic base64(:<PAT>)` | Personal Access Token |
| `bearer` | `Authorization: Bearer <token>` | 預先取得的 OAuth／Azure AD 權杖 |
| `azure-cli` | `Authorization: Bearer <token>` | 透過 `az account get-access-token` 取得的權杖 |
| `azure-ad` | `Authorization: Bearer <token>` | 透過 OAuth2 使用者端憑證流程取得的權杖 |

**範例——透過環境變數使用 PAT：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "basic-pat",
  "token_env": "AZURE_DEVOPS_PAT"
}
```

**範例——Azure CLI（互動式登入）：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "azure-cli"
}
```

需要事先已執行 `az login`。

**範例——Azure AD 服務主體（CI／自動化）：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "azure-ad",
  "tenant_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "client_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "client_secret_env": "AZURE_CLIENT_SECRET"
}
```

### Bitbucket（`bitbucket`）

| 方案 | 標頭 | 適用於 |
|---|---|---|
| `bearer` | `Authorization: Bearer <token>` | 儲存庫／專案／工作區存取權杖，或不帶帳號電子郵件傳送的 Atlassian API 權杖（Bitbucket Cloud，**僅限 `api.bitbucket.org`**，見下方說明）；HTTP 存取權杖（Bitbucket Data Center） |
| `basic` | `Authorization: Basic base64(<username>:<token>)` | 對 `api.bitbucket.org` 使用的 Atlassian API 權杖（username 為 Atlassian 帳號電子郵件）。Bitbucket Cloud 應用程式密碼已由 Atlassian 於 2026 年 7 月 28 日移除，請改用 API 權杖或存取權杖。 |

> **主機說明：**Bitbucket Cloud 依主機區分其介面。`api.bitbucket.org` 接受儲存庫／專案／工作區存取權杖作為 Bearer，也接受 Atlassian API 權杖作為 Basic（以帳號電子郵件為使用者名稱）或 Bearer（不需電子郵件），適用於任何 REST 呼叫，包括透過 `GET /2.0/repositories/<workspace>/<repo>/src/<ref>/<path>` 取得型錄檔案。純 `bitbucket.org` 網站主機（瀏覽器頁面、`.../raw/...` 連結、透過 HTTPS 的 `git clone`）**不**接受這兩者，它以 HTTP Basic 驗證 git-over-HTTPS，使用字面使用者名稱 `x-token-auth` 與存取權杖作為密碼。請將型錄與 `download_url` 項目指向 `api.bitbucket.org`（見下），而非 `bitbucket.org/.../raw/...`，讓你的 `auth.json` 中的憑證真正生效。

**範例——Bitbucket Cloud 存取權杖（建議）：**

```json
{
  "hosts": ["api.bitbucket.org"],
  "provider": "bitbucket",
  "auth": "bearer",
  "token_env": "BITBUCKET_ACCESS_TOKEN"
}
```

在代管你的型錄與封存檔的儲存庫（或專案／工作區）上，以 **Repositories: Read** 範圍建立權杖。透過 `https://api.bitbucket.org/2.0/repositories/<workspace>/<repo>/src/<ref>/catalog.json` 以此憑證取得型錄檔案，而非 `bitbucket.org/.../raw/...` URL。

**範例——Atlassian API 權杖（Basic 驗證）：**

```json
{
  "hosts": ["api.bitbucket.org"],
  "provider": "bitbucket",
  "auth": "basic",
  "username": "you@example.com",
  "token_env": "ATLASSIAN_API_TOKEN"
}
```

**範例——Bitbucket Data Center HTTP 存取權杖：**

```json
{
  "hosts": ["bitbucket.example.com"],
  "provider": "bitbucket",
  "auth": "bearer",
  "token_env": "BITBUCKET_DC_TOKEN"
}
```

> **注意：**Bitbucket Cloud 透過重新導向到預先簽章的 Amazon S3 URL 提供檔案下載（儲存庫的 **Downloads** 區段）。Specify 會在該重新導向上移除 `Authorization` 標頭，因為目標離開了你宣告的主機，這是預期行為，且下載仍會成功，因為 S3 URL 本身即具授權。請在型錄項目中釘選 `sha256`，讓未經驗證的最後一跳保持完整性檢查。

## 多個項目

你可以為不同的主機或組織設定多個項目：

```json
{
  "providers": [
    {
      "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    },
    {
      "hosts": ["dev.azure.com"],
      "provider": "azure-devops",
      "auth": "basic-pat",
      "token_env": "AZURE_DEVOPS_PAT"
    }
  ]
}
```

## 運作方式

1. 對於每個對外 HTTP 請求，URL 主機名稱會與 `auth.json` 中的 `hosts` 模式比對。
2. 若找到符合項，對應的提供者會解析權杖並附加適當的 `Authorization` 標頭。`github-cli` 取得失敗會立即結束請求，不會嘗試後續符合的項目，也不會發出未經驗證的請求。
3. 權杖成功取得後，若請求收到 401 或 403，會嘗試下一個符合的項目。
4. 在沒有取得失敗的情況下，所有符合項目都用盡後，會嘗試未經驗證的請求作為最後備援。
5. 在重新導向時，若重新導向目標離開該項目的宣告主機，`Authorization` 標頭會被移除，以防止憑證外洩到 CDN 或第三方服務。

## 範本

已預先設定 GitHub 的參照 `auth.json`：

```json
{
  "providers": [
    {
      "hosts": [
        "github.com",
        "api.github.com",
        "raw.githubusercontent.com",
        "codeload.github.com"
      ],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    }
  ]
}
```

使用方式：

```bash
mkdir -p ~/.specify
# Copy the JSON above into ~/.specify/auth.json
chmod 600 ~/.specify/auth.json
```
