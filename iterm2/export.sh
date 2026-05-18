#!/usr/bin/env bash
# Export current iTerm2 preferences into the repo as com.googlecode.iterm2.plist
# Run after changing iTerm2 settings to capture them in the dotfiles repo.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

if [[ ! -f $PLIST ]]; then
  echo "iTerm2 plist not found at $PLIST" >&2
  exit 1
fi

# Force iTerm2 to flush any in-memory prefs to disk first.
defaults read com.googlecode.iterm2 >/dev/null 2>&1 || true

cp "$PLIST" "$REPO_DIR/com.googlecode.iterm2.plist"
echo "Exported -> $REPO_DIR/com.googlecode.iterm2.plist"
echo
echo "Tip: in iTerm2, set Settings -> General -> Settings -> Load preferences"
echo "     from custom folder to '$REPO_DIR' so future changes save here directly."
