#!/bin/bash
set -euo pipefail

# Test common.sh functions

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

source "$PROJECT_ROOT/lib/init.sh"
source "$PROJECT_ROOT/lib/common.sh"
source "$SCRIPT_DIR/test-lib.sh"

echo "Testing common.sh functions..."
echo ""

# Test backup_file (creates backup of an existing file)
TEST_FILE="$HOME/.better-ops-test-$$"
echo "test" > "$TEST_FILE"
backup_file ".better-ops-test-$$"
assert_success "backup_file creates backup for existing file" test -f "${TEST_FILE}.better-ops-backup."*
rm -f "$TEST_FILE" "${TEST_FILE}.better-ops-backup."*

# Test install_file
TEST_SRC=$(mktemp)
echo "test content" > "$TEST_SRC"
install_file "$TEST_SRC" ".better-ops-test-install-$$"
assert_equals "test content" "$(cat "$HOME/.better-ops-test-install-$$")" "install_file copies file correctly"
rm -f "$TEST_SRC" "$HOME/.better-ops-test-install-$$"

# Test is_container (should return without error)
assert_success "is_container runs without error" is_container || true

print_summary
