# Colorscheme configuration
# This is set in ~/github/dotfiles-latest/colorscheme/colorscheme-vars.sh
~/github/dotfiles-latest/zshrc/colorscheme-set.sh "$colorscheme_profile"

# Brew autocompletion settings
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# -v makes command display a description of how the shell would
# invoke the command, so you're checking if the command exists and is executable.
if command -v brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# eza
# ls replacement
# https://github.com/eza-community/eza
# uses colours to distinguish file types and metadata. It knows about
# symlinks, extended attributes, and Git.
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias ll='eza -lhg'
  alias lla='eza -alhg'
  alias tree='eza --tree'
fi

# Bat -> Cat with wings
# https://github.com/sharkdp/bat
# Supports syntax highlighting for a large number of programming and markup languages
if command -v bat &>/dev/null; then
  # --style=plain - removes line numbers and git modifications
  # --paging=never - doesnt pipe it through less
  alias cat='bat --paging=never --style=plain'
  alias catt='bat'
  # alias cata='bat --show-all --paging=never'
  alias cata='bat --show-all --paging=never --style=plain'
fi

# smarter cd command, it remembers which directories you use most
# frequently, so you can "jump" to them in just a few keystrokes.
# https://github.com/ajeetdsouza/zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias cdd='z -'

fi

# Source Google Cloud SDK configurations, if Homebrew and the SDK are installed
if command -v brew &>/dev/null; then
  if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  fi
  if [ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
  fi
fi

# PATH
export PATH=/usr/local/go/bin:$PATH

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools

fpath+=~/.zfunc

export STARSHIP_CONFIG=$HOME/github/dotfiles-latest/starship-config/active-config.toml
