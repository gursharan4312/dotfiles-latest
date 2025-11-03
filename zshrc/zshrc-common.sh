source ~/github/dotfiles-latest/zshrc/modules/colors.sh
source ~/github/dotfiles-latest/colorscheme/colorscheme-vars.sh
source ~/github/dotfiles-latest/zshrc/modules/aliases.sh
source ~/github/dotfiles-latest/zshrc/modules/autocompletion.sh
source ~/github/dotfiles-latest/zshrc/modules/history.sh

# PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH

# Antidote plugin manager
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load ~/github/dotfiles-latest/zshrc/.zsh_plugins.txt

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
eval "$(mise activate zsh)"

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
