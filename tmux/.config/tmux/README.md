# Tmux

Catppuccin status bar + TPM plugins. Config: `~/.config/tmux/tmux.conf` (stow from `tmux/`).

## First-time setup

```bash
brew bundle install          # tmux, tpm, sesh, gitmux
./setup.sh gitmux tmux       # symlink configs
# In tmux:
#   Prefix + I               install TPM plugins
#   Prefix + r               reload config
```

## Status bar

| Area | Content |
|------|---------|
| **Left** | Session name |
| **Right** | Current directory path, git branch/status (gitmux) |
| **Window tabs** | `#I` + basename of pane path (`#{b:pane_current_path}`), flags on active tab |

Colors: `tmux-theme.conf` (regenerate via `./colorscheme-set.sh` from repo root).

## Keybindings

| Keys | Action |
|------|--------|
| `Ctrl+Space` | Prefix |
| `Prefix + r` | Reload config |
| `Prefix + T` | Sesh session picker (fzf) |
| `Prefix + f` | tmux-fzf (sessions / windows / panes) |
| `Prefix + O` | New window: `nvim .` in current pane’s directory |
| `Prefix + m` | extrakto — pick text from scrollback |
| `Prefix + [` then `o` | tmux-open — open highlighted text with default app (copy mode) |
| `Prefix + [` then `C-o` | tmux-open — open highlighted text in nvim (copy mode) |
| `Prefix + I` | Install / update TPM plugins |
| `Shift+←` / `Shift+→` | Previous / next window |
| `Alt+hjkl` | Move between panes |
| `Ctrl+hjkl` | Vim-tmux-navigator (when nvim focused) |

## Plugins (TPM)

- **catppuccin/tmux** — theme and status modules
- **tmux-resurrect** + **tmux-continuum** — save/restore sessions (auto-restore on start)
- **tmux-yank** — copy from vi mode to system clipboard
- **tmux-fzf** — fuzzy finder for sessions/windows/panes
- **tmux-open** — open highlighted text in copy mode (`o` / `C-o`)
- **tmux-extrakto** — extract URLs/paths from pane history

## Git in status bar

Requires **gitmux** (`brew install gitmux`) and `~/.gitmux.conf` (stow `gitmux/` package).
