# 一次性使用（uvx）

若你想試用 Spec Kit 而不想永久安裝，可以使用 `uvx` 直接執行它。這會將工具下載到暫存環境中，指令結束後即丟棄。

> [!NOTE]
> 下列指令需要 **[uv](https://docs.astral.sh/uv/)**。若你看到 `command not found: uvx`，請[先安裝 uv](uv.md)。

## 執行 Specify CLI

```bash
# Create a new project (latest from main)
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# Or target a specific release (replace vX.Y.Z with a tag from Releases;
# keep the leading v, e.g. v0.12.11 not 0.12.11)
uvx --from git+https://github.com/github/spec-kit.git@vX.Y.Z specify init <PROJECT_NAME>

# Initialize in the current directory
uvx --from git+https://github.com/github/spec-kit.git specify init . --integration copilot

# Or use the --here flag
uvx --from git+https://github.com/github/spec-kit.git specify init --here --integration copilot
```

## 何時改用永久安裝

若你打算經常使用 Spec Kit，建議採用永久安裝：

- 工具會保持安裝狀態，且在 PATH 中隨時可用
- 每次呼叫都不必重新下載
- 以 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 進行更完善的工具管理

永久安裝的說明請參閱主要的[安裝指南](../installation.md)。
