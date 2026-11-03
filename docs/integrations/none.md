# None：僅共用骨架

將 `none` 整合用於不綁定特定代理的專案。它會安裝共用的 `.specify/` 骨架，不含代理專屬的命令、技能、設定或 hook。不需要任何程式代理。

## 多重安裝安全性

本整合已宣告為多重安裝安全，因為它不產生任何代理專屬檔案。其他已安裝的整合也必須宣告為安全，才能在不使用 `--force` 的情況下共存。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration none
```

若要在既有專案中取代目前的預設整合：

```bash
specify integration switch none
```

若 `none` 已安裝，`switch` 只會將它選為預設；它不會移除其他整合。安裝、啟用與清理方式請參閱[整合管理](cli.md)。

## 共用檔案與移除

範本、指令稿、憲章、隨附的工作流程與專案中繼資料，都會保留在 `.specify/` 之下。本整合產生的檔案清單是空的；解除安裝 `none` 不會移除共用骨架或不屬於它的檔案。

混合代理團隊的選用做法，請參閱[在團隊中工作](index.md#working-in-a-team)。

## 工作流程限制

本整合無法分派工作流程的命令或提示詞步驟。若要執行這些步驟，請切換到支援 CLI 分派的代理整合。沒有整合專屬的設定選項。
