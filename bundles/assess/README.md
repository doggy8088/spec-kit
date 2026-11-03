# 想法評估套件組

GitHub Spec Kit 官方出品的套件組，在投入規格驅動開發之前，先安裝一條想法分類評估流程。

## 提供的內容

- **Assess 擴充功能**（`extensions/assess`）——`speckit.assess.intake`、`speckit.assess.research`、`speckit.assess.define`、`speckit.assess.shape` 與 `speckit.assess.decide` 命令。
- **Assess 工作流程**（`workflows/assess`）——一條有引導、可恢復的流程：
  1. `intake` 接收原始想法。
  2. `research` 研究證據。
  3. `define` 定義問題。
  4. `shape` 塑造概念。
  5. `decide` 做出裁決。
  6. `review-verdict` 關卡——核准即完成評估；拒絕即中止。裁決為 `go` 時，再手動交接給 `/speckit.specify`。

## 安裝

```bash
specify bundle install assess
# or
specify bundle add assess
```

## 執行工作流程

```bash
specify workflow run assess \
  --input idea="Let users work offline and sync when they reconnect" \
  --input slug="offline-mode"
```

必要輸入必須透過 `--input` 提供：`idea` 與 `slug`。所有產出物都以該 slug 作為 `.specify/assessments/<slug>/` 下的工作目錄。

## 移除

```bash
specify bundle remove assess
```

移除套件組會解除安裝其帶來的工作流程與擴充功能，除非它們仍被其他已安裝的套件組相依（FR-022）。您自行獨立安裝的元件不會歸屬於這個套件組，移除後仍會保留。
