# Fix Environment Variable Typo

## Problem
The environment variable `KDHIRA_ZSH_PLUGIN_MANGER` is missing an 'A' - should be `KDHIRA_ZSH_PLUGIN_MANAGER`.

This typo:
- Creates confusion when referencing the variable
- May cause issues if documented or used elsewhere
- Looks unprofessional

## Current State

**File:** `.zshrc` (line 18)
```zsh
KDHIRA_ZSH_PLUGIN_MANGER=${KDHIRA_ZSH_PLUGIN_MANGER:-zinit}
```

**File:** `.zshrc` (lines 29-30)
```zsh
[ "$KDHIRA_ZSH_PLUGIN_MANGER" = "zinit" ] && source $KDHIRA_DOTFILES/zshrc.d/zinit.zsh
[ "$KDHIRA_ZSH_PLUGIN_MANGER" = "ohmyzsh" ] && source $KDHIRA_DOTFILES/zshrc.d/ohmyzsh.zsh
```

## Proposed Solution

Rename all occurrences to `KDHIRA_ZSH_PLUGIN_MANAGER` (with 'A'):

```zsh
KDHIRA_ZSH_PLUGIN_MANAGER=${KDHIRA_ZSH_PLUGIN_MANAGER:-zinit}
```

## Implementation Steps

1. Edit `.zshrc`
2. Find and replace all occurrences of `KDHIRA_ZSH_PLUGIN_MANGER` with `KDHIRA_ZSH_PLUGIN_MANAGER`
3. Update any documentation (README.md) if the variable is mentioned
4. Update `~/.zshenv` on any machines where this variable is set

## Files to Modify

- `.zshrc` (3 occurrences)
- README.md (if variable is documented)
- Personal `~/.zshenv` files (on each machine)

## Testing

1. Source the updated `.zshrc`: `source ~/.zshrc`
2. Verify plugin manager loads correctly
3. Test switching plugin managers:
   ```bash
   export KDHIRA_ZSH_PLUGIN_MANAGER=ohmyzsh
   source ~/.zshrc
   ```
4. Confirm no errors about undefined variables

## Migration Note

If you have `KDHIRA_ZSH_PLUGIN_MANGER` set in `~/.zshenv` on any machines, you'll need to update those files as well. Consider adding a temporary compatibility shim:

```zsh
# Temporary backward compatibility (remove after all machines updated)
KDHIRA_ZSH_PLUGIN_MANAGER=${KDHIRA_ZSH_PLUGIN_MANAGER:-$KDHIRA_ZSH_PLUGIN_MANGER}
```
