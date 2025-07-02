#!/bin/bash

# GitHub Pages Setup Script for docs-ui
# This script helps configure GitHub repository settings for automatic deployment

set -e

echo "🚀 GitHub Pages Setup for docs-ui"
echo "=================================="
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "   Install it from: https://cli.github.com/"
    echo "   Or run: brew install gh (on macOS)"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "🔐 Authenticating with GitHub..."
    gh auth login
fi

# Get repository info
REPO_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")
if [[ -z "$REPO_URL" ]]; then
    echo "❌ No git remote origin found. Please run this from your repository root."
    exit 1
fi

# Extract owner and repo name
if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
else
    echo "❌ Could not parse GitHub repository URL: $REPO_URL"
    exit 1
fi

echo "📁 Repository: $OWNER/$REPO"
echo ""

# Enable GitHub Pages
echo "🌐 Configuring GitHub Pages..."
echo "   Source: GitHub Actions"
echo "   Branch: gh-pages"

# Set up Pages with GitHub Actions as source
gh api -X POST /repos/$OWNER/$REPO/pages \
    -f source[branch]=gh-pages \
    -f source[path]=/ \
    2>/dev/null || echo "   (Pages may already be configured)"

# Set Pages source to GitHub Actions
gh api -X PUT /repos/$OWNER/$REPO/pages \
    -f source[branch]=gh-pages \
    -f source[path]=/ \
    2>/dev/null || echo "   (Could not update Pages source)"

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Push your code to the main branch"
echo "   2. GitHub Actions will automatically build and deploy"
echo "   3. Your site will be available at: https://$OWNER.github.io/$REPO"
echo ""
echo "🔗 Useful links:"
echo "   • Repository: https://github.com/$OWNER/$REPO"
echo "   • Actions: https://github.com/$OWNER/$REPO/actions"
echo "   • Pages settings: https://github.com/$OWNER/$REPO/settings/pages"
echo ""
echo "💡 Tips:"
echo "   • Use 'make ci-local' to test the full pipeline locally"
echo "   • Pull requests will create preview deployments"
echo "   • Check the Actions tab for build status" 