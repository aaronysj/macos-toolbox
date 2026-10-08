#!/bin/zsh
# Symlink every script in bin/ into ${PREFIX:-$HOME/.local/bin}
set -euo pipefail

repo=${0:A:h}
prefix=${PREFIX:-$HOME/.local/bin}
mkdir -p "$prefix"

for src in "$repo"/bin/*(N); do
  [[ -x $src ]] || continue
  dst=$prefix/${src:t}
  ln -sf "$src" "$dst"
  print "$dst -> $src"
done
