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

# Neovim from various installation methods
[[ -d "/opt/nvim-linux-x86_64/bin" ]] && export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
[[ -d "/opt/nvim/bin" ]] && export PATH="/opt/nvim/bin:$PATH"

# Snap packages
[[ -d "/snap/bin" ]] && export PATH="/snap/bin:$PATH"

# Go
[[ -d "/usr/local/go/bin" ]] && export PATH="/usr/local/go/bin:$PATH"

# Starship config
export STARSHIP_CONFIG="$HOME/github/dotfiles-latest/starship-config/active-config.toml"

# =============================================================================
# System Info Display
# =============================================================================

# Show system info on shell start (optional)
if command -v fastfetch &>/dev/null; then
    echo
    fastfetch
elif command -v neofetch &>/dev/null; then
    echo
    neofetch
fi
