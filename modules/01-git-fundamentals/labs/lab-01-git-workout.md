# Lab 1: Git Workout 🏋️

Time: 30 minutes | Difficulty: Beginner

## Objectives

Practice the fundamental Git operations you've learned:
- Initialize a repository
- Make commits
- Create and merge branches
- Resolve a merge conflict

## Setup

```bash
# Create a new directory for this lab
mkdir ~/git-workout
cd ~/git-workout
```

---

## Exercise 1: Your First Repository (5 min)

**Goal**: Create a Git repo and make your first commits.

### Steps

1. Initialize a new Git repository:
```bash
git init
```

2. Configure Git (if not done globally):
```bash
git config user.email "you@example.com"
git config user.name "Your Name"
```

3. Create a file called `notes.txt`:
```bash
cat > notes.txt << 'EOF'
My DevOps Learning Notes
========================

1. Git is a version control system
2. GitHub hosts repositories online
3. Branches allow parallel development
EOF
```

4. Check the status:
```bash
git status
```

5. Stage and commit:
```bash
git add notes.txt
git commit -m "Add initial notes"
```

### ✅ Verification
Run `git log --oneline` - you should see your commit.

---

## Exercise 2: Making Changes (5 min)

**Goal**: Practice the edit-commit cycle.

### Steps

1. Add a new line to `notes.txt`:
```bash
cat >> notes.txt << 'EOF'

4. Commits track changes
5. Branches enable parallel work
EOF
```

2. Check what changed:
```bash
git diff
```

3. Stage and commit:
```bash
git add notes.txt
git commit -m "Add more learning points"
```

4. Check the log:
```bash
git log --oneline
```

### ✅ Verification
You should see 2 commits now.

---

## Exercise 3: Branching (10 min)

**Goal**: Create a feature branch and make changes.

### Steps

1. Create a new branch:
```bash
git checkout -b add-checklist
```

2. Create a new file `checklist.md`:
```bash
cat > checklist.md << 'EOF'
# DevOps Learning Checklist

- [ ] Learn Git basics
- [ ] Master the command line
- [ ] Understand Docker
- [ ] Build a CI/CD pipeline
- [ ] Deploy to the cloud
EOF
```

3. Stage and commit:
```bash
git add checklist.md
git commit -m "Add learning checklist"
```

4. Switch back to main:
```bash
git checkout main
```

5. List branches:
```bash
git branch
```

6. See the commit on each branch:
```bash
git log main --oneline
git log add-checklist --oneline
```

### ✅ Verification
- Main should have 2 commits
- `add-checklist` should have 3 commits

---

## Exercise 4: Merging (5 min)

**Goal**: Merge your feature branch back to main.

### Steps

1. Switch to main:
```bash
git checkout main
```

2. Merge the feature branch:
```bash
git merge add-checklist
```

3. Clean up (delete the feature branch):
```bash
git branch -d add-checklist
```

4. Verify:
```bash
git log --oneline
ls -la
```

### ✅ Verification
- `checklist.md` should exist in main
- All commits visible in main history

---

## Exercise 5: Merge Conflict (5 min)

**Goal**: Create and resolve a merge conflict.

### Steps

1. Create a new branch:
```bash
git checkout -b conflict-test
```

2. Modify `notes.txt`:
```bash
cat > notes.txt << 'EOF'
My DevOps Learning Notes
========================

Version: 1.0

1. Git is a version control system
2. GitHub hosts repositories online
3. Branches allow parallel development
4. Commits track changes
5. Branches enable parallel work
6. CONFLICT TEST LINE (feature)
EOF
```

3. Commit:
```bash
git add notes.txt
git commit -m "Add conflict test on feature branch"
```

4. Switch to main:
```bash
git checkout main
```

5. Make conflicting changes:
```bash
cat > notes.txt << 'EOF'
My DevOps Learning Notes
========================

Version: 2.0

1. Git is a version control system
2. GitHub hosts repositories online
3. Branches allow parallel development
4. Commits track changes
5. Branches enable parallel work
6. CONFLICT TEST LINE (main)
EOF
```

6. Commit:
```bash
git add notes.txt
git commit -m "Add conflict test on main branch"
```

7. Attempt merge:
```bash
git merge conflict-test
```

### You should see a CONFLICT!

8. View the conflict:
```bash
cat notes.txt
```

9. Fix the conflict - remove the markers and keep the content you want:
```bash
cat > notes.txt << 'EOF'
My DevOps Learning Notes
========================

Version: 3.0 (Merged!)

1. Git is a version control system
2. GitHub hosts repositories online
3. Branches allow parallel development
4. Commits track changes
5. Branches enable parallel work
6. CONFLICT RESOLVED
EOF
```

10. Stage and commit:
```bash
git add notes.txt
git commit -m "Resolve merge conflict"
```

### ✅ Verification
`git log --oneline` should show a merge commit.

---

## Bonus: Clean Up and Push

```bash
# Go to main
git checkout main

# Delete the conflict-test branch
git branch -D conflict-test

# Add a remote (use your own GitHub account or skip)
git remote add origin https://github.com/YOUR_USERNAME/DevOps_Course.git

# Clean up the workout directory
cd ~/git-workout
rm -rf .git
```

---

## Summary Commands

```bash
# Quick recap - run these anytime
git status              # Check status
git log --oneline      # View history
git branch             # List branches
git diff               # See changes
```

---

**Lab Complete! 🎉**

Next: [Module 2: Linux Essentials](../02-linux-essentials/README.md)