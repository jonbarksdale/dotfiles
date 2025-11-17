#!/usr/bin/env bash
# ABOUTME: Installs SDKMAN! for managing SDK versions (Java, Kotlin, Groovy, etc.)
# ABOUTME: Skips if sdk function is already available, installs with rcupdate=false

set -euo pipefail

# Check if SDKMAN! is already installed by testing for the sdk function
# This matches the dotbot check: (( $+functions[sdk] ))
if command -v sdk &> /dev/null || [[ -n "${SDKMAN_DIR:-}" ]]; then
    echo "✓ SDKMAN! is already installed"
    exit 0
fi

echo "Installing SDKMAN!..."

# Install SDKMAN! without modifying shell rc files (we'll source it from zshrc)
curl -s "https://get.sdkman.io?rcupdate=false" | bash

echo "✓ SDKMAN! installed successfully"
echo "  You may need to restart your shell or source ~/.sdkman/bin/sdkman-init.sh"
