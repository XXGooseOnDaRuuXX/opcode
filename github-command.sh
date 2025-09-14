#!/bin/bash

# Global GitHub command script
# Usage: github [command]
# Commands: open, pr, issues, create-pr, help

# Function to show help
show_help() {
    echo "🌐 GitHub - Quick GitHub commands"
    echo ""
    echo "Usage: github [command]"
    echo ""
    echo "Commands:"
    echo "  open        Open repository on GitHub (default)"
    echo "  pr          View pull requests"
    echo "  issues      View issues"
    echo "  create-pr   Create new pull request"
    echo "  branch      Open current branch on GitHub"
    echo "  compare     Compare branches"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  github          # Open current repo"
    echo "  github open     # Open current repo"
    echo "  github pr       # View pull requests"
    echo "  github issues   # View issues"
    echo "  github create-pr # Create new PR"
    echo "  github branch   # Open current branch"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) not installed"
    echo "Install it with: brew install gh"
    exit 1
fi

# Handle commands
case "${1:-open}" in
    "open"|"")
        echo "🌐 Opening repository on GitHub..."
        gh browse
        ;;
    "pr")
        echo "📝 Opening pull requests..."
        gh pr list --web
        ;;
    "issues")
        echo "🐛 Opening issues..."
        gh issue list --web
        ;;
    "create-pr"|"create")
        echo "➕ Creating new pull request..."
        gh pr create --web
        ;;
    "branch")
        echo "🌿 Opening current branch..."
        gh browse --branch "$(git branch --show-current)"
        ;;
    "compare")
        echo "🔄 Comparing branches..."
        current_branch=$(git branch --show-current)
        echo "Current branch: $current_branch"
        gh browse --compare "$current_branch"
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
