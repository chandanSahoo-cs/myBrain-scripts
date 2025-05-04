#!/bin/bash

# Obsidian vault directory
cd "/home/chandan/Obsidian Vaults/Vault/myBrain" || exit 1

# Quit if no changes
git diff --quiet && echo "No changes to commit." && exit 0

# Add all changes
git add .

# Commit
git commit -m "Auto commit on $(date '+%Y-%m-%d %H:%M:%S')"

#Push
git push origin main
