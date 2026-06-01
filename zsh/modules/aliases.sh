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
if [[ -d "$HOME/dev/stackadapt" ]]; then
  SA="$HOME/dev/stackadapt"
  alias sa="cd $SA"
  alias web="$SA/web"
  alias frontend="$SA/web/frontend"
  alias backend="$SA/web/backend"
  down() {
    local rc=0 label dir line
    for label dir in \
      frontend "$SA/web/frontend" \
      backend "$SA/web/backend"
    do
      print -r -- "[$label] stack down"
      (cd "$dir" && stack down) 2>&1 | while IFS= read -r line; do
        print -r -- "[$label] $line"
      done
      (( pipestatus[1] )) && rc=1
    done
    return $rc
  }
fi
