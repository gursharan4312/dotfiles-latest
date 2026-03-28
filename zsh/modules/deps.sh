# Antidote bootstrap — clones if missing, then sources it.
# Called from .zshrc; kept here for reference but .zshrc sources antidote directly.
install_antidote() {
    local antidote_home="${ZDOTDIR:-$HOME}/.antidote"
    if [[ ! -d "$antidote_home" ]]; then
        echo "[INFO] Installing antidote..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_home"
    fi
}
