#!/usr/bin/env bash
# Full setup for a brand new Mac.
# Run once after cloning the repo:  ./bootstrap.sh
#
# What it does:
#   1. Installs Xcode Command Line Tools
#   2. Installs Homebrew
#   3. Installs all packages from brew/Brewfile
#   4. Sets zsh as the default shell
#   5. Runs setup.sh to stow dotfiles
#   6. Prompts to pick a colorscheme

set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ── Helpers ───────────────────────────────────────────────────────────────────

step() { echo ""; echo "▶ $*"; }
ok()   { echo "  ✓ $*"; }

# ── 1. Xcode Command Line Tools ───────────────────────────────────────────────

step "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
    ok "Already installed"
else
    echo "  Installing (a dialog will appear — click Install)..."
    xcode-select --install
    echo "  Press Enter once the installation dialog finishes..."
    read -r
fi

# ── 2. Homebrew ───────────────────────────────────────────────────────────────

step "Homebrew"
if command -v brew &>/dev/null; then
    ok "Already installed"
else
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for the rest of this script (Apple Silicon path)
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
ok "Homebrew ready at $(brew --prefix)"

# ── 3. Brewfile ───────────────────────────────────────────────────────────────

step "Installing packages (brew/Brewfile)"
brew bundle --file="$DOTFILES/brew/Brewfile"
ok "Packages installed"

# ── 4. Default shell → zsh ────────────────────────────────────────────────────

step "Default shell"
ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    ok "Already set to $ZSH_PATH"
else
    if ! grep -qF "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
    ok "Default shell changed to $ZSH_PATH (takes effect in new terminal)"
fi

# ── 5. Stow dotfiles ──────────────────────────────────────────────────────────

step "Stowing dotfiles"
"$DOTFILES/setup.sh"

# ── 6. Colorscheme ───────────────────────────────────────────────────────────

step "Colorscheme"
printf "  Pick a colorscheme now? [Y/n] "
read -r answer
case "$answer" in
    [nN]|[nN][oO])
        echo "  Skipped — run ./colorscheme-set.sh later to choose a theme."
        ;;
    *)
        "$DOTFILES/colorscheme-set.sh"
        ;;
esac

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Bootstrap complete!"
echo "  Open a new terminal to load your shell."
echo "  Antidote plugins will install on first shell start."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
