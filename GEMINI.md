# Dotfiles

This repository contains personal configuration files for a macOS and Linux environment.

## Project Overview

This is a "dotfiles" repository, used for managing and versioning personal configuration files. It includes configurations for a variety of tools, mostly related to the shell environment, text editors, and terminal emulators.

The user maintains a blog and a YouTube channel where they explain their setup in detail.

## Key Configurations

This repository contains configurations for the following tools:

*   **Shell:** `zsh` is the primary shell, with separate configurations for macOS and Linux. The main configuration file is `zshrc/zshrc-file.sh`.
*   **Terminal Emulators:**
    *   **Alacritty:** The configuration is located at `alacritty/alacritty.toml`.
    *   **Kitty:** The configuration is located at `kitty/kitty.conf`.
    *   **Wezterm:** The configuration is located at `wezterm/wezterm.lua`.
*   **Text Editor:**
    *   **Neovim:** The user has a custom Neovim configuration called "neobean", located in the `neovim/neobean` directory. The `neovim/README.md` file provides more information about the setup.
*   **Window Manager (macOS):**
    *   **yabai:** A tiling window manager for macOS. The configuration is likely in the `yabai/` directory.
    *   **sketchybar:** A flexible status bar for macOS. The configuration is likely in the `sketchybar/` directory.
*   **Multiplexer:**
    *   **tmux:** The configuration is in the `tmux/` directory.
*   **Other Tools:**
    *   **lazygit:** A simple terminal UI for git commands. The configuration is at `lazygit/config.yml`.
    *   **Hammerspoon:** An automation tool for macOS. The configuration is at `hammerspoon/init.lua`.

## Development Conventions

The repository is well-organized, with each tool's configuration in its own directory. Many of the directories contain a `README.md` file with more information about the setup, including links to the user's blog and YouTube channel.

The user has a script for creating symlinks to the configuration files in this repository from their home directory. This is a common practice for managing dotfiles.
