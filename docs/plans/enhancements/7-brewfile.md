# Add Brewfile for Dependency Management

## Opportunity
A Brewfile documents all Homebrew dependencies, enabling:

- **Reproducible setup**: `brew bundle` installs everything
- **Documentation**: Clear list of what's needed
- **Version control**: Track dependency changes
- **Cleanup**: `brew bundle cleanup` removes unlisted packages

## Current State

Dependencies are installed ad-hoc or auto-installed by shell config:
- `.zshrc` installs `fzf`, `starship`, `oh-my-posh` if missing
- No central list of required packages

## Proposed Brewfile

Create `Brewfile`:

```ruby
# =============================================================================
# Brewfile - Kevin Hira's Dotfiles Dependencies
# =============================================================================
# Install: brew bundle
# Cleanup: brew bundle cleanup --force
# =============================================================================

# Taps
tap "homebrew/cask-fonts"

# =============================================================================
# CLI Tools
# =============================================================================

# Shell
brew "zsh"
brew "zsh-completions"

# Prompt
brew "starship"
brew "oh-my-posh"

# Search & Navigation
brew "fzf"
brew "ripgrep"
brew "fd"
brew "eza"  # Modern ls replacement

# Git
brew "git"
brew "git-lfs"
brew "gh"  # GitHub CLI

# Development
brew "nvm"
brew "python"

# Utilities
brew "jq"
brew "yq"
brew "htop"
brew "tree"
brew "tldr"
brew "shellcheck"

# =============================================================================
# Applications (Casks)
# =============================================================================

cask "iterm2"
cask "visual-studio-code"

# =============================================================================
# Fonts
# =============================================================================

cask "font-meslo-lg-nerd-font"
cask "font-fira-code-nerd-font"
cask "font-jetbrains-mono-nerd-font"

# =============================================================================
# Optional (uncomment as needed)
# =============================================================================

# brew "tmux"
# brew "neovim"
# brew "go"
# brew "rust"
# cask "docker"
```

### Conditional Brewfiles

For work vs personal machines:

`Brewfile.work`:
```ruby
# Work-specific tools
brew "awscli"
brew "terraform"
cask "slack"
cask "zoom"
```

`Brewfile.personal`:
```ruby
# Personal tools
cask "spotify"
cask "discord"
```

## Bootstrap Integration

Update `install.sh`:

```bash
#!/usr/bin/env bash

# Install Homebrew if needed
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install dependencies
cd "$KDHIRA_DOTFILES"
brew bundle

# Optional: machine-specific
if [[ -f ~/.work-machine ]]; then
    brew bundle --file=Brewfile.work
fi
```

## Implementation Steps

1. Create `Brewfile` in repository root
2. Run `brew bundle dump` to capture current packages (optional starting point)
3. Curate the list to essentials
4. Add to `install.sh` or README
5. Create optional `Brewfile.work` / `Brewfile.personal`

## Files to Create

- `Brewfile`
- `Brewfile.work` (optional)
- `Brewfile.personal` (optional)

## Files to Modify

- `install.sh` (add brew bundle step)
- `README.md` (document Brewfile usage)

## Testing

1. Review current packages: `brew leaves`
2. Create initial Brewfile: `brew bundle dump`
3. Edit to include only essential packages
4. Test on fresh system:
   ```bash
   brew bundle
   brew bundle check  # Verify all installed
   ```

## Maintenance Commands

```bash
# Install all
brew bundle

# Check what's missing
brew bundle check

# Install missing only
brew bundle install

# Remove packages not in Brewfile
brew bundle cleanup --force

# Update Brewfile from current state
brew bundle dump --force
```
