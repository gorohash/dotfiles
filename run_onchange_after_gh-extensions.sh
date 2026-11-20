#!/bin/bash
# このファイルが変わったときだけ実行される
# 前提: gh auth login 済み
set -euo pipefail

extensions=(
  github/gh-stack
)

for extension in "${extensions[@]}"; do
  # インストール済みならメッセージを出して何もしない
  /opt/homebrew/bin/gh extension install "$extension"
done
