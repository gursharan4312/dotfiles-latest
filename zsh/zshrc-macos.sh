# =============================================================================
# macOS-specific ZSH Configuration
# =============================================================================

# Colorscheme configuration (if exists)
local colorscheme_script="$HOME/github/dotfiles-latest/zsh/colorscheme-set.sh"
if [[ -f "$colorscheme_script" ]] && [[ -n "$colorscheme_profile" ]]; then
    "$colorscheme_script" "$colorscheme_profile"
fi

# =============================================================================
# Homebrew Setup
# =============================================================================

if command -v brew &>/dev/null; then
    # Add brew completions to fpath
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit -C
    
    # Google Cloud SDK (if installed via Homebrew)
    local gcloud_path="$(brew --prefix)/share/google-cloud-sdk"
    [[ -f "$gcloud_path/path.zsh.inc" ]] && source "$gcloud_path/path.zsh.inc"
    [[ -f "$gcloud_path/completion.zsh.inc" ]] && source "$gcloud_path/completion.zsh.inc"
fi

# =============================================================================
# CLI Tool Aliases (with existence checks)
# =============================================================================

# eza - modern ls replacement
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -lhg'
    alias lla='eza -alhg'
    alias tree='eza --tree'
fi

# bat - cat with syntax highlighting
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias catt='bat'
    alias cata='bat --show-all --paging=never --style=plain'
fi

# zoxide - smarter cd
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdd='z -'
fi

# =============================================================================
# PATH Additions
# =============================================================================

export PATH="/usr/local/go/bin:$PATH"

# Android SDK (if exists)
if [[ -d "$HOME/Library/Android/sdk" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"
fi

# Starship config
export STARSHIP_CONFIG="$HOME/github/dotfiles-latest/starship-config/active-config.toml"

# Add custom functions path
fpath+=~/.zfunc
