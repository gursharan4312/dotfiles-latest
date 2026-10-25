# AGENTS.md

macOS/Linux dotfiles managed with **GNU Stow**. No tests, lint, CI, or build system — this is a configuration repository.

Both `opencode` (as `AGENTS.md`) and Claude Code (via the `CLAUDE.md → AGENTS.md` **symlink** in repo root) read this file. Keep it accurate so any assistant has the same mental model.

## Maintenance

When any config, script, or structure in this repo changes, update this file to keep it accurate.

## Repo location constraint

The repo **must** be cloned to `~/github/dotfiles-latest`. Absolute paths are hardcoded throughout:
- `zsh/.zshrc` (`DOTFILES_ZSH=$HOME/github/dotfiles-latest/zsh`)
- `zsh/.zprofile` (`STARSHIP_CONFIG`, `mise` shims)
- `colorscheme-set.sh` (root + legacy `zsh/colorscheme-set.sh`)
- `kitty/.config/kitty/kitty.conf` (theme include, commented shell launches)
- `wezterm/.config/wezterm/wezterm.lua` (color source path)
- `yabai/.config/yabai/*.sh` (yabai_env, yabai_restart, positions)
- `lazygit/.local/bin/herdr-open`, `herdr-open-worktree`, `sesh-open-worktree`
- `herdr/.config/herdr/config.toml` (references `herdr-open`)
- `herdr/.config/herdr/plugins/config/sessionizer/config.toml`

Renaming/dir-locating the repo requires editing all of the above.

## Key commands

| Command | Purpose |
|---------|---------|
| `./bootstrap.sh` | Full fresh-Mac setup: Xcode CLT → Homebrew → Brewfile → zsh default → stow → optional colorscheme |
| `./setup.sh` | Stow **all** non-excluded top-level dirs (interactive Y/n per package) |
| `./setup.sh zsh tmux` | Stow only the listed packages |
| `./unstow.sh` | Remove all stow symlinks from `$HOME` (interactive Y/n per package) |
| `./colorscheme-set.sh` | Interactive colorscheme picker (fzf or numbered fallback) |
| `./colorscheme-set.sh <name>` | Apply a specific theme directly, e.g. `./colorscheme-set.sh tokyo-night` |

`setup.sh` enforces `$HOME/.config` exists as a real directory first (so stow creates symlinks *inside* it instead of replacing it with a single symlink). Filters out `setup.sh`, `bootstrap.sh`, `unstow.sh`, `colorscheme-set.sh`, `colorscheme/`, `assets/`. Silences the noisy `BUG in find_stowed_path` warning.

`bootstrap.sh` installs Homebrew (skipped if present), runs `brew bundle --file=brew/Brewfile`, then `chsh -s "$(command -v zsh)"` (after `sudo tee -a /etc/shells` if needed), then `setup.sh`, then optionally runs `./colorscheme-set.sh`. Antidote plugins install on first shell start.

## Stow packages

Each top-level directory (except those listed below) is a stow package whose contents mirror the structure it should produce under `$HOME`. Examples:
- `zsh/` → symlinks `.zshrc`, `.zprofile`, `.zsh_plugins.txt` into `~`
- `tmux/` → symlinks `.config/tmux/tmux.conf` into `~/.config/tmux/`
- `ghostty/` → symlinks `.config/ghostty/config` into `~/.config/ghostty/`

**Not stowed** (kept in repo at known paths): `colorscheme/`, `assets/`.

### Package index (all top-level dirs that are stow packages)

