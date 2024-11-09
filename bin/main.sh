#!/bin/bash

# check if the current shell is running bash and exit if not
if [ "$SHELL" != "/bin/bash" ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[33mWARN\e[0m] Invalid number of arguments"
    exit 1
fi

# get the parent directory of the current script
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
SCRIPT_DIR="$PROJECT_ROOT/scripts"
LIB_DIR="$PROJECT_ROOT/lib"
ASSET_DIR="$PROJECT_ROOT/assets"

# active the library
. $LIB_DIR/log.sh
. $LIB_DIR/get_distribution.sh
. $LIB_DIR/install_package.sh
. $LIB_DIR/generate_banner.sh

DIST_OS=$(get_distribution)

# exec the scripts
DEBIAN_SCRIPT_PATH="$SCRIPT_DIR/distro/debian"
if [ $DIST_OS = "debian" ]; then
    . ${DEBIAN_SCRIPT_PATH}/preflight.sh
    . ${DEBIAN_SCRIPT_PATH}/config_network.sh
    . ${DEBIAN_SCRIPT_PATH}/config_bash.sh
    . ${DEBIAN_SCRIPT_PATH}/config_ssh.sh
    . ${DEBIAN_SCRIPT_PATH}/config_nvim.sh
    . ${DEBIAN_SCRIPT_PATH}/config_docker.sh
fi

source /etc/profile
source /etc/bash.bashrc
source ~/.bash_profile
source ~/.bashrc
