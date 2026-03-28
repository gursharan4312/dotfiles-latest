#!/usr/bin/env bash

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STOW_FOLDERS=$@
if [ -z "$STOW_FOLDERS" ]; then
    STOW_FOLDERS=$(find . -maxdepth 1 -not -path '*/.*' -type d | sed 's|^\./||' | grep -v '^\.$')
fi

echo "Stowing packages..."

# Ensure ~/.config is a real directory so stow creates symlinks inside it
# instead of replacing it with a single symlink (stow "folding").
mkdir -p "$HOME/.config"

for folder in $STOW_FOLDERS; do
    case "$folder" in
        setup.sh|bootstrap.sh|unstow.sh|colorscheme-set.sh|README.md|colorscheme|assets)
            continue ;;
    esac

    printf "Stow '%s'? [Y/n] " "$folder"
    read -r answer
    case "$answer" in
        [nN]|[nN][oO])
            echo "Skipping $folder."
            continue
            ;;
    esac

    echo "Processing $folder..."
    stow -d "$DOTFILES_DIR" -t "$HOME" -R "$folder" 2>&1 | grep -v "BUG in find_stowed_path" || true
done

echo "Done!"
