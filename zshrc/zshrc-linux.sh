# Add Debian-specific configurations here
# For example, you can add z.lua config for Linux here, if not installed will install them

# Using xterm-kitty as in macOS on my Debian servers is a nightmare
# If I hit backspace I see extra characters, if I type its all buggy, testing
# if this will fix it
export TERM=xterm-256color

alias ls='ls --color=auto'

export STARSHIP_CONFIG=$HOME/github/dotfiles-latest/starship-config/active-config.toml

# Initialize z.lua
eval "$(lua $HOME/github/z.lua/z.lua --init zsh enhanced once)"

# Initialize neofetch
if command -v neofetch &>/dev/null; then
  # leave blank space before the command
  echo
  neofetch
fi

# PATH
export PATH=/opt/nvim-linux-x86_64/bin:/snap/bin:$PATH
