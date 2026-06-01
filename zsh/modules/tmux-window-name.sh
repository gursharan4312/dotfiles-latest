# Rename the active tmux window to the cwd basename on every prompt.
# Works with allow-rename off (blocks app title escape sequences).

_tmux_cwd_window_name() {
  [[ -z "$TMUX" ]] && return
  local name="${PWD:t}"
  [[ -n "$name" ]] || name="~"
  tmux rename-window "$name" 2>/dev/null
}

precmd_functions+=(_tmux_cwd_window_name)
