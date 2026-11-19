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

## 管理しないもの

- `~/.gitconfig`: `gh auth login` や `git lfs install` などのツールが書き込む先として残す。Git の設定は `~/.config/git/config` で管理する
