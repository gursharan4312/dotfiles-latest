# =============================================================================
# Linux-specific ZSH Configuration
# =============================================================================

# Fix for terminal compatibility when SSHing from kitty/other terminals
export TERM="${TERM:-xterm-256color}"

# =============================================================================
# CLI Tool Aliases (with existence checks)
# =============================================================================

# Basic ls with colors (fallback if eza not installed)
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -lhg'
    alias lla='eza -alhg'
    alias tree='eza --tree'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias lla='ls -lah'
fi

# bat - cat with syntax highlighting
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias catt='bat'
    alias cata='bat --show-all --paging=never --style=plain'
# Some distros install bat as batcat
elif command -v batcat &>/dev/null; then
    alias cat='batcat --paging=never --style=plain'
    alias catt='batcat'
    alias cata='batcat --show-all --paging=never --style=plain'
fi

# zoxide - smarter cd (if installed)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdd='z -'
# Fallback to z.lua if installed
elif [[ -f "$HOME/github/z.lua/z.lua" ]] && command -v lua &>/dev/null; then
    eval "$(lua $HOME/github/z.lua/z.lua --init zsh enhanced once)"
fi

# =============================================================================
# PATH Additions
# =============================================================================

# Bun is managed by mise (`mise use -g bun@latest` → ~/.config/mise/config.toml),
# so `mise activate` puts it on PATH. No ~/.bun PATH block needed.

# Neovim from various installation methods
[[ -d "/opt/nvim-linux-x86_64/bin" ]] && export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
[[ -d "/opt/nvim/bin" ]] && export PATH="/opt/nvim/bin:$PATH"

# Snap packages
[[ -d "/snap/bin" ]] && export PATH="/snap/bin:$PATH"

# Go
[[ -d "/usr/local/go/bin" ]] && export PATH="/usr/local/go/bin:$PATH"

# =============================================================================
# System Info Display
# =============================================================================

# Show system info on login shell only (skip new tmux panes)
if [[ -z "$TMUX" ]]; then
    if command -v fastfetch &>/dev/null; then
        echo
        fastfetch
    elif command -v neofetch &>/dev/null; then
        echo
        neofetch
    fi
fi

# fzf — completion and key bindings (Ctrl+R, Ctrl+T, Alt+C)
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh" ]]; then
    source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
    source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
elif command -v fzf &>/dev/null; then
    source <(fzf --zsh) 2>/dev/null
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi
