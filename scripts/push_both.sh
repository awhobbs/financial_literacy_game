#!/bin/bash
# Push current branch to both repositories
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Pushing branch '$BRANCH' to origin (nathalienyanga)..."
git push origin "$BRANCH"
echo "Pushing branch '$BRANCH' to theirs (awhobbs)..."
git push theirs "$BRANCH"
echo "Done."