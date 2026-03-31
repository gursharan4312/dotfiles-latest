# .zprofile — login shells only (runs once, not on every new terminal tab)
# Put static PATH and env vars here so .zshrc stays fast.

# Homebrew (Apple Silicon path; Intel uses /usr/local)
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Starship prompt config
export STARSHIP_CONFIG="$HOME/github/dotfiles-latest/starship-config/.config/active-config.toml"
eval "$(mise activate zsh --shims)"
