#!/bin/bash
# ABOUTME: Installs Claude Code plugins and marketplaces
# ABOUTME: Re-runs when script content changes (e.g., adding new plugins)

set -e

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "claude CLI not found, skipping plugin installation"
    exit 0
fi

# Add marketplaces (idempotent - fails silently if already present)
claude plugin marketplace add https://github.com/steveyegge/beads 2>/dev/null || true

# Install plugins (idempotent - fails silently if already installed)
claude plugin install beads@beads-marketplace 2>/dev/null || true

echo "Claude plugins installation complete"
