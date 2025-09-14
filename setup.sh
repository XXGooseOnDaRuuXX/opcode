#!/bin/bash

# Opcode Setup Script
# This script will install all dependencies and start the application

set -e  # Exit on any error

echo "🚀 Setting up Opcode..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "Please run this script from the opcode project root directory"
    exit 1
fi

# Check and install Rust if needed
print_status "Checking Rust installation..."
if ! command -v cargo &> /dev/null; then
    print_status "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    print_success "Rust installed successfully"
else
    print_success "Rust is already installed"
fi

# Check and install Bun if needed
print_status "Checking Bun installation..."
if ! command -v bun &> /dev/null; then
    print_status "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
    print_success "Bun installed successfully"
else
    print_success "Bun is already installed"
fi

# Install dependencies
print_status "Installing project dependencies..."
bun install
print_success "Dependencies installed successfully"

# Check if Claude Code CLI is installed
print_status "Checking Claude Code CLI..."
if ! command -v claude &> /dev/null; then
    print_warning "Claude Code CLI not found. You'll need to install it from https://claude.ai/code"
    print_warning "The app will still run, but some features may not work without it."
else
    print_success "Claude Code CLI is installed"
fi

print_success "Setup complete! 🎉"
echo ""
print_status "Starting the application..."
echo ""

# Start the application
bun run tauri dev
