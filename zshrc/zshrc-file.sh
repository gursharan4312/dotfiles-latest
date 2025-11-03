source ~/github/dotfiles-latest/zshrc/zshrc-common.sh

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

# macOS-specific configurations
if [ "$OS" = 'Mac' ]; then
  source ~/github/dotfiles-latest/zshrc/zshrc-macos.sh
# Linux (Debian)-specific configurations
elif [ "$OS" = 'Linux' ]; then
  source ~/github/dotfiles-latest/zshrc/zshrc-linux.sh
fi

setopt autocd

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
