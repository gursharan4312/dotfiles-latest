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
if [[ -d "$HOME/Desktop/stackadapt" ]]; then
  SA="$HOME/Desktop/stackadapt"
  alias sa="cd $SA"
  alias web="$SA/stackadapt-web"
  alias frontend="$SA/frontend"
fi
