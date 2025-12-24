# Add Nerd Fonts Fallback

## Problem
The prompt configuration (oh-my-posh) and vim status line use Nerd Font icons. If Nerd Fonts aren't installed, users see broken glyphs (boxes, question marks) with no graceful degradation.

## Current State

**Files using Nerd Font icons:**
- `oh-my-posh/omp.toml` - PowerLine symbols, git icons
- `.vimrc` (lightline) - Status bar may use special characters

## Proposed Solution

### Option A: Detection with Fallback Config

Create a font detection mechanism and alternative configs:

```zsh
# In .zshrc
has_nerd_font() {
    # Check if any Nerd Font is installed
    fc-list 2>/dev/null | grep -qi "nerd" && return 0
    # macOS alternative
    system_profiler SPFontsDataType 2>/dev/null | grep -qi "nerd" && return 0
    return 1
}

if has_nerd_font; then
    OMP_CONFIG="$KDHIRA_DOTFILES/oh-my-posh/omp.toml"
else
    OMP_CONFIG="$KDHIRA_DOTFILES/oh-my-posh/omp-minimal.toml"
fi
```

### Option B: ASCII-Safe Prompt Configs

Create alternative config files:
- `oh-my-posh/omp-minimal.toml` - Uses ASCII characters only

### Option C: Document Requirement + Auto-Install

Add font installation to bootstrap:

```bash
# In install.sh
install_nerd_font() {
    if command -v brew &>/dev/null; then
        brew install --cask font-meslo-lg-nerd-font
    else
        echo "Please install a Nerd Font: https://www.nerdfonts.com/"
    fi
}
```

## Implementation Steps

1. Choose approach (recommend Option C for simplicity)
2. Add font installation to bootstrap script
3. Document font requirement prominently in README
4. Optionally create minimal fallback configs

## Files to Create

- `oh-my-posh/omp-minimal.toml` (if using Option B)

## Files to Modify

- `install.sh` (add font installation)
- `README.md` (document font requirement)
- `.zshrc` (add detection if using Option A)

## Testing

1. Uninstall Nerd Fonts temporarily
2. Source shell config
3. Verify prompt renders without broken characters
4. Reinstall fonts and verify full icons return
