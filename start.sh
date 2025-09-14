#!/bin/bash

# Simple start script for Opcode
# Run this after initial setup

echo "🚀 Starting Opcode..."

# Make sure we have the right environment
export PATH="$HOME/.cargo/bin:$HOME/.bun/bin:$PATH"

# Start the application
bun run tauri dev
