# Add Bootstrap Script

## Problem
Currently, setting up dotfiles on a new machine requires manually creating symlinks as documented in README.md. This is:

- Error-prone (easy to miss files or create wrong symlinks)
- Time-consuming for new machine setup
- Not self-documenting (dependencies aren't explicit)

## Current State

**File:** `README.md` documents manual symlink creation:
```bash
ln -s $KDHIRA_DOTFILES/.vimrc ~/.vimrc
ln -s $KDHIRA_DOTFILES/.zshrc ~/.zshrc
# etc...
```

## Proposed Solution

Create an `install.sh` script that:
1. Validates prerequisites
2. Creates necessary symlinks
3. Backs up existing files if they exist
4. Reports what was done

## Implementation

### Option A: Simple Shell Script

```bash
#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Files to symlink (source -> target)
declare -A LINKS=(
    [".vimrc"]="$HOME/.vimrc"
    [".zshrc"]="$HOME/.zshrc"
    [".gitconfig"]="$HOME/.gitconfig"
    [".gitexcludes"]="$HOME/.gitexcludes"
)

backup_and_link() {
    local src="$DOTFILES_DIR/$1"
    local dst="$2"

    if [[ -e "$dst" && ! -L "$dst" ]]; then
        echo "Backing up $dst to $dst.bak"
        mv "$dst" "$dst.bak"
    fi

    if [[ -L "$dst" ]]; then
        rm "$dst"
    fi

    ln -s "$src" "$dst"
    echo "Linked $src -> $dst"
}

for src in "${!LINKS[@]}"; do
    backup_and_link "$src" "${LINKS[$src]}"
done

echo "Done! Set KDHIRA_DOTFILES=$DOTFILES_DIR in ~/.zshenv"
```

### Option B: Use GNU Stow

```bash
#!/usr/bin/env bash
# Requires: brew install stow
cd "$KDHIRA_DOTFILES"
stow -v -t "$HOME" .
```

## Implementation Steps

1. Create `install.sh` in repository root
2. Add executable permission: `chmod +x install.sh`
3. Update README.md to reference the script
4. Test on a fresh environment (Docker container)

## Files to Create

- `install.sh`

## Files to Modify

- `README.md` (update setup instructions)

## Testing

1. Use Docker test environment: `cd test && docker build -t dotfiles-test .`
2. Run install script in container
3. Verify all symlinks created correctly
4. Test with existing files to verify backup works
