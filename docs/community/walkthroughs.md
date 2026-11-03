# 社群實作導覽

> [!NOTE]
> 社群實作導覽由各自作者獨立建立與維護，未經 GitHub 審查、背書或支援。跟隨操作前請先檢視其內容，並自行斟酌使用。

透過這些社群貢獻的實作導覽，了解規格驅動開發在不同情境中的實際運作。這些導覽是已完成流程的實用唯讀範例，但並非產生規格、計畫或任務的官方標準輸出。

- **[Greenfield .NET CLI tool](https://github.com/mnriem/spec-kit-dotnet-cli-demo)** — 從空白目錄開始，以 .NET 單一執行檔 CLI 工具打造 Timezone Utility，涵蓋完整的 spec-kit 工作流程：憲章、specify、plan、tasks，以及使用 GitHub Copilot 代理的多輪 implement。

- **[Greenfield Spring Boot + React platform](https://github.com/mnriem/spec-kit-spring-react-demo)** — 從零開始，使用 Spring Boot、內嵌 React、PostgreSQL 與 Docker Compose 打造 LLM 效能分析平台（REST API、圖表、迭代追蹤），並包含釐清步驟與跨產出物一致性分析。

- **[Brownfield ASP.NET CMS extension](https://github.com/mnriem/spec-kit-aspnet-brownfield-demo)** — 為既有的開放原始碼 .NET CMS（CarrotCakeCMS-Core，約 307,000 行 C#、Razor、SQL、JavaScript 與設定檔）擴充兩項新功能：跨平台 Docker Compose 基礎設施，以及以權杖驗證的 headless REST API，展示 spec-kit 如何在沒有既有規格或憲章的情況下融入既有程式碼庫。

- **[Brownfield Java runtime extension](https://github.com/mnriem/spec-kit-java-brownfield-demo)** — 為既有的開放原始碼 Jakarta EE 執行環境（Piranha，橫跨 180 個 Maven 模組、約 420,000 行 Java、XML、JSP、HTML 與設定檔）擴充受密碼保護的 Server Admin Console，展示 spec-kit 在沒有既有規格或憲章的大型多模組 Java 專案中的應用。

- **[Brownfield Go / React dashboard demo](https://github.com/mnriem/spec-kit-go-brownfield-demo)** — 展示完全從**終端機使用 GitHub Copilot CLI** 驅動 spec-kit。為 NASA 的開放原始碼 Hermes 地面支援系統（Go）擴充輕量的 React 網頁遙測儀表板，證明完整的 constitution → specify → plan → tasks → implement 工作流程可在終端機中完成。

- **[Greenfield Spring Boot MVC with a custom preset](https://github.com/mnriem/spec-kit-pirate-speak-preset-demo)** — 使用自訂的海盜用語預設集，從零開始打造 Spring Boot MVC 應用程式，展示預設集如何重塑整個 spec-kit 體驗：規格變成「Voyage Manifests」，計畫變成「Battle Plans」，任務變成「Crew Assignments」，全部以道地的海盜用語產生，且不更動任何工具。

- **[Greenfield Spring Boot + React with a custom extension](https://github.com/mnriem/spec-kit-aide-extension-demo)** — 導覽 **AIDE 擴充功能**，這是社群擴充功能，為 spec-kit 加入另一種規格驅動工作流程，以高階規格（vision）與低階規格（work items）組成 7 步驟迭代生命週期：vision → roadmap → progress tracking → work queue → work items → execution → feedback loops。範例以家庭交易平台（Spring Boot 4、React 19、PostgreSQL、Docker Compose）為情境，說明擴充功能機制如何讓使用者在不更動任何核心工具的情況下，接入不同風格的規格驅動開發，充分體現 Spec Kit 中的「Kit」精神。
