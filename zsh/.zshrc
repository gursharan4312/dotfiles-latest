#!/usr/bin/env zsh
# =============================================================================
# ZSH Configuration - Entry Point
# Simplified, modular, cross-platform (macOS & Linux)
# =============================================================================

# Optional profiling (uncomment to debug slow startup)
# zmodload zsh/zprof

# =============================================================================
# Core Setup
# =============================================================================

# Path to dotfiles (works with stow symlinks)
export DOTFILES_DIR="${DOTFILES_DIR:-$(dirname ${(%):-%N})}"

# Detect OS once
case "$(uname -s)" in
    Darwin) export DOTFILES_OS='macos' ;;
    Linux)  export DOTFILES_OS='linux' ;;
    *)      export DOTFILES_OS='unknown' ;;
esac

# =============================================================================
# Load Modules
# =============================================================================

# Load dependency management and check for missing packages
source "$DOTFILES_DIR/modules/deps.sh"

# Load core modules (order matters)
source "$DOTFILES_DIR/modules/colors.sh"
source "$DOTFILES_DIR/modules/history.sh"
source "$DOTFILES_DIR/modules/autocompletion.sh"
source "$DOTFILES_DIR/modules/aliases.sh"

# =============================================================================
# Initialize Dependencies
# =============================================================================

init_deps

# =============================================================================
# Cross-Platform PATH Setup
# =============================================================================

# Add common paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# Temporary directory
export TMPDIR="${TMPDIR:-$HOME/.tmp}"
export TMP="$TMPDIR"
export TEMP="$TMPDIR"
[[ ! -d "$TMPDIR" ]] && mkdir -p "$TMPDIR"

# =============================================================================
# Platform-Specific Configuration
# =============================================================================

if [[ "$DOTFILES_OS" == "macos" ]]; then
    source "$DOTFILES_DIR/zshrc-macos.sh"
elif [[ "$DOTFILES_OS" == "linux" ]]; then
    source "$DOTFILES_DIR/zshrc-linux.sh"
fi

# =============================================================================
# Shell Options
# =============================================================================

setopt autocd              # cd by typing directory name
setopt correct             # Command spelling correction
setopt interactive_comments # Allow comments in interactive shell

# Keybindings
bindkey -e                 # Emacs-style keybindings
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Skip insecure directory permissions check
ZSH_DISABLE_COMPFIX="true"

# Disable automatic text highlighting on paste
zle_highlight+=(paste:none)

# Zsh autosuggestion highlighting - grey
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# =============================================================================
# External Tool Initialization
# =============================================================================

# Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# kubectl completion
if command -v kubectl &>/dev/null; then
    source <(kubectl completion zsh)
fi

# mise (lazy loading for faster startup)
eval "$(command mise activate zsh)"
# if command -v mise &>/dev/null; then
#     function mise() {
#         unfunction mise
#         eval "$(command mise activate zsh)"
#         mise "$@"
#     }
# fi

# =============================================================================
# Tmux Auto-Attach (optional)
# =============================================================================

# Auto-attach to tmux if not already in tmux and not in IDE
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && command -v tmux &>/dev/null; then
    # Skip in editors/IDEs
    if [[ -z "$INSIDE_EMACS" ]] && [[ -z "$VSCODE_PID" ]] && [[ -z "$VSCODE_INJECTION" ]]; then
        tmux attach -t TMUX 2>/dev/null || tmux new -s TMUX
    fi
fi

# Uncomment to show profiling results
# zprof
