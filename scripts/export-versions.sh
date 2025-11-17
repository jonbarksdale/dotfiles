#!/usr/bin/env bash
# ABOUTME: Export current state of all version managers (SDKMAN!, Volta, uv) to
# ABOUTME: files for reference during migration to a new computer.

set -e

OUTPUT_DIR="${1:-$HOME}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "Exporting version manager state to ${OUTPUT_DIR}..."
echo

# Create output directory if needed
mkdir -p "$OUTPUT_DIR"

# SDKMAN! state
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    echo "📦 Exporting SDKMAN! state..."
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    {
        echo "# SDKMAN! Version Manager State"
        echo "# Exported: $(date)"
        echo "# Host: $(hostname)"
        echo
        echo "## Current Versions"
        sdk current
        echo
        echo "## Installed Java Versions"
        sdk list java | grep installed || echo "No Java versions installed"
        echo
        echo "## Installed Gradle Versions"
        sdk list gradle | grep installed || echo "No Gradle versions installed"
        echo
        echo "## Installed Maven Versions"
        sdk list maven | grep installed || echo "No Maven versions installed"
        echo
        echo "## All Installed Candidates"
        ls -la ~/.sdkman/candidates/ | grep '^d' | awk '{print $NF}' | grep -v '^\.' | while read -r candidate; do
            echo "### $candidate"
            ls ~/.sdkman/candidates/$candidate/ | grep -v current
        done
    } > "${OUTPUT_DIR}/migration-sdkman-${TIMESTAMP}.txt"

    echo "   ✓ Saved to migration-sdkman-${TIMESTAMP}.txt"
else
    echo "   ⚠ SDKMAN! not found"
fi

# Volta state
if command -v volta &> /dev/null; then
    echo "📦 Exporting Volta state..."

    {
        echo "# Volta Version Manager State"
        echo "# Exported: $(date)"
        echo "# Host: $(hostname)"
        echo
        echo "## All Installed Node.js Versions"
        volta list all
        echo
        echo "## Current Default Versions"
        volta list
    } > "${OUTPUT_DIR}/migration-volta-${TIMESTAMP}.txt"

    echo "   ✓ Saved to migration-volta-${TIMESTAMP}.txt"
else
    echo "   ⚠ Volta not found"
fi

# uv state
if command -v uv &> /dev/null; then
    echo "📦 Exporting uv state..."

    {
        echo "# uv Python Manager State"
        echo "# Exported: $(date)"
        echo "# Host: $(hostname)"
        echo
        echo "## Installed Python Versions"
        uv python list
        echo
        echo "## Installed Tools"
        uv tool list
    } > "${OUTPUT_DIR}/migration-uv-${TIMESTAMP}.txt"

    echo "   ✓ Saved to migration-uv-${TIMESTAMP}.txt"
else
    echo "   ⚠ uv not found (will be installed on new machine)"
fi

# Homebrew packages
if command -v brew &> /dev/null; then
    echo "📦 Exporting Homebrew state..."

    {
        echo "# Homebrew Package State"
        echo "# Exported: $(date)"
        echo "# Host: $(hostname)"
        echo
        echo "## Installed Packages"
        brew list
        echo
        echo "## Installed Casks"
        brew list --cask
        echo
        echo "## Taps"
        brew tap
    } > "${OUTPUT_DIR}/migration-brew-${TIMESTAMP}.txt"

    echo "   ✓ Saved to migration-brew-${TIMESTAMP}.txt"
else
    echo "   ⚠ Homebrew not found"
fi

# Git configuration
if command -v git &> /dev/null; then
    echo "📦 Exporting Git configuration..."

    {
        echo "# Git Global Configuration"
        echo "# Exported: $(date)"
        echo "# Host: $(hostname)"
        echo "# NOTE: Sensitive data may be included - review before sharing"
        echo
        git config --global --list
    } > "${OUTPUT_DIR}/migration-git-${TIMESTAMP}.txt"

    echo "   ✓ Saved to migration-git-${TIMESTAMP}.txt"
else
    echo "   ⚠ Git not found"
fi

# SSH keys inventory
if [[ -d "$HOME/.ssh" ]]; then
    echo "📦 Inventorying SSH keys..."

    {
        echo "# SSH Keys Inventory"
        echo "# Exported: $(date)"
        echo "# Host: $(hostname)"
        echo "# NOTE: This does NOT export private keys - only lists them"
        echo
        echo "## SSH Directory Contents"
        ls -lah ~/.ssh/
        echo
        echo "## Keys Currently Loaded in Agent"
        ssh-add -l 2>/dev/null || echo "No keys in agent or agent not running"
        echo
        echo "## Public Keys"
        find ~/.ssh -name "*.pub" -exec echo "---" \; -exec echo "File: {}" \; -exec cat {} \;
    } > "${OUTPUT_DIR}/migration-ssh-inventory-${TIMESTAMP}.txt"

    echo "   ✓ Saved to migration-ssh-inventory-${TIMESTAMP}.txt"
else
    echo "   ⚠ ~/.ssh directory not found"
fi

# GPG keys inventory
if command -v gpg &> /dev/null; then
    echo "📦 Inventorying GPG keys..."

    {
        echo "# GPG Keys Inventory"
        echo "# Exported: $(date)"
        echo "# Host: $(hostname)"
        echo "# NOTE: This does NOT export private keys - only lists them"
        echo
        echo "## Secret Keys"
        gpg --list-secret-keys --keyid-format LONG
        echo
        echo "## Public Keys"
        gpg --list-keys --keyid-format LONG
    } > "${OUTPUT_DIR}/migration-gpg-inventory-${TIMESTAMP}.txt"

    echo "   ✓ Saved to migration-gpg-inventory-${TIMESTAMP}.txt"
else
    echo "   ⚠ GPG not found"
fi

echo
echo "✅ Export complete!"
echo
echo "Files created in ${OUTPUT_DIR}:"
ls -lh "${OUTPUT_DIR}"/migration-*-${TIMESTAMP}.txt 2>/dev/null || echo "   (no files created)"
echo
echo "💡 Next steps:"
echo "   1. Review the exported files"
echo "   2. Store them securely (they may contain sensitive information)"
echo "   3. Use these files as reference when setting up your new computer"
echo "   4. Follow PRE_MIGRATION_CHECKLIST.md for additional backup steps"
echo
