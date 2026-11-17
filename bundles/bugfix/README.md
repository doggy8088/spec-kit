# 錯誤修正套件組

GitHub Spec Kit 官方出品的套件組，安裝一條經過編排的錯誤修正流程。

## 提供的內容

- **Bug 擴充功能**（`extensions/bug`）——`speckit.bug.assess`、`speckit.bug.fix` 與 `speckit.bug.test` 命令。
- **Bugfix 工作流程**（`workflows/bugfix`）——一條有引導、可恢復的流程：
  1. `assess` 評估錯誤回報。
  2. `review-assessment` 關卡——核准即繼續，拒絕即中止。
  3. `fix` 修正錯誤。
  4. `test` 測試修正結果。

## 安裝

```bash
specify bundle install bugfix
# or
specify bundle add bugfix
```

## 執行工作流程

```bash
specify workflow run bugfix \
  --input report="https://github.com/example/repo/issues/1234" \
  --input slug="callback-token"
```

必要輸入必須透過 `--input` 提供：`report` 與 `slug`。所有產出物都以該 slug 作為 `.specify/bugs/<slug>/` 下的工作目錄。

若無互動式終端機，執行會在 `review-assessment` 暫停。請檢視評估結果，再使用選用的判定輸入予以核准：

```bash
specify workflow resume <run_id> --input bug_review_assessment_verdict=approve
```

`bug_review_assessment_verdict` 預設為 `""`。省略它或提供空值時，會保留既有的互動式提示或非互動式暫停。此輸入適用於 `bugfix` 工作流程 1.0.1 版，需要 Specify CLI 0.15.1 或更新版本。請更新工作流程並開始新的執行以使用此輸入；既有的執行會保留開始時儲存的定義。

## 移除

```bash
specify bundle remove bugfix
```

移除套件組會解除安裝其帶來的工作流程與擴充功能，除非它們仍被其他已安裝的套件組相依（FR-022）。您自行獨立安裝的元件不會歸屬於這個套件組，移除後仍會保留。

## 另請參閱

- [套件組總覽](https://github.github.io/spec-kit/bundles/overview.html)
- [套件組 CLI 參考](https://github.github.io/spec-kit/bundles/cli.html)
