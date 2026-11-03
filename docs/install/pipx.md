# 使用 pipx 安裝

[pipx](https://pipx.pypa.io/) 是在隔離環境中安裝 Python CLI 應用程式的工具。它不需要 [uv](https://docs.astral.sh/uv/)。

## 安裝 Specify CLI

為了穩定，請釘選特定的發行標籤（最新版本請查 [Releases](https://github.com/github/spec-kit/releases)）：

```bash
# Install a specific stable release (recommended — replace vX.Y.Z with the
# latest tag, keeping the leading v, e.g. v0.12.11 not 0.12.11)
pipx install git+https://github.com/github/spec-kit.git@vX.Y.Z

# Or install latest from main (may include unreleased changes)
pipx install git+https://github.com/github/spec-kit.git
```

## 驗證

```bash
specify version
```

## 升級

```bash
pipx install --force git+https://github.com/github/spec-kit.git@vX.Y.Z
```

## 解除安裝

```bash
pipx uninstall specify-cli
```

## 後續步驟

前往[快速入門](../quickstart.md)初始化你的第一個專案。