| Package | Stow target | Purpose / notable files |
|---------|-------------|------------------------|
| `aerospace/` | `~/.config/aerospace/` | macOS tiling WM (primary). `aerospace.toml`. Through `nikitabobko/tap`. |
| `brew/` | n/a (data only) | `Brewfile` consumed by `brew bundle`. Taps: `felixkratz/formulae` (sketchybar), `nikitabobko/tap` (aerospace). |
| `btop/` | `~/.config/btop/` | Process/resource viewer. `btop.conf` + `themes/btop-theme.theme` (composed from colorscheme) + `themes/dracula.theme` (static). |
| `fastfetch/` | `~/.config/fastfetch/` | System info display. `config.jsonc` (kitty-image logo) + `images/` (`.png`/`.webp` logos). Run on first Linux login via `zshrc-linux.sh`. |
| `ghostty/` | `~/.config/ghostty/` | **Primary terminal**. `config` (auto-starts herdr, custom GLSL shaders: `bloom025`, `cursor_blaze_no_trail`, `cursor_smear`), `ghostty-theme` (generated), `reload-config.scpt` (AppleScript reload). |
| `herdr/` | `~/.config/herdr/` | **Primary terminal multiplexer**. `config.toml` (prefix=Ctrl+Space), `session.json` (runtime), `plugins.json` (runtime), `plugins/config/sessionizer/config.toml` (tracked: dev workspace layout — nvim + opencode + lazygit split). |
| `kitty/` | `~/.config/kitty/` | **Legacy terminal** (sessions + remote-control socket at `unix:/tmp/kitty`). `kitty.conf`, `kitty.default.conf` (reference), `active-theme.conf` (generated), `sessions/*.kitty-session` (named workspaces), `themes/` + 307 theme files under `themes/themes/`. |
| `lazygit/` | `~/.config/lazygit/` + `~/.local/bin/` | TUI git client. `config.yml` (`nvim-remote` edit/open presets, two customCommands) + bin scripts in `.local/bin/`. |
| `mise/` | n/a (single file `mise.toml` in repo root) | Tool version manager. **`mise.toml` sits at repo root**, not in a package. Only `lua = "latest"` is managed. |
| `mouseless/` | `~/.config/mouseless/` | macOS keyboard-driven mouse control. `config.yaml` (+ `config.bakup.yaml`). |
| `orca/` | `~/.orca/` | Orca app settings. `keybindings.json` tracked; app-generated `agent-hooks/` and `claude-agent-teams-bin/` gitignored via `orca/.orca/.gitignore`. **Stow-folded like herdr**: `~/.orca` is a single dir symlink into the repo, so Orca's runtime writes land in the repo dir. |
| `starship-config/` | `~/.config/` | Prompt config. `active-config.toml` (generated, written through `STARSHIP_CONFIG` env var), `starship.toml` (static Nerd Font symbols), plus legacy variants `starship-eldritch.toml`, `starship-linkarzu.toml`, `starship1..4.toml`. |
| `tmux/` | `~/.config/tmux/` | Legacy multiplexer. `tmux.conf` (prefix=Ctrl+Space, tmux2k status bar, plugins via TPM), `scripts/update-session-name.sh` (auto-renames session with git branch). |
| `vimrc/` | `~/.vimrc` | **Legacy `.vimrc`** (vim-plug, bullets.vim) used by Obsidian / sticky-notes — *not* Neovim config. `vimrc-file-sticky` is `source`d from `.vimrc` for `sticky.md` sessions. |
| `wezterm/` | `~/.config/wezterm/` | Terminal (present, not in active use). `wezterm.lua` — **broken at runtime**: it calls `dofile("…/neovim/neobean/lua/config/colors.lua")` which doesn't exist; will fail unless a `neovim/neobean-…` package is added. |
| `yabai/` | `~/.config/yabai/` | **Legacy tiling WM** (replaced by aerospace). `yabairc`, `yabai_env.sh`, `yabai_restart.sh`, `positions/kitty-pos.sh`, `positions/yabai-custom-pad.sh`. |
| `yazi/` | `~/.config/yazi/` | Terminal file manager (TUI). `yazi.toml` (show_hidden, optional ueberzug), `keymap.toml` (Esc=quit, dd=remove, yy=yank, o=create), `yazi-default.toml` (upstream reference), `keymap-default.toml` (upstream reference). |
| `zsh/` | `~/.zshrc`, `~/.zprofile`, `~/.zsh_plugins.txt` | Shell. `.stow-local-ignore` excludes `modules/`, `zshrc-*.sh`, `colorscheme-set.sh`, `readme.md`, `.gitignore` — these stay repo-local and are sourced by absolute path from `$HOME/github/dotfiles-latest/zsh/`. |

`.cursor/` exists in repo root but is empty.

## Brewfile (`brew/Brewfile`)

Taps: `felixkratz/formulae` (sketchybar — currently commented out), `nikitabobko/tap` (aerospace).

