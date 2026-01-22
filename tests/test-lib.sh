#!/bin/bash
set -euo pipefail

# Simple test framework for better-ops

TEST_COUNT=0
TEST_PASSED=0
TEST_FAILED=0

# Assert that two values are equal
assert_equals() {
    local expected="$1"
    local actual="$2"
    local description="$3"

    ((TEST_COUNT++))

    if [ "$expected" = "$actual" ]; then
        ((TEST_PASSED++))
        echo "✓ $description"
    else
        ((TEST_FAILED++))
        echo "✗ $description"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
    fi
}

# Assert that a command succeeds
assert_success() {
    local description="$1"
    shift

    ((TEST_COUNT++))

    if "$@" >/dev/null 2>&1; then
        ((TEST_PASSED++))
        echo "✓ $description"
    else
        ((TEST_FAILED++))
        echo "✗ $description"
        echo "  Command failed: $*"
    fi
}

# Assert that a command fails
assert_failure() {
    local description="$1"
    shift

    ((TEST_COUNT++))

    if ! "$@" >/dev/null 2>&1; then
        ((TEST_PASSED++))
        echo "✓ $description"
    else
        ((TEST_FAILED++))
        echo "✗ $description"
        echo "  Command should have failed: $*"
    fi
}

# Assert that a string contains a substring
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local description="$3"

    ((TEST_COUNT++))

    if [[ "$haystack" == *"$needle"* ]]; then
        ((TEST_PASSED++))
        echo "✓ $description"
    else
        ((TEST_FAILED++))
        echo "✗ $description"
        echo "  Expected to contain: $needle"
        echo "  Actual: $haystack"
    fi
}

# Print test summary and return appropriate exit code
print_summary() {
    echo ""
    echo "================================"
    echo "Tests: $TEST_COUNT | Passed: $TEST_PASSED | Failed: $TEST_FAILED"
    echo "================================"
    [ $TEST_FAILED -eq 0 ]
}
