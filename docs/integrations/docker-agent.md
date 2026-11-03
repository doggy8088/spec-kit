# Docker Agent

設定前請先安裝 [Docker Agent](https://docs.docker.com/ai/docker-agent/)。整合鍵為 `docker-agent`。Spec Kit 可偵測獨立的 `docker-agent` 執行檔或 Docker CLI 外掛程式（`docker agent`）。

## 多重安裝安全性

本整合未宣告為多重安裝安全，因為它的技能目錄與其他整合共用。請參閱[共用的多重安裝規則](cli.md#can-i-install-multiple-integrations-in-the-same-project)。

## 設定

```bash
specify init my-project --integration docker-agent
```

若是既有的 Spec Kit 專案，請使用 `specify integration install docker-agent`。啟用、升級與移除方式請參閱[整合管理](cli.md)。

## 已安裝的技能與代理設定

技能會安裝為 `.agents/skills/speckit-<command>/SKILL.md`，與 Codex 和 Zed 使用同一個目錄。在所選代理的 YAML 中，以 `skills: true` 啟用本機技能，並提供檔案系統讀取存取權。在代理的聊天中以 `/speckit-specify`，或已安裝 bug 擴充功能的 `/speckit-bug-assess` 呼叫這些技能。

選用的設定旗標 `--integration-options="--skills"` 只是重述預設值；本整合一律產生技能。Spec Kit 不會編輯所選代理的 YAML，也不會透過 Spec Kit 的原生事件系統公開其 hook。

## 工作流程設定

工作流程分派需要代理設定參照。優先使用命令步驟的結構化執行階段欄位：

```yaml
- id: specify
  type: command
  command: speckit.specify
  integration: docker-agent
  integration_args:
    - ./agent.yaml
  integration_options:
    agent: root
    safety: balanced
  input:
    args: "Describe the feature"
```

`integration_args` 最多接受一個非空參照，且不得以 `-` 開頭；Docker Agent 會驗證所參照的本機檔案或登錄項目。支援的 `integration_options` 為 `agent` 與 `safety`；safety 必須是 `strict`、`balanced`、`restricted` 或 `autonomous`。設定模型請使用步驟最上層的 `model`，而不是 `integration_options.model`。未知或格式錯誤的執行階段選項會明確失敗。

當未提供逐步參照時，舊版的 `SPECKIT_INTEGRATION_DOCKER_AGENT_EXTRA_ARGS=./agent.yaml` 環境變數仍受支援。逐步參照會覆寫整個舊版值，包括其中包含的任何旗標。分派使用 `run --exec`，會加上要求的 `--json` 與 `--model` 旗標，並將提示詞放在 `--` 之後，讓提示詞文字不會變成 CLI 選項。請參閱[逐步整合設定](../reference/workflows.md#per-step-integration-configuration)。
