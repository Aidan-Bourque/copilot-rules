#!/bin/bash

# Script to create a GitHub repository for the .github folder

# Set the repository name
REPO_NAME="copilot-rules"
REPO_DIR="/home/aj/Documents/.github"

# Navigate to the directory
cd "$REPO_DIR" || exit 1

# Initialize git if not already initialized
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
fi

# Add all files
echo "Adding files to git..."
git add .

# Commit if there are changes
if git diff --staged --quiet; then
    echo "No changes to commit"
else
    echo "Committing files..."
    git commit -m "Initial commit: Copilot rules and documentation"
fi

# Create GitHub repository (private)
echo "Creating GitHub repository: $REPO_NAME..."
gh repo create "$REPO_NAME" --private --source=. --remote=origin --push

echo "Done! Repository created and pushed to GitHub."
