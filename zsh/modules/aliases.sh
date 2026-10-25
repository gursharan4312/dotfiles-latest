alias vim=nvim

# Git shortcuts
alias push="git push"
alias pull="git pull"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gs="git status"
alias gd="git diff"
alias oc="opencode"
alias cl="claude --effort xhigh --enable-auto-mode"
alias cx="codex"

# Modern search tools
alias rg='rg --smart-case'
# Debian/Ubuntu ship the fd binary as `fdfind`
if command -v fd &>/dev/null; then
    alias fd='fd --hidden --exclude .git'
elif command -v fdfind &>/dev/null; then
    alias fd='fdfind --hidden --exclude .git'
fi

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
  wtpool() {
    emulate -L zsh
    local repo_root="$HOME/dev/stackadapt/web"
    local git_root_cmd
    git_root_cmd="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -n "$git_root_cmd" && -e "$git_root_cmd/.agents/skills/sa-worktree/SKILL.md" ]]; then
      repo_root="$git_root_cmd"
    fi
    local skill_dir="" d
    for d in "$repo_root/.agents/skills" "$HOME/.cursor/skills" "$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.config/agents/skills"; do
      [[ -e "$d/sa-worktree/SKILL.md" ]] || continue
      skill_dir="${d}/sa-worktree"
      break
    done
    if [[ -z "$skill_dir" ]]; then
      print -r -- "wtpool: sa-worktree skill not found" >&2
      return 1
    fi
    command "${skill_dir}/scripts/wtpool" --repo "${repo_root}" "$@"
  }
fi
