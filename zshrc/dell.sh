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

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools

export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


fpath+=~/.zfunc

alias vim="NVIM_APPNAME=astrovim5 nvim"
alias push="git push"
alias pull="git pull"
alias gc="git checkout"
alias gcb="git checkout -b"

BB=~/Desktop/brokerbay

alias bb="cd $BB"
alias app="cd $BB/app"
alias mobile="cd $BB/mobile"
alias rets="cd $BB/rets2"
alias script="cd $BB/scripts"
alias auth="cd $BB/auth-server"
alias bbcli="~/Desktop/brokerbay/cli/dist/bbcli"

export TMPDIR=$HOME/.tmp
export TMP=$HOME/.tmp
export TEMP=$HOME/.tmp

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
