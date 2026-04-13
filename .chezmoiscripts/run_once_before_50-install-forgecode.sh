#!/bin/bash
# ABOUTME: Installs ForgeCode CLI coding agent via curl installer
# ABOUTME: Skips installation if forge is already on PATH

set -euo pipefail

if command -v forge &> /dev/null; then
    echo "✓ ForgeCode is already installed"
    exit 0
fi

echo "Installing ForgeCode..."
curl -fsSL https://forgecode.dev/cli | sh

echo "✓ ForgeCode installed successfully"
