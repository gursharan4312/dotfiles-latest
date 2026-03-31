zmodload zsh/complist
autoload -Uz compinit

# Required by oh-my-zsh plugins (e.g. docker) that write completions here
export ZSH_CACHE_DIR="${HOME}/.zsh/cache"
mkdir -p "$ZSH_CACHE_DIR/completions"

# User-installed completions, ohmyzsh plugin cache, and Homebrew completions
# (all must be in fpath before compinit runs)
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fpath=("$HOME/.zsh/completions" "$ZSH_CACHE_DIR/completions" "$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
else
    fpath=("$HOME/.zsh/completions" "$ZSH_CACHE_DIR/completions" $fpath)
fi

# Regenerate dump at most once a day; -C skips security check for speed
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

_comp_options+=(globdots)

setopt AUTO_LIST
setopt COMPLETE_IN_WORD


# Begin Added by stack init (do not modify) #
source /Users/gursharan.hayer/.stack/wrapper.sh
source /Users/gursharan.hayer/.stack/completion.sh
# End Added by stack init (do not modify) #

zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' complete true
zstyle ':completion:*' menu select
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages'     format '%F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings'     format '%F{red}-- no matches found --%f'
