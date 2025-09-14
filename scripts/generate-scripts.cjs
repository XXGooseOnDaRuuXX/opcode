#!/usr/bin/env node

/**
 * Script Generator for Opcode
 * Generates user-specific scripts from templates
 */

const fs = require("fs");
const path = require("path");
const os = require("os");

// Configuration
const CONFIG = {
  templatesDir: path.join(__dirname, "templates"),
  outputDir: path.join(__dirname, "generated"),
  userDir: path.join(__dirname, "user"),
  projectRoot: path.resolve(__dirname, ".."),
};

// Platform detection
function detectPlatform() {
  const platform = os.platform();
  const arch = os.arch();

  return {
    platform,
    arch,
    isMac: platform === "darwin",
    isLinux: platform === "linux",
    isWindows: platform === "win32",
  };
}

// Package manager detection
function detectPackageManager() {
  if (fs.existsSync(path.join(CONFIG.projectRoot, "bun.lock"))) {
    return {
      manager: "bun",
      installCommand: "curl -fsSL https://bun.sh/install | bash",
      installPackage: "bun add",
    };
  } else if (fs.existsSync(path.join(CONFIG.projectRoot, "pnpm-lock.yaml"))) {
    return {
      manager: "pnpm",
      installCommand: "npm install -g pnpm",
      installPackage: "pnpm add",
    };
  } else {
    return {
      manager: "npm",
      installCommand: "npm install -g npm@latest",
      installPackage: "npm install",
    };
  }
}

// Generate user-specific configuration
function generateConfig() {
  const platform = detectPlatform();
  const packageManager = detectPackageManager();
  const userHome = os.homedir();

  return {
    USER_HOME: userHome,
    OPCODE_PROJECT_PATH: CONFIG.projectRoot,
    CARGO_PATH: path.join(userHome, ".cargo", "bin"),
    BUN_PATH: path.join(userHome, ".bun", "bin"),
    PACKAGE_MANAGER: packageManager.manager,
    PACKAGE_MANAGER_INSTALL: packageManager.installCommand,
    PACKAGE_MANAGER_INSTALL_COMMAND: packageManager.installCommand,
    PLATFORM: platform.platform,
    ARCH: platform.arch,
  };
}

// Template processing
function processTemplate(templatePath, config) {
  let content = fs.readFileSync(templatePath, "utf8");

  // Replace template variables
  Object.entries(config).forEach(([key, value]) => {
    const regex = new RegExp(`{{${key}}}`, "g");
    content = content.replace(regex, value);
  });

  return content;
}

// Generate scripts
function generateScripts() {
  console.log("🔧 Generating user-specific scripts...");

  // Create output directories
  if (!fs.existsSync(CONFIG.outputDir)) {
    fs.mkdirSync(CONFIG.outputDir, { recursive: true });
  }

  if (!fs.existsSync(CONFIG.userDir)) {
    fs.mkdirSync(CONFIG.userDir, { recursive: true });
  }

  const config = generateConfig();
  const templates = fs.readdirSync(CONFIG.templatesDir);

  templates.forEach((templateFile) => {
    if (templateFile.endsWith(".template")) {
      const templatePath = path.join(CONFIG.templatesDir, templateFile);
      const outputFile = templateFile.replace(".template", "");
      const outputPath = path.join(CONFIG.outputDir, outputFile);

      console.log(`  📝 Generating ${outputFile}...`);

      const content = processTemplate(templatePath, config);
      fs.writeFileSync(outputPath, content);

      // Make executable on Unix systems
      if (process.platform !== "win32") {
        fs.chmodSync(outputPath, "755");
      }
    }
  });

  console.log("✅ Scripts generated successfully!");
  console.log(`📁 Generated scripts in: ${CONFIG.outputDir}`);
  console.log(`📁 User customizations in: ${CONFIG.userDir}`);
}

// Install global commands
function installGlobalCommands() {
  console.log("🔗 Installing global commands...");

  const userHome = os.homedir();
  const localBin = path.join(userHome, ".local", "bin");

  // Create .local/bin if it doesn't exist
  if (!fs.existsSync(localBin)) {
    fs.mkdirSync(localBin, { recursive: true });
  }

  // Create symlinks for global commands
  const commands = ["opcode-command.sh"];

  commands.forEach((command) => {
    const sourcePath = path.join(CONFIG.outputDir, command);
    const targetPath = path.join(localBin, command.replace("-command.sh", ""));

    if (fs.existsSync(sourcePath)) {
      try {
        // Remove existing symlink if it exists
        if (fs.existsSync(targetPath)) {
          fs.unlinkSync(targetPath);
        }

        fs.symlinkSync(sourcePath, targetPath);
        console.log(`  ✅ Installed: ${command.replace("-command.sh", "")}`);
      } catch (error) {
        console.log(`  ⚠️  Could not install ${command}: ${error.message}`);
      }
    }
  });

  // Add to PATH if not already there
  const shellConfig = path.join(userHome, ".zshrc");
  const pathAddition = 'export PATH="$HOME/.local/bin:$PATH"';

  if (fs.existsSync(shellConfig)) {
    const content = fs.readFileSync(shellConfig, "utf8");
    if (!content.includes(pathAddition)) {
      fs.appendFileSync(shellConfig, `\n${pathAddition}\n`);
      console.log("  ✅ Added ~/.local/bin to PATH in ~/.zshrc");
    }
  }

  console.log("✅ Global commands installed!");
  console.log("🔄 Please restart your terminal or run: source ~/.zshrc");
}

// Main function
function main() {
  console.log("🚀 Opcode Script Generator");
  console.log("==========================");

  try {
    generateScripts();
    installGlobalCommands();

    console.log("\n🎉 Setup complete!");
    console.log("\n📋 Available commands:");
    console.log("  opcode          # Start development server");
    console.log("  opcode build    # Build production app");
    console.log("  opcode setup    # Run setup");
    console.log("\n📋 For GitHub commands, install the global github command:");
    console.log("  npm install -g @github/cli  # Install GitHub CLI");
    console.log("  gh browse                   # Open current repo");
    console.log("  gh pr list --web           # View pull requests");

    console.log("\n📁 Customize scripts in: scripts/user/");
    console.log("📁 Generated scripts in: scripts/generated/");
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = { generateScripts, installGlobalCommands, generateConfig };
