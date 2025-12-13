# Add Git Hooks

## Opportunity
Git hooks automate quality checks and enforce standards:

- **Pre-commit**: Lint, format, validate before committing
- **Commit-msg**: Enforce commit message format
- **Pre-push**: Run tests before pushing

## Proposed Setup

### Directory Structure

```
.githooks/
├── pre-commit
├── commit-msg
└── pre-push
```

### Pre-commit Hook

`.githooks/pre-commit`:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Running pre-commit checks..."

# ShellCheck on shell files
if command -v shellcheck &>/dev/null; then
    echo "  ShellCheck..."
    shellcheck zshrc.d/*.sh scripts/* 2>/dev/null || {
        echo "❌ ShellCheck failed"
        exit 1
    }
    echo "  ✓ ShellCheck passed"
fi

# Validate TOML files
if command -v python3 &>/dev/null; then
    echo "  Validating TOML..."
    python3 -c "import tomllib; tomllib.load(open('oh-my-posh/omp.toml', 'rb'))" || {
        echo "❌ Invalid TOML: oh-my-posh/omp.toml"
        exit 1
    }
    python3 -c "import tomllib; tomllib.load(open('starship/starship.toml', 'rb'))" || {
        echo "❌ Invalid TOML: starship/starship.toml"
        exit 1
    }
    echo "  ✓ TOML valid"
fi

# Check for secrets
echo "  Checking for secrets..."
if git diff --cached --name-only | xargs grep -l -E "(password|secret|api_key|token).*=" 2>/dev/null; then
    echo "⚠️  Warning: Possible secrets detected. Review carefully."
fi

echo "✓ Pre-commit checks passed"
```

### Commit Message Hook

`.githooks/commit-msg`:

```bash
#!/usr/bin/env bash

# Enforce conventional commit format (optional)
# Format: type: description
# Types: feat, fix, docs, style, refactor, test, chore

commit_msg=$(cat "$1")

# At minimum, ensure message isn't empty
if [[ -z "$commit_msg" ]]; then
    echo "❌ Commit message cannot be empty"
    exit 1
fi

# Optional: Enforce conventional commits
# if ! echo "$commit_msg" | grep -qE "^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+"; then
#     echo "❌ Commit message must follow conventional commits format"
#     echo "   Example: feat: add new feature"
#     echo "   Example: fix(shell): resolve zsh compatibility"
#     exit 1
# fi

# Warn if message is too short
if [[ ${#commit_msg} -lt 10 ]]; then
    echo "⚠️  Warning: Commit message is very short"
fi
```

### Pre-push Hook

`.githooks/pre-push`:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Running pre-push checks..."

# Run test script if it exists
if [[ -x test/run-tests.sh ]]; then
    echo "  Running tests..."
    ./test/run-tests.sh || {
        echo "❌ Tests failed"
        exit 1
    }
fi

# Prevent pushing to main without review (optional)
protected_branch="main"
current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ "$current_branch" == "$protected_branch" ]]; then
    echo "⚠️  Pushing directly to $protected_branch"
    read -p "Are you sure? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "✓ Pre-push checks passed"
```

## Commit Message Template

Create `.gitmessage`:

```
# <type>: <description>
#
# [optional body]
#
# [optional footer]
#
# Types:
#   feat     - New feature
#   fix      - Bug fix
#   docs     - Documentation
#   style    - Formatting
#   refactor - Code restructuring
#   test     - Tests
#   chore    - Maintenance
```

Update `.gitconfig`:

```gitconfig
[commit]
    template = ~/.gitmessage
```

## Installation

Add to `install.sh`:

```bash
# Enable custom hooks
git config core.hooksPath .githooks
chmod +x .githooks/*
```

Or add to `.gitconfig`:

```gitconfig
[core]
    hooksPath = ~/dotfiles/.githooks
```

## Implementation Steps

1. Create `.githooks/` directory
2. Create hook scripts with executable permission
3. Create `.gitmessage` template
4. Add `core.hooksPath` to `.gitconfig`
5. Update `install.sh` to set up hooks
6. Document in README

## Files to Create

- `.githooks/pre-commit`
- `.githooks/commit-msg`
- `.githooks/pre-push`
- `.gitmessage`

## Files to Modify

- `.gitconfig` (add hooks path and commit template)
- `install.sh` (set up hooks)
- `README.md` (document hooks)

## Testing

1. Set hooks path: `git config core.hooksPath .githooks`
2. Make executable: `chmod +x .githooks/*`
3. Make a test commit
4. Verify pre-commit runs
5. Test with intentional failures (bad shellcheck, empty message)
