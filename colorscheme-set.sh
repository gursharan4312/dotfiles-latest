#!/usr/bin/env bash
# Interactive colorscheme switcher.
# Run: ./colorscheme-set.sh           — interactive menu
#      ./colorscheme-set.sh <name>    — apply directly, e.g. ./colorscheme-set.sh tokyo-night

set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THEMES_DIR="$DOTFILES/colorscheme/list"
ACTIVE_FILE="$DOTFILES/colorscheme/active/active-colorscheme.sh"

# ── Pick a theme ─────────────────────────────────────────────────────────────

mapfile -t themes < <(ls "$THEMES_DIR"/*.sh 2>/dev/null | xargs -I{} basename {} .sh | sort)

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

# ── Kitty ─────────────────────────────────────────────────────────────────────

generate_kitty() {
    local out="$DOTFILES/kitty/.config/kitty/active-theme.conf"
    mkdir -p "$(dirname "$out")"
    cat > "$out" <<EOF
foreground            $linkarzu_color14
background            $linkarzu_color10
selection_foreground  $linkarzu_color14
selection_background  $linkarzu_color16
url_color             $linkarzu_color03
# black
color0                $linkarzu_color10
color8                $linkarzu_color08
# red
color1                $linkarzu_color11
color9                $linkarzu_color11
# green
color2                $linkarzu_color02
color10               $linkarzu_color02
# yellow
color3                $linkarzu_color05
color11               $linkarzu_color05
# blue
color4                $linkarzu_color04
color12               $linkarzu_color04
# magenta
color5                $linkarzu_color01
color13               $linkarzu_color01
# cyan
color6                $linkarzu_color03
color14               $linkarzu_color03
# white
color7                $linkarzu_color14
color15               $linkarzu_color14
cursor                $linkarzu_color24
cursor_text_color     $linkarzu_color10
active_tab_foreground   $linkarzu_color10
active_tab_background   $linkarzu_color02
inactive_tab_foreground $linkarzu_color03
inactive_tab_background $linkarzu_color10
active_border_color     $linkarzu_color04
inactive_border_color   $linkarzu_color10
EOF
    echo "  kitty"
}

# ── btop ──────────────────────────────────────────────────────────────────────

generate_btop() {
    local out="$DOTFILES/btop/.config/btop/themes/btop-theme.theme"
    mkdir -p "$(dirname "$out")"
    cat > "$out" <<EOF
theme[main_bg]=""
theme[main_fg]="$linkarzu_color14"
theme[title]="$linkarzu_color14"
theme[hi_fg]="$linkarzu_color02"
theme[selected_bg]="$linkarzu_color04"
theme[selected_fg]="$linkarzu_color14"
theme[inactive_fg]="$linkarzu_color09"
theme[graph_text]="$linkarzu_color14"
theme[meter_bg]="$linkarzu_color17"
theme[proc_misc]="$linkarzu_color01"
theme[cpu_box]="$linkarzu_color04"
theme[mem_box]="$linkarzu_color02"
theme[net_box]="$linkarzu_color03"
theme[proc_box]="$linkarzu_color05"
theme[div_line]="$linkarzu_color17"
theme[temp_start]="$linkarzu_color01"
theme[temp_mid]="$linkarzu_color16"
theme[temp_end]="$linkarzu_color06"
theme[cpu_start]="$linkarzu_color01"
theme[cpu_mid]="$linkarzu_color05"
theme[cpu_end]="$linkarzu_color02"
theme[free_start]="$linkarzu_color18"
theme[free_mid]="$linkarzu_color16"
theme[free_end]="$linkarzu_color06"
theme[cached_start]="$linkarzu_color03"
theme[cached_mid]="$linkarzu_color05"
theme[cached_end]="$linkarzu_color08"
theme[available_start]="$linkarzu_color21"
theme[available_mid]="$linkarzu_color01"
theme[available_end]="$linkarzu_color04"
theme[used_start]="$linkarzu_color19"
theme[used_mid]="$linkarzu_color05"
theme[used_end]="$linkarzu_color02"
theme[download_start]="$linkarzu_color01"
theme[download_mid]="$linkarzu_color02"
theme[download_end]="$linkarzu_color05"
theme[upload_start]="$linkarzu_color08"
theme[upload_mid]="$linkarzu_color16"
theme[upload_end]="$linkarzu_color06"
theme[process_start]="$linkarzu_color03"
theme[process_mid]="$linkarzu_color02"
theme[process_end]="$linkarzu_color06"
EOF
    echo "  btop"
}

# ── Starship ──────────────────────────────────────────────────────────────────

generate_starship() {
    local out="$DOTFILES/starship-config/.config/active-config.toml"
    mkdir -p "$(dirname "$out")"
    cat > "$out" <<EOF
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

[time]
disabled = false
style    = '${linkarzu_color04} bold'
format   = '[\[$time\]](\$style) '
time_format = '%y/%m/%d'

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

# ── tmux ──────────────────────────────────────────────────────────────────────

apply_tmux() {
    if ! command -v tmux &>/dev/null || ! tmux info &>/dev/null 2>&1; then
        return 0
    fi
    tmux set -g @catppuccin_directory_color         "$linkarzu_color03"
    tmux set -g @catppuccin_window_current_color     "$linkarzu_color08"
    tmux set -g @catppuccin_window_current_background "$linkarzu_color10"
    tmux set -g @catppuccin_window_default_color     "$linkarzu_color23"
    tmux set -g @catppuccin_window_default_background "$linkarzu_color10"
    tmux set -g @catppuccin_pane_active_border_style  "fg=$linkarzu_color03"
    tmux set -g @catppuccin_pane_border_style         "fg=$linkarzu_color09"
    tmux set -g @catppuccin_status_background         "default"
    tmux set -g @catppuccin_session_color "#{?client_prefix,$linkarzu_color04,$linkarzu_color02}"
    tmux set -g @catppuccin_window_default_fill "number"
    tmux set -g @catppuccin_window_default_text "#[fg=$linkarzu_color14]#W"
    tmux set -g @catppuccin_window_current_fill "number"
    tmux set -g @catppuccin_window_current_text \
        "#W#{?window_zoomed_flag,#[fg=$linkarzu_color04] (zoom),}#{?pane_synchronized,#[fg=$linkarzu_color04] SYNC,}"
    tmux set -wF mode-style "fg=$linkarzu_color02,bg=$linkarzu_color13"
    tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || tmux source-file ~/.tmux.conf 2>/dev/null || true
    echo "  tmux"
}

# ── macOS: reload running apps ────────────────────────────────────────────────

reload_macos_apps() {
    # Ghostty — reload via AppleScript
    if [[ -f "$DOTFILES/ghostty/reload-config.scpt" ]]; then
        osascript "$DOTFILES/ghostty/reload-config.scpt" 2>/dev/null && echo "  ghostty reloaded" || true
    fi

    # Kitty — signal reload (no restart needed)
    if pgrep -x kitty &>/dev/null; then
        kill -SIGUSR1 "$(pgrep -x kitty)" 2>/dev/null && echo "  kitty reloaded" || true
    fi

    # Sketchybar
    if command -v sketchybar &>/dev/null; then
        sketchybar --reload 2>/dev/null && echo "  sketchybar reloaded" || true
    fi
}

# ── Run everything ────────────────────────────────────────────────────────────

echo "Generating configs:"
generate_ghostty
generate_kitty
generate_btop
generate_starship

echo "Applying live:"
apply_tmux

if [[ "$(uname)" == "Darwin" ]]; then
    reload_macos_apps
fi

echo ""
echo "Done. Theme: $chosen"
echo "Note: open a new terminal (or run 'source ~/.zshrc') to pick up starship colors."
