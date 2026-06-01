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

    # New session: window 1 opens nvim, window 2 is a background shell
    local win_name="${session_path:t}"
    tmux new-session -d -s "$session_name" -c "$session_path" -n "$win_name"
    tmux send-keys -t "${session_name}:1" "nvim" Enter
    tmux new-window -t "$session_name" -d -c "$session_path" -n "$win_name"
    tmux switch-client -t "${session_name}:1"
}
