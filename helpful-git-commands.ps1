# Git: Initialize a new Git repository
git init

# Git: Clone an existing repository
git clone <repository-url>

# Git: Check the current status
git status

# Git: Add files to staging area
git add <file>
git add .

# Git: Commit changes
git commit -m "Your commit message"

# Git: View commit history
git log
git log --oneline

# Git: Create a new branch
git checkout -b <branch-name>

# Git: Switch between branches
git checkout <branch-name>

# Git: List all branches
git branch

# Git: Merge a branch into the current branch
git merge <branch-name>

# Git: Delete a branch
git branch -d <branch-name>

# Git: Push local changes to a remote repository
git push origin <branch-name>

# Git: Pull changes from a remote repository
git pull origin <branch-name>

# Git: Fetch changes from a remote repository without merging
git fetch origin

# Git: Set a remote URL
git remote add origin <repository-url>

# Git: Discard local changes
git checkout -- <file>

# Git: Remove a file from staging area
git reset <file>

# Git: Undo the last commit
git reset --soft HEAD~1

# Git: Reset a branch to a previous state
git reset --hard <commit-hash>

# Git: Stash uncommitted changes
git stash

# Git: Apply stashed changes
git stash apply

# Git: List all stashes
git stash list

# Git: Create a new tag
git tag <tag-name>

# Git: List all tags
git tag

# Git: Push a tag to remote repository
git push origin <tag-name>

# Git: View changes between commits
git diff <commit1> <commit2>

# Git: Show changes in the working directory
git diff

# Git: Show a specific commit
git show <commit-hash>

# Git: Show remote repositories
git remote -v

# Git: Rename a remote
git remote rename <old-name> <new-name>

# Git: Remove a remote
git remote remove <remote-name>
