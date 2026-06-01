# ZSH Configuration

Cross-platform ZSH configuration for **macOS** and **Linux**.

## Structure

```
zsh/
├── .zshrc                 # Main entry point (symlinked to ~/.zshrc via stow)
├── .zprofile              # Login shell: Homebrew, mise shims, Starship path
├── .zsh_plugins.txt       # Antidote plugin list
├── zshrc-macos.sh         # macOS-specific config
├── zshrc-linux.sh         # Linux-specific config
└── modules/
    ├── aliases.sh         # Shell aliases (vim → nvim, git shortcuts)
    ├── autocompletion.sh  # Completion settings
    ├── history.sh         # History settings
    └── sesh.sh            # Tmux session picker (sesh + fzf)
```

## Installation

From the dotfiles root, run:

```bash
./setup.sh zsh
```

This uses `stow` to symlink `.zshrc` to your home directory.

## Features

### Auto-Install
On first shell start, the config will:
1. Install **antidote** plugin manager (if not present)
2. Install all plugins from `.zsh_plugins.txt`

### Plugins (via Antidote)
- `ohmyzsh/ohmyzsh` (lib, docker)
- `zsh-users/zsh-autosuggestions`
- `zsh-users/zsh-syntax-highlighting`
- `zsh-users/zsh-completions`
- `jeffreytse/zsh-vi-mode`

### Tooling
- **mise** — runtimes via shims in `.zprofile` (not double-activated in `.zshrc`)
- **fzf** — Ctrl+R / Ctrl+T / Alt+C key bindings (macOS + Linux)
- **sesh** — project tmux sessions; picker bound to tmux `Prefix + T`
- **Starship** — prompt; theme from `colorscheme-set.sh` → `starship-config/.config/active-config.toml`

## Customization

### Adding Plugins
Edit `.zsh_plugins.txt` and restart your shell. Antidote will auto-install.

### Platform-Specific Config
- **macOS**: Edit `zshrc-macos.sh`
- **Linux**: Edit `zshrc-linux.sh`

### Aliases
Add custom aliases to `modules/aliases.sh`
