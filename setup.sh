#!/usr/bin/env bash

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_SUFFIX=".bak.$(date +%s)"
STOW_FOLDERS=$@
if [ -z "$STOW_FOLDERS" ]; then
    # Use POSIX-compatible find (works on both macOS and Linux)
    STOW_FOLDERS=$(find . -maxdepth 1 -not -path '*/.*' -type d | sed 's|^\./||' | grep -v '^\.$')
fi

# Function to check and backup files/folders
# Usage: check_and_backup <package_name> <relative_path>
check_and_backup() {
    local pkg="$1"
    local rel_path="$2"
    local source_path="$DOTFILES_DIR/$pkg/$rel_path"
    local target_path="$HOME/$rel_path"

    # If source is a directory, we need to handle it carefully because stow folds directories
    if [ -d "$source_path" ]; then
        if [ -L "$target_path" ]; then
             # It's a symlink. Check if it's absolute or points to the wrong place
             local link_target=$(readlink "$target_path")
             local canonical_target=$(readlink -f "$target_path")
             local expected_canonical=$(readlink -f "$source_path")
             
             # If it's an absolute symlink or points to wrong location, remove it
             if [[ "$link_target" = /* ]] || [ "$canonical_target" != "$expected_canonical" ]; then
                 echo "Removing incorrect symlink: $target_path -> $link_target"
                 rm "$target_path"
                 return
             fi
             # Otherwise it's a correct relative symlink, leave it
             return
        elif [ -d "$target_path" ]; then
            # Both are directories. We need to recurse because stow will try to fold them.
            # We must verify if stow WILL fold them. Stow folds if the target directory exists and is not a symlink.
            # So we recurse into the source directory's children.
            for child in "$source_path"/*; do
                local child_rel_path="${rel_path}/$(basename "$child")"
                # Strip leading slash if present (though logic above shouldn't add one for first level)
                child_rel_path="${child_rel_path#/}" 
                check_and_backup "$pkg" "$child_rel_path"
            done
        elif [ -e "$target_path" ]; then
             # Target is a file but source is a directory? This is a conflict.
             echo "Backing up file (conflict with dir): $target_path"
             mv "$target_path" "${target_path}${BACKUP_SUFFIX}"
        fi
    else
        # Source is a file
        if [ -L "$target_path" ]; then
            local link_target=$(readlink "$target_path")
            local canonical_target=$(readlink -f "$target_path")
            local expected_canonical=$(readlink -f "$source_path")
            
            # If it's an absolute symlink or points to wrong location, remove it
            if [[ "$link_target" = /* ]] || [ "$canonical_target" != "$expected_canonical" ]; then
                echo "Removing incorrect symlink: $target_path -> $link_target"
                rm "$target_path"
            fi
        elif [ -e "$target_path" ]; then
            echo "Backing up existing file: $target_path"
            mv "$target_path" "${target_path}${BACKUP_SUFFIX}"
        fi
    fi
}

echo "Stowing packages..."

# Ensure ~/.config exists as a real directory so stow never folds it into a symlink
mkdir -p "$HOME/.config"

for folder in $STOW_FOLDERS; do
    if [ "$folder" == "setup.sh" ] || [ "$folder" == "README.md" ]; then
        continue
    fi

    # Interactive prompt — default to yes on empty input
    printf "Stow '%s'? [Y/n] " "$folder"
    read -r answer
    case "$answer" in
        [nN]|[nN][oO])
            echo "Skipping $folder."
            continue
            ;;
    esac

    echo "Processing $folder..."
    
    # Pre-process to handle backups and bad symlinks
    # We iterate over top-level items in the package
    shopt -s dotglob
    for item in "$DOTFILES_DIR/$folder"/*; do
        shopt -u dotglob
        # Handle case where glob matches nothing
        [ -e "$item" ] || continue
        
        rel_path="$(basename "$item")"
        check_and_backup "$folder" "$rel_path"
    done
    
    # --no-folding prevents stow from symlinking whole directories (e.g. ~/.config)
    # and instead creates the real directories and symlinks individual files/dirs within them.
    stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" -R "$folder" 2>&1 | grep -v "BUG in find_stowed_path" || true
done

echo "Done!"
