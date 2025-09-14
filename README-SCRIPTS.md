# Opcode - Quick Start Guide

A GUI application for Claude Code with easy setup and deployment scripts.

## 🚀 Quick Setup (One Time Only)

```bash
./setup.sh
```

This script will:

- Install Rust (if needed)
- Install Bun (if needed)
- Install all dependencies
- Set up global `opcode` command
- Start the application

## 📋 Available Commands

### Global Commands (Run from anywhere)

```bash
opcode          # Start development server (default)
opcode dev      # Start development server
opcode build    # Build production app
opcode setup    # Run full setup
opcode help     # Show help
```

### Local Scripts (Run from project directory)

```bash
./setup.sh      # Full setup (install everything)
./start.sh      # Quick start (after setup)
./opcode-command.sh  # Manual command script
```

## 🔧 Development Mode

**Use this for daily use and testing:**

```bash
opcode dev
# or just
opcode
```

**What it does:**

- ✅ Hot reload (changes update automatically)
- ✅ Debug mode with full error messages
- ✅ Fast compilation
- ✅ Development server on `http://localhost:1420/`
- ✅ Desktop app window opens

## 🚀 Production Mode

**Use this to create a distributable app:**

```bash
opcode build
```

**What it does:**

- ✅ Creates optimized, minified app
- ✅ Generates installable files in `src-tauri/target/release/`
- ✅ Smaller file size
- ✅ Better performance
- ✅ Ready for distribution

**Output files:**

- **macOS**: `.dmg` installer
- **Windows**: `.msi` installer
- **Linux**: `.deb`, `.rpm`, `.AppImage`

## 🎯 Daily Usage

### First Time Setup

```bash
cd /path/to/opcode
./setup.sh
```

### Daily Development

```bash
# From anywhere on your system:
opcode
```

### Building for Production

```bash
# From anywhere on your system:
opcode build
```

## 🔍 Troubleshooting

### App Not Starting?

```bash
# Check if processes are running
ps aux | grep -E "(tauri|vite|bun)"

# Kill stuck processes
pkill -f "tauri|vite|bun.*dev"

# Restart
opcode
```

### Global Command Not Working?

```bash
# Check if command exists
which opcode

# Re-run setup
./setup.sh
```

### Desktop Window Not Appearing?

- Check your dock/taskbar for "opcode" app
- Try Mission Control (F3) to see all windows
- Wait 10-30 seconds on first run
- Check browser at `http://localhost:1420/`

## 📁 Project Structure

```
opcode/
├── setup.sh              # Full setup script
├── start.sh              # Quick start script
├── opcode-command.sh     # Global command script
├── src/                  # Frontend (React + TypeScript)
├── src-tauri/            # Backend (Rust + Tauri)
└── package.json          # Dependencies
```

## 🎉 That's It!

- **Development**: `opcode` (from anywhere)
- **Production**: `opcode build` (from anywhere)
- **Setup**: `./setup.sh` (one time only)

The global `opcode` command works from any directory and automatically finds your project.
