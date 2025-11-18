#!/usr/bin/env bash
# ABOUTME: Installs Claude Code CLI using the official installation script
# ABOUTME: Uses curl method to enable automatic updates

set -euo pipefail

# Check if claude is already installed
if command -v claude &> /dev/null; then
    echo "✓ Claude Code is already installed"
    claude --version
    exit 0
fi

echo "Installing Claude Code CLI..."

# Install using official script
if curl -fsSL https://claude.ai/install.sh | bash; then
    echo "✓ Claude Code installed successfully"
    echo "  You'll be prompted to authenticate on first use"
else
    echo "⚠ Claude Code installation failed"
    echo "  You can retry manually with: curl -fsSL https://claude.ai/install.sh | bash"
    exit 1
fi
