#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

links=(
  "zsh/zshrc:$HOME/.zshrc"
  "zsh/prompt.zsh:$HOME/.config/zsh/prompt.zsh"
  "scripts/anime-motd.sh:$HOME/.config/scripts/anime-motd.sh"
)

link_file() {
  local src="$REPO/$1"
  local dst="$2"

  if [[ ! -e $src ]]; then
    echo "skip: $src does not exist in repo" >&2
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -L $dst ]]; then
    local current
    current=$(readlink "$dst")
    if [[ $current == "$src" ]]; then
      echo "ok:   $dst"
      return
    fi
    echo "move: $dst -> $dst.bak (was $current)"
    mv "$dst" "$dst.bak"
  elif [[ -e $dst ]]; then
    echo "move: $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

for entry in "${links[@]}"; do
  link_file "${entry%%:*}" "${entry#*:}"
done

if [[ ! -e $HOME/.config/zsh/local.zsh ]]; then
  mkdir -p "$HOME/.config/zsh"
  cp "$REPO/zsh/local.zsh.example" "$HOME/.config/zsh/local.zsh"
  echo "new:  ~/.config/zsh/local.zsh"
fi

if [[ ! -e $HOME/.hushlogin ]]; then
  touch "$HOME/.hushlogin"
  echo "new:  ~/.hushlogin"
fi

echo
echo "Done. Open a new shell or 'source ~/.zshrc'."
