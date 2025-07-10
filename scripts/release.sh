#!/bin/bash

# LDR Gotchi Release Script
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 1.0.0

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION="$1"
TAG="v$VERSION"

echo "Creating release for version $VERSION..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Commit all changes first
echo "Committing all changes before release..."
git add .
git commit -m "chore: pre-release changes" || true

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Error: You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

# Update version in pubspec.yaml
echo "Updating version in pubspec.yaml..."
sed -i "s/version: .*/version: $VERSION+1/" pubspec.yaml

# Commit version update
git add pubspec.yaml
git commit -m "Bump version to $VERSION"

# Create and push tag
echo "Creating tag $TAG..."
git tag -a "$TAG" -m "Release $VERSION"

echo "Pushing to origin..."
git push origin main
git push origin "$TAG"

echo ""
echo "✅ Release $VERSION created successfully!"
echo ""
echo "GitHub Actions will now:"
echo "1. Build the APK automatically"
echo "2. Create a GitHub release"
echo "3. Upload the APK to the release"
echo ""
echo "Check the Actions tab in your GitHub repository to monitor progress."
echo "Release will be available at: https://github.com/[YOUR-USERNAME]/llm_gotchi/releases/tag/$TAG" 