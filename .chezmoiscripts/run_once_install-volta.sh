#!/usr/bin/env bash
# ABOUTME: Installs Volta for managing Node.js versions
# ABOUTME: Skips if volta is already installed, installs with --skip-setup flag

set -euo pipefail

# Check if Volta is already installed
if command -v volta &> /dev/null; then
    echo "✓ Volta is already installed"
    volta --version
    exit 0
fi

echo "Installing Volta..."

# Install Volta with --skip-setup to avoid modifying shell rc files
curl https://get.volta.sh | bash -s -- --skip-setup

echo "✓ Volta installed successfully"
echo "  You may need to restart your shell or add Volta to your PATH"
