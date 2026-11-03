# Qoder CLI

設定前請先安裝 [Qoder CLI](https://qoder.com/cli)。整合鍵為 `qodercli`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration qodercli
```

若是既有的 Spec Kit 專案，請使用 `specify integration install qodercli`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能

技能會安裝為 `.qoder/skills/speckit-<command>/SKILL.md`。在代理的聊天中呼叫它們，例如 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess`。

技能版式取代了舊版的 `.qoder/commands/` 掃描方式。當已啟用的擴充功能重新註冊時，舊的平面擴充功能命令檔案只有在其替代技能檔案存在後才會退役。重新註冊前，請先備份你對那些舊版擴充功能命令的編輯：該退役程序不會比對它們的內容雜湊。

## 工作流程分派

工作流程步驟使用 `qodercli -p <prompt>`，並在已設定時傳入 `--model`、在要求結構化輸出時傳入 `--output-format json`。沒有整合專屬的設定選項；技能模式是無條件適用的。
