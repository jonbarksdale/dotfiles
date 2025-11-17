#!/usr/bin/env bash
# ABOUTME: Upgrades all Mac App Store applications
# ABOUTME: Uses 'mas upgrade' to update all installed App Store apps

set -euo pipefail

# Check if mas is installed
if ! command -v mas &> /dev/null; then
    echo "⚠ mas (Mac App Store CLI) is not installed"
    echo "  It should be installed by Homebrew - skipping App Store upgrades"
    exit 0
fi

echo "Upgrading Mac App Store applications..."
mas upgrade

echo "✓ Mac App Store applications upgraded successfully"
