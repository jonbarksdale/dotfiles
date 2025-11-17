#!/usr/bin/env bash
# ABOUTME: Interactive helper script to restore version manager state on a new
# ABOUTME: computer using the exported state files from export-versions.sh.

set -e

EXPORT_FILE="${1}"

print_usage() {
  echo "Usage: $0 <export-file>"
  echo
  echo "Install versions from an export file created by export-versions.sh"
  echo
  echo "Example:"
  echo "  $0 ~/migration-sdkman-20250117-143022.txt"
  echo
  echo "This script will:"
  echo "  - Parse the export file"
  echo "  - Show you what would be installed"
  echo "  - Prompt for confirmation before installing"
  echo "  - Install versions using the appropriate package manager"
}

if [[ -z "$EXPORT_FILE" ]]; then
  print_usage
  exit 1
fi

if [[ ! -f "$EXPORT_FILE" ]]; then
  echo "Error: Export file not found: $EXPORT_FILE"
  exit 1
fi

echo "📖 Reading export file: $EXPORT_FILE"
echo

# Detect which type of export file this is
if grep -q "SDKMAN! Version Manager State" "$EXPORT_FILE"; then
  echo "Detected: SDKMAN! export file"
  echo
  echo "This script will help you install the Java/Maven/Gradle versions."
  echo "Note: You'll need to manually specify which versions to install based on"
  echo "your requirements, as versions may have changed since export."
  echo
  echo "Current state from export file:"
  echo "----------------------------------------"
  grep -A 50 "## Current Versions" "$EXPORT_FILE" | head -20
  echo "----------------------------------------"
  echo
  read -p "Open SDKMAN! interactive installer? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo "Available commands:"
    echo "  sdk list java          # List available Java versions"
    echo "  sdk install java X.Y.Z # Install a specific version"
    echo "  sdk default java X.Y.Z # Set default version"
    echo
    echo "Reference your export file for previously installed versions."
    echo "Install required versions as documented."
    echo
    exec zsh
  fi

elif grep -q "Volta Version Manager State" "$EXPORT_FILE"; then
  echo "Detected: Volta export file"
  echo
  echo "Previously installed Node.js versions:"
  echo "----------------------------------------"
  grep -A 20 "## All Installed Node.js Versions" "$EXPORT_FILE" | tail -n +3
  echo "----------------------------------------"
  echo

  # Extract version numbers
  VERSIONS=$(grep -A 20 "## All Installed Node.js Versions" "$EXPORT_FILE" |
    grep -E "v[0-9]+\.[0-9]+\.[0-9]+" |
    awk '{print $2}' |
    sort -u)

  if [[ -n "$VERSIONS" ]]; then
    echo "Found versions to install:"
    echo "$VERSIONS"
    echo
    read -p "Install these Node.js versions? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if command -v volta &>/dev/null; then
        echo "$VERSIONS" | while read -r version; do
          echo "Installing $version..."
          volta install "node@${version}"
        done
        echo
        echo "✅ Installation complete!"
        echo "Current default: $(volta list | grep default || echo 'none')"
      else
        echo "Error: volta not found. Install dotfiles first."
        exit 1
      fi
    fi
  else
    echo "No versions found in export file."
  fi

elif grep -q "uv Python Manager State" "$EXPORT_FILE"; then
  echo "Detected: uv export file"
  echo
  echo "Previously installed Python versions:"
  echo "----------------------------------------"
  grep -A 10 "## Installed Python Versions" "$EXPORT_FILE" | tail -n +3
  echo "----------------------------------------"
  echo
  echo "Previously installed tools:"
  echo "----------------------------------------"
  grep -A 20 "## Installed Tools" "$EXPORT_FILE" | tail -n +3
  echo "----------------------------------------"
  echo

  # Extract Python versions
  PYTHON_VERSIONS=$(grep -A 10 "## Installed Python Versions" "$EXPORT_FILE" |
    grep -E "cpython-[0-9]+\.[0-9]+" |
    sed 's/cpython-//' |
    awk '{print $1}')

  if [[ -n "$PYTHON_VERSIONS" ]]; then
    echo "Found Python versions:"
    echo "$PYTHON_VERSIONS"
    echo
    read -p "Install these Python versions? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if command -v uv &>/dev/null; then
        echo "$PYTHON_VERSIONS" | while read -r version; do
          echo "Installing Python $version..."
          uv python install "$version"
        done
        echo "✅ Python versions installed!"
      else
        echo "Error: uv not found. Install dotfiles first."
        exit 1
      fi
    fi
  fi

  # Extract tools
  TOOLS=$(grep -A 20 "## Installed Tools" "$EXPORT_FILE" |
    grep -v "^#" |
    grep -v "^$" |
    awk '{print $1}' |
    grep -v "Installed")

  if [[ -n "$TOOLS" ]]; then
    echo
    echo "Found tools:"
    echo "$TOOLS"
    echo
    read -p "Install these tools? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if command -v uv &>/dev/null; then
        echo "$TOOLS" | while read -r tool; do
          echo "Installing $tool..."
          uv tool install "$tool"
        done
        echo "✅ Tools installed!"
      else
        echo "Error: uv not found. Install dotfiles first."
        exit 1
      fi
    fi
  fi

else
  echo "Unknown export file format."
  echo "This script supports:"
  echo "  - migration-sdkman-*.txt"
  echo "  - migration-volta-*.txt"
  echo "  - migration-uv-*.txt"
  echo
  echo "For other export files (brew, git, ssh, gpg), refer to them manually"
  echo "or follow the steps in NEW_COMPUTER_SETUP.md"
  exit 1
fi

echo
echo "✅ Done! Review installed versions:"
if grep -q "SDKMAN!" "$EXPORT_FILE"; then
  sdk current || true
elif grep -q "Volta" "$EXPORT_FILE"; then
  volta list || true
elif grep -q "uv" "$EXPORT_FILE"; then
  uv python list || true
  uv tool list || true
fi