Brews grouped: **core** (`git stow wget gh`), **shell** (`zsh starship fzf zoxide eza bat fd ripgrep mise`), **multiplexer** (`tmux tpm sesh bash` — bash 5.2+ for tmux2k), **editor/dev** (`bob` for Neovim, `tree-sitter lazygit`), **monitoring** (`btop bottom fastfetch gdu`), **fonts** (`hack`, `jetbrains-mono`, `meslo-lg` Nerd Font casks), **apps** (`aerospace betterdisplay dbeaver-community ghostty steermouse`).

Notable absences: `herdr` itself is **not** in the Brewfile — install it out-of-band (https://herdr.app or `brew install --cask herdr` once published). No neovim binary (managed via `bob`).

## Architecture: primary tools & apps

- **Terminal:** Ghostty (primary, auto-starts herdr — see `ghostty/.config/ghostty/config`. Custom shaders bloom + cursor effects). Kitty is also configured (legacy) with named sessions, remote-control socket at `unix:/tmp/kitty`, and 307 bundled themes under `themes/themes/`. Wezterm config exists but is not in active use.
- **Multiplexer:** **herdr** (primary, prefix=Ctrl+Space — `prefix+\` stacks panes, `prefix+-` splits side-by-side, `Ctrl+h/j/k/l` direct pane focus, `Shift+←/→` prev/next tab, `prefix+n` new workspace). tmux is configured as a fallback (same prefix, tmux2k status bar, TPM plugins).
- **Editor:** Neovim (via `bob` version manager), `vim` aliased to `nvim`. **No `neovim/` or `nvim/` package exists in this repo** — `.vimrc` (see `vimrc/`) is a vim-plug config for Obsidian/sticky-notes only. Neovim configs referenced in `kitty.conf` (e.g. `~/github/dotfiles-latest/neovim/neobean-…`) are **stale comment paths**; see "Known inconsistencies" below.
- **Shell:** ZSH with **antidote** plugin manager. Antigote auto-clones to `~/.antidote` if missing. Real loader: `.zsh_plugins.txt` → `ohmyzsh lib`, `ohmyzsh docker plugin`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`, `zsh-history-substring-search`. (Note: `zsh/readme.md` mentions `jeffreytse/zsh-vi-mode` but that plugin is **not** currently in `.zsh_plugins.txt`.)
- **Prompt:** Starship. Two config locations: `starship-config/.config/active-config.toml` (generated by `./colorscheme-set.sh`, exported via `STARSHIP_CONFIG` in `.zprofile`) + `starship-config/.config/starship.toml` (static Nerd Font symbol overrides — the one merged with the active config).
- **Window manager:** **AeroSpace** (macOS tiling WM, via `nikitabobko/tap` brew). Yabai config (`yabai/.config/yabai/yabairc`) is legacy — used only by paths still referenced from kitty.conf and `zsh/colorscheme-set.sh`.
- **File manager:** **yazi** (TUI, in `yazi/` package).
- **Mouse:** mouseless (Cask app, config in `mouseless/` package).
- **System info:** fastfetch on Linux login only (`zshrc-linux.sh`).
- **Runtimes:** **mise** for `lua` only (`mise.toml` at repo root). Shell is activated twice — `eval "$(mise activate zsh --shims)"` in `.zprofile` (login) and `eval "$(mise activate zsh)"` near the bottom of `.zshrc`.

## herdr notes

- Config: `herdr/.config/herdr/config.toml` — prefix is Ctrl+Space (same as tmux). macOS tip: disable "Select the previous input source" in System Settings > Keyboard, exactly as for tmux, so Ctrl+Space reaches herdr.
- `prefix+g` opens lazygit (`type = "pane"`); `prefix+shift+f` runs `herdr-open` (fzf folder picker); `prefix+shift+n` opens the sessionizer plugin (`sessionizer.open` — moved off `prefix+shift+t` to keep the default `rename_tab` binding there; `prefix+shift+n` is free because `new_workspace` is remapped to `prefix+n`).
- Worktree keys: `prefix+shift+g` (default `new_worktree` — create branch worktree under `[worktrees] directory`, default `~/.herdr/worktrees`, and open as workspace) and `prefix+shift+o` → `herdr-worktree-picker` (in `lazygit/.local/bin/`) — fzf over the current repo's linked worktrees, opens the pick as its own workspace grouped under the parent. The native `open_worktree`/`new_worktree` actions refuse to run from a linked-worktree workspace (`linked_worktree_source` guard, also enforced on the API's `--cwd` source); the picker script sidesteps it by resolving the main repo via `git rev-parse --git-common-dir` first, so it works from any pane in the repo.
- `[terminal] new_cwd = "follow"` — splits and new workspaces inherit the focused pane's cwd, mirroring tmux's `-c "#{pane_current_path}"` bindings. **But herdr's native `new_tab` action resolves the pane's spawn-time cwd, not the live one after a `cd`** — so `prefix+c` is rebound to a `type = "shell"` command running `herdr tab create --focus` (the API does a live process-cwd lookup); the native action is parked on `prefix+shift+c`.
- `herdr-open` (in `lazygit/.local/bin/`) searches `~/dev`, `~/Workspace`, `~/dev/stackadapt`, `~/dev/stackadapt/web-worktrees` (depth-1, BSD-style `find` with `-E`-incompatible negated path predicates; matches the `projects.roots` list in `herdr/.config/herdr/plugins/config/sessionizer/config.toml`). Routes linked worktrees to `herdr worktree open` (groups under parent repo, like `lazygit X`), plain repos/folders to `herdr workspace create`.
- Theme: `catppuccin` to match tmux2k.
- Tracked plugin manifest: `herdr/.config/herdr/plugins/config/sessionizer/config.toml` — defines the "dev" workspace layout (tab with nvim editor + `opencode` agent pane right + lazygit pane down).
- Runtime state (`session.json`, `session-snapshots/`, `plugins.json`, `release-notes.json`, `*.log`, `*.sock`, `*.sock.agent`) is gitignored by `herdr/.config/herdr/.gitignore`. `herdr.sock.agent` is a symlink to the macOS SSH agent socket whose path changes every boot.
- **Stow folded this package**: `~/.config/herdr` is a single directory symlink into the repo (`../github/dotfiles-latest/herdr/.config/herdr`), not per-file links. That's why herdr's runtime files land inside the repo dir, and why creating/replacing files at `~/.config/herdr/...` paths writes directly into the repo — never `ln -sf` "back to the repo" from there; the file is already the repo file.

## lazygit custom config

- `os.editPreset: "nvim-remote"` — `e` opens file in parent nvim via `$NVIM` socket.
- `os.open` is `nvim --server "$NVIM" --remote "<file>"` (lazygit has no `openPreset`).
- `Ctrl+A` in files panel → `lazygit-ai-commit` (GitHub Models API, `gpt-4o-mini` by default, requires `gh auth token`). Generates 8 suggestions, fzf pick, opens `$EDITOR` for review.
- `X` in branches panel → `herdr-open-worktree <branch>` (resolves main repo via `git rev-parse --path-format=absolute --git-common-dir`, opens via `herdr worktree open`).
- `~/.local/bin/` also has `sesh-open-worktree` (tmux equivalent of `herdr-open-worktree`).

## ZSH specifics

- `.zshrc` sources five modules from the repo path (not symlinked): `history.sh` (10k hist, 20k savehist, various dedup opts), `autocompletion.sh` (zsh/complist, fpath includes `$HOME/.zsh/completions`, `$ZSH_CACHE_DIR/completions`, brew site-functions; stubs `compdef` until ohmyzsh load is done), `aliases.sh`, `sesh.sh` (project-session picker), `herdr-tab.sh` — singular zsh `preexec`/`precmd` hooks (the singular functions, not `add-zsh-hook preexec` because the array form passes no args). `preexec` matches the first post-alias-expansion token against `claude|cl`, `opencode|oc`, `codex|cx` and renames the focused tab to `<current-label>.<agent>` — strips any existing `.claude/.opencode/.codex` suffix first so custom names like `babysit loop` become `babysit loop.codex` and switching agents in the same tab swaps just the suffix. `precmd` strips the suffix when `herdr pane get $HERDR_PANE_ID .agent` is empty (agent foreground gone); agents still running keep the suffix. `stack up` (and `stack up <args>`) is reported as a custom `stack` agent via `herdr pane report-agent --source stack-up` in `preexec` and released in `precmd`, so the app pane shows in the agents sidebar (no tab rename). Both no-op outside herdr because `HERDR_TAB_ID`/`HERDR_PANE_ID` are unset.
- Platform split by `$OSTYPE == darwin*`: `zshrc-macos.sh` (eza/bat/zoxide/fzf via Homebrew; sets `XDG_CONFIG_HOME=$HOME/.config`) vs `zshrc-linux.sh` (same with fallbacks: `batcat`, `z.lua`, `neofetch`, distro `/usr/share/doc/fzf/examples`; runs `fastfetch` on login shell — skipped in tmux).
- Aliases shipped: `vim=nvim`, git shortcuts (`push/pull/gc/gcb/gs/gd`), `oc=opencode`, `cl=claude --effort xhigh --enable-auto-mode`, `cx=codex`. `rg` has `--smart-case` and `fd` has `--hidden --exclude .git` defaults.
- **StackAdapt-specific aliases** (only when `~/dev/stackadapt` exists): `sa`, `web`, `frontend`, `backend`, `down` (runs `stack down` in both frontend & backend with labels), `wtpool` (locates the `sa-worktree` SKILL and runs `scripts/wtpool`). `down` and `wtpool` need dev/stackadapt checked out.
- There is also a **`stack init` block** appended to `.zshrc` ("Begin Added by stack init (do not modify)") which sources `/Users/gursharan.hayer/.stack/wrapper.sh` and `/Users/gursharan.hayer/.stack/completion.sh`, then calls `compinit`. This is injected by the StackAdapt dev tooling on local machines — leave it untouched.
- `.bashrc`/`completion` dirs: `fpath = ($HOME/.zsh/completions $ZSH_CACHE_DIR/completions $HOMEBREW_PREFIX/share/zsh/site-functions $fpath)`. `sesh` completions are auto-generated on first run.

## Two `colorscheme-set.sh` scripts

| Script | Driver | Generates | Reload chain |
|--------|--------|-----------|--------------|
| `./colorscheme-set.sh` (root) | `fzf`/numeric menu OR positional arg | `ghostty/.config/ghostty/ghostty-theme`, `starship-config/.config/active-config.toml` | sources tmux if running; on macOS runs `ghostty/reload-config.scpt` (AppleScript) |
| `zsh/colorscheme-set.sh` (legacy) | positional arg only, errors if missing | `kitty/active-theme.conf` (at the wrong path — see "Known inconsistencies"), `ghostty/ghostty-theme` (wrong path), `btop/themes/btop-theme.theme` (wrong path), `starship-config/active-config.toml` (wrong path), copies into `neovim/neobean/.../active-colorscheme.sh`, runs `tmux/tools/linkarzu/set_tmux_colors.sh`, plus macOS-only: sketchybar reload, kitty `SIGUSR1`, wallpaper change via `osascript`, `yabai_restart.sh`. | extensive macOS side-effects |

Both copy the chosen theme from `colorscheme/list/<name>.sh` into `colorscheme/active/active-colorscheme.sh` (gitignored). Available themes in `list/`: `catppuccin-mocha`, `dracula`, `gruvbox-dark`, `linkarzu`, `nord`, `rose-pine`, `tokyo-night`.

Theme files export 24 `linkarzu_colorNN` shell variables (color01–color24) which the generators consume.

## Colorscheme system (do not edit generated files)

Generated files (do **not** hand-edit — re-run `./colorscheme-set.sh` instead; root script writes correct stow-mirror paths, legacy script writes wrong paths but is not the canonical driver):

- `colorscheme/active/active-colorscheme.sh` — **gitignored** (`colorscheme/.gitignore`). Active theme in shell var form.
- `ghostty/.config/ghostty/ghostty-theme` — **tracked in repo** (committed snapshot of the current theme).
- `starship-config/.config/active-config.toml` — **tracked in repo**.
- `kitty/.config/kitty/active-theme.conf` — **tracked in repo**.
- `btop/.config/btop/themes/btop-theme.theme` — **tracked in repo**.

A second static theme `btop/.config/btop/themes/dracula.theme` is also tracked (not generated, hand-tuned).

## Useful conventions & gotchas

- **Lazygit state.yml** gitignored per-package at `lazygit/.config/lazygit/.gitignore`.
- **TPM plugins** gitignored at `tmux/.config/tmux/.gitignore` (`plugins/`).
- **Antidote compiled plugins** gitignored at repo root (`zsh/.zsh_plugins.zsh` listed in top-level `.gitignore`).
- **Cargo/Lua build artifacts**, Neovim `lazyvim.json` files, several `karabiner/`, `brew/*/Brewfile.lock.json`, and assorted scratch files (`tt.*`, `foo.*`, `*.log`) are all in the top-level `.gitignore`.
- **`mise.toml`** is at repo root, not inside a package, and only declares `lua = "latest"`.
- **`DOTFILES_ZSH` is a hard absolute path** in `.zshrc`, so `modules/*.sh` must stay inside the repo at `$HOME/github/dotfiles-latest/zsh/modules/` for sourcing to work.
- **`setup.sh` and `unstow.sh` both interactive** — they `read` a Y/n prompt per package, so they are **not safe to run unattended** in agent automation. `bootstrap.sh` takes entire-machine scope.

## Gitignored generated/runtime files (quick reference)

- `colorscheme/active/active-colorscheme.sh` — active theme (run by colorscheme-set)
- `tmux/.config/tmux/plugins/` — TPM plugins
- `lazygit/.config/lazygit/state.yml` — lazygit runtime state (committed `config.yml` is the static config)
- `zsh/.zsh_plugins.zsh` — antidote compiled plugins
- `herdr/.config/herdr/session.json`, `session-snapshots/` — runtime session state + auto backups
- `herdr/.config/herdr/plugins.json` — plugin manifest cache
- `herdr/.config/herdr/herdr-{client,server}.log`, `*.sock`, `*.sock.agent`
- `herdr/.config/herdr/release-notes.json` — written by `herdr update` with versioned changelog

## Known inconsistencies to address (agents do not silently fix)

These are documented wrong paths / stale references discovered while preparing this file. **Do not "fix" them in unrelated work** — they need their own focused PR so review is clear.

- `wezterm/.config/wezterm/wezterm.lua:8` `dofile(... "/github/dotfiles-latest/neovim/neobean/lua/config/colors.lua")` — no `neovim/` package exists. wezterm will fail at startup unless colors are sourced differently (e.g. inline read of colorscheme/active/active-colorscheme.sh).
- `kitty/.config/kitty/kitty.conf:117–138` heavily-commented `shell` lines reference `~/github/dotfiles-latest/neovim/neobean-sticky/`, `/tmp/skitty-neobean-socket`, NVIM_APPNAME=neobean-sticky etc. All dead. Real launch is just `shell zsh --login`.
- `zsh/colorscheme-set.sh` (legacy) writes generated files to wrong paths (`~/github/dotfiles-latest/kitty/active-theme.conf`, `…/ghostty/ghostty-theme`, `…/btop/themes/btop-theme.theme`, `…/starship-config/active-config.toml`) — actually need to be inside the stow hosts, i.e. `kitty/.config/kitty/active-theme.conf`, etc. Also still calls into `~/github/dotfiles-latest/tmux/tools/linkarzu/set_tmux_colors.sh` (no `tmux/tools/`), `~/github/dotfiles-latest/neovim/neobean/lua/config/active-colorscheme.sh` (no `neovim/`), sketchybar (casks commented out), and an AppleScript wallpaper setter. **Root `./colorscheme-set.sh` is the canonical driver; the legacy one is unmaintained.**
- `zsh/readme.md` lists `jeffreytse/zsh-vi-mode` as a plugin, but `.zsh_plugins.txt` does not include it. Update readme OR re-add the plugin — your call.
- `aerospace.toml` first line says "Place a copy of this config to ~/.aerospace.toml" but the file is stowed to `~/.config/aerospace/aerospace.toml` (AeroSpace's actual config path). Misleading comment — safe to leave or retitle.
- `vimrc/.vimrc` line 4 has a "UNIQUE_ID=do_not_delete_this_line" sentinel for back-ups. Same pattern lives in `yabai/.config/yabai/yabairc:6` and `vimrc/vimrc-file-sticky`. If you remove a dotfile symlink and the unique-id reappears, that's why.
- `yazi/.config/yazi/yazi-default.toml` and `keymap-default.toml` are unmodified upstream reference copies sitting next to `yazi.toml` + `keymap.toml`. Useful as diff baseline — do not delete blindly.
- `kitty/.config/kitty/themes/themes/` is ~307 vendored theme files (full kitty-themes repo). Tracked because they're referenced by `kitty.conf` includes. Heaviest single directory in the repo.
