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

# ── eza ──────────────────────────────────────────────────────────────────────
# eza reads EZA_COLORS (LS_COLORS syntax, 24-bit truecolor accepted), so `ls`
# matches the terminal palette instead of GNU's stock blue/green.

_rgb() {
    local hex="${1#\#}"
    # 16# parsing (not printf %d 0x…) keeps this working on macOS bash 3.2
    printf '%d;%d;%d' "$((16#${hex:0:2}))" "$((16#${hex:2:2}))" "$((16#${hex:4:2}))"
}

generate_eza() {
    local out="$DOTFILES/colorscheme/active/eza-colors.sh"
    local rules=(
        "di=$linkarzu_color04" "ln=$linkarzu_color07" "ex=$linkarzu_color02" "fi=$linkarzu_color14"
        "pi=$linkarzu_color12" "so=$linkarzu_color18" "bd=$linkarzu_color05" "cd=$linkarzu_color05"
        "or=$linkarzu_color11" "mi=$linkarzu_color11" "su=$linkarzu_color11" "sg=$linkarzu_color11"
        "tw=$linkarzu_color02" "ow=$linkarzu_color04" "st=$linkarzu_color04" "mh=$linkarzu_color02"
        "ga=$linkarzu_color02" "gm=$linkarzu_color05" "gd=$linkarzu_color11"
        "gv=$linkarzu_color01" "gt=$linkarzu_color12"
        "da=$linkarzu_color09" "sn=$linkarzu_color21" "uu=$linkarzu_color05" "gu=$linkarzu_color05"
        "*.md=$linkarzu_color20" "*.txt=$linkarzu_color21" "*.pdf=$linkarzu_color11"
        "*.jpg=$linkarzu_color18" "*.jpeg=$linkarzu_color18" "*.png=$linkarzu_color18"
        "*.gif=$linkarzu_color18" "*.webp=$linkarzu_color18" "*.svg=$linkarzu_color18" "*.ico=$linkarzu_color18"
        "*.mp3=$linkarzu_color12" "*.flac=$linkarzu_color12" "*.wav=$linkarzu_color12" "*.ogg=$linkarzu_color12"
        "*.mp4=$linkarzu_color12" "*.mkv=$linkarzu_color12" "*.mov=$linkarzu_color12"
        "*.zip=$linkarzu_color19" "*.tar=$linkarzu_color19" "*.gz=$linkarzu_color19" "*.tgz=$linkarzu_color19"
        "*.bz2=$linkarzu_color19" "*.xz=$linkarzu_color19" "*.zst=$linkarzu_color19"
        "*.7z=$linkarzu_color19" "*.rar=$linkarzu_color19"
        "*.rs=$linkarzu_color12" "*.py=$linkarzu_color05" "*.js=$linkarzu_color05"
        "*.mjs=$linkarzu_color05" "*.cjs=$linkarzu_color05" "*.ts=$linkarzu_color05"
        "*.tsx=$linkarzu_color05" "*.jsx=$linkarzu_color05" "*.json=$linkarzu_color05"
        "*.go=$linkarzu_color07" "*.lua=$linkarzu_color04"
        "*.sh=$linkarzu_color02" "*.bash=$linkarzu_color02" "*.zsh=$linkarzu_color02"
        "*.fish=$linkarzu_color02" "*.toml=$linkarzu_color03" "*.yaml=$linkarzu_color03"
        "*.yml=$linkarzu_color03" "*.ini=$linkarzu_color03" "*.conf=$linkarzu_color03"
        "*.lock=$linkarzu_color09"
    )
    local rule key hex colors=""
    for rule in "${rules[@]}"; do
        key="${rule%%=*}"
        hex="${rule#*=}"
        colors+="${key}=38;2;$(_rgb "$hex"):"
    done
    colors="${colors%:}"

    mkdir -p "$(dirname "$out")"
    {
        echo "# Generated by colorscheme-set.sh — do not edit. Theme: $chosen"
        printf "export EZA_COLORS='%s'\n" "$colors"
    } > "$out"
    echo "  eza"
}

# ── Windows Terminal ─────────────────────────────────────────────────────────
# WSL can't colour the Windows-side emulator, so patch WT's settings.json
# directly. One constant scheme name ("Dotfiles Active") is reused, so a theme
# switch only rewrites the palette values and WT hot-reloads — no restart.

generate_windows_terminal() {
    local settings="" candidate
    local -a candidates
    shopt -s nullglob
    candidates=(
        /mnt/c/Users/*/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json
        /mnt/c/Users/*/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_*/LocalState/settings.json
        /mnt/c/Users/*/AppData/Local/Microsoft/"Windows Terminal"/settings.json
    )
    shopt -u nullglob
    for candidate in "${candidates[@]}"; do
        case "$candidate" in
            */Public/*|*/Default/*) continue ;;
        esac
        settings="$candidate"
        break
    done

    if [[ -z "$settings" ]]; then
        echo "  windows terminal (skipped: not running under WSL)"
        return 0
    fi
    if ! command -v python3 >/dev/null 2>&1; then
        echo "  windows terminal (skipped: python3 not found)"
        return 0
    fi

    python3 - "$settings" <<PY || { echo "  windows terminal (failed)"; return 0; }
import json, os, shutil, sys

path = sys.argv[1]
scheme = {
    "name": "Dotfiles Active",
    "background": "$linkarzu_color10",
    "foreground": "$linkarzu_color14",
    "cursorColor": "$linkarzu_color24",
    "selectionBackground": "$linkarzu_color16",
    "black": "$linkarzu_color08",
    "red": "$linkarzu_color11",
    "green": "$linkarzu_color02",
    "yellow": "$linkarzu_color05",
    "blue": "$linkarzu_color04",
    "purple": "$linkarzu_color18",
    "cyan": "$linkarzu_color03",
    "white": "$linkarzu_color15",
    "brightBlack": "$linkarzu_color16",
    "brightRed": "$linkarzu_color11",
    "brightGreen": "$linkarzu_color02",
    "brightYellow": "$linkarzu_color05",
    "brightBlue": "$linkarzu_color04",
    "brightPurple": "$linkarzu_color18",
    "brightCyan": "$linkarzu_color03",
    "brightWhite": "$linkarzu_color21",
}

backup = path + ".dotfiles-backup"
if not os.path.exists(backup):
    shutil.copy2(path, backup)

with open(path, encoding="utf-8-sig") as fh:
    cfg = json.load(fh)

existing = [s for s in cfg.get("schemes", []) if s.get("name") != scheme["name"]]
cfg["schemes"] = [scheme] + existing

profiles = cfg.setdefault("profiles", {})
profiles.setdefault("defaults", {})["colorScheme"] = scheme["name"]
for profile in profiles.get("list", []):
    if profile.get("name") == "Ubuntu":
        profile["colorScheme"] = scheme["name"]

tmp = path + ".tmp"
with open(tmp, "w", encoding="utf-8") as fh:
    json.dump(cfg, fh, indent=4)
    fh.write("\n")
os.replace(tmp, path)

print("  windows terminal")
PY
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
generate_eza
generate_windows_terminal

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
