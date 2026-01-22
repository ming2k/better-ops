#!/bin/bash
set -euo pipefail

# ShellCheck linting script for better-ops

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

echo "================================"
echo "Running ShellCheck on all scripts"
echo "================================"
echo ""

# Check if shellcheck is installed
if ! command -v shellcheck &>/dev/null; then
    echo "ERROR: shellcheck is not installed"
    echo "Install with: apt-get install shellcheck (Debian/Ubuntu)"
    echo "            or: dnf install ShellCheck (Fedora/RHEL)"
    echo "            or: pacman -S shellcheck (Arch)"
    exit 1
fi

FAILED=0
TOTAL=0

# Find and check all .sh files
while IFS= read -r -d '' file; do
    ((TOTAL++))
    echo "Checking: $file"
    if shellcheck -x "$file"; then
        echo "✓ $file passed"
    else
        echo "✗ $file failed"
        ((FAILED++))
    fi
    echo ""
done < <(find "$PROJECT_ROOT" -name "*.sh" -type f -print0)

echo "================================"
echo "ShellCheck Summary"
echo "================================"
echo "Files checked: $TOTAL"
echo "Files passed: $((TOTAL - FAILED))"
echo "Files failed: $FAILED"
echo "================================"

if [ $FAILED -eq 0 ]; then
    echo "All files passed ShellCheck!"
    exit 0
else
    echo "Some files have ShellCheck warnings/errors"
    exit 1
fi
