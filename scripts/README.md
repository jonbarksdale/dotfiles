# Migration Helper Scripts

ABOUTME: Helper scripts for exporting version manager state and importing it on
ABOUTME: a new computer.

## Overview

These scripts help with migrating your development environment to a new
computer by exporting and importing version manager state (SDKMAN!, Volta, uv).

## Scripts

### export-versions.sh

Exports current state of all version managers to timestamped text files.

**Usage:**

```bash
# Export to home directory (default)
./scripts/export-versions.sh

# Export to specific directory
./scripts/export-versions.sh ~/Desktop
```

**What it exports:**

- SDKMAN! state (Java, Maven, Gradle versions)
- Volta state (Node.js versions)
- uv state (Python versions and tools)
- Homebrew packages (for comparison with Brewfile)
- Git global configuration
- SSH keys inventory (lists keys, doesn't export private keys)
- GPG keys inventory (lists keys, doesn't export private keys)

**Output files:**

- `migration-sdkman-TIMESTAMP.txt`
- `migration-volta-TIMESTAMP.txt`
- `migration-uv-TIMESTAMP.txt`
- `migration-brew-TIMESTAMP.txt`
- `migration-git-TIMESTAMP.txt`
- `migration-ssh-inventory-TIMESTAMP.txt`
- `migration-gpg-inventory-TIMESTAMP.txt`

**When to run:**

Run this on your current/old computer before migrating to a new one. Follow
PRE_MIGRATION_CHECKLIST.md for the complete pre-migration process.

### install-versions.sh

Interactive helper to restore version manager state from export files.

**Usage:**

```bash
# Install from an export file
./scripts/install-versions.sh ~/migration-sdkman-20250117-143022.txt

# Or with Volta
./scripts/install-versions.sh ~/migration-volta-20250117-143022.txt

# Or with uv
./scripts/install-versions.sh ~/migration-uv-20250117-143022.txt
```

**What it does:**

- Parses the export file
- Shows what would be installed
- Prompts for confirmation
- Installs versions using the appropriate package manager

**Supported export types:**

- SDKMAN! exports (interactive - helps you install manually)
- Volta exports (automated installation)
- uv exports (automated installation)

**When to run:**

Run this on your new computer after installing dotfiles. Follow
NEW_COMPUTER_SETUP.md for the complete setup process.

## Workflow

### On Old Computer (Before Migration)

1. Follow PRE_MIGRATION_CHECKLIST.md
2. Run export-versions.sh:
   ```bash
   ./scripts/export-versions.sh
   ```
3. Review generated files in home directory
4. Transfer export files to new computer (USB drive, cloud storage, etc.)

### On New Computer (After Dotfiles Installation)

1. Install dotfiles first (see NEW_COMPUTER_SETUP.md)
2. Transfer export files from old computer
3. Use install-versions.sh to restore versions:
   ```bash
   ./scripts/install-versions.sh ~/migration-volta-*.txt
   ./scripts/install-versions.sh ~/migration-uv-*.txt
   ```
4. Complete remaining steps in NEW_COMPUTER_SETUP.md

## Notes

### SDKMAN! Special Handling

SDKMAN! versions (Java, Maven, Gradle) are not automatically installed because:

- Corporate dev has specific required versions
- Version numbers change frequently
- You need to verify current requirements

The script shows you what was installed and helps you install the correct
versions interactively.

### Security Considerations

**Export files may contain sensitive information:**

- Git configuration may include email addresses
- SSH inventory shows key fingerprints
- File paths may reveal project names

**Private keys are NEVER exported by these scripts.** You must handle SSH and
GPG private key migration separately following the security procedures in
NEW_COMPUTER_SETUP.md.

### Version Compatibility

These scripts work with:

- SDKMAN! 5.x+
- Volta 1.x+
- uv (any recent version)
- Homebrew 4.x+

## Troubleshooting

### "Command not found" errors

Ensure you've installed dotfiles first. These scripts expect version managers to
already be installed via the dotfiles installation process.

### Volta installation fails

Check that Volta is properly initialized:

```bash
volta --version
# If not found:
source ~/.zshrc
```

### uv not installed

uv is a new addition. If it's not installed:

```bash
brew install uv
```

## Related Documentation

- [PRE_MIGRATION_CHECKLIST.md](../PRE_MIGRATION_CHECKLIST.md) - Pre-migration
  tasks
- [NEW_COMPUTER_SETUP.md](../NEW_COMPUTER_SETUP.md) - Complete setup guide
- Main [README.md](../README.md) - Dotfiles overview
