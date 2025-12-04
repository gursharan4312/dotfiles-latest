DOTFILES_DIR="$(dirname ${(%):-%N})"
source "$DOTFILES_DIR/modules/colors.sh"
# source ~/github/dotfiles-latest/colorscheme/colorscheme-vars.sh
source "$DOTFILES_DIR/modules/aliases.sh"
source "$DOTFILES_DIR/modules/autocompletion.sh"
source "$DOTFILES_DIR/modules/history.sh"

# PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$PATH

# Define ZSH_CACHE_DIR for oh-my-zsh plugins
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
# Ensure the directory exists to prevent errors
if [[ ! -d "$ZSH_CACHE_DIR/completions" ]]; then
  mkdir -p "$ZSH_CACHE_DIR/completions"
fi

# Antidote plugin manager
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote bundle <~/github/dotfiles-latest/zsh/.zsh_plugins.txt > ~/.zsh_plugins.zsh
source ~/.zsh_plugins.zsh

# Keybindings
bindkey -e

# Skip insecure directory permissions check to speed up start time
ZSH_DISABLE_COMPFIX="true"

# Disable automatic text highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/349
zle_highlight+=(paste:none)

# Zsh autosuggestion highlighting - grey
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# mise (runtime manager)
function mise() {
  eval "$(command mise activate zsh)"
  mise "$@"
}
export PATH="$HOME/.local/share/mise/shims:$PATH"

# Starship
eval "$(starship init zsh)"

export TMPDIR=$HOME/.tmp
export TMP=$HOME/.tmp
export TEMP=$HOME/.tmp

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# kubectl completion
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
  [[ -n "$INSIDE_EMACS" || -n "$VSCODE_PID" ]] || \
    tmux attach -t TMUX || tmux new -s TMUX
fi
