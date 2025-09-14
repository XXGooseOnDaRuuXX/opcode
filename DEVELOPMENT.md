# Development Setup Guide

This guide explains how to set up Opcode for development with user-specific scripts and global commands.

## 🚀 Quick Setup

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/getAsterisk/opcode.git
cd opcode
bun install  # or npm install / pnpm install
```

### 2. Generate User-Specific Scripts

```bash
bun run setup-scripts  # or npm run setup-scripts / pnpm run setup-scripts
```

This will:

- ✅ Detect your platform (macOS/Linux/Windows)
- ✅ Detect your package manager (bun/npm/pnpm)
- ✅ Generate user-specific scripts from templates
- ✅ Install global commands (`opcode`, `github`)
- ✅ Set up your PATH automatically

### 3. Start Development

```bash
opcode  # Start development server (works from anywhere)
```

## 📋 Available Commands

### Global Commands (after setup)

```bash
opcode          # Start development server
opcode build    # Build production app
opcode setup    # Run full setup
opcode help     # Show all commands
```

### GitHub Commands (install separately)

```bash
# Install GitHub CLI globally
npm install -g @github/cli

# Then use anywhere
gh browse                   # Open current repo on GitHub
gh pr list --web           # View pull requests
gh issue list --web        # View issues
gh pr create --web         # Create new PR
```

### Local Commands

```bash
bun run dev           # Start frontend only
bun run tauri dev     # Start full Tauri app
bun run tauri build   # Build production app
bun run setup-scripts # Regenerate user scripts
```

## 🔧 How It Works

### Template System

- **Templates**: `scripts/templates/` (committed to git)
- **Generated**: `scripts/generated/` (gitignored, user-specific)
- **Custom**: `scripts/user/` (gitignored, for user customizations)

### Auto-Detection

The script generator automatically detects:

- **Platform**: macOS, Linux, Windows
- **Package Manager**: bun, npm, pnpm
- **Paths**: Home directory, cargo path, project path
- **Shell**: zsh, bash, fish

### Global Commands

Generated scripts are symlinked to `~/.local/bin/` and added to your PATH.

## 🛠️ Customization

### Custom Scripts

1. Copy templates to `scripts/user/`
2. Modify as needed
3. Run `bun run setup-scripts` to regenerate

### Environment Variables

Templates support these variables:

- `{{USER_HOME}}` - Your home directory
- `{{OPCODE_PROJECT_PATH}}` - Path to opcode project
- `{{CARGO_PATH}}` - Rust cargo bin path
- `{{BUN_PATH}}` - Bun bin path
- `{{PACKAGE_MANAGER}}` - Detected package manager
- `{{PLATFORM}}` - Operating system

## 🐛 Troubleshooting

### Commands Not Found

```bash
# Regenerate scripts
bun run setup-scripts

# Reload shell
source ~/.zshrc  # or restart terminal
```

### Wrong Package Manager

The generator auto-detects based on lock files:

- `bun.lock` → bun
- `pnpm-lock.yaml` → pnpm
- `package-lock.json` → npm

### Platform Issues

Templates are platform-agnostic, but you can create platform-specific versions:

- `setup.sh.template` (Unix)
- `setup.bat.template` (Windows)

## 📁 Project Structure

```
opcode/
├── scripts/
│   ├── templates/           # Template files (committed)
│   │   ├── opcode-command.sh.template
│   │   ├── github-command.sh.template
│   │   └── setup.sh.template
│   ├── generated/           # Generated scripts (gitignored)
│   ├── user/               # User customizations (gitignored)
│   └── generate-scripts.js # Script generator
├── src/                    # Frontend code
├── src-tauri/             # Backend code
└── package.json           # Dependencies
```

## 🔄 Regenerating Scripts

If you need to regenerate scripts (after changing templates or environment):

```bash
bun run setup-scripts
```

This will:

- Re-detect your environment
- Regenerate all scripts
- Reinstall global commands
- Update PATH if needed

## 🎯 Best Practices

1. **Don't commit user-specific scripts** - They're gitignored for a reason
2. **Customize in `scripts/user/`** - Your changes won't be overwritten
3. **Use templates for new features** - Add to `scripts/templates/`
4. **Test on multiple platforms** - Templates should work everywhere
5. **Document new variables** - Add to this guide when adding new template variables

## 🤝 Contributing

When adding new scripts:

1. Create template in `scripts/templates/`
2. Add template variables to `generate-scripts.js`
3. Update this documentation
4. Test on your platform
5. Submit PR with template changes only (not generated scripts)
