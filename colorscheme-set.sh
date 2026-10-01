#!/usr/bin/env bash
# Interactive colorscheme switcher.
# Run: ./colorscheme-set.sh           — interactive menu
#      ./colorscheme-set.sh <name>    — apply directly, e.g. ./colorscheme-set.sh tokyo-night

set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THEMES_DIR="$DOTFILES/colorscheme/list"
ACTIVE_FILE="$DOTFILES/colorscheme/active/active-colorscheme.sh"

# ── Pick a theme ─────────────────────────────────────────────────────────────

themes=()
while IFS= read -r t; do
    themes+=("$t")
done < <(ls "$THEMES_DIR"/*.sh 2>/dev/null | xargs -I{} basename {} .sh | sort)

if [[ ${#themes[@]} -eq 0 ]]; then
    echo "No themes found in $THEMES_DIR"; exit 1
fi

if [[ -n "$1" ]]; then
    chosen="$1"
elif command -v fzf &>/dev/null; then
    chosen=$(printf '%s\n' "${themes[@]}" | fzf --prompt="  Theme: " --height=40% --border --reverse)
else
    echo "Available themes:"
    for i in "${!themes[@]}"; do
        printf "  %2d) %s\n" "$((i+1))" "${themes[$i]}"
    done
    printf "\nChoose [1-%d]: " "${#themes[@]}"
    read -r choice
    chosen="${themes[$((choice-1))]}"
fi

[[ -z "$chosen" ]] && exit 0

theme_file="$THEMES_DIR/$chosen.sh"
if [[ ! -f "$theme_file" ]]; then
    echo "Theme '$chosen' not found in $THEMES_DIR"; exit 1
fi

# Already active?
if [[ -f "$ACTIVE_FILE" ]] && diff -q "$ACTIVE_FILE" "$theme_file" &>/dev/null; then
    echo "Theme '$chosen' is already active — nothing to do."; exit 0
fi

echo "Applying: $chosen"

cp "$theme_file" "$ACTIVE_FILE"
# shellcheck source=/dev/null
source "$ACTIVE_FILE"

# ── Ghostty ──────────────────────────────────────────────────────────────────

generate_ghostty() {
    local out="$DOTFILES/ghostty/.config/ghostty/ghostty-theme"
    mkdir -p "$(dirname "$out")"
    cat > "$out" <<EOF
background = $linkarzu_color10
foreground = $linkarzu_color14
cursor-color = $linkarzu_color24

# black
palette = 0=$linkarzu_color10
palette = 8=$linkarzu_color08
# red
palette = 1=$linkarzu_color11
palette = 9=$linkarzu_color11
# green
palette = 2=$linkarzu_color02
palette = 10=$linkarzu_color02
# yellow
palette = 3=$linkarzu_color05
palette = 11=$linkarzu_color05
# blue
palette = 4=$linkarzu_color04
palette = 12=$linkarzu_color04
# purple
palette = 5=$linkarzu_color01
palette = 13=$linkarzu_color01
# cyan
palette = 6=$linkarzu_color03
palette = 14=$linkarzu_color03
# white
palette = 7=$linkarzu_color14
palette = 15=$linkarzu_color14
EOF
    echo "  ghostty"
}

# ── Starship ──────────────────────────────────────────────────────────────────

generate_starship() {
    local out="$DOTFILES/starship-config/.config/active-config.toml"
    mkdir -p "$(dirname "$out")"
    cat > "$out" <<EOF
# The web monorepo has a 3.3G .git, so a cold \`git status\` render can exceed
# starship's 500ms default. Raise the ceiling to keep git_status in the prompt.
command_timeout = 2000

format = """
\$username\
\$hostname\
\$time\
\$all\
\$directory
\$character
"""

[character]
success_symbol = '[❯❯❯❯](${linkarzu_color02} bold)'
error_symbol   = '[✗✗✗✗](${linkarzu_color11} bold)'
vicmd_symbol   = '[❮❮❮❮](${linkarzu_color04} bold)'

[battery]
disabled = true

[aws]
disabled = true

[time]
disabled = false
style    = '${linkarzu_color04} bold'
format   = '[\[\$time\]](\$style) '
time_format = '%d/%m:%H:%M:%S'

[username]
show_always = true
style_user  = '${linkarzu_color04} bold'
style_root  = 'white bold'
format      = '[\$user](\$style).@.'

[hostname]
ssh_only = true
format   = '(white bold)[\$hostname](${linkarzu_color02} bold)'

[directory]
style             = '${linkarzu_color03} bold'
truncation_length = 0
truncate_to_repo  = false

[ruby]
detect_variables = []
detect_files     = ['Gemfile', '.ruby-version']
EOF
    echo "  starship"
}

# ── macOS: reload running apps ────────────────────────────────────────────────

reload_macos_apps() {
    # Ghostty — reload via AppleScript
    if [[ -f "$DOTFILES/ghostty/reload-config.scpt" ]]; then
        osascript "$DOTFILES/ghostty/reload-config.scpt" 2>/dev/null && echo "  ghostty reloaded" || true
    fi
}

# ── Run everything ────────────────────────────────────────────────────────────

echo "Generating configs:"
generate_ghostty
generate_starship

echo "Applying live:"
if command -v tmux &>/dev/null && tmux info &>/dev/null 2>&1; then
    tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true
    echo "  tmux reloaded"
fi

if [[ "$(uname)" == "Darwin" ]]; then
    reload_macos_apps
fi

echo ""
echo "Done. Theme: $chosen"
echo "Note: open a new terminal (or run 'source ~/.zshrc') to pick up starship colors."
