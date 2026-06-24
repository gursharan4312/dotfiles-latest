command -v sesh &>/dev/null || return

# Generate sesh completions on first run
_sesh_comp="${HOME}/.zsh/completions/_sesh"
if [[ ! -f "$_sesh_comp" ]]; then
    mkdir -p "${_sesh_comp:h}"
    sesh completion zsh > "$_sesh_comp"
fi

# Switch to an existing session, or create a new one with:
#   window 1 — nvim (tab name = cwd basename via tmux-window-name.sh)
#   window 2 — shell in same project directory
function sesh_connect() {
    local selected
    selected="$(sesh list | fzf \
        --height 100% \
        --no-sort \
        --border-label ' sesh ' \
        --prompt '⚡  ' \
        --header 'ctrl-t: tmux sessions  |  ctrl-z: zoxide dirs' \
        --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
        --bind 'ctrl-z:change-prompt(📁  )+reload(sesh list -z)')"

    [[ -z "$selected" ]] && return

    local session_name session_path
    session_name="$(basename "$selected")"
    # sesh list emits ~ paths; tmux -c does not expand ~, so expand it manually
    session_path="${selected/#\~/$HOME}"

    if tmux has-session -t="$session_name" 2>/dev/null; then
        tmux switch-client -t "$session_name"
        return
    fi

    local actual_session
    actual_session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null \
        | grep "^${session_name}(" | head -1)"
    if [[ -n "$actual_session" ]]; then
        tmux switch-client -t "$actual_session"
        return
    fi

    # New session: window 1 opens nvim, window 2 is a background shell
    local win_name="${session_path:t}"
    tmux new-session -d -s "$session_name" -c "$session_path" -n "$win_name"
    tmux send-keys -t "${session_name}:1" "nvim" Enter
    tmux new-window -t "$session_name" -d -c "$session_path" -n "$win_name"
    tmux switch-client -t "${session_name}:1"
}

function sesh_open_dir() {
    local session_path="${1:-}"
    [[ -z "$session_path" ]] && return 1

    session_path="${session_path/#\~/$HOME}"
    [[ ! -d "$session_path" ]] && return 1
    [[ -z "${TMUX:-}" ]] && return 1

    session_path="${session_path:A}"
    local session_name="${session_path:t}"

    if tmux has-session -t="$session_name" 2>/dev/null; then
        tmux switch-client -t "$session_name"
        return
    fi

    local actual_session
    actual_session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null \
        | grep "^${session_name}(" | head -1)"
    if [[ -n "$actual_session" ]]; then
        tmux switch-client -t "$actual_session"
        return
    fi

    tmux new-session -d -s "$session_name" -c "$session_path" -n "$session_name"
    tmux switch-client -t "$session_name"
}

function sesh_open_worktree_branch() {
    local branch="${1:-}"
    [[ -z "$branch" ]] && return 1

    local worktree_path
    worktree_path="$(git worktree list --porcelain | awk -v branch="refs/heads/$branch" '
        $1 == "worktree" { path = substr($0, 10) }
        $1 == "branch" && $2 == branch { print path; exit }
    ')"

    [[ -z "$worktree_path" ]] && return 1
    sesh_open_dir "$worktree_path"
}
