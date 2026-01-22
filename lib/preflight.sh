#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/init.sh"
fi

source "$PROJECT_ROOT/lib/banner-generator.sh"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/get-distribution.sh"
source "$PROJECT_ROOT/lib/install-package.sh"

# Set DIST_OS if not already set
if [ -z "$DIST_OS" ]; then
    DIST_OS=$(get_distribution)
fi

generate_banner "EXEC PREFLIGHT CHECK"

install_package bash sudo
install_package build-essential rsync curl wget git man-db fuse3
