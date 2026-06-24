#!/usr/bin/env bash
session_name="$1"
[ -z "$session_name" ] && exit 0

first_window_pane=$(tmux list-panes -t "$session_name" -F '#{window_index} #{pane_index}' 2>/dev/null | sort -n | head -1)
[ -z "$first_window_pane" ] && exit 0

pane_path=$(tmux display-message -t "$session_name:$first_window_pane" -p '#{pane_current_path}' 2>/dev/null)
[ -z "$pane_path" ] && exit 0

branch=$(git -C "$pane_path" symbolic-ref --short HEAD 2>/dev/null)
if [ -z "$branch" ]; then
    target_name="$session_name"
else
    base_name=$(echo "$session_name" | sed 's/([^)]*)//')
    target_name="${base_name}(${branch})"
fi

if [ "$session_name" != "$target_name" ]; then
    tmux rename-session -t "$session_name" "$target_name"
fi
