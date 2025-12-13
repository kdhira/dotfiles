# Remove Backup File from Repository

## Problem
`oh-my-posh/omp.toml.bak` is committed to the repository. Backup files should not be tracked in version control because:

- Git history already provides versioning
- Clutters the repository
- The backup is an old version (v3) while current is v4

## Current State

**File:** `oh-my-posh/omp.toml.bak`
- Old version 3 configuration
- Committed to repository

## Proposed Solution

1. Remove the backup file from the repository
2. Add `*.bak` to `.gitignore` to prevent future commits

## Implementation Steps

1. Delete the backup file:
   ```bash
   rm oh-my-posh/omp.toml.bak
   ```

2. Add to `.gitignore`:
   ```
   # Backup files
   *.bak
   *.backup
   *~
   ```

3. Commit the changes:
   ```bash
   git add -A
   git commit -m "Remove backup file, add *.bak to gitignore"
   ```

## Files to Delete

- `oh-my-posh/omp.toml.bak`

## Files to Modify

- `.gitignore` (add backup patterns)

## Testing

1. Verify file is deleted: `ls oh-my-posh/`
2. Create a test backup: `touch test.bak`
3. Verify it's ignored: `git status` should not show `test.bak`
4. Clean up: `rm test.bak`
