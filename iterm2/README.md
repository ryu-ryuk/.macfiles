# iTerm2

## One-time setup: have iTerm2 read/write prefs here

1. Open iTerm2 -> Settings -> General -> Settings
2. Check **Load preferences from a custom folder or URL**
3. Point it at this directory: `~/.macfiles/iterm2`
4. Pick **Save changes to folder when iTerm2 quits**

From then on, every settings change you make is written to `com.googlecode.iterm2.plist` in this folder and can be committed.

## Manual export (if you don't want auto-save)

Run `./export.sh` after changing settings to snapshot the current plist into this folder.

## Restore on a new machine

1. Clone the dotfiles repo
2. Open iTerm2 -> Settings -> General -> Settings -> **Load preferences from a custom folder** -> select `~/.macfiles/iterm2`
3. Quit and reopen iTerm2

## What's tracked

Just `com.googlecode.iterm2.plist`. Caches and app-support state are gitignored.
