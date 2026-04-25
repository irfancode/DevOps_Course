# Git Commands Quick Reference

## Quick Reference Card

### Essential Commands

| Command | Description |
|---------|-------------|
| `git init` | Initialize a new repository |
| `git clone URL` | Clone an existing repository |
| `git status` | Check current status |
| `git add FILE` | Stage a file |
| `git commit -m "MSG"` | Commit staged changes |
| `git push` | Push to remote |
| `git pull` | Pull from remote |

### Branching Commands

| Command | Description |
|---------|-------------|
| `git branch` | List branches |
| `git branch NAME` | Create branch |
| `git checkout NAME` | Switch to branch |
| `git checkout -b NAME` | Create and switch |
| `git merge NAME` | Merge branch into current |
| `git branch -d NAME` | Delete branch |

### Viewing History

| Command | Description |
|---------|-------------|
| `git log` | Full commit history |
| `git log --oneline` | Compact history |
| `git log -n 5` | Last 5 commits |
| `git log --graph` | Visual graph |
| `git log --stat` | With file changes |
| `git diff` | See unstanged changes |
| `git diff --staged` | See staged changes |

### Remote Commands

| Command | Description |
|---------|-------------|
| `git remote -v` | List remotes |
| `git remote add NAME URL` | Add remote |
| `git push -u origin main` | Push with upstream |
| `git fetch` | Fetch without merging |
| `git stash` | Stash changes |

## Cheat Sheet (Copy-Paste)

```bash
#!/bin/bash
# Git Quick Start

# New project
mkdir myproject && cd myproject
git init
git add README.md
git commit -m "Initial commit"
git remote add origin https://github.com/user/repo.git
git push -u origin main

# Daily commands
git status          # Check status
git add .           # Stage all
git commit -m "Update"  # Commit
git push            # Push

# Branch workflow
git checkout -b feature-name
# ... work on feature ...
git add .
git commit -m "Add feature"
git push origin feature-name
git checkout main
git merge feature-name
git push main
```

## Common Workflows

### Feature Branch Workflow
```bash
git checkout main
git pull origin main
git checkout -b feature/my-feature
# ... make changes ...
git add .
git commit -m "Implement feature"
git push origin feature/my-feature
# Create PR on GitHub
```

### Hotfix Workflow
```bash
git checkout main
git pull origin main
git checkout -b hotfix/bug-fix
# ... fix the bug ...
git add .
git commit -m "Fix critical bug"
git checkout main
git merge hotfix/bug-fix
git push origin main
git branch -d hotfix/bug-fix
```

## Git Ignore Examples

```gitignore
# Compiled files
*.class
*.o
*.pyc

# Dependencies
node_modules/
venv/
.env

# IDE
.vscode/
.idea/
*.swp

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Build outputs
dist/
build/
target/
```

## SSH Key Setup

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub | pbcopy  # macOS
cat ~/.ssh/id_ed25519.pub | xclip  # Linux

# Test connection
ssh -T git@github.com
```

## Tags

```bash
git tag                    # List tags
git tag v1.0.0            # Create lightweight tag
git tag -a v1.0.0 -m "Release"  # Annotated tag
git push origin v1.0.0    # Push tag
git push origin --tags    # Push all tags
```

## Advanced Git

```bash
# Interactive staging
git add -i

# Rebase (rewrite history - be careful!)
git rebase main
git rebase -i HEAD~3

# Cherry-pick commits
git cherry-pick abc123

# Bisect (find bugs)
git bisect start
git bisect bad
git bisect good abc123
git bisect reset
```

---

**← [Back to Module 1](./README.md)** | **[Next: Branching & Merging →](./branching.md)**