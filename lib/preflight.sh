#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/get-distribution.sh
source $PROJECT_ROOT/lib/install-package.sh

# Set DIST_OS if not already set
if [ -z "$DIST_OS" ]; then
    DIST_OS=$(get_distribution)
fi

generate_banner "EXEC PREFLIGHT CHECK"

install_package bash sudo
install_package build-essential rsync curl wget git man-db fuse3
