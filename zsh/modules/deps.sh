#!/usr/bin/env zsh
# =============================================================================
# Dependency Management for ZSH
# Auto-installs zsh-related packages and logs missing external dependencies
# =============================================================================

# Track missing dependencies
typeset -g MISSING_DEPS=()

# Detect OS
_detect_os() {
    case "$(uname -s)" in
        Darwin) echo 'macos' ;;
        Linux)  echo 'linux' ;;
        *)      echo 'unknown' ;;
    esac
}

# Check if a command exists
_cmd_exists() {
    command -v "$1" &>/dev/null
}

# Check if ANY of the given commands exist (for tools with multiple names)
_any_cmd_exists() {
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null && return 0
    done
    return 1
}

# Add to missing deps list
_add_missing() {
    MISSING_DEPS+=("$1")
}

# =============================================================================
# ZSH Package Installation (auto-install)
# =============================================================================

# Install antidote plugin manager
install_antidote() {
    local antidote_home="${ZDOTDIR:-$HOME}/.antidote"
    if [[ ! -d "$antidote_home" ]]; then
        echo "[INFO] Installing antidote plugin manager..."
        if git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_home" 2>/dev/null; then
            echo "[OK] Antidote installed successfully"
        else
            echo "[ERROR] Failed to install antidote (requires git)"
            return 1
        fi
    fi
    return 0
}

# Initialize antidote and load plugins
init_antidote() {
    local antidote_home="${ZDOTDIR:-$HOME}/.antidote"
    local plugins_txt="${DOTFILES_DIR:-.}/.zsh_plugins.txt"
    local plugins_zsh="$HOME/.zsh_plugins.zsh"
    
    if [[ -f "$antidote_home/antidote.zsh" ]]; then
        source "$antidote_home/antidote.zsh"
        
        # Generate plugins file if source changed or doesn't exist
        if [[ ! -f "$plugins_zsh" ]] || [[ "$plugins_txt" -nt "$plugins_zsh" ]]; then
            if [[ -f "$plugins_txt" ]]; then
                antidote bundle <"$plugins_txt" >"$plugins_zsh"
            fi
        fi
        
        [[ -f "$plugins_zsh" ]] && source "$plugins_zsh"
        return 0
    fi
    return 1
}

# Ensure ZSH cache directory exists
ensure_zsh_cache() {
    local cache_dir="${ZSH_CACHE_DIR:-$HOME/.cache/zsh}"
    [[ ! -d "$cache_dir/completions" ]] && mkdir -p "$cache_dir/completions"
    export ZSH_CACHE_DIR="$cache_dir"
}

# =============================================================================
# External Dependencies Check
# =============================================================================

check_external_deps() {
    local os=$(_detect_os)
    
    # --- Required Tools ---
    
    _cmd_exists git || _add_missing "git - Install via package manager"
    
    # Starship prompt
    if ! _cmd_exists starship; then
        case "$os" in
            macos) _add_missing "starship - brew install starship" ;;
            linux) _add_missing "starship - curl -sS https://starship.rs/install.sh | sh" ;;
        esac
    fi
    
    # Neovim
    if ! _any_cmd_exists nvim bob; then
        case "$os" in
            macos) _add_missing "neovim - brew install neovim" ;;
            linux) _add_missing "neovim - Install from https://github.com/neovim/neovim/releases" ;;
        esac
    fi
    
    # --- Optional Tools ---
    
    # eza (ls replacement)
    if ! _cmd_exists eza; then
        case "$os" in
            macos) _add_missing "eza (optional) - brew install eza" ;;
            linux) _add_missing "eza (optional) - cargo install eza OR apt install eza (Ubuntu 24.04+)" ;;
        esac
    fi
    
    # bat (cat replacement) - on Debian/Ubuntu it's called 'batcat'
    if ! _any_cmd_exists bat batcat; then
        case "$os" in
            macos) _add_missing "bat (optional) - brew install bat" ;;
            linux) _add_missing "bat (optional) - apt install bat" ;;
        esac
    fi
    
    # zoxide (smarter cd)
    if ! _cmd_exists zoxide; then
        case "$os" in
            macos) _add_missing "zoxide (optional) - brew install zoxide" ;;
            linux) _add_missing "zoxide (optional) - curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh" ;;
        esac
    fi
    
    # fd (find replacement) - on Debian/Ubuntu it's called 'fdfind'
    if ! _any_cmd_exists fd fdfind; then
        case "$os" in
            macos) _add_missing "fd (optional) - brew install fd" ;;
            linux) _add_missing "fd (optional) - apt install fd-find" ;;
        esac
    fi
    
    # ripgrep
    if ! _cmd_exists rg; then
        case "$os" in
            macos) _add_missing "ripgrep (optional) - brew install ripgrep" ;;
            linux) _add_missing "ripgrep (optional) - apt install ripgrep" ;;
        esac
    fi
    
    # fzf
    if ! _cmd_exists fzf; then
        case "$os" in
            macos) _add_missing "fzf (optional) - brew install fzf" ;;
            linux) _add_missing "fzf (optional) - apt install fzf" ;;
        esac
    fi
    
    # tmux
    if ! _cmd_exists tmux; then
        case "$os" in
            macos) _add_missing "tmux (optional) - brew install tmux" ;;
            linux) _add_missing "tmux (optional) - apt install tmux" ;;
        esac
    fi
    
    # lazygit
    if ! _cmd_exists lazygit; then
        case "$os" in
            macos) _add_missing "lazygit (optional) - brew install lazygit" ;;
            linux) _add_missing "lazygit (optional) - https://github.com/jesseduffield/lazygit#installation" ;;
        esac
    fi
}

# Print missing dependencies summary
print_missing_deps() {
    if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
        echo ""
        echo -e "\033[1;33m[WARN] Missing dependencies:\033[0m"
        for dep in "${MISSING_DEPS[@]}"; do
            echo "  • $dep"
        done
        echo ""
    fi
}

# =============================================================================
# Main initialization
# =============================================================================

init_deps() {
    ensure_zsh_cache
    install_antidote
    init_antidote
    check_external_deps
    print_missing_deps
}
