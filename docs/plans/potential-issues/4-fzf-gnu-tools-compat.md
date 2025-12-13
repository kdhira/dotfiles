# Fix FZF Preview GNU Tools Compatibility

## Problem
The fzf-tab preview commands use `ls --color` which requires GNU coreutils. On a fresh macOS without GNU tools installed, the BSD `ls` doesn't support `--color` flag (it uses `-G` instead).

## Current State

**File:** `zshrc.d/zinit.zsh` (lines 49-51)

```zsh
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color $realpath'
```

## Proposed Solution

Detect which `ls` is available and use appropriate flags:

### Option A: Use a Wrapper Function

```zsh
# Portable ls with colors
_fzf_ls() {
    if ls --color=auto / &>/dev/null; then
        ls --color=always "$@"
    else
        CLICOLOR_FORCE=1 ls -G "$@"
    fi
}

zstyle ':fzf-tab:complete:cd:*' fzf-preview '_fzf_ls $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview '_fzf_ls $realpath'
```

### Option B: Use eza/exa (Modern Alternative)

```zsh
if command -v eza &>/dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
elif command -v exa &>/dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:ls:*' fzf-preview 'exa -1 --color=always $realpath'
else
    # Fallback - try GNU first, then BSD
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath 2>/dev/null || CLICOLOR_FORCE=1 ls -G $realpath'
    zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color $realpath 2>/dev/null || CLICOLOR_FORCE=1 ls -G $realpath'
fi
```

### Option C: Inline Detection

```zsh
# Detect ls flavor once
if ls --color=auto / &>/dev/null 2>&1; then
    _LS_COLOR_FLAG='--color'
else
    _LS_COLOR_FLAG='-G'
fi

zstyle ':fzf-tab:complete:cd:*' fzf-preview "ls $_LS_COLOR_FLAG \$realpath"
```

## Implementation Steps

1. Choose approach (recommend Option B for modern tooling or Option C for simplicity)
2. Edit `zshrc.d/zinit.zsh`
3. Replace hardcoded `ls --color` with portable version
4. Test on both macOS (BSD) and Linux (GNU)

## Files to Modify

- `zshrc.d/zinit.zsh`

## Testing

1. On macOS without coreutils:
   ```bash
   brew uninstall coreutils  # temporarily
   source ~/.zshrc
   cd <TAB>  # Verify preview works
   ```

2. On Linux:
   ```bash
   source ~/.zshrc
   cd <TAB>  # Verify preview works
   ```

3. Restore coreutils if needed: `brew install coreutils`
