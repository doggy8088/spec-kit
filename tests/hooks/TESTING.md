# 測試擴充功能掛鉤

這個目錄包含一個模擬專案，用來驗證 LLM 代理能正確辨識並執行 `.specify/extensions.yml` 中定義的掛鉤命令。

## 測試 1：測試 `before_tasks` 與 `after_tasks`

1. 在這個專案中與 LLM（例如 GitHub Copilot）開啟對話。
2. 請它為目前目錄產生任務：
   > "Please follow `/speckit.tasks` for the `./tests/hooks` directory."
3. **預期行為**：
   - 在進行任何產生動作之前，LLM 應該注意到 `.specify/extensions.yml` 中 `before_tasks` 下的 `AUTOMATIC Pre-Hook`。
   - 它應該表明自己正在執行 `EXECUTE_COMMAND: pre_tasks_test`。
   - 接著它應該繼續讀取 `.md` 文件並產出 `tasks.md`。
   - 產生完成後，它應該輸出選用的 `after_tasks` 掛鉤（`post_tasks_test`）區塊，詢問您是否要執行它。

## 測試 2：測試 `before_implement` 與 `after_implement`

*（需要測試 1 的 `tasks.md` 已存在）*

1. 在同一個（或新的）對話中，請 LLM 實作這些任務：
   > "Please follow `/speckit.implement` for the `./tests/hooks` directory."
2. **預期行為**：
   - LLM 應該先檢查 `before_implement` 掛鉤。
   - 它應該在進行任何實際任務執行之前，表明自己正在執行 `EXECUTE_COMMAND: pre_implement_test`。
   - 它應該評估檢核清單並執行撰寫程式碼的任務。
   - 完成後，它應該輸出選用的 `after_implement` 掛鉤（`post_implement_test`）區塊。

## 運作方式

`templates/commands/tasks.md` 與 `templates/commands/implement.md` 中這些命令的範本包含嚴格排序的清單。新的 `before_*` 掛鉤在綱要之前的 **Pre-Execution Checks** 區段中明確表述，以確保它們會先被評估，同時不打亂範本的步驟編號。
