# Stow Migration Plan

This document outlines the plan to migrate the existing dotfiles to be managed by `stow`.

## General Strategy

The goal is to use `stow` to manage symlinks from this dotfiles repository to the user's home directory. The current directory structure is already well-organized, which is a good starting point.

The migration will involve the following steps:

1.  **Restructure for Stow:** For each directory (which will become a `stow` package), we need to ensure the file paths inside the directory match the desired path relative to the home directory. For example, if a file needs to be at `~/.config/nvim/init.lua`, then in this repository, it should be at `nvim/.config/nvim/init.lua`.

2.  **Stow Command:** The `stow` command will be used to create the symlinks. For example, to stow the `nvim` configuration, we would run `stow nvim`.

3.  **Backup:** Before running `stow`, any existing files in the target locations should be backed up. `stow` has an option to do this (`--backup`).

4.  **Verification:** After running `stow`, we need to verify that the symlinks are created correctly.

## Directory-by-Directory Plan

Here is a plan for each directory. The "Stow Target" indicates where the files should be symlinked from the home directory.

| Directory | Stow Target | Notes |
|---|---|---|
| `aerospace` | `~/.config/aerospace` | The `aerospace.toml` file should be moved to `aerospace/.config/aerospace/aerospace.toml`. |
| `alacritty` | `~/.config/alacritty` | The `alacritty.toml` and `alacritty.yml` files should be moved to `alacritty/.config/alacritty/`. The `themes` directory should also be moved. |
| `bashrc` | `~/` | The `bashrc-file.sh` should be renamed to `.bashrc` and placed in the `bashrc` directory. |
| `betterTouchTool` | `~/Library/Application Support/BetterTouchTool` | This is a macOS specific directory. The `.bttpreset` file should be moved to the correct location inside the stow package. |
| `brew` | `~/` | The `Brewfile` should be placed in the `brew` directory and symlinked to `~/`. |
| `btop` | `~/.config/btop` | The `btop.conf` and `themes` directory should be moved to `btop/.config/btop/`. |
| `colorscheme` | `~/` | This directory contains scripts. It might be better to add the scripts directory to the `PATH` rather than symlinking individual files. Or, symlink the scripts to `~/.local/bin`. |
| `dictionaries` | `~/` | The `words.txt` file could be symlinked to `~/`. |
| `eligere` | `~/` | The `.eligere.json` and `eligere.toml` files should be symlinked to `~/`. |
| `emacs` | `~/.emacs.d` | The `example.org` file should be moved to `emacs/.emacs.d/`. |
| `fastfetch` | `~/.config/fastfetch` | The `config.jsonc` and `images` directory should be moved to `fastfetch/.config/fastfetch/`. |
| `ghostty` | `~/.config/ghostty` | The `config` file and other contents should be moved to `ghostty/.config/ghostty/`. |
| `hammerspoon` | `~/.hammerspoon` | The lua files should be moved to `hammerspoon/.hammerspoon/`. |
| `hidapitester` | `~/` | This contains a binary. It might be better to add this to the `PATH`. |
| `kanata` | `~/.config/kanata` | The `configs` directory should be moved to `kanata/.config/kanata/`. |
| `karabiner` | `~/.config/karabiner` | The `mxstbr` directory should be moved to `karabiner/.config/karabiner/`. |
| `kitty` | `~/.config/kitty` | The `kitty.conf` and other files should be moved to `kitty/.config/kitty/`. |
| `lazygit` | `~/.config/lazygit` | The `config.yml` should be moved to `lazygit/.config/lazygit/`. |
| `mise` | `~/.config/mise` | The `config.toml` should be moved to `mise/.config/mise/`. |
| `mouseless` | `~/.config/mouseless` | The `config.yaml` should be moved to `mouseless/.config/mouseless/`. |
| `neovide` | `~/.config/neovide` | The `config.toml` should be moved to `neovide/.config/neovide/`. |
| `neovim` | `~/.config/nvim` | The contents of the `neovim` directory should be moved to `neovim/.config/nvim/`. This is a complex one, as it contains multiple neovim configurations. The user is currently using `neobean`. The `neobean` directory should be moved to `neovim/.config/nvim`. |
| `obs` | `~/` | This directory seems to be for OBS guest assets. It's not clear if this should be managed by stow. |
| `rio` | `~/.config/rio` | The `config.toml` should be moved to `rio/.config/rio/`. |
| `scripts` | `~/.local/bin` | The scripts in this directory should be symlinked to `~/.local/bin`. |
| `sesh` | `~/.config/sesh` | The `sesh.toml` should be moved to `sesh/.config/sesh/`. |
| `sketchybar` | `~/.config/sketchybar` | The contents of the `sketchybar` directory should be moved to `sketchybar/.config/sketchybar/`. |
| `starship-config` | `~/.config` | The `starship.toml` file should be moved to `starship-config/.config/starship.toml`. |
| `steermouse` | `~/Library/Application Support/SteerMouse` | macOS specific. The `.smsetting_dev` file should be moved to the correct location inside the stow package. |
| `tmux` | `~/.config/tmux` | The `tmux.conf.sh` should be renamed to `tmux.conf` and moved to `tmux/.config/tmux/`. |
| `ubersicht` | `~/` | The `.simplebarrc` file should be symlinked to `~/`. The `widgets` directory should be moved to `ubersicht/Library/Application Support/Übersicht/widgets`. |
| `vimrc` | `~/` | The `vimrc-file` should be renamed to `.vimrc` and placed in the `vimrc` directory. |
| `vivaldi` | `~/` | Not clear if this should be managed by stow. |
| `vscode` | `~/Library/Application Support/Code/User` | macOS specific. The `settings.json` file should be moved to `vscode/Library/Application Support/Code/User/settings.json`. |
| `wezterm` | `~/.config/wezterm` | The `wezterm.lua` file should be moved to `wezterm/.config/wezterm/wezterm.lua`. |
| `windows` | `~/` | Contains AutoHotkey scripts. Not for macOS/Linux. |
| `yabai` | `~/.config/yabai` | The `yabairc` file and other contents should be moved to `yabai/.config/yabai/`. |
| `yazi` | `~/.config/yazi` | The `yazi.toml` and other files should be moved to `yazi/.config/yazi/`. |
| `zshrc` | `~/` | The `zshrc-file.sh` should be renamed to `.zshrc` and placed in the `zshrc` directory. The other files are sourced from `.zshrc`. |

## Next Steps

1.  **Review the plan:** The user should review this plan and make any necessary adjustments.
2.  **Restructure the directories:** Create the new directory structure as outlined above.
3.  **Backup existing dotfiles:** Before running `stow`, make sure to backup any existing dotfiles.
4.  **Run stow:** Run `stow <directory>` for each directory.
5.  **Verify:** Verify that the symlinks are created correctly.
