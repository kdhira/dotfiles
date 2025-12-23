# Add Conditional/Lazy Tool Loading

## Opportunity
Lazy-loading heavy tools improves shell startup time by deferring initialization until the tool is actually used. This is especially valuable for:
- NVM (Node Version Manager) - notoriously slow
- rbenv, pyenv, other version managers
- Cloud CLIs (aws, gcloud, az)

## Current State

**File:** `.zshrc` (lines 60-62)

```zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
```

NVM is loaded on every shell startup, even when not needed.

## Proposed Solution

### Lazy-Load Pattern

```zsh
# Lazy-load NVM - only loads when nvm/node/npm/npx is called
nvm() {
    unset -f nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
    nvm "$@"
}

node() {
    unset -f nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    node "$@"
}

npm() {
    unset -f nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    npm "$@"
}

npx() {
    unset -f nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    npx "$@"
}
```

### Helper Function Approach

Create a reusable lazy-loader:

```zsh
# zshrc.d/lazy-load.sh

# Usage: lazy_load <init_command> <commands...>
lazy_load() {
    local init_cmd="$1"
    shift
    local cmds=("$@")

    for cmd in "${cmds[@]}"; do
        eval "${cmd}() {
            unset -f ${cmds[*]}
            ${init_cmd}
            ${cmd} \"\$@\"
        }"
    done
}

# Example usage:
lazy_load 'source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"' nvm node npm npx
lazy_load 'eval "$(rbenv init -)"' rbenv ruby gem bundle
lazy_load 'source /opt/google-cloud-sdk/path.zsh.inc' gcloud gsutil bq
```

### Using zinit's Lazy Loading

If using zinit, leverage its built-in lazy loading:

```zsh
# Load NVM only when nvm command is used
zinit ice wait lucid
zinit light lukechilds/zsh-nvm
```

## Benchmark

Measure improvement:

```bash
# Before
time zsh -i -c exit

# After
time zsh -i -c exit
```

Typical improvement: 200-500ms faster startup.

## Implementation Steps

1. Create `zshrc.d/lazy-load.sh` with helper function
2. Modify `.zshrc` to use lazy loading for NVM
3. Identify other slow-loading tools (run `zprof`)
4. Apply lazy loading to identified tools
5. Benchmark before/after

## Files to Create

- `zshrc.d/lazy-load.sh`

## Files to Modify

- `.zshrc` (change NVM loading)
- `zshrc.d/zinit.zsh` (if using zinit lazy loading)

## Testing

1. Enable zsh profiling:
   ```zsh
   # Add to top of .zshrc
   zmodload zsh/zprof
   # Add to bottom
   zprof
   ```

2. Open new shell, review timing
3. Verify `nvm`, `node`, `npm` still work correctly
4. Verify shell startup is faster
