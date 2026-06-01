# Tmux

Config: `~/.config/tmux/tmux.conf` (stow from `tmux/`).

**Status bar & tabs:** [tmux2k](https://github.com/2KAbhishek/tmux2k) (catppuccin theme, git, cwd, time, path in window list).

## First-time setup

```bash
brew bundle install          # tmux, tpm, bash 5.2+, sesh
./setup.sh tmux

# In tmux (install plugins once):
#   Prefix + I
#   Prefix + r               reload config
```

tmux2k needs **bash 5.2+**. Ghostty/kitty are supported; default Terminal.app is not.

## Layout

| Area | Content |
|------|---------|
| **Left** | Session name |
| **Center** | Window tabs: `#I` + `#{b:pane_current_path}` |
| **Right** | Git branch/status, cwd, time |

Theme colors: `tmux2k-overrides.conf` (regenerate via `./colorscheme-set.sh`).

## Keybindings

| Keys | Action |
|------|--------|
| `Ctrl+Space` | Prefix |
| `Prefix + r` | Reload config |
| `Prefix + T` | Sesh session picker |
| `Prefix + f` | tmux-fzf |
| `Prefix + O` | New window: `nvim .` in pane cwd |
| `Prefix + [` then `o` / `Ctrl+o` | tmux-open (copy mode) |
| `Prefix + m` | extrakto |
| `Prefix + I` | Install TPM plugins |
| `Shift+←` / `Shift+→` | Prev / next window |
| `Alt+hjkl` | Move between panes |
| `Ctrl+hjkl` | Vim-tmux-navigator (when nvim focused) |

## TPM plugins

| Plugin | Role |
|--------|------|
| **2kabhishek/tmux2k** | Theme, status bar, window list |
| **tmux-resurrect** + **continuum** | Session restore |
| **tmux-yank** | Vi copy → clipboard |
| **tmux-fzf** | Fuzzy session/window/pane picker |
| **tmux-open** | Open selection in copy mode |
| **tmux-extrakto** | Extract text from scrollback |

Removed vs old setup: **catppuccin/tmux**, **gitmux**, **zsh window renamer** (tmux2k handles tabs + git).
