#!/bin/bash

# check if the current shell is running bash and exit if not
if [ "$SHELL" != "/bin/bash" ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[33mWARN\e[0m] Invalid number of arguments"
    exit 1
fi

source $LIB_DIR/init-path.sh
source $LIB_DIR/get-distribution.sh

# DIST_OS=$(grep "^ID=" /etc/os-release | awk -F= '{print $2}')
DIST_OS=$(get_distribution)

# Preflight check   
# ---------------------
. ${SCRIPT_DIR}/preflight.sh

# Config scripts
# ---------------------
UBUNTU_SCRIPT_PATH="$SCRIPT_DIR/ubuntu"
if [ $DIST_OS = "ubuntu" ]; then
    . ${UBUNTU_SCRIPT_PATH}/config_network.sh
    . ${UBUNTU_SCRIPT_PATH}/config_bash.sh
    . ${UBUNTU_SCRIPT_PATH}/config_ssh.sh
    . ${UBUNTU_SCRIPT_PATH}/config_nvim.sh
    . ${UBUNTU_SCRIPT_PATH}/config_docker.sh
fi
