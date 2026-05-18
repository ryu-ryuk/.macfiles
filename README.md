# macfiles

My MacBook setup. `install.sh` symlinks everything into `$HOME`.

```
.macfiles/
├── install.sh
├── zsh/
│   ├── zshrc       -> ~/.zshrc
│   └── prompt.zsh  -> ~/.config/zsh/prompt.zsh
├── scripts/
│   └── anime-motd.sh      -> ~/.config/scripts/anime-motd.sh
├── iterm2/
│   ├── README.md          how to point iTerm2 here
│   └── export.sh          snapshot the current iTerm2 plist
└── bin/                   personal scripts, on PATH via zshrc
```

## Fresh machine

```sh
git clone <repo-url> ~/.macfiles
cd ~/.macfiles
./install.sh
```

Then open a new shell.

For iTerm2: see `iterm2/README.md`.

## Deps

`zinit` (bootstraps itself), `fzf`, `zoxide`, `atuin`, `direnv`, `eza`, `bat`, `fd`, `lazygit`, `yazi`, `nvim`, `bun`, `vivid`. Plus `nvm` if you want node (installed per its docs, not Homebrew). Most of them:

```sh
brew install fzf zoxide atuin direnv eza bat fd lazygit yazi neovim oven-sh/bun/bun vivid
brew install --cask iterm2
```

The prompt uses Nerd Font glyphs (` ❯ 󰔚 ✘ ⇡ ⇣`), so pick a Nerd-patched font in iTerm2.

## Theme

Catppuccin Mocha. Everywhere.

---

Some of these files were yak-shaved alongside [Claude Code](https://claude.com/claude-code).
