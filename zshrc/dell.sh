if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
  [[ -n "$INSIDE_EMACS" || -n "$VSCODE_PID" ]] || \
    tmux attach -t TMUX || tmux new -s TMUX
fi

# Antidote plugin manager
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load ~/github/dotfiles-latest/zshrc/.zsh_plugins.txt

# Keybindings
bindkey -e

# Disable theme since we are using starship
#ZSH_THEME=""

# Skip insecure directory permissions check to speed up start time
ZSH_DISABLE_COMPFIX="true"

# Disable automatic text highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/349
zle_highlight+=(paste:none)

# Zsh autosuggestion highlighting - grey
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/go/bin:/opt/nvim-linux-x86_64/bin:/snap/bin:$PATH

# mise (runtime manager)
eval "$(mise activate zsh)"

export STARSHIP_CONFIG=$HOME/github/dotfiles-latest/starship-config/starship1.toml
eval "$(starship init zsh)"

fpath+=~/.zfunc

alias vim="NVIM_APPNAME=astrovim5 nvim"
alias push="git push"
alias pull="git pull"
alias gc="git checkout"
alias gcb="git checkout -b"

alias bb="cd ~/Desktop/brokerbay"
alias app="cd ~/Desktop/brokerbay/app"
alias bbcli="~/Desktop/brokerbay/cli/dist/bbcli"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
