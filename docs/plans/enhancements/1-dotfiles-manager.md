# Adopt a Dotfiles Manager

## Opportunity
Using a dedicated dotfiles manager provides significant advantages over manual symlink management:

- **Templates**: Machine-specific values without separate files
- **Encrypted secrets**: Safely store sensitive configs in git
- **Atomic updates**: Rollback capability if something breaks
- **Cross-platform**: Better handling of OS differences

## Current State

Manual symlink-based setup documented in README.md with per-machine override files (`~/.zshrc-user`, `~/.gitconfig-user`).

## Options Comparison

### Option A: chezmoi (Recommended)

**Pros:**
- Most feature-rich
- Built-in templates (Go templates)
- Encrypted secrets with age/gpg
- Supports 1Password, Bitwarden integration
- `chezmoi diff` shows what would change
- Active development

**Cons:**
- Learning curve for templates
- Requires chezmoi binary on each machine

**Example migration:**
```bash
# Initialize
chezmoi init

# Add files (creates ~/.local/share/chezmoi/)
chezmoi add ~/.vimrc
chezmoi add ~/.zshrc

# Template example for machine-specific config
# ~/.local/share/chezmoi/dot_gitconfig.tmpl
[user]
    name = Kevin Hira
{{- if eq .chezmoi.hostname "work-laptop" }}
    email = kevin@work.com
{{- else }}
    email = kevin@personal.com
{{- end }}
```

### Option B: GNU Stow

**Pros:**
- Simple symlink manager
- No learning curve
- Already installed on most systems
- Just works with existing structure

**Cons:**
- No templating
- No secret management
- Minimal features

**Example:**
```bash
cd ~/dotfiles
stow -v -t ~ .
```

### Option C: yadm

**Pros:**
- Git wrapper (familiar commands)
- Supports alternate files per host/OS
- Bootstrap script support
- Encrypted files with GPG

**Cons:**
- Less flexible than chezmoi
- Smaller community

## Implementation Steps (for chezmoi)

1. Install chezmoi: `brew install chezmoi`
2. Initialize: `chezmoi init`
3. Add existing dotfiles:
   ```bash
   chezmoi add ~/.vimrc
   chezmoi add ~/.zshrc
   chezmoi add ~/.gitconfig
   chezmoi add -r ~/dotfiles/zshrc.d
   ```
4. Convert machine-specific files to templates
5. Test: `chezmoi diff` then `chezmoi apply`
6. Push to git: `chezmoi cd && git push`

## Migration Path

1. Keep current repo structure initially
2. Add chezmoi config alongside
3. Gradually convert files to chezmoi management
4. Eventually deprecate manual symlink instructions

## Files to Create

- `.chezmoi.toml.tmpl` (chezmoi config template)
- Convert `~/.gitconfig-user` pattern to templates

## Files to Modify

- `README.md` (update setup instructions)
- `.gitconfig` (convert to template)

## Testing

1. Test on a fresh VM or Docker container
2. Verify `chezmoi init --apply` sets everything up
3. Test on different "machine types" to verify templates
