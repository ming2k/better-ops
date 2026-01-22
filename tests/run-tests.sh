#!/bin/bash
set -euo pipefail

# Test runner for better-ops

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "================================"
echo "Running Better-Ops Test Suite"
echo "================================"
echo ""

TOTAL_TESTS=0
FAILED_TESTS=0

# Run all test-*.sh files in the tests directory
for test_file in "$SCRIPT_DIR"/test-*.sh; do
    # Skip test-lib.sh as it's the framework, not a test
    if [[ "$test_file" == *"test-lib.sh"* ]]; then
        continue
    fi

    echo "Running $(basename "$test_file")..."
    if bash "$test_file"; then
        echo "✓ $(basename "$test_file") passed"
    else
        echo "✗ $(basename "$test_file") failed"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    echo ""
done

echo "================================"
echo "Test Suite Summary"
echo "================================"
echo "Test files run: $TOTAL_TESTS"
echo "Test files passed: $((TOTAL_TESTS - FAILED_TESTS))"
echo "Test files failed: $FAILED_TESTS"
echo "================================"

if [ $FAILED_TESTS -eq 0 ]; then
    echo "All tests passed!"
    exit 0
else
    echo "Some tests failed!"
    exit 1
fi
