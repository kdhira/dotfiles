# Improve Test Setup

## Problem
The current test setup is basic:
- Only a `test/zshrc` file exists
- No automated CI/CD
- No shell script linting
- No validation that configs are syntactically correct

## Current State

**Directory:** `test/`
```
test/
└── zshrc        # Minimal test zshrc
```

## Proposed Solution

Implement comprehensive testing with GitHub Actions:

### 1. ShellCheck Linting

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
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run ShellCheck
        uses: ludeeus/action-shellcheck@master
        with:
          scandir: './zshrc.d'
          additional_files: '.zshrc install.sh'
```

### 2. Syntax Validation

Add a job to validate configs parse correctly:

```yaml
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate TOML configs
        run: |
          pip install toml
          python -c "import toml; toml.load('oh-my-posh/omp.toml')"
          python -c "import toml; toml.load('starship/starship.toml')"

      - name: Validate vim syntax
        run: |
          vim -u .vimrc -c 'quit' 2>&1 | grep -i error && exit 1 || true
```

### 3. Docker Integration Test

Enhance `test/Dockerfile`:

```dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    zsh \
    git \
    curl \
    vim

WORKDIR /dotfiles
COPY . .

# Test shell configs load without error
RUN zsh -c 'source test/zshrc && echo "ZSH OK"'

# Test vimrc loads
RUN vim -u .vimrc -c 'PlugInstall --sync' -c 'quit' -c 'quit'
```

### 4. Local Test Script

Create `test/run-tests.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== Running ShellCheck ==="
shellcheck zshrc.d/*.sh .zshrc

echo "=== Validating TOML ==="
python3 -c "import toml; toml.load('oh-my-posh/omp.toml')"
python3 -c "import toml; toml.load('starship/starship.toml')"

echo "=== All tests passed ==="
```

## Implementation Steps

1. Create `.github/workflows/lint.yml`
2. Create `test/Dockerfile` (or enhance existing)
3. Create `test/run-tests.sh` for local testing
4. Add required dependencies to README
5. Add status badge to README

## Files to Create

- `.github/workflows/lint.yml`
- `test/Dockerfile`
- `test/run-tests.sh`

## Files to Modify

- `README.md` (add CI badge, testing instructions)

## Testing

1. Run locally: `./test/run-tests.sh`
2. Push to GitHub and verify Actions pass
3. Introduce an error and verify it's caught
