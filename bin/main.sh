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
# ---------------------
. ${SCRIPT_DIR}/preflight.sh

# Scripts
# ---------------------

# Script paths to compose a pool of scripts
COMMON_SCRIPT_PATH="$SCRIPT_DIR/common"
UBUNTU_SCRIPT_PATH="$SCRIPT_DIR/ubuntu"
DEBIAN_SCRIPT_PATH="$SCRIPT_DIR/debian"

if [ "$DIST_OS" = "debian" ]; then
    . ${COMMON_SCRIPT_PATH}/setup-network.sh
    . ${COMMON_SCRIPT_PATH}/setup-ssh.sh
    . ${COMMON_SCRIPT_PATH}/setup-bash.sh
    . ${COMMON_SCRIPT_PATH}/setup-nvim.sh
fi

if [ "$DIST_OS" = "ubuntu" ]; then
    . ${COMMON_SCRIPT_PATH}/setup-network.sh
    . ${COMMON_SCRIPT_PATH}/setup-bash.sh
    . ${COMMON_SCRIPT_PATH}/setup-ssh.sh
    . ${COMMON_SCRIPT_PATH}/setup-nvim.sh
    # . ${UBUNTU_SCRIPT_PATH}/setup-docker.sh
fi
