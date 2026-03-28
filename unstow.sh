#!/usr/bin/env bash
# Remove all dotfile symlinks from $HOME.
# Use this to revert to a clean state before uninstalling or switching setups.
# Original files that were backed up (*.bak.*) are NOT restored automatically.

set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Directories that are NOT stow packages
NON_PACKAGES="colorscheme assets"

echo "Unstowing packages..."
echo ""

# Collect stow packages (top-level dirs, excluding hidden and non-packages)
STOW_FOLDERS=$(find "$DOTFILES" -maxdepth 1 -mindepth 1 -type d \
    | grep -v '/\.' \
    | sed "s|$DOTFILES/||" \
    | sort)

for folder in $STOW_FOLDERS; do
    # Skip non-stow directories
    skip=false
    for np in $NON_PACKAGES; do
        [[ "$folder" == "$np" ]] && skip=true && break
    done
    $skip && continue

    printf "Unstow '%s'? [Y/n] " "$folder"
    read -r answer
    case "$answer" in
        [nN]|[nN][oO])
            echo "  Skipping $folder."
            continue
            ;;
    esac

    stow -d "$DOTFILES" -t "$HOME" -D "$folder" 2>&1 \
        | grep -v "BUG in find_stowed_path" || true
    echo "  Removed symlinks for $folder"
done

echo ""
echo "Done. All selected symlinks removed."
echo "Note: any *.bak.* backup files from the original setup.sh run were NOT touched."
