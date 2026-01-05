#!/usr/bin/env bash
# ABOUTME: Removes old version manager installations after mise migration
# ABOUTME: Run after verifying mise-managed tools work correctly

set -e

echo "=== Old Version Manager Cleanup ==="
echo
echo "This will remove:"
[[ -d "$HOME/.sdkman" ]] && echo "  - ~/.sdkman ($(du -sh "$HOME/.sdkman" 2>/dev/null | cut -f1))"
[[ -d "$HOME/.volta" ]] && echo "  - ~/.volta ($(du -sh "$HOME/.volta" 2>/dev/null | cut -f1))"
echo

echo "Before proceeding, verify mise tools work:"
echo "  node --version"
echo "  java --version"
echo "  mvn --version"
echo "  gradle --version"
echo "  go version"
echo

read -p "Have you verified mise tools work correctly? (type 'yes' to confirm) " -r
echo

if [[ "$REPLY" != "yes" ]]; then
    echo "Aborted. Verify mise works first, then re-run this script."
    exit 1
fi

if [[ -d "$HOME/.sdkman" ]]; then
    echo "Removing SDKMAN! (~/.sdkman)..."
    rm -rf "$HOME/.sdkman"
    echo "  Done."
fi

if [[ -d "$HOME/.volta" ]]; then
    echo "Removing Volta (~/.volta)..."
    rm -rf "$HOME/.volta"
    echo "  Done."
fi

echo
echo "Cleanup complete."
echo
echo "Optionally remove old export files:"
echo "  rm ~/migration-sdkman-*.txt ~/migration-volta-*.txt"
