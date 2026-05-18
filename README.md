# macfiles

My MacBook dotfiles. Symlinked into `$HOME` by `install.sh`.

## Layout

```
.macfiles/
├── install.sh                  # symlinks everything into $HOME (idempotent)
├── zsh/
│   ├── zshrc                   # main zsh config -> ~/.zshrc
│   ├── prompt.zsh              # Catppuccin Mocha pill prompt -> ~/.config/zsh/prompt.zsh
│   └── local.zsh.example       # template for ~/.config/zsh/local.zsh (gitignored)
├── scripts/
│   └── anime-motd.sh           # login MOTD -> ~/.config/scripts/anime-motd.sh
├── iterm2/
│   ├── README.md               # how to wire iTerm2 to load prefs from here
│   └── export.sh               # snapshot current iTerm2 plist into the repo
└── bin/                        # personal scripts (PATH'd via .zshrc)
```

## Install on a fresh machine

```sh
git clone <repo-url> ~/.macfiles
cd ~/.macfiles
./install.sh
```

That symlinks the tracked files into place and creates a starter `~/.config/zsh/local.zsh` from the example. Open a new shell.

### iTerm2

See `iterm2/README.md` — point iTerm2 at this folder for prefs.

## Secrets

Anything secret or machine-specific lives in `~/.config/zsh/local.zsh`, which is sourced from `.zshrc` but never committed. The template is `zsh/local.zsh.example`.

Currently kept out of the repo:
- `POP_SMTP_*` (pop email cli creds)
- SSH host aliases (`uwu-ssh`, `aws-ssh`, etc.)
- Work-specific aliases tied to a host or path

## Dependencies

Things `.zshrc` expects to find on `PATH`:

| Tool | Used for |
|---|---|
| `zinit` | plugin manager (auto-bootstraps on first shell) |
| `fzf` | fuzzy finder, Ctrl-T / Alt-C |
| `zoxide` | `cd` replacement |
| `atuin` | better Ctrl-R history search |
| `direnv` | per-directory `.envrc` |
| `eza` | `ls` replacement (aliased `ls`/`l`/`lr`/`t`) |
| `bat` | `cat` replacement |
| `fd` | `find` replacement (used by FZF) |
| `lazygit` | TUI git |
| `yazi` | file manager (with `y` shell function) |
| `nvim` | editor |
| `bun` | runtime + completions |
| `nvm` | lazy-loaded node version manager |
| `vivid` | LS_COLORS generator |

Install most with:
```sh
brew install zinit fzf zoxide atuin direnv eza bat fd lazygit yazi neovim oven-sh/bun/bun vivid
brew install --cask iterm2
# nvm: install per their docs, not Homebrew
```

A Nerd Font is required for the prompt glyphs (` ❯ 󰔚 ✘ ⇡ ⇣`). I use a Nerd-patched font in iTerm2.

## Theme

Catppuccin Mocha throughout — FZF colors, bat theme, prompt pills, MOTD.
