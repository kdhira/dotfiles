# Add Shell Script Linting

## Opportunity
Automated linting catches common shell script issues:
- Unquoted variables
- Deprecated syntax
- POSIX compatibility issues
- Security vulnerabilities (command injection)

## Current State

No automated linting. Some `shellcheck` directives exist in code (e.g., `# shellcheck disable=SC2068`), indicating awareness but no CI enforcement.

## Proposed Solution

### GitHub Actions Workflow

Create `.github/workflows/lint.yml`:

```yaml
name: Lint

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  shellcheck:
    name: ShellCheck
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run ShellCheck on zshrc.d
        uses: ludeeus/action-shellcheck@master
        with:
          scandir: './zshrc.d'
          severity: warning
          format: gcc

      - name: Run ShellCheck on scripts
        uses: ludeeus/action-shellcheck@master
        with:
          scandir: './scripts'
          severity: warning

      - name: Check main shell files
        run: |
          shellcheck -x .zshrc || true  # zsh-specific syntax may warn
```

### Local Pre-commit Hook

Create `.githooks/pre-commit`:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Running ShellCheck..."
shellcheck zshrc.d/*.sh scripts/* 2>/dev/null || {
    echo "ShellCheck found issues. Fix them before committing."
    exit 1
}

echo "Linting passed!"
```

Enable with:
```bash
git config core.hooksPath .githooks
```

### ShellCheck Configuration

Create `.shellcheckrc`:

```
# Use bash as default shell
shell=bash

# Exclude common false positives for zsh
disable=SC1090  # Can't follow non-constant source
disable=SC1091  # Not following sourced file
disable=SC2034  # Variable appears unused (common in configs)

# Enable optional checks
enable=avoid-nullary-conditions
enable=deprecate-which
enable=quote-safe-variables
```

## Implementation Steps

1. Create `.github/workflows/lint.yml`
2. Create `.shellcheckrc` with appropriate rules
3. Create `.githooks/pre-commit` for local checking
4. Fix any existing issues ShellCheck finds
5. Add README badge for CI status

## Files to Create

- `.github/workflows/lint.yml`
- `.shellcheckrc`
- `.githooks/pre-commit`

## Files to Modify

- `README.md` (add CI badge)
- Various shell files (fix any linting issues)

## Testing

1. Run locally: `shellcheck zshrc.d/*.sh`
2. Push to GitHub
3. Verify Actions workflow runs
4. Intentionally break something to verify it catches issues

## README Badge

```markdown
[![Lint](https://github.com/kdhira/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/kdhira/dotfiles/actions/workflows/lint.yml)
```
