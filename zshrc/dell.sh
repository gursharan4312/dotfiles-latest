if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
  [[ -n "$INSIDE_EMACS" || -n "$VSCODE_PID" ]] || \
    tmux attach -t TMUX || tmux new -s TMUX
fi

# Antidote plugin manager
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load ~/github/dotfiles-latest/zshrc/.zsh_plugins.txt

# History
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Keybindings
bindkey -e

# PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/go/bin:/opt/nvim-linux-x86_64/bin:/snap/bin:$PATH

# mise (runtime manager)
eval "$(mise activate zsh)"
# path=("$HOME/.local/share/mise/shims" $path)
# export PATH

# Powerlevel10k config (if exists)
[[ -r ~/.config/dotfiles/zsh/p10k.zsh ]] && source ~/.config/dotfiles/zsh/p10k.zsh


fpath+=~/.zfunc

alias vim=nvim
alias push=git push
alias pull=git pull
alias gc=git checkout
alias gcb=git checkout -b
alias bb=~/brokerbay
alias app=~/brokerbay/app
alias bbcli=/home/garry/brokerbay/cli/dist/bbcli

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
