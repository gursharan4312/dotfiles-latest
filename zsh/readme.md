# ZSH Configuration

Cross-platform ZSH configuration for **macOS** and **Linux**.

## Structure

```
zsh/
├── .zshrc                 # Main entry point (symlinked to ~/.zshrc via stow)
├── .zsh_plugins.txt       # Antidote plugin list
├── zshrc-macos.sh         # macOS-specific config
├── zshrc-linux.sh         # Linux-specific config
├── colorscheme-set.sh     # Theme/colorscheme helper
└── modules/
    ├── deps.sh            # Dependency management & auto-install
    ├── aliases.sh         # Shell aliases
    ├── autocompletion.sh  # Completion settings
    ├── colors.sh          # Color definitions
    └── history.sh         # History settings
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

### Missing Dependency Logging
External tools that need a package manager are logged with install instructions:

```
[WARN] Missing dependencies (install manually):
  • starship - brew install starship
  • fzf - brew install fzf
  • eza (optional) - brew install eza
```

### Plugins (via Antidote)
- `ohmyzsh/ohmyzsh` (lib, docker, kubectl)
- `zsh-users/zsh-autosuggestions`
- `zsh-users/zsh-syntax-highlighting`
- `zsh-users/zsh-completions`
- `jeffreytse/zsh-vi-mode`

## Customization

### Adding Plugins
Edit `.zsh_plugins.txt` and restart your shell. Antidote will auto-install.

### Platform-Specific Config
- **macOS**: Edit `zshrc-macos.sh`
- **Linux**: Edit `zshrc-linux.sh`

### Aliases
Add custom aliases to `modules/aliases.sh`
