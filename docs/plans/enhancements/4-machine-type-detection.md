# Add Machine Type Detection

## Opportunity
Automatically detect machine type (work vs personal, laptop vs server) to apply appropriate configurations without manual per-machine setup files.

Use cases:
- Different git email for work vs personal
- Different GPG signing key
- Work-specific aliases or tools
- Different prompt indicators

## Current State

Uses per-machine override files:
- `~/.gitconfig-user` - Included from `.gitconfig`
- `~/.zshrc-user` - Sourced from `.zshrc`

These must be manually created on each machine.

## Proposed Solution

### Detection Strategies

**Option A: Hostname Pattern Matching**
```zsh
# zshrc.d/machine-type.sh

detect_machine_type() {
    local hostname=$(hostname)

    case "$hostname" in
        *-work-*|*work*|*corp*)
            export MACHINE_TYPE="work"
            ;;
        *-personal-*|*macbook*|*home*)
            export MACHINE_TYPE="personal"
            ;;
        *)
            export MACHINE_TYPE="unknown"
            ;;
    esac
}
```

**Option B: Marker File**
```zsh
# Check for marker files
if [[ -f ~/.work-machine ]]; then
    export MACHINE_TYPE="work"
elif [[ -f ~/.personal-machine ]]; then
    export MACHINE_TYPE="personal"
else
    export MACHINE_TYPE="unknown"
fi
```

**Option C: Environment Variable (set in ~/.zshenv)**
```zsh
# ~/.zshenv on work machine
export MACHINE_TYPE="work"
```

### Apply Configuration Based on Type

```zsh
# zshrc.d/machine-type.sh

apply_machine_config() {
    case "$MACHINE_TYPE" in
        work)
            export GIT_AUTHOR_EMAIL="kevin@company.com"
            export GIT_COMMITTER_EMAIL="kevin@company.com"
            alias vpn='networksetup -connectpppoeservice "Work VPN"'
            ;;
        personal)
            export GIT_AUTHOR_EMAIL="kevin@personal.com"
            export GIT_COMMITTER_EMAIL="kevin@personal.com"
            ;;
    esac
}

detect_machine_type
apply_machine_config
```

### Git Configuration with Includes

```gitconfig
# .gitconfig
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work

[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
```

This uses directory-based detection - work repos in `~/work/`, personal in `~/personal/`.

## Implementation Steps

1. Choose detection strategy (recommend Option B + C hybrid)
2. Create `zshrc.d/machine-type.sh`
3. Source it early in `.zshrc`
4. Migrate settings from `~/.zshrc-user` to machine-type conditions
5. Document how to set machine type on new machines

## Files to Create

- `zshrc.d/machine-type.sh`
- `.gitconfig-work` (template)
- `.gitconfig-personal` (template)

## Files to Modify

- `.zshrc` (source machine-type.sh)
- `.gitconfig` (add includeIf directives)
- `README.md` (document machine type setup)

## Testing

1. Set machine type: `touch ~/.work-machine`
2. Open new shell
3. Verify `echo $MACHINE_TYPE` returns "work"
4. Verify work-specific settings are applied
5. Test with `~/.personal-machine` marker

## Prompt Indicator

Add machine type to prompt for visibility:

```toml
# oh-my-posh/omp.toml
[[blocks]]
  type = "segment"
  style = "plain"
  template = "{{ if eq .Env.MACHINE_TYPE \"work\" }}🏢{{ else }}🏠{{ end }}"
```
