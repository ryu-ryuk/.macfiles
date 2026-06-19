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
├── vscode/
│   └── settings.json -> ~/Library/Application Support/Code/User/settings.json
├── fonts/                 copied into ~/Library/Fonts on install
│   ├── AnthrosevkaMono-*.ttf
│   └── OFL.txt            SIL OFL 1.1 license for the fonts
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

The prompt uses Nerd Font glyphs (` ❯ 󰔚 ✘ ⇡ ⇣`), so pick a Nerd-patched font in your terminal. `install.sh` ships `Anthrosevka Mono` (a custom Iosevka build, SIL OFL 1.1, from [nanxstats/anthrosevka](https://github.com/nanxstats/anthrosevka)) into `~/Library/Fonts`; it carries Nerd glyphs.

## Theme

Catppuccin Mocha. Everywhere.

---

Some of these files were yak-shaved alongside [Claude Code](https://claude.com/claude-code).
