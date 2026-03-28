# macOS-specific ZSH configuration

# Colorscheme (set colorscheme_profile before sourcing to activate a theme)
if [[ -n "$colorscheme_profile" ]]; then
    "$HOME/github/dotfiles-latest/zsh/colorscheme-set.sh" "$colorscheme_profile"
fi

# Homebrew completions ($HOMEBREW_PREFIX is set by brew shellenv in .zprofile)
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
    autoload -Uz compinit && compinit -C

    # Google Cloud SDK
    [[ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc" ]] &&
        source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"
    [[ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc" ]] &&
        source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
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
