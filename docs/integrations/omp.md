# Oh My Pi

設定前請先安裝 [Oh My Pi](https://www.npmjs.com/package/@oh-my-pi/pi-coding-agent)。整合鍵為 `omp`。

## 多重安裝安全性

本整合已宣告為多重安裝安全。請參閱[共用的多重安裝規則](cli.md#我可以在同一個專案中安裝多個整合嗎)。

## 設定

```bash
specify init my-project --integration omp
```

若是既有的 Spec Kit 專案，請使用 `specify integration install omp`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的命令

Markdown 斜線命令會安裝在 `.omp/commands/` 之下。在代理的聊天中以點記法呼叫它們，例如 `/speckit.specify`，或已安裝 bug 擴充功能的 `/speckit.bug.assess`。

## 工作流程分派

工作流程步驟使用 `omp --print <prompt>`；`--print` 會啟用單次模式，提示詞為位置參數。轉接器會轉傳已設定的 `--model`，並以 `--mode json`（而非 `--output-format`）要求結構化輸出。本整合沒有專屬的設定選項；請參閱下方的執行階段選項。

## 執行期選項

命令步驟可將逐步驟執行階段設定傳給 `omp --print`（請參閱[逐步驟整合設定](../reference/workflows.md#per-step-integration-configuration)）：

| `integration_options` 鍵 | OMP 旗標 | 值 |
| ------------------------- | ------------ | ------------------------------------------------------------------------ |
| `profile` | `--profile` | 隔離的 OMP 設定檔名稱 |
| `thinking` | `--thinking` | 其中之一：`off`、`minimal`、`low`、`medium`、`high`、`xhigh`、`max`、`auto` |
| `tools` | `--tools` | 以逗號分隔的工具清單（非專屬允許清單） |

```yaml
- id: plan-with-omp
  type: command
  command: speckit.plan
  integration: omp
  integration_args:
    - "--no-session"
  integration_options:
    profile: work
    thinking: high
    tools: "read,bash"
  model: "gpt-5"
```

`tools` 會選取 OMP 啟用的工具；它不是專屬允許清單，也不是安全邊界。OMP 仍可啟用不在清單中的已探索自訂工具與擴充功能註冊的工具，因此 `tools: read` 不保證唯讀存取。

選項值必須是非空字串；未知的鍵與不支援的 `thinking` 值會在 OMP 啟動前失敗。請以步驟最上層的 `model` 欄位選取模型：`integration_options.model` 與 `integration_args` 中的 `--model` 旗標都會被拒絕。

`integration_args` 會以原始旗標傳給 OMP，但 OMP 的解析器可能讓某些 token 吃掉或重排產生的選項與提示詞，因此每個值必須是以下其中之一：

- 已知的無值旗標，例如 `--no-session`、`--no-title` 或 `--yolo`；或
- 自足的 `--name=value` token，例如 `--system-prompt=...` 或 `--resume=<id>`。

裸值旗標（`--system-prompt`、`--resume`）、`--` 終止符與 `--=` 形式（OMP 會將其正規化為 `--`）、位置文字、`@file` 參照、短旗標，以及 `--help`／`--version`／`--print`／`--export`／`--alias`／`--mode`，都會在 OMP 啟動前失敗。

參數會依下列順序傳給 `omp --print`，因此較晚的來源在命令列上會出現在較早的來源之後：

1. `SPECKIT_INTEGRATION_OMP_EXTRA_ARGS`
2. `integration_args`
3. `integration_options` 旗標
4. 來自步驟 `model` 欄位的 `--model`
5. `--mode json`（關閉 JSON 輸出時為 `--mode text`），接著是提示詞
