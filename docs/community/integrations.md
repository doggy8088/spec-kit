# 社群整合

社群整合透過獨立維護的外部配接器，將 Spec Kit 連接至更多程式代理。

> [!NOTE]
> 維護者僅檢查型錄項目的中繼資料，不檢查配接器實作。收錄不等同於程式碼稽核、背書、支援承諾或安裝許可。安裝與使用前，請先檢視配接器的原始碼與 release。

## 可用的整合

目前[社群整合型錄](https://github.com/github/spec-kit/blob/main/integrations/catalog.community.json)沒有任何項目。內建整合隨 CLI 一同提供，另列於整合目錄。

檢視專案中啟用的來源並搜尋其中繼資料：

```bash
specify integration catalog list
specify integration search
specify integration info <id> --versions
```

搜尋使用你啟用的型錄設定，不只使用社群來源。預設的社群來源僅供探索。安裝外部配接器需要明確允許安裝的型錄，以及可存取的套件封存檔；沒有直接 URL 或本機安裝途徑。

## 貢獻整合

開發並測試外部配接器，發佈其描述元與固定版本的 release 封存檔，然後提交編輯 `integrations/catalog.community.json` 的型錄 PR。請依循整合貢獻指南，了解套件合約、必要中繼資料、驗證證據與版本更新方式。內建整合的貢獻在該指南中另有路徑。

## 另請參閱

- [整合目錄](../integrations/index.md)
- [外部配接器安裝](../integrations/cli.md#透過型錄安裝的外部轉接器)
- [型錄結構描述與設定](../integrations/catalog.md)
- [開發與提交整合](../integrations/contributing.md)
- [型錄探索與信任](../overview/catalogs.md)
