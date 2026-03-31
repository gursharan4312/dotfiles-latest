# macOS-specific ZSH configuration


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
