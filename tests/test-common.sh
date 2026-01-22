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

# Test get_user_home
result=$(get_user_home "root")
assert_equals "/root" "$result" "get_user_home returns /root for root user"

result=$(get_user_home "testuser")
assert_equals "/home/testuser" "$result" "get_user_home returns /home/testuser for testuser"

# Test get_target_users
result=$(get_target_users)
assert_contains "$result" "$(whoami)" "get_target_users includes current user"

# Test validate_writable_dir with /tmp (should succeed)
assert_success "validate_writable_dir succeeds for /tmp" validate_writable_dir "/tmp" "temp directory"

# Test validate_writable_dir with non-existent directory (should fail)
assert_failure "validate_writable_dir fails for non-existent directory" validate_writable_dir "/nonexistent" "fake directory"

print_summary
