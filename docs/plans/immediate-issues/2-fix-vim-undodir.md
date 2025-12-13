# Fix Vim Undo Directory Location

## Problem
The vim undo directory is set to `/tmp`, which has several issues:

1. **Data loss**: Undo history is cleared on system restart
2. **Privacy**: On multi-user systems, `/tmp` may be readable by others
3. **Inconsistency**: Different behavior across machines and OS versions

## Current State

**File:** `.vimrc` (lines 111-114)

```vim
if exists("&undodir")
    set undofile
    set undodir=/tmp
endif
```

## Proposed Solution

Use a user-specific directory that persists across restarts:

```vim
if exists("&undodir")
    set undofile
    let s:undodir = expand('~/.vim/undo')
    if !isdirectory(s:undodir)
        call mkdir(s:undodir, 'p', 0700)
    endif
    let &undodir = s:undodir
endif
```

This:
- Creates `~/.vim/undo/` if it doesn't exist
- Sets restrictive permissions (0700)
- Persists undo history across sessions

## Alternative: XDG-Compliant Location

For better organization following XDG spec:

```vim
let s:undodir = expand($XDG_DATA_HOME ?? '~/.local/share') . '/vim/undo'
```

## Implementation Steps

1. Edit `.vimrc` lines 111-114
2. Replace hardcoded `/tmp` with dynamic directory creation
3. Optionally add `~/.vim/undo/` to `.gitignore` if backing up vim config

## Files to Modify

- `.vimrc`

## Testing

1. Start vim and make some edits to a file
2. Save and close the file
3. Verify undo files exist: `ls -la ~/.vim/undo/`
4. Reopen the file and verify `u` (undo) still works
5. Reboot machine and verify undo history persists
