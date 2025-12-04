zmodload zsh/zprof

# Path to your dotfiles (works with stow symlinks)
DOTFILES_DIR="$(dirname ${(%):-%N})"

# Source common configurations
source "$DOTFILES_DIR/zshrc-common.sh"

# Detect OS
case "$(uname -s)" in
    Darwin)
        OS='Mac'
        ;;
    Linux)
        OS='Linux'
        ;;
    *)
        OS='Other'
        ;;
esac

# Platform-specific configurations
if [ "$OS" = 'Mac' ]; then
    source "$DOTFILES_DIR/zshrc-macos.sh"
elif [ "$OS" = 'Linux' ]; then
    source "$DOTFILES_DIR/zshrc-linux.sh"
fi

setopt autocd

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# opencode
export PATH=/home/garry/.opencode/bin:$PATH
