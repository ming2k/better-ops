#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/init.sh"
fi

source "$PROJECT_ROOT/lib/common.sh"
source "$PROJECT_ROOT/lib/install-package.sh"

generate_banner "EXEC PREFLIGHT CHECK"

# Check that basic required commands are available
require_command git rsync
