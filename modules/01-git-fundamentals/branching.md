# Branching & Merging

## Understanding Branches

A branch in Git is simply a movable pointer to a commit. The default branch is usually called `main` or `master`.

```
       HEAD
         │
         ▼
main ─── A ─── B ─── C ─── D
                            │
                       feature/login
                            ▼
                         E ─── F
```

### Key Concepts

| Concept | Description |
|---------|-------------|
| **HEAD** | Your current position in the repo |
| **main/master** | The default branch |
| **origin** | The default remote name |
| **tracking** | Link between local and remote branch |

## Creating Branches

### Method 1: Create then switch
```bash
git branch feature-name      # Create
git checkout feature-name    # Switch
```

### Method 2: Create and switch at once
```bash
git checkout -b feature-name
# OR (Git 2.23+)
git switch -c feature-name
```

### Method 3: Based on a specific commit
```bash
git checkout -b feature-name abc1234
```

## Switching Branches

```bash
git checkout main                 # Switch to main
git switch main                   # Same (new syntax)
git checkout -                   # Go back to previous
git switch -                     # Same
```

## Listing Branches

```bash
git branch                 # Local branches
git branch -a              # All (including remote)
git branch -r              # Remote branches
git branch -v              # With last commit
git branch -vv             # With tracking info
```

## Deleting Branches

```bash
git branch -d branch-name     # Safe delete (merged)
git branch -D branch-name     # Force delete (unmerged)
git push origin --delete branch-name  # Delete remote
```

## Comparing Branches

```bash
git log main..feature          # Commits in feature but not main
git diff main..feature        # Changes between branches
git log --graph --all        # Visual branch history
```

## Merging

Merging combines the histories of two branches.

### Fast-Forward Merge

When the main branch hasn't changed:

```
Before:                    After:
main ─── A                 main ─── A ─── B ─── C
              \                                       \\
               B ─── C         feature ─────────► feature
                              (deleted)
```

```bash
git checkout main
git merge feature
# Fast-forward merge happens automatically
```

### Three-Way Merge

When both branches have changes:

```
       main
         │
    A ─── B ─── C
                \
                 \
          feature   D ─── E
```

```bash
git checkout main
git merge feature
# Git creates a merge commit
```

## Merge Conflicts

### What Causes Conflicts?
```
<<<<<<< HEAD
Your changes
=======
Their changes
>>>>>>> feature-branch
```

### Resolving Conflicts

```bash
# 1. Find conflicting files
git status

# 2. Edit the file, remove conflict markers
# 3. Choose which changes to keep

# 4. Stage and commit
git add filename.txt
git commit -m "Resolve merge conflict"
```

### Tools for Conflict Resolution

```bash
git mergetool              # Open merge tool
git merge --abort          # Cancel merge
```

## Rebasing

Rebasing rewrites history by applying commits on a new base.

```
Before:                    After:
main ─── A                 main ─── A ─── B ─── C
              \                                   \
               B ─── C         feature ─────────► feature (B', C')
```

⚠️ **Warning**: Never rebase commits that have been pushed and shared!

```bash
git checkout feature
git rebase main

# Interactive rebase
git rebase -i HEAD~3
```

### Rebase vs Merge

| Rebase | Merge |
|--------|-------|
| Linear history | Preserves history |
| Rewrites commits | Creates merge commit |
| Safer for local | Safe for shared |
| Cleaner log | Accurate chronology |

## Handling Long-Running Branches

```bash
# Update feature with latest main
git checkout feature
git rebase main

# Or use merge
git checkout feature
git merge main
```

## Stashing Changes

Temporarily store uncommitted changes:

```bash
git stash                   # Stash changes
git stash list             # List stashes
git stash pop              # Apply and remove stash
git stash apply            # Apply but keep stash
git stash drop            # Delete stash
git stash -u              # Include untracked files
```

## Cherry-Picking

Apply a specific commit from another branch:

```bash
git cherry-pick abc1234
git cherry-pick abc123..xyz999  # Range
```

## Workflow Patterns

### GitHub Flow (Simple)

```
1. Create branch
2. Make changes
3. Open PR
4. Review
5. Deploy
6. Merge
```

### Git Flow (Complex)

| Branch | Purpose |
|--------|---------|
| main | Production code |
| develop | Development |
| feature/* | New features |
| release/* | Release preparation |
| hotfix/* | Emergency fixes |

```bash
# Starting a feature
git checkout develop
git checkout -b feature/my-feature

# Finishing a feature
git checkout develop
git merge --no-ff feature/my-feature
git branch -d feature/my-feature
```

---

**← [Back to Module 1](./README.md)** | **[← Previous: Commands](./commands.md)**