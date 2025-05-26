#!/bin/bash

# check if the current shell is running bash and exit if not
if [ "$SHELL" != "/bin/bash" ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[33mWARN\e[0m] Invalid shell: $SHELL"
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
. ${SCRIPT_DIR}/preflight.sh

# Scripts
# ---------------------
if [ "$DIST_OS" = "debian" ]; then
    . ${SCRIPT_DIR}/setup/network.sh
    . ${SCRIPT_DIR}/setup/ssh.sh
    . ${SCRIPT_DIR}/setup/bash.sh
    . ${SCRIPT_DIR}/setup/nvim.sh
fi

if [ "$DIST_OS" = "ubuntu" ]; then
    . ${SCRIPT_DIR}/setup/network.sh
    . ${SCRIPT_DIR}/setup/bash.sh
    . ${SCRIPT_DIR}/setup/ssh.sh
    . ${SCRIPT_DIR}/setup/nvim.sh
    . ${SCRIPT_DIR}/setup/docker-on-ubuntu.sh
fi
