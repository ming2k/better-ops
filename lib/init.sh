#!/bin/bash
set -euo pipefail

# Initialize project environment
# This script should be sourced at the beginning of all other scripts

if [ -z "${BETTER_OPS_PROJECT_ROOT:-}" ]; then
    if [ -n "${BASH_SOURCE[0]:-}" ]; then
        BETTER_OPS_PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")
    elif [ -n "${0:-}" ]; then
        BETTER_OPS_PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
    else
        echo "ERROR: Cannot determine PROJECT_ROOT"
        exit 1
    fi
    export BETTER_OPS_PROJECT_ROOT
fi

# Backward compatibility
PROJECT_ROOT="$BETTER_OPS_PROJECT_ROOT"

# Load user configuration if it exists
if [ -f "$HOME/.config/better-ops/better-ops.conf" ]; then
    source "$HOME/.config/better-ops/better-ops.conf"
fi
