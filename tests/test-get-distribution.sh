#!/bin/bash
set -euo pipefail

# Test get-distribution.sh functions

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

source "$PROJECT_ROOT/lib/get-distribution.sh"
source "$SCRIPT_DIR/test-lib.sh"

echo "Testing get-distribution.sh functions..."
echo ""

# Test get_distribution returns a non-empty value
result=$(get_distribution)
if [ -n "$result" ] && [ "$result" != "Unknown" ]; then
    ((TEST_COUNT++))
    ((TEST_PASSED++))
    echo "✓ get_distribution returns valid distribution: $result"
else
    ((TEST_COUNT++))
    ((TEST_FAILED++))
    echo "✗ get_distribution should return a valid distribution"
    echo "  Got: $result"
fi

# Test that result is one of the expected distributions
if [[ "$result" =~ ^(debian|ubuntu|centos|rhel|fedora|arch|manjaro|Unknown)$ ]]; then
    ((TEST_COUNT++))
    ((TEST_PASSED++))
    echo "✓ get_distribution returns a recognized distribution"
else
    ((TEST_COUNT++))
    ((TEST_FAILED++))
    echo "✗ get_distribution should return a recognized distribution"
    echo "  Got: $result"
fi

print_summary
