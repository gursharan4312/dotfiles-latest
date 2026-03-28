# macOS-specific ZSH configuration

# Homebrew completions ($HOMEBREW_PREFIX is set by brew shellenv in .zprofile)
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
    autoload -Uz compinit && compinit -C
fi

# eza — modern ls
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -lhg'
    alias lla='eza -alhg'
    alias tree='eza --tree'
fi

# bat — cat with syntax highlighting
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias catt='bat'
    alias cata='bat --show-all --paging=never --style=plain'
fi

# zoxide — smarter cd
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdd='z -'
fi
