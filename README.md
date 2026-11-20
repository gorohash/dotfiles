# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理している dotfiles。

## セットアップ

```sh
brew install chezmoi
chezmoi init --apply gorohash
```

初回の `chezmoi init` で以下を聞かれる。回答は `~/.config/chezmoi/chezmoi.toml` に保存され、リポジトリには含まれない。

| 項目 | 用途 |
| --- | --- |
| `machine` (`work` / `personal`) | 会社の PC だけに置く設定 (GitHub Packages の pnpm token helper など) の切り替え |
| `email` | Git のメールアドレス、署名検証 (`allowed_signers`) |
| `takumiGuardToken` | Takumi Guard のトークン (`~/.npmrc`) |

回答を変えるときは `chezmoi init --prompt` で聞き直す。

## 更新

```sh
chezmoi update
```

## Homebrew のパッケージ

`~/.Brewfile` で管理する。`chezmoi apply` で `~/.Brewfile` が変わると `brew bundle --global --no-upgrade` が実行され、足りないパッケージがインストールされる。

- 追加・削除は `chezmoi edit ~/.Brewfile` で行う (`brew bundle dump` は `~/.Brewfile` を上書きするので使わない)
- Brewfile から消してもアンインストールはされない。消すときは `brew bundle cleanup --global` で確認してから `--force` を付けて実行する

## mise のツール

`~/.config/mise/config.toml` で管理する。`chezmoi apply` で設定が変わると `mise install` が実行される。

## gh の拡張機能

`run_onchange_after_gh-extensions.sh` の一覧で管理する。一覧を変えると `chezmoi apply` でインストールされる。`gh auth login` を済ませてから `chezmoi apply` する。更新は `gh extension upgrade --all`。

## 管理しないもの

- `~/.gitconfig`: `gh auth login` や `git lfs install` などのツールが書き込む先として残す。Git の設定は `~/.config/git/config` で管理する
