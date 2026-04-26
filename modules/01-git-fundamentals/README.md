# Module 1: Git & Version Control

## Learning Objectives

By the end of this module, you will:
- ✅ Understand what version control is and why it matters
- ✅ Install and configure Git on your machine
- ✅ Use basic Git commands to track changes
- ✅ Create and manage branches
- ✅ Collaborate with others using GitHub

## What is Version Control?

**Version Control** is a system that records changes to files over time so you can recall specific versions later. Think of it as a time machine for your code!

### Why Version Control?

```
Without Version Control          With Version Control
─────────────────────          ────────────────────
❌ final.txt                   ✅ Git tracks everything
❌ final_FINAL.txt             ✅ Easy to undo mistakes
❌ final_FINAL_v2.txt          ✅ Work on multiple features
❌ final_FINAL_v2_REALLY.txt    ✅ Collaborate with others
❌ final_backup.txt
```

## Git vs GitHub

| Term | What it is |
|------|------------|
| **Git** | A version control system (the software) |
| **GitHub** | A cloud platform that hosts Git repositories |

> **Analogy**: Git is like a camera, GitHub is like a photo album where you store your photos online.

## Installing Git

### macOS
```bash
# Using Homebrew (recommended)
brew install git

# Or check if already installed
git --version
```

### Windows
Download from [git-scm.com](https://git-scm.com) - the installer includes Git Bash

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install git
```

## Configuring Git

```bash
# Set your name
git config --global user.name "Your Name"

# Set your email
git config --global user.email "your.email@example.com"

# Set default editor (VS Code)
git config --global core.editor "code --wait"

# Verify your settings
git config --list
```

## The Three States

Git has three main states for your files:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Modified   │ ──▶ │   Staged    │ ──▶ │   Committed │
│             │     │             │     │             │
│  Changed    │     │  Ready to   │     │  Saved in   │
│  but not    │     │  commit     │     │  .git       │
│  tracked    │     │             │     │  directory  │
└─────────────┘     └─────────────┘     └─────────────┘
     Working             Staging           Repository
     Directory          Area             (.git folder)
```

## Your First Git Repository

```bash
# 1. Create a new directory
mkdir my-first-project
cd my-first-project

# 2. Initialize a new Git repository
git init

# 3. Create a file
echo "Hello, Git!" > hello.txt

# 4. Check the status
git status

# 5. Stage the file
git add hello.txt

# 6. Commit the file
git commit -m "Add hello.txt with greeting"

# 7. View the commit history
git log
```

## Essential Git Commands

### Checking Status & History
```bash
git status              # See what's changed
git log                 # View commit history
git log --oneline       # Compact history
git diff                # See unstaged changes
git diff --staged       # See staged changes
```

### Adding & Committing
```bash
git add filename.txt           # Stage single file
git add .                      # Stage all changes
git commit -m "Your message"  # Commit staged changes
git commit -am "Message"       # Add + commit tracked files
```

### Undoing Things
```bash
git checkout -- filename.txt   # Discard changes (dangerous!)
git reset filename.txt        # Unstage a file
git reset HEAD~1              # Undo last commit (keep changes)
git revert HEAD               # Create new commit that undoes last
```

### Working with Remotes
```bash
git remote -v                 # List remotes
git remote add origin URL      # Add remote
git push origin main           # Push to remote
git pull origin main          # Pull from remote
git clone URL                 # Clone repository
```

## Branching Explained

Branches let you work on features without affecting the main code.

```bash
# Create a new branch
git branch feature-login

# Switch to the branch
git checkout feature-login
# OR (newer syntax)
git switch feature-login

# Create AND switch in one command
git checkout -b feature-login

# List all branches
git branch

# Delete a branch
git branch -d feature-login

# Merge branches
git checkout main
git merge feature-login
```

### Visual Branching

```
        feature-login
              │
    ┌─────────┴─────────┐
    │                   │
main ◀───────E───────────F──▶ main
              ▲
              │
         merge commit
```

## GitHub Workflow

```bash
# 1. Create repository on GitHub
# 2. Clone it to your machine
git clone https://github.com/username/repo.git

# 3. Make changes
echo "My changes" > file.txt

# 4. Commit
git add .
git commit -m "Add new feature"

# 5. Push to GitHub
git push origin main

# 6. Create Pull Request on GitHub
# 7. Review and merge!
```

## Pro Tips

### Commit Messages
```
✅ Good: "Add user login functionality"
✅ Good: "Fix bug in payment calculation"
❌ Bad:  "Updated stuff"
❌ Bad:  "Fix"
```

### Command Shortcuts
```bash
alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
```

### Useful Flags
```bash
git log -p                 # Show full diffs
git log --graph            # Visual graph
git log -n 5              # Last 5 commits
git blame filename.txt    # Who changed what
git stash                 # Temporarily hide changes
```

## Common Errors & Solutions

| Error | Solution |
|-------|----------|
| `nothing to commit` | Make changes first, then add |
| `nothing added to commit` | Run `git add` first |
| `branch not found` | Check branch name with `git branch` |
| `merge conflict` | Edit conflicting files, then add & commit |
| `fatal: not a git repo` | Run `git init` or check directory |

## Next Steps

➡️ **[Commands Reference](./commands.md)** - Quick command reference
➡️ **[Branching & Merging](./branching.md)** - Advanced branching
➡️ **[Lab Exercises](./labs/lab-01-git-workout.md)** - Practice with hands-on exercises

---

**Next: [Basic Commands →](./commands.md)