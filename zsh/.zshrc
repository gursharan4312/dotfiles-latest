DOTFILES_ZSH="$HOME/github/dotfiles-latest/zsh"

# History
source "$DOTFILES_ZSH/modules/history.sh"

# Completions
source "$DOTFILES_ZSH/modules/autocompletion.sh"

# Aliases
source "$DOTFILES_ZSH/modules/aliases.sh"

# Sesh — project session manager
source "$DOTFILES_ZSH/modules/sesh.sh"

# Antidote — bootstrap if missing, then load plugins
[[ -d ~/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
source ~/.antidote/antidote.zsh
antidote load

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
