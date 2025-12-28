#!/bin/bash

# Check if running with bash
if [ -z "$BASH_VERSION" ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[31mERROR\e[0m] This script requires bash"
    exit 1
fi

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/get-distribution.sh

# Get distribution
DIST_OS=$(get_distribution)
SCRIPT_DIR="$PROJECT_ROOT/scripts"

# Preflight check
# -------------------
. ${PROJECT_ROOT}/lib/preflight.sh

# Scripts
# ---------------------
if [ "$DIST_OS" = "debian" ]; then
    . ${PROJECT_ROOT}/lib/setup/network.sh
    . ${PROJECT_ROOT}/lib/setup/ssh.sh
    . ${PROJECT_ROOT}/lib/setup/bash.sh
    . ${PROJECT_ROOT}/lib/setup/nvim.sh
fi

if [ "$DIST_OS" = "ubuntu" ]; then
    . ${PROJECT_ROOT}/lib/setup/network.sh
    . ${PROJECT_ROOT}/lib/setup/bash.sh
    . ${PROJECT_ROOT}/lib/setup/ssh.sh
    . ${PROJECT_ROOT}/lib/setup/nvim.sh
fi
