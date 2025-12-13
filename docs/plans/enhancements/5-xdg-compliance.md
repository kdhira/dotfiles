# XDG Base Directory Compliance

## Opportunity
The XDG Base Directory Specification provides a standard for where configuration, data, and cache files should be stored. Benefits:

- Cleaner home directory (fewer dotfiles)
- Easier backup (just backup `~/.config`)
- Better organization
- Industry standard

## Current State

Traditional dotfile locations:
- `~/.vimrc`
- `~/.gitconfig`
- `~/.zshrc`

## XDG Directories

| Variable | Default | Purpose |
|----------|---------|---------|
| `$XDG_CONFIG_HOME` | `~/.config` | User configuration |
| `$XDG_DATA_HOME` | `~/.local/share` | User data |
| `$XDG_CACHE_HOME` | `~/.cache` | Non-essential cache |
| `$XDG_STATE_HOME` | `~/.local/state` | Persistent state |

## Migration Plan

### Git (supports XDG)

```bash
# Move config
mkdir -p ~/.config/git
mv ~/.gitconfig ~/.config/git/config
mv ~/.gitexcludes ~/.config/git/ignore
```

No symlink needed - Git checks `~/.config/git/config` automatically.

### Vim (partial XDG support)

Create `~/.config/vim/vimrc`:

```vim
" Set XDG paths
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)
set viewdir=$XDG_DATA_HOME/vim/view | call mkdir(&viewdir, 'p', 0700)
set backupdir=$XDG_CACHE_HOME/vim/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$XDG_CACHE_HOME/vim/swap   | call mkdir(&directory, 'p', 0700)
set undodir=$XDG_CACHE_HOME/vim/undo     | call mkdir(&undodir, 'p', 0700)

" Source the rest of config
source $XDG_CONFIG_HOME/vim/vimrc.conf
```

Add to `~/.zshenv`:
```zsh
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
```

### Zsh (ZDOTDIR)

In `~/.zshenv` (this file must stay in home):
```zsh
export ZDOTDIR="$HOME/.config/zsh"
```

Then move:
```bash
mkdir -p ~/.config/zsh
mv ~/.zshrc ~/.config/zsh/.zshrc
mv ~/.zshrc.d ~/.config/zsh/zshrc.d
```

### Recommended Structure

```
~/.config/
├── git/
│   ├── config          # Main git config
│   └── ignore          # Global gitignore
├── vim/
│   ├── vimrc           # Bootstrap (sets paths)
│   └── vimrc.conf      # Main config
├── zsh/
│   ├── .zshrc
│   └── zshrc.d/
├── oh-my-posh/
│   └── omp.toml
└── starship.toml
```

## Implementation Steps

1. Set XDG variables in `~/.zshenv`:
   ```zsh
   export XDG_CONFIG_HOME="$HOME/.config"
   export XDG_DATA_HOME="$HOME/.local/share"
   export XDG_CACHE_HOME="$HOME/.cache"
   export XDG_STATE_HOME="$HOME/.local/state"
   ```

2. Migrate git config (easiest, fully supported)
3. Migrate zsh with ZDOTDIR
4. Migrate vim (more complex)
5. Update bootstrap script for new locations

## Files to Create

- `~/.zshenv` (XDG exports + ZDOTDIR)

## Files to Modify

- `.vimrc` (XDG path handling)
- `install.sh` (new symlink locations)
- `README.md` (updated paths)

## Testing

1. Back up existing configs
2. Apply migrations one at a time
3. Open new shell after each change
4. Verify tools still work
5. Check `ls -la ~` is cleaner

## Rollback

Keep symlinks from old locations temporarily:
```bash
ln -s ~/.config/git/config ~/.gitconfig
```

Remove after confirming everything works.
