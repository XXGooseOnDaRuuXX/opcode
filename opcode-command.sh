#!/bin/bash

# Global Opcode command script
# Usage: opcode [command]
# Commands: dev, build, setup, help

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the opcode directory
cd "$SCRIPT_DIR"

# If we're in a symlinked location, find the actual project directory
if [ ! -f "package.json" ]; then
    # Try to find the opcode project directory
    OPCODE_DIR="$(find "$HOME" -name "opcode" -type d -path "*/Documents/Apps/opcode" 2>/dev/null | head -1)"
    if [ -n "$OPCODE_DIR" ] && [ -f "$OPCODE_DIR/package.json" ]; then
        cd "$OPCODE_DIR"
    fi
fi

# Set up environment
export PATH="$HOME/.cargo/bin:$HOME/.bun/bin:$PATH"

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Could not find opcode project directory"
    exit 1
fi

# Function to show help
show_help() {
    echo "🚀 Opcode - GUI for Claude Code"
    echo ""
    echo "Usage: opcode [command]"
    echo ""
    echo "Commands:"
    echo "  dev     Start development server (default)"
    echo "  build   Build the application"
    echo "  setup   Run full setup (install dependencies)"
    echo "  help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  opcode        # Start development server"
    echo "  opcode dev    # Start development server"
    echo "  opcode build  # Build the application"
    echo "  opcode setup  # Run setup"
}

# Handle commands
case "${1:-dev}" in
    "dev")
        echo "🚀 Starting Opcode development server..."
        bun run tauri dev
        ;;
    "build")
        echo "🔨 Building Opcode..."
        bun run tauri build
        ;;
    "setup")
        echo "⚙️  Running Opcode setup..."
        if [ -f "./setup.sh" ]; then
            ./setup.sh
        else
            echo "Installing dependencies..."
            bun install
            echo "✅ Setup complete!"
        fi
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