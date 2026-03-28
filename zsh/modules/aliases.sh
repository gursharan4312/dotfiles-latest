# Neovim with custom config
alias vim="NVIM_APPNAME=astrovim5 nvim"

# Git shortcuts
alias push="git push"
alias pull="git pull"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gs="git status"
alias gd="git diff"

# Project-specific aliases (only if directory exists)
if [[ -d "$HOME/Desktop/brokerbay" ]]; then
    BB="$HOME/Desktop/brokerbay"
    alias bb="cd $BB"
    alias app="cd $BB/app"
    alias mobile="cd $BB/mobile"
    alias rets="cd $BB/rets2"
    alias script="cd $BB/scripts"
    alias auth="cd $BB/auth-server"
    alias bbcli="$BB/cli/dist/bbcli"
fi
