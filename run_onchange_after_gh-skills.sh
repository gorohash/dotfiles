#!/bin/bash
# このファイルが変わったときだけ実行される
# 前提: gh auth login 済み
set -euo pipefail

# "<リポジトリ> <スキル名>" の一覧
skills=(
  "github/gh-stack gh-stack"
)

cd "$HOME"
for skill in "${skills[@]}"; do
  read -r repository name <<< "$skill"
  # インストール済みだとエラーになるため --force で上書きする
  /opt/homebrew/bin/gh skill install "$repository" "$name" --agent claude-code --scope user --force
done
