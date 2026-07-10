DOTFILES_ZSH="$HOME/github/dotfiles-latest/zsh"

# Editor (vim -> nvim; $EDITOR is exec'd directly so it can't use the vim alias)
export EDITOR=nvim
export VISUAL=nvim

# History
source "$DOTFILES_ZSH/modules/history.sh"

# Completions
source "$DOTFILES_ZSH/modules/autocompletion.sh"

# Aliases
source "$DOTFILES_ZSH/modules/aliases.sh"

# Sesh — project session manager
source "$DOTFILES_ZSH/modules/sesh.sh"

# Herdr — auto-rename the focused tab when an agent harness launches
source "$DOTFILES_ZSH/modules/herdr-tab.sh"

# Antidote — bootstrap if missing, then load plugins
[[ -d ~/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
source ~/.antidote/antidote.zsh
antidote load

# history-substring-search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Platform-specific config
if [[ "$OSTYPE" == darwin* ]]; then
    source "$DOTFILES_ZSH/zshrc-macos.sh"
else
    source "$DOTFILES_ZSH/zshrc-linux.sh"
fi

# Prompt
eval "$(starship init zsh)"

# Begin Added by stack init (do not modify) #
autoload -Uz compinit
compinit
source /Users/gursharan.hayer/.stack/wrapper.sh
source /Users/gursharan.hayer/.stack/completion.sh
# End Added by stack init (do not modify) #
eval "$(mise activate zsh)"
