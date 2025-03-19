#!/bin/bash

# Get the project root directory
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh

generate_banner "RUNNING CONFIGURATION TESTS"

# Parse command line arguments
DISTRO="ubuntu"  # Default distribution to test
ALL_DISTROS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --distro=*)
            DISTRO="${1#*=}"
            shift
            ;;
        --all)
            ALL_DISTROS=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--distro=DISTRO] [--all]"
            echo "  --distro=DISTRO  Run tests for specific distribution (default: ubuntu)"
            echo "  --all            Run tests for all supported distributions"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            log "error" "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Function to run tests for a specific distribution
run_distro_test() {
    local distro=$1
    local test_script="$PROJECT_ROOT/tests/integration/$distro/integration_test.sh"
    
    if [ -f "$test_script" ]; then
        log "Running tests for $distro..."
        bash "$test_script"
        return $?
    else
        log "error" "No test script found for $distro"
        return 1
    fi
}

# Run tests based on command line arguments
if [ "$ALL_DISTROS" = true ]; then
    # Find all directories in tests/integration/ and run their integration_test.sh
    success=true
    for distro_dir in "$PROJECT_ROOT"/tests/integration/*/; do
        distro=$(basename "$distro_dir")
        if [ -f "$distro_dir/integration_test.sh" ]; then
            log "Testing $distro distribution..."
            if ! run_distro_test "$distro"; then
                success=false
                log "error" "Tests for $distro failed"
            fi
        fi
    done
    
    if [ "$success" = true ]; then
        log "All tests completed successfully"
        exit 0
    else
        log "error" "Some tests failed"
        exit 1
    fi
else
    # Run tests for the specified distribution
    if run_distro_test "$DISTRO"; then
        log "Tests for $DISTRO completed successfully"
        exit 0
    else
        log "error" "Tests for $DISTRO failed"
        exit 1
    fi
fi 