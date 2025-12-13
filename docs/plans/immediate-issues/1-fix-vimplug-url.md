# Fix vim-plug Installation URL

## Problem
The vim-plug auto-installation in `.vimrc` uses the legacy domain `raw.github.com` instead of the current `raw.githubusercontent.com`.

While this still works via redirect, it:
- Adds latency from the redirect
- May break if GitHub deprecates the old domain
- Doesn't follow current best practices

## Current State

**File:** `.vimrc` (line 23)

```vim
execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
```

## Proposed Solution

Update to use the current GitHub raw content URL:

```vim
execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

## Implementation Steps

1. Edit `.vimrc` line 23
2. Change `raw.github.com` to `raw.githubusercontent.com`

## Files to Modify

- `.vimrc`

## Testing

1. Remove existing vim-plug: `rm ~/.vim/autoload/plug.vim`
2. Open vim: `vim`
3. Verify plug.vim is downloaded without redirect warnings
4. Run `:PlugInstall` to confirm plugins install correctly
