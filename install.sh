#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

links=(
  "zsh/zshrc:$HOME/.zshrc"
  "zsh/prompt.zsh:$HOME/.config/zsh/prompt.zsh"
  "scripts/anime-motd.sh:$HOME/.config/scripts/anime-motd.sh"
  "vscode/settings.json:$HOME/Library/Application Support/Code/User/settings.json"
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

# Fonts: copy (not symlink) into ~/Library/Fonts; macOS font registration is
# more reliable with real files than symlinks.
if [[ -d $REPO/fonts ]]; then
  mkdir -p "$HOME/Library/Fonts"
  for f in "$REPO"/fonts/*.ttf; do
    [[ -e $f ]] || continue
    dst="$HOME/Library/Fonts/$(basename "$f")"
    if [[ -f $dst ]]; then
      echo "ok:   $dst"
    else
      cp "$f" "$dst"
      echo "font: $dst"
    fi
  done
fi

if [[ ! -e $HOME/.hushlogin ]]; then
  touch "$HOME/.hushlogin"
  echo "new:  ~/.hushlogin"
fi

echo
echo "Done. Open a new shell or 'source ~/.zshrc'."
